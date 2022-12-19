Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89539C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Dec 2022 11:08:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231907AbiLSLIL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Dec 2022 06:08:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231877AbiLSLIB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Dec 2022 06:08:01 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB4A9EE09
        for <linux-scsi@vger.kernel.org>; Mon, 19 Dec 2022 03:08:00 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJ9Q1pi010480
        for <linux-scsi@vger.kernel.org>; Mon, 19 Dec 2022 03:08:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=FeeMdws7uEzQ06EpN9EHnWT5yvU9sC0da6GU0VpLhl0=;
 b=iVl/Mo764kXpRrq5GqOESBFX8VGJkYUIRoLj6QNKC3QdDXPt5DKf4+CoHfWPW0rr/b3I
 p+UZnqIULoOxVGlG+0oBtO3C67mD9WmDTGTRRoMXBU9YT3uprcbxhMZN0PgjA42BHDCc
 vSQ+qlZDHmAyku8ttwBsAQnWEoNoYdNnpYdR7DpNeGVkmWqVsMFgzCqlnuPAnrsgaqjm
 ya0eUVrEJgooMEBl9OvF4aTl9Cvt5G7ud/gFUiW99LrqwUWWa+a3my26nYtHqbwDzfrd
 sVnPG3tIQ7m5wvRYhNSbdLwjZxt/EsAdv/TZpCONKhaVDa/OGJDE1bpt4K02FTT/yYwt hw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3mjnanrb8v-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 19 Dec 2022 03:08:00 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Mon, 19 Dec
 2022 03:07:58 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Mon, 19 Dec 2022 03:07:58 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 16B053F7041;
        Mon, 19 Dec 2022 03:07:58 -0800 (PST)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH v2 08/11] qla2xxx: Fix erroneous link down
Date:   Mon, 19 Dec 2022 03:07:45 -0800
Message-ID: <20221219110748.7039-9-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20221219110748.7039-1-njavali@marvell.com>
References: <20221219110748.7039-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: gMOcu0nghrXUaT92wjTMu8tupJ5VVa7-
X-Proofpoint-ORIG-GUID: gMOcu0nghrXUaT92wjTMu8tupJ5VVa7-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-19_01,2022-12-15_02,2022-06-22_01
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
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 36d3cecab20e..2d86f804872b 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -7094,9 +7094,12 @@ qla2x00_do_dpc(void *data)
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

