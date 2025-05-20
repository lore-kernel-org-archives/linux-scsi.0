Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B3B2AE6F;
	Tue, 20 May 2025 01:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747706381; cv=none; b=uyBDM3Yqd7o16pGhYXAc1khwvQjxR9HgbdONuWeHbGyCpfZ6WP3ClAuQp2edhc/D+LXSr1H31Qs6jUGtIQKcKtai0ReIymOQAKEjaf4UDrFRE/7Qzv9IxhCr00rmqnai5pm9rMMl+60S0Xl2rhVg9Q1b+WYap0ur4Hbq12koujc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747706381; c=relaxed/simple;
	bh=BAJr/4RBGvizUqVcHRgIQ46G7iWUjjNJ3dQj0dL2WsE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=DenrmCgSzKeG7hpVG7nHyR1O3Fmd8kiFd6IRT79zN2Rhm+So66JfDbe8fxKvSjCrDcE7vzE782SRJggqzeSragRppefVMDhNyLK2xRMo0rdNKzKJO9OLn26GKf6+veMIN8EfHlM50TYAjeDuXHQd2keihIpzKcMiFzdijjodptM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=fMMTCmdT; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="fMMTCmdT"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54JKZHJE005266;
	Tue, 20 May 2025 01:59:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=dN/K11DGGvzR0B2IyPE0+d
	FpKkx5skoBPZuEN1t7XXQ=; b=fMMTCmdThl4huW1+b/JwzLN186cVIVzFyHMb62
	jm20bhfFeOLkGr5RVMvvCE+Ou72TVNuYiiQpJHgVHN0yS3Err3Zs7cO/oa6O8djU
	xSZdMIM/fSVpZY2aohzwJaJccQapLpwDmOUq1ACRcYxXs7hlONleKeT/b0tNCyYN
	17pmqN8V5HpaeyTXrPPMdREIJgycP2uxeLUVnJnSRNaX6qPlPlxj9qP/V7ffPSDB
	hWlyOLvicr191KhtAte3GoF2sO0/f9dguWuhyLWm6sFrG+C4+5dP/+hiscZeOdtv
	VZFd7Fh/HroGCKsj4deFmUjSCi6Hvns4FFeiJ7uLLbqqDVlg==
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 46pjm4x6y2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 May 2025 01:59:31 +0000 (GMT)
Received: from nalasex01b.na.qualcomm.com (nalasex01b.na.qualcomm.com [10.47.209.197])
	by NALASPPMTA01.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 54K1xUUr021364
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 May 2025 01:59:30 GMT
Received: from hlos-sh01-lnx.qualcomm.com (10.80.80.8) by
 nalasex01b.na.qualcomm.com (10.47.209.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Mon, 19 May 2025 18:59:28 -0700
From: Kassey Li <quic_yingangl@quicinc.com>
To: <rostedt@goodmis.org>, <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>, <mathieu.desnoyers@efficios.com>,
        <linux-kernel@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
CC: <quic_yingangl@quicinc.com>
Subject: [PATCH v4] scsi: trace: show rtn in string for scsi_dispatch_cmd_error
Date: Tue, 20 May 2025 09:59:15 +0800
Message-ID: <20250520015915.1464093-1-quic_yingangl@quicinc.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01b.na.qualcomm.com (10.47.209.197)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Authority-Analysis: v=2.4 cv=dIimmPZb c=1 sm=1 tr=0 ts=682be203 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=GEpy-HfZoHoA:10 a=dt9VzEwgFbYA:10 a=COk6AnOGAAAA:8 a=HDVQ9ilCK7Bs7oLMxKUA:9
 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-ORIG-GUID: sHiruoNErnn5Elg5dLb5Mqxc0TUUqvJu
X-Proofpoint-GUID: sHiruoNErnn5Elg5dLb5Mqxc0TUUqvJu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIwMDAxNSBTYWx0ZWRfXyF/lLc0frLUK
 E7MnaWP5FVpTG4wtPqC4RaAcAhB8rGQAnX05DMtjKYLME3KYX3XNiBxkHoc3KMCrY9APmKcg0BD
 tnAmZCx8zb0QHEQIlV8CYPE5565vdzXluvKNzlWeYF7d6dbqOv4FwYfW+dUIGFKEH68486qKHkr
 DhF/1AJdmOHAjmUng4eapFQ5UbQtLl1znFjdraEG/ZTbchPFur1bKJeRrFi/28BtQPF9bWPSZeN
 VmWQlIt7JI60laf5T5LrrXXnxObD6Vx5bdIEjJlYLb6ptAPV3ee0Hs1pWQTk+qKF/velHrbFl1V
 IwDrC+G69CJW+rrdpAiDCbfdliTWjknC3c1/zU2o5U8ZGMfPYC9vEDA1h0NUoewc67Tv7ZD/b1h
 LhSq+CDADRKvUX/KN6nhfFZlhSpY03nPWEK39Mbsie0wRriMIckSkmkgHCrPh1kXK/JKP9f9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-20_01,2025-05-16_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 mlxscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 impostorscore=0 clxscore=1015 phishscore=0 adultscore=0 priorityscore=1501
 mlxlogscore=999 spamscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505070000
 definitions=main-2505200015

By default it showed rtn in decimal:

kworker/3:1H-183 [003] ....  51.035474: scsi_dispatch_cmd_error: host_no=0 channel=0 id=0 lun=4 data_sgl=1  prot_sgl=0 prot_op=SCSI_PROT
_NORMAL cmnd=(READ_10 lba=3907214  txlen=1 protect=0 raw=28 00 00 3b 9e 8e 00 00 01 00) rtn=4181

In source code we define these possible values as hexadecimal:

include/scsi/scsi.h

SCSI_MLQUEUE_HOST_BUSY   0x1055
SCSI_MLQUEUE_DEVICE_BUSY 0x1056
SCSI_MLQUEUE_EH_RETRY    0x1057
SCSI_MLQUEUE_TARGET_BUSY 0x1058

This change shows the rtn in strings:

dd-1059    [007] .....    31.689529: scsi_dispatch_cmd_error: host_no=0 channel=0 id=0 lun=4 data_sgl=65 prot_sgl=0 prot_op=SCSI_PROT_NORMAL driver_tag=23 scheduler_tag=117 cmnd=(READ_10 lba=0 txlen=128 protect=0 raw=28 00 00 00 00 00 00 00 80 00) rtn=SCSI_MLQUEUE_DEVICE_BUSY

Signed-off-by: Kassey Li <quic_yingangl@quicinc.com>
---
 include/trace/events/scsi.h | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
index 8e2d9b1b0e77..38743635f2c1 100644
--- a/include/trace/events/scsi.h
+++ b/include/trace/events/scsi.h
@@ -199,6 +199,14 @@ TRACE_EVENT(scsi_dispatch_cmd_start,
 		  __print_hex(__get_dynamic_array(cmnd), __entry->cmd_len))
 );
 
+#define scsi_rtn_name(result)	{ result, #result }
+#define show_rtn_name(val)					\
+	__print_symbolic(val,					\
+		scsi_rtn_name(SCSI_MLQUEUE_HOST_BUSY),		\
+		scsi_rtn_name(SCSI_MLQUEUE_DEVICE_BUSY),	\
+		scsi_rtn_name(SCSI_MLQUEUE_EH_RETRY),	\
+		scsi_rtn_name(SCSI_MLQUEUE_TARGET_BUSY))
+
 TRACE_EVENT(scsi_dispatch_cmd_error,
 
 	TP_PROTO(struct scsi_cmnd *cmd, int rtn),
@@ -239,14 +247,15 @@ TRACE_EVENT(scsi_dispatch_cmd_error,
 
 	TP_printk("host_no=%u channel=%u id=%u lun=%u data_sgl=%u prot_sgl=%u" \
 		  " prot_op=%s driver_tag=%d scheduler_tag=%d cmnd=(%s %s raw=%s)" \
-		  " rtn=%d",
+		  " rtn=%s",
 		  __entry->host_no, __entry->channel, __entry->id,
 		  __entry->lun, __entry->data_sglen, __entry->prot_sglen,
 		  show_prot_op_name(__entry->prot_op), __entry->driver_tag,
 		  __entry->scheduler_tag, show_opcode_name(__entry->opcode),
 		  __parse_cdb(__get_dynamic_array(cmnd), __entry->cmd_len),
 		  __print_hex(__get_dynamic_array(cmnd), __entry->cmd_len),
-		  __entry->rtn)
+		  show_rtn_name(__entry->rtn)
+	  )
 );
 
 DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
-- 
2.34.1

