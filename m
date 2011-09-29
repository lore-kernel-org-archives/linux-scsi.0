From: yxlraid@gmail.com
Subject: [PATCH 7/8] [SCSI] mvsas: fixed SMP request watchdog timeout issue.
Date: Thu, 29 Sep 2011 00:35:15 -0700
Message-ID: <4e834cee.2679440a.6d74.79d6@mx.google.com>
References: <mvsas>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43307 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab1I1QgA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2011 12:36:00 -0400
In-Reply-To: <mvsas>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: jack_wang@usish.com, lucas.demarchi@profusion.mobi, maciej.trela@intel.com, dan.j.williams@intel.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Xiangliang Yu <yuxiangl@marvell.com>

From: Xiangliang Yu <yuxiangl@marvell.com>

-- set SMP link timeout value to maximum.

Signed-off-by: Xiangliang Yu <yuxiangl@marvell.com>
---
 drivers/scsi/mvsas/mv_94xx.c |    4 ++++
 drivers/scsi/mvsas/mv_defs.h |    1 +
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_94xx.c b/drivers/scsi/mvsas/mv_94xx.c
index ba667db..49088d5 100644
--- a/drivers/scsi/mvsas/mv_94xx.c
+++ b/drivers/scsi/mvsas/mv_94xx.c
@@ -511,6 +511,10 @@ static int __devinit mvs_94xx_init(struct mvs_info *mvi)
 	tmp |= CINT_PHY_MASK;
 	mw32(MVS_INT_MASK, tmp);
 
+	tmp = mvs_cr32(mvi, CMD_LINK_TIMER);
+	tmp |= 0xFFFF0000;
+	mvs_cw32(mvi, CMD_LINK_TIMER, tmp);
+
 	/* tune STP performance */
 	tmp = 0x003F003F;
 	mvs_cw32(mvi, CMD_PL_TIMER, tmp);
diff --git a/drivers/scsi/mvsas/mv_defs.h b/drivers/scsi/mvsas/mv_defs.h
index 8e21482..f545194 100644
--- a/drivers/scsi/mvsas/mv_defs.h
+++ b/drivers/scsi/mvsas/mv_defs.h
@@ -388,6 +388,7 @@ enum sas_cmd_port_registers {
 	CMD_SL_MODE1		= 0x1C0, /* SL Mode 1 */
 	CMD_PND_FIFO_CTL1	= 0x1C4, /* Pending FIFO Control 1 */
 	CMD_PORT_LAYER_TIMER1	= 0x1E0, /* Port Layer Timer 1 */
+	CMD_LINK_TIMER		= 0x1E4, /* Link Timer */
 };
 
 enum mvs_info_flags {
-- 
1.7.4.4

