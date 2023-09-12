Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1A6FCA0ECE
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Sep 2023 07:47:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231789AbjILHr1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Sep 2023 03:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231765AbjILHrZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Sep 2023 03:47:25 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77C4BE78
        for <linux-scsi@vger.kernel.org>; Tue, 12 Sep 2023 00:47:21 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52545C433C8;
        Tue, 12 Sep 2023 07:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694504841;
        bh=dDb2OR13rU8PBckEAenZVXz29tsHo+xkQPOI0ocl4Sk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=jLr473wNMX+SVsw+7I9V/qFe4hCh1AYAt3llr4uKBSlWdKxIWGZdBr8M2YMEdmcA7
         DIyS8O0cEBHoRk8phPBjzc9k/zoSRL3qq77COEEtNyOM1LfdBdEcLK9AnUl/QlTKP1
         YnGaAK7W5b0hsl1FJKjSaIjuv0QEkAe2drR1klY8DPjk+pQ7G3VDY9SCg36kacR/V7
         ygQhIBVLdNhFxBfNb9A3TKcMVHfFeCnWxcOsr6cYY1GIxdeF5/uQwHNxHIrEitiZzU
         rBuwUk5lWI/nY9hzS78fcOa0Qrr/UQGIhpOwd+NFytslICVbAGpSSLrvFTPOfyxLiz
         fZBedJ2QBZ8Jg==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 2/3] scsi: libsas: Declare sas_set_phy_speed() static
Date:   Tue, 12 Sep 2023 16:47:14 +0900
Message-ID: <20230912074715.424062-3-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230912074715.424062-1-dlemoal@kernel.org>
References: <20230912074715.424062-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

sas_set_phy_speed() is used only within sas_init.c. Declare this
function as static.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/libsas/sas_init.c | 4 ++--
 include/scsi/libsas.h          | 1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index 8586dc79f2a0..9c8cc723170d 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -315,8 +315,8 @@ int sas_phy_reset(struct sas_phy *phy, int hard_reset)
 }
 EXPORT_SYMBOL_GPL(sas_phy_reset);
 
-int sas_set_phy_speed(struct sas_phy *phy,
-		      struct sas_phy_linkrates *rates)
+static int sas_set_phy_speed(struct sas_phy *phy,
+			     struct sas_phy_linkrates *rates)
 {
 	int ret;
 
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 87f194925b3c..5ee86b225359 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -679,7 +679,6 @@ extern void sas_resume_ha(struct sas_ha_struct *sas_ha);
 extern void sas_resume_ha_no_sync(struct sas_ha_struct *sas_ha);
 extern void sas_suspend_ha(struct sas_ha_struct *sas_ha);
 
-int sas_set_phy_speed(struct sas_phy *phy, struct sas_phy_linkrates *rates);
 int sas_phy_reset(struct sas_phy *phy, int hard_reset);
 int sas_phy_enable(struct sas_phy *phy, int enable);
 extern int sas_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
-- 
2.41.0

