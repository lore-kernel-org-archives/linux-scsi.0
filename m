From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: [PATCH]: Flexible timeout infrastructure
Date: Tue, 15 Jun 2004 11:02:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40CF0F9F.4050902@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:61855 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S265676AbUFOPC5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jun 2004 11:02:57 -0400
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id i5FF2uX28339
	for <linux-scsi@vger.kernel.org>; Tue, 15 Jun 2004 08:02:56 -0700
Received: from rtpe2k01.adaptec.com (rtpe2k01.adaptec.com [10.110.12.40])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id i5FF2uo29249
	for <linux-scsi@vger.kernel.org>; Tue, 15 Jun 2004 08:02:56 -0700
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hello,

This patch introduces a flexible command timeout infrastructure
accomodating completely current behaviour SCSI Core command timeout,
but also offering the ability to hand command timeout handling to
a LLDD, _yet_ still have it all go through *SCSI Core*.

This is somewhat similar to Christoph's proposal patch, but I wasn't
aware of his patch when I thought of this. Interestingly enough it can be
viewed as an extension to his patch.

The patch is very short (minimal chages indeed), but the text a bit
lenghty since it outlines the many different a usage of such an
infrastructure.

New method: 
  struct scsi_host_template :: int (*eh_cmd_timed_out)(struct scsi_cmnd *);
This method is marked as OPTIONAL status.

If the driver does not define eh_cmd_timed_out() method in its
host template, then current behaviour is assumed.

If the driver does define it, then SCSI Core will give the command
to LLDD without a timer running.  Then when the LLDD notifies the
transport and before it sends it to the interconnect it start
the timer *by calling SCSI Core*, scsi_add_timer(<cmd>,<timeout>,scsi_times_out).

Timeline:
---+-------------------------+-------------> t
   t0                        t1           
SCSI Core::queuecommand(), LLDD::scsi_add_timer(,,scsi_times_out)

NB: |t1-t0| is *always* bounded! (hint)

SUCCESS: If the command completes, LLDD calls
scsi_delete_timer(<cmd>), and then scsi_done().  This completes
the SCSI command transaction.

TO: If the command times out, then *SCSI Core* is called,
scsi_times_out(), which calls the defined, eh_cmd_timed_out()
method.

RETURNS: eh_cmd_timed_out() returns:
  EH_HANDLED:
          - LLDD has called scsi_done() having set the status/response
            codes appropriately,
       XOR
          - resent the command back to the LU.
    Either way, there's nothing to do at this point and the timer
    routine completes.

  EH_NONE:
          - SCSI Core should do error handling as usual.

Note that after eh_cmd_timed_out() returns, we are in _consistent_
state:
- either the command is back out to the LU: timer
has been rerun by the LLDD, the command belongs to LLDD,
SCSI Core should do nothing -- just the same as if it never fired,
XOR
- scsi_done() is called and SCSI Core will
be processing the command shortly, no timer is running
since it fired (since we're executing in this method).
Consistent as if the command completed.
Or we returned EH_NONE, and SCSI Core adds it to the
eh list for recovery.

Let me know your comments, USB, FC, SAS, iSCSI device driver
writers.  The main point of this patch is complicated
_recovery_ of protocols for which SCSI Core cannot have
internal knowlege, but will get notified *at every step*.
I.e. SAM like.

Note that the driver may also decide to do some processing
in the eh_cmd_timed_out() method (interrupt context) and still
return EH_NONE, to get back at that command in process context
from the eh tread (i.e. if TMF ABORT TASK takes some time to return).

Against scsi-misc-2.6:

===== drivers/scsi/scsi.c 1.143 vs edited =====
--- 1.143/drivers/scsi/scsi.c	2004-04-28 12:32:09 -04:00
+++ edited/drivers/scsi/scsi.c	2004-06-14 15:13:12 -04:00
@@ -549,7 +549,12 @@
 		host->resetting = 0;
 	}
 
-	scsi_add_timer(cmd, cmd->timeout_per_command, scsi_times_out);
+	/* If the LLDD claims to be able to handle its own command timeout,
+	 * don't start the timer.  It will start it before sending the command
+	 * to the LU.
+	 */
+	if (!host->hostt->eh_cmd_timed_out)
+		scsi_add_timer(cmd, cmd->timeout_per_command, scsi_times_out);
 
 	scsi_log_send(cmd);
 
@@ -699,8 +704,9 @@
 	 * that function could really be.  It might be on another processor,
 	 * etc, etc.
 	 */
-	if (!scsi_delete_timer(cmd))
-		return;
+	if (!cmd->device->host->hostt->eh_cmd_timed_out)
+		if (!scsi_delete_timer(cmd))
+			return;
 
 	/*
 	 * Set the serial numbers back to zero
===== drivers/scsi/scsi_error.c 1.76 vs edited =====
--- 1.76/drivers/scsi/scsi_error.c	2004-06-04 12:54:06 -04:00
+++ edited/drivers/scsi/scsi_error.c	2004-06-14 15:13:53 -04:00
@@ -155,8 +155,8 @@
 }
 
 /**
- * scsi_times_out - Timeout function for normal scsi commands.
- * @scmd:	Cmd that is timing out.
+ * scsi_times_out - Timeout function for normal SCSI commands.
+ * @scmd:	Command that is timing out.
  *
  * Notes:
  *     We do not need to lock this.  There is the potential for a race
@@ -166,7 +166,16 @@
  **/
 void scsi_times_out(struct scsi_cmnd *scmd)
 {
+	int ret = EH_NONE;
+	
 	scsi_log_completion(scmd, TIMEOUT_ERROR);
+
+	if (scmd->device->host->hostt->eh_cmd_timed_out)
+		ret = scmd->device->host->hostt->eh_cmd_timed_out(scmd);
+
+	if (ret == EH_HANDLED)
+		return;
+	
 	if (unlikely(!scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD))) {
 		panic("Error handler thread not present at %p %p %s %d",
 		      scmd, scmd->device->host, __FILE__, __LINE__);
===== drivers/scsi/scsi_syms.c 1.47 vs edited =====
--- 1.47/drivers/scsi/scsi_syms.c	2004-05-19 13:46:14 -04:00
+++ edited/drivers/scsi/scsi_syms.c	2004-06-14 11:09:29 -04:00
@@ -107,3 +107,4 @@
  */
 EXPORT_SYMBOL(scsi_add_timer);
 EXPORT_SYMBOL(scsi_delete_timer);
+EXPORT_SYMBOL(scsi_times_out);
===== include/scsi/scsi.h 1.21 vs edited =====
--- 1.21/include/scsi/scsi.h	2004-04-21 12:54:43 -04:00
+++ edited/include/scsi/scsi.h	2004-06-14 14:33:15 -04:00
@@ -327,6 +327,12 @@
 #define SCSI_MLQUEUE_EH_RETRY    0x1057
 
 /*
+ * LLDD timeout handler return values
+ */
+#define EH_NONE        (0)
+#define EH_HANDLED     (1)
+
+/*
  *  Use these to separate status msg and our bytes
  *
  *  These are set by:
===== include/scsi/scsi_eh.h 1.2 vs edited =====
--- 1.2/include/scsi/scsi_eh.h	2004-06-04 07:45:01 -04:00
+++ edited/include/scsi/scsi_eh.h	2004-06-14 11:12:13 -04:00
@@ -7,10 +7,11 @@
 
 extern void scsi_add_timer(struct scsi_cmnd *, int,
 			   void (*)(struct scsi_cmnd *));
-extern int scsi_delete_timer(struct scsi_cmnd *);
+extern int  scsi_delete_timer(struct scsi_cmnd *);
+extern void scsi_times_out(struct scsi_cmnd *);
 extern void scsi_report_bus_reset(struct Scsi_Host *, int);
 extern void scsi_report_device_reset(struct Scsi_Host *, int, int);
-extern int scsi_block_when_processing_errors(struct scsi_device *);
+extern int  scsi_block_when_processing_errors(struct scsi_device *);
 extern void scsi_sleep(int);
 
 /*
===== include/scsi/scsi_host.h 1.17 vs edited =====
--- 1.17/include/scsi/scsi_host.h	2004-06-04 12:51:31 -04:00
+++ edited/include/scsi/scsi_host.h	2004-06-14 15:12:23 -04:00
@@ -125,6 +125,40 @@
 	int (* eh_bus_reset_handler)(struct scsi_cmnd *);
 	int (* eh_host_reset_handler)(struct scsi_cmnd *);
 
+
+	/*
+	 * If defined, SCSI Core will leave _all_ command timeout
+	 * handling to the LLDD.  The LLDD should call
+	 * scsi_add_timer(<cmd>,<timeout>,scsi_times_out) when
+	 * appropriate, possibly before sending the command to the LU,
+	 * and scsi_delete_timer(<cmd>) before returning it to SCSI
+	 * Core. That is, a SCSI command is passed to the LLDD (via
+	 * queuecommand()) _without_ a timer running and is expected
+	 * to be returned to SCSI Core (via scsi_done()) just the
+	 * same, without one running.
+	 *
+	 * This method is called whenever a SCSI command times out, if
+	 * the driver had called
+	 * scsi_add_timer(<cmd>,<timeout>,scsi_times_out) of course.
+	 *
+	 * Returns: EH_HANDLED or EH_NONE.
+	 * EH_HANDLED -- means that the LLDD has taken all steps
+	 * to ensure proper command recovery handling and had
+	 * A) either called scsi_done() and set the response/result
+	 * properly in the SCSI command structure,
+	 * XOR
+	 * B) resent the command to the LU.
+	 * EH_NONE -- SCSI Core should try to recover the command as
+	 * usual (eh recovery thread, etc).
+	 *
+	 * If this method is not defined, current/old behaviour is assumed.
+	 *
+	 * NOTE: This runs in interrupt context, so it cannot sleep.
+	 * 
+	 * STATUS: OPTIONAL
+	 */
+	int (* eh_cmd_timed_out)(struct scsi_cmnd *);
+
 	/*
 	 * Old EH handlers, no longer used. Make them warn the user of old
 	 * drivers by using a wrong type


-- 
Luben


