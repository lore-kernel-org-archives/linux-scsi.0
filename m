Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE44355813
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 09:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784022962; cv=none; b=tzOP9rF/SHcE47JdOPCoW3Nj5tmKyn8QLrrtm/z++AS9kwZm67/0KdXqxU0zwbHoqx6of9PKRCBEd5WYRIciQyXmUaGPl4/yRRj7Yp46FqfhjYcA6IuYimhhcA2bYgCmcY4jfSekHCkwpFG6Jp2I9oAwLaQzAKnbdWZtxBN3kOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784022962; c=relaxed/simple;
	bh=eB9WP/wZa7W8e7GsWn57ny0lFbXTYL8w9EeakWCn+BA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZxI0cqc13zqxh8U5JdOSTnLehR4XHAUEw/OrbTJdRlH+4bPdFdrt9Ualfn/Slrfq/DPNtN8vQpZ3z+jQVDEJYSxFJ0OPMjYlEmkaeDrfHzL80WKWqyuVbZxQnV0yIJVJs56r8Sy1LRLYDGeekzJmqCY5XLABZypVz3wldmUmFe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=aBs283Vf; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="aBs283Vf"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66E6Ukqn3693372;
	Tue, 14 Jul 2026 02:55:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=s
	fLoo/z9F6OeKGMx+MoQlIdc+XDzT5UUKELEdGDxIuI=; b=aBs283Vf3OqC5vFE/
	H2QDMT4rwUfIGMsP9O7pmfAnSumQXDtHW8RY8mNXQVGekqDpn/M6GeST4n6Hb86R
	onK6ECzrF58gdnsNgMEEP2HZAt6jILV7+FKp/DQdc8b16dNf/QeiD/lMT+IPEMdH
	GsVU5wUmimxFE0ApV3N0XlTLd0HcUByTXAnANmbRoAaCEM/hUn6wSyPhIAnk5rIP
	ebg8euWJBhAvwV3neZX74cZgOzA1BRG0j78soV9jGnmRfCeRBzGbV9VXUURkFp/S
	OVQprpDGsitvfQ+D2Cbh183Zka57EtlTq7q0vII44Fhc/9RJDKmCeKHJ6XBP6wpK
	QTVog==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4fbnbey8qp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Jul 2026 02:55:57 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 14 Jul 2026 02:55:56 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Tue, 14 Jul 2026 02:55:56 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 1CB935E6867;
	Tue, 14 Jul 2026 02:55:53 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v4 36/56] scsi: qla2xxx: Add build-time size check for VP config IOCB layout
Date: Tue, 14 Jul 2026 15:23:33 +0530
Message-ID: <20260714095353.289460-37-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260714095353.289460-1-njavali@marvell.com>
References: <20260714095353.289460-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: Z1Vg3umnVUx0YW_DZTyj44n_GLSEK92o
X-Authority-Analysis: v=2.4 cv=WOdPmHsR c=1 sm=1 tr=0 ts=6a5607ad cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=QdJASnsuDdI3Qm7nM90A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: Z1Vg3umnVUx0YW_DZTyj44n_GLSEK92o
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX0ILZNQf1NSK/
 wbPfePqL0IhXb48eiUhY7eoZ2CmH0755z+x5EcX2E9splaCe+WcpJYE8V6HfgN4kz/i39fl+GY2
 zxZgYzdp7qVtBSNGBQV3j507NzGJ9y0=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX6ls3w8U+P029
 D1wR/WKLZ3BgjESyf7zZjYEU0W+raa0uUCmbV1qpA/zKqtbGKIBpZPlCujNM0eVSyJmwElWRTh8
 9rd0pTbdUOKTCtQfD9koAb4YtqIfbH8bTABStDYlEetXml466Yc/wYYjmyfrtEMYHaMp3G2kLLd
 k9MA1+S+dzlzPMo1Oxxe5HtQo37vqjSgL1CkSmhHVCkVZEss+XwuCKfECsvVpLviuJuU6RMMtQH
 6t27TIG1TVAecdaLQp1dgEk4Q/8IaCw4FR/MGp6z910uOmMPU6n70sbvf3b/Qaq/BLK4sfjePpE
 sYU1IGCurVyTvEgeIMLZVfP/UpIYx0OLf/EktRcWJqwMcSuVscChD3Dpiugz1ZNtsCHgObVhTE4
 pkRxCjMKAzzFSKHiax0yBEPHKbfLyk4bhlPmtb1F+VaiOB+sIDqhjTDdaOzTytvRXB+/3P7uSdU
 +ZFE/hXltgqIxj+G8+g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-14_02,2026-07-10_01,2025-10-01_01

Add a BUILD_BUG_ON for struct vp_config_entry_24xx_ext to verify its
128-byte size at compile time alongside the existing 64-byte check for
struct vp_config_entry_24xx.

Document in qla24xx_modify_vp_config() that the ext variant overlays
the base 24xx layout for the first 64 bytes (all fields this helper
reads and writes), so the IOCB can be built through a single struct
vp_config_entry_24xx pointer regardless of the adapter's IOCB stride.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 8 +++++++-
 drivers/scsi/qla2xxx/qla_os.c  | 1 +
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 0d7aa6fce007..3ebda35dd584 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -4364,6 +4364,13 @@ qla24xx_modify_vp_config(scsi_qla_host_t *vha)
 		return QLA_MEMORY_ALLOC_FAILED;
 	}
 
+	/*
+	 * vp_config_entry_24xx_ext overlays vp_config_entry_24xx for the
+	 * full 64-byte 24xx layout (the ext variant merely appends fields
+	 * at offset 64+ which this helper never touches), so the IOCB is
+	 * built and inspected through a single struct vp_config_entry_24xx
+	 * pointer regardless of adapter stride.
+	 */
 	vpmod->entry_type = VP_CONFIG_IOCB_TYPE;
 	vpmod->entry_count = 1;
 	vpmod->command = VCT_COMMAND_MOD_ENABLE_VPS;
@@ -4392,7 +4399,6 @@ qla24xx_modify_vp_config(scsi_qla_host_t *vha)
 		    le16_to_cpu(vpmod->comp_status));
 		rval = QLA_FUNCTION_FAILED;
 	} else {
-		/* EMPTY */
 		ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x10c0,
 		    "Done %s.\n", __func__);
 		fc_vport_set_state(vha->fc_vport, FC_VPORT_INITIALIZING);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index ad070c0bf7db..8e5d49abead4 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -8436,6 +8436,7 @@ qla2x00_module_init(void)
 	BUILD_BUG_ON(sizeof(struct verify_chip_rsp_84xx) != 52);
 	BUILD_BUG_ON(sizeof(struct vf_evfp_entry_24xx) != 56);
 	BUILD_BUG_ON(sizeof(struct vp_config_entry_24xx) != 64);
+	BUILD_BUG_ON(sizeof(struct vp_config_entry_24xx_ext) != 128);
 	BUILD_BUG_ON(sizeof(struct vp_ctrl_entry_24xx) != 64);
 	BUILD_BUG_ON(sizeof(struct vp_ctrl_entry_24xx_ext) != 128);
 	BUILD_BUG_ON(sizeof(struct vp_rpt_id_entry_24xx) != 64);
-- 
2.47.3

