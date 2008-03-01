From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] mvsas: plumb in phy speeds
Date: Sat, 01 Mar 2008 11:20:22 -0600
Message-ID: <1204392022.4003.108.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40959 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754205AbYCARUZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Mar 2008 12:20:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ke Wei <kewei.mv@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

The current mvsas driver doesn't display any link speeds in /sys.  This
is because it doesn't actually initialise any.  Make mvsas initialise
the correct sas_phy link speeds in mvs_update_phyinfo() (remembering
that it might be called too early in the init sequence to have a phy).

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

---

diff --git a/drivers/scsi/mvsas.c b/drivers/scsi/mvsas.c
index 5ec0665..158568a 100755
--- a/drivers/scsi/mvsas.c
+++ b/drivers/scsi/mvsas.c
@@ -1049,6 +1049,7 @@ static void mvs_scan_start(struct Scsi_Host *shost)
 	struct mvs_info *mvi = SHOST_TO_SAS_HA(shost)->lldd_ha;
 
 	for (i = 0; i < mvi->chip->n_phy; ++i) {
+		mvs_update_phyinfo(mvi, i, 0);
 		mvs_bytes_dmaed(mvi, i);
 	}
 }
@@ -2524,6 +2531,17 @@ static void mvs_update_phyinfo(struct mvs_info *mvi, int i,
 		sas_phy->linkrate =
 			(phy->phy_status & PHY_NEG_SPP_PHYS_LINK_RATE_MASK) >>
 				PHY_NEG_SPP_PHYS_LINK_RATE_MASK_OFFSET;
+		if (sas_phy->phy) {
+			struct sas_phy *sphy = sas_phy->phy;
+
+			sphy->negotiated_linkrate = sas_phy->linkrate;
+			sphy->minimum_linkrate =
+				(phy->phy_status & PHY_MIN_SPP_PHYS_LINK_RATE_MASK) >> 8;
+			sphy->minimum_linkrate_hw = SAS_LINK_RATE_1_5_GBPS;
+			sphy->maximum_linkrate = 
+				(phy->phy_status & PHY_MAX_SPP_PHYS_LINK_RATE_MASK) >> 12;
+			sphy->maximum_linkrate_hw = SAS_LINK_RATE_3_0_GBPS;
+		}
 
 		/* Updated attached_sas_addr */
 		mvs_write_port_cfg_addr(mvi, i, PHYR_ATT_ADDR_HI);


