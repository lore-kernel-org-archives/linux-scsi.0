Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 690764446F4
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 09:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784022895; cv=none; b=IGZouEyi22ZDwttYI9rRwC/C42qLYxcN8hfaIbsAEfOFC55GOH2GDtEocJkd4A8DWt07Tve0kE7zm/i3oG6W2q3xsvNYDNudMmUC8kU6qcHQSs7zXUr5mDBg09u2DatLEBSEB4JMPy+5oOoIOY39wYsw9wZW3qJD+qloJy/cRYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784022895; c=relaxed/simple;
	bh=SSJ+f0bVjbnUNAZO4DgJU6UrWQZ2XkdiMPIi9hqoN5k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jo5Y/XLA87c54DqN/d1H0uLvLkCwmS+uXXnkQCZ7yDQ4EsAwe6LZEXBmrv31/FiBBDeSW6mudxU8Pwaq3qccI/grSPqeyghIqnbwFzOTwSPW2dk1IvyJVEP9dV82rss0gE4xwuClJ+Fuz8dWt/+kWfsptQV7BWJvQoge6c7xnXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=JPfdxQRR; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="JPfdxQRR"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66E6UDAK2407820;
	Tue, 14 Jul 2026 02:54:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=5
	memnFUsudtA7OngSeWjyki1bfkJF8gcSrposXJ3z7U=; b=JPfdxQRRnnetHuCjH
	Nm4DCdLkNSu9YFVuHCbZwZcu8KZxMNrGC77F0M9/xubcEDt0q3rSWhHChFKUYRxX
	LPVecr92aFY7uh776Dj4UFfGmcDEV0U2je8hG2q218lAfJJWsGvtDbFQZqkq3d1z
	V2rIcPJltxlndI3lOppJJG+GwEex1DAw0f+KmXJGexHNMIcmM6A//2vN9sGSuIO4
	yBhLtADcD8s7jL79t2hgD0SQn/27emaBlaeXAsenk3XiDu1Wg9y5daZz87c5wVkM
	MgPKfjhHzYiVcmYS7IL0PCxEEIdXJaCqBFlLfUvGFYb69loVPN15kxe8kGJ7r4Vr
	VOv4g==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4fc6k9npvr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Jul 2026 02:54:47 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 14 Jul 2026 02:54:46 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Tue, 14 Jul 2026 02:54:46 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id C8E295E6867;
	Tue, 14 Jul 2026 02:54:43 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v4 13/56] scsi: qla2xxx: Skip unsupported sysfs attributes for 29xx
Date: Tue, 14 Jul 2026 15:23:10 +0530
Message-ID: <20260714095353.289460-14-njavali@marvell.com>
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
X-Proofpoint-ORIG-GUID: 2Fbo9wjrVGHknzv9eOsCKxBz9AsfC1KV
X-Proofpoint-GUID: 2Fbo9wjrVGHknzv9eOsCKxBz9AsfC1KV
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX6NU/GHEd2/Dj
 bnNkcY6nL7yzFugLWCcPs1SPKw+wcicqPC40qcJnb6JgqVq8qMCtXZbGEolsSqKVwgVXYZBdRRE
 kHdYdHl2jCX22TYZyH7ZRlcwHviIjU8=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfXyG8MnDOfTn3U
 HOikMkGloWpO0AVjHM2cGdQJhQZQRBYoSYFmDXbgfot0QRQEhghnBmISOWpvTB/d0PTX96ga41Y
 CJuGLVbDO/W04kcmlcEktPpVG+79AC0VIIortUrfqvgib2H+CJPZbgZgCPpZW8NamVmzenDPpN+
 dLgn70hIOVYBSolzleXZdz+j5a8LWgxVk5gPE+/Vfwx4jF6wZqW3TAqX5+6N5ht870FU81gkx9D
 GKiGnB0iIy18WmWM1pte38qTPxskmbbd6FiOJieKHgbL4CnEk+Qj4/TRfTD0N8Vq62+gaN5Qn18
 oiYl9mzHHsmvesDWY9wX2kRk94YOKmNp8F67etEb3NKdEv3ti9LXIKYLXzH9BxoduMbG+Qrm6w2
 /HLJtqADFRyfWYQN0aAYX+Zc1T3QIIUnemL55yvYAz5Jij4/oM1skHOAPea8Z7tBBwNTxtS/AKY
 CluDx8Sqpo7cUp5xdIw==
X-Authority-Analysis: v=2.4 cv=ULLt2ify c=1 sm=1 tr=0 ts=6a560767 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=bdT1wdj0V6UCSXu2SXIA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-14_02,2026-07-10_01,2025-10-01_01

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

