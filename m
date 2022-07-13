Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50834C43334
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jul 2022 05:21:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbiGMFVL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jul 2022 01:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232195AbiGMFVA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jul 2022 01:21:00 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39E14D5146
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2022 22:20:59 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26D2MG1w026753
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2022 22:20:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=EgZ7RzD7Jr2FyiKT4Z0vDvyjhaJkaFDasJ5reQxvMu8=;
 b=IZ91lQPukZ5jCa9X1XE/0EXwjCihnBHKBvUDjpRLDXUifXBq4sRu1V4P4BeTaFSl2TlZ
 HfiIMqj9XNBoRj0jzpW9XAusHo5CkABdA5jck1TrYMy5lBr+QgZ9Xkf3dSHroh9e1sdI
 2MvpRHR8h6C5Ul4N+QMvPyMM6EHH3Xpq95aIeyYZCjS+xqOOknDB8Bbpq7DYR7P6ztae
 Td1Vue3KricoHAoqrexxAn3/+HmHpF0kuDAsBGvGHRwyF/SYPEv6ZUmcYbpEsOASyeGm
 Lg0eD4Q4XizLNyKu6ReH7DfF8iCCtmvf53TTkg+WVs9gUXmyLVhnEjkLbCixjpHawgBm 5Q== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3h9n6n0f0j-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2022 22:20:58 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 12 Jul
 2022 22:20:56 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 12 Jul 2022 22:20:56 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id A9ED63F70C3;
        Tue, 12 Jul 2022 22:20:55 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 08/10] qla2xxx: fix sparse warning for dport_data
Date:   Tue, 12 Jul 2022 22:20:43 -0700
Message-ID: <20220713052045.10683-9-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220713052045.10683-1-njavali@marvell.com>
References: <20220713052045.10683-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: J9Cui2lds-3yrO2Crfw9R8BMFHkdEZZ_
X-Proofpoint-GUID: J9Cui2lds-3yrO2Crfw9R8BMFHkdEZZ_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-12_14,2022-07-12_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use le16_to_cpu to fix sparse warning reported for dport_data.

sparse warnings: (new ones prefixed by >>)
>> drivers/scsi/qla2xxx/qla_bsg.c:2485:34: sparse: sparse: incorrect
>> type in assignment (different base types) @@ expected unsigned
>> short [usertype] mbx1 @@ got restricted __le16 @@
   drivers/scsi/qla2xxx/qla_bsg.c:2485:34: sparse: expected unsigned short [usertype] mbx1
      drivers/scsi/qla2xxx/qla_bsg.c:2485:34: sparse: got restricted __le16
>> drivers/scsi/qla2xxx/qla_bsg.c:2486:34: sparse: sparse:
>> incorrect type in assignment (different base types) @@
>> expected unsigned short [usertype] mbx2 @@ got restricted __le16 @@
   drivers/scsi/qla2xxx/qla_bsg.c:2486:34: sparse: expected unsigned short [usertype] mbx2
   drivers/scsi/qla2xxx/qla_bsg.c:2486:34: sparse: got restricted __le16

Fixes: 476da8faa336 ("scsi: qla2xxx: Add a new v2 dport diagnostic feature")
Reported-by: kernel test robot <lkp@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 299c5cba92f4..5db9bf69dcff 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -2482,8 +2482,8 @@ qla2x00_do_dport_diagnostics_v2(struct bsg_job *bsg_job)
 			dd->mbx2 = mcp->mb[1];
 			vha->dport_status |=  DPORT_DIAG_IN_PROGRESS;
 		} else if (options == QLA_GET_DPORT_RESULT_V2) {
-			dd->mbx1 = vha->dport_data[1];
-			dd->mbx2 = vha->dport_data[2];
+			dd->mbx1 = le16_to_cpu(vha->dport_data[1]);
+			dd->mbx2 = le16_to_cpu(vha->dport_data[2]);
 		}
 	} else {
 		dd->mbx1 = mcp->mb[0];
-- 
2.19.0.rc0

