Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FE66C77B75
	for <linux-scsi@archiver.kernel.org>; Sun,  7 May 2023 15:23:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231740AbjEGPX6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 May 2023 11:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231706AbjEGPX4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 May 2023 11:23:56 -0400
X-Greylist: delayed 99 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 07 May 2023 08:23:54 PDT
Received: from smtp.smtpout.orange.fr (smtp-18.smtpout.orange.fr [80.12.242.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9B1116368
        for <linux-scsi@vger.kernel.org>; Sun,  7 May 2023 08:23:54 -0700 (PDT)
Received: from pop-os.home ([86.243.2.178])
        by smtp.orange.fr with ESMTPA
        id vgEopnCQ5xJDXvgEopiFxi; Sun, 07 May 2023 17:23:53 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
        s=t20230301; t=1683473033;
        bh=AycFl3TvTFQR8JMUPxB7ny9rxzvemcvxjVhoUuNuY3g=;
        h=From:To:Cc:Subject:Date;
        b=FJhCsrPnMWRaKzE0BgeW7FTqT+wVIic/9IlzqY7WYYIul8w1QKn07alf5sWlQ01Rq
         1B7RFI0ZTDTR2NGrsbWF9BNycY7z8Np8pa7rVmwnv12IEQjePqkz+N9S/Kpb+ORyI5
         eaVQHLdlLbm/0UJrpnUVUPS/7KpIGjvogYjVuB+AWicfKyLH+ckjAW1a9hoeBiRXEQ
         FPsOF2/hcPYJzCXN62X4LDAtMFvl81RhED4QtyolUn9hesXKAiqe0kB1/LTFeB/OTp
         VNXFMNAGLgjDJ76wCs2mVVlNZmM9RCcSUPeGdxdPTV1acWEH83lkwWXtTGxHM5Kc87
         pOodiyjFETJhA==
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 07 May 2023 17:23:53 +0200
X-ME-IP: 86.243.2.178
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH v2] scsi: mpi3mr: Fix the type used for pointers to bitmap
Date:   Sun,  7 May 2023 17:23:49 +0200
Message-Id: <8bdf9148ce1a5d01aac11c46c8617b477813457e.1683473011.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Bitmaps are "unsigned long[]", so better use "unsigned long *" instead of
a plain "void *" when dealing with pointers to bitmaps.

This is more informative.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
v2: Fix some other declaration
---
 drivers/scsi/mpi3mr/mpi3mr.h    | 8 ++++----
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index dfe6b87fe288..0afb687402e1 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -1133,18 +1133,18 @@ struct mpi3mr_ioc {
 	u32 chain_buf_count;
 	struct dma_pool *chain_buf_pool;
 	struct chain_element *chain_sgl_list;
-	void *chain_bitmap;
+	unsigned long *chain_bitmap;
 	spinlock_t chain_buf_lock;
 
 	struct mpi3mr_drv_cmd bsg_cmds;
 	struct mpi3mr_drv_cmd host_tm_cmds;
 	struct mpi3mr_drv_cmd dev_rmhs_cmds[MPI3MR_NUM_DEVRMCMD];
 	struct mpi3mr_drv_cmd evtack_cmds[MPI3MR_NUM_EVTACKCMD];
-	void *devrem_bitmap;
+	unsigned long *devrem_bitmap;
 	u16 dev_handle_bitmap_bits;
-	void *removepend_bitmap;
+	unsigned long *removepend_bitmap;
 	struct list_head delayed_rmhs_list;
-	void *evtack_cmds_bitmap;
+	unsigned long *evtack_cmds_bitmap;
 	struct list_head delayed_evtack_cmds_list;
 
 	u32 ts_update_counter;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 075fa67e95ee..9b56d13821c6 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -1134,7 +1134,7 @@ static int mpi3mr_issue_and_process_mur(struct mpi3mr_ioc *mrioc,
 static int
 mpi3mr_revalidate_factsdata(struct mpi3mr_ioc *mrioc)
 {
-	void *removepend_bitmap;
+	unsigned long *removepend_bitmap;
 
 	if (mrioc->facts.reply_sz > mrioc->reply_sz) {
 		ioc_err(mrioc,
-- 
2.34.1

