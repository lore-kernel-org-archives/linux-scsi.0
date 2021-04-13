Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9A0AC43470
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 17:07:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0A8C613B7
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 17:07:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347133AbhDMRIL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 13:08:11 -0400
Received: from mail-pg1-f177.google.com ([209.85.215.177]:38735 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347120AbhDMRIE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 13:08:04 -0400
Received: by mail-pg1-f177.google.com with SMTP id w10so12400868pgh.5
        for <linux-scsi@vger.kernel.org>; Tue, 13 Apr 2021 10:07:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rFXmVizIQL6C4Iz8cpLnIDm4ABF9jZDW6wKSe2yCIWU=;
        b=mkorC6Lti5awlJMtTy4T6ovjOWEJcvvJpzdguCKSIjYcpDEDtV1+fVkHc2fHoJ8Jga
         KsuvAAupaCoWhOfzQuU52rPt9T9Z7xKEdHDo8mgGiZCY4jP3oeHN4oeyn7WUlHOQM7Wo
         k35yTPSbrvx/08TCpnqv9J5BBhLvtVEJLuqOItVdSihy/vEM6hOn3Z8eV+oirNL3F+Ss
         eCdLevP2WnWxoM4yFJ3VuP359fcEQycVH6VMtzD5YvB8rNv4VYzkodCF90VUgwx99uwa
         Mg8rYDSHZyp/s08HPFj4hU1wr3GTvehx69jsMr4GvQk1qtNfvvAacWyFXx6MRn25bndi
         DiEQ==
X-Gm-Message-State: AOAM530I8IVzNcukBkIf7QHSCmSkOPBBxUf09fXNQvgrwz/9Bwak5Ay0
        2QwLsFD7q/WM7qkz+4xI1gI=
X-Google-Smtp-Source: ABdhPJzA/O6U3qzBBt0SRWMjhILbReHXBiHpnIrzd8wlObcYGvlCJt2kNbV/57rWiW0OsD9ao54TDg==
X-Received: by 2002:a63:145a:: with SMTP id 26mr23823559pgu.300.1618333663857;
        Tue, 13 Apr 2021 10:07:43 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:345f:c70d:97e0:e2ef])
        by smtp.gmail.com with ESMTPSA id z10sm6736078pfe.218.2021.04.13.10.07.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 10:07:43 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 19/20] target: Fix several format specifiers
Date:   Tue, 13 Apr 2021 10:07:13 -0700
Message-Id: <20210413170714.2119-20-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210413170714.2119-1-bvanassche@acm.org>
References: <20210413170714.2119-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use format specifier '%u' to format the u32 and int data types instead of
'%hu'.

Cc: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/target_core_configfs.c | 6 +++---
 drivers/target/target_core_pr.c       | 6 ++----
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 9cb1ca8421c8..01005a9e5128 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2746,7 +2746,7 @@ static ssize_t target_tg_pt_gp_alua_access_state_store(struct config_item *item,
 
 	if (!tg_pt_gp->tg_pt_gp_valid_id) {
 		pr_err("Unable to do implicit ALUA on non valid"
-			" tg_pt_gp ID: %hu\n", tg_pt_gp->tg_pt_gp_valid_id);
+			" tg_pt_gp ID: %u\n", tg_pt_gp->tg_pt_gp_valid_id);
 		return -EINVAL;
 	}
 	if (!target_dev_configured(dev)) {
@@ -2798,7 +2798,7 @@ static ssize_t target_tg_pt_gp_alua_access_status_store(
 
 	if (!tg_pt_gp->tg_pt_gp_valid_id) {
 		pr_err("Unable to do set ALUA access status on non"
-			" valid tg_pt_gp ID: %hu\n",
+			" valid tg_pt_gp ID: %u\n",
 			tg_pt_gp->tg_pt_gp_valid_id);
 		return -EINVAL;
 	}
@@ -2853,7 +2853,7 @@ static ssize_t target_tg_pt_gp_alua_support_##_name##_store(		\
 									\
 	if (!t->tg_pt_gp_valid_id) {					\
 		pr_err("Unable to do set " #_name " ALUA state on non"	\
-		       " valid tg_pt_gp ID: %hu\n",			\
+		       " valid tg_pt_gp ID: %u\n",			\
 		       t->tg_pt_gp_valid_id);				\
 		return -EINVAL;						\
 	}								\
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index d61dc166bc5f..6fd5fec95539 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -1637,8 +1637,7 @@ core_scsi3_decode_spec_i_port(
 			}
 
 			dest_tpg = tmp_tpg;
-			pr_debug("SPC-3 PR SPEC_I_PT: Located %s Node:"
-				" %s Port RTPI: %hu\n",
+			pr_debug("SPC-3 PR SPEC_I_PT: Located %s Node: %s Port RTPI: %u\n",
 				dest_tpg->se_tpg_tfo->fabric_name,
 				dest_node_acl->initiatorname, dest_rtpi);
 
@@ -1675,8 +1674,7 @@ core_scsi3_decode_spec_i_port(
 		dest_se_deve = core_get_se_deve_from_rtpi(dest_node_acl,
 					dest_rtpi);
 		if (!dest_se_deve) {
-			pr_err("Unable to locate %s dest_se_deve"
-				" from destination RTPI: %hu\n",
+			pr_err("Unable to locate %s dest_se_deve from destination RTPI: %u\n",
 				dest_tpg->se_tpg_tfo->fabric_name,
 				dest_rtpi);
 
