Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB3A2C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Mar 2022 08:21:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344959AbiCHIWL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Mar 2022 03:22:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344951AbiCHIWF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2022 03:22:05 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE3D3F315
        for <linux-scsi@vger.kernel.org>; Tue,  8 Mar 2022 00:21:08 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22883jqi000787
        for <linux-scsi@vger.kernel.org>; Tue, 8 Mar 2022 00:21:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=0iHAKmwKeTQXQztJIVMaCWi4xY7+xmGllzboljtAkL8=;
 b=PaY816EG0biQXwisZmNGgSN8SlUw4JSY6i6aO4j/15+3kMnU4OYa7uxCX02mt63zfI8k
 9YDF/6tNwTNcGgy7HLTPACO9NG0G7ylK6bt9NyMJreh4s/zkvHnfUoKYtt8sdfaC0TrD
 jjHbSwqp0rzSvo/qhIcl6CfJRHFr/WX+X6MjEVD9vrvUoF+iE0bw0iWm4+uqcQnFSwR0
 +/6wez2t+xEmbboCqY+1U4TugpA1Axo4nfZYm5a29xvpKLjZtlxk6KfZLPTmXNuOZCeQ
 4Gep+OLxlJDER8dsKKuA1+RYAj0UmTIaCrRROZ5TC7Pekp0LXvkgULSOaRvavn0vZm8O Kg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3ep39x82uy-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 08 Mar 2022 00:21:08 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 8 Mar
 2022 00:21:06 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 8 Mar 2022 00:21:06 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 7949C5B6924;
        Tue,  8 Mar 2022 00:21:06 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 2288L6gS009853;
        Tue, 8 Mar 2022 00:21:06 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 2288L6XG009852;
        Tue, 8 Mar 2022 00:21:06 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 11/13] qla2xxx: Use correct feature type field during rffid processing
Date:   Tue, 8 Mar 2022 00:20:46 -0800
Message-ID: <20220308082048.9774-12-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220308082048.9774-1-njavali@marvell.com>
References: <20220308082048.9774-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 3t2USDHZ8ccZs-PGbT5puPF9-7ERqMpC
X-Proofpoint-GUID: 3t2USDHZ8ccZs-PGbT5puPF9-7ERqMpC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-08_03,2022-03-04_01,2022-02-23_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Manish Rangankar <mrangankar@marvell.com>

During SNS Register FC-4 Features (RFF_ID) for initiator driver was
sending incorrect type field for nvme supported device. Use correct
feature type field.

Cc: stable@vger.kernel.org
Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_gs.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index a812f4a45232..6b67bd561810 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -676,8 +676,7 @@ qla2x00_rff_id(scsi_qla_host_t *vha, u8 type)
 		return (QLA_SUCCESS);
 	}
 
-	return qla_async_rffid(vha, &vha->d_id, qlt_rff_id(vha),
-	    FC4_TYPE_FCP_SCSI);
+	return qla_async_rffid(vha, &vha->d_id, qlt_rff_id(vha), type);
 }
 
 static int qla_async_rffid(scsi_qla_host_t *vha, port_id_t *d_id,
@@ -729,7 +728,7 @@ static int qla_async_rffid(scsi_qla_host_t *vha, port_id_t *d_id,
 	/* Prepare CT arguments -- port_id, FC-4 feature, FC-4 type */
 	ct_req->req.rff_id.port_id = port_id_to_be_id(*d_id);
 	ct_req->req.rff_id.fc4_feature = fc4feature;
-	ct_req->req.rff_id.fc4_type = fc4type;		/* SCSI - FCP */
+	ct_req->req.rff_id.fc4_type = fc4type;		/* SCSI-FCP or FC-NVMe */
 
 	sp->u.iocb_cmd.u.ctarg.req_size = RFF_ID_REQ_SIZE;
 	sp->u.iocb_cmd.u.ctarg.rsp_size = RFF_ID_RSP_SIZE;
-- 
2.19.0.rc0

