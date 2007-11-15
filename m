From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] scsi: docbook and kernel-doc updates
Date: Thu, 15 Nov 2007 15:42:30 -0800
Message-ID: <20071115154230.28295485.randy.dunlap@oracle.com>
References: <200710262318.01021.rob@landley.net>
	<20071104100252.c3e08c71.rdunlap@xenotime.net>
	<1194418040.3545.31.camel@localhost.localdomain>
	<200711081419.41759.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:61287 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349AbXKOXm7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Nov 2007 18:42:59 -0500
In-Reply-To: <200711081419.41759.rob@landley.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Rob Landley <rob@landley.net>

From: Randy Dunlap <randy.dunlap@oracle.com>

- Change title to remove "Mid-Layer" since the doc is about all of the
SCSI layers.
- Use "SCSI" instead of "scsi" in docbook text.
- Use "*/" to end kernel-doc notation blocks.
- A few other minor typo fixes.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/DocBook/scsi.tmpl   |   10 +--
 drivers/scsi/scsi.c               |    2 
 drivers/scsi/scsi_error.c         |   79 +++++++++++++---------------
 drivers/scsi/scsi_transport_srp.c |    3 -
 4 files changed, 45 insertions(+), 49 deletions(-)

--- scsi-misc-26.orig/Documentation/DocBook/scsi.tmpl
+++ scsi-misc-26/Documentation/DocBook/scsi.tmpl
@@ -4,7 +4,7 @@
 
 <book id="scsimid">
   <bookinfo>
-    <title>SCSI Mid Layer Guide</title>
+    <title>SCSI Interfaces Guide</title>
 
     <authorgroup>
       <author>
@@ -92,7 +92,7 @@
         The SCSI subsystem uses a three layer design, with upper, mid, and low
         layers.  Every operation involving the SCSI subsystem (such as reading
         a sector from a disk) uses one driver at each of the 3 levels: one
-        upper layer driver, one lower layer driver, and the scsi midlayer.
+        upper layer driver, one lower layer driver, and the SCSI midlayer.
       </para>
       <para>
         The SCSI upper layer provides the interface between userspace and the
@@ -154,7 +154,7 @@
 
       <sect2 id="scsi.c">
         <title>drivers/scsi/scsi.c</title>
-        <para>Main file for the scsi midlayer.</para>
+        <para>Main file for the SCSI midlayer.</para>
 !Edrivers/scsi/scsi.c
       </sect2>
       <sect2 id="scsicam.c">
@@ -182,7 +182,7 @@
       <sect2 id="scsi_ioctl.c">
         <title>drivers/scsi/scsi_ioctl.c</title>
         <para>
-          Handle ioctl() calls for scsi devices.
+          Handle ioctl() calls for SCSI devices.
         </para>
 !Edrivers/scsi/scsi_ioctl.c
       </sect2>
@@ -287,7 +287,7 @@
     <sect1 id="Transport_classes">
       <title>Transport classes</title>
       <para>
-        Transport classes are service libraries for drivers in the scsi
+        Transport classes are service libraries for drivers in the SCSI
         lower layer, which expose transport attributes in sysfs.
       </para>
       <sect2 id="Fibre_Channel_transport">
--- scsi-misc-26.orig/drivers/scsi/scsi.c
+++ scsi-misc-26/drivers/scsi/scsi.c
@@ -933,7 +933,7 @@ EXPORT_SYMBOL(starget_for_each_device);
  * reference.  You must hold the host's host_lock over this call and
  * any access to the returned scsi_device.
  *
- * Note:  The only reason why drivers would want to use this is because
+ * Note:  The only reason why drivers should use this is because
  * they need to access the device list in irq context.  Otherwise you
  * really want to use scsi_device_lookup_by_target instead.
  **/
--- scsi-misc-26.orig/drivers/scsi/scsi_error.c
+++ scsi-misc-26/drivers/scsi/scsi_error.c
@@ -62,7 +62,7 @@ void scsi_eh_wakeup(struct Scsi_Host *sh
  * @shost:	SCSI host to invoke error handling on.
  *
  * Schedule SCSI EH without scmd.
- **/
+ */
 void scsi_schedule_eh(struct Scsi_Host *shost)
 {
 	unsigned long flags;
@@ -86,7 +86,7 @@ EXPORT_SYMBOL_GPL(scsi_schedule_eh);
  *
  * Return value:
  *	0 on failure.
- **/
+ */
 int scsi_eh_scmd_add(struct scsi_cmnd *scmd, int eh_flag)
 {
 	struct Scsi_Host *shost = scmd->device->host;
@@ -121,7 +121,7 @@ int scsi_eh_scmd_add(struct scsi_cmnd *s
  *    This should be turned into an inline function.  Each scsi command
  *    has its own timer, and as it is added to the queue, we set up the
  *    timer.  When the command completes, we cancel the timer.
- **/
+ */
 void scsi_add_timer(struct scsi_cmnd *scmd, int timeout,
 		    void (*complete)(struct scsi_cmnd *))
 {
@@ -155,7 +155,7 @@ void scsi_add_timer(struct scsi_cmnd *sc
  * Return value:
  *     1 if we were able to detach the timer.  0 if we blew it, and the
  *     timer function has already started to run.
- **/
+ */
 int scsi_delete_timer(struct scsi_cmnd *scmd)
 {
 	int rtn;
@@ -181,7 +181,7 @@ int scsi_delete_timer(struct scsi_cmnd *
  *     only in that the normal completion handling might run, but if the
  *     normal completion function determines that the timer has already
  *     fired, then it mustn't do anything.
- **/
+ */
 void scsi_times_out(struct scsi_cmnd *scmd)
 {
 	enum scsi_eh_timer_return (* eh_timed_out)(struct scsi_cmnd *);
@@ -224,7 +224,7 @@ void scsi_times_out(struct scsi_cmnd *sc
  *
  * Return value:
  *     0 when dev was taken offline by error recovery. 1 OK to proceed.
- **/
+ */
 int scsi_block_when_processing_errors(struct scsi_device *sdev)
 {
 	int online;
@@ -245,7 +245,7 @@ EXPORT_SYMBOL(scsi_block_when_processing
  * scsi_eh_prt_fail_stats - Log info on failures.
  * @shost:	scsi host being recovered.
  * @work_q:	Queue of scsi cmds to process.
- **/
+ */
 static inline void scsi_eh_prt_fail_stats(struct Scsi_Host *shost,
 					  struct list_head *work_q)
 {
@@ -295,7 +295,7 @@ static inline void scsi_eh_prt_fail_stat
  * Notes:
  *	When a deferred error is detected the current command has
  *	not been executed and needs retrying.
- **/
+ */
 static int scsi_check_sense(struct scsi_cmnd *scmd)
 {
 	struct scsi_sense_hdr sshdr;
@@ -398,7 +398,7 @@ static int scsi_check_sense(struct scsi_
  *    queued during error recovery.  the main difference here is that we
  *    don't allow for the possibility of retries here, and we are a lot
  *    more restrictive about what we consider acceptable.
- **/
+ */
 static int scsi_eh_completed_normally(struct scsi_cmnd *scmd)
 {
 	/*
@@ -452,7 +452,7 @@ static int scsi_eh_completed_normally(st
 /**
  * scsi_eh_done - Completion function for error handling.
  * @scmd:	Cmd that is done.
- **/
+ */
 static void scsi_eh_done(struct scsi_cmnd *scmd)
 {
 	struct completion     *eh_action;
@@ -469,7 +469,7 @@ static void scsi_eh_done(struct scsi_cmn
 /**
  * scsi_try_host_reset - ask host adapter to reset itself
  * @scmd:	SCSI cmd to send hsot reset.
- **/
+ */
 static int scsi_try_host_reset(struct scsi_cmnd *scmd)
 {
 	unsigned long flags;
@@ -498,7 +498,7 @@ static int scsi_try_host_reset(struct sc
 /**
  * scsi_try_bus_reset - ask host to perform a bus reset
  * @scmd:	SCSI cmd to send bus reset.
- **/
+ */
 static int scsi_try_bus_reset(struct scsi_cmnd *scmd)
 {
 	unsigned long flags;
@@ -533,7 +533,7 @@ static int scsi_try_bus_reset(struct scs
  *    unreliable for a given host, then the host itself needs to put a
  *    timer on it, and set the host back to a consistent state prior to
  *    returning.
- **/
+ */
 static int scsi_try_bus_device_reset(struct scsi_cmnd *scmd)
 {
 	int rtn;
@@ -568,7 +568,7 @@ static int __scsi_try_to_abort_cmd(struc
  *    author of the low-level driver wishes this operation to be timed,
  *    they can provide this facility themselves.  helper functions in
  *    scsi_error.c can be supplied to make this easier to do.
- **/
+ */
 static int scsi_try_to_abort_cmd(struct scsi_cmnd *scmd)
 {
 	/*
@@ -601,7 +601,7 @@ static void scsi_abort_eh_cmnd(struct sc
  * sent must be one that does not transfer any data.  If @sense_bytes != 0
  * @cmnd is ignored and this functions sets up a REQUEST_SENSE command
  * and cmnd buffers to read @sense_bytes into @scmd->sense_buffer.
- **/
+ */
 void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
 			unsigned char *cmnd, int cmnd_size, unsigned sense_bytes)
 {
@@ -667,7 +667,7 @@ EXPORT_SYMBOL(scsi_eh_prep_cmnd);
  * @ses:        saved information from a coresponding call to scsi_prep_eh_cmnd
  *
  * Undo any damage done by above scsi_prep_eh_cmnd().
- **/
+ */
 void scsi_eh_restore_cmnd(struct scsi_cmnd* scmd, struct scsi_eh_save *ses)
 {
 	/*
@@ -697,7 +697,7 @@ EXPORT_SYMBOL(scsi_eh_restore_cmnd);
  *
  * Return value:
  *    SUCCESS or FAILED or NEEDS_RETRY
- **/
+ */
 static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 			     int cmnd_size, int timeout, unsigned sense_bytes)
 {
@@ -765,7 +765,7 @@ static int scsi_send_eh_cmnd(struct scsi
  *    Some hosts automatically obtain this information, others require
  *    that we obtain it on our own. This function will *not* return until
  *    the command either times out, or it completes.
- **/
+ */
 static int scsi_request_sense(struct scsi_cmnd *scmd)
 {
 	return scsi_send_eh_cmnd(scmd, NULL, 0, SENSE_TIMEOUT, ~0);
@@ -782,7 +782,7 @@ static int scsi_request_sense(struct scs
  *    and that would disturb what we are doing.  Thus we really want to
  *    keep a list of pending commands for final completion, and once we
  *    are ready to leave error handling we handle completion for real.
- **/
+ */
 void scsi_eh_finish_cmd(struct scsi_cmnd *scmd, struct list_head *done_q)
 {
 	scmd->device->host->host_failed--;
@@ -810,7 +810,7 @@ EXPORT_SYMBOL(scsi_eh_finish_cmd);
  *
  *    XXX: Long term this code should go away, but that needs an audit of
  *         all LLDDs first.
- **/
+ */
 int scsi_eh_get_sense(struct list_head *work_q,
 		      struct list_head *done_q)
 {
@@ -862,7 +862,7 @@ EXPORT_SYMBOL_GPL(scsi_eh_get_sense);
  *
  * Return value:
  *    0 - Device is ready. 1 - Device NOT ready.
- **/
+ */
 static int scsi_eh_tur(struct scsi_cmnd *scmd)
 {
 	static unsigned char tur_command[6] = {TEST_UNIT_READY, 0, 0, 0, 0, 0};
@@ -897,7 +897,7 @@ retry_tur:
  *    command that has timed out.  If the command simply failed, it makes
  *    no sense to try and abort the command, since as far as the shost
  *    adapter is concerned, it isn't running.
- **/
+ */
 static int scsi_eh_abort_cmds(struct list_head *work_q,
 			      struct list_head *done_q)
 {
@@ -935,7 +935,7 @@ static int scsi_eh_abort_cmds(struct lis
  *
  * Return value:
  *    0 - Device is ready. 1 - Device NOT ready.
- **/
+ */
 static int scsi_eh_try_stu(struct scsi_cmnd *scmd)
 {
 	static unsigned char stu_command[6] = {START_STOP, 0, 0, 0, 1, 0};
@@ -963,7 +963,7 @@ static int scsi_eh_try_stu(struct scsi_c
  * Notes:
  *    If commands are failing due to not ready, initializing command required,
  *	try revalidating the device, which will end up sending a start unit. 
- **/
+ */
 static int scsi_eh_stu(struct Scsi_Host *shost,
 			      struct list_head *work_q,
 			      struct list_head *done_q)
@@ -1017,7 +1017,7 @@ static int scsi_eh_stu(struct Scsi_Host 
  *    devices that are jammed or not - if we have multiple devices, it
  *    makes no sense to try bus_device_reset - we really would need to try
  *    a bus_reset instead. 
- **/
+ */
 static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
 				    struct list_head *work_q,
 				    struct list_head *done_q)
@@ -1068,7 +1068,7 @@ static int scsi_eh_bus_device_reset(stru
  * @shost:	&scsi host being recovered.
  * @work_q:     &list_head for pending commands.
  * @done_q:	&list_head for processed commands.
- **/
+ */
 static int scsi_eh_bus_reset(struct Scsi_Host *shost,
 			     struct list_head *work_q,
 			     struct list_head *done_q)
@@ -1125,7 +1125,7 @@ static int scsi_eh_bus_reset(struct Scsi
  * scsi_eh_host_reset - send a host reset 
  * @work_q:	list_head for processed commands.
  * @done_q:	list_head for processed commands.
- **/
+ */
 static int scsi_eh_host_reset(struct list_head *work_q,
 			      struct list_head *done_q)
 {
@@ -1160,8 +1160,7 @@ static int scsi_eh_host_reset(struct lis
  * scsi_eh_offline_sdevs - offline scsi devices that fail to recover
  * @work_q:	list_head for processed commands.
  * @done_q:	list_head for processed commands.
- *
- **/
+ */
 static void scsi_eh_offline_sdevs(struct list_head *work_q,
 				  struct list_head *done_q)
 {
@@ -1194,7 +1193,7 @@ static void scsi_eh_offline_sdevs(struct
  *    is woken.  In cases where the error code indicates an error that
  *    doesn't require the error handler read (i.e. we don't need to
  *    abort/reset), this function should return SUCCESS.
- **/
+ */
 int scsi_decide_disposition(struct scsi_cmnd *scmd)
 {
 	int rtn;
@@ -1375,7 +1374,7 @@ int scsi_decide_disposition(struct scsi_
  *
  *	If scsi_allocate_request() fails for what ever reason, we
  *	completely forget to lock the door.
- **/
+ */
 static void scsi_eh_lock_door(struct scsi_device *sdev)
 {
 	unsigned char cmnd[MAX_COMMAND_SIZE];
@@ -1399,7 +1398,7 @@ static void scsi_eh_lock_door(struct scs
  * Notes:
  *    When we entered the error handler, we blocked all further i/o to
  *    this device.  we need to 'reverse' this process.
- **/
+ */
 static void scsi_restart_operations(struct Scsi_Host *shost)
 {
 	struct scsi_device *sdev;
@@ -1445,8 +1444,7 @@ static void scsi_restart_operations(stru
  * @shost: 	host to be recovered.
  * @work_q:     &list_head for pending commands.
  * @done_q:	&list_head for processed commands.
- *
- **/
+ */
 void scsi_eh_ready_devs(struct Scsi_Host *shost,
 			struct list_head *work_q,
 			struct list_head *done_q)
@@ -1462,8 +1460,7 @@ EXPORT_SYMBOL_GPL(scsi_eh_ready_devs);
 /**
  * scsi_eh_flush_done_q - finish processed commands or retry them.
  * @done_q:	list_head of processed commands.
- *
- **/
+ */
 void scsi_eh_flush_done_q(struct list_head *done_q)
 {
 	struct scsi_cmnd *scmd, *next;
@@ -1517,7 +1514,7 @@ EXPORT_SYMBOL(scsi_eh_flush_done_q);
  *    scsi_finish_cmd() called for it.  we do all of the retry stuff
  *    here, so when we restart the host after we return it should have an
  *    empty queue.
- **/
+ */
 static void scsi_unjam_host(struct Scsi_Host *shost)
 {
 	unsigned long flags;
@@ -1544,7 +1541,7 @@ static void scsi_unjam_host(struct Scsi_
  * Notes:
  *    This is the main error handling loop.  This is run as a kernel thread
  *    for every SCSI host and handles all error handling activity.
- **/
+ */
 int scsi_error_handler(void *data)
 {
 	struct Scsi_Host *shost = data;
@@ -1773,7 +1770,7 @@ EXPORT_SYMBOL(scsi_reset_provider);
  *
  * Return value:
  *	1 if valid sense data information found, else 0;
- **/
+ */
 int scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
                          struct scsi_sense_hdr *sshdr)
 {
@@ -1839,7 +1836,7 @@ EXPORT_SYMBOL(scsi_command_normalize_sen
  *
  * Return value:
  *	pointer to start of (first) descriptor if found else NULL
- **/
+ */
 const u8 * scsi_sense_desc_find(const u8 * sense_buffer, int sb_len,
 				int desc_type)
 {
@@ -1875,7 +1872,7 @@ EXPORT_SYMBOL(scsi_sense_desc_find);
  *
  * Return value:
  *	1 if information field found, 0 if not found.
- **/
+ */
 int scsi_get_sense_info_fld(const u8 * sense_buffer, int sb_len,
 			    u64 * info_out)
 {
--- scsi-misc-26.orig/drivers/scsi/scsi_transport_srp.c
+++ scsi-misc-26/drivers/scsi/scsi_transport_srp.c
@@ -185,11 +185,10 @@ static int srp_host_match(struct attribu
 
 /**
  * srp_rport_add - add a SRP remote port to the device hierarchy
- *
  * @shost:	scsi host the remote port is connected to.
  * @ids:	The port id for the remote port.
  *
- * publishes a port to the rest of the system
+ * Publishes a port to the rest of the system.
  */
 struct srp_rport *srp_rport_add(struct Scsi_Host *shost,
 				struct srp_rport_identifiers *ids)
