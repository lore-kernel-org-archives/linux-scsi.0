From: Rajat Jain <rajatja@google.com>
Subject: [PATCH RESEND] Documentation/scsi: Documentation about scsi_cmnd lifecycle
Date: Tue,  9 Jun 2015 10:43:49 -0700
Message-ID: <1433871829-10459-1-git-send-email-rajatja@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Cc: rajatxjain@gmail.com, linux-kernel@vger.kernel.org, Rajat Jain <rajatja@google.com>
List-Id: linux-scsi@vger.kernel.org

Add documentation to describe the various scenarios that the scsi_cmnd
may go through in its life time in the mid level driver - aborts,
failures, retries, error handling etc. The documentation has lots of
details including examples.

Signed-off-by: Rajat Jain <rajatja@google.com>
---
Hello James / linux-scsi,

Resending the patch since it couldn't get any attention in a month. I'd
appreciate if you could please review it and provide your valuable feedback.

Thanks,

Rajat


 Documentation/scsi/life_of_a_scsi_cmnd.txt | 667 +++++++++++++++++++++++++++++
 1 file changed, 667 insertions(+)
 create mode 100644 Documentation/scsi/life_of_a_scsi_cmnd.txt

diff --git a/Documentation/scsi/life_of_a_scsi_cmnd.txt b/Documentation/scsi/life_of_a_scsi_cmnd.txt
new file mode 100644
index 0000000..b09b2a2
--- /dev/null
+++ b/Documentation/scsi/life_of_a_scsi_cmnd.txt
@@ -0,0 +1,667 @@
+                 ==================================
+                 Life of a SCSI Command (scsi_cmnd)
+                 ==================================
+
+              Rajat Jain <rajatja@google.com> on 12-May-2015
+
+(This document roughly matches the Linux kernel 4.0)
+
+This documents describes the various phases of a SCSI command (struct scsi_cmnd)
+lifecycle, as it flows though different parts of the SCSI mid level driver. It
+describes under what conditions and how a scsi_cmnd may be aborted, or retried,
+or scheduled for error handling, and how is it recovered, and in general how a
+block request is handled by the SCSI mid level driver. It goes into detail about
+what functions get called and the purpose for each one of them etc.
+
+To help explain with an example, it takes example of a scsi_cmnd that goes
+through it all - timeout, abort, error handling, retry (also results in
+CHECK_CONDITION and gets sense info). The last section traces the path taken by
+this example scsi_cmnd in its lifetime.
+
+TABLE OF CONTENTS
+
+[1] Lifecycle of a scsi_cmnd
+[2] How does a scsi_cmnd get queued to the LLD for processing?
+[3] How does a scsi_cmnd complete?
+    [3.1] Command completing via scsi_softirq_done()
+    [3.2] Command completing via scsi_times_out()$
+[4] SCSI Error Handling
+    [4.1] How did we Get here?
+    [4.2] When does Error Handling actually run?
+    [4.3] SCSI Error Handler thread
+[5] SCSI Commands can be "hijacked"
+[6] SCSI Command Aborts
+    [6.1] When would mid level try to abort a command?
+    [6.2] How SCSI command abort works?
+    [6.3] Aborts can fail too
+[7] SCSI command Retries
+    [7.1] When would mid level retry a command?
+    [7.2] Eligibility criteria for Retry
+[8] Example: Following a scsi_cmnd (that results in CHECK_CONDITION)
+    [8.1] High level view of path taken by example scsi_cmnd
+    [8.2] Actual Path taken
+[9] References
+
+1. Lifecycle of a scsi_cmnd
+   ========================
+   SCSI Mid level interfaces with the block layer just like any other block
+   driver. For each block device that SCSI ML adds to the system, it indicates
+   a bunch of functions to serve the corresponding request queue.
+
+   The following functions are relevant to the scsi_cmnd in its lifetime. Note
+   that depending on the situations, it may not go thourgh some of these
+   stages, or may have to go through some stages multiple times.
+
+   scsi_prep_fn()
+     is called by the blocklayer to prepare the request. This
+     function actually allocates a new scsi_cmnd for the request (from
+     scsi_host->cmd_pool) and sets it up. This is where a scsi_smnd is "born".
+     Note, a new scsi_cmnd is allocated only if the blk req did not already have
+     one associated with it (req->special != NULL). A req may already have a
+     scsi_cmnd if the req was tried by SCSI earlier, and it resulted in a
+     decision to retry later (and hence req was put back on the queue).
+
+   scsi_request_fn()
+     is the actual function to serve the request queue. It basically checks
+     whether the host is ready for new commands, and if so, it submits it to the
+     LLD:
+     scsi_request_fn()
+       ->scsi_dispatch_cmd()
+           ->hostt->queue_command()
+     In case a scsi_cmnd could not be queued to LLD for some reason, the req
+     is put back on the original request queue (for retry later).
+
+   scsi_softirq_done()
+     is the handler that gets called once the LLD indicates command completed.
+     scsi_done()
+       ->blk_complete_request()
+           ->causes softirq
+               ->blk_done_softirq()
+                   ->scsi_softirq_done()
+     The most important goal of this function is to determine the course of
+     further action for this req (based on the scsi_cmnd->result and sense data
+     if present), and take that course. The options could be to finish off the
+     request to block layer, requeue it to block layer, or schedule it for error
+     handling (if that is deemed necessary). This is discussed in much detail
+     later.
+
+   scsi_times_out()
+     is the function that gets called if the LLD does not respond with the
+     result of a scsi_cmnd for a long time, and a time out happens. It tries
+     to see if the situation can be fixed by LLD timeout handlers (if available)
+     or aborting the commands. If not, it schedules the commands for EH
+     (discussed at length later).
+
+   scsi_unprep_fn()
+     is the function that gets called to unprepare the request. It is supposed
+     to undo whatever scsi_prep_fn() does.
+
+2. How does a scsi_cmnd get queued to the LLD for processing?
+   ==========================================================
+   The submission part is very simple. Once the scsi_request_fn() gets called
+   for a block request and it picks up a new block request via
+   blk_peek_request(), the scsi_cmnd has already been setup and is ready to be
+   sent to the LLD:
+    scsi_request_fn()
+        ->scsi_dispatch_cmd()
+              ->hostt->queue_command()
+
+3. How does a scsi_cmnd complete?
+   ==============================
+   Once a scsi_cmnd is submitted to the LLD, there are only 2 ways it can get
+   completed:
+
+   a. Either the LLD responds in time.
+      (i.e. resulting in scsi_softirq_done() for the command)
+
+   b. Or, the LLD does not respond in time and a timeout out occurred
+      (i.e. resulting in scsi_times_out() for the command)
+
+   We discuss both these cases below.
+
+   Note 1: There may be scsi_cmnd(s) that are re-tried. But completion of a
+      re-tried scsi_cmnd is not any different than the completion of a new
+      scsi_cmnd. Thus irrespective of retries, the scsi_cmnds will always end up
+      in using one of the above 2 scenarios.
+
+   Note 2: A scsi_cmnd may be "highjacked" during error handling in
+      scsi_send_eh_cmnd(), to send one of the EH commands (TUR / STU /
+      REQUEST_SENSE). However, the completion of these EH commands does not land up
+      in the above two scenarios. This is the only exception. Once the scsi_cmnd is
+      "un-hijacked", the result of this original scsi_cmnd will still go through
+      the same 2 scenarios.
+
+3.1 Command completing via scsi_softirq_done()
+    ==========================================
+    This is the case when the LLD responded in time i.e. completed the command.
+    Note that here "completed" does not mean that the command was successfully
+    completed. In fact it could have been the case, that the SCSI host hardware
+    may have failed without even accepting the command. However, the fact that
+    scsi_softir_done() was called, indicates that there is a "result" available
+    in a timely fashion. And we'll have to examine this result in order to
+    decide the next course of action.
+
+    scsi_softirq_done()
+    |
+    +---> scsi_decide_disposition()
+    |      Takes a look at the scsi_cmnd->result and sense data to determine
+    |      what is the best course of action to take. While reading this
+    |      function code, one should not confuse SUCCESS as meaning the command
+    |      was successful, or FAILED to mean the command failed etc. The return
+    |      value of this function merely indicates the course of action to take
+    |
+    +---> case SUCCESS:
+    |      (Finish off the command to block layer. For e.g, the device may be
+    |      offline, and hence complete the command - the block layer may retry
+    |      on its own later, but that doesn't concern the SCSI ML)
+    |      |
+    |      +---> scsi_finish_command()
+    |            |
+    |            +---> scsi_io_completion() (*see note below)
+    |                  |
+    |                  +---> blk_finish_request()
+    |
+    +---> case RETRY/ADD_TO_MLQUEUE:
+    |     (Requeue the command to request queue. For e.g. the device HW was
+    |      busy, and thus SCSI ML knows that retrying may help)
+    |      |
+    |      +---> scsi_queue_insert()
+    |            |
+    |            +---> blk_requeue_request()
+    |
+    +---> case FAILED/default:
+          (Schedule the scsi_cmnd for EH. For e.g. there was a bus error that
+          might need bus reset. Or we got CHECK_CONDITION and we need to issue
+          REQ_SENSE to get more info about the failure. etc)
+          |
+          +---> scsi_eh_scmd_add()
+                Add scsi_cmnd to the host EH queue
+                    scsi_eh_wakeup()
+
+    Note 3:
+       The scsi_io_completion() has a secondary logic similar to
+       scsi_decide_disposition() in that it also looks at result and sense data
+       and figures out what to do with request. It makes similar choices on the
+       course of action to take. There is a special case in this function that
+       involves "unprepping" a scsi_cmnd before requeuing it, and we'll discuss
+       it in sections below.
+
+3.2 Command completing via scsi_times_out()
+    =======================================
+    This happens when the LLD does not repond in time, the block layer times
+    out, and as a result calls the timeout function for the request queue for
+    the SCSI device in question.
+
+    scsi_times_out()
+    |
+    +---> scsi_transport_template->eh_timed_out() - Successful? If not...
+    |     (Gives transportt a chance to deal with it)
+    |
+    +---> scsi_host_template->eh_timed_out() - Successful? If not...
+    |     (Gives hostt a chance to deal with it)
+    |
+    +---> scsi_abort_command() - Successful? If not...
+    |     (Schedule an ABORT of the scsi_cmnd. The abort handler will also
+    |      requeue it if needed)
+    |
+    +---> scsi_eh_scmd_add()
+          (Schedule the scsi_cmnd for EH. This'll definitely work. Because if it
+           doesn't work, the EH handler will mark the device as offline, which
+           counts as a good fix :-))
+
+4. SCSI Error Handling
+   ===================
+
+   SCSI Error handling should be thought of the action the mid level decides to
+   take when it knows that merely retrying a request may not help, and it needs
+   to do something else (possibly disruptive) in order to fix the issue. For
+   e.g. a stalled host may require a host reset, and only after that a retry of
+   the request may complete.
+
+   Note 4:
+      (Random thoughts): Contrast the "Error Handling" with "Retries". A Retry
+      is a normal thing to do, when the mid level believes that it has seen an
+      error which is transient in nature, and will go away on its own without
+      explicitly doing anything. Thus a retry of a request again makes sense in
+      this case. (On the other hand a cmnd is scheduled for EH, when it knows
+      that it needs to do "something" before a retrying a cmnd can give good
+      results).
+
+   Note 5:
+      The SCSI mid level maintains a (per-host) list of all the scsi_cmnd(s)
+      that have been scheduled for EH at that host using scsi_host->eh_cmd_q.
+      This is the list that gets processed by the EH thread, when it runs.
+
+4.1 How did we Get here?
+    --------------------
+
+    A scsi_cmnd could be marked for EH in the following cases:
+
+    * The command "error completed" i.e. scsi_decide_disposition() returned
+      FAILED or something that indicates a failure that requires some sort of
+      error recovery. E.g. device hardware failed, or we have a CHECK_CONDITION.
+      scsi_softirq_done()
+        ->scsi_decide_disposition = FAILED
+            ->scsi_eh_scmd_add()
+
+    * A scsi_cmnd timed out, and attempt to abort it fails.
+      scsi_times_out()
+        ->scsi_abort_command() != SUCCESS
+            ->scsi_eh_scmd_add()
+
+4.2 When does Error Handling actually run?
+    -------------------------------------
+
+    A SCSI error handler thread is scheduled whenever there is a scsi_smnd that
+    is marked for EH (inserted in the Scsi_Host->eh_cmd_q). Once a scsi_cmnd is
+    marked for EH, the ML does not accept any more scsi_cmnds for that
+    particular Scsi_Host. However, the EH thread does not actually run until all
+    the pending IOs to the LLD for that particular Scsi_Host have either
+    completed or failed. In other words, the only commands pending at the LLD
+    for that host are the ones that need EH (host_busy == host_failed).
+
+    The idea is to quiesce the bus, so that EH thread can recover the devices,
+    as it may require to reset different components in order to do its job.
+
+4.3 SCSI Error Handler thread
+    -------------------------
+
+    scsi_error_handler()
+    |
+    +---> transportt->eh_strategy_handler() if exists, else...
+    |     (Use transportt's own error recovery handler, if available)
+    |
+    +---> scsi_unjam_host()
+    |     (The SCSI ML error handler described below. Also described in
+    |      Documentation/scsi/scsi_eh.txt. Basic goal is to do whatever
+    |      needs to recover from the current error condition. And requeue the
+    |      eligible commands after recovery)
+    |
+    +---> scsi_restart_operations()
+          (Restart the operations of the SCSI request queue)
+          |
+          +---> scsi_run_host_queues()
+                |
+                +---> scsi_run_queue()
+                      |
+                      +---> blk_run_queue()
+
+    scsi_unjam_host()
+    -----------------
+    The idea is to create 2 lists: work_q, done_q.
+    Initially, work_q = <All EH scsi cmds>, done_q = NULL
+    And then error handle all the requests in work_q by taking sequentially
+    higher severity action items that may recover the cmnd or device. Keep
+    moving the requests from work_q to done_q and in the end finish them all
+    in one go rather than individually finishing them up.
+
+    scsi_unjam_host()
+    |
+    +--> Create 2 lists: work_q, done_q
+    |    work_q = <All EH scsi cmds>, done_q = NULL
+    |
+    +--> scsi_eh_get_sense() - Are we done? if not...
+    |   (For the commands that have CHECK_CONDITION, get sense_info)
+    |    |
+    |    +--> scsi_request_sense()
+    |    |   (Use scsi_send_eh_cmnd() to send a "hijacked" REQ_SENSE cmnd)
+    |    |
+    |    +--> scsi_decide_disposition()
+    |    |
+    |    +--> Arrange to finish the scsi_cmnd if SUCCESS (by setting
+    |         retries=allowed)
+    |
+    +--> scsi_eh_abort_cmds() - Are we done? If not...
+    |   (Abort the commands that had timed out)
+    |    |
+    |    +--> scsi_try_to_abort_cmd()
+    |    |    (Results in call to hostt->eh_abort_handler() which is responsible
+    |    |     making the LLD and the HW forget about the scsi_cmnd)
+    |    |
+    |    +--> scsi_eh_test_devices()
+    |         (Test if the device is responding now by sending appropriate EH
+    |          commands (STU / TEST_UNIT_READY). Again, sending these EH
+    |          commands involves highjacking the original scsi_cmnd, and later
+    |          restoring the context)
+    |
+    +--> scsi_eh_ready_devs() - Are we done? if not...
+    |   (Take increasing order of higher severity actions in order to recover)
+    |    |
+    |    +--> scsi_eh_bus_device_reset()
+    |    |   (Reset the scsi_device. Results in call to
+    |    |    hostt->eh_device_reset_handler())
+    |    |
+    |    +--> scsi_eh_target_reset()
+    |    |   (Reset the scsi_target. Results in call to
+    |    |    hostt->eh_target_reset_handler())
+    |    |
+    |    +--> scsi_eh_bus_reset()
+    |    |   (Reset the scsi_device. Results in call to
+    |    |    hostt->eh_bus_reset_handler())
+    |    |
+    |    +--> scsi_eh_host_reset()
+    |    |   (Reset the Scsi_Host. Results in call to
+    |    |    hostt->eh_host_reset_handler())
+    |    |
+    |    +--> If nothing has worked - scsi_eh_offline_sdevs()
+    |         (The device is not recoverable, put it offline)
+    |
+    +--> scsi_eh_flush_done_q()
+        (For all the EH commands on the done_q, either requeue them (via
+         scsi_queue_insert()) if eligible, or finish them up to block layer
+         (via scsi_finish_command())
+
+   Note 6:
+      At each recovery stage we test if we are done (using
+      scsi_eh_test_devices()), and take the next severity action only if needed.
+
+   Note 7:
+      The error handler takes care that for multiple scsi_cmnds that can be
+      recovered by resetting the same component (e.g. same scsi_device), the
+      device is reset only once.
+
+5. SCSI Commands can be "hijacked"
+   ===============================
+
+   As seen above, the EH thread may need to send some EH commands in order to
+   check the health and responsiveness of the SCSI device:
+   * TUR - Test Unit Ready
+   * STU - Start / Stop Unit
+   * REQUEST_SENSE - To get the Sense data in response to CHECK_CONDITION
+
+   However instead of allocating and setting up a new scsi_cmnd for such
+   temporary purposes, the EH thread hijacks- the current scsi_cmnd that it is
+   trying to recover, in order to send the EH commands. This whole process is
+   done in scsi_send_eh_cmnd().
+
+   The scsi_send_eh_cmnd saves a context of the current command before hijacking
+   it, replaces the scsi_done ptr with its own before dipatching it to the LLD,
+   and restores the context later once it is done. The EH commands sent in this
+   manner are subject to the same problems of timeouts / abort failures /
+   completions - but they do not take the route taken by normal commands (i.e.
+   don't take the scsi_softirq_done() or scsi_times_out() route). Every
+   thing is handled within scsi_send_eh_cmnd(). This is discussed in following
+   sections.
+
+6. SCSI Command Aborts
+   ===================
+
+   It refers to the scenario where the SCSI mid level wants to have the LLD
+   driver and the hardware below it forget everything about a scsi_cmnd that
+   was given to the LLD earlier. The most common reason is that the LLD failed
+   to respond in time.
+
+6.1 When would mid level try to abort a command?
+    --------------------------------------------
+    The SCSI ML may try to abort a scsi_cmnd in the following conditions:
+
+    1. SCSI mid layer times out on a command, and tried to abort it.
+       scsi_times_out()
+         -> scsi_abort_command()
+        What happens if this abort fails? Schedule the command for EH.
+
+    2. The EH thread tried to abort all the pending commands while trying to
+       unjam a host.
+       scsi_unjam_host()
+         -> scsi_eh_abort_cmds()
+
+       What happens if this abort fails? We move to higher severity recovery
+       steps (start resetting HW components etc) because that is likely to cause
+       both LLD and the HW forget aout those commands.
+
+    3. This is a nasty one. During error recovery, the EH thread may "hijack"
+       a scsi_cmnd to send a EH command (TUR/STU/REQ_SENSE) to LLD using
+       scsi_send_eh_cmnd(). If such a "hijacked" EH command times out, the SCSI
+       EH thread will try to abort it.
+       scsi_send_eh_cmnd()
+         -> scsi_abort_eh_cmnd()
+              -> scsi_try_to_abort_cmd()
+
+       What happens if this abort fails? Similar to the previous case, the
+       scsi_abort_eh_cmnd() will try to take higher severity actions (reset bus
+       etc) but will not send EH commands such as TUR etc again in order to
+       verify if the devices started to respond.
+
+6.2 How SCSI command abort works?
+    -----------------------------
+    Unlike EH command like TUR, the ABORT is not a SCSI command that mid layer
+    driver sends to LLD. The LLD provides an eh_abort_handler() function
+    pointer that is used to abort the command. It is up to the LLD to do
+    whatever is needed to abort the command. It may require to send some
+    proprietary command to the HW, or fiddle some bits, or do whatever magic
+    is necessary.
+
+6.3 Aborts can fail too
+    --------------------
+
+    As with other things, abort attempts can also fail. The SCSI mid layer does
+    the right thing in such situations as depicted in the section above.
+
+    Note 8:
+       Once a block layer hands off a command to the SCSI subsystem, there is no
+       way currently for the block layer to cancel / abort a request. This needs
+       some work.
+
+7. SCSI command Retries
+   ====================
+
+   The SCSI mid level maintains no queues for the SCSI commands it is processing
+   (other than the EH command queue). Thus whenever the SCSI ML thinks it needs
+   to retry a command, it requeues the request back to the corresponding request
+   queue, so that the retries will be made "naturally" when the request function
+   picks up the next request for processing.
+
+   When requing such requests back to the request queue, they are put at the
+   head so that they go before the other (existing) requests in that request
+   queue.
+
+7.1 When would mid level retry a command?
+    -------------------------------------
+
+    Following are the conditions that will cause a SCSI command to be retried
+    (by putting the blk request back at the request queue):
+
+    1. Mid layer times out on a scsi_cmnd, aborts it successfully, and requeues
+       it.
+       scsi_times_out()
+         -> scsi_abort_command()
+              -> schedules scmd_eh_abort_handler()
+                   -> scsi_queue_insert()
+                        -> blk_requeue_request()
+
+    2. EH thread, after recovering a host, requeues back all the scsi_cmnds that
+       are eligible for a retry:
+       scsi_error_handler()
+         -> scsi_unjam_host()
+              -> scsi_eh_flush_done_q()
+                   -> scsi_queue_insert()
+                        -> blk_requeue_request()
+
+    3. LLD completes the scsi_cmnd, and scsi_decide_disposition() looks at the
+       scsi_cmnd->result and thinks it needs to be retried (For e.g. because the
+       bus was busy).
+       scsi_softirq_done()
+         -> scsi_decide_disposition() returns NEEDS_RETRY
+              -> scsi_queue_insert()
+                   -> blk_requeue_request()
+
+    4. In the scsi_request_fn(), the SCSI ML finds out that the host is busy and
+       the scsi_cmnd could not be sent to the LLD, hence it requeues the req
+       back on the queue.
+       scsi_request_fn()
+         -> case note_ready:
+              -> blk_requeue_request()
+
+    5. scsi_finish_command() that is called from a variety of places to finish
+       off a request to the block level. However, it calls scsi_io_completion()
+       that may look at the request and decide to retry it (if it qualifies).
+       scsi_finish_command()
+         -> scsi_io_completion()
+              -> __scsi_queue_insert()
+                   -> blk_requeue_request()
+
+    Note 9:
+       The case 5 above has a very special case. There may be some cases where
+       the scsi_io_completion() decides that a blk request has to be retried,
+       however the scsi_cmnd for this req should be relased and instead a new
+       scsi_cmnd should be allocated and used for this request at the next
+       retry. This can be the case for e.g. if it sees an ILLEGAL REQUEST as a
+       response to a READ10 command, and thinks that it may be because the
+       device supports only READ6. Thus it may make sense to switch to READ6
+       (hence a new scsi_cmnd) at the time of next retry.
+
+7.2 Eligibility criteria for Retry
+    ------------------------------
+
+    Note that SCSI mid level always checks for retry eligibility before it goes
+    ahead and requeues the command for retries. The eligibility criteria for a
+    scsi_cmnd includes (some of these may not apply in all situations described
+    above):
+
+    * retries < allowed (Num of retries should be less than allowed retries)
+    * no more than host->eh_deadline jiffies spent in EH.
+    * scsi_noretry_cmd() should return 0 for the command.
+    * scsi_device must be online
+    * req->timeout must not have expired
+    * etc.
+
+8. Example: Following a scsi_cmnd
+   ==============================
+
+8.1 High level view of path taken by example scsi_cmnd
+    --------------------------------------------------
+    We take the example of a block request that for example wants to read a
+    block off a scsi disk, how ever the LBA address is out of range for the
+    current device (hypothetically). The ML submits it to LLD, but the HW takes
+    the command and chokes on it (again hypothetically to trace through the
+    abort sequence). So the timeout happens and the ML aborts the
+    command, and requeues it. In the next run, the LLD completes the command
+    with CHECK_CONDITION.  We assume that the SCSI host does not automatically
+    get the sense info. The ML schedules the cmnd for EH. The EH thread sends
+    the REQUEST_SENSE to get sense info ILLEGAL_REQUEST, and based on it
+    completes the request to the block layer.
+
+8.2 Actual Path taken
+    -----------------
+
+    Dispatched:
+
+    scsi_request_fn()
+    |
+    +---> blk_peek_request()
+    |     |
+    |     +---> scsi_prep_fn()
+    |           (Allocate and setup scsi_cmnd)
+    |
+    +---> scsi_dispatch_cmd()
+          |
+          +---> hostt->queue_command()
+
+    Times out:
+
+    scsi_times_out()
+    |
+    +---> scsi_abort_command() - returns SUCCESS
+          |
+          +---> queue_delayed_work(abort_work)
+
+    Abort Handler:
+
+    scmd_eh_abort_handler()
+    |
+    +---> scsi_try_to_abort_cmd() - returns SUCCESS
+    |     |
+    |     +---> hostt->eh_abort_handler()
+    |
+    +---> scsi_queue_insert()
+          |
+          +---> __scsi_queue_insert()
+                |
+                +---> blk_requeue_request()
+                      (the req is requeued, with req->special pointing
+                       to scsi_cmnd)
+
+    Request picked up again:
+
+    scsi_request_fn()
+    |
+    +---> blk_peek_request()
+    |     (req->cmd_flags has REQ_DONTPREP set, so does not call
+    |      scsi_prep_fn() again)
+    |
+    +---> scsi_dispatch_cmd()
+          |
+          +---> hostt->queue_command()
+
+    Command is completed with a CHECK_CONDITION:
+
+    scsi_softirq_done()
+    |
+    +---> scsi_decide_disposition()
+    |     (Sees the CHECK_CONDITION)
+    |     |
+    |     +---> scsi_check_sense() - returns FAILED
+    |           |
+    |           +---> scsi_command_normalize_sense()
+    |                 (Fails to find a valid sense data)
+    |
+    +---> case FAILED:
+          |
+          +---> scsi_eh_scmd_add()
+                Add scsi_cmnd to the host EH queue
+                |
+                +---> scsi_eh_wakeup()
+
+    The SCSI Error handler thread runs to get the sense info, and completes the
+    request once it is done.
+
+    scsi_error_handler()
+    |
+    +---> scsi_unjam_host()
+          |
+          +---> scsi_eh_get_sense()
+          |     |
+          |     +---> scsi_request_sense()
+          |     |     |
+          |     |     +---> scsi_send_eh_cmnd()
+          |     |          (Highjacks the smnd to send EH command)
+          |     |           |
+          |     |           +--> scsi_eh_prep_cmnd()
+          |     |           |    (save context of the existing scsi_cmndi,
+          |     |           |    allocates a sense buffer, and sets up the
+          |     |           |    scsi_cmnd for REQUEST_SENSE)
+          |     |           |
+          |     |           +--> hostt->queuecommand(), and then wait...
+          |     |           |    (gets the sense data for the cmnd)
+          |     |           |
+          |     |           +--> scsi_eh_completed_normally() - returns SUCCESS
+          |     |           |
+          |     |           +--> scsi_eh_restore_cmnd()
+          |     |                (restores the context of original scsi_cmnd)
+          |     |
+          |     +---> scsi_decide_disposition() - returns SUCCESS
+          |     |      (This time can see the sense info)
+          |     |
+          |     +---> Set scmd->retries = scmd->allowed (to avoid retries)
+          |     |
+          |     +---> scsi_eh_finish_cmd()
+          |           (Puts the scsi_cmnd on the done_q)
+          |
+          +---> scsi_eh_flush_done_q()
+                (Sees that scsi_cmnd is not eligible for retries)
+                |
+                +---> scsi_finish_command()
+                      |
+                      +---> scsi_io_completion()
+                            |
+                            +---> scsi_end_request()
+                                  |
+                                  +---> scsi_put_command()
+                                       (Releases the scsi_cmnd)
+
+9. References
+   ==========
+   The following are excellent sources of references:
+   Documentation/scsi/scsi_eh.txt
+   http://events.linuxfoundation.org/sites/events/files/slides/SCSI-EH.pdf
+--
-- 
2.2.0.rc0.207.ga3a616c
