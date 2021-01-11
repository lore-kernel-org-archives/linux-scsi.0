Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C654C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 04:45:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0710A20782
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 04:45:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727169AbhAKEp0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Jan 2021 23:45:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:48238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726278AbhAKEp0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 10 Jan 2021 23:45:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CDA120782;
        Mon, 11 Jan 2021 04:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610340285;
        bh=v3WIruP3B1wdJRzDgEpDFElbtoKOktc9Qr4F3/oV+Bs=;
        h=From:To:Cc:Subject:Date:From;
        b=I048932AvWOMEUgGKiiTPzl/aNHr662Adg/H5au1RTIHX0KKaVdofSISatA82DIC5
         ww6Am6H6aVY8xwz0yx34aD2DSzWjJpHFINujHh/FH9bwTxKTolmIOSx4L7fDW7+Qs1
         rScv1TZRbDAoukxCvdmqt0c9S7SMDZkvYp9EPtmb4fUXWXV7ILmQu+L+G9RSMlK3tM
         3dhvgYOARYbx+Ew+2LPW4Pd15qXzl18I3eKGrs4TKcKmioINqq4uD9sNedPW0BTTTr
         pLkR/sKeeEZmnxrRRHALi78t8VNbbEOk37xlQD4UNACKKznEHp0L6eS/rmPtuSsxSU
         nlCTHWAzZVApw==
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com
Cc:     cang@codeaurora.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org, martin.petersen@oracle.com,
        stanley.chu@mediatek.com, Jaegeuk Kim <jaegeuk@google.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH] scsi: ufs: should not override buffer lengh
Date:   Sun, 10 Jan 2021 20:44:43 -0800
Message-Id: <20210111044443.1405049-1-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@google.com>

Kernel stack violation when getting unit_descriptor/wb_buf_alloc_units from
rpmb lun. The reason is the unit descriptor length is different per LU.

The lengh of Normal LU is 45, while the one of rpmb LU is 35.

int ufshcd_read_desc_param(struct ufs_hba *hba, ...)
{
	param_offset=41;
	param_size=4;
	buff_len=45;
	...
	buff_len=35 by rpmb LU;

	if (is_kmalloc) {
		/* Make sure we don't copy more data than available */
		if (param_offset + param_size > buff_len)
			param_size = buff_len - param_offset;
			--> param_size = 250;
		memcpy(param_read_buf, &desc_buf[param_offset], param_size);
		--> memcpy(param_read_buf, desc_buf+41, 250);

[  141.868974][ T9174] Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in: wb_buf_alloc_units_show+0x11c/0x11c
	}
}

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 2a715f13fe1d..722697b57777 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3293,8 +3293,12 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
 
 	if (is_kmalloc) {
 		/* Make sure we don't copy more data than available */
-		if (param_offset + param_size > buff_len)
-			param_size = buff_len - param_offset;
+		if (param_offset + param_size > buff_len) {
+			if (buff_len > param_offset)
+				param_size = buff_len - param_offset;
+			else
+				param_size = 0;
+		}
 		memcpy(param_read_buf, &desc_buf[param_offset], param_size);
 	}
 out:
-- 
2.30.0.284.gd98b1dd5eaa7-goog

