Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25911C46467
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Jan 2023 11:31:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbjAOLb5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Jan 2023 06:31:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbjAOLb4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Jan 2023 06:31:56 -0500
X-Greylist: delayed 450 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 15 Jan 2023 03:31:55 PST
Received: from smtp.smtpout.orange.fr (smtp-16.smtpout.orange.fr [80.12.242.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B58DFF778
        for <linux-scsi@vger.kernel.org>; Sun, 15 Jan 2023 03:31:55 -0800 (PST)
Received: from pop-os.home ([86.243.2.178])
        by smtp.orange.fr with ESMTPA
        id H17bpDGm8IopLH17bpa0Ms; Sun, 15 Jan 2023 12:24:23 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 15 Jan 2023 12:24:23 +0100
X-ME-IP: 86.243.2.178
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Bean Huo <beanhuo@micron.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: ufs: core: Fix an error handling path in ufshcd_read_desc_param()
Date:   Sun, 15 Jan 2023 12:24:17 +0100
Message-Id: <2c6e42205e5ec22e5e8c7c85c6deb8fde31c74da.1673781835.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If an error occurs, some memory may need to be freed, as in the other
error handling paths.

Before the commit in the Fixes tag, this test was done before the memory
allocation, so there was no issue.

Fixes: 16ed9d312b42 ("scsi: ufs: core: Remove ufshcd_map_desc_id_to_length()")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/ufs/core/ufshcd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 6ec65dcdd689..097f2489bc91 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3452,7 +3452,8 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
 	if (param_offset >= buff_len) {
 		dev_err(hba->dev, "%s: Invalid offset 0x%x in descriptor IDN 0x%x, length 0x%x\n",
 			__func__, param_offset, desc_id, buff_len);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 
 	/* Sanity check */
-- 
2.34.1

