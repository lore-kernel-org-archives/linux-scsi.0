From: James Smart <james.smart@emulex.com>
Subject: Re: [PATCH 7/8] lpfc 8.3.24: debugfs additions for SLI4
Date: Fri, 27 May 2011 23:49:52 -0400
Message-ID: <1306554606.9543.4.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:20590 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757803Ab1E1D5s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 May 2011 23:57:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org

>On Tue, 2011-05-24 at 11:44 -0400, James Smart wrote:
>> > debugfs additions for new SLI interface
>
>You guys need a newer compiler:
>
>drivers/scsi/lpfc/lpfc_debugfs.c: In function <91>lpfc_debugfs_dumpHBASlim_data.clone.3<92>:
>drivers/scsi/lpfc/lpfc_debugfs.c:412:1: warning: the frame size of 1036 bytes is larger than 1024 bytes
>drivers/scsi/lpfc/lpfc_debugfs.c: In function <91>lpfc_idiag_drbacc_write<92>:
>drivers/scsi/lpfc/lpfc_debugfs.c:2260:30: warning: <91>reg_val<92> may be used uninitialized in this function
>
>The reg_val problem looks to be just because the compiler can't work out
>that one of the if () statements will always be true.
>
>The stack overflow is the char buf[1024]
>
>James

yes, it appears so.  We didn't touch these areas, so a latent bug.  What rev are you running ?

I've updated the patch to add the diff below. I'll resend patch7 shortly.

-- james s


 ---

 lpfc_debugfs.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)


--- b/drivers/scsi/lpfc/lpfc_debugfs.c.ORIG	2011-05-27 23:08:48.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c	2011-05-27 23:15:10.000000000 -0400
@@ -379,16 +379,20 @@ lpfc_debugfs_dumpHBASlim_data(struct lpf
 	int len = 0;
 	int i, off;
 	uint32_t *ptr;
-	char buffer[1024];
+	char *dbuf;
+
+	dbuf = kmalloc(1024, GFP_KERNEL);
+	if (!dbuf)
+		goto out;
 
 	off = 0;
 	spin_lock_irq(&phba->hbalock);
 
 	len +=  snprintf(buf+len, size-len, "HBA SLIM\n");
-	lpfc_memcpy_from_slim(buffer,
+	lpfc_memcpy_from_slim(dbuf,
 		phba->MBslimaddr + lpfc_debugfs_last_hba_slim_off, 1024);
 
-	ptr = (uint32_t *)&buffer[0];
+	ptr = (uint32_t *)dbuf;
 	off = lpfc_debugfs_last_hba_slim_off;
 
 	/* Set it up for the next time */
@@ -408,6 +412,8 @@ lpfc_debugfs_dumpHBASlim_data(struct lpf
 	}
 
 	spin_unlock_irq(&phba->hbalock);
+	kfree(dbuf);
+out:
 	return len;
 }
 
@@ -2257,7 +2263,7 @@ lpfc_idiag_drbacc_write(struct file *fil
 {
 	struct lpfc_debug *debug = file->private_data;
 	struct lpfc_hba *phba = (struct lpfc_hba *)debug->i_private;
-	uint32_t drb_reg_id, value, reg_val;
+	uint32_t drb_reg_id, value, reg_val = 0;
 	void __iomem *drb_reg;
 	int rc;
 



