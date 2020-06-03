Return-Path: <SRS0=gfFE=7Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 257D7C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Jun 2020 09:20:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05FAB20825
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Jun 2020 09:20:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a1dRKcsX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726888AbgFCJUc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Jun 2020 05:20:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbgFCJU1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jun 2020 05:20:27 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D84EC05BD43;
        Wed,  3 Jun 2020 02:20:25 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id f7so1391157ejq.6;
        Wed, 03 Jun 2020 02:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Q95qHoKQVgshqw0ghfJQeL4NL6m9CpdNwWifAaKLFtc=;
        b=a1dRKcsXzPT7/8nWrC4VZaeR7YDw02C/6aHacGu5vuOLbvbvwCyiF2dyNYk5DyJ3Kl
         MAwO8gypA1msXDmORABgyDYQODgRevPwvvOddPfYkxvocIpBNYhRdICe+0PVaGcnPpbw
         AASLFSQRL/MkeLNui2tEMXLMXDY868Bj8AMb5yJ9/7fRAK/vQ+ma+/khX+KiaoWRiJ3o
         vBk45uVjCPubkPcywcAPWRY28S03tEVe2vUFozKS0ancrlRbQ5aXG4EujqnMZQ938+G5
         qlWcov5+CydFFhht1xEpEw2UxUWMXDGc1JpYTFHYZOzs/tDVuKaBMerpUB2lBzRr51/S
         PQog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Q95qHoKQVgshqw0ghfJQeL4NL6m9CpdNwWifAaKLFtc=;
        b=L030gZ94B8xz1+ef2vzBbhcxglP4h/IWtsha7MlLZ4l65Y8grrqyfyWSIyDV7YBrpo
         6Za0HLD9zR5/4ne8RR/h7ZelETEa4ngmGJTHbQ3gYQpfvjLc7q6XKMvKLiGhi0Elx/0X
         /Dm5Su+4NuSZAIGLAelTxaqLY17hX9aSvOd3x2W3lZnKzGMkau6e8zXG3L8jaztZOIv6
         OP4FBZLST+tBvd7EG/3S/5Sdaos8obeRggGYxP2IoA2NC3gT0ksmDzXrzhL2xMeyDq/j
         tQuIK+zoM2DiUWtc9u0Z7LCOM32simx+14dE0OQduq+V62CKw9zYpBoaFkB49zf4QgGn
         69VA==
X-Gm-Message-State: AOAM530bBG8KfknegoRkzvFher/pUfuxRd2UtdahDFluDmfyeHB2VDb5
        vnGxn80wPZEfsOaCmtqOUWE=
X-Google-Smtp-Source: ABdhPJz2YuxsHU8XJEnnqJiRuVIc8v0w9TR6f+5y6O8Uy9eveeYV2eS4etq0B0vYPFhh908E2u0qtQ==
X-Received: by 2002:a17:906:6156:: with SMTP id p22mr25758769ejl.329.1591176023678;
        Wed, 03 Jun 2020 02:20:23 -0700 (PDT)
Received: from localhost.localdomain ([2a01:598:d00c:464c:92b:aecc:3637:dc7c])
        by smtp.gmail.com with ESMTPSA id 64sm865636eda.85.2020.06.03.02.20.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 02:20:23 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        beanhuo@outlook.com
Subject: [RESENT PATCH v5 5/5] scsi: ufs: add compatibility with 3.1 UFS unit descriptor length
Date:   Wed,  3 Jun 2020 11:19:59 +0200
Message-Id: <20200603091959.27618-6-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200603091959.27618-1-huobean@gmail.com>
References: <20200603091959.27618-1-huobean@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

For UFS 3.1, the normal unit descriptor is 10 bytes larger
than the RPMB unit, however, both descriptors share the same
desc_idn, to cover both unit descriptors with one length, we
choose the normal unit descriptor length by desc_index.

Signed-off-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufs.h    |  1 +
 drivers/scsi/ufs/ufshcd.c | 11 ++++++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 8770255b5dc0..250e1a905a14 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -63,6 +63,7 @@
 #define UFS_UPIU_MAX_UNIT_NUM_ID	0x7F
 #define UFS_MAX_LUNS		(SCSI_W_LUN_BASE + UFS_UPIU_MAX_UNIT_NUM_ID)
 #define UFS_UPIU_WLUN_ID	(1 << 7)
+#define UFS_RPMB_UNIT		0xC4
 
 /* WriteBooster buffer is available only for the logical unit from 0 to 7 */
 #define UFS_UPIU_MAX_WB_LUN_ID	8
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 5ad0eebccc98..f283b9eb97ac 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3070,11 +3070,16 @@ void ufshcd_map_desc_id_to_length(struct ufs_hba *hba, enum desc_idn desc_id,
 EXPORT_SYMBOL(ufshcd_map_desc_id_to_length);
 
 static void ufshcd_update_desc_length(struct ufs_hba *hba,
-				      enum desc_idn desc_id,
+				      enum desc_idn desc_id, int desc_index,
 				      unsigned char desc_len)
 {
 	if (hba->desc_size[desc_id] == QUERY_DESC_MAX_SIZE &&
-	    desc_id != QUERY_DESC_IDN_STRING)
+	    desc_id != QUERY_DESC_IDN_STRING && desc_index != UFS_RPMB_UNIT)
+		/* For UFS 3.1, the normal unit descriptor is 10 bytes larger
+		 * than the RPMB unit, however, both descriptors share the same
+		 * desc_idn, to cover both unit descriptors with one length, we
+		 * choose the normal unit descriptor length by desc_index.
+		 */
 		hba->desc_size[desc_id] = desc_len;
 }
 
@@ -3143,7 +3148,7 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
 
 	/* Update descriptor length */
 	buff_len = desc_buf[QUERY_DESC_LENGTH_OFFSET];
-	ufshcd_update_desc_length(hba, desc_id, buff_len);
+	ufshcd_update_desc_length(hba, desc_id, desc_index, buff_len);
 
 	/* Check wherher we will not copy more data, than available */
 	if (is_kmalloc && (param_offset + param_size) > buff_len)
-- 
2.17.1

