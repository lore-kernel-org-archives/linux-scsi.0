From: James Bottomley <James.Bottomley@suse.de>
Subject: [PATCH] fix up SCSI documentation for change in ->queuecommand to
 lockless calling
Date: Thu, 16 Dec 2010 09:22:24 -0500
Message-ID: <1292509344.3024.7.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:48942 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753670Ab0LPOW2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Dec 2010 09:22:28 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.221.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id AF5FB90975
	for <linux-scsi@vger.kernel.org>; Thu, 16 Dec 2010 15:22:27 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

The current doc still says we call it with the host lock held, which is
going to cause confusion.

James

---

diff --git a/Documentation/scsi/scsi_mid_low_api.txt b/Documentation/scsi/scsi_mid_low_api.txt
index 570ef2b..df322c1 100644
--- a/Documentation/scsi/scsi_mid_low_api.txt
+++ b/Documentation/scsi/scsi_mid_low_api.txt
@@ -1044,9 +1044,9 @@ Details:
 
 
 /**
- *      queuecommand - queue scsi command, invoke 'done' on completion
+ *      queuecommand - queue scsi command, invoke scp->scsi_done on completion
+ *      @shost: pointer to the scsi host object
  *      @scp: pointer to scsi command object
- *      @done: function pointer to be invoked on completion
  *
  *      Returns 0 on success.
  *
@@ -1074,42 +1074,45 @@ Details:
  *
  *      Other types of errors that are detected immediately may be
  *      flagged by setting scp->result to an appropriate value,
- *      invoking the 'done' callback, and then returning 0 from this
- *      function. If the command is not performed immediately (and the
- *      LLD is starting (or will start) the given command) then this
- *      function should place 0 in scp->result and return 0.
+ *      invoking the scp->scsi_done callback, and then returning 0
+ *      from this function. If the command is not performed
+ *      immediately (and the LLD is starting (or will start) the given
+ *      command) then this function should place 0 in scp->result and
+ *      return 0.
  *
  *      Command ownership.  If the driver returns zero, it owns the
- *      command and must take responsibility for ensuring the 'done'
- *      callback is executed.  Note: the driver may call done before
- *      returning zero, but after it has called done, it may not
- *      return any value other than zero.  If the driver makes a
- *      non-zero return, it must not execute the command's done
- *      callback at any time.
- *
- *      Locks: struct Scsi_Host::host_lock held on entry (with "irqsave")
- *             and is expected to be held on return.
+ *      command and must take responsibility for ensuring the
+ *      scp->scsi_done callback is executed.  Note: the driver may
+ *      call scp->scsi_done before returning zero, but after it has
+ *      called scp->scsi_done, it may not return any value other than
+ *      zero.  If the driver makes a non-zero return, it must not
+ *      execute the command's scsi_done callback at any time.
+ *
+ *      Locks: up to and including 2.6.36, struct Scsi_Host::host_lock
+ *             held on entry (with "irqsave") and is expected to be
+ *             held on return. From 2.6.37 onwards, queuecommand is
+ *             called without any locks held.
  *
  *      Calling context: in interrupt (soft irq) or process context
  *
- *      Notes: This function should be relatively fast. Normally it will
- *      not wait for IO to complete. Hence the 'done' callback is invoked 
- *      (often directly from an interrupt service routine) some time after
- *      this function has returned. In some cases (e.g. pseudo adapter 
- *      drivers that manufacture the response to a SCSI INQUIRY)
- *      the 'done' callback may be invoked before this function returns.
- *      If the 'done' callback is not invoked within a certain period
- *      the SCSI mid level will commence error processing.
- *      If a status of CHECK CONDITION is placed in "result" when the
- *      'done' callback is invoked, then the LLD driver should 
- *      perform autosense and fill in the struct scsi_cmnd::sense_buffer
+ *      Notes: This function should be relatively fast. Normally it
+ *      will not wait for IO to complete. Hence the scp->scsi_done
+ *      callback is invoked (often directly from an interrupt service
+ *      routine) some time after this function has returned. In some
+ *      cases (e.g. pseudo adapter drivers that manufacture the
+ *      response to a SCSI INQUIRY) the scp->scsi_done callback may be
+ *      invoked before this function returns.  If the scp->scsi_done
+ *      callback is not invoked within a certain period the SCSI mid
+ *      level will commence error processing.  If a status of CHECK
+ *      CONDITION is placed in "result" when the scp->scsi_done
+ *      callback is invoked, then the LLD driver should perform
+ *      autosense and fill in the struct scsi_cmnd::sense_buffer
  *      array. The scsi_cmnd::sense_buffer array is zeroed prior to
  *      the mid level queuing a command to an LLD.
  *
  *      Defined in: LLD
  **/
-    int queuecommand(struct scsi_cmnd * scp, 
-                     void (*done)(struct scsi_cmnd *))
+    int queuecommand(struct Scsi_Host *shost, struct scsi_cmnd * scp)
 
 
 /**


