From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 11/10] Fix build when spinlock debugging is enabled
Date: Wed, 29 Mar 2006 14:45:18 -0700
Message-ID: <20060329214518.GD13590@parisc-linux.org>
References: <1143561824743-git-send-email-matthew@wil.cx> <1143585873.1061.44.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:60057 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S1750760AbWC2VpU
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Mar 2006 16:45:20 -0500
Content-Disposition: inline
In-Reply-To: <1143585873.1061.44.camel@markh3.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@osdl.org>

On Tue, Mar 28, 2006 at 02:44:33PM -0800, Mark Haverkamp wrote:
> I am seeing a compile error here:
> drivers/scsi/sym53c8xx_2/sym_glue.c: In function ???sym_eh_done???:
> drivers/scsi/sym53c8xx_2/sym_glue.c:711: error: size of array ???type name??? is negative
> make[3]: *** [drivers/scsi/sym53c8xx_2/sym_glue.o] Error 1
> 
> config attached.

Thanks, Mark.

-----------

When spinlock debugging is turned on, a struct completion grows beyond the
size allowed for the scsi_pointer.  So move the struct completion back onto
the stack.  The additional memory barriers are to keep us from completing
a random piece of kernel stack if the command happens to complete after
the error handling has finished.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 2c4e5f1..9c83b4d 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -140,11 +140,11 @@ static struct scsi_transport_template *s
  *  Driver private area in the SCSI command structure.
  */
 struct sym_ucmd {		/* Override the SCSI pointer structure */
-	struct completion done;
-	void (*old_done)(struct scsi_cmnd *);
-	dma_addr_t data_mapping;
-	int to_do;
-	u_char data_mapped; /* corresponds to data_mapping above */
+	dma_addr_t	data_mapping;
+	unsigned char	data_mapped;
+	unsigned char	to_do;			/* For error handling */
+	void (*old_done)(struct scsi_cmnd *);	/* For error handling */
+	struct completion *eh_done;		/* For error handling */
 };
 
 #define SYM_UCMD_PTR(cmd)  ((struct sym_ucmd *)(&(cmd)->SCp))
@@ -713,7 +713,7 @@ static void sym_eh_done(struct scsi_cmnd
 	cmd->scsi_done = ucmd->old_done;
 
 	if (ucmd->to_do == SYM_EH_DO_WAIT)
-		complete(&ucmd->done);
+		complete(ucmd->eh_done);
 }
 
 /*
@@ -728,6 +728,7 @@ static int sym_eh_handler(int op, char *
 	SYM_QUEHEAD *qp;
 	int to_do = SYM_EH_DO_IGNORE;
 	int sts = -1;
+	struct completion eh_done;
 
 	dev_warn(&cmd->device->sdev_gendev, "%s operation started.\n", opname);
 
@@ -742,8 +743,10 @@ static int sym_eh_handler(int op, char *
 	}
 
 	if (to_do == SYM_EH_DO_WAIT) {
-		init_completion(&ucmd->done);
+		init_completion(&eh_done);
 		ucmd->old_done = cmd->scsi_done;
+		ucmd->eh_done = &eh_done;
+		wmb();
 		cmd->scsi_done = sym_eh_done;
 	}
 
@@ -779,8 +782,9 @@ static int sym_eh_handler(int op, char *
 	spin_unlock_irq(host->host_lock);
 
 	if (to_do == SYM_EH_DO_WAIT) {
-		if (!wait_for_completion_timeout(&ucmd->done, 5*HZ)) {
+		if (!wait_for_completion_timeout(&eh_done, 5*HZ)) {
 			ucmd->to_do = SYM_EH_DO_IGNORE;
+			wmb();
 			sts = -2;
 		}
 	}
