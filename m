From: bo yang <bo.yang@lsi.com>
Subject: [PATCH 3/6] scsi: megaraid_sas - using unsigned long for
	sense_buff ptr
Date: Fri, 09 Nov 2007 04:28:47 -0500
Message-ID: <1194600527.6297.4.camel@dhcp-75-884.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:35661 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385AbXKIVXU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Nov 2007 16:23:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, akpm@osdl.org, linux-kernel@vger.kernel.org, Bo.yang@lsi.com, Sumant.patro@lsi.com

MegaRAID utilities expect sense_buff to be of type unsigned long.

Signed-off-by: Bo Yang <bo.yang@lsi.com>

---
 drivers/scsi/megaraid/megaraid_sas.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff -rupN linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.c
--- linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.c	2007-11-07 02:28:21.206651976 -0500
+++ linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.c	2007-11-07 02:29:11.219048936 -0500
@@ -2824,6 +2824,7 @@ megasas_mgmt_fw_ioctl(struct megasas_ins
 	void *sense = NULL;
 	dma_addr_t sense_handle;
 	u32 *sense_ptr;
+	unsigned long *sense_buff;
 
 	memset(kbuff_arr, 0, sizeof(kbuff_arr));
 
@@ -2928,14 +2929,16 @@ megasas_mgmt_fw_ioctl(struct megasas_ins
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

