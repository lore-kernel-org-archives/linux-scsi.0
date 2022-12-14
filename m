Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 850BAC4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Dec 2022 04:50:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237340AbiLNEug (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Dec 2022 23:50:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237294AbiLNEu1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Dec 2022 23:50:27 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B473D139
        for <linux-scsi@vger.kernel.org>; Tue, 13 Dec 2022 20:50:27 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BE3gC9F020064
        for <linux-scsi@vger.kernel.org>; Tue, 13 Dec 2022 20:50:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=j1NFNCD9aPiYDjlQG5sucdS4PPL5N1owsE1HLRYCNpM=;
 b=hn3O7TFDgXjuBl2BY0lDzRVlYAvfEAfKHCHBMGjWzUEz2aL0S1CRMa1VRDieCDmzuBx5
 9X0Mq0LMpAw6CW8ZXey4WcXfI5ULgFi9/Q7TRnoduDLqSG04n4pWQsjtdgH2V1MfJJFh
 FkscZl1QRbS39TS+yCiB7cK40LVVObrV1HbJvu6JSv6XJMkpGFaTOwivCwdJ7kEi2ko1
 m6YvkRG52op0VxPOrv3Zs3zMBeWSEF1DCUoX3JnyyQwQL4Vwtno6v99+e44Z3GoizQKR
 8b2uhss/8LG5amhcV5UZ1coHBYPD6uDVNHJSr9BpCTClsCbFqn+CRo2/4RoxBaABOPkv pQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3mf6tj078d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 13 Dec 2022 20:50:26 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 13 Dec
 2022 20:50:25 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Tue, 13 Dec 2022 20:50:25 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 1783C3F7077;
        Tue, 13 Dec 2022 20:50:25 -0800 (PST)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>
Subject: [PATCH 08/10] qla2xxx: Fix erroneous link down
Date:   Tue, 13 Dec 2022 20:50:12 -0800
Message-ID: <20221214045014.19362-9-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20221214045014.19362-1-njavali@marvell.com>
References: <20221214045014.19362-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: K6VeigEBl2bBhKbHFGDhWG4LD8l2xuKi
X-Proofpoint-GUID: K6VeigEBl2bBhKbHFGDhWG4LD8l2xuKi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-14_02,2022-12-13_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

After adapter reset, the appearance of link is not recovered,
the devices were not rediscovered.
This is result of a race condition between adapter reset (abort_isp)
and the topology scan.
During adapter reset, the ABORT_ISP_ACTIVE flag is set.
Topology scan usually occurred after adapter reset.
In this case, the topology scan came earlier than usual where it
ran into problem due to ABORT_ISP_ACTIVE flag was still set.

kernel: qla2xxx [0000:13:00.0]-1005:1: Cmd 0x6a aborted with timeout since ISP Abort is pending
kernel: qla2xxx [0000:13:00.0]-28a0:1: MBX_GET_PORT_NAME failed, No FL Port.
kernel: qla2xxx [0000:13:00.0]-286b:1: qla2x00_configure_loop: exiting normally. local port wwpn 51402ec0123d9a80 id 012300)
kernel: qla2xxx [0000:13:00.0]-8017:1: ADAPTER RESET SUCCEEDED nexus=1:0:15.

Allow adapter reset to complete before any scan can start.

Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 1fc4e6209db7..6e33dc16ce6f 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -7095,9 +7095,12 @@ qla2x00_do_dpc(void *data)
 			}
 		}
 loop_resync_check:
-		if (test_and_clear_bit(LOOP_RESYNC_NEEDED,
+		if (!qla2x00_reset_active(base_vha) &&
+		    test_and_clear_bit(LOOP_RESYNC_NEEDED,
 		    &base_vha->dpc_flags)) {
-
+			/*
+			 * Allow abort_isp to complete before moving on to scanning.
+			 */
 			ql_dbg(ql_dbg_dpc, base_vha, 0x400f,
 			    "Loop resync scheduled.\n");
 
-- 
2.19.0.rc0

