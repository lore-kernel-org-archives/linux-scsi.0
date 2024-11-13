Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C62E81FBF4D;
	Wed, 13 Nov 2024 10:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731493911; cv=none; b=TriVu1R7tdMlT6hWfQjniBgNktRmTPOj9FZCMvIz5eDLSMUR2HRv5czhomZ/TmS4dmROcK6Wqtf7VA9uTRgSPvJjpaga0qAt2Fc9BBRAZ783CyW8CViR5A71sJ/tqUlAgjRv7TsJQwnm1EwokxouMeR7XDz1d+s/iSEGHDbnbNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731493911; c=relaxed/simple;
	bh=7rJsdgqKqSxqsu6KlaxSAg4QS9bi1EhAxsHHKmFrnPc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tfqoi69wLGyCzKKU4YtHgG9huA/dHIJ20iQ+IxvzTiaTJXMnGjg+ID8CIXPoADeQMXC5QwHKoYfKwsN/Sn0PM4Oszh9PjdUsBass7NHL9tol62pz2v7onUHexQ8zJqkF0/qp6QBXjp03yH4vY2psLFZnbDheMPJT+SQt4msB9ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=coj3cswg; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="coj3cswg"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4ADA1srs026688;
	Wed, 13 Nov 2024 10:31:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=ongJ0KnkbsuLXRH/6euurAAy/ESE9ymgD07
	q0MLGCp8=; b=coj3cswgW93S8vyx/EbJUlsMBFcVLHgJjQdzKVoQPx++37vzmqn
	e/yqzwW8M7O/mo162VFEGGFzkYiEOe/woeqcTZh5pCzymO40padDbK99Ny9Patje
	hfkcXeCbpCF7IaRYyvEw0EIK4QPIaTJOdSc9PZSlCDg2305iEtmRNQ10OAeUa6d/
	GHvpGIvxBRBwV6L6qb0f5+A9XIVHxmuF2MH0whf+b/BAPkfItIevijrrVUvp7yKx
	fgvdVSy1d+0+O+Ci+8dHbCKvKe6t3GXwsoGRo9CuBE7cE8CDavfwvly4JVOp+gF8
	6sE63cBmT92gYeMho1hIdk+MADVcldE+cww==
Received: from aptaippmta01.qualcomm.com (tpe-colo-wan-fw-bordernet.qualcomm.com [103.229.16.4])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 42vgqqsgf7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Nov 2024 10:31:19 +0000 (GMT)
Received: from pps.filterd (APTAIPPMTA01.qualcomm.com [127.0.0.1])
	by APTAIPPMTA01.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTP id 4ADAV3dF028612;
	Wed, 13 Nov 2024 10:31:03 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by APTAIPPMTA01.qualcomm.com (PPS) with ESMTPS id 42t0tkkdeh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Nov 2024 10:31:03 +0000
Received: from APTAIPPMTA01.qualcomm.com (APTAIPPMTA01.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4ADAV3tw028607;
	Wed, 13 Nov 2024 10:31:03 GMT
Received: from cbsp-sh-gv.ap.qualcomm.com (CBSP-SH-gv.ap.qualcomm.com [10.231.249.68])
	by APTAIPPMTA01.qualcomm.com (PPS) with ESMTPS id 4ADAV2r9028606
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Nov 2024 10:31:03 +0000
Received: by cbsp-sh-gv.ap.qualcomm.com (Postfix, from userid 393357)
	id 4B6F340C0C; Wed, 13 Nov 2024 18:31:02 +0800 (CST)
From: Ziqi Chen <quic_ziqichen@quicinc.com>
To: quic_asutoshd@quicinc.com, quic_cang@quicinc.com, bvanassche@acm.org,
        mani@kernel.org, beanhuo@micron.com, avri.altman@wdc.com,
        junwoo80.lee@samsung.com, martin.petersen@oracle.com,
        quic_ziqichen@quicinc.com, quic_nguyenb@quicinc.com,
        quic_nitirawa@quicinc.com, quic_rampraka@quicinc.com
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Hannes Reinecke <hare@suse.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Andrew Halaney <ahalaney@redhat.com>,
        Maramaina Naresh <quic_mnaresh@quicinc.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] scsi: ufs: core: Add ufshcd_send_bsg_uic_cmd() for UFS BSG
Date: Wed, 13 Nov 2024 18:30:46 +0800
Message-Id: <20241113103057.714531-1-quic_ziqichen@quicinc.com>
X-Mailer: git-send-email 2.34.1
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
X-Proofpoint-ORIG-GUID: 3vCQ5G1ZA2rxJJulB42VsGd9dZGKyC0a
X-Proofpoint-GUID: 3vCQ5G1ZA2rxJJulB42VsGd9dZGKyC0a
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1011
 impostorscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0
 priorityscore=1501 phishscore=0 malwarescore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411130092

User layer applications can send UIC GET/SET commands via the BSG
framework, and if the user layer application sends a UIC SET command
to the PA_PWRMODE attribute, a power mode change shall be initiated
in UniPro and two interrupts shall be triggered if the power mode is
successfully changed, i.e., UIC Command Completion interrupt and UIC
Power Mode interrupt.

The current UFS BSG code calls ufshcd_send_uic_cmd() directly, with
which the second interrupt, i.e., UIC Power Mode interrupt, shall be
treated as unhandled interrupt. In addition, after the UIC command is
completed, user layer application has to poll UniPro and/or M-PHY state
machine to confirm the power mode change is finished.

Add a new wrapper function ufshcd_send_bsg_uic_cmd() and call it from
ufs_bsg_request() so that if a UIC SET command is targeting the PA_PWRMODE
attribute it can be redirected to ufshcd_uic_pwr_ctrl().

Signed-off-by: Can Guo <quic_cang@quicinc.com>
Signed-off-by: Ziqi Chen <quic_ziqichen@quicinc.com>
---
 drivers/ufs/core/ufs_bsg.c     |  2 +-
 drivers/ufs/core/ufshcd-priv.h |  1 +
 drivers/ufs/core/ufshcd.c      | 36 ++++++++++++++++++++++++++++++++++
 3 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c
index 433d0480391e..6c09d97ae006 100644
--- a/drivers/ufs/core/ufs_bsg.c
+++ b/drivers/ufs/core/ufs_bsg.c
@@ -170,7 +170,7 @@ static int ufs_bsg_request(struct bsg_job *job)
 		break;
 	case UPIU_TRANSACTION_UIC_CMD:
 		memcpy(&uc, &bsg_request->upiu_req.uc, UIC_CMD_SIZE);
-		ret = ufshcd_send_uic_cmd(hba, &uc);
+		ret = ufshcd_send_bsg_uic_cmd(hba, &uc);
 		if (ret)
 			dev_err(hba->dev, "send uic cmd: error code %d\n", ret);
 
diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index 7aea8fbaeee8..9ffd94ddf8c7 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -84,6 +84,7 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
 			    u8 **buf, bool ascii);
 
 int ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd);
+int ufshcd_send_bsg_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd);
 
 int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
 			     struct utp_upiu_req *req_upiu,
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index e338867bc96c..d168dc36eebe 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4319,6 +4319,42 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 	return ret;
 }
 
+/**
+ * ufshcd_send_bsg_uic_cmd - Send UIC commands requested via BSG layer and retrieve the result
+ * @hba: per adapter instance
+ * @uic_cmd: UIC command
+ *
+ * Return: 0 only if success.
+ */
+int ufshcd_send_bsg_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
+{
+	int ret;
+
+	if (hba->quirks & UFSHCD_QUIRK_BROKEN_UIC_CMD)
+		return 0;
+
+	ufshcd_hold(hba);
+
+	if (uic_cmd->argument1 == UIC_ARG_MIB(PA_PWRMODE) &&
+	    uic_cmd->command == UIC_CMD_DME_SET) {
+		ret = ufshcd_uic_pwr_ctrl(hba, uic_cmd);
+		goto out;
+	}
+
+	mutex_lock(&hba->uic_cmd_mutex);
+	ufshcd_add_delay_before_dme_cmd(hba);
+
+	ret = __ufshcd_send_uic_cmd(hba, uic_cmd, true);
+	if (!ret)
+		ret = ufshcd_wait_for_uic_cmd(hba, uic_cmd);
+
+	mutex_unlock(&hba->uic_cmd_mutex);
+
+out:
+	ufshcd_release(hba);
+	return ret;
+}
+
 /**
  * ufshcd_uic_change_pwr_mode - Perform the UIC power mode chage
  *				using DME_SET primitives.
-- 
2.34.1

