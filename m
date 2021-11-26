Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0F30C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Nov 2021 21:20:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241648AbhKZVYD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Nov 2021 16:24:03 -0500
Received: from smtp01.smtpout.orange.fr ([80.12.242.123]:53823 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242915AbhKZVV6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Nov 2021 16:21:58 -0500
Received: from pop-os.home ([86.243.171.122])
        by smtp.orange.fr with ESMTPA
        id qic7mXi0d1UGBqicGm0pwP; Fri, 26 Nov 2021 22:18:44 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Fri, 26 Nov 2021 22:18:44 +0100
X-ME-IP: 86.243.171.122
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     john.garry@huawei.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 3/3] scsi: hisi_sas: Use non-atomic bitmap functions when possible
Date:   Fri, 26 Nov 2021 22:18:26 +0100
Message-Id: <8ee33e463523db080e6a2c06f332e47abb69359b.1637961191.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <4afa3f71e66c941c660627c7f5b0223b51968ebb.1637961191.git.christophe.jaillet@wanadoo.fr>
References: <4afa3f71e66c941c660627c7f5b0223b51968ebb.1637961191.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

All uses of the 'hisi_hba->slot_index_tags' bitmap are protected with the
'hisi_hba->lock' spinlock.

So prefer the non-atomic '__[set|clear]_bit()' functions to save a few
cycles.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index d4f5d093bde4..889c36fa9309 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -158,7 +158,7 @@ static void hisi_sas_slot_index_clear(struct hisi_hba *hisi_hba, int slot_idx)
 {
 	void *bitmap = hisi_hba->slot_index_tags;
 
-	clear_bit(slot_idx, bitmap);
+	__clear_bit(slot_idx, bitmap);
 }
 
 static void hisi_sas_slot_index_free(struct hisi_hba *hisi_hba, int slot_idx)
@@ -175,7 +175,7 @@ static void hisi_sas_slot_index_set(struct hisi_hba *hisi_hba, int slot_idx)
 {
 	void *bitmap = hisi_hba->slot_index_tags;
 
-	set_bit(slot_idx, bitmap);
+	__set_bit(slot_idx, bitmap);
 }
 
 static int hisi_sas_slot_index_alloc(struct hisi_hba *hisi_hba,
-- 
2.30.2

