Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9F99C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jun 2022 05:35:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358687AbiFPFfm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jun 2022 01:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358608AbiFPFfQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jun 2022 01:35:16 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A9DE5AEFB
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2022 22:35:15 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25FN9tAi014579
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2022 22:35:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=AaKRkTJyPIjveifCS4Z2pTxe6qv6bIInbJwpXrUD9dg=;
 b=CY3cWeRTk2E9O9Yip6ht3ao7dOOzSSwGmAmVRqfOr+hvaw48SeBe9/s/SC8dckDJ9aPN
 jkLDP+JWKReFsXiwmXfxa1L0anoCkJ/o42rsVmgSTlI425EZDDfVLQyc2rZzbe+/MIUt
 rnAA3+urf6XKhYRTyCvmR/uWkU2SCMKrDFqnGPePaypFhwZfLt/v0qOk3iWTxDVbYPJu
 s4LaNzFHvb1WB7eXtmyTASBTggA7xJoHE2drh1N+YIFbvKKh9wvQeehxxjbXLjPo/cmy
 KZRwcjGQVHLODdDobo2QOGCa7t9fZ2Gkdy/b+eidyxsf6Jj7FApD/YUaFuu4VBrs5q6J Gg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3gqruu977w-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2022 22:35:14 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 15 Jun
 2022 22:35:12 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 15 Jun 2022 22:35:12 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id AFCE83F70AE;
        Wed, 15 Jun 2022 22:35:12 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 08/11] qla2xxx: Add debug prints in the device remove path
Date:   Wed, 15 Jun 2022 22:35:05 -0700
Message-ID: <20220616053508.27186-9-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220616053508.27186-1-njavali@marvell.com>
References: <20220616053508.27186-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: m6VKa61_kx0sRRr88ZDl7jjzVPpGL-f0
X-Proofpoint-GUID: m6VKa61_kx0sRRr88ZDl7jjzVPpGL-f0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-16_02,2022-06-15_01,2022-02-23_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

Add a debug print in the devloss callback.

Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_attr.c | 3 +++
 drivers/scsi/qla2xxx/qla_def.h  | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index feca9e44b21c..fa1fcbfb946f 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -2714,6 +2714,9 @@ qla2x00_dev_loss_tmo_callbk(struct fc_rport *rport)
 	if (!fcport)
 		return;
 
+	ql_dbg(ql_dbg_async, fcport->vha, 0x5101,
+	       DBG_FCPORT_PRFMT(fcport, "dev_loss_tmo expiry, rport_state=%d",
+				rport->port_state));
 
 	/*
 	 * Now that the rport has been deleted, set the fcport state to
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 89cb6c24258d..1bdc7a208fe3 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -5464,4 +5464,10 @@ struct ql_vnd_tgt_stats_resp {
 #define IS_SESSION_DELETED(_fcport) (_fcport->disc_state == DSC_DELETE_PEND || \
 				      _fcport->disc_state == DSC_DELETED)
 
+#define DBG_FCPORT_PRFMT(_fp, _fmt, _args...) \
+	"%s: %8phC: " _fmt " (state=%d disc_state=%d scan_state=%d loopid=0x%x deleted=%d flags=0x%x)\n", \
+	__func__, _fp->port_name, ##_args, atomic_read(&_fp->state), \
+	_fp->disc_state, _fp->scan_state, _fp->loop_id, _fp->deleted, \
+	_fp->flags
+
 #endif
-- 
2.19.0.rc0

