Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCA59C5479D
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Jan 2023 01:55:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbjAJBzw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Jan 2023 20:55:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230453AbjAJBzq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jan 2023 20:55:46 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE5BD1869B
        for <linux-scsi@vger.kernel.org>; Mon,  9 Jan 2023 17:55:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1673315745; x=1704851745;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sgAev5VzvlIv5c4/OhZ3LiIg69h8A1vafDAPidAnZ3w=;
  b=mAsbbz9ARRoIwczVYcEtCwxPGSXf2xTar2w06a8GhMev3R5doOckyAjx
   Ckw7nsmIVpKakDFR2qG6t+s36mTJ+4uEydOj2+RiGXOot07S/1fO+6hAS
   71SbEdw+XnRfCdmi0fuobfCYEYFXXzw7EE9S86VV32AmlhzeCUPJRi8rv
   xFLyZq0gEzDm9bmBPEbMOnIcVcFaSHEOUUSSCUOaIGQrDrzIaHHIxrVnr
   4QWEOt6RPRtQMqi6TlvU/Jh67KAo5o9RQgVZhUGEfaG/5lY9edCtoB8we
   XfH25+kWwDmTsbBs1iemdgMOjLPe1j+N+LXPrdoDHv+bFrfc3drmPvlfs
   w==;
X-IronPort-AV: E=Sophos;i="5.96,313,1665417600"; 
   d="scan'208";a="324698289"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 10 Jan 2023 09:55:45 +0800
IronPort-SDR: hHbd/+9Umvsv4sRgo4y9HCPmH3nyoB7Oe1/NskTPvH8MxZgCGucUvKIfW7LNPA1Lb+p4FEwG/V
 07rvqkhckmH0Jo6l+xBpty7+l1SOieRfEF2ChDOUVyCH31ExYfNmPmC0pZevFbsOp3pv5Pbv0m
 v0avidFHsp3P8temjlDHcwwD//YTnCPV4OjZv4h4Gh4dYyqplOFVcS3/em5LoRjMhYs7zAznxK
 W9vyucRl0y81FUeJ82FEVspnF9PvGfcsw5xUWlNcfmUcFHDkDbOLQ/aj7esDdoEaMXxfzyqmVh
 xE4=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Jan 2023 17:07:51 -0800
IronPort-SDR: hReiqU8yvp8IG+ZDCp8yFHm3JlO0OA6Sl/iWd0HOAfEHqqWMcR7CxGh1f6r3lOg9yqUA5mP7T3
 boAcw7qQNTDWIF5euULW182TanjvhMfm42dK+X04MGaWK55GktofWcKg6HTV4ELCBt0wmTtuC+
 G/oWrcBCj6UMiK0YWPMTVXQgmJaaquQAe8ZtgWzsNDobVKQfvOMhZH26OgSGxwr+WYq8aR97YP
 amEi8ZKPsUP+flG7HlDNVCeAJUjjblulWvcjSw2zgHLAZ9MvphSu0YC04JtNwcMa878t1mkTqR
 YmE=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 09 Jan 2023 17:55:45 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     linux-scsi@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com
Cc:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v3 4/5] scsi: mpi3mr: use number of bits to manage bitmap sizes
Date:   Tue, 10 Jan 2023 10:55:37 +0900
Message-Id: <20230110015538.201332-5-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230110015538.201332-1-shinichiro.kawasaki@wdc.com>
References: <20230110015538.201332-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

To allocate bitmaps, the mpi3mr driver calculates sizes of bitmaps using
byte as unit. However, bitmap helper functions assume that bitmaps are
allocated using unsigned long as unit. This gap causes memory access
beyond the bitmap sizes and results in "BUG: KASAN: slab-out-of-bounds".
The BUG was observed at firmware download to eHBA-9600. Call trace
indicated that the out-of-bounds access happened in find_first_zero_bit
called from mpi3mr_send_event_ack for miroc->evtack_cmds_bitmap.

To fix the BUG, do not use bytes to manage bitmap sizes. Instead, use
number of bits, and call bitmap helper functions which take number of
bits as arguments. For memory allocation, call bitmap_zalloc instead of
kzalloc. For zero clear, call bitmap_clear instead of memset. For
resize, call bitmap_zalloc and bitmap_copy instead of krealloc.

Remove three fields for bitmap byte sizes in struct scmd_priv, which are
no longer required. Replace the field dev_handle_bitmap_sz with
dev_handle_bitmap_bits to keep number of bits of removepend_bitmap
across resize.

Fixes: c5758fc72b92 ("scsi: mpi3mr: Gracefully handle online FW update operation")
Fixes: e844adb1fbdc ("scsi: mpi3mr: Implement SCSI error handler hooks")
Fixes: c1af985d27da ("scsi: mpi3mr: Add Event acknowledgment logic")
Fixes: 824a156633df ("scsi: mpi3mr: Base driver code")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h    | 10 +----
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 68 ++++++++++++++-------------------
 2 files changed, 30 insertions(+), 48 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index def4c5e15cd8..8a438f248a82 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -955,19 +955,16 @@ struct scmd_priv {
  * @chain_buf_count: Chain buffer count
  * @chain_buf_pool: Chain buffer pool
  * @chain_sgl_list: Chain SGL list
- * @chain_bitmap_sz: Chain buffer allocator bitmap size
  * @chain_bitmap: Chain buffer allocator bitmap
  * @chain_buf_lock: Chain buffer list lock
  * @bsg_cmds: Command tracker for BSG command
  * @host_tm_cmds: Command tracker for task management commands
  * @dev_rmhs_cmds: Command tracker for device removal commands
  * @evtack_cmds: Command tracker for event ack commands
- * @devrem_bitmap_sz: Device removal bitmap size
  * @devrem_bitmap: Device removal bitmap
- * @dev_handle_bitmap_sz: Device handle bitmap size
+ * @dev_handle_bitmap_bits: Number of bits in device handle bitmap
  * @removepend_bitmap: Remove pending bitmap
  * @delayed_rmhs_list: Delayed device removal list
- * @evtack_cmds_bitmap_sz: Event Ack bitmap size
  * @evtack_cmds_bitmap: Event Ack bitmap
  * @delayed_evtack_cmds_list: Delayed event acknowledgment list
  * @ts_update_counter: Timestamp update counter
@@ -1128,7 +1125,6 @@ struct mpi3mr_ioc {
 	u32 chain_buf_count;
 	struct dma_pool *chain_buf_pool;
 	struct chain_element *chain_sgl_list;
-	u16  chain_bitmap_sz;
 	void *chain_bitmap;
 	spinlock_t chain_buf_lock;
 
@@ -1136,12 +1132,10 @@ struct mpi3mr_ioc {
 	struct mpi3mr_drv_cmd host_tm_cmds;
 	struct mpi3mr_drv_cmd dev_rmhs_cmds[MPI3MR_NUM_DEVRMCMD];
 	struct mpi3mr_drv_cmd evtack_cmds[MPI3MR_NUM_EVTACKCMD];
-	u16 devrem_bitmap_sz;
 	void *devrem_bitmap;
-	u16 dev_handle_bitmap_sz;
+	u16 dev_handle_bitmap_bits;
 	void *removepend_bitmap;
 	struct list_head delayed_rmhs_list;
-	u16 evtack_cmds_bitmap_sz;
 	void *evtack_cmds_bitmap;
 	struct list_head delayed_evtack_cmds_list;
 
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 0c4aabaefdcc..8ed4566772ca 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -1128,7 +1128,6 @@ static int mpi3mr_issue_and_process_mur(struct mpi3mr_ioc *mrioc,
 static int
 mpi3mr_revalidate_factsdata(struct mpi3mr_ioc *mrioc)
 {
-	u16 dev_handle_bitmap_sz;
 	void *removepend_bitmap;
 
 	if (mrioc->facts.reply_sz > mrioc->reply_sz) {
@@ -1160,25 +1159,24 @@ mpi3mr_revalidate_factsdata(struct mpi3mr_ioc *mrioc)
 		    "\tcontroller while sas transport support is enabled at the\n"
 		    "\tdriver, please reboot the system or reload the driver\n");
 
-	dev_handle_bitmap_sz = mrioc->facts.max_devhandle / 8;
-	if (mrioc->facts.max_devhandle % 8)
-		dev_handle_bitmap_sz++;
-	if (dev_handle_bitmap_sz > mrioc->dev_handle_bitmap_sz) {
-		removepend_bitmap = krealloc(mrioc->removepend_bitmap,
-		    dev_handle_bitmap_sz, GFP_KERNEL);
+	if (mrioc->facts.max_devhandle > mrioc->dev_handle_bitmap_bits) {
+		removepend_bitmap = bitmap_zalloc(mrioc->facts.max_devhandle,
+						  GFP_KERNEL);
 		if (!removepend_bitmap) {
 			ioc_err(mrioc,
-			    "failed to increase removepend_bitmap sz from: %d to %d\n",
-			    mrioc->dev_handle_bitmap_sz, dev_handle_bitmap_sz);
+				"failed to increase removepend_bitmap bits from %d to %d\n",
+				mrioc->dev_handle_bitmap_bits,
+				mrioc->facts.max_devhandle);
 			return -EPERM;
 		}
-		memset(removepend_bitmap + mrioc->dev_handle_bitmap_sz, 0,
-		    dev_handle_bitmap_sz - mrioc->dev_handle_bitmap_sz);
+		bitmap_copy(removepend_bitmap, mrioc->removepend_bitmap,
+			    mrioc->dev_handle_bitmap_bits);
 		mrioc->removepend_bitmap = removepend_bitmap;
 		ioc_info(mrioc,
-		    "increased dev_handle_bitmap_sz from %d to %d\n",
-		    mrioc->dev_handle_bitmap_sz, dev_handle_bitmap_sz);
-		mrioc->dev_handle_bitmap_sz = dev_handle_bitmap_sz;
+			 "increased bits of dev_handle_bitmap from %d to %d\n",
+			 mrioc->dev_handle_bitmap_bits,
+			 mrioc->facts.max_devhandle);
+		mrioc->dev_handle_bitmap_bits = mrioc->facts.max_devhandle;
 	}
 
 	return 0;
@@ -2957,27 +2955,18 @@ static int mpi3mr_alloc_reply_sense_bufs(struct mpi3mr_ioc *mrioc)
 	if (!mrioc->pel_abort_cmd.reply)
 		goto out_failed;
 
-	mrioc->dev_handle_bitmap_sz = mrioc->facts.max_devhandle / 8;
-	if (mrioc->facts.max_devhandle % 8)
-		mrioc->dev_handle_bitmap_sz++;
-	mrioc->removepend_bitmap = kzalloc(mrioc->dev_handle_bitmap_sz,
-	    GFP_KERNEL);
+	mrioc->dev_handle_bitmap_bits = mrioc->facts.max_devhandle;
+	mrioc->removepend_bitmap = bitmap_zalloc(mrioc->dev_handle_bitmap_bits,
+						 GFP_KERNEL);
 	if (!mrioc->removepend_bitmap)
 		goto out_failed;
 
-	mrioc->devrem_bitmap_sz = MPI3MR_NUM_DEVRMCMD / 8;
-	if (MPI3MR_NUM_DEVRMCMD % 8)
-		mrioc->devrem_bitmap_sz++;
-	mrioc->devrem_bitmap = kzalloc(mrioc->devrem_bitmap_sz,
-	    GFP_KERNEL);
+	mrioc->devrem_bitmap = bitmap_zalloc(MPI3MR_NUM_DEVRMCMD, GFP_KERNEL);
 	if (!mrioc->devrem_bitmap)
 		goto out_failed;
 
-	mrioc->evtack_cmds_bitmap_sz = MPI3MR_NUM_EVTACKCMD / 8;
-	if (MPI3MR_NUM_EVTACKCMD % 8)
-		mrioc->evtack_cmds_bitmap_sz++;
-	mrioc->evtack_cmds_bitmap = kzalloc(mrioc->evtack_cmds_bitmap_sz,
-	    GFP_KERNEL);
+	mrioc->evtack_cmds_bitmap = bitmap_zalloc(MPI3MR_NUM_EVTACKCMD,
+						  GFP_KERNEL);
 	if (!mrioc->evtack_cmds_bitmap)
 		goto out_failed;
 
@@ -3415,10 +3404,7 @@ static int mpi3mr_alloc_chain_bufs(struct mpi3mr_ioc *mrioc)
 		if (!mrioc->chain_sgl_list[i].addr)
 			goto out_failed;
 	}
-	mrioc->chain_bitmap_sz = num_chains / 8;
-	if (num_chains % 8)
-		mrioc->chain_bitmap_sz++;
-	mrioc->chain_bitmap = kzalloc(mrioc->chain_bitmap_sz, GFP_KERNEL);
+	mrioc->chain_bitmap = bitmap_zalloc(num_chains, GFP_KERNEL);
 	if (!mrioc->chain_bitmap)
 		goto out_failed;
 	return retval;
@@ -4190,10 +4176,11 @@ void mpi3mr_memset_buffers(struct mpi3mr_ioc *mrioc)
 		for (i = 0; i < MPI3MR_NUM_EVTACKCMD; i++)
 			memset(mrioc->evtack_cmds[i].reply, 0,
 			    sizeof(*mrioc->evtack_cmds[i].reply));
-		memset(mrioc->removepend_bitmap, 0, mrioc->dev_handle_bitmap_sz);
-		memset(mrioc->devrem_bitmap, 0, mrioc->devrem_bitmap_sz);
-		memset(mrioc->evtack_cmds_bitmap, 0,
-		    mrioc->evtack_cmds_bitmap_sz);
+		bitmap_clear(mrioc->removepend_bitmap, 0,
+			     mrioc->dev_handle_bitmap_bits);
+		bitmap_clear(mrioc->devrem_bitmap, 0, MPI3MR_NUM_DEVRMCMD);
+		bitmap_clear(mrioc->evtack_cmds_bitmap, 0,
+			     MPI3MR_NUM_EVTACKCMD);
 	}
 
 	for (i = 0; i < mrioc->num_queues; i++) {
@@ -4887,9 +4874,10 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 
 	mpi3mr_flush_delayed_cmd_lists(mrioc);
 	mpi3mr_flush_drv_cmds(mrioc);
-	memset(mrioc->devrem_bitmap, 0, mrioc->devrem_bitmap_sz);
-	memset(mrioc->removepend_bitmap, 0, mrioc->dev_handle_bitmap_sz);
-	memset(mrioc->evtack_cmds_bitmap, 0, mrioc->evtack_cmds_bitmap_sz);
+	bitmap_clear(mrioc->devrem_bitmap, 0, MPI3MR_NUM_DEVRMCMD);
+	bitmap_clear(mrioc->removepend_bitmap, 0,
+		     mrioc->dev_handle_bitmap_bits);
+	bitmap_clear(mrioc->evtack_cmds_bitmap, 0, MPI3MR_NUM_EVTACKCMD);
 	mpi3mr_flush_host_io(mrioc);
 	mpi3mr_cleanup_fwevt_list(mrioc);
 	mpi3mr_invalidate_devhandles(mrioc);
-- 
2.38.1

