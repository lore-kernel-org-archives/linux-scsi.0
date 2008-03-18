From: bo yang <bo.yang@lsi.com>
Subject: [PATCH 1/4] scsi: megaraid_sas - Rollback the sense info
	implementation
Date: Tue, 18 Mar 2008 03:13:06 -0400
Message-ID: <1205824386.7238.7.camel@pcp021067pcs.se.lsil.com>
References: <9738BCBE884FDB42801FAD8A7769C26501CE50E4@NAMAIL1.ad.lsil.com>
	 <1195251505.3407.30.camel@localhost.localdomain>
	 <9738BCBE884FDB42801FAD8A7769C26501C9A4AF@NAMAIL1.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:45689 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752312AbYCQTdh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Mar 2008 15:33:37 -0400
In-Reply-To: <9738BCBE884FDB42801FAD8A7769C26501C9A4AF@NAMAIL1.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, linux-kernel@vger.kernel.org, "Patro, Sumant" <Sumant.Patro@lsi.com>, nella.kolli@lsi.com, bo.yang@lsi.com

Rollback the sense info implementation

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
 drivers/scsi/megaraid/megaraid_sas.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff -rupN linux-2.6.24_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.24_new/drivers/scsi/megaraid/megaraid_sas.c
--- linux-2.6.24_orig/drivers/scsi/megaraid/megaraid_sas.c	2008-03-07 10:59:53.000000000 -0500
+++ linux-2.6.24_new/drivers/scsi/megaraid/megaraid_sas.c	2008-03-17 13:47:08.000000000 -0400
@@ -2909,7 +2909,6 @@ megasas_mgmt_fw_ioctl(struct megasas_ins
 	void *sense = NULL;
 	dma_addr_t sense_handle;
 	u32 *sense_ptr;
-	unsigned long *sense_buff;
 
 	memset(kbuff_arr, 0, sizeof(kbuff_arr));
 
@@ -3014,14 +3013,14 @@ megasas_mgmt_fw_ioctl(struct megasas_ins
 	 */
 	if (ioc->sense_len) {
 		/*
-		 * sense_buff points to the location that has the user
+		 * sense_ptr points to the location that has the user
 		 * sense buffer address
 		 */
-		sense_buff = (unsigned long *) ((unsigned long)ioc->frame.raw +
-								ioc->sense_off);
+		sense_ptr = (u32 *) ((unsigned long)ioc->frame.raw +
+				     ioc->sense_off);
 
-		if (copy_to_user((void __user *)(unsigned long)(*sense_buff),
-				sense, ioc->sense_len)) {
+		if (copy_to_user((void __user *)((unsigned long)(*sense_ptr)),
+				 sense, ioc->sense_len)) {
 			printk(KERN_ERR "megasas: Failed to copy out to user "
 					"sense data\n");
 			error = -EFAULT;

