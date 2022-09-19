Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFB2BC54EE9
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Sep 2022 13:44:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbiISNot (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Sep 2022 09:44:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbiISNor (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Sep 2022 09:44:47 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A31EE60DE
        for <linux-scsi@vger.kernel.org>; Mon, 19 Sep 2022 06:44:43 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28J5EZ7L010921;
        Mon, 19 Sep 2022 06:44:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=N/wSG2cg3fr7REXUAezyUtq1AzgV0Rsrtevf626KGio=;
 b=PoWTtjfu+w8EmvtnIokyaZM9pjISkOVIAVd7h2ljB4nbcrHzdSIXf6unYX4p9y5N2Wdw
 ysK/JU+bmGeyUA6MHkjuo88sr+6uLbDkPkJMuvrC6DbBNEOsmKKl2aNE8BZ73VZz5Rsi
 JNttf3+qbKhbbKJo+iVVd5dzxTv8xyhg148MRP09MmJnIY3z2Z40uGNH4+HRxqXNeN1m
 2NACf1eg/0OweDwMNALYF43f4nD0v+gAEv19JUgkSwTNF6CCcKOGi6kTk3E//9/ivU32
 oJBr/jwRwwpHWu5qp5N1gKKQ3RSYD/hnPNw8GegAHO+jEAnNvxMwZDI3kCTLhdkfkK2p jg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3jndrmpeb3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 19 Sep 2022 06:44:41 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 19 Sep
 2022 06:44:39 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 19 Sep 2022 06:44:39 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id D75B33F7067;
        Mon, 19 Sep 2022 06:44:38 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <jmeneghi@redhat.com>,
        <guazhang@redhat.com>, <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2] qedf: Populate sysfs attributes for vport
Date:   Mon, 19 Sep 2022 06:44:34 -0700
Message-ID: <20220919134434.3513-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: Rk0IPDbCJD8CZEPGCR1uA4fhvNgbpqnk
X-Proofpoint-ORIG-GUID: Rk0IPDbCJD8CZEPGCR1uA4fhvNgbpqnk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-19_05,2022-09-16_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Saurav Kashyap <skashyap@marvell.com>

Few vport parameters were displayed by systool as
'Unknown' or 'NULL'.
Copy speed, supported_speed, frame_size and update
port_type for NPIV port.

Tested-by: Guangwu Zhang <guazhang@redhat.com>
Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
v1 -> v2:
Add more description, add Tested-by, Reviewed-by, Cc tags.

 drivers/scsi/qedf/qedf_main.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 3d6b137314f3..cc6d9decf62c 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -1921,6 +1921,27 @@ static int qedf_vport_create(struct fc_vport *vport, bool disabled)
 		fc_vport_setlink(vn_port);
 	}
 
+	/* Set symbolic node name */
+	if (base_qedf->pdev->device == QL45xxx)
+		snprintf(fc_host_symbolic_name(vn_port->host), 256,
+			 "Marvell FastLinQ 45xxx FCoE v%s", QEDF_VERSION);
+
+	if (base_qedf->pdev->device == QL41xxx)
+		snprintf(fc_host_symbolic_name(vn_port->host), 256,
+			 "Marvell FastLinQ 41xxx FCoE v%s", QEDF_VERSION);
+
+	/* Set supported speed */
+	fc_host_supported_speeds(vn_port->host) = n_port->link_supported_speeds;
+
+	/* Set speed */
+	vn_port->link_speed = n_port->link_speed;
+
+	/* Set port type */
+	fc_host_port_type(vn_port->host) = FC_PORTTYPE_NPIV;
+
+	/* Set maxframe size */
+	fc_host_maxframe_size(vn_port->host) = n_port->mfs;
+
 	QEDF_INFO(&(base_qedf->dbg_ctx), QEDF_LOG_NPIV, "vn_port=%p.\n",
 		   vn_port);
 
-- 
2.23.1

