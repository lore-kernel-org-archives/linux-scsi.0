Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA263E2753;
	Wed, 25 Mar 2026 15:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774452233; cv=none; b=DpWLH8ozeME1qMsIsj1SB6f6oUyIDEjy6/NIiigfrkdtsoqGMZ6yBecRNTfV5EEDX8Byl9YIOGo3UmacmTk1zwZr37a3nYiZg0zx9aWFwM6/d4qcr0WZy/Iby1AwzCT7/285CCuuKZDEj6twZeBIx8cZB+E4V6ZsOin+36XOEwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774452233; c=relaxed/simple;
	bh=Tbdo9up4bbHTRmTF56sSAvu+2S9CyN/s1jrknv8u2Mg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=E0rgpSf1w7KFj3q+jJ8ZpZ2yRsrdIKlN55grrEK0KN7O+rx4O436R5jByPU+QLRHIL5m5vr7xAdfGojmo9CZl14NGsp4Mb9s03SytA+awnYyJjPgAXzjVqs8KaJLrqQbyAtYuN10vjnFgFA3GV+jbYUSojnjRIxXPGB+cRky7KE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Wy9Idwdo; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Wy9Idwdo"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62PFHA1P2737654;
	Wed, 25 Mar 2026 15:23:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=huRM/uNCDyP
	fAyCYhB4qT6tKsas+J//X6lgJc6wQFa8=; b=Wy9IdwdoyRxnCUQQFL6ony3fOfK
	SdK/Qg2I2G16DUaF/GO8fTfAEpN8b1d7C8xvLjP9+CU7V2+lvi34R081iNaNoQiF
	KHghY2vqXQg4Qp1exD/4/8v1chHw8Sh/gzhs3PP7eBGMW4ftPNWtFBkGJtlJwzQf
	olkDTbd9ezAj/kt0gzJLtVmeeg30g6bmNYNhSc+gaavCkwayz/4hFUnRLSPXfCQi
	Vj5rNwdBm0lVMz5vVoc7Dv8sct3ANtgel3H4qXXORSEF1ZG73N/65ohiQ1keB9Oo
	fhC0mK7t4kmQpOCDbA67ZE/L7ZrWZkrYxvvMK755wvg1Foz01XE2Y1y4/kQ==
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d4859ae3a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Mar 2026 15:23:37 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA05.qualcomm.com [127.0.0.1])
	by NALASPPMTA05.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTP id 62PFLpOS005896;
	Wed, 25 Mar 2026 15:23:36 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA05.qualcomm.com (PPS) with ESMTPS id 4d473nfj4g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Mar 2026 15:23:36 +0000
Received: from NALASPPMTA05.qualcomm.com (NALASPPMTA05.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 62PFGY0G029006;
	Wed, 25 Mar 2026 15:23:35 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA05.qualcomm.com (PPS) with ESMTPS id 62PFNZ7p008743
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Mar 2026 15:23:35 +0000
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id 81F395AE; Wed, 25 Mar 2026 08:23:35 -0700 (PDT)
From: Can Guo <can.guo@oss.qualcomm.com>
To: avri.altman@wdc.com, bvanassche@acm.org, beanhuo@micron.com,
        peter.wang@mediatek.com, martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v5 06/12] scsi: ufs: core: Add helpers to pause and resume command processing
Date: Wed, 25 Mar 2026 08:21:48 -0700
Message-Id: <20260325152154.1604082-7-can.guo@oss.qualcomm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI1MDExMCBTYWx0ZWRfX4uAqpOjPrRQu
 6mOXbxDddU5oHTC8MAj5L8WjfO3NUasqGnLQbDm13QKW2UkLtB8B2QE3y+mAb+N32FsA8ons4Ly
 EXYs8jGMxYanxKeqr3yx7Chz6F5KfyZULI6Y0B5w94gzYK3tx37p08sTyH1HlZoPm7FRWqnQvwV
 /on1cE+D2VUextJUyUMQGv7FYMRn5y8r4+pl0BZhiS7akXzstrS4q2ViDJkg2zUjNNyWtD5Kxxc
 1d9WYdbmEmeo2kujAJt5JObjhuTFPMWsxkgQCb6rhAjCahgm/wGZtbpJEaPm9nwHm/+6CmQWpqZ
 IZGDA/txMmEPIJkJcJNF6iFUBQG7EXs7VqpKIDY8fENNFFBUxkDuqVG1Eva2rKlCAjxA5dPrQ99
 W1zRWcNnyfAA+esVpNXmMTQkDYLsDDpNdA8RsB1oROPEob4qxsqtIixI9nrltoW7DDvsEdaoURq
 CFnlryWULgw/iFT56nQ==
X-Authority-Analysis: v=2.4 cv=VODQXtPX c=1 sm=1 tr=0 ts=69c3fdf9 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=_glEPmIy2e8OvE2BGh3C:22 a=PY6Zn8H8AAAA:8 a=N54-gffFAAAA:8 a=EUspDBNiAAAA:8
 a=ESNYe2aa-GzWVSZYbXUA:9 a=ySS05r0LPNlNiX1MMvNp:22
X-Proofpoint-GUID: kTWjkEZ16GuViFu5w0vl2r2pL5fB2ZSW
X-Proofpoint-ORIG-GUID: kTWjkEZ16GuViFu5w0vl2r2pL5fB2ZSW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-25_04,2026-03-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015 adultscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603250110

In preparation for supporting TX Equalization refreshing, introduce
helper functions to safely pause and resume command processing.

ufshcd_pause_command_processing() ensures the host is in a quiescent
state by stopping the block layer tagset, acquiring the necessary
locks (scan_mutex and clk_scaling_lock), and waiting for any
in-flight commands to complete within a specified timeout.

ufshcd_resume_command_processing() restores the host to its previous
operational state by reversing these steps in the correct order.

Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
---
 drivers/ufs/core/ufshcd-priv.h |  2 ++
 drivers/ufs/core/ufshcd.c      | 42 ++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index 13a957dc11d0..7f18dbcd9343 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -78,6 +78,8 @@ int ufshcd_mcq_sq_cleanup(struct ufs_hba *hba, int task_tag);
 int ufshcd_mcq_abort(struct scsi_cmnd *cmd);
 int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag);
 void ufshcd_release_scsi_cmd(struct ufs_hba *hba, struct scsi_cmnd *cmd);
+int ufshcd_pause_command_processing(struct ufs_hba *hba, u64 timeout_us);
+void ufshcd_resume_command_processing(struct ufs_hba *hba);
 
 /**
  * enum ufs_descr_fmt - UFS string descriptor format
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index d9da4f3c1f14..0ee8bc156af1 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1362,6 +1362,48 @@ static int ufshcd_wait_for_pending_cmds(struct ufs_hba *hba,
 	return ret;
 }
 
+/**
+ * ufshcd_pause_command_processing - Pause command processing
+ * @hba: per-adapter instance
+ * @timeout_us: timeout in microseconds to wait for pending commands to finish
+ *
+ * This function stops new command submissions and waits for existing commands
+ * to complete.
+ *
+ * Return: 0 on success, %-EBUSY if commands did not finish within @timeout_us.
+ * On failure, all acquired locks are released and the tagset is unquiesced.
+ */
+int ufshcd_pause_command_processing(struct ufs_hba *hba, u64 timeout_us)
+{
+	int ret = 0;
+
+	mutex_lock(&hba->host->scan_mutex);
+	blk_mq_quiesce_tagset(&hba->host->tag_set);
+	down_write(&hba->clk_scaling_lock);
+
+	if (ufshcd_wait_for_pending_cmds(hba, timeout_us)) {
+		ret = -EBUSY;
+		up_write(&hba->clk_scaling_lock);
+		blk_mq_unquiesce_tagset(&hba->host->tag_set);
+		mutex_unlock(&hba->host->scan_mutex);
+	}
+
+	return ret;
+}
+
+/**
+ * ufshcd_resume_command_processing - Resume command processing
+ * @hba: per-adapter instance
+ *
+ * This function resumes command submissions.
+ */
+void ufshcd_resume_command_processing(struct ufs_hba *hba)
+{
+	up_write(&hba->clk_scaling_lock);
+	blk_mq_unquiesce_tagset(&hba->host->tag_set);
+	mutex_unlock(&hba->host->scan_mutex);
+}
+
 /**
  * ufshcd_scale_gear - scale up/down UFS gear
  * @hba: per adapter instance
-- 
2.34.1

