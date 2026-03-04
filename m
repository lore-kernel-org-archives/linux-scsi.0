Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0FDC3A0B20;
	Wed,  4 Mar 2026 13:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772632456; cv=none; b=E6KrKXdIDw3k0mYTCkQn+z306EO4DXF1Hyow7CKFtCm3Js2AsW0z+opNrcpDTJOj+4BsDVFacifmvejxp7Q365CpKcMW7Bq0VA5LgIPDv+52kKufYnyPE6PFi93pWk2pXbro6yNOHzx8Svn1C0f/OzL0vbRpGMQEe+iRWTaU0KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772632456; c=relaxed/simple;
	bh=5fJoHSOmnreeIVtISPHRTvxb3dOnnLvtcnvpg1L8WE0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rdpvZ9CuRWymzJ5Ake0R9mg+Nc/iefu/do/wpKmxT2OsBpzpZsr55IKuF5s7UwpAahWQy7UHlRrqVm7QYgh6jvUiKW2ckxCBSCcPNpsMgL01n57gyKA11IVh7Qy3V44VRb8tBklmAg2TbR7yXGRRmAE7r1mwJpKjuVK35mEez34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=eiMnaddP; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="eiMnaddP"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 624CW8ed3110371;
	Wed, 4 Mar 2026 13:54:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=TPklJFAv1Es
	JA2G83WNF9p6+pyjY6rMIwMQpxGevl80=; b=eiMnaddP1xue2PajttvsF0bJOIb
	w7f1nnSFsXErQiKfN5gkCt2NRfBgFSzogdQ6QVkLad6Vva+ClQCeCm8L6AxMsoER
	oiDv5E6YRKfCEejkxOPmf/xVsbJRcUjnhsr/NFPX/Ah+lHVWr+4HXzjTSO/iXSfF
	b3TqvUNc9EXbTxkwcqMGOXW9uAnt0hGlv8dwvpnzeV1xKknKBZON/srtbfojTPf0
	NEXtwqZy1hb7RJ+1OwME/9vVNNtypFwmdV4YnncgsEsQZaZEdXTUysglx3+zJnfh
	2Z3rRhIx/yM+5Ona+60K5CzBtHzBRx4bhqYFlncHj2oHT0PDJAB/Lr5fEaw==
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cp5h2bbks-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Mar 2026 13:54:05 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA05.qualcomm.com [127.0.0.1])
	by NALASPPMTA05.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTP id 624Ds5pS028210;
	Wed, 4 Mar 2026 13:54:05 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA05.qualcomm.com (PPS) with ESMTPS id 4cpdg0nq4c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Mar 2026 13:54:05 +0000
Received: from NALASPPMTA05.qualcomm.com (NALASPPMTA05.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 624Ds5lV028202;
	Wed, 4 Mar 2026 13:54:05 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA05.qualcomm.com (PPS) with ESMTPS id 624Ds4gj028193
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Mar 2026 13:54:05 +0000
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id AD38D5A7; Wed,  4 Mar 2026 05:54:04 -0800 (PST)
From: Can Guo <can.guo@oss.qualcomm.com>
To: avri.altman@wdc.com, bvanassche@acm.org, beanhuo@micron.com,
        martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 05/11] scsi: ufs: core: Add debugfs entries for TX Equalization params
Date: Wed,  4 Mar 2026 05:53:07 -0800
Message-Id: <20260304135313.413688-6-can.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260304135313.413688-1-can.guo@oss.qualcomm.com>
References: <20260304135313.413688-1-can.guo@oss.qualcomm.com>
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
X-Authority-Analysis: v=2.4 cv=JqL8bc4C c=1 sm=1 tr=0 ts=69a8397d cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=_K5XuSEh1TEqbUxoQ0s3:22 a=EUspDBNiAAAA:8 a=XdPEaRKDkzQItEEY_e8A:9
X-Proofpoint-ORIG-GUID: cMvsPNAG9Iydz7wYU71cOt5ms1lp6uiE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA0MDExMSBTYWx0ZWRfX2aXUl667sD+6
 VbFim0V7hA9ZcNWoGoE3EQEuLuJ8wvweXMgUXBlloJaOrnTcZFXwlKy8cbLtNGgDOiqZ+mb/UPW
 Y65/O8wKxr4JclS5aCpbOhrSvNOoDOHrOgZrOgxefS/7hW50VNhouUuSsScqXApZp0j/Ew423E5
 GLiPmhQRPZtjgD3mr5s7NQRt6+ex6iyj8v9baBEc3M41D3rzGeDytU+w8IDKjqXAOWjQQDSqrp7
 vMx9Hty34iiT0F6Fsc4CW2L7ZH3tQ8rtSW76cGvNekRCzuI7jJiBKbP25W2xTrqEYPvZyo/ZXqe
 aEhkKAy3pKfOZnBz/3DrQBSFgA2oqsoX3zD5Oww3YnrewBoOCYNf6iGrSGjn5dbkS2yXG9t//er
 Bft1SnrySlHgoGtztT1peFobshHZ4BYuJM+QqiM7NRyFUgDIt5UI8453urcTgXwDzxzVrQIH1kl
 lZ72gyGyGt8SPUY6d1g==
X-Proofpoint-GUID: cMvsPNAG9Iydz7wYU71cOt5ms1lp6uiE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-04_06,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 priorityscore=1501 lowpriorityscore=0
 clxscore=1015 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2603040111

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

Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
---
 drivers/ufs/core/ufs-debugfs.c | 211 +++++++++++++++++++++++++++++++++
 1 file changed, 211 insertions(+)

diff --git a/drivers/ufs/core/ufs-debugfs.c b/drivers/ufs/core/ufs-debugfs.c
index e3baed6c70bd..b618d9b11dc9 100644
--- a/drivers/ufs/core/ufs-debugfs.c
+++ b/drivers/ufs/core/ufs-debugfs.c
@@ -209,6 +209,186 @@ static const struct ufs_debugfs_attr ufs_attrs[] = {
 	{ }
 };
 
+static int ufs_tx_eq_params_show(struct seq_file *s, void *data)
+{
+	struct ufs_hba *hba = hba_from_file(s->file);
+	struct ufshcd_tx_eq_settings *settings;
+	struct ufshcd_tx_eq_params *params;
+	const char *file_name = s->file->f_path.dentry->d_name.name;
+	u32 gear = (u32)(uintptr_t)s->file->f_inode->i_private;
+	u32 rate = hba->pwr_info.hs_rate;
+	u32 num_lanes;
+	int lane;
+
+	if (!ufshcd_is_tx_eq_supported(hba))
+		return -EOPNOTSUPP;
+
+	if (gear < UFS_HS_G1 || gear >= UFS_HS_GEAR_MAX) {
+		seq_printf(s, "Invalid gear selected: %u\n", gear);
+		return 0;
+	}
+
+	params = &hba->tx_eq_params[gear - 1];
+	if (!params->is_valid) {
+		seq_printf(s, "TX EQ params are invalid for HS-G%u, Rate-%s\n",
+			   gear, UFS_HS_RATE_STRING(rate));
+		return 0;
+	}
+
+	if (strcmp(file_name, "host_tx_eq_params") == 0) {
+		settings = params->host;
+		num_lanes = params->tx_lanes;
+		seq_printf(s, "Host TX EQ PreShoot Cap: 0x%02x, DeEmphasis Cap: 0x%02x\n",
+			   hba->host_preshoot_cap, hba->host_deemphasis_cap);
+	} else if (strcmp(file_name, "device_tx_eq_params") == 0) {
+		settings = params->device;
+		num_lanes = params->rx_lanes;
+		seq_printf(s, "Device TX EQ PreShoot Cap: 0x%02x, DeEmphasis Cap: 0x%02x\n",
+			   hba->device_preshoot_cap, hba->device_deemphasis_cap);
+	} else {
+		return -ENOENT;
+	}
+
+	seq_printf(s, "TX EQ setting for HS-G%u, Rate-%s:\n", gear,
+		   UFS_HS_RATE_STRING(rate));
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
+	struct ufs_hba *hba = hba_from_file(s->file);
+	struct ufshcd_tx_eq_params *params;
+	unsigned long preshoot_bitmap, deemphasis_bitmap;
+	unsigned int preshoot, deemphasis;
+	const char *file_name = s->file->f_path.dentry->d_name.name;
+	u32 (*record)[TX_HS_NUM_PRESHOOT][TX_HS_NUM_DEEMPHASIS];
+	u32 gear = (u32)(uintptr_t)s->file->f_inode->i_private;
+	u32 rate = hba->pwr_info.hs_rate;
+	u32 num_lanes;
+	int lane;
+	char name[32];
+
+	if (!ufshcd_is_tx_eq_supported(hba))
+		return -EOPNOTSUPP;
+
+	if (gear < UFS_HS_G1 || gear >= UFS_HS_GEAR_MAX) {
+		seq_printf(s, "Invalid gear selected: %u\n", gear);
+		return 0;
+	}
+
+	params = &hba->tx_eq_params[gear - 1];
+	if (!params->is_valid) {
+		seq_printf(s, "TX EQ params are invalid for HS-G%u, Rate-%s\n",
+			   gear, UFS_HS_RATE_STRING(rate));
+		return 0;
+	}
+
+	if (!params->num_eqtr_records) {
+		seq_printf(s, "No TX EQTR records found for HS-G%u, Rate-%s.\n",
+			   gear, UFS_HS_RATE_STRING(rate));
+		return 0;
+	}
+
+	if (strcmp(file_name, "host_tx_eqtr_record") == 0) {
+		record = params->host_eqtr_record;
+		preshoot_bitmap = (hba->host_preshoot_cap << 0x1) | 0x1;
+		deemphasis_bitmap = (hba->host_deemphasis_cap << 0x1) | 0x1;
+		num_lanes = params->tx_lanes;
+		snprintf(name, 32, "%s", "Host");
+	} else if (strcmp(file_name, "device_tx_eqtr_record") == 0) {
+		record = params->device_eqtr_record;
+		preshoot_bitmap = (hba->device_preshoot_cap << 0x1) | 0x1;
+		deemphasis_bitmap = (hba->device_deemphasis_cap << 0x1) | 0x1;
+		num_lanes = params->rx_lanes;
+		snprintf(name, 32, "%s", "Device");
+	} else {
+		return -ENOENT;
+	}
+
+	seq_printf(s, "%s TX EQTR record summary -\n", name);
+	seq_printf(s, "Target Power Mode: HS-G%u, Rate-%s\n", gear,
+		   UFS_HS_RATE_STRING(rate));
+	seq_printf(s, "Number of records: %d\n", params->num_eqtr_records);
+	seq_printf(s, "Last record timestamp: %llu us\n",
+		   ktime_to_us(params->last_eqtr_ts));
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
+					u32 fom = record[lane][preshoot][deemphasis];
+					u32 fom_val = fom & RX_FOM_VALUE_MASK;
+					bool precode_en = !!(fom & RX_FOM_PRECODING_EN_MASK);
+
+					if (fom == 0xFFFFFFFF)
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
@@ -230,6 +410,37 @@ void ufs_debugfs_hba_init(struct ufs_hba *hba)
 			    hba, &ee_usr_mask_fops);
 	debugfs_create_u32("exception_event_rate_limit_ms", 0600, hba->debugfs_root,
 			   &hba->debugfs_ee_rate_limit_ms);
+
+	if (!(hba->caps & UFSHCD_CAP_TX_EQUALIZATION))
+		return;
+
+	for (u32 gear = UFS_HS_G1; gear < UFS_HS_GEAR_MAX; gear++) {
+		struct dentry *txeq_dir;
+		char name[32];
+
+		snprintf(name, 32, "tx_eq_hs_gear%d", gear);
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
-- 
2.34.1

