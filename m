Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1EDD3002D1;
	Sat, 21 Mar 2026 03:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774062689; cv=none; b=TKaof/7jPq1bmLZ+hz2g7Bsvirw2MG1IT0jjSWm1OP7dllJYZS4K5fzAqFFzTCNUxsnW70RSMJe1tNZDb/hXLWosdDnMUW4CiFmuqf1HlL71qvfN27kMSN7Al5wrx8R2vUnLH0/lvTvkZ1wdtX6Dr0coTyuqitHFfaO9z5hKwuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774062689; c=relaxed/simple;
	bh=p9mbe/Yxg/80h0p0WoNyW2hpESxoUGIFrApKZX1vX1E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pS04UG5g86YRoTcW7nY8ucHULZ77d8IxFQ3DKC1xWXLcRiGoUVbVlfiY9LY+N3rTq2o0snbjC8/JkH9MSf55vbVHY8k+Q+KZ4QsD3nabUOoeNyqciySIh6C66kQftvFnaT+f8QQncQWWBx4DswRX+sIKMf68YNuorFldiPezOT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=SjKjKuFP; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="SjKjKuFP"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62KN6kCR3134251;
	Sat, 21 Mar 2026 03:11:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=2qTQlGgCJdp
	Q4Ghnt1gDIzgO4pr4nCh62QMLRl5x+/I=; b=SjKjKuFP8GPT4P8aPydGKrt9YGd
	4gdglge0QQ4iI3kZFbF5NislYQvuzFZG80S49ENon8tPm+ZE3CPO/T3QBGJMgUOH
	wUGOmlbbuv7D9c9fC+v8xjV9JvHHFo1ieOzpB/dz+8NZ/Wb9uNk+0uweGAOe1VSD
	rB5aGHSiA4sZ/M/nd9W7xfPnaKY/UyjiyqeG6C1upVQahVmuFO5GELzTE9umtZ67
	thaNT5ABvdBVzNa3SqGmJ92xPJUBcYBfgtvUnbx4iaHztFvSte4fYelLMXgYLiy7
	bFFHpdJ0jNio+KePca11D3blWCu37FAzkWcJMNJP19HECxUVxbBwYrpY7dQ==
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d0sm6kn0u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 21 Mar 2026 03:11:15 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA05.qualcomm.com [127.0.0.1])
	by NALASPPMTA05.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTP id 62L3ANL1030418;
	Sat, 21 Mar 2026 03:11:14 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA05.qualcomm.com (PPS) with ESMTPS id 4d0spy9cx3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 21 Mar 2026 03:11:14 +0000
Received: from NALASPPMTA05.qualcomm.com (NALASPPMTA05.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 62L3BEQn031424;
	Sat, 21 Mar 2026 03:11:14 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA05.qualcomm.com (PPS) with ESMTPS id 62L3BETW031420
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 21 Mar 2026 03:11:14 +0000
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id 0841A5A8; Fri, 20 Mar 2026 20:11:14 -0700 (PDT)
From: Can Guo <can.guo@oss.qualcomm.com>
To: avri.altman@wdc.com, bvanassche@acm.org, beanhuo@micron.com,
        peter.wang@mediatek.com, martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v4 06/12] scsi: ufs: core: Add helpers to pause and resume command processing
Date: Fri, 20 Mar 2026 20:10:15 -0700
Message-Id: <20260321031021.1722459-7-can.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260321031021.1722459-1-can.guo@oss.qualcomm.com>
References: <20260321031021.1722459-1-can.guo@oss.qualcomm.com>
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
X-Proofpoint-GUID: vyedx4d9s_6NYzbNijmrrDvFJghiluAR
X-Authority-Analysis: v=2.4 cv=Rv/I7SmK c=1 sm=1 tr=0 ts=69be0c53 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=yOCtJkima9RkubShWh1s:22 a=EUspDBNiAAAA:8 a=gPywXGqH3ohmGHrydA0A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIxMDAyNCBTYWx0ZWRfXyR2qUzVAXkfG
 R169gk+XYxdfhrIFTFcjsc3IryeJQvAqlYi9u662SVgd8I7krUsLbUztSaTnZX0adKcAxHMXzag
 tcFOl6z1LkwOy79D9mElf28uBEHmPzr5Tlw5Ubcm0yYfQLp7vG90k1X+C/ofQ6bjIDYRE3VikFb
 U1lqJKHdJjaGVF98xwdgg9rM1KdWDNy8gAjP2mE3bIgA7TGFzBAU0vmJxLnn3St4Qvq2uxYwfdZ
 UFg+GXlO75RMRX0ywkulbK38xE9lvHQur558D/t5KyDvL7aSRPhLlsfsTs1VsJx5cstAjmmhlpO
 0zMpRw/BzO0wbcQ2ba2LeZ9oCyHiczcGb0UM6UrRUkeyNYJXkWXkOxf94vU8E4oZ8ATNhwvKiSs
 RldXF7kMcwN+4uJ+XbNIO0+ZXc/zgl17oEEPBNTyvjQhFKjyjWIG3oPz1bUTwTp7rb3bXsMDTfH
 Cr85TJn3nEZFFocgW6w==
X-Proofpoint-ORIG-GUID: vyedx4d9s_6NYzbNijmrrDvFJghiluAR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-21_01,2026-03-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 spamscore=0 phishscore=0 bulkscore=0
 impostorscore=0 adultscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603210024

In preparation for supporting TX Equalization refreshing, introduce
helper functions to safely pause and resume command processing.

ufshcd_pause_command_processing() ensures the host is in a quiescent
state by stopping the block layer tagset, acquiring the necessary
locks (scan_mutex and clk_scaling_lock), and waiting for any
in-flight commands to complete within a specified timeout.

ufshcd_resume_command_processing() restores the host to its previous
operational state by reversing these steps in the correct order.

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

