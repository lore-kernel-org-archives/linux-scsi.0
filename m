From: bo yang <bo.yang@lsi.com>
Subject: [PATCH 5/8] scsi: megaraid_sas - using unsigned long for
	sense_buff ptr
Date: Mon, 01 Oct 2007 12:02:05 -0400
Message-ID: <1191254525.5850.22.camel@dhcp-75-534.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:61260 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754072AbXJCUoz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Oct 2007 16:44:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, akpm@osdl.org, linux-kernel@vger.kernel.org, Bo.yang@lsi.com, Sumant.patro@lsi.com

MegaRAID utilities expect sense_buff to be of type unsigned long.

Signed-off-by: Bo Yang <bo.yang@lsi.com>

---
 drivers/scsi/megaraid/megaraid_sas.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff -uprN linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.c
--- linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.c	2007-10-01 05:20:03.000000000 -0700
+++ linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.c	2007-10-02 22:40:22.000000000 -0700
@@ -2942,6 +2942,7 @@ megasas_mgmt_fw_ioctl(struct megasas_ins
 	void *sense = NULL;
 	dma_addr_t sense_handle;
 	u32 *sense_ptr;
+	unsigned long *sense_buff;
 
 	memset(kbuff_arr, 0, sizeof(kbuff_arr));
 
@@ -3046,14 +3047,16 @@ megasas_mgmt_fw_ioctl(struct megasas_ins
 	 */
 	if (ioc->sense_len) {
 		/*
-		 * sense_ptr points to the location that has the user
+		 * sense_buff points to the location that has the user
 		 * sense buffer address
 		 */
-		sense_ptr = (u32 *) ((unsigned long)ioc->frame.raw +
-				     ioc->sense_off);
+		sense_buff = (unsigned long *) ((unsigned long)ioc->frame.raw +
+								ioc->sense_off);
 
-		if (copy_to_user((void __user *)((unsigned long)(*sense_ptr)),
-				 sense, ioc->sense_len)) {
+		if (copy_to_user((void __user *)(unsigned long)(*sense_buff),
+				sense, ioc->sense_len)) {
+			printk(KERN_ERR "megasas: Failed to copy out to user "
+					"sense data\n");
 			error = -EFAULT;
 			goto out;
 		}

