Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D24A17543
	for <linux-scsi@vger.kernel.org>; Fri, 23 Feb 2024 07:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708674348; cv=none; b=bA8cOTayS0IlTmqwVkPseySvXgTUkUltkwuXkpfXAt/tVTwqubrVL4bJQA9B2A2lS1mYGJ5FyXtxkNsbsyBBpTnC6NaC5O2naPQwiTjhXbRflQdnqqq2VNPUrJOf2TWpHoz0x5JrneHK+oxylb3gORyfz0Wh7q1DZd+XjuQnMEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708674348; c=relaxed/simple;
	bh=VuefFMlk5zxtYV3RhBl/qhjOprFLLMdj2kjcWrV9IPE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l9+d4XSVvd3DRXGUjeElIZ5d0z2PROmvDksLHHsqQWif2+VBnzgfgc9d0nCWT5JA7lCr+230EjuVjGPvGuR8pC47na91SFbQZLX/ERiyqqS8DE3TpihoPzHfl+xooSX3aBtJLhthm+jxh9ojIKJTwEA7dcZdhJxBDZfwQAOB6Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=SBXlJyNk; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="SBXlJyNk"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 41ML8vm6003174;
	Thu, 22 Feb 2024 23:45:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	pfpt0220; bh=RCWA+X1nUHFpgPNpm+2uM9/HCnWQ993U8Li7Ptgpiik=; b=SBX
	lJyNkBgsqrOK6lE9XJx8sPiezzFoQBQ4hK/vkCPsdbG1pELI0speAgTEIZ4Vgqt6
	ETnZ7Wv13nWgJc35KPmU/08vvt2nBm9Nuz2liVqkIjPQDlJfRAQBSd2+8zwUYDHv
	buaDMizI6nIhSQNb86DldaN1zXGnaP9EdRYcro6BrgwQJOFEobk5z7+/vx0VysPt
	KcqkjudaI9aMJ5dxvR7XvzOrqKPwVk8qwtS8dO4RnIM+RhvEz/LgXe8VB0L7pqSo
	kBjVLXgCE9SBeDPKyUCPxwWzEtx3qp3X4ppFV0XdVsNTw6U8oOd5LvgSkuh3yyK3
	lGsCV6A2Oz1KTG7u9qw==
Received: from dc5-exch01.marvell.com ([199.233.59.181])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3wedwxht2p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Thu, 22 Feb 2024 23:45:43 -0800 (PST)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server (TLS) id
 15.0.1497.48; Thu, 22 Feb 2024 23:45:41 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1258.12; Thu, 22 Feb
 2024 23:45:40 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Thu, 22 Feb 2024 23:45:40 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id 4908A3F7151;
	Thu, 22 Feb 2024 23:45:38 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH 05/11] qla2xxx: NVME|FCP prefer flag not being honored
Date: Fri, 23 Feb 2024 13:15:08 +0530
Message-ID: <20240223074514.8472-6-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20240223074514.8472-1-njavali@marvell.com>
References: <20240223074514.8472-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: qnsWcwtgNsvK-leWx4MZU-TPmV_r_laY
X-Proofpoint-ORIG-GUID: qnsWcwtgNsvK-leWx4MZU-TPmV_r_laY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-22_15,2024-02-22_01,2023-05-22_02

From: Quinn Tran <qutran@marvell.com>

Changing of [FCP|NVME] prefer flag in flash has
no effect on driver. For device that support both FCP + NVME
over the same connection, driver continue to connect to this device
using the previous successful login mode.

On completion of flash update, adapter will be reset. Driver will
reset the prefer flag based on setting from flash.

Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 92c3091fd087..00700b848d9c 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -7503,6 +7503,7 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
 	struct scsi_qla_host *vp, *tvp;
 	struct req_que *req = ha->req_q_map[0];
 	unsigned long flags;
+	fc_port_t *fcport;
 
 	if (vha->flags.online) {
 		qla2x00_abort_isp_cleanup(vha);
@@ -7571,6 +7572,15 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
 			       "ISP Abort - ISP reg disconnect post nvmram config, exiting.\n");
 			return status;
 		}
+
+		/* User may have updated [fcp|nvme] prefer in flash */
+		list_for_each_entry(fcport, &vha->vp_fcports, list) {
+			if (NVME_PRIORITY(ha, fcport))
+				fcport->do_prli_nvme = 1;
+			else
+				fcport->do_prli_nvme = 0;
+		}
+
 		if (!qla2x00_restart_isp(vha)) {
 			clear_bit(RESET_MARKER_NEEDED, &vha->dpc_flags);
 
@@ -7641,6 +7651,14 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
 				atomic_inc(&vp->vref_count);
 				spin_unlock_irqrestore(&ha->vport_slock, flags);
 
+				/* User may have updated [fcp|nvme] prefer in flash */
+				list_for_each_entry(fcport, &vp->vp_fcports, list) {
+					if (NVME_PRIORITY(ha, fcport))
+						fcport->do_prli_nvme = 1;
+					else
+						fcport->do_prli_nvme = 0;
+				}
+
 				qla2x00_vp_abort_isp(vp);
 
 				spin_lock_irqsave(&ha->vport_slock, flags);
-- 
2.23.1

