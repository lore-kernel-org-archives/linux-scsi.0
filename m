Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 267B1C433C1
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 04:47:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F00BD619AB
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 04:47:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbhCWErN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Mar 2021 00:47:13 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:19122 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229504AbhCWErC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 23 Mar 2021 00:47:02 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12N4jUga021133
        for <linux-scsi@vger.kernel.org>; Mon, 22 Mar 2021 21:47:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=6i3ZbVCP2mfRcgbjgTSRH+GUvZixukPPftFeOxu+ES8=;
 b=LgNPyQhjInu8Zv4t4+aG7OGXamng3FAlWDzG87R6WDsrrNteIo9xsVzON06DthU2Cb+H
 GWMZccikaT4GnZnZg8D8jNIHsjTf+VP6HPwbvL6y1BiJrUp95Wndmo7egHeyKT6uL5EG
 fnbQB3xA17RU4JtclFTplhDadkfIRBrcPHn587L4qsNu/sAATJgmplMjPYbiikp+CHeb
 PlmVJErljbdOjN7/6/3FssyZqRJYuV3/0/4VMjvjsiErq92SiCaUrK3oDbkfwMzsmkbd
 3VTjCeQ2sIXbK1evGR35WfFavFto8ZhJWfS5lmWbBIhaG3PI6rw135Fhe/vDAvMO3a7U vg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 37dgjnyh14-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 22 Mar 2021 21:47:01 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Mar
 2021 21:46:59 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 22 Mar 2021 21:46:59 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 5DA763F703F;
        Mon, 22 Mar 2021 21:46:59 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 12N4kx7A026769;
        Mon, 22 Mar 2021 21:46:59 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 12N4kxvq026760;
        Mon, 22 Mar 2021 21:46:59 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 09/11] qla2xxx: fix mailbox recovery during PCIe error
Date:   Mon, 22 Mar 2021 21:42:55 -0700
Message-ID: <20210323044257.26664-10-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210323044257.26664-1-njavali@marvell.com>
References: <20210323044257.26664-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-23_01:2021-03-22,2021-03-23 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

For the mailbox thread that encounter PCIe error, pause that
thread until PCIe link reset/recovery completed to prevent
the thread from possibly unmapping any type of DMA resource that might
be in progress at the same time.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 38 ++++++++++++++++++++++++++--------
 1 file changed, 29 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 0149f84cdd8e..3bc6020cfb8d 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -102,7 +102,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 	int		rval, i;
 	unsigned long    flags = 0;
 	device_reg_t *reg;
-	uint8_t		abort_active;
+	uint8_t		abort_active, eeh_delay;
 	uint8_t		io_lock_on;
 	uint16_t	command = 0;
 	uint16_t	*iptr;
@@ -136,7 +136,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 		    "PCI error, exiting.\n");
 		return QLA_FUNCTION_TIMEOUT;
 	}
-
+	eeh_delay = 0;
 	reg = ha->iobase;
 	io_lock_on = base_vha->flags.init_done;
 
@@ -159,11 +159,10 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 	}
 
 	/* check if ISP abort is active and return cmd with timeout */
-	if ((test_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags) ||
-	    test_bit(ISP_ABORT_RETRY, &base_vha->dpc_flags) ||
-	    test_bit(ISP_ABORT_NEEDED, &base_vha->dpc_flags) ||
-	    ha->flags.eeh_busy) &&
-	    !is_rom_cmd(mcp->mb[0])) {
+	if (((test_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags) ||
+	      test_bit(ISP_ABORT_RETRY, &base_vha->dpc_flags) ||
+	      test_bit(ISP_ABORT_NEEDED, &base_vha->dpc_flags)) &&
+	      !is_rom_cmd(mcp->mb[0])) || ha->flags.eeh_busy) {
 		ql_log(ql_log_info, vha, 0x1005,
 		    "Cmd 0x%x aborted with timeout since ISP Abort is pending\n",
 		    mcp->mb[0]);
@@ -186,7 +185,11 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 		return QLA_FUNCTION_TIMEOUT;
 	}
 	atomic_dec(&ha->num_pend_mbx_stage1);
-	if (ha->flags.purge_mbox || chip_reset != ha->chip_reset) {
+	if (ha->flags.purge_mbox || chip_reset != ha->chip_reset ||
+	    ha->flags.eeh_busy) {
+		ql_log(ql_log_warn, vha, 0xd035,
+		       "Error detected: purge[%d] eeh[%d] cmd=0x%x, Exiting.\n",
+		       ha->flags.purge_mbox, ha->flags.eeh_busy, mcp->mb[0]);
 		rval = QLA_ABORTED;
 		goto premature_exit;
 	}
@@ -266,6 +269,8 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 		if (!wait_for_completion_timeout(&ha->mbx_intr_comp,
 		    mcp->tov * HZ)) {
 			if (chip_reset != ha->chip_reset) {
+				eeh_delay = ha->flags.eeh_busy ? 1 : 0;
+
 				spin_lock_irqsave(&ha->hardware_lock, flags);
 				ha->flags.mbox_busy = 0;
 				spin_unlock_irqrestore(&ha->hardware_lock,
@@ -283,6 +288,8 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 
 		} else if (ha->flags.purge_mbox ||
 		    chip_reset != ha->chip_reset) {
+			eeh_delay = ha->flags.eeh_busy ? 1 : 0;
+
 			spin_lock_irqsave(&ha->hardware_lock, flags);
 			ha->flags.mbox_busy = 0;
 			spin_unlock_irqrestore(&ha->hardware_lock, flags);
@@ -324,6 +331,8 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 		while (!ha->flags.mbox_int) {
 			if (ha->flags.purge_mbox ||
 			    chip_reset != ha->chip_reset) {
+				eeh_delay = ha->flags.eeh_busy ? 1 : 0;
+
 				spin_lock_irqsave(&ha->hardware_lock, flags);
 				ha->flags.mbox_busy = 0;
 				spin_unlock_irqrestore(&ha->hardware_lock,
@@ -532,7 +541,8 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 				clear_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 				/* Allow next mbx cmd to come in. */
 				complete(&ha->mbx_cmd_comp);
-				if (ha->isp_ops->abort_isp(vha)) {
+				if (ha->isp_ops->abort_isp(vha) &&
+				    !ha->flags.eeh_busy) {
 					/* Failed. retry later. */
 					set_bit(ISP_ABORT_NEEDED,
 					    &vha->dpc_flags);
@@ -585,6 +595,16 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 		ql_dbg(ql_dbg_mbx, base_vha, 0x1021, "Done %s.\n", __func__);
 	}
 
+	i = 500;
+	while (i && eeh_delay && (ha->pci_error_state < QLA_PCI_SLOT_RESET)) {
+		/* The caller of this mailbox encounter pci error.
+		 * Hold the thread until PCIE link reset complete to make
+		 * sure caller does not unmap dma while recovery is
+		 * in progress.
+		 */
+		msleep(1);
+		i--;
+	}
 	return rval;
 }
 
-- 
2.19.0.rc0

