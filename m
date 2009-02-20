From: "Nicholas A. Bellinger" <nicholas_bellinger@sbcglobal.net>
Subject: [PATCH 6/7] [Target_Core_Mod/RAMDISK]: Add 4k sector/block size
	emulation support
Date: Fri, 20 Feb 2009 00:05:53 -0800
Message-ID: <1235117153.12375.1048.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:28371 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753043AbZBTINk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Feb 2009 03:13:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Matthew Wilcox <matthew@wil.cx>, Alan Stern <stern@rowland.harvard.edu>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Andrew Morton <akpm@linux-foundation.org>

>From e534e9f02be94996536ce275da27734ba329572d Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Thu, 19 Feb 2009 19:43:20 -0800
Subject: [PATCH 6/7] [Target_Core_Mod/RAMDISK]: Add 4k sector/block size emulation support

This patch adds support for 4k (and all non 512 byte) sector sizes for the
Target_Core_Mod/ConfigFS interaction with RAMDISK_DR and RAMDISK_MCP objects.

This patch updates rd_emulate_read_cap(), rd_emulate_read_cap16() for control path
CDB emulation, and rd_MEMCPY_do_task() rd_DIRECT_do_se_mem_map() and rd_DIRECT_check_lba()
for LBA related ops.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_rd.c |   31 ++++++++++++++++++++-----------
 1 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/lio-core/target_core_rd.c b/drivers/lio-core/target_core_rd.c
index 1c263cc..8c55c43 100644
--- a/drivers/lio-core/target_core_rd.c
+++ b/drivers/lio-core/target_core_rd.c
@@ -440,20 +440,23 @@ static int rd_emulate_inquiry (se_task_t *task)
 static int rd_emulate_read_cap (se_task_t *task)
 {
 	rd_dev_t *rd_dev = (rd_dev_t *) task->se_dev->dev_ptr;
-	u32 blocks = ((rd_dev->rd_page_count * PAGE_SIZE) / RD_BLOCKSIZE) - 1;
+	u32 blocks = ((rd_dev->rd_page_count * PAGE_SIZE) /
+		       DEV_ATTRIB(task->se_dev)->block_size) - 1;
 
-	if ((((rd_dev->rd_page_count * PAGE_SIZE) / RD_BLOCKSIZE) - 1) > 0x00000000ffffffff)
+	if ((((rd_dev->rd_page_count * PAGE_SIZE) /
+	       DEV_ATTRIB(task->se_dev)->block_size) - 1) >= 0x00000000ffffffff)
 		blocks = 0xffffffff;
 
-	return(transport_generic_emulate_readcapacity(TASK_CMD(task), blocks, RD_BLOCKSIZE));
+	return(transport_generic_emulate_readcapacity(TASK_CMD(task), blocks));
 }
 
 static int rd_emulate_read_cap16 (se_task_t *task)
 {
 	rd_dev_t *rd_dev = (rd_dev_t *) task->se_dev->dev_ptr;
-	unsigned long long blocks_long = ((rd_dev->rd_page_count * PAGE_SIZE) / RD_BLOCKSIZE) - 1;	
+	unsigned long long blocks_long = ((rd_dev->rd_page_count * PAGE_SIZE) /
+				   DEV_ATTRIB(task->se_dev)->block_size) - 1;	
 
-	return(transport_generic_emulate_readcapacity_16(TASK_CMD(task), blocks_long, RD_BLOCKSIZE));
+	return(transport_generic_emulate_readcapacity_16(TASK_CMD(task), blocks_long));
 }
 
 /*	rd_emulate_scsi_cdb():
@@ -767,15 +770,17 @@ static int rd_MEMCPY_write (rd_request_t *req)
  */
 extern int rd_MEMCPY_do_task (se_task_t *task)
 {
-	int ret = 0;
+	se_device_t *dev = task->se_dev;
 	rd_request_t *req = (rd_request_t *) task->transport_req;
+	int ret;
 
 	if (!(TASK_CMD(task)->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB))
 		return(rd_emulate_scsi_cdb(task));
 		
 	req->rd_lba = task->task_lba;
-	req->rd_page = (req->rd_lba * RD_BLOCKSIZE) / PAGE_SIZE;
-	req->rd_offset = (req->rd_lba % (PAGE_SIZE / RD_BLOCKSIZE)) * RD_BLOCKSIZE;
+	req->rd_page = (req->rd_lba * DEV_ATTRIB(dev)->block_size) / PAGE_SIZE;
+	req->rd_offset = (req->rd_lba % (PAGE_SIZE / DEV_ATTRIB(dev)->block_size)) *
+			  DEV_ATTRIB(dev)->block_size;
 	req->rd_size = task->task_size;
 
 	if (req->rd_data_direction == RD_DATA_READ)
@@ -979,8 +984,11 @@ extern int rd_DIRECT_do_se_mem_map (
 
 	req->rd_lba = task->task_lba;
 	req->rd_req_flags = RRF_GOT_LBA;
-	req->rd_page = ((req->rd_lba * RD_BLOCKSIZE) / PAGE_SIZE);
-	req->rd_offset = (req->rd_lba % (PAGE_SIZE / RD_BLOCKSIZE)) * RD_BLOCKSIZE;
+	req->rd_page = ((req->rd_lba * DEV_ATTRIB(task->se_dev)->block_size) /
+			PAGE_SIZE);
+	req->rd_offset = (req->rd_lba %
+			(PAGE_SIZE / DEV_ATTRIB(task->se_dev)->block_size)) *
+			DEV_ATTRIB(task->se_dev)->block_size;
 	req->rd_size = task->task_size;
 
 	if (req->rd_offset)
@@ -1301,7 +1309,8 @@ extern int rd_CDB_write_SG (se_task_t *task, u32 size)
  */
 extern int rd_DIRECT_check_lba (unsigned long long lba, se_device_t *dev)
 {
-	return(((lba % (PAGE_SIZE / RD_BLOCKSIZE)) * RD_BLOCKSIZE) ? 1 : 0);
+	return(((lba % (PAGE_SIZE / DEV_ATTRIB(dev)->block_size)) *
+		 DEV_ATTRIB(dev)->block_size) ? 1 : 0);
 }
 
 /*	rd_MEMCPY_check_lba():
-- 
1.5.4.1



