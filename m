From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 03/12] qla4xxx: memory wedge with peg_halt test in loop
Date: Thu, 2 Dec 2010 22:12:15 -0800
Message-ID: <5E4F49720D0BAD499EE1F01232234BA872243F411A@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:3229 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755636Ab0LCGMS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Dec 2010 01:12:18 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Swapnil Nagle <swapnil.nagle@qlogic.com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Swapnil Nagle <swapnil.nagle@qlogic.com>

Signed-off-by: Swapnil Nagle <swapnil.nagle@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_nx.c |   43 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index 474b10d..2d95ef2 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -942,12 +942,55 @@ qla4_8xxx_pinit_from_rom(struct scsi_qla_host *ha, int verbose)
 
 	/* Halt all the indiviual PEGs and other blocks of the ISP */
 	qla4_8xxx_rom_lock(ha);
+
+	/* mask all niu interrupts */
+	qla4_8xxx_wr_32(ha, QLA82XX_CRB_NIU + 0x40, 0xff);
+	/* disable xge rx/tx */
+	qla4_8xxx_wr_32(ha, QLA82XX_CRB_NIU + 0x70000, 0x00);
+	/* disable xg1 rx/tx */
+	qla4_8xxx_wr_32(ha, QLA82XX_CRB_NIU + 0x80000, 0x00);
+
+	/* halt sre */
+	val = qla4_8xxx_rd_32(ha, QLA82XX_CRB_SRE + 0x1000);
+	qla4_8xxx_wr_32(ha, QLA82XX_CRB_SRE + 0x1000, val & (~(0x1)));
+
+	/* halt epg */
+	qla4_8xxx_wr_32(ha, QLA82XX_CRB_EPG + 0x1300, 0x1);
+
+	/* halt timers */
+	qla4_8xxx_wr_32(ha, QLA82XX_CRB_TIMER + 0x0, 0x0);
+	qla4_8xxx_wr_32(ha, QLA82XX_CRB_TIMER + 0x8, 0x0);
+	qla4_8xxx_wr_32(ha, QLA82XX_CRB_TIMER + 0x10, 0x0);
+	qla4_8xxx_wr_32(ha, QLA82XX_CRB_TIMER + 0x18, 0x0);
+	qla4_8xxx_wr_32(ha, QLA82XX_CRB_TIMER + 0x100, 0x0);
+
+	/* halt pegs */
+	qla4_8xxx_wr_32(ha, QLA82XX_CRB_PEG_NET_0 + 0x3c, 1);
+	qla4_8xxx_wr_32(ha, QLA82XX_CRB_PEG_NET_1 + 0x3c, 1);
+	qla4_8xxx_wr_32(ha, QLA82XX_CRB_PEG_NET_2 + 0x3c, 1);
+	qla4_8xxx_wr_32(ha, QLA82XX_CRB_PEG_NET_3 + 0x3c, 1);
+	qla4_8xxx_wr_32(ha, QLA82XX_CRB_PEG_NET_4 + 0x3c, 1);
+
+	/* big hammer */
+	msleep(1000);
 	if (test_bit(DPC_RESET_HA, &ha->dpc_flags))
 		/* don't reset CAM block on reset */
 		qla4_8xxx_wr_32(ha, QLA82XX_ROMUSB_GLB_SW_RESET, 0xfeffffff);
 	else
 		qla4_8xxx_wr_32(ha, QLA82XX_ROMUSB_GLB_SW_RESET, 0xffffffff);
 
+	/* reset ms */
+	val = qla4_8xxx_rd_32(ha, QLA82XX_CRB_QDR_NET + 0xe4);
+	val |= (1 << 1);
+	qla4_8xxx_wr_32(ha, QLA82XX_CRB_QDR_NET + 0xe4, val);
+
+	msleep(20);
+	/* unreset ms */
+	val = qla4_8xxx_rd_32(ha, QLA82XX_CRB_QDR_NET + 0xe4);
+	val &= ~(1 << 1);
+	qla4_8xxx_wr_32(ha, QLA82XX_CRB_QDR_NET + 0xe4, val);
+	msleep(20);
+
 	qla4_8xxx_rom_unlock(ha);
 
 	/* Read the signature value from the flash.
-- 
1.7.3.2

