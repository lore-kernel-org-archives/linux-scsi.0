Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F152539A4D8
	for <linux-scsi@vger.kernel.org>; Mon,  1 Jun 2026 10:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780309808; cv=none; b=NgZXHJb12yuY7Azm1GouoSV83WAdPwo2cSkl34fzDVAFL364q4/R+O/fEMnWrNTe71qtfC1AV8yVNJ+el9ce2xzcID/FuwSxCojaJshLFokbf2EBRMjxy0K6ZXqzw/i3rGKOvekEPAW6F+Q3XlSS38zADy/58ozvFe87Xz+d8aE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780309808; c=relaxed/simple;
	bh=lp9BQ0RYvdylgRUwL589PHCohzOezM5Wx35MndJKW98=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TAg9nTBjINOn9Uxyb8hp6YISryX62XFRWWYaHv2Whc5FToiVOFsgXb087ZeNSGWfQaPpqR5Y3nkdrM0rnfZKIfTfzg7f0VzPeComBdDTmunfNQf3jk9uQ18ZBm4Zs+NpbwYnozFNFclECqTPJqBy9jmZJRuRdY/O5gpD0C3a6Po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=kQk6zcQl; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="kQk6zcQl"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64VN0LBi3439390;
	Mon, 1 Jun 2026 03:30:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=C
	+jqenlzp7Uv9W1vjPgFU8THlv1oFOAIcCwmkmtk39c=; b=kQk6zcQl/Mdr5Ixej
	QWVJqADwe+ccHlsj164+tf+QZPDuQiPl+p7vL+M+FnhbxTTgF6f+E1kK2bUKnqJp
	L/PaPCE2785qsShb6Pl1VBt8mrTMshDN/Y37hyrUWg+0DfsDVWo1Oa+24mtdEWIQ
	Ntz8p/wW3FCv1GZaTk4ptn2ZvJKqgH0Hk+N5WWFaocKWVwQn71qJ/aK3PSu+9NJS
	oO6Nh1cNbbF4Vx5x/OkkDigY56NB1G5kc/SXCi56U7EWSYYFxqQh3SgWkcEd2Kvc
	ghtJA6V/+lcUgK68L5E62s+HRdb8IB4drmJTXU41EEV7r+qo/1nPi0+w2CHqeR65
	KeghA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4eggn8b8u3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jun 2026 03:30:03 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 1 Jun 2026 03:30:02 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 1 Jun 2026 03:30:02 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id B27573F7053;
	Mon,  1 Jun 2026 03:29:59 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 15/44] scsi: qla2xxx: Skip unsupported sysfs attributes for 29xx
Date: Mon, 1 Jun 2026 15:58:24 +0530
Message-ID: <20260601102853.328426-16-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260601102853.328426-1-njavali@marvell.com>
References: <20260601102853.328426-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: C_bKoMRuMH-OThKhiaUa9a8_DNa2uiyZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAxMDEwNSBTYWx0ZWRfXw2ome4HddtWd
 Up9/UFFUhtWjjiSaa774NvQ8fFOFD7ibvYr4DVpY4tgCuwzeGshac7BdSVAY12jXfZQ2u790i+K
 6nMzVQ1qehBCMvk8kzLS1Z0f8aO6l94lnysumLt5/mF+JAAZK87hzL12TFKtCzkThYwGHmzjfsr
 TmMPrMbU6bfn7ubN1SpqOjdBJi3x+aydsE60XNNFTmgMb10JunRCHGghmail5fy/zDxbLkxVc1I
 ebCbq739KTpl9cG3vzqwXBZ/9QG2SLodSQoeuoVhApHtFlsVLq0LWytnk8OYbxXKE2MxxbvbjDg
 M3TC6L5uMVqJviWIZelSGeQ+2BQIAGabjItHUuMiI4a6kn1N2dvvq0g+xFWLSNWsWitr73vUDdC
 7ttmnQ+mWBvH9J25n+5BK47sW/IYh3pOCPbbrllMQ6kznFSuuEgI+rXzd6ajsf+OMIwhOfJdhk/
 JGsKMltEKPyWn3pAE0A==
X-Proofpoint-GUID: C_bKoMRuMH-OThKhiaUa9a8_DNa2uiyZ
X-Authority-Analysis: v=2.4 cv=ON0XGyaB c=1 sm=1 tr=0 ts=6a1d5f2b cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=bdT1wdj0V6UCSXu2SXIA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_03,2026-05-28_03,2025-10-01_01

Not all sysfs attributes are applicable to the 29xx adapter.
Return -EPERM for attributes that are meaningless on 29xx (gold
firmware version, 84xx firmware version, flash block size, VLAN
ID, VN-port MAC address, and CNA firmware dump toggle) so that
userspace tools do not see stale or undefined values.

Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
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

