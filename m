From: yxlraid@gmail.com
Subject: [PATCH 3/8] [SCSI] mvsas: fixed some disk spin up issue
Date: Thu, 29 Sep 2011 00:33:49 -0700
Message-ID: <4e834c98.2679440a.6d74.7962@mx.google.com>
References: <mvsas>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <mvsas>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com
Cc: jack_wang@usish.com, lucas.demarchi@profusion.mobi, maciej.trela@intel.com, dan.j.williams@intel.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Xiangliang Yu <yuxiangl@marvell.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiangliang Yu <yuxiangl@marvell.com>

-- spin up issue: some direct attached SAS device can't spin up

Signed-off-by: Xiangliang Yu <yuxiangl@marvell.com>
---
 drivers/scsi/mvsas/mv_94xx.c |    4 ++++
 drivers/scsi/mvsas/mv_sas.c  |   12 ++++++++++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_94xx.c b/drivers/scsi/mvsas/mv_94xx.c
index 3501291..8f32c7c 100644
--- a/drivers/scsi/mvsas/mv_94xx.c
+++ b/drivers/scsi/mvsas/mv_94xx.c
@@ -823,6 +823,10 @@ static void mvs_94xx_fix_phy_info(struct mvs_info *mvi, int i,
 		phy->att_dev_info = PORT_DEV_STP_TRGT | 1;
 	}
 
+	/* enable spin up bit */
+	mvs_write_port_cfg_addr(mvi, i, PHYR_PHY_STAT);
+	mvs_write_port_cfg_data(mvi, i, 0x04);
+
 }
 
 void mvs_94xx_phy_set_link_rate(struct mvs_info *mvi, u32 phy_id,
diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 86847c6..15e9a31 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -265,6 +265,12 @@ static void mvs_bytes_dmaed(struct mvs_info *mvi, int i)
 		id->dev_type = phy->identify.device_type;
 		id->initiator_bits = SAS_PROTOCOL_ALL;
 		id->target_bits = phy->identify.target_port_protocols;
+
+		/* direct attached SAS device */
+		if(phy->att_dev_info & PORT_SSP_TRGT_MASK) {
+			MVS_CHIP_DISP->write_port_cfg_addr(mvi, i, PHYR_PHY_STAT);
+			MVS_CHIP_DISP->write_port_cfg_data(mvi, i, 0x00);
+		}
 	} else if (phy->phy_type & PORT_TYPE_SATA) {
 		/*Nothing*/
 	}
@@ -1241,6 +1247,12 @@ static void mvs_port_notify_formed(struct asd_sas_phy *sas_phy, int lock)
 		port->wide_port_phymap = sas_port->phy_mask;
 		mv_printk("set wide port phy map %x\n", sas_port->phy_mask);
 		mvs_update_wideport(mvi, sas_phy->id);
+
+		/* direct attached SAS device */
+		if(phy->att_dev_info & PORT_SSP_TRGT_MASK) {
+			MVS_CHIP_DISP->write_port_cfg_addr(mvi, i, PHYR_PHY_STAT);
+			MVS_CHIP_DISP->write_port_cfg_data(mvi, i, 0x04);
+		}
 	}
 	if (lock)
 		spin_unlock_irqrestore(&mvi->lock, flags);
-- 
1.7.4.4
