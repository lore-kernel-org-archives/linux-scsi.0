Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15AD2CA0ECA
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Sep 2023 08:53:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbjILIxu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Sep 2023 04:53:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232362AbjILIxq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Sep 2023 04:53:46 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D044AA
        for <linux-scsi@vger.kernel.org>; Tue, 12 Sep 2023 01:53:42 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B153C433CA;
        Tue, 12 Sep 2023 08:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694508822;
        bh=8GIY0hX/apECJAkq9UrWe0jcYTY0W5t9faqRFMBlVAU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=jNisUFFEwf3D+N3BbHahpQdoh4l8Mu4sNWa+ygMKvBhS4+H5afaqeCsIeAllK4WyW
         sekXQxWaTyWuEfFxKyPQU/8XR/Fl+A0z/1CvWh/rz6f70+p6M9pm3CMZv+hESKwhzN
         gs7ST+gAZKCgez/vE/CIF58o+sqJZy4KfGCubWXXAtZ8RIE5tT4rW72Ed7khsNEbBB
         XcwKm2gf6urWjyNpQYhQvJnDJQPQgA3oojSNK/vcsi1fJYl5Zql5m+92X2Z7s81t30
         qxzHRy73Lx2Pojxjbog2ocIhcgVYwykb459gOowurCkPsO3u5HG3cbL2Gi3tBfDNzc
         ao+i9UQjDMf8A==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 2/3] scsi: libsas: Declare sas_set_phy_speed() static
Date:   Tue, 12 Sep 2023 17:53:37 +0900
Message-ID: <20230912085338.434381-3-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230912085338.434381-1-dlemoal@kernel.org>
References: <20230912085338.434381-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

sas_set_phy_speed() is used only within sas_init.c. Declare this
function as static.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: John Garry <john.g.garry@oracle.com>
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
index 2e800690b127..d3ace28ee41f 100644
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

