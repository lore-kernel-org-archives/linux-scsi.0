Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 468FBC433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 24 Oct 2021 19:48:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2645A60E96
	for <linux-scsi@archiver.kernel.org>; Sun, 24 Oct 2021 19:48:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232093AbhJXTug (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 24 Oct 2021 15:50:36 -0400
Received: from smtp01.smtpout.orange.fr ([80.12.242.123]:59105 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231300AbhJXTuf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Oct 2021 15:50:35 -0400
Received: from pop-os.home ([92.140.161.106])
        by smtp.orange.fr with ESMTPA
        id ejTWmbi84dmYbejTWmLmaJ; Sun, 24 Oct 2021 21:48:12 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 24 Oct 2021 21:48:12 +0200
X-ME-IP: 92.140.161.106
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     james.smart@broadcom.com, ram.vegesna@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com, dwagner@suse.de,
        hare@suse.de
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] scsi: elx: libefc_sli: Use 'bitmap_zalloc()' when applicable
Date:   Sun, 24 Oct 2021 21:48:09 +0200
Message-Id: <2a0a83949fb896a0a236dcca94dfdc8486d489f5.1635104793.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

'sli4->ext[i].use_map' is a bitmap. Use 'bitmap_zalloc()' to simplify code,
improve the semantic and avoid some open-coded arithmetic in allocator
arguments.

Also change the corresponding 'kfree()' into 'bitmap_free()' to keep
consistency.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/scsi/elx/libefc_sli/sli4.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/elx/libefc_sli/sli4.c b/drivers/scsi/elx/libefc_sli/sli4.c
index 6c6c04e1b74d..907d67aeac23 100644
--- a/drivers/scsi/elx/libefc_sli/sli4.c
+++ b/drivers/scsi/elx/libefc_sli/sli4.c
@@ -4145,7 +4145,7 @@ static int
 sli_get_read_config(struct sli4 *sli4)
 {
 	struct sli4_rsp_read_config *conf = sli4->bmbx.virt;
-	u32 i, total, total_size;
+	u32 i, total;
 	u32 *base;
 
 	if (sli_cmd_read_config(sli4, sli4->bmbx.virt)) {
@@ -4203,8 +4203,7 @@ sli_get_read_config(struct sli4 *sli4)
 
 	for (i = 0; i < SLI4_RSRC_MAX; i++) {
 		total = sli4->ext[i].number * sli4->ext[i].size;
-		total_size = BITS_TO_LONGS(total) * sizeof(long);
-		sli4->ext[i].use_map = kzalloc(total_size, GFP_KERNEL);
+		sli4->ext[i].use_map = bitmap_zalloc(total, GFP_KERNEL);
 		if (!sli4->ext[i].use_map) {
 			efc_log_err(sli4, "bitmap memory allocation failed %d\n",
 				    i);
@@ -4743,7 +4742,7 @@ sli_reset(struct sli4 *sli4)
 	sli4->ext[0].base = NULL;
 
 	for (i = 0; i < SLI4_RSRC_MAX; i++) {
-		kfree(sli4->ext[i].use_map);
+		bitmap_free(sli4->ext[i].use_map);
 		sli4->ext[i].use_map = NULL;
 		sli4->ext[i].base = NULL;
 	}
@@ -4784,7 +4783,7 @@ sli_teardown(struct sli4 *sli4)
 	for (i = 0; i < SLI4_RSRC_MAX; i++) {
 		sli4->ext[i].base = NULL;
 
-		kfree(sli4->ext[i].use_map);
+		bitmap_free(sli4->ext[i].use_map);
 		sli4->ext[i].use_map = NULL;
 	}
 
-- 
2.30.2

