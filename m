Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24B19C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jul 2022 17:52:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235880AbiGGRwS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jul 2022 13:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235888AbiGGRwR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2022 13:52:17 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78C495A2CB
        for <linux-scsi@vger.kernel.org>; Thu,  7 Jul 2022 10:52:16 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id y37-20020a056a001ca500b00528bbf82c1eso3878334pfw.10
        for <linux-scsi@vger.kernel.org>; Thu, 07 Jul 2022 10:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=BCD/UPLA849PB90VlTORzUwtOo6cTD56r/SSsY1YZSw=;
        b=nBMiV5Mo5yBHjen2CRHgi/YEy69wJ02g+92NKj+rhzEuhL4OKVt1aRU6/mlZRX79YR
         JJdADXUhYKkTcNvG5QBENLDMueliK3z0SY9dXV424H7H7kiVOdrX2Qd0zKwRPTrzZxEf
         RwS5xnUviky6t6GwlVcrFfBO4wjnZGifbb5V4pWammNQk5ozpIKbRGr2CaYZvh1XqWqI
         0/mpTVzAsnbVqKzrvvYVwoNSr4VZ/zcWmEg8VvllKQewlyQGf43YVKuge1ZXCa/GbL04
         Va37rxA8TUzOD/EAvegXoxJ3yDwY+dZ+BEM+RWjCEUQdzsw7g1Y1VLv7h/5puoZVUcmp
         Xymg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=BCD/UPLA849PB90VlTORzUwtOo6cTD56r/SSsY1YZSw=;
        b=n49uxRaxVHjur+lsUDwA8qyI9MHephyQipOYQScAKkXZBjdwBag3S8u4i9IudI24h1
         dpXhZ3lbNr4wCJKqKjXYnqpJK53J1qN+He5XHhX30BKnCjtzrX1HqPfrZ7XxuHEyK34V
         W3zMIkWetGV4Eno2nJ9J80fpfmAUy3iR5ckn4LqX4SA0B3jtt981ho1hukRdhXgaJd5J
         aFuNmR0VcGpXjILbtYf/ELDZv8cFhGaj4Z/9HlM0Xft4irgVQy6TlV2BK7fa9b3mlaDA
         iLDKykzAgzSYfpO0AYmetWUWj75b2kWXE05JipK7+69Qcp4uMo335q+36fcOtdbXw6C8
         EkpA==
X-Gm-Message-State: AJIora8G2BwY1VtJbCbm7oq5RvsG8aY5csRwdUqr8dfArcXqW4jYL9nq
        zRgcjHHZCFsLXt5WZzfdR464CnA7PuRUMYdw
X-Google-Smtp-Source: AGRyM1sablTTPRB1lQ+Pt+B4WZU1EOBR1g6L8t4s+pAou+xor1DJcHhW+hxZ9VWd5TUIpmk3N5cAkoIfr4UotMEZ
X-Received: from changyuanl-desktop.svl.corp.google.com ([2620:15c:2c5:13:1635:ec61:7abe:233e])
 (user=changyuanl job=sendgmr) by 2002:a17:903:44b:b0:16b:ec58:3727 with SMTP
 id iw11-20020a170903044b00b0016bec583727mr18548323plb.171.1657216336007; Thu,
 07 Jul 2022 10:52:16 -0700 (PDT)
Date:   Thu,  7 Jul 2022 10:52:10 -0700
Message-Id: <20220707175210.528858-1-changyuanl@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH] scsi: pm80xx: Fix 'Unknown' max/min linkrate
From:   Changyuan Lyu <changyuanl@google.com>
To:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Changyuan Lyu <changyuanl@google.com>,
        Igor Pylypiv <ipylypiv@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently, the dataflow of the max/min linkrate in the driver is
* in pm8001_get_lrate_mode():
  hardcoded value ==> struct sas_phy
* in pm8001_bytes_dmaed():
  struct pm8001_phy ==> struct sas_phy
* in pm8001_phy_control():
  libsas data ==> struct pm8001_phy

Since pm8001_bytes_dmaed() follows pm8001_get_lrate_mode(), and
the fields in struct pm8001_phy are not initialized, sysfs
`/sys/class/sas_phy/phy-*/maximum_linkrate` always shows `Unknown`.

To fix the issue, this patch changes the dataflow to the following:
* in pm8001_phy_init():
  initial value ==> struct pm8001_phy
* in pm8001_get_lrate_mode():
  struct pm8001_phy ==> struct sas_phy
* in pm8001_phy_control():
  libsas data ==> struct pm8001_phy

For negotiated linkrate, the current dataflow is
* in pm8001_get_lrate_mode():
  iomb data ==> struct asd_sas_phy ==> struct sas_phy
* in pm8001_bytes_dmaed():
  struct asd_sas_phy ==> struct sas_phy

Since pm8001_bytes_dmaed() follows pm8001_get_lrate_mode(), the
assignment statements in pm8001_bytes_dmaed() are unnecessary and
cleaned up.

Signed-off-by: Changyuan Lyu <changyuanl@google.com>
Reviewed-by: Igor Pylypiv <ipylypiv@google.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c  | 19 +++----------------
 drivers/scsi/pm8001/pm8001_init.c |  2 ++
 2 files changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index f7466a895d3b..991eb01bb1e0 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -3145,15 +3145,6 @@ void pm8001_bytes_dmaed(struct pm8001_hba_info *pm8001_ha, int i)
 	if (!phy->phy_attached)
 		return;
 
-	if (sas_phy->phy) {
-		struct sas_phy *sphy = sas_phy->phy;
-		sphy->negotiated_linkrate = sas_phy->linkrate;
-		sphy->minimum_linkrate = phy->minimum_linkrate;
-		sphy->minimum_linkrate_hw = SAS_LINK_RATE_1_5_GBPS;
-		sphy->maximum_linkrate = phy->maximum_linkrate;
-		sphy->maximum_linkrate_hw = phy->maximum_linkrate;
-	}
-
 	if (phy->phy_type & PORT_TYPE_SAS) {
 		struct sas_identify_frame *id;
 		id = (struct sas_identify_frame *)phy->frame_rcvd;
@@ -3177,26 +3168,22 @@ void pm8001_get_lrate_mode(struct pm8001_phy *phy, u8 link_rate)
 	switch (link_rate) {
 	case PHY_SPEED_120:
 		phy->sas_phy.linkrate = SAS_LINK_RATE_12_0_GBPS;
-		phy->sas_phy.phy->negotiated_linkrate = SAS_LINK_RATE_12_0_GBPS;
 		break;
 	case PHY_SPEED_60:
 		phy->sas_phy.linkrate = SAS_LINK_RATE_6_0_GBPS;
-		phy->sas_phy.phy->negotiated_linkrate = SAS_LINK_RATE_6_0_GBPS;
 		break;
 	case PHY_SPEED_30:
 		phy->sas_phy.linkrate = SAS_LINK_RATE_3_0_GBPS;
-		phy->sas_phy.phy->negotiated_linkrate = SAS_LINK_RATE_3_0_GBPS;
 		break;
 	case PHY_SPEED_15:
 		phy->sas_phy.linkrate = SAS_LINK_RATE_1_5_GBPS;
-		phy->sas_phy.phy->negotiated_linkrate = SAS_LINK_RATE_1_5_GBPS;
 		break;
 	}
 	sas_phy->negotiated_linkrate = phy->sas_phy.linkrate;
-	sas_phy->maximum_linkrate_hw = SAS_LINK_RATE_6_0_GBPS;
+	sas_phy->maximum_linkrate_hw = phy->maximum_linkrate;
 	sas_phy->minimum_linkrate_hw = SAS_LINK_RATE_1_5_GBPS;
-	sas_phy->maximum_linkrate = SAS_LINK_RATE_6_0_GBPS;
-	sas_phy->minimum_linkrate = SAS_LINK_RATE_1_5_GBPS;
+	sas_phy->maximum_linkrate = phy->maximum_linkrate;
+	sas_phy->minimum_linkrate = phy->minimum_linkrate;
 }
 
 /**
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 9b04f1a6a67d..01f2f41928eb 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -143,6 +143,8 @@ static void pm8001_phy_init(struct pm8001_hba_info *pm8001_ha, int phy_id)
 	struct asd_sas_phy *sas_phy = &phy->sas_phy;
 	phy->phy_state = PHY_LINK_DISABLE;
 	phy->pm8001_ha = pm8001_ha;
+	phy->minimum_linkrate = SAS_LINK_RATE_1_5_GBPS;
+	phy->maximum_linkrate = SAS_LINK_RATE_6_0_GBPS;
 	sas_phy->enabled = (phy_id < pm8001_ha->chip->n_phy) ? 1 : 0;
 	sas_phy->class = SAS;
 	sas_phy->iproto = SAS_PROTOCOL_ALL;
-- 
2.37.0.rc0.161.g10f37bed90-goog

