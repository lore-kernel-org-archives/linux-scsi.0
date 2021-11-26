Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67E39C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Nov 2021 21:17:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241777AbhKZVUn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Nov 2021 16:20:43 -0500
Received: from smtp01.smtpout.orange.fr ([80.12.242.123]:59499 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240653AbhKZVSn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Nov 2021 16:18:43 -0500
Received: from pop-os.home ([86.243.171.122])
        by smtp.orange.fr with ESMTPA
        id qiZ3mXh0q1UGBqiZ4m0pfI; Fri, 26 Nov 2021 22:15:27 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Fri, 26 Nov 2021 22:15:27 +0100
X-ME-IP: 86.243.171.122
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     john.garry@huawei.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 1/3] scsi: hisi_sas: Use devm_bitmap_zalloc() when applicable
Date:   Fri, 26 Nov 2021 22:15:21 +0100
Message-Id: <4afa3f71e66c941c660627c7f5b0223b51968ebb.1637961191.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

'hisi_hba->slot_index_tags' is a bitmap. So use 'devm_bitmap_zalloc()' to
simplify code, improve the semantic and avoid some open-coded arithmetic
in allocator arguments.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
The use of 's' is questionable here. I've left it because it looks more
consistent this way with the surrounding code.

Can it be an issue to have the length of the allocated bitmap not being
a multiple of sizeof(long)?
I guess that there is some kind of 'rounding' done by the memory allocator
to keep some alignment, so I think that the previous code is safe (but not
logical).
If this is not the case, there is a potential out of bound bug related to
the bitmap API that expect to access only longs (which is not necessarily
the case here).
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index f206c433de32..6ecb42d5ce81 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -2516,9 +2516,8 @@ int hisi_sas_alloc(struct hisi_hba *hisi_hba)
 	if (!hisi_hba->breakpoint)
 		goto err_out;
 
-	hisi_hba->slot_index_count = max_command_entries;
-	s = hisi_hba->slot_index_count / BITS_PER_BYTE;
-	hisi_hba->slot_index_tags = devm_kzalloc(dev, s, GFP_KERNEL);
+	s = hisi_hba->slot_index_count = max_command_entries;
+	hisi_hba->slot_index_tags = devm_bitmap_zalloc(dev, s, GFP_KERNEL);
 	if (!hisi_hba->slot_index_tags)
 		goto err_out;
 
-- 
2.30.2

