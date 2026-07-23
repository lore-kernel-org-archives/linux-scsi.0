Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D34D1DE4FB
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 05:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784783111; cv=none; b=jzi9aI6GiTiPsCSP+YnPsmgwLfzyPnP6Wy0TWf4MbYHCt96my4Rtgywsf0pJbtY6xlNsP+xi1svtXL5FvBLN7ZFvgX7R/OHYJu2ffFatnWtD3ONIjaJA1UcZEitjvG8rw7QRKDzhNAuQK2zjfo+hWZFVW9oTBAnANGm3TpTmtwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784783111; c=relaxed/simple;
	bh=SSJ+f0bVjbnUNAZO4DgJU6UrWQZ2XkdiMPIi9hqoN5k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KaE5/BoZuxyBN260aZDUyzIZKqBn0oBTBUGI+Ss6dOnhetBEdYF7Gcu4q2bbtfr5Xa+darQ0eHj53ViwGhU3LVXnsMO5sC3eXn60U8+6zBYMXQ+TB5YAXachoZFxnufi+OuPUAr4kzLunU+2pT7PR0fpcAdpKyW1MX2lXbtgbmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=EJNcEqCe; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="EJNcEqCe"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N4vn7f2435467;
	Wed, 22 Jul 2026 22:05:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=5
	memnFUsudtA7OngSeWjyki1bfkJF8gcSrposXJ3z7U=; b=EJNcEqCeNx8paIPI/
	qsPYcxFTIlcsgY0RzMHcLE81Uyo2LlOBffZ+JIwX2cKFmcpHay+EQ8ZrrFT4PR4z
	FSCsynnYFxvxOOwENVjjDF8b4ESExlKaNl00/PNCN+6q9xxOXmtEs7SaNFP7fVFh
	MBTbv3cXd9fwPWJoeQXmepaFOrdZ/YiLq+M50tmrjMQXPQITrWkHfnG4jCcoQYPN
	pwtK36k6ZbDeB0urSV7XI7CztYNykOWJlyE9NQZXsYRfvsU1E7NyXnDvhLDuGRZx
	/pX0IAS5yPprwgvSeL7XxmcmhVMfj+9brZmuW9l6NiNA1NNzD0J7wWvl1ZB4uIMD
	L01UQ==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4fka6k88f7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 22:05:05 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 22 Jul 2026 22:05:04 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 22 Jul 2026 22:05:04 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 11B855C68E6;
	Wed, 22 Jul 2026 22:05:01 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v6 13/56] scsi: qla2xxx: Skip unsupported sysfs attributes for 29xx
Date: Thu, 23 Jul 2026 10:33:30 +0530
Message-ID: <20260723050413.3897522-14-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260723050413.3897522-1-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfX4KpIG9HyzLHS
 sFXX48G4fkqJHtjWqLiE9T5GTK2AjshO4O1cIGl6Gm8gE3VRm4v+IU9SlMX3yW5hrwpbv45eVdq
 9dhaf/+DJjy1MDlTKEtfVC+DpoIF2MM=
X-Proofpoint-GUID: D9Vp4DFlTMTc0pbN1cooFAqglF_epuzj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfX+XNwCKk2McTE
 g9sli8ajcNhUrCdEjzuDvf7sVOK7nXm3ncvmS+vcwyj4pmqypjRGma0wjs1Rym0NEz0aEQU3rcn
 Yd/FKryPPR8edej2HHSVdHmZP/GlrjytV6A5n4Dd9eb1MyPUTtHFOI+gOi1zOo3B2vE0Hu7PZuJ
 4nhnZG8hYf3Jkmq1w+3TrCIAFiJX0aKYiVdnimhIxbBq+lCP/Q6oFGAI87JD/56TbDgp1gim8lr
 E/lEXnFnCbqXT+QKYqckrC0/WSYziwt8h+StjfhYyqESvpUHfaIl+N+7oWJgALVtQQ1P9/r2QFA
 AmVFL6Et+GZ57/iUIReUVd48+cXf6bYAJ0WAh4qP4o0T2bcdELriRUFxA7CuXvQkteBnHP5M/mw
 3iW/wa/XtFXxU+pMQGJ4PqNhmjKxpb94dG52gdkKu6eekz5/iwl6Dph2YA7tQAquzq95gS+fATU
 5pzkDmeb2SwvxAF5CDg==
X-Proofpoint-ORIG-GUID: D9Vp4DFlTMTc0pbN1cooFAqglF_epuzj
X-Authority-Analysis: v=2.4 cv=Ccs4Irrl c=1 sm=1 tr=0 ts=6a61a101 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=bdT1wdj0V6UCSXu2SXIA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_02,2026-07-22_02,2025-10-01_01

Not all sysfs attributes are applicable to the 29xx adapter.
Return -EPERM for attributes that are meaningless on 29xx (gold
firmware version, 84xx firmware version, flash block size, VLAN
ID, VN-port MAC address, and CNA firmware dump toggle) so that
userspace tools do not see stale or undefined values.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_attr.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 800751ab562a..e8755ab86b6a 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1471,6 +1471,9 @@ qla2x00_optrom_gold_fw_version_show(struct device *dev,
 	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
 	struct qla_hw_data *ha = vha->hw;
 
+	if (IS_QLA29XX(ha))
+		return -EPERM;
+
 	if (!IS_QLA81XX(ha) && !IS_QLA83XX(ha) &&
 	    !IS_QLA27XX(ha) && !IS_QLA28XX(ha))
 		return scnprintf(buf, PAGE_SIZE, "\n");
@@ -1499,6 +1502,9 @@ qla24xx_84xx_fw_version_show(struct device *dev,
 	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
 	struct qla_hw_data *ha = vha->hw;
 
+	if (IS_QLA29XX(ha))
+		return -EPERM;
+
 	if (!IS_QLA84XX(ha))
 		return scnprintf(buf, PAGE_SIZE, "\n");
 
@@ -1565,6 +1571,9 @@ qla2x00_flash_block_size_show(struct device *dev,
 	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
 	struct qla_hw_data *ha = vha->hw;
 
+	if (IS_QLA29XX(ha))
+		return -EPERM;
+
 	return scnprintf(buf, PAGE_SIZE, "0x%x\n", ha->fdt_block_size);
 }
 
@@ -1573,6 +1582,10 @@ qla2x00_vlan_id_show(struct device *dev, struct device_attribute *attr,
     char *buf)
 {
 	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
+	struct qla_hw_data *ha = vha->hw;
+
+	if (IS_QLA29XX(ha))
+		return -EPERM;
 
 	if (!IS_CNA_CAPABLE(vha->hw))
 		return scnprintf(buf, PAGE_SIZE, "\n");
@@ -1585,6 +1598,10 @@ qla2x00_vn_port_mac_address_show(struct device *dev,
     struct device_attribute *attr, char *buf)
 {
 	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
+	struct qla_hw_data *ha = vha->hw;
+
+	if (IS_QLA29XX(ha))
+		return -EPERM;
 
 	if (!IS_CNA_CAPABLE(vha->hw))
 		return scnprintf(buf, PAGE_SIZE, "\n");
@@ -1716,6 +1733,10 @@ qla2x00_allow_cna_fw_dump_show(struct device *dev,
 	struct device_attribute *attr, char *buf)
 {
 	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
+	struct qla_hw_data *ha = vha->hw;
+
+	if (IS_QLA29XX(ha))
+		return -EPERM;
 
 	if (!IS_P3P_TYPE(vha->hw))
 		return scnprintf(buf, PAGE_SIZE, "\n");
-- 
2.47.3

