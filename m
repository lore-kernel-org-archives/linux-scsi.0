Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0AD74D9EF
	for <linux-scsi@vger.kernel.org>; Tue, 27 Feb 2024 17:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709055165; cv=none; b=RAD/+KegRkHKfPP132qczLbU505+nZdYwD2K2f3kbFmVeLNE8ybKxmjNZhNDsuurn5ucFwIrpyxFRXbjPdL6scbjuzwitRqStDcNsFUGCY+MqLmcHnPHrTaiWcXfL+MbP1TR4CX0CFUaXfQ4E6tjquZXW2cq3MZJwJMh+fh4nKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709055165; c=relaxed/simple;
	bh=eDSdCZ5VL7HQbXq7svsYQ80zxv/WaZJHwRjE5B+FtF8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XNbW42Sjg7fqZ0y7hMzwWOc11VazXx8c8CvROw7QoMOXFk+l0cQGcaUmN7iBVt0RuI8iL4YhlVBzxOsBqSCm/iH25lew+9oOHRkfe70T2DdLdrdibWJkUss2hca9kMjWLT92S1UVaIN8cOcaa5aWp3fnBg2ApZtr5wBQGqFB5Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=j9dlAbQ8; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="j9dlAbQ8"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 41RFhNe1005875;
	Tue, 27 Feb 2024 09:32:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	pfpt0220; bh=XVnIahW4v2gIbDotTcP+rKof8ZrCVR5ZRO7xoZSx3pA=; b=j9d
	lAbQ8jyzxrKdWG+oMbObTmiUrA8/LvsVjjPF0OYUqNT50YEqZtrTNEFTqd6oU5Ni
	oX/5ca1cu5MqBfTf+iuv7/egbrgRuJum0jk+xolQR62S6OX5Rb3CPdQPr2FYZ5r7
	mYTpRa0L+daapMZEvb9OGYiMzimqqdRqrdtDlYPx71L2qYJRwkWLw4AQwdW4k/uH
	4CiIoL+umg/TaVI4xIk6VCpodL8e7XghL90SAiBcvrWlghAx457E3F6gwGz5Xl+B
	o/BSRwC3VhNx9mh73DLBjBZOhE2BJmw0wmj55xGn6IVY8ts60KkrjgnSAekY1hTs
	Rdg28Aii2aA7OKCItsA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3whjm68h0q-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Feb 2024 09:32:41 -0800 (PST)
Received: from DC6WP-EXCH01.marvell.com (10.76.176.21) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1258.12; Tue, 27 Feb 2024 09:32:39 -0800
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH01.marvell.com (10.76.176.21) with Microsoft SMTP Server (TLS) id
 15.0.1497.48; Tue, 27 Feb 2024 11:41:52 -0500
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1258.12 via Frontend
 Transport; Tue, 27 Feb 2024 08:41:52 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id 2F0E63F7099;
	Tue, 27 Feb 2024 08:41:49 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH v2 05/11] qla2xxx: NVME|FCP prefer flag not being honored
Date: Tue, 27 Feb 2024 22:11:21 +0530
Message-ID: <20240227164127.36465-6-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20240227164127.36465-1-njavali@marvell.com>
References: <20240227164127.36465-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: HVqeD9TYU-SVAH4Muz5Kcg4bNHcqXL6A
X-Proofpoint-GUID: HVqeD9TYU-SVAH4Muz5Kcg4bNHcqXL6A
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-27_03,2024-02-27_01,2023-05-22_02

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
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 3f5a933e60d0..8377624d76c9 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -7501,6 +7501,7 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
 	struct scsi_qla_host *vp, *tvp;
 	struct req_que *req = ha->req_q_map[0];
 	unsigned long flags;
+	fc_port_t *fcport;
 
 	if (vha->flags.online) {
 		qla2x00_abort_isp_cleanup(vha);
@@ -7569,6 +7570,15 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
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
 
@@ -7639,6 +7649,14 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
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

