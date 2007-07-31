From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Subject: [PATCH 21] drivers/scsi/dpt_i2o.c: kmalloc + memset conversion to kzalloc
Date: Tue, 31 Jul 2007 19:35:13 +0200
Message-ID: <200707311935.13958.m.kozlowski@tuxland.pl>
References: <200707311845.48807.m.kozlowski@tuxland.pl>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, aacraid@adaptec.com
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/scsi/dpt_i2o.c | 87632 -> 87457 (-175 bytes)
 drivers/scsi/dpt_i2o.o | 213064 -> 212324 (-740 bytes)

 drivers/scsi/dpt_i2o.c |   27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

--- linux-2.6.23-rc1-mm1-a/drivers/scsi/dpt_i2o.c	2007-07-26 13:07:42.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/scsi/dpt_i2o.c	2007-07-31 11:17:32.000000000 +0200
@@ -950,16 +950,14 @@ static int adpt_install_hba(struct scsi_
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

@@ -2667,14 +2665,13 @@ static s32 adpt_i2o_init_outbound_q(adpt

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
@@ -2713,12 +2710,11 @@ static s32 adpt_i2o_init_outbound_q(adpt

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
@@ -2929,12 +2925,11 @@ static int adpt_i2o_build_sys_table(void

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
