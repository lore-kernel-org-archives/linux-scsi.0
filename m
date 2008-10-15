From: Mike Miller <mike.miller@hp.com>
Subject: [PATCH 2/1] cciss regression: firmware version not displayed in procfs
Date: Wed, 15 Oct 2008 15:44:13 -0500
Message-ID: <20081015204413.GA19110@roadking.ldev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:38866 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbYJOUoO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Oct 2008 16:44:14 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, JensAxboejens.axboe@oracle.com
Cc: LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>

Patch 2 of 1

This patch fixes another regression introduced by commit
6ae5ce8e8d4de666f31286808d2285aa6a50fa40. The fiwmware version is no longer
being displayed in procfs. Please consider this for inclusion.

Signed-off-by: Mike Miller <mike.miller@hp.com>

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 1e1f915..09b27d5 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1631,6 +1632,7 @@ static int rebuild_lun_table(ctlr_info_t *h, int first_time)
 	int ctlr = h->ctlr;
 	int num_luns;
 	ReportLunData_struct *ld_buff = NULL;
+	InquiryData_struct *inq_buff = NULL;
 	int return_code;
 	int listlength = 0;
 	int i;
@@ -1651,6 +1653,26 @@ static int rebuild_lun_table(ctlr_info_t *h, int first_time)
 	h->busy_configuring = 1;
 	spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
 
+	inq_buff = kzalloc(sizeof(InquiryData_struct), GFP_KERNEL);
+        if (inq_buff == NULL) {
+                printk(KERN_ERR "cciss: out of memory\n");
+                return ENOMEM;
+        }
+
+	/* Get the firmware version */ 
+	return_code = sendcmd_withirq(CISS_INQUIRY, ctlr, inq_buff, 
+		sizeof(InquiryData_struct), 0, 0 ,0, TYPE_CMD);
+	if (return_code == IO_OK) {
+		h->firm_ver[0] = inq_buff->data_byte[32];
+		h->firm_ver[1] = inq_buff->data_byte[33];
+		h->firm_ver[2] = inq_buff->data_byte[34];
+		h->firm_ver[3] = inq_buff->data_byte[35];
+	} else {	 /* send command failed */
+		printk(KERN_WARNING "cciss: unable to determine firmware"
+			" version of controller\n");
+	}
+
+	/* Get the number of logical volumes */ 
 	ld_buff = kzalloc(sizeof(ReportLunData_struct), GFP_KERNEL);
 	if (ld_buff == NULL)
 		goto mem_msg;
