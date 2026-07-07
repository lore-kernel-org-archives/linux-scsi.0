Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8859533DED9
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403750; cv=none; b=GTiFkXhUfbmanU41f09TPqXGSIGh5J0Fle+FfmHSm0mYBQTyh5z/WPzPY/iIfXQJI9y7rVoz/hSnuZrYWDZMEe0l2+/raz0UI8HL8vL6w1NQ+c43NZnPhyTg+875djoqQj3+mxCsRx8GO+qsmrMCdeTR/jlpxdWBb0KHIhUf2WM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403750; c=relaxed/simple;
	bh=SSJ+f0bVjbnUNAZO4DgJU6UrWQZ2XkdiMPIi9hqoN5k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S4niSLvKd+iQRc7/jaVyJWNhJqdOjwlEmCmTiPR/UBEb9LX1zvjKbop7XKe6f4sXepn48/kaQTowjh62d0Oiz+9cARsMmRBZQX3bS3doIiN8BQm6kUF7polgnjwwRwfcygBckCsuXqntlOx6IM+7Q1iHGtkossVzGAbZMdbrhFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=DTAkfhvM; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="DTAkfhvM"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66747g2F854295;
	Mon, 6 Jul 2026 22:55:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=5
	memnFUsudtA7OngSeWjyki1bfkJF8gcSrposXJ3z7U=; b=DTAkfhvMeK1bxn0mv
	PAoMVE6MsnByWCJBXPytbLI70cp4VYIF8XUHJdQe3cXYJkQHnRu+gWiuuOW68pa1
	y79PyBWrLldTyJCR67VQa8G22Jug9/YETudm2n7fB6IvWfVqG1qeAIXa3Kt08TvK
	j47UdGsykI5rDA1uoUeySPSrp2teQBXkoMyVJh6rSN2VAaDV1DMT3GBLIicy6jYV
	ZNr5ZvbuAIMgIJFJw60bJj8Mfm3qNGPq0Sen7tCpoK2F2xVqNlwlOcOeK8N01Eo/
	vvOlHAY2NqqeJ+bxXRG40z0vEhSIXq5qcW78llrYXEGmlLdaOQf7VsnD+Fxo6vVQ
	xgcvQ==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4f8p2y0q12-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:55:39 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:55:39 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:55:38 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 9E5F83F7066;
	Mon,  6 Jul 2026 22:55:36 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 13/88] scsi: qla2xxx: Skip unsupported sysfs attributes for 29xx
Date: Tue, 7 Jul 2026 11:23:20 +0530
Message-ID: <20260707055435.2680300-14-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260707055435.2680300-1-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1MyBTYWx0ZWRfXwWNKz2feV3Gh
 Q4oUPdfLvQ7IAtTxZ80nt+NhP1Y0SYwT5LhBV9qj1GQF0ZBszsxxt7WFfyKX8KW2K/ja6uY6FmP
 LpL5c6txt9REfmcHIopBvq3QZJqZabVJ1+x9mKJj4y5Aj5mnyK+sU15HIB/uHqOzQTSpHvQeais
 dJDESsihDVb05MPwBQLJG/zzmWzw7SbIDf8vVpRodRUZN9SD+MHsm4JniVKhlyBW1EfxkIUni27
 4Yi5km7kz+GZJiAmMytL5wF44nWS1QbM815mMd9OeApaGrtV0GXmaTtdvZa2eP6pzB5agm/aTsj
 1HIUyqhckUMWdGJpMB38fihRM3lDvWBBV1HiwOg5DyrWeVm5HiBOkNUirbbYF4HKDwbUEYjE8tg
 9fs09Nsau9W0vPY4KK14uZ/spso1YWA2RbPW4DekMBios8UuGhXFZd2/DZp6Ed0ASS5ydEK9GMD
 4LytwMpJTCgh5bql8mg==
X-Authority-Analysis: v=2.4 cv=GoByPE1C c=1 sm=1 tr=0 ts=6a4c94db cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=bdT1wdj0V6UCSXu2SXIA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1MyBTYWx0ZWRfX9hEI7Evf3MB4
 eN0CHKmBNfurSD+U+S+1JOjgdL3qriMCWdKgtHe7/B2yG3FIFTBk6UiYYRDJHfA4Cqn9PQC1Jbq
 IIeYHqNo9np9cUbiPOFTRSyvRw27YGk=
X-Proofpoint-ORIG-GUID: PWVGkSr0WYHITFVzKbfFT43wpBsphHdU
X-Proofpoint-GUID: PWVGkSr0WYHITFVzKbfFT43wpBsphHdU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

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

