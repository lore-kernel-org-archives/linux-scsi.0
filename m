Return-Path: <SRS0=V0rO=7N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB186C433E2
	for <linux-scsi@archiver.kernel.org>; Sun, 31 May 2020 15:09:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4C6A207C4
	for <linux-scsi@archiver.kernel.org>; Sun, 31 May 2020 15:09:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uPKWmbqu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728272AbgEaPI4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 31 May 2020 11:08:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728252AbgEaPIu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 31 May 2020 11:08:50 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08455C061A0E;
        Sun, 31 May 2020 08:08:50 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id z5so6826523ejb.3;
        Sun, 31 May 2020 08:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MEIjMYiUChbqFAFH7gikTnN2cVqo8tkhFxOw2OxjyaU=;
        b=uPKWmbquwWYeY5eW/cl9nAqdXzw/jh5U6svQPC4aapN5yV+zz9gi2aSPkFDSdngsqj
         qOS7wLyjCgd6tmm+o9JvjlEmadKDLNrK+R3+HtAh99a54pRSXn/iFb5sQmWme+LryTKJ
         GoKFIr5sNIfhChDRObuRtjT9SDL2/bQzDSmk8mMpgpfc0KXfJI26mIDlVfJC9nCSGpoB
         oJv+PuIceaRe/zSxkkEoZdXM/TKECYQBd+fwB97pPumDBniN7si8TM/uF5QWogGvtk7l
         qseS4dx91NabCA8ohoJTyOv9NRtgw8u4UWIAhBWkk9G30gz7I9LhKPZpIYg3mdUk+yA7
         YogA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MEIjMYiUChbqFAFH7gikTnN2cVqo8tkhFxOw2OxjyaU=;
        b=myuU4pqUXHRV+qpwHuhla5Kfalujt99yMHqaDuihh/Zx/mb7HjybnCNyC2qn2VYf2e
         isk+6Sd36uN6KrQ+D/8nRBXsMb4srI4iDEeTA7CCXm6S27YS1HYQZdH6x/nJxWJeKcyx
         j1NsuNiQ3HDhrvD+DcGm9jddMjeYbJfPAbeggPdVQ21bfMHSkgweOWvwNW2jAW4WanIO
         HabPZik0zIgTZCChDSz5Ue9QvrrqDSWp7qM0CixQ020t+MKVSYvdF0FvjRSEDjkGoHpz
         yOFHhQKCO2XG7UclfBJIccLWmcV85ITLIBMQHVasSq/W7Lu/1n+Xc3rGDYh6aJ0Er0qT
         5oCA==
X-Gm-Message-State: AOAM5325j+2gP0cLbYIRJgniNL78rb+vPOGtBZTQ4TUwJwXh0Sj5kkY1
        6uO7e1vL69jUv55OZTuO/tY=
X-Google-Smtp-Source: ABdhPJwl6uguCs5YC7SshKNrvK5ot6uJOWR0R080eVq1DZdYCsj15GQLxNw1iENyVsAo+Qjmn0pwQQ==
X-Received: by 2002:a17:906:6686:: with SMTP id z6mr10337247ejo.258.1590937728748;
        Sun, 31 May 2020 08:08:48 -0700 (PDT)
Received: from localhost.localdomain (ip5f5bfcfd.dynamic.kabel-deutschland.de. [95.91.252.253])
        by smtp.gmail.com with ESMTPSA id a62sm9564928edf.38.2020.05.31.08.08.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 08:08:48 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 5/5] scsi: ufs: add compatibility with 3.1 UFS unit descriptor length
Date:   Sun, 31 May 2020 17:08:31 +0200
Message-Id: <20200531150831.9946-6-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200531150831.9946-1-huobean@gmail.com>
References: <20200531150831.9946-1-huobean@gmail.com>
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
index 6548ef102eb9..332ae09e6238 100644
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
index 45d1fef982a9..a64718bfe2bc 100644
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
 	if (is_kmalloc && param_size > buff_len)
-- 
2.17.1

