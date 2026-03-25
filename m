Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3299939F191;
	Wed, 25 Mar 2026 15:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774452226; cv=none; b=HwZsjsmq5UYqMwyvdY/zei2PW676uCrUOL8Pol2WtDO7g4EAadcWHZhM7O7BcLqigb5k/aefZpUwa3vouC4dfu/tscg+VNY1CMGrIV/jCOwdAbuqX0SKEkCgXBg+KbvePSLZjDM7mGkMoRX2PbZjT1RQk0DYotx9DUJZRV44GDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774452226; c=relaxed/simple;
	bh=dQWR8jo2VEu0nSk1XXsgKikunwk6SuzRu/wQffDv6Vg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Bx0Pl/ep72PK0z4sUV50WCBOIbuhleW7dAXFKX+POI+sLRGiIrUmJYq1CqhBetY/HUbJ0xE9IXk6so1xr+p1VFBD82CP1t4/DmdXVeKbF0ixTdgDnKlpFlteT62OI1epdGNeuJpOVMaXbv1cwC4pGpE2VbX4HwZGyPJ+43QhIPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=cTFoPU1r; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="cTFoPU1r"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62PFHDjN585582;
	Wed, 25 Mar 2026 15:23:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=1cRO/gAArtb
	BZab01l1n3nfaU/pU+lHOkGnEm2AqQjk=; b=cTFoPU1rh1elzhqxMKXJa/6cbhR
	mEJhxu9GgrH1MuKBUg9DqQ8Z092Y2gpVwbyknqaKiK5tRycseYKiuRP9tzH9jgDN
	ksVstYhVN3NUKQ1tt6BCBjPfq4/Dx07CyG41lqR45a1q34d5UMxlNzY20XIp+0LD
	B6WzpRnD4JPiLrJbOW5JFeglaZUze9jqEJAbZrmXqS08ZlaHAGQpU6M6d8CepBun
	5KgWjlSAaU+yHUY7mAXzsBSnqaAzm0lOolSK+9sKN0TneA1dc8jCn713Ur++pRQ5
	dragZ62+YMpZ1kfvYsGRXGFZeDbshd/MDZ4oDCMTt3fKfughCIJRzIlQ+Bw==
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d46tp2p3n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Mar 2026 15:23:32 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA04.qualcomm.com [127.0.0.1])
	by NALASPPMTA04.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTP id 62PFJRNd001889;
	Wed, 25 Mar 2026 15:23:31 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA04.qualcomm.com (PPS) with ESMTPS id 4d3uva5drj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Mar 2026 15:23:31 +0000
Received: from NALASPPMTA04.qualcomm.com (NALASPPMTA04.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 62PFMU1V008657;
	Wed, 25 Mar 2026 15:23:31 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA04.qualcomm.com (PPS) with ESMTPS id 62PFNVcY009909
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Mar 2026 15:23:31 +0000
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id 274E15AE; Wed, 25 Mar 2026 08:23:31 -0700 (PDT)
From: Can Guo <can.guo@oss.qualcomm.com>
To: avri.altman@wdc.com, bvanassche@acm.org, beanhuo@micron.com,
        peter.wang@mediatek.com, martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v5 05/12] scsi: ufs: core: Add debugfs entries for TX Equalization params
Date: Wed, 25 Mar 2026 08:21:47 -0700
Message-Id: <20260325152154.1604082-6-can.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260325152154.1604082-1-can.guo@oss.qualcomm.com>
References: <20260325152154.1604082-1-can.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: YlNVyNwRfyxyqBD7fOUNi64HXf99qWhb
X-Authority-Analysis: v=2.4 cv=F4lat6hN c=1 sm=1 tr=0 ts=69c3fdf4 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=yOCtJkima9RkubShWh1s:22 a=N54-gffFAAAA:8 a=PY6Zn8H8AAAA:8 a=EUspDBNiAAAA:8
 a=ufAJUjbdAAAA:8 a=0IiJqymllj2wnhsb30kA:9 a=ySS05r0LPNlNiX1MMvNp:22
 a=rB1ygNaI0PWiOa_UD5GD:22
X-Proofpoint-GUID: YlNVyNwRfyxyqBD7fOUNi64HXf99qWhb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI1MDExMCBTYWx0ZWRfX8XU+m8hsVW+D
 ADbHaQBBhlH11fJONqGVz9+L9e0oLD3BqaluEP8cvhE31DKTiC9NXAlya88ki8BrbADjuOqFbgc
 +ch4N/09VxPdk6012BpfarNlLw2cMWdEbjQhHGNB6rfVKm2OWdXPM/z+qnCPQulB+RWa5UHkHGC
 WfxwrMyY0wKTbyEXD9ChxD+vaaC385/AQl/IwKQplBvHVXrChAKt++cuABxKNVd2365FyYdQgsy
 VU7tUHXwm6ykAJ/zxbIu53YDym6GkJPuP4LrrfPNonnNV56ppLG81L2/m/q93YOVBxOuA5sEl55
 O73BsII1RAysqDn3wlNE9R0box9xDf2KzDIyVqAwkkeaJcQXgOvt2SnGBt90lMQ0khF7jZjCorP
 Sr32l6Up49JGgs+cOwPelfcsb3xd74rdrFeGwUberbduB4KPB8vb27A8KIYJig1HKWue4xoXLs+
 RL0pe6TPTt10x6DdVqQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-25_04,2026-03-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0 adultscore=0
 malwarescore=0 clxscore=1015 suspectscore=0 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603250110

Add debugfs support for UFS TX Equalization and UFS TX Equalization
Training (EQTR) to facilitate runtime inspection of link quality. These
entries allow developers to monitor and optimize TX Equalization
parameters and EQTR records during live operation.

The debugfs entries are organized on a per-gear basis under the HBA's
debugfs root. Since TX EQTR is only defined for High Speed Gear 4 (HS-G4)
and above, EQTR-related entries are explicitly excluded for HS-G1
through HS-G3 to avoid exposing unsupported attributes.

The ufshcd's debugfs folder structure will look like below:

/sys/kernel/debug/ufshcd/*ufs*/
|--tx_eq_hs_gear1/
|  |--device_tx_eq_params
|  |--host_tx_eq_params
|--tx_eq_hs_gear2/
|--tx_eq_hs_gear3/
|--tx_eq_hs_gear4/
|--tx_eq_hs_gear5/
|--tx_eq_hs_gear6/
   |--device_tx_eq_params
   |--device_tx_eqtr_record
   |--host_tx_eq_params
   |--host_tx_eqtr_record

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
---
 drivers/ufs/core/ufs-debugfs.c | 229 +++++++++++++++++++++++++++++++++
 drivers/ufs/core/ufs-txeq.c    |   7 +-
 drivers/ufs/core/ufshcd-priv.h |   2 +
 3 files changed, 237 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufs-debugfs.c b/drivers/ufs/core/ufs-debugfs.c
index e3baed6c70bd..831758b45163 100644
--- a/drivers/ufs/core/ufs-debugfs.c
+++ b/drivers/ufs/core/ufs-debugfs.c
@@ -209,6 +209,204 @@ static const struct ufs_debugfs_attr ufs_attrs[] = {
 	{ }
 };
 
+static int ufs_tx_eq_params_show(struct seq_file *s, void *data)
+{
+	const char *file_name = s->file->f_path.dentry->d_name.name;
+	u32 gear = (u32)(uintptr_t)s->file->f_inode->i_private;
+	struct ufs_hba *hba = hba_from_file(s->file);
+	struct ufshcd_tx_eq_settings *settings;
+	struct ufs_pa_layer_attr *pwr_info;
+	struct ufshcd_tx_eq_params *params;
+	u32 rate = hba->pwr_info.hs_rate;
+	u32 num_lanes;
+	int lane;
+
+	if (!ufshcd_is_tx_eq_supported(hba))
+		return -EOPNOTSUPP;
+
+	if (gear < UFS_HS_G1 || gear > UFS_HS_GEAR_MAX) {
+		seq_printf(s, "Invalid gear selected: %u\n", gear);
+		return 0;
+	}
+
+	if (!hba->max_pwr_info.is_valid) {
+		seq_puts(s, "Max power info is invalid\n");
+		return 0;
+	}
+
+	pwr_info = &hba->max_pwr_info.info;
+	params = &hba->tx_eq_params[gear - 1];
+	if (!params->is_valid) {
+		seq_printf(s, "TX EQ params are invalid for HS-G%u, Rate-%s\n",
+			   gear, ufs_hs_rate_to_str(rate));
+		return 0;
+	}
+
+	if (strcmp(file_name, "host_tx_eq_params") == 0) {
+		settings = params->host;
+		num_lanes = pwr_info->lane_tx;
+		seq_printf(s, "Host TX EQ PreShoot Cap: 0x%02x, DeEmphasis Cap: 0x%02x\n",
+			   hba->host_preshoot_cap, hba->host_deemphasis_cap);
+	} else if (strcmp(file_name, "device_tx_eq_params") == 0) {
+		settings = params->device;
+		num_lanes = pwr_info->lane_rx;
+		seq_printf(s, "Device TX EQ PreShoot Cap: 0x%02x, DeEmphasis Cap: 0x%02x\n",
+			   hba->device_preshoot_cap, hba->device_deemphasis_cap);
+	} else {
+		return -ENOENT;
+	}
+
+	seq_printf(s, "TX EQ setting for HS-G%u, Rate-%s:\n", gear,
+		   ufs_hs_rate_to_str(rate));
+	for (lane = 0; lane < num_lanes; lane++)
+		seq_printf(s, "TX Lane %d - PreShoot: %d, DeEmphasis: %d, Pre-Coding %senabled\n",
+			   lane, settings[lane].preshoot,
+			   settings[lane].deemphasis,
+			   settings[lane].precode_en ? "" : "not ");
+
+	return 0;
+}
+
+static int ufs_tx_eq_params_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ufs_tx_eq_params_show, inode->i_private);
+}
+
+static const struct file_operations ufs_tx_eq_params_fops = {
+	.owner		= THIS_MODULE,
+	.open		= ufs_tx_eq_params_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static const struct ufs_debugfs_attr ufs_tx_eq_attrs[] = {
+	{ "host_tx_eq_params", 0400, &ufs_tx_eq_params_fops },
+	{ "device_tx_eq_params", 0400, &ufs_tx_eq_params_fops },
+	{ }
+};
+
+static int ufs_tx_eqtr_record_show(struct seq_file *s, void *data)
+{
+	const char *file_name = s->file->f_path.dentry->d_name.name;
+	u8 (*fom_array)[TX_HS_NUM_PRESHOOT][TX_HS_NUM_DEEMPHASIS];
+	u32 gear = (u32)(uintptr_t)s->file->f_inode->i_private;
+	unsigned long preshoot_bitmap, deemphasis_bitmap;
+	struct ufs_hba *hba = hba_from_file(s->file);
+	struct ufs_pa_layer_attr *pwr_info;
+	struct ufshcd_tx_eq_params *params;
+	struct ufshcd_tx_eqtr_record *rec;
+	u32 rate = hba->pwr_info.hs_rate;
+	u8 preshoot, deemphasis;
+	u32 num_lanes;
+	char name[32];
+	int lane;
+
+	if (!ufshcd_is_tx_eq_supported(hba))
+		return -EOPNOTSUPP;
+
+	if (gear < UFS_HS_G1 || gear > UFS_HS_GEAR_MAX) {
+		seq_printf(s, "Invalid gear selected: %u\n", gear);
+		return 0;
+	}
+
+	if (!hba->max_pwr_info.is_valid) {
+		seq_puts(s, "Max power info is invalid\n");
+		return 0;
+	}
+
+	pwr_info = &hba->max_pwr_info.info;
+	params = &hba->tx_eq_params[gear - 1];
+	if (!params->is_valid) {
+		seq_printf(s, "TX EQ params are invalid for HS-G%u, Rate-%s\n",
+			   gear, ufs_hs_rate_to_str(rate));
+		return 0;
+	}
+
+	rec = params->eqtr_record;
+	if (!rec || !rec->last_record_index) {
+		seq_printf(s, "No TX EQTR records found for HS-G%u, Rate-%s.\n",
+			   gear, ufs_hs_rate_to_str(rate));
+		return 0;
+	}
+
+	if (strcmp(file_name, "host_tx_eqtr_record") == 0) {
+		preshoot_bitmap = (hba->host_preshoot_cap << 0x1) | 0x1;
+		deemphasis_bitmap = (hba->host_deemphasis_cap << 0x1) | 0x1;
+		num_lanes = pwr_info->lane_tx;
+		fom_array = rec->host_fom;
+		snprintf(name, sizeof(name), "%s", "Host");
+	} else if (strcmp(file_name, "device_tx_eqtr_record") == 0) {
+		preshoot_bitmap = (hba->device_preshoot_cap << 0x1) | 0x1;
+		deemphasis_bitmap = (hba->device_deemphasis_cap << 0x1) | 0x1;
+		num_lanes = pwr_info->lane_rx;
+		fom_array = rec->device_fom;
+		snprintf(name, sizeof(name), "%s", "Device");
+	} else {
+		return -ENOENT;
+	}
+
+	seq_printf(s, "%s TX EQTR record summary -\n", name);
+	seq_printf(s, "Target Power Mode: HS-G%u, Rate-%s\n", gear,
+		   ufs_hs_rate_to_str(rate));
+	seq_printf(s, "Most recent record index: %d\n",
+		   rec->last_record_index);
+	seq_printf(s, "Most recent record timestamp: %llu us\n",
+		   ktime_to_us(rec->last_record_ts));
+
+	for (lane = 0; lane < num_lanes; lane++) {
+		seq_printf(s, "\nTX Lane %d FOM - %s\n", lane, "PreShoot\\DeEmphasis");
+		seq_puts(s, "\\");
+		/* Print DeEmphasis header as X-axis. */
+		for (deemphasis = 0; deemphasis < TX_HS_NUM_DEEMPHASIS; deemphasis++)
+			seq_printf(s, "%8d%s", deemphasis, " ");
+		seq_puts(s, "\n");
+		/* Print matrix rows with PreShoot as Y-axis. */
+		for (preshoot = 0; preshoot < TX_HS_NUM_PRESHOOT; preshoot++) {
+			seq_printf(s, "%d", preshoot);
+			for (deemphasis = 0; deemphasis < TX_HS_NUM_DEEMPHASIS; deemphasis++) {
+				if (test_bit(preshoot, &preshoot_bitmap) &&
+				    test_bit(deemphasis, &deemphasis_bitmap)) {
+					u8 fom = fom_array[lane][preshoot][deemphasis];
+					u8 fom_val = fom & RX_FOM_VALUE_MASK;
+					bool precode_en = fom & RX_FOM_PRECODING_EN_BIT;
+
+					if (ufshcd_is_txeq_presets_used(hba) &&
+					    !ufshcd_is_txeq_preset_selected(preshoot, deemphasis))
+						seq_printf(s, "%8s%s", "-", " ");
+					else
+						seq_printf(s, "%8u%s", fom_val,
+							   precode_en ? "*" : " ");
+				} else {
+					seq_printf(s, "%8s%s", "x", " ");
+				}
+			}
+			seq_puts(s, "\n");
+		}
+	}
+
+	return 0;
+}
+
+static int ufs_tx_eqtr_record_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ufs_tx_eqtr_record_show, inode->i_private);
+}
+
+static const struct file_operations ufs_tx_eqtr_record_fops = {
+	.owner		= THIS_MODULE,
+	.open		= ufs_tx_eqtr_record_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static const struct ufs_debugfs_attr ufs_tx_eqtr_attrs[] = {
+	{ "host_tx_eqtr_record", 0400, &ufs_tx_eqtr_record_fops },
+	{ "device_tx_eqtr_record", 0400, &ufs_tx_eqtr_record_fops },
+	{ }
+};
+
 void ufs_debugfs_hba_init(struct ufs_hba *hba)
 {
 	const struct ufs_debugfs_attr *attr;
@@ -230,6 +428,37 @@ void ufs_debugfs_hba_init(struct ufs_hba *hba)
 			    hba, &ee_usr_mask_fops);
 	debugfs_create_u32("exception_event_rate_limit_ms", 0600, hba->debugfs_root,
 			   &hba->debugfs_ee_rate_limit_ms);
+
+	if (!(hba->caps & UFSHCD_CAP_TX_EQUALIZATION))
+		return;
+
+	for (u32 gear = UFS_HS_G1; gear <= UFS_HS_GEAR_MAX; gear++) {
+		struct dentry *txeq_dir;
+		char name[32];
+
+		snprintf(name, sizeof(name), "tx_eq_hs_gear%d", gear);
+		txeq_dir = debugfs_create_dir(name, hba->debugfs_root);
+		if (IS_ERR_OR_NULL(txeq_dir))
+			return;
+
+		d_inode(txeq_dir)->i_private = hba;
+
+		/* Create files for TX Equalization parameters */
+		for (attr = ufs_tx_eq_attrs; attr->name; attr++)
+			debugfs_create_file(attr->name, attr->mode, txeq_dir,
+					    (void *)(uintptr_t)gear,
+					    attr->fops);
+
+		/* TX EQTR is supported for HS-G4 and higher Gears */
+		if (gear < UFS_HS_G4)
+			continue;
+
+		/* Create files for TX EQTR related attributes */
+		for (attr = ufs_tx_eqtr_attrs; attr->name; attr++)
+			debugfs_create_file(attr->name, attr->mode, txeq_dir,
+					    (void *)(uintptr_t)gear,
+					    attr->fops);
+	}
 }
 
 void ufs_debugfs_hba_exit(struct ufs_hba *hba)
diff --git a/drivers/ufs/core/ufs-txeq.c b/drivers/ufs/core/ufs-txeq.c
index 04f9f1ffa43e..b68a7af78290 100644
--- a/drivers/ufs/core/ufs-txeq.c
+++ b/drivers/ufs/core/ufs-txeq.c
@@ -375,7 +375,12 @@ static int ufshcd_get_rx_fom(struct ufs_hba *hba,
 	return ret;
 }
 
-static bool ufshcd_is_txeq_preset_selected(u8 preshoot, u8 deemphasis)
+bool ufshcd_is_txeq_presets_used(struct ufs_hba *hba)
+{
+	return use_txeq_presets;
+}
+
+bool ufshcd_is_txeq_preset_selected(u8 preshoot, u8 deemphasis)
 {
 	int i;
 
diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index 20ec8d8ac0a4..13a957dc11d0 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -108,6 +108,8 @@ void ufshcd_apply_valid_tx_eq_settings(struct ufs_hba *hba);
 int ufshcd_config_tx_eq_settings(struct ufs_hba *hba,
 				 struct ufs_pa_layer_attr *pwr_mode);
 void ufshcd_print_tx_eq_params(struct ufs_hba *hba);
+bool ufshcd_is_txeq_presets_used(struct ufs_hba *hba);
+bool ufshcd_is_txeq_preset_selected(u8 preshoot, u8 deemphasis);
 
 /* Wrapper functions for safely calling variant operations */
 static inline const char *ufshcd_get_var_name(struct ufs_hba *hba)
-- 
2.34.1

