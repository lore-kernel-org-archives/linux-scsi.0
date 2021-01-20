Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ABABC4332B
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jan 2021 03:36:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A45023109
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jan 2021 03:36:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731792AbhATC3X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jan 2021 21:29:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:47354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730755AbhATB3Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Jan 2021 20:29:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F7F523440;
        Wed, 20 Jan 2021 01:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611106067;
        bh=G0hwRYnbXc6l/tV8pex+dZGLS2ecO09b9ad3GWlMxkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BYFTrseT4K4OeSvv3iwaDaML/QAvQwehdzz31yME8lKFuYaqlb2oDCPF9t4XgdVU2
         VBWo70XaKr6lfD/Dn1JL+4YqS3YbOQyvWt72k98A2cKV6Ai3djF4LzkwIShoSs/nma
         C0FPNumL+pEA7tgqndXZgl4sV3qYK0F7pF66NO8nVGMu7qyZAxs+KR83MxQrG8ML9v
         q7x2qgSsLdCh6sAzoZfihNEIYvfFlW+c+BHuDfLJC4536teDzeAT7sHcmW7MYoaFIi
         rpiRpI3l3uwyr64MjQSotwIm0DcouX5ICCRtOUKE4kuJwtDTBCaxogwr4JCX0suV1b
         Zv9SBLZybEkOw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nilesh Javali <njavali@marvell.com>, Lee Duncan <lduncan@suse.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 04/15] scsi: qedi: Correct max length of CHAP secret
Date:   Tue, 19 Jan 2021 20:27:29 -0500
Message-Id: <20210120012740.770354-4-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012740.770354-1-sashal@kernel.org>
References: <20210120012740.770354-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Nilesh Javali <njavali@marvell.com>

[ Upstream commit d50c7986fbf0e2167279e110a2ed5bd8e811c660 ]

The CHAP secret displayed garbage characters causing iSCSI login
authentication failure. Correct the CHAP password max length.

Link: https://lore.kernel.org/r/20201217105144.8055-1-njavali@marvell.com
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedi/qedi_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index eaa50328de90c..e201c163ea1c8 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -2129,7 +2129,7 @@ qedi_show_boot_tgt_info(struct qedi_ctx *qedi, int type,
 			     chap_name);
 		break;
 	case ISCSI_BOOT_TGT_CHAP_SECRET:
-		rc = sprintf(buf, "%.*s\n", NVM_ISCSI_CFG_CHAP_NAME_MAX_LEN,
+		rc = sprintf(buf, "%.*s\n", NVM_ISCSI_CFG_CHAP_PWD_MAX_LEN,
 			     chap_secret);
 		break;
 	case ISCSI_BOOT_TGT_REV_CHAP_NAME:
@@ -2137,7 +2137,7 @@ qedi_show_boot_tgt_info(struct qedi_ctx *qedi, int type,
 			     mchap_name);
 		break;
 	case ISCSI_BOOT_TGT_REV_CHAP_SECRET:
-		rc = sprintf(buf, "%.*s\n", NVM_ISCSI_CFG_CHAP_NAME_MAX_LEN,
+		rc = sprintf(buf, "%.*s\n", NVM_ISCSI_CFG_CHAP_PWD_MAX_LEN,
 			     mchap_secret);
 		break;
 	case ISCSI_BOOT_TGT_FLAGS:
-- 
2.27.0

