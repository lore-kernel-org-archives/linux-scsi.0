From: Jeff Garzik <jgarzik@pobox.com>
Subject: [BK PATCH] 2.6.x libata fix
Date: Sat, 28 Feb 2004 17:23:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040228222329.GA11392@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([216.162.42.101]:55735 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S261936AbUB1WXb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 Feb 2004 17:23:31 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>
Cc: linux-scsi@vger.kernel.org


The SCSI part of this change was ACK'd by James, and is needed anyway
for anybody using the SCSI layer's ->eh_strategy_handler().  I was just
the first to actually use ->eh_strategy_handler(), it looks like :)

Long term probably better to kill ->eh_strategy_handler(), but I leave
that up to James, Christoph, and the wiser heads of scsi land.


Please do a

	bk pull bk://gkernel.bkbits.net/libata-2.5

This will update the following files:

 drivers/scsi/libata-core.c |    8 ++++++++
 drivers/scsi/scsi.c        |    1 +
 drivers/scsi/scsi_priv.h   |    1 -
 include/scsi/scsi_cmnd.h   |    1 +
 4 files changed, 10 insertions(+), 1 deletion(-)

through these ChangeSets:

<jgarzik@redhat.com> (04/02/28 1.1683)
   [libata] Use scsi_finish_command as completion function,
   in our error handling thread callback.
   
   This also exports scsi_finish_command in the SCSI layer.
   
   Thanks much to James Bottomley and his patience, as this solution
   was figured out.

diff -Nru a/drivers/scsi/libata-core.c b/drivers/scsi/libata-core.c
--- a/drivers/scsi/libata-core.c	Sat Feb 28 17:20:23 2004
+++ b/drivers/scsi/libata-core.c	Sat Feb 28 17:20:23 2004
@@ -2005,6 +2005,14 @@
 		goto out;
 	}
 
+	/* hack alert!  We cannot use the supplied completion
+	 * function from inside the ->eh_strategy_handler() thread.
+	 * libata is the only user of ->eh_strategy_handler() in
+	 * any kernel, so the default scsi_done() assumes it is
+	 * not being called from the SCSI EH.
+	 */
+	qc->scsidone = scsi_finish_command;
+
 	switch (qc->tf.protocol) {
 	case ATA_PROT_DMA_READ:
 	case ATA_PROT_DMA_WRITE:
diff -Nru a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
--- a/drivers/scsi/scsi.c	Sat Feb 28 17:20:23 2004
+++ b/drivers/scsi/scsi.c	Sat Feb 28 17:20:23 2004
@@ -847,6 +847,7 @@
 
 	cmd->done(cmd);
 }
+EXPORT_SYMBOL(scsi_finish_command);
 
 /*
  * Function:	scsi_adjust_queue_depth()
diff -Nru a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
--- a/drivers/scsi/scsi_priv.h	Sat Feb 28 17:20:23 2004
+++ b/drivers/scsi/scsi_priv.h	Sat Feb 28 17:20:23 2004
@@ -77,7 +77,6 @@
 extern int scsi_setup_command_freelist(struct Scsi_Host *shost);
 extern void scsi_destroy_command_freelist(struct Scsi_Host *shost);
 extern void scsi_done(struct scsi_cmnd *cmd);
-extern void scsi_finish_command(struct scsi_cmnd *cmd);
 extern int scsi_retry_command(struct scsi_cmnd *cmd);
 extern int scsi_insert_special_req(struct scsi_request *sreq, int);
 extern void scsi_init_cmd_from_req(struct scsi_cmnd *cmd,
diff -Nru a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
--- a/include/scsi/scsi_cmnd.h	Sat Feb 28 17:20:23 2004
+++ b/include/scsi/scsi_cmnd.h	Sat Feb 28 17:20:23 2004
@@ -159,5 +159,6 @@
 extern struct scsi_cmnd *scsi_get_command(struct scsi_device *, int);
 extern void scsi_put_command(struct scsi_cmnd *);
 extern void scsi_io_completion(struct scsi_cmnd *, unsigned int, unsigned int);
+extern void scsi_finish_command(struct scsi_cmnd *cmd);
 
 #endif /* _SCSI_SCSI_CMND_H */
