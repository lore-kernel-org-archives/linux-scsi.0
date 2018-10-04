From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] scsi: aic94xx: mark expected switch fall-throughs
Date: Thu, 4 Oct 2018 09:10:09 +0200
Message-ID: <20181004071009.GA13875@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

Addresses-Coverity-ID: 114988 ("Missing break in switch")
Addresses-Coverity-ID: 114989 ("Missing break in switch")
Addresses-Coverity-ID: 114990 ("Missing break in switch")
Addresses-Coverity-ID: 114991 ("Missing break in switch")
Addresses-Coverity-ID: 114992 ("Missing break in switch")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/scsi/aic94xx/aic94xx_scb.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/aic94xx/aic94xx_scb.c b/drivers/scsi/aic94xx/aic94xx_scb.c
index 22873ce..91ea87d 100644
--- a/drivers/scsi/aic94xx/aic94xx_scb.c
+++ b/drivers/scsi/aic94xx/aic94xx_scb.c
@@ -724,9 +724,11 @@ static void set_speed_mask(u8 *speed_mask, struct asd_phy_desc *pd)
 	switch (pd->max_sas_lrate) {
 	case SAS_LINK_RATE_6_0_GBPS:
 		*speed_mask &= ~SAS_SPEED_60_DIS;
+		/* fall through*/
 	default:
 	case SAS_LINK_RATE_3_0_GBPS:
 		*speed_mask &= ~SAS_SPEED_30_DIS;
+		/* fall through*/
 	case SAS_LINK_RATE_1_5_GBPS:
 		*speed_mask &= ~SAS_SPEED_15_DIS;
 	}
@@ -734,6 +736,7 @@ static void set_speed_mask(u8 *speed_mask, struct asd_phy_desc *pd)
 	switch (pd->min_sas_lrate) {
 	case SAS_LINK_RATE_6_0_GBPS:
 		*speed_mask |= SAS_SPEED_30_DIS;
+		/* fall through*/
 	case SAS_LINK_RATE_3_0_GBPS:
 		*speed_mask |= SAS_SPEED_15_DIS;
 	default:
@@ -745,6 +748,7 @@ static void set_speed_mask(u8 *speed_mask, struct asd_phy_desc *pd)
 	switch (pd->max_sata_lrate) {
 	case SAS_LINK_RATE_3_0_GBPS:
 		*speed_mask &= ~SATA_SPEED_30_DIS;
+		/* fall through*/
 	default:
 	case SAS_LINK_RATE_1_5_GBPS:
 		*speed_mask &= ~SATA_SPEED_15_DIS;
@@ -803,6 +807,7 @@ void asd_build_control_phy(struct asd_ascb *ascb, int phy_id, u8 subfunc)
 
 		/* link reset retries, this should be nominal */
 		control_phy->link_reset_retries = 10;
+		/* fall through */
 
 	case RELEASE_SPINUP_HOLD: /* 0x02 */
 		/* decide the func_mask */
-- 
2.7.4
