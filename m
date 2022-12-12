Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BE40C4167B
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Dec 2022 01:57:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbiLLB5O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Dec 2022 20:57:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230466AbiLLB5M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Dec 2022 20:57:12 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2848DD105
        for <linux-scsi@vger.kernel.org>; Sun, 11 Dec 2022 17:57:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1670810231; x=1702346231;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=O05rZULrHHkSjmvsVyESJCuotaDAlzqN1bbUwhFACh8=;
  b=TGZfh9RRTGKw/jMZ9P0uAYaVH9Ej763fqWtX8UUVmd+1LYfEVOOFUAy4
   10WOxhYJSzZq7PQEn9eg/4q/QTguQt8nrIWUom42O8/qhGYizg5NK+w0q
   Qbe2yHL8WoZ1RoeaxjZxSL+fYcx5gx9RKlhOzx2D36bz7ZaEClQ04vX0m
   XWn60Mo/rxfPi3iulbvJiLRd2aTMruLv7lFctKM1gCHOAHQi5HKnXAnza
   sC0DgFi3KhbileFHS6bzXFcYiOzB/Hs21z9E85QXJt4WxR5+u2ZCtss0Q
   R7rYOjaH5PSwCRC0QHsUmG26J/S8f3Bqx2wkQ/NVCt+smvKYufdaplsUq
   A==;
X-IronPort-AV: E=Sophos;i="5.96,237,1665417600"; 
   d="scan'208";a="218660145"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 12 Dec 2022 09:57:10 +0800
IronPort-SDR: gQNbEOmJlLL/0J16TOQgnMo1kIR0lByfzL0UPg3sPRTeeKizjg5j1s1yhGis/ovUQIifUmpDSl
 WtMjivy1GrPEjXHGF98iCGrOlsG3c5cSHg6NNEanTJEWCWwaa7uESa4nZJ7wIlaDq+9onXjFnV
 JqAOt/IrxNGIPQtlaLic2CZN+mLy9hNpaC33Sd80CVRQFCOSIWzvTV9JJH5Ojc4LWR/x/YUTua
 wODERZ2dy3+X/Ih0JjmABbjmg35ziFMugQfAPGEmN2pFhjlz0n8hK1Y4EsWTF9qiM60/Qb02v/
 oyI=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Dec 2022 17:15:36 -0800
IronPort-SDR: vZxV3EAWUSGp6Qwf7ljLZA/wPJwEiZuvcxbkhBgRTgvYK4D8JgZuzNF2nco2+gvfbvLutozMeC
 JbIGyNJxD/lPp2IBajM7ezpWwbCFSh8guSSVDAb3Us1k7ViTpBJMXjGVgHxPxEDcQQWvQzICzH
 Wmg33pIou3nHhTfGW0XuQ10st2hWhLfQ86igfFsptSMdAutjxkQ58UzNvylhPqBptZ5/oUkksr
 /eFUNl9g/FlbTQ3LkL/6xAOoNVBrg8fRCZb86EwG3n6VTsfbKoutxPjqlYs6WBCxI4CEibKl8r
 MN4=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 11 Dec 2022 17:57:09 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     linux-scsi@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com
Cc:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH 2/3] scsi: mpi3mr: fix bitmap memory size calculation
Date:   Mon, 12 Dec 2022 10:57:05 +0900
Message-Id: <20221212015706.2609544-3-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221212015706.2609544-1-shinichiro.kawasaki@wdc.com>
References: <20221212015706.2609544-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

To allocate memory for bitmaps, the mpi3mr driver calculates sizes of
each bitmap using byte as unit. However, bit operation helper functions
assume that bitmaps are allocated using unsigned long as unit. This gap
causes memory access beyond the bitmap memory size and results in "BUG:
KASAN: slab-out-of-bounds". The BUG was observed at firmware download to
eHBA-9600. Call trace indicated that the out-of-bounds access happened
in find_first_zero_bit called from mpi3mr_send_event_ack for the bitmap
miroc->evtack_cmds_bitmap.

To avoid the BUG, fix bitmap size calculations using unsigned long as
unit. Apply this fix to five places to cover all bitmap size
calculations in the driver.

Fixes: c5758fc72b92 ("scsi: mpi3mr: Gracefully handle online FW update operation")
Fixes: e844adb1fbdc ("scsi: mpi3mr: Implement SCSI error handler hooks")
Fixes: c1af985d27da ("scsi: mpi3mr: Add Event acknowledgment logic")
Fixes: 824a156633df ("scsi: mpi3mr: Base driver code")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 0c4aabaefdcc..272c318387b7 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -1160,9 +1160,8 @@ mpi3mr_revalidate_factsdata(struct mpi3mr_ioc *mrioc)
 		    "\tcontroller while sas transport support is enabled at the\n"
 		    "\tdriver, please reboot the system or reload the driver\n");
 
-	dev_handle_bitmap_sz = mrioc->facts.max_devhandle / 8;
-	if (mrioc->facts.max_devhandle % 8)
-		dev_handle_bitmap_sz++;
+	dev_handle_bitmap_sz = sizeof(unsigned long) *
+		DIV_ROUND_UP(mrioc->facts.max_devhandle, BITS_PER_LONG);
 	if (dev_handle_bitmap_sz > mrioc->dev_handle_bitmap_sz) {
 		removepend_bitmap = krealloc(mrioc->removepend_bitmap,
 		    dev_handle_bitmap_sz, GFP_KERNEL);
@@ -2957,25 +2956,22 @@ static int mpi3mr_alloc_reply_sense_bufs(struct mpi3mr_ioc *mrioc)
 	if (!mrioc->pel_abort_cmd.reply)
 		goto out_failed;
 
-	mrioc->dev_handle_bitmap_sz = mrioc->facts.max_devhandle / 8;
-	if (mrioc->facts.max_devhandle % 8)
-		mrioc->dev_handle_bitmap_sz++;
+	mrioc->dev_handle_bitmap_sz = sizeof(unsigned long) *
+		DIV_ROUND_UP(mrioc->facts.max_devhandle, BITS_PER_LONG);
 	mrioc->removepend_bitmap = kzalloc(mrioc->dev_handle_bitmap_sz,
 	    GFP_KERNEL);
 	if (!mrioc->removepend_bitmap)
 		goto out_failed;
 
-	mrioc->devrem_bitmap_sz = MPI3MR_NUM_DEVRMCMD / 8;
-	if (MPI3MR_NUM_DEVRMCMD % 8)
-		mrioc->devrem_bitmap_sz++;
+	mrioc->devrem_bitmap_sz = sizeof(unsigned long) *
+		DIV_ROUND_UP(MPI3MR_NUM_DEVRMCMD, BITS_PER_LONG);
 	mrioc->devrem_bitmap = kzalloc(mrioc->devrem_bitmap_sz,
 	    GFP_KERNEL);
 	if (!mrioc->devrem_bitmap)
 		goto out_failed;
 
-	mrioc->evtack_cmds_bitmap_sz = MPI3MR_NUM_EVTACKCMD / 8;
-	if (MPI3MR_NUM_EVTACKCMD % 8)
-		mrioc->evtack_cmds_bitmap_sz++;
+	mrioc->evtack_cmds_bitmap_sz = sizeof(unsigned long) *
+		DIV_ROUND_UP(MPI3MR_NUM_EVTACKCMD, BITS_PER_LONG);
 	mrioc->evtack_cmds_bitmap = kzalloc(mrioc->evtack_cmds_bitmap_sz,
 	    GFP_KERNEL);
 	if (!mrioc->evtack_cmds_bitmap)
@@ -3415,9 +3411,8 @@ static int mpi3mr_alloc_chain_bufs(struct mpi3mr_ioc *mrioc)
 		if (!mrioc->chain_sgl_list[i].addr)
 			goto out_failed;
 	}
-	mrioc->chain_bitmap_sz = num_chains / 8;
-	if (num_chains % 8)
-		mrioc->chain_bitmap_sz++;
+	mrioc->chain_bitmap_sz = sizeof(unsigned long) *
+		DIV_ROUND_UP(num_chains, BITS_PER_LONG);
 	mrioc->chain_bitmap = kzalloc(mrioc->chain_bitmap_sz, GFP_KERNEL);
 	if (!mrioc->chain_bitmap)
 		goto out_failed;
-- 
2.37.1

