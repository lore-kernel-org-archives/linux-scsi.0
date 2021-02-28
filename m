Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E80FBC433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 06:00:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C238064E0F
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 06:00:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbhB1GA5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Feb 2021 01:00:57 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:30790 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbhB1GAv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Feb 2021 01:00:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614492050; x=1646028050;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tCXTOesn64fsAQikVkAZ/PeVOCP1HPHoYAPxZhx39Vw=;
  b=kKZI5CLZPStnPOVtbKreQcxuR0u0ecq0vzFEB4ysLv5RAJ8NWxBtlqKP
   UzZWqASHRLIOJIdn6VY3DU9cqngDsG61A4DzpuaSbS14TYgJx9xgvwqUM
   sI1Y9DYdrAX0CXk+lY5aMhb5eJapKeXug+yKF/LKJU2j09PyJDDlbeFO0
   36CELPzLCboSBQDfJOTddfSCkPxI4mGbhLImKrcH8v2dMgUyXVs05+ZWJ
   mVtlrC+NWStSN6r++CMo9saWY0HWL5dKUbVG98mxnxmNAtN2qZiBhzNgL
   fjXYpJJj0Ehl7V+yWbm40MW3ig5qrte2SIfmvTUSeNYXZGlwYq6MJRUbb
   w==;
IronPort-SDR: YjztxMNDfgLOBpO31GV8qMlxErYP8DWIo4gb0igegenSQweY+FO3AzHkYt+V/i/1+KRwl6Wh2V
 lAP8pRsqbYxdgXeKjXgsIj5VSoykjsRcV440xm6gB1YyxG11AL3JwtKv9inP/76U4VzafiEWDX
 ypVUUmwyNOE4PpEZOav538Tgo9TZRNhNWlDiAyj2CJJW9qxdwDQxBDS7rJhKWGmeNDAroOGYCN
 dLjWUBy0qmDt/G2wDzwbTmiX1ANflkl09tVnqtmkqMF+xPNlF5/2NrKulDHe7FFLvfVX+sj6ad
 89E=
X-IronPort-AV: E=Sophos;i="5.81,211,1610380800"; 
   d="scan'208";a="160972997"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Feb 2021 13:59:09 +0800
IronPort-SDR: +LxA4Iq0a6qVmcu1LyEan6GBB/HYWExt9bxCJ4T7YA4TDkADtZr/TTxuQYCL7iC/BIrau1D+FG
 Bg1Ek2qc946xQ2P4N2Ddt1cOlAJ+0dHy0yrsQvRmO2zduPIHkHkQt3stoit4wswvd8cz0w12rX
 84SNxcA2goMmHV3+3fEdrS/tAdXLUWMh0uyEFtosiokYqPO7ydlP8X+ExFrTMCcFsgfqQ3Xcz/
 jmWGEeTOycICO8qfJpG9tnGTxCIX47J3jmSfYVZUlOoIqtCNkkURGLO4ktMJdbTDSlbxpa4nF4
 A95/TyjRa+kuARSwAG3x0EVe
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2021 21:40:28 -0800
IronPort-SDR: QwYpMdK3VfqdjcuEoXn05nm+JES2/a3sTUkMJApcrOjc/kMTHZatZ0+NjHqiALS9TWcs8yM2ed
 L4n95lorUa3QC2+ZRYgBft3dZTxsdhNXgtqORhEJDKWemJiTuiEe/O726AfE7tZwAK6OrfPvht
 2xI6QIaEfipVTj9sWJxZ0Bx2wKL1swJGO9VgxlgqPZi2UTCcN5VvmHmw50XGr8mtjGwu5mxelp
 WH+iNZwef+9f4XdG5D6YX8x3V1MvBp5VywV/TLmifDv/8H1OxSDILwXKX319b07/1ANIQFZROz
 3eQ=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Feb 2021 21:59:09 -0800
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, jejb@linux.ibm.com,
        mlombard@redhat.com, michael.christie@oracle.com,
        bvanassche@acm.org, houpu@bytedance.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH 15/23] target/configfs: remove the memset with declare-init
Date:   Sat, 27 Feb 2021 21:56:37 -0800
Message-Id: <20210228055645.22253-16-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.22.1.dirty
In-Reply-To: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
References: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of initializing the array with memset, use declare init pattern
that is present under the kernel tree in other drivers so we can remove
the memset call.

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 drivers/target/target_core_configfs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 4c60334a1e9f..315791b5554a 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2283,7 +2283,7 @@ static ssize_t target_dev_alua_lu_gp_store(struct config_item *item,
 	struct se_hba *hba = dev->se_hba;
 	struct t10_alua_lu_gp *lu_gp = NULL, *lu_gp_new = NULL;
 	struct t10_alua_lu_gp_member *lu_gp_mem;
-	unsigned char buf[LU_GROUP_NAME_BUF];
+	unsigned char buf[LU_GROUP_NAME_BUF] = { };
 	int move = 0;
 
 	lu_gp_mem = dev->dev_alua_lu_gp_mem;
@@ -2294,7 +2294,6 @@ static ssize_t target_dev_alua_lu_gp_store(struct config_item *item,
 		pr_err("ALUA LU Group Alias too large!\n");
 		return -EINVAL;
 	}
-	memset(buf, 0, LU_GROUP_NAME_BUF);
 	memcpy(buf, page, count);
 	/*
 	 * Any ALUA logical unit alias besides "NULL" means we will be
-- 
2.22.1

