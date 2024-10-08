Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 202691DA5A;
	Tue,  8 Oct 2024 02:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728353099; cv=none; b=GY1MlY7SlqnLxCf6nSofXH5tTuUy6nSz0d7kdf/ZA8shsxVgCa6upVpYl6NPqt4QdaTqtYzW81RY6mM6luUd9YFCscXx8hHp3jTMRlO70AckmJWzqAWEQJ8JNzi0WX6vILPzckX+PJ+hd0AP4mAvOcg5akw2qp9yjtiUeYg0X0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728353099; c=relaxed/simple;
	bh=pRd4x/iiLKO4ozHcbOB10zammKjZUYsajkFl83dF/74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ezaq6GvNUHMutuhEAXt4N8SIYmPyIy8KHLzp8fwOVaR6E5exebzg2sMbsGf7Q+qoE4aqlLrzc7yIj2vt8jF1cG3HyvyKjTZH8cztGXXUHxxiIHr9sh+SoFAinV8LMuOgG3kbogHkP/HqRR1iQZ97Dk9z7PPvAsEjHVHKEc+9fKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nNRB8iNK; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nNRB8iNK"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4981MbNJ024471;
	Tue, 8 Oct 2024 02:04:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=JdixH
	91jVgOtkOuZkAeuHfqVuD6rnwniLViElyE+938=; b=nNRB8iNKBzQmh2R1XRq7a
	U8C0inkdK4DAd3V32K+2z3D4T39gQBtiNutLzFXehn89YsbLjpvTNn8MGc93NxbU
	Vb+sChRYBEeCgQ/itEjxSOCCCc3mrMhCYlSxt6VoLLuh+PI/f2HqMcESn1PVLD9l
	EyfnmpUzivbJ6ZPy7ABd3cUxRCU0QXmyxJPNDdRAzADzqpBU4At36jgW0iijsizY
	YO2Vqxjnu3AHVOmRBB0+gHcE0etC/hgMt86D0WM3+Zrot4cSWhgtxz+fsvpqRV9P
	w1NZTj8dUud30A709ZkHhHiD/gFCpraSDG7asEm/8i1o/XIi5GCNsn3A50m4xy1n
	A==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42300dvsjg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 08 Oct 2024 02:04:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 497NUTdL004626;
	Tue, 8 Oct 2024 02:04:41 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 422uw6k88u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 08 Oct 2024 02:04:40 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 49824dIt004476;
	Tue, 8 Oct 2024 02:04:40 GMT
Received: from mnc-mac.us.oracle.com (dhcp-10-39-198-64.vpn.oracle.com [10.39.198.64])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 422uw6k87u-3;
	Tue, 08 Oct 2024 02:04:40 +0000
From: Mike Christie <michael.christie@oracle.com>
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 2/7] scsi: target: Add atomic se_device fields
Date: Mon,  7 Oct 2024 21:03:11 -0500
Message-ID: <20241008020437.78788-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20241008020437.78788-1-michael.christie@oracle.com>
References: <20241008020437.78788-1-michael.christie@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-08_01,2024-10-07_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 phishscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2410080011
X-Proofpoint-GUID: KMU05S5Cek2K_u6N8gs5OG1WB922ZnX_
X-Proofpoint-ORIG-GUID: KMU05S5Cek2K_u6N8gs5OG1WB922ZnX_

This adds atomic fields to the se_device and exports them in configfs.

Initially only target_core_iblock will be supported and we will inherit
all the settings from the block layer except the alignment which userspace
will set.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_configfs.c | 42 +++++++++++++++++++++++++++
 include/target/target_core_base.h     |  6 ++++
 2 files changed, 48 insertions(+)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index c40217f44b1b..f3c7da650f65 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -578,6 +578,12 @@ DEF_CONFIGFS_ATTRIB_SHOW(unmap_zeroes_data);
 DEF_CONFIGFS_ATTRIB_SHOW(max_write_same_len);
 DEF_CONFIGFS_ATTRIB_SHOW(emulate_rsoc);
 DEF_CONFIGFS_ATTRIB_SHOW(submit_type);
+DEF_CONFIGFS_ATTRIB_SHOW(atomic_supported);
+DEF_CONFIGFS_ATTRIB_SHOW(atomic_alignment);
+DEF_CONFIGFS_ATTRIB_SHOW(atomic_max_len);
+DEF_CONFIGFS_ATTRIB_SHOW(atomic_granularity);
+DEF_CONFIGFS_ATTRIB_SHOW(atomic_max_with_boundary);
+DEF_CONFIGFS_ATTRIB_SHOW(atomic_max_boundary);
 
 #define DEF_CONFIGFS_ATTRIB_STORE_U32(_name)				\
 static ssize_t _name##_store(struct config_item *item, const char *page,\
@@ -1266,6 +1272,30 @@ static ssize_t submit_type_store(struct config_item *item, const char *page,
 	return count;
 }
 
+static ssize_t atomic_alignment_store(struct config_item *item,
+				      const char *page, size_t count)
+{
+	struct se_dev_attrib *da = to_attrib(item);
+	u32 val;
+	int ret;
+
+	ret = kstrtou32(page, 0, &val);
+	if (ret < 0)
+		return ret;
+
+	if (da->da_dev->export_count) {
+		pr_err("dev[%p]: Unable to change SE Device atomic_alignment while export_count is %d\n",
+		       da->da_dev, da->da_dev->export_count);
+		return -EINVAL;
+	}
+
+	da->atomic_alignment = val;
+
+	pr_debug("dev[%p]: SE Device atomic_alignment changed to %u\n",
+		 da->da_dev, val);
+	return count;
+}
+
 CONFIGFS_ATTR(, emulate_model_alias);
 CONFIGFS_ATTR(, emulate_dpo);
 CONFIGFS_ATTR(, emulate_fua_write);
@@ -1302,6 +1332,12 @@ CONFIGFS_ATTR(, max_write_same_len);
 CONFIGFS_ATTR(, alua_support);
 CONFIGFS_ATTR(, pgr_support);
 CONFIGFS_ATTR(, submit_type);
+CONFIGFS_ATTR(, atomic_alignment);
+CONFIGFS_ATTR_RO(, atomic_supported);
+CONFIGFS_ATTR_RO(, atomic_max_len);
+CONFIGFS_ATTR_RO(, atomic_granularity);
+CONFIGFS_ATTR_RO(, atomic_max_with_boundary);
+CONFIGFS_ATTR_RO(, atomic_max_boundary);
 
 /*
  * dev_attrib attributes for devices using the target core SBC/SPC
@@ -1345,6 +1381,12 @@ struct configfs_attribute *sbc_attrib_attrs[] = {
 	&attr_pgr_support,
 	&attr_emulate_rsoc,
 	&attr_submit_type,
+	&attr_atomic_supported,
+	&attr_atomic_alignment,
+	&attr_atomic_max_len,
+	&attr_atomic_granularity,
+	&attr_atomic_max_with_boundary,
+	&attr_atomic_max_boundary,
 	NULL,
 };
 EXPORT_SYMBOL(sbc_attrib_attrs);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 97099a5e3f6c..6c87bd018983 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -715,6 +715,7 @@ struct se_dev_attrib {
 	bool		is_nonrot;
 	bool		emulate_rest_reord;
 	bool		unmap_zeroes_data;
+	bool		atomic_supported;
 	u32		hw_block_size;
 	u32		block_size;
 	u32		hw_max_sectors;
@@ -726,6 +727,11 @@ struct se_dev_attrib {
 	u32		unmap_granularity;
 	u32		unmap_granularity_alignment;
 	u32		max_write_same_len;
+	u32		atomic_max_len;
+	u32		atomic_alignment;
+	u32		atomic_granularity;
+	u32		atomic_max_with_boundary;
+	u32		atomic_max_boundary;
 	u8		submit_type;
 	struct se_device *da_dev;
 	struct config_group da_group;
-- 
2.34.1

