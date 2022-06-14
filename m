Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CED59C43334
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jun 2022 07:30:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354604AbiFNHa0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jun 2022 03:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240045AbiFNHaN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jun 2022 03:30:13 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13C9E3EA9B
        for <linux-scsi@vger.kernel.org>; Tue, 14 Jun 2022 00:30:03 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25E5SfxY006033
        for <linux-scsi@vger.kernel.org>; Tue, 14 Jun 2022 00:30:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=CRvppUOeRenealKkA0y8gDydhwhBBlnonqVle9OjlCE=;
 b=VAD+74kOhVIBRPzEUtBlKkGdHB6YvzvWyc8U9tYbOdYgbmeJp9Zz126R9ikgLSkWoUVU
 qmrAhAGs4Zp/WZTCYElISqIbNS3COYL6c1DcpaHX2KOHRVpvAQ0nr+8WzcVLm9rcUUgM
 gUowR4Nxj/NXseBRHYPXR2NqnkepbKwtinR5gFK8XkomxCYQceBaraK0Dy1/nRwhjiE3
 ZR+8iyFJXcfStbEgmPk7yboKq3e1sm44li/u5Xe3vC/2TE3tQOfoHs5qyR36Nv0eVPq2
 yDbRyzlu3x99dLdd+0ZBo/USZGwW9nBqMhQVktWpr1qSQ/8vh1G4fCacpp9R4rXX6C6P MA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3gmtjp2bjh-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 14 Jun 2022 00:30:03 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 14 Jun
 2022 00:30:00 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 14 Jun 2022 00:30:00 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id D9B0E3F70A6;
        Tue, 14 Jun 2022 00:29:59 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 09/11] qla2xxx: Fix losing FCP-2 targets on long port disable with IOs
Date:   Tue, 14 Jun 2022 00:29:51 -0700
Message-ID: <20220614072953.16462-10-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220614072953.16462-1-njavali@marvell.com>
References: <20220614072953.16462-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: HExbMcZW-j9UMGdKJHRkP_9SIR2ZMvvY
X-Proofpoint-ORIG-GUID: HExbMcZW-j9UMGdKJHRkP_9SIR2ZMvvY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-14_02,2022-06-13_01,2022-02-23_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

FCP-2 devices were not coming back online once it was
lost, login retries exhausted and then came back up.
Fix this by accepting RSCN when the device is
not online.

Fixes: 44c57f205876 ("scsi: qla2xxx: Changes to support FCP2 Target")
Cc: stable@vger.kernel.org
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 7860cf4319ef..41ffad65d29e 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1832,7 +1832,8 @@ void qla2x00_handle_rscn(scsi_qla_host_t *vha, struct event_arg *ea)
 	case RSCN_PORT_ADDR:
 		fcport = qla2x00_find_fcport_by_nportid(vha, &ea->id, 1);
 		if (fcport) {
-			if (fcport->flags & FCF_FCP2_DEVICE) {
+			if (fcport->flags & FCF_FCP2_DEVICE &&
+			    atomic_read(&fcport->state) == FCS_ONLINE) {
 				ql_dbg(ql_dbg_disc, vha, 0x2115,
 				       "Delaying session delete for FCP2 portid=%06x %8phC ",
 					fcport->d_id.b24, fcport->port_name);
@@ -1864,7 +1865,8 @@ void qla2x00_handle_rscn(scsi_qla_host_t *vha, struct event_arg *ea)
 		break;
 	case RSCN_AREA_ADDR:
 		list_for_each_entry(fcport, &vha->vp_fcports, list) {
-			if (fcport->flags & FCF_FCP2_DEVICE)
+			if (fcport->flags & FCF_FCP2_DEVICE &&
+			    atomic_read(&fcport->state) == FCS_ONLINE)
 				continue;
 
 			if ((ea->id.b24 & 0xffff00) == (fcport->d_id.b24 & 0xffff00)) {
@@ -1875,7 +1877,8 @@ void qla2x00_handle_rscn(scsi_qla_host_t *vha, struct event_arg *ea)
 		break;
 	case RSCN_DOM_ADDR:
 		list_for_each_entry(fcport, &vha->vp_fcports, list) {
-			if (fcport->flags & FCF_FCP2_DEVICE)
+			if (fcport->flags & FCF_FCP2_DEVICE &&
+			    atomic_read(&fcport->state) == FCS_ONLINE)
 				continue;
 
 			if ((ea->id.b24 & 0xff0000) == (fcport->d_id.b24 & 0xff0000)) {
@@ -1887,7 +1890,8 @@ void qla2x00_handle_rscn(scsi_qla_host_t *vha, struct event_arg *ea)
 	case RSCN_FAB_ADDR:
 	default:
 		list_for_each_entry(fcport, &vha->vp_fcports, list) {
-			if (fcport->flags & FCF_FCP2_DEVICE)
+			if (fcport->flags & FCF_FCP2_DEVICE &&
+			    atomic_read(&fcport->state) == FCS_ONLINE)
 				continue;
 
 			fcport->scan_needed = 1;
-- 
2.19.0.rc0

