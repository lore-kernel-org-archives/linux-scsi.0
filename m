From: akpm@linux-foundation.org
Subject: [patch 25/30] drivers/scsi/dpt_i2o.c: kmalloc + memset conversion to kzalloc
Date: Fri, 10 Aug 2007 14:50:49 -0700
Message-ID: <200708102150.l7ALooaZ011395@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54131 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759416AbXHJWCB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Aug 2007 18:02:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, m.kozlowski@tuxland.pl, mark_salyzyn@adaptec.com

From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/scsi/dpt_i2o.c | 87632 -> 87457 (-175 bytes)
 drivers/scsi/dpt_i2o.o | 213064 -> 212324 (-740 bytes)

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Acked-by: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/dpt_i2o.c |   27 +++++++++++----------------
 1 files changed, 11 insertions(+), 16 deletions(-)

diff -puN drivers/scsi/dpt_i2o.c~drivers-scsi-dpt_i2oc-kmalloc-memset-conversion-to-kzalloc drivers/scsi/dpt_i2o.c
--- a/drivers/scsi/dpt_i2o.c~drivers-scsi-dpt_i2oc-kmalloc-memset-conversion-to-kzalloc
+++ a/drivers/scsi/dpt_i2o.c
@@ -949,16 +949,14 @@ static int adpt_install_hba(struct pci_d
 	}
 	
 	// Allocate and zero the data structure
-	pHba = kmalloc(sizeof(adpt_hba), GFP_KERNEL);
-	if( pHba == NULL) {
-		if(msg_addr_virt != base_addr_virt){
+	pHba = kzalloc(sizeof(adpt_hba), GFP_KERNEL);
+	if (!pHba) {
+		if (msg_addr_virt != base_addr_virt)
 			iounmap(msg_addr_virt);
-		}
 		iounmap(base_addr_virt);
 		pci_release_regions(pDev);
 		return -ENOMEM;
 	}
-	memset(pHba, 0, sizeof(adpt_hba));
 
 	mutex_lock(&adpt_configuration_lock);
 
@@ -2622,14 +2620,13 @@ static s32 adpt_i2o_init_outbound_q(adpt
 
 	msg=(u32 __iomem *)(pHba->msg_addr_virt+m);
 
-	status = kmalloc(4,GFP_KERNEL|ADDR32);
-	if (status==NULL) {
+	status = kzalloc(4, GFP_KERNEL|ADDR32);
+	if (!status) {
 		adpt_send_nop(pHba, m);
 		printk(KERN_WARNING"%s: IOP reset failed - no free memory.\n",
 			pHba->name);
 		return -ENOMEM;
 	}
-	memset(status, 0, 4);
 
 	writel(EIGHT_WORD_MSG_SIZE| SGL_OFFSET_6, &msg[0]);
 	writel(I2O_CMD_OUTBOUND_INIT<<24 | HOST_TID<<12 | ADAPTER_TID, &msg[1]);
@@ -2668,12 +2665,11 @@ static s32 adpt_i2o_init_outbound_q(adpt
 
 	kfree(pHba->reply_pool);
 
-	pHba->reply_pool = kmalloc(pHba->reply_fifo_size * REPLY_FRAME_SIZE * 4, GFP_KERNEL|ADDR32);
-	if(!pHba->reply_pool){
-		printk(KERN_ERR"%s: Could not allocate reply pool\n",pHba->name);
-		return -1;
+	pHba->reply_pool = kzalloc(pHba->reply_fifo_size * REPLY_FRAME_SIZE * 4, GFP_KERNEL|ADDR32);
+	if (!pHba->reply_pool) {
+		printk(KERN_ERR "%s: Could not allocate reply pool\n", pHba->name);
+		return -ENOMEM;
 	}
-	memset(pHba->reply_pool, 0 , pHba->reply_fifo_size * REPLY_FRAME_SIZE * 4);
 
 	ptr = pHba->reply_pool;
 	for(i = 0; i < pHba->reply_fifo_size; i++) {
@@ -2884,12 +2880,11 @@ static int adpt_i2o_build_sys_table(void
 
 	kfree(sys_tbl);
 
-	sys_tbl = kmalloc(sys_tbl_len, GFP_KERNEL|ADDR32);
-	if(!sys_tbl) {
+	sys_tbl = kzalloc(sys_tbl_len, GFP_KERNEL|ADDR32);
+	if (!sys_tbl) {
 		printk(KERN_WARNING "SysTab Set failed. Out of memory.\n");	
 		return -ENOMEM;
 	}
-	memset(sys_tbl, 0, sys_tbl_len);
 
 	sys_tbl->num_entries = hba_count;
 	sys_tbl->version = I2OVERSION;
_
