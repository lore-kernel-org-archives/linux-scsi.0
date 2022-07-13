Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3BA8C43334
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jul 2022 05:21:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233344AbiGMFVC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jul 2022 01:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbiGMFU7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jul 2022 01:20:59 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF6A9D4BE2
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2022 22:20:57 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26D2MG1t026753
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2022 22:20:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=x/49qnA8GGJbc1xVsPcnO2DEnrb5I+TziBA69irL99g=;
 b=lOYIK/OS5YhS4+BJ6ki9H6M3itG3pP7MnpNZdP1G7j24Zyre7C2nAVr4JNS0qAu6e777
 BEXdscpl7GrcuqHeYFZwTuXfSfpneOuwpU52flsfrq83LIwF33ThcktOUmAelidysBMb
 jokWiigO1sGcyi/KI7yMZ3LKqRkGZf+7N38A3xbLqJgO0jv7cOXwxXj274s0rkDf/Lzd
 6BxhDa6533Drm3VQHIYatT+QuVb/uO9MtFh+qZgxHshsb/0lqJQ/iRhcetlVEgdibrtm
 czKKc+iOXDUkMuefcIaPbkOucZtnmLyK+ZQMn5SXF2bWpFWS60IzufOaMSQjm5LX7lUB 6A== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3h9n6n0f0j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2022 22:20:57 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 12 Jul
 2022 22:20:54 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 12 Jul 2022 22:20:54 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 961323F7085;
        Tue, 12 Jul 2022 22:20:54 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 02/10] qla2xxx: Fix incorrect display of max frame size
Date:   Tue, 12 Jul 2022 22:20:37 -0700
Message-ID: <20220713052045.10683-3-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220713052045.10683-1-njavali@marvell.com>
References: <20220713052045.10683-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: uhBsjeUyfpxsCVwb5_EWI25Q9ek6I20A
X-Proofpoint-GUID: uhBsjeUyfpxsCVwb5_EWI25Q9ek6I20A
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-12_14,2022-07-12_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bikash Hazarika <bhazarika@marvell.com>

Replace display field with the correct field.

Fixes: 8777e4314 ("scsi: qla2xxx: Migrate NVME N2N handling into state machine")
Cc: stable@vger.kernel.org
Signed-off-by: Bikash Hazarika <bhazarika@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_def.h  | 1 +
 drivers/scsi/qla2xxx/qla_gs.c   | 9 +++------
 drivers/scsi/qla2xxx/qla_init.c | 2 ++
 drivers/scsi/qla2xxx/qla_isr.c  | 4 +---
 4 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 1bdc7a208fe3..91c8fedc8ffa 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3988,6 +3988,7 @@ struct qla_hw_data {
 	/* SRB cache. */
 #define SRB_MIN_REQ     128
 	mempool_t       *srb_mempool;
+	u8 port_name[WWN_SIZE];
 
 	volatile struct {
 		uint32_t	mbox_int		:1;
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 68fb91ef380a..88c841195bdf 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1596,7 +1596,6 @@ qla2x00_hba_attributes(scsi_qla_host_t *vha, void *entries,
 	unsigned int callopt)
 {
 	struct qla_hw_data *ha = vha->hw;
-	struct init_cb_24xx *icb24 = (void *)ha->init_cb;
 	struct new_utsname *p_sysid = utsname();
 	struct ct_fdmi_hba_attr *eiter;
 	uint16_t alen;
@@ -1758,8 +1757,8 @@ qla2x00_hba_attributes(scsi_qla_host_t *vha, void *entries,
 	/* MAX CT Payload Length */
 	eiter = entries + size;
 	eiter->type = cpu_to_be16(FDMI_HBA_MAXIMUM_CT_PAYLOAD_LENGTH);
-	eiter->a.max_ct_len = cpu_to_be32(le16_to_cpu(IS_FWI2_CAPABLE(ha) ?
-		icb24->frame_payload_size : ha->init_cb->frame_payload_size));
+	eiter->a.max_ct_len = cpu_to_be32(ha->frame_payload_size >> 2);
+
 	alen = sizeof(eiter->a.max_ct_len);
 	alen += FDMI_ATTR_TYPELEN(eiter);
 	eiter->len = cpu_to_be16(alen);
@@ -1851,7 +1850,6 @@ qla2x00_port_attributes(scsi_qla_host_t *vha, void *entries,
 	unsigned int callopt)
 {
 	struct qla_hw_data *ha = vha->hw;
-	struct init_cb_24xx *icb24 = (void *)ha->init_cb;
 	struct new_utsname *p_sysid = utsname();
 	char *hostname = p_sysid ?
 		p_sysid->nodename : fc_host_system_hostname(vha->host);
@@ -1903,8 +1901,7 @@ qla2x00_port_attributes(scsi_qla_host_t *vha, void *entries,
 	/* Max frame size. */
 	eiter = entries + size;
 	eiter->type = cpu_to_be16(FDMI_PORT_MAX_FRAME_SIZE);
-	eiter->a.max_frame_size = cpu_to_be32(le16_to_cpu(IS_FWI2_CAPABLE(ha) ?
-		icb24->frame_payload_size : ha->init_cb->frame_payload_size));
+	eiter->a.max_frame_size = cpu_to_be32(ha->frame_payload_size);
 	alen = sizeof(eiter->a.max_frame_size);
 	alen += FDMI_ATTR_TYPELEN(eiter);
 	eiter->len = cpu_to_be16(alen);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index e9bc93395e2f..15fb5ed565c0 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4534,6 +4534,8 @@ qla2x00_init_rings(scsi_qla_host_t *vha)
 			 BIT_6) != 0;
 		ql_dbg(ql_dbg_init, vha, 0x00bc, "FA-WWPN Support: %s.\n",
 		    (ha->flags.fawwpn_enabled) ? "enabled" : "disabled");
+		/* Init_cb will be reused for other command(s).  Save a backup copy of port_name */
+		memcpy(ha->port_name, ha->init_cb->port_name, WWN_SIZE);
 	}
 
 	/* ELS pass through payload is limit by frame size. */
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 24f9a3b116d8..4fa24d318f14 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1354,9 +1354,7 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 			if (!vha->vp_idx) {
 				if (ha->flags.fawwpn_enabled &&
 				    (ha->current_topology == ISP_CFG_F)) {
-					void *wwpn = ha->init_cb->port_name;
-
-					memcpy(vha->port_name, wwpn, WWN_SIZE);
+					memcpy(vha->port_name, ha->port_name, WWN_SIZE);
 					fc_host_port_name(vha->host) =
 					    wwn_to_u64(vha->port_name);
 					ql_dbg(ql_dbg_init + ql_dbg_verbose,
-- 
2.19.0.rc0

