Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E4BEC636D4
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Feb 2023 00:50:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbjBNAu2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Feb 2023 19:50:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbjBNAu1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Feb 2023 19:50:27 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E6241A670
        for <linux-scsi@vger.kernel.org>; Mon, 13 Feb 2023 16:50:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1676335826; x=1707871826;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YQuTPaW4hIRSGO+vIWFEKbeot5QnZc28y8iqj05avgo=;
  b=QmPBQa9Oeg0tfWegkef4ims/19a/elfNFuLJxh2+ABO5jLzypuz3aBcK
   dNGEfo2p2QbXYGDiNdaVV2FjmZ5nFn+fXOIdFOeEo+FnG8/nypSDeGFU9
   S7sdWywkfS2sgn7eNggRI/DOZgTAU64ZDqV4+BT7+Nbvaydl3ZAiRYcG5
   OxWLMK2PuPaokr6K8mKglO06Ds/JNxwW4t0L/vbvtgos/9zIJ+Ippy4Pp
   PU7qESI+l4vDkHStpPW+YhVCK2O5F6qYj6Ty6xRg280R5g+E7PUCaH5Tb
   LL8xgMl02FDK0oPjNptUS+Wk24dod/1Vs90fZft0q+khlcMMkFDEAMnAF
   g==;
X-IronPort-AV: E=Sophos;i="5.97,294,1669046400"; 
   d="scan'208";a="228193161"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Feb 2023 08:50:26 +0800
IronPort-SDR: 4V6mNLBwj/bzkVqhuaikHPB16Lg2p2+VN/tL4sJXipOUveW4a3mASz9Vx+eGRg6MMg8KTRPmtD
 Nc6q1W6ZKEz+JfhToVnpKmHRYELSmC9j1f/yco7ID4Bo3YA6MZc7OJSTk2sx3Y1i9A2bdQp5Qv
 vGrPCkgB/xPvVTggoAvuNzcXLb49kI1kySMNo/uoRhBzUaQkT6ROSQI/JFd/Xu1SvGSwQqI9EE
 o80nPvBCW3HvEAl3r5M2uovJG3KPnYhoPNuFv4CefZ6bNZ9TF6Kt+lbgteXRLJi+XExkuE9WZj
 Iak=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Feb 2023 16:07:34 -0800
IronPort-SDR: CcLsQ/mWbE+eOU04cmkuSjJhYz0/IPzFP5C2LCHUsLcWV2VrEWS5f+MFWfnrpdqFEQzcyRLm2U
 iuWWTAtoBExeY17mgvWGA86QShddOzDemKL9h+1sVw73qItF+QtqEtphtUrrlZx7SzyDLvKDLp
 Zv7vCFW52UZ/j8m3Zs/4gFKozlDCpK6FKx3JQPdeLHcQXyJDJm/IP0hV8igkGnt/Mly5d4Xk7V
 q656Bsirs9CmKaGp3WyBh6IzvpBPYkNz8i/qMuEh8hv6dn7oyYeSs24ZGKIqmvxXX+cYsIemop
 t4o=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 13 Feb 2023 16:50:25 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     linux-scsi@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com
Cc:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v5 3/4] scsi: mpi3mr: use number of bits to manage bitmap sizes
Date:   Tue, 14 Feb 2023 09:50:18 +0900
Message-Id: <20230214005019.1897251-4-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230214005019.1897251-1-shinichiro.kawasaki@wdc.com>
References: <20230214005019.1897251-1-shinichiro.kawasaki@wdc.com>
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
kzalloc and krealloc. For memory free, call bitmap_free instead of
kfree. For zero clear, call bitmap_clear instead of memset.

Remove three fields for bitmap byte sizes in struct scmd_priv, which are
no longer required. Replace the field dev_handle_bitmap_sz with
dev_handle_bitmap_bits to keep number of bits of removepend_bitmap
across resize.

Fixes: c5758fc72b92 ("scsi: mpi3mr: Gracefully handle online FW update operation")
Fixes: e844adb1fbdc ("scsi: mpi3mr: Implement SCSI error handler hooks")
Fixes: c1af985d27da ("scsi: mpi3mr: Add Event acknowledgment logic")
Fixes: 824a156633df ("scsi: mpi3mr: Base driver code")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h    | 10 +----
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 75 ++++++++++++++-------------------
 2 files changed, 33 insertions(+), 52 deletions(-)

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
index 286a44506578..758f7ca9e0ee 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -1128,7 +1128,6 @@ static int mpi3mr_issue_and_process_mur(struct mpi3mr_ioc *mrioc,
 static int
 mpi3mr_revalidate_factsdata(struct mpi3mr_ioc *mrioc)
 {
-	u16 dev_handle_bitmap_sz;
 	void *removepend_bitmap;
 
 	if (mrioc->facts.reply_sz > mrioc->reply_sz) {
@@ -1160,25 +1159,23 @@ mpi3mr_revalidate_factsdata(struct mpi3mr_ioc *mrioc)
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
+		bitmap_free(mrioc->removepend_bitmap);
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
@@ -2957,27 +2954,18 @@ static int mpi3mr_alloc_reply_sense_bufs(struct mpi3mr_ioc *mrioc)
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
 
@@ -3415,10 +3403,7 @@ static int mpi3mr_alloc_chain_bufs(struct mpi3mr_ioc *mrioc)
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
@@ -4189,10 +4174,11 @@ void mpi3mr_memset_buffers(struct mpi3mr_ioc *mrioc)
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
@@ -4318,16 +4304,16 @@ void mpi3mr_free_mem(struct mpi3mr_ioc *mrioc)
 		mrioc->evtack_cmds[i].reply = NULL;
 	}
 
-	kfree(mrioc->removepend_bitmap);
+	bitmap_free(mrioc->removepend_bitmap);
 	mrioc->removepend_bitmap = NULL;
 
-	kfree(mrioc->devrem_bitmap);
+	bitmap_free(mrioc->devrem_bitmap);
 	mrioc->devrem_bitmap = NULL;
 
-	kfree(mrioc->evtack_cmds_bitmap);
+	bitmap_free(mrioc->evtack_cmds_bitmap);
 	mrioc->evtack_cmds_bitmap = NULL;
 
-	kfree(mrioc->chain_bitmap);
+	bitmap_free(mrioc->chain_bitmap);
 	mrioc->chain_bitmap = NULL;
 
 	kfree(mrioc->transport_cmds.reply);
@@ -4886,9 +4872,10 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 
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

