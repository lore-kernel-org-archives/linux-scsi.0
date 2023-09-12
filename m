Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61259EE49B7
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Sep 2023 23:05:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237871AbjILXGB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Sep 2023 19:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233926AbjILXGA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Sep 2023 19:06:00 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7759D10CC
        for <linux-scsi@vger.kernel.org>; Tue, 12 Sep 2023 16:05:56 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79427C433C7;
        Tue, 12 Sep 2023 23:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694559956;
        bh=48eF2cgpkycKIzkMa5k5kr5XhEsGILdgX/pUN0n575w=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=lLbA1eMXvo4TGXh7J3yCrZfTHxEX20vBaPcMvOHVTg2t6a8ttEQi44i8puj66rMhm
         zHpVV5dxESFDmHiJa/NM/ZuMjcaCbknSsYQIjNf8OqAvdT9dHu6VNJQQem0lrZN8I+
         k9onM2hPTOT3EXkF2U5vgPXlYumz96a4B+tDpPUHltJGxx30zSZ7efbjQI2yfEGF8B
         yTsw9zc4F/ZZLQdlRSDQhSMBi+JRWahisLM9rnB8XylnjYmODOnALskV1GUA7+s892
         PYoEpnbOgktDpv+Q0tMfzkxqt/QvQE9M+JVFWwf8Tw7TgwgF1VDF/tKbEV0qqgcceF
         nT8B2LGZwwccQ==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 2/3] scsi: libsas: Declare sas_set_phy_speed() static
Date:   Wed, 13 Sep 2023 08:05:50 +0900
Message-ID: <20230912230551.454357-3-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230912230551.454357-1-dlemoal@kernel.org>
References: <20230912230551.454357-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

sas_set_phy_speed() is used only within sas_init.c. Declare this
function as static.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
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

