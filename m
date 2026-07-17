Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32931360ED1
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 15:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784302195; cv=none; b=tTo8Yq90wdebxEd5htV3OMiNBuEX+dXC92pDk1N+y9c+Q28l138NCGpL4nbm+YOy0htO+rCU7jWzEXnyRkZro4q78Yl5jsug1kBd/d2yUWP6vx0afEf2OWwPM7Ii6E1o5A+/Cgrtsj7Llj7PtuukmrGPSiDh3HSo33xXcPJRnd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784302195; c=relaxed/simple;
	bh=SSJ+f0bVjbnUNAZO4DgJU6UrWQZ2XkdiMPIi9hqoN5k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nsqwMWrq/W4qYE4CJGJFcn8FDJGDlAmMzOQGRSfVGn0IU1mnC7f0GDbaATgzEEM9IE3QsY7xpDgenEBuSik4z0FfxO6QTEJz+jz1L6+OpZxHe4vOYh4kbxXdvR/GNbUwC7DyOVsj+KukJ372NmqHMovwMgJoTtoZ+pkq/fSaOrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=MVHVSCD2; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="MVHVSCD2"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HE80lp094830;
	Fri, 17 Jul 2026 08:29:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=5
	memnFUsudtA7OngSeWjyki1bfkJF8gcSrposXJ3z7U=; b=MVHVSCD2D/Gyg8rZc
	7nzffhoMAPnsn8mI5Ev9lcVtVJYxowkEkaPJJ8jxmms30icybcPTqPiu3HUZYiAM
	2fBYg19NCvNvpPGQe+w9q0Kkjaka6ySvAPrRwExhdkWloB3K2G5oqn1RW+f8l007
	4AyehDswlHRja2oVkBBXcW2fd1lorkbSQAxPQij4MocbQgJuVgSfHln/e+OLARso
	ZuL97qKsce+CrP9YrtPLGsqjM63fe94lKP6fDzhDxMwbqcc3K5ZhTNsRBVVbmHCG
	AIH7Qn5s/mc0NYUfl4xz6YGxaSmucg8wi3Ujbc8z/V+oXxQyACG/MS7I/Eeaai6D
	OGC6g==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4ffhg8rxa9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jul 2026 08:29:50 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 17 Jul 2026 08:29:49 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 17 Jul 2026 08:29:49 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id BF0D35B693D;
	Fri, 17 Jul 2026 08:29:46 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v5 13/56] scsi: qla2xxx: Skip unsupported sysfs attributes for 29xx
Date: Fri, 17 Jul 2026 20:58:21 +0530
Message-ID: <20260717152904.3155730-14-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260717152904.3155730-1-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: M_QAYIf9w5XZaGoABpyqaoTjsJbGJQxL
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfXx2bMFIlNVfdy
 j7W7ntdBJAuKJDaWO4qFW3koNaH4ETe9m5FDPLTpTE+wu+1lioccqM6LG+PATKgo9yqQzn39Ome
 t7VNfyo3N2DOasVAqfDeF8cF9M6tJYU=
X-Authority-Analysis: v=2.4 cv=SpKgLvO0 c=1 sm=1 tr=0 ts=6a5a4a6e cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=bdT1wdj0V6UCSXu2SXIA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfXz4IhzgjChRwS
 akpg+T+KAUBwie00Ps1QoD8MacoMiAy729934uN3+xlG+ScpopKXEbozDlw3aiZXsfGVgy2dsek
 yJnEu634beQhdoSVFX5RtOfR337X/Ol5xb8VLPICro0cVHlFUM0VkrC4jMEdHmIPzFK6xl2zHju
 nzBihkAy+5aCt8e+ZTaM9rcRaQ2Z7H67BXjrc/g8lJbPoCZ5/mtvsdk5cb8ESgD4/Q0pwhSS/6H
 rtPqfkqKBrbiI0BDHA9mCxN1JINhDMl2oM4YLSSznteM4Fw7LMnPaoM8r+WiArCWkoFFkRMX1fP
 t5U0jJBFRGWx28ohhB6YjtQiFW3fueYF5AxYZivPBbqBZCah9I2PlZZs6jl8y8XAZ5CYuGy1T4w
 e7o+XqGGnBB8d/BV8XbjBfW4dPvLnouoKFspbmr3jdlKvx6JFJfgcNfb0PpEcQ/Ks56XLLsIHKq
 ZN3t//rY2uO5+2jcjMA==
X-Proofpoint-ORIG-GUID: M_QAYIf9w5XZaGoABpyqaoTjsJbGJQxL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_04,2026-07-17_01,2025-10-01_01

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

