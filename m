Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC0CCC4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Dec 2022 00:53:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233852AbiLMAxS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Dec 2022 19:53:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233770AbiLMAw4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Dec 2022 19:52:56 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A2B17E39
        for <linux-scsi@vger.kernel.org>; Mon, 12 Dec 2022 16:52:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1670892768; x=1702428768;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CITLkV6jqLkcssff6KJ4K/xdSW+1v5gn9eBOn8qgMMQ=;
  b=qt/ch5n49DTkRoyAl+0pdSrvZRG6JYBxR6ShWrABC3byiIT/eDf+YnEh
   u+eqaX/2fuGTy94XMkcYU0QV8nLd0R9l1Pye0ReTSdVlHgY8vYXRq/tgp
   LX4tSTg+31YRyj7TonKjMuJAGxeTJAnw/QpNqZ8Nbhdm3yVhqs7bFh6oT
   jKr4O6lZvj9lxvykTMxvHEPl0HHFU2Nv85EcEoUVhIA7xbMqj3pf+fkhJ
   7wSLZfWiHH5KnciJ2sgoaH59nncWMLwadfWLuqoXmRmd4kUUMHRAJajaF
   ggyKZ1nQiMP9uQ+tQPYvaIK1FsWWotV861OkEQlpCzIMJNVZXTpddMjEf
   A==;
X-IronPort-AV: E=Sophos;i="5.96,239,1665417600"; 
   d="scan'208";a="223646013"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 13 Dec 2022 08:52:48 +0800
IronPort-SDR: rZh3m+QXW31XwcpU839nN0st1v/N/TllYES4hzoIh+OCOfDaUR/OkvjpYqgos6Rpfy2EIT/UDQ
 lROMvUiPxcOUdscPHmdB3coJahuvfIgy+FysaklQDxM2ONmAjxFsn496lhPyj4iIsqWQd4w0zy
 5HaZuApp8at6O93dY6vCh+OO7bt8zYQApRglfo/VcUmHejrUIap97QeZqLS/ipYapwg/N9JyA8
 9OMbmMDOUzqaNyTZ9G3/j1Sb5LWntkXm9gAa86snk3BVOeHWZoJZP0+hnhxoBSwgD0+WUir+0p
 MV8=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Dec 2022 16:11:12 -0800
IronPort-SDR: xowe6KyJGCxFiSeEnZwkEZpeZnp4kSAuik+sKzPP3q4Zg0HYQwFXL4pOrFUNatTdb7Jozq83Ff
 09Gw9TZdgTKd/vrPHnKzvf39PWfV/OOyyaaFsyCKvAih34Sv7EfiTi4ysHYUGe2gy1sZDiaxSS
 8l18N9f5zZ7oxZLJdrsr6fb1YRjMgjnRon1IXRoyy/TifwAAT/mqssilnglOxR/lKL6+IEaJ+R
 HjPdfs7qve9F5hZdvOVZTvRpgPU+lZBxaCQGI3UwRRQSocB+pDUNvi0WQOfUuX9d29VBCe6QiG
 y3Y=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 12 Dec 2022 16:52:47 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     linux-scsi@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com
Cc:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 2/3] scsi: mpi3mr: use number of bits to manage bitmap sizes
Date:   Tue, 13 Dec 2022 09:52:42 +0900
Message-Id: <20221213005243.2727877-3-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221213005243.2727877-1-shinichiro.kawasaki@wdc.com>
References: <20221213005243.2727877-1-shinichiro.kawasaki@wdc.com>
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
2.37.1

