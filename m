Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E34A4C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 08:31:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDBC860FBF
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 08:31:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237979AbhIMIcR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 04:32:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238000AbhIMIcQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Sep 2021 04:32:16 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C133C061766
        for <linux-scsi@vger.kernel.org>; Mon, 13 Sep 2021 01:31:01 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id n4so5299320plh.9
        for <linux-scsi@vger.kernel.org>; Mon, 13 Sep 2021 01:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k6I3d4QKUMqIFCVSWNnfeEYQvKn1IjGnWO5CPP3tbKc=;
        b=TvuLbeIwW1YvhiX08c0wNlQ21TsxKVuLLI+ovDMvnsmMbWjEy+la+dJz6hf6qyDPvE
         J98VmubaRWJ6pG5ga+bAnNRrOjdxCXTtes+2bMtOvH1itxiNccyH/JERcYEjnvasUEoR
         3xBKmSbNldjQ0XYpvDaWzTl/lfw2bH8iBNCZziuM3UzrniKEpbtwOgmKF/GOc3/xp+7c
         bwbrOy9AxhonYgYnfgNkiWVjyYC57Psd38bPR3gVm8t9nHMHA1Y5aBpGTfgY0eikAyxf
         H5ALMNEzg7OJwFOZC9jtKJzR5CjeSm8vKm9XubyFMa9324CmB8GxNnV1CWmNmJn25Rdv
         KQNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k6I3d4QKUMqIFCVSWNnfeEYQvKn1IjGnWO5CPP3tbKc=;
        b=n/z2AOOlJuWBJam2D84yJpYreH+WacNKWisxIp+LKFVechEGpXuFFejUhVIpgNiQI3
         t5c/J/xfcpvUdeuwGJmIZO+I2K4ZTnKvW3h5P6TOTM4WR8r5y03kpBnzO7E3SiqKKcdN
         JvzFVsErBO5gHS8GLXzF7lv0VJO4EQ00iP5dk5oCUXg2SVH4JoG3IByXIPGGt/U/uwE3
         IhX1AWddQjkjsWLGOTl7wJG2myvUMdz+BjBd/8AULgBcEII5MLSf5ui/+f30BxNs5fEy
         AMxJAkn9XLwIeCHRtCB/D7XcWhQC/MY6mj55sqbqxFXlTeJik4+ngzuMn9ULpJha2vqH
         VYnw==
X-Gm-Message-State: AOAM530RSVPJqmpKuN/XcSZO1h4Y5vKHqbS5O7jgeLYBx9bJV9BL7HJy
        3MEvygZ/8bGDwZvhni4nf23YmaUyhAMNlA==
X-Google-Smtp-Source: ABdhPJy708a65NoXpk1Fs8oKCw+Q6uhx47rfcqy2ceY930ZlJs+8vq0HJDkCkvNjC2upMmcZbr48Hw==
X-Received: by 2002:a17:902:b095:b029:12c:de88:7d3b with SMTP id p21-20020a170902b095b029012cde887d3bmr9560829plr.15.1631521860434;
        Mon, 13 Sep 2021 01:31:00 -0700 (PDT)
Received: from 64-217.. ([103.97.201.33])
        by smtp.gmail.com with ESMTPSA id mv1sm5873493pjb.29.2021.09.13.01.30.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 01:30:59 -0700 (PDT)
From:   Li Feng <fengli@smartx.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org (open list:SCSI TARGET SUBSYSTEM),
        target-devel@vger.kernel.org (open list:SCSI TARGET SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Cc:     Li Feng <fengli@smartx.com>
Subject: [PATCH] scsi: target: Remove unused argument of some functions
Date:   Mon, 13 Sep 2021 16:30:45 +0800
Message-Id: <20210913083045.3670648-1-fengli@smartx.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The se_cmd is unused in these functions, just remove it.
Signed-off-by: Li Feng <fengli@smartx.com>
---
 drivers/target/target_core_xcopy.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index d4fe7cb2bd00..6bb20aa9c5bc 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -295,8 +295,7 @@ static int target_xcopy_parse_target_descriptors(struct se_cmd *se_cmd,
 	return -EINVAL;
 }
 
-static int target_xcopy_parse_segdesc_02(struct se_cmd *se_cmd, struct xcopy_op *xop,
-					unsigned char *p)
+static int target_xcopy_parse_segdesc_02(struct xcopy_op *xop, unsigned char *p)
 {
 	unsigned char *desc = p;
 	int dc = (desc[1] & 0x02);
@@ -332,9 +331,9 @@ static int target_xcopy_parse_segdesc_02(struct se_cmd *se_cmd, struct xcopy_op
 	return 0;
 }
 
-static int target_xcopy_parse_segment_descriptors(struct se_cmd *se_cmd,
-				struct xcopy_op *xop, unsigned char *p,
-				unsigned int sdll, sense_reason_t *sense_ret)
+static int target_xcopy_parse_segment_descriptors(struct xcopy_op *xop,
+				unsigned char *p, unsigned int sdll,
+				sense_reason_t *sense_ret)
 {
 	unsigned char *desc = p;
 	unsigned int start = 0;
@@ -362,7 +361,7 @@ static int target_xcopy_parse_segment_descriptors(struct se_cmd *se_cmd,
 		 */
 		switch (desc[0]) {
 		case 0x02:
-			rc = target_xcopy_parse_segdesc_02(se_cmd, xop, desc);
+			rc = target_xcopy_parse_segdesc_02(xop, desc);
 			if (rc < 0)
 				goto out;
 
@@ -840,8 +839,7 @@ static sense_reason_t target_parse_xcopy_cmd(struct xcopy_op *xop)
 	 */
 	seg_desc = &p[16] + tdll;
 
-	rc = target_xcopy_parse_segment_descriptors(se_cmd, xop, seg_desc,
-						    sdll, &ret);
+	rc = target_xcopy_parse_segment_descriptors(xop, seg_desc, sdll, &ret);
 	if (rc <= 0)
 		goto out;
 
-- 
2.31.1

