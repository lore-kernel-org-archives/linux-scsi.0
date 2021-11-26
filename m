Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56D2EC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Nov 2021 21:20:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241565AbhKZVXw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Nov 2021 16:23:52 -0500
Received: from smtp01.smtpout.orange.fr ([80.12.242.123]:56922 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241624AbhKZVVu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Nov 2021 16:21:50 -0500
Received: from pop-os.home ([86.243.171.122])
        by smtp.orange.fr with ESMTPA
        id qic7mXi0d1UGBqic8m0pvc; Fri, 26 Nov 2021 22:18:36 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Fri, 26 Nov 2021 22:18:36 +0100
X-ME-IP: 86.243.171.122
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     john.garry@huawei.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 2/3] scsi: hisi_sas: Remove some useless code in 'hisi_sas_alloc()'
Date:   Fri, 26 Nov 2021 22:18:25 +0100
Message-Id: <41c86e7e3e05a13bd586d8ee1b81296140b7a6eb.1637961191.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <4afa3f71e66c941c660627c7f5b0223b51968ebb.1637961191.git.christophe.jaillet@wanadoo.fr>
References: <4afa3f71e66c941c660627c7f5b0223b51968ebb.1637961191.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The 'hisi_hba->slot_index_tags' bitmap is allocated with 'bitmap_zalloc()'
so it is already cleared.

There is no need to clear it another time, one bit at a time.

So, remove the corresponding useless code.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 6ecb42d5ce81..d4f5d093bde4 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -206,14 +206,6 @@ static int hisi_sas_slot_index_alloc(struct hisi_hba *hisi_hba,
 	return index;
 }
 
-static void hisi_sas_slot_index_init(struct hisi_hba *hisi_hba)
-{
-	int i;
-
-	for (i = 0; i < hisi_hba->slot_index_count; ++i)
-		hisi_sas_slot_index_clear(hisi_hba, i);
-}
-
 void hisi_sas_slot_task_free(struct hisi_hba *hisi_hba, struct sas_task *task,
 			     struct hisi_sas_slot *slot)
 {
@@ -2535,7 +2527,6 @@ int hisi_sas_alloc(struct hisi_hba *hisi_hba)
 	if (!hisi_hba->sata_breakpoint)
 		goto err_out;
 
-	hisi_sas_slot_index_init(hisi_hba);
 	hisi_hba->last_slot_index = HISI_SAS_UNRESERVED_IPTT;
 
 	hisi_hba->wq = create_singlethread_workqueue(dev_name(dev));
-- 
2.30.2

