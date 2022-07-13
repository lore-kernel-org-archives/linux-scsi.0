Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDF5CC43334
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jul 2022 05:21:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233727AbiGMFVO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jul 2022 01:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233330AbiGMFVA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jul 2022 01:21:00 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03D7CD5147
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2022 22:20:59 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26D2Lj1X025309
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2022 22:20:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=eR2JkDJkZ7CAcf98uMYQQ4+gGZQmie3p/GH/8ByTszY=;
 b=jFRXSoOdip8wSDjNuVXAvNNiw2wTNvSoGHiJ2BGv537cgtcQmYBfq74ZpQTN3LLGxU9m
 aGSvxQy1Rrtia3t2yA27zCRbcizw0HD/mLOTnHnLA3ca9wkVCqoxJDV8gVEoNg0KCLfI
 lfXB8XrNMXmUYjvezxz1NhRyqe/+su6QTt/wD1EGj7tDX5qZADHK5+A16seZvyqW3xDH
 ZZV0/y67bnUZBGby2gfUhG8HdO4M2uHVdHIbZc0WU61XyCn5k2Rd3RHrIODMvncnxQg3
 aTmY04RQ9Dckm+Ci8Fy0l5PzEQgrHepCgjxFX55f8s166o8BaYki0tegSDzqQx2U7peP 1A== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3h9n6n0f0h-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2022 22:20:59 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 12 Jul
 2022 22:20:56 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 12 Jul 2022 22:20:56 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 7F42E3F70C2;
        Tue, 12 Jul 2022 22:20:55 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 07/10] qla2xxx: Fix discovery issues in FC-AL topology
Date:   Tue, 12 Jul 2022 22:20:42 -0700
Message-ID: <20220713052045.10683-8-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220713052045.10683-1-njavali@marvell.com>
References: <20220713052045.10683-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: fwhjnTEZesZQPq1uzh018o5533IoRgAx
X-Proofpoint-GUID: fwhjnTEZesZQPq1uzh018o5533IoRgAx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-12_14,2022-07-12_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

A direct attach tape device, when gets swapped
with another, was not discovered. Fix this by
looking at loop map and reinitialize link if
there are devices present.

Reported-by: Tony Battersby <tonyb@cybernetics.com>
Tested-by: Tony Battersby <tonyb@cybernetics.com>
Link: https://lore.kernel.org/linux-scsi/baef87c3-5dad-3b47-44c1-6914bfc90108@cybernetics.com/
Cc: stable@vger.kernel.org
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h  |  3 ++-
 drivers/scsi/qla2xxx/qla_init.c | 29 +++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_mbx.c  |  5 ++++-
 3 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 96147ca40126..5dd2932382ee 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -436,7 +436,8 @@ extern int
 qla2x00_get_resource_cnts(scsi_qla_host_t *);
 
 extern int
-qla2x00_get_fcal_position_map(scsi_qla_host_t *ha, char *pos_map);
+qla2x00_get_fcal_position_map(scsi_qla_host_t *ha, char *pos_map,
+		u8 *num_entries);
 
 extern int
 qla2x00_get_link_status(scsi_qla_host_t *, uint16_t, struct link_statistics *,
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 83fae4c341ee..e7fe0e52c11d 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5516,6 +5516,22 @@ static int qla2x00_configure_n2n_loop(scsi_qla_host_t *vha)
 	return QLA_FUNCTION_FAILED;
 }
 
+static void
+qla_reinitialize_link(scsi_qla_host_t *vha)
+{
+	int rval;
+
+	atomic_set(&vha->loop_state, LOOP_DOWN);
+	atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
+	rval = qla2x00_full_login_lip(vha);
+	if (rval == QLA_SUCCESS) {
+		ql_dbg(ql_dbg_disc, vha, 0xd050, "Link reinitialized\n");
+	} else {
+		ql_dbg(ql_dbg_disc, vha, 0xd051,
+			"Link reinitialization failed (%d)\n", rval);
+	}
+}
+
 /*
  * qla2x00_configure_local_loop
  *	Updates Fibre Channel Device Database with local loop devices.
@@ -5567,6 +5583,19 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
 		spin_unlock_irqrestore(&vha->work_lock, flags);
 
 		if (vha->scan.scan_retry < MAX_SCAN_RETRIES) {
+			u8 loop_map_entries = 0;
+			int rc;
+
+			rc = qla2x00_get_fcal_position_map(vha, NULL,
+						&loop_map_entries);
+			if (rc == QLA_SUCCESS && loop_map_entries > 1) {
+				/*
+				 * There are devices that are still not logged
+				 * in. Reinitialize to give them a chance.
+				 */
+				qla_reinitialize_link(vha);
+				return QLA_FUNCTION_FAILED;
+			}
 			set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
 			set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
 		}
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 9a3f832c49ef..359595a64664 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3068,7 +3068,8 @@ qla2x00_get_resource_cnts(scsi_qla_host_t *vha)
  *	Kernel context.
  */
 int
-qla2x00_get_fcal_position_map(scsi_qla_host_t *vha, char *pos_map)
+qla2x00_get_fcal_position_map(scsi_qla_host_t *vha, char *pos_map,
+		u8 *num_entries)
 {
 	int rval;
 	mbx_cmd_t mc;
@@ -3108,6 +3109,8 @@ qla2x00_get_fcal_position_map(scsi_qla_host_t *vha, char *pos_map)
 
 		if (pos_map)
 			memcpy(pos_map, pmap, FCAL_MAP_SIZE);
+		if (num_entries)
+			*num_entries = pmap[0];
 	}
 	dma_pool_free(ha->s_dma_pool, pmap, pmap_dma);
 
-- 
2.19.0.rc0

