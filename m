Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC318C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Mar 2022 09:26:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240822AbiCJJ1i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Mar 2022 04:27:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240803AbiCJJ11 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Mar 2022 04:27:27 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83986139CDF
        for <linux-scsi@vger.kernel.org>; Thu, 10 Mar 2022 01:26:27 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22A1dmHS025048
        for <linux-scsi@vger.kernel.org>; Thu, 10 Mar 2022 01:26:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=3o9u9hpG0BdcU60SfsVn30PCeibyC2mFQBm2nVp/Yuc=;
 b=TmDZSP91ntx5+y/C/SrhU3B6dRtKKshmK4/uNzraAd6N5T0Tfi/uBAL/6IsEgoP6keCR
 HmzLj+bv/FaoiZRNxhUxCBHlDsa6HkcOoEUZ/07581qNPhjIv2/aGk/40Joor8bPqBUh
 ZKkwixl5h4qdD/ygCqlxyw8YPtn/Gq158gmOivMQL2ZUHMtA6Fr77C6+xrCuB97x0UxD
 hZ/wSSMiI4WGElLINmWtitAaIf7U31cKyA7fYJCQ/82kZmkPGKjwrZgoZKu/9kVbkliU
 NRkNR4uIxdtrudIpjqKA65br6r2sZDeLEQ4ZHgBDkCGryUUFizC/Jp7TXHBEfor6G/3n Ng== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3ep38pmd7w-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 10 Mar 2022 01:26:26 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 10 Mar
 2022 01:26:23 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 10 Mar 2022 01:26:23 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 32A333F705D;
        Thu, 10 Mar 2022 01:26:23 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 22A9QNmU023005;
        Thu, 10 Mar 2022 01:26:23 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 22A9QNxu023004;
        Thu, 10 Mar 2022 01:26:23 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 05/13] qla2xxx: Fix crash during module load unload test
Date:   Thu, 10 Mar 2022 01:25:56 -0800
Message-ID: <20220310092604.22950-6-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220310092604.22950-1-njavali@marvell.com>
References: <20220310092604.22950-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: d2fJxanJQVgdajmNT59gDXWOdPkLNUu7
X-Proofpoint-ORIG-GUID: d2fJxanJQVgdajmNT59gDXWOdPkLNUu7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-10_03,2022-03-09_01,2022-02-23_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

During purex packet handling driver was incorrectly
freeing a pre-allocated structure. Fix this by
skipping that entry.

System crashed with the following stack during a
module unload test.

Call Trace:
          sbitmap_init_node+0x7f/0x1e0
          sbitmap_queue_init_node+0x24/0x150
          blk_mq_init_bitmaps+0x3d/0xa0
          blk_mq_init_tags+0x68/0x90
          blk_mq_alloc_map_and_rqs+0x44/0x120
          blk_mq_alloc_set_map_and_rqs+0x63/0x150
          blk_mq_alloc_tag_set+0x11b/0x230
          scsi_add_host_with_dma.cold+0x3f/0x245
          qla2x00_probe_one+0xd5a/0x1b80 [qla2xxx]

Call Trace with slub_debug and debug kernel:
        kasan_report_invalid_free+0x50/0x80
        __kasan_slab_free+0x137/0x150
        slab_free_freelist_hook+0xc6/0x190
        kfree+0xe8/0x2e0
        qla2x00_free_device+0x3bb/0x5d0 [qla2xxx]
        qla2x00_remove_one+0x668/0xcf0 [qla2xxx]

Reported-by: Marco Patalano <mpatalan@redhat.com>
Tested-by: Marco Patalano <mpatalan@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 62e9dd177732 ("scsi: qla2xxx: Change in PUREX to handle FPIN ELS requests")
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index a4546346c18b..d572a76d0fa0 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3904,6 +3904,8 @@ qla24xx_free_purex_list(struct purex_list *list)
 	spin_lock_irqsave(&list->lock, flags);
 	list_for_each_entry_safe(item, next, &list->head, list) {
 		list_del(&item->list);
+		if (item == &item->vha->default_item)
+			continue;
 		kfree(item);
 	}
 	spin_unlock_irqrestore(&list->lock, flags);
-- 
2.19.0.rc0

