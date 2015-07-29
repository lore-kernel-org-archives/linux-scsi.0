From: <Viswas.G@pmcs.com>
Subject: [PATCH 1/8] pm80xx: Updated link rate
Date: Wed, 29 Jul 2015 11:57:13 +0530
Message-ID: <1438151240-4097-2-git-send-email-Viswas.G@pmcs.com>
References: <1438151240-4097-1-git-send-email-Viswas.G@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:35331 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751790AbbG2G0B (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jul 2015 02:26:01 -0400
In-Reply-To: <1438151240-4097-1-git-send-email-Viswas.G@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: xjtuwjp@gmail.com, JBottomley@parallels.com, Tomas Henzl <thenzl@redhat.com>, Suresh.Thiagarajan@pmcs.com, Viswas.G@pmcs.com

From: Viswas G <Viswas.G@pmcs.com>


Updated 12G linkrate to libsas.

Signed-off-by: Viswas G <Viswas.G@pmcs.com>
Signed-off-by: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com> 

---
 drivers/scsi/pm8001/pm8001_defs.h |    1 +
 drivers/scsi/pm8001/pm8001_hwi.c  |    4 ++++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_defs.h b/drivers/scsi/pm8001/pm8001_defs.h
index 74a4bb9..d4d20cc 100644
--- a/drivers/scsi/pm8001/pm8001_defs.h
+++ b/drivers/scsi/pm8001/pm8001_defs.h
@@ -56,6 +56,7 @@ enum phy_speed {
 	PHY_SPEED_15 = 0x01,
 	PHY_SPEED_30 = 0x02,
 	PHY_SPEED_60 = 0x04,
+	PHY_SPEED_120 = 0x08,
 };
 
 enum data_direction {
diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 96dcc09..39306b1 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -3263,6 +3263,10 @@ void pm8001_get_lrate_mode(struct pm8001_phy *phy, u8 link_rate)
 	struct sas_phy *sas_phy = phy->sas_phy.phy;
 
 	switch (link_rate) {
+	case PHY_SPEED_120:
+		phy->sas_phy.linkrate = SAS_LINK_RATE_12_0_GBPS;
+		phy->sas_phy.phy->negotiated_linkrate = SAS_LINK_RATE_12_0_GBPS;
+		break;
 	case PHY_SPEED_60:
 		phy->sas_phy.linkrate = SAS_LINK_RATE_6_0_GBPS;
 		phy->sas_phy.phy->negotiated_linkrate = SAS_LINK_RATE_6_0_GBPS;
-- 
1.7.1

