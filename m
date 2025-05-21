Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5659E184E;
	Wed, 21 May 2025 01:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747790253; cv=none; b=O8c7BmGbZtNw4+bfG/qMK8+M7e2CwyS3z5nGl7AQUQWQQFJxO0tpvy6D92F8137uAY+HFY4Jholn+KJ5YdB2X2AxPR8DF6t5iXWoxX1X7+gJA785oc914CDmimaYbahx36Ss6OLq6Ns64UP2AcWqSOAoWoDEOi4ITri7F2jsy2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747790253; c=relaxed/simple;
	bh=/DGBChWqkoyrehLrPFhludhKS9BW6V3CZw214BTIWyo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=aGUKAewMnfyg9y2ekgGr5v0OTA7wCR4x2JjjyR61/T+KQ+PyUsBzuQGPSPbxNSWuVS2IbK/xjcpGBhgQERXGT98ECGEhES2v6ks0trzHLjvaE30AZmCC0avySe24rz6jMLlVqeheS3j+bbkfgDktNKSu9FghOXf1roRIQv/mpo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=I0/44lyS; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="I0/44lyS"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54KGeOGP020632;
	Wed, 21 May 2025 01:17:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=22MIIhZcOt+ZHm3CEkVEmk
	yNNX4uM2tIUsVvcMh9bQQ=; b=I0/44lySGeQNB8LcKwox+yBsSmmQy8vPV+yaAB
	QLnk4G/5EBubXIu7qiNqTWxWct+ukarTpwuH4XNmCkiVEqMOElPsNQOZOgTO7/BQ
	GTWDXUKnFOI39WESS4+1LAav5aa1+9TBoNwe6wSNZ3kaRvyZCRhT9K70JdgtqBBx
	wmUVTJJjRG2d0Ize58JsCiKGehqPgOy+i3q3NNh7/5jmzI2lTLcBC8oZelMvmI0v
	RXhxXqDZZpdJW18YXNYI/jkFGeETqv3obYOTWUtyndc1xXFJf6lyYHN/zLxDhLji
	nRSuwQbU9+YAE/r0ugaDJDJP5LkNBxn5z0ykZJ0SjNKRDiwA==
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 46rwf9s215-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 May 2025 01:17:24 +0000 (GMT)
Received: from nalasex01b.na.qualcomm.com (nalasex01b.na.qualcomm.com [10.47.209.197])
	by NALASPPMTA01.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 54L1HNM3012083
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 May 2025 01:17:23 GMT
Received: from hlos-sh01-lnx.qualcomm.com (10.80.80.8) by
 nalasex01b.na.qualcomm.com (10.47.209.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Tue, 20 May 2025 18:17:21 -0700
From: Kassey Li <quic_yingangl@quicinc.com>
To: <rostedt@goodmis.org>, <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>, <mathieu.desnoyers@efficios.com>,
        <linux-kernel@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
CC: <quic_yingangl@quicinc.com>
Subject: [PATCH v5] scsi: trace: show rtn in string for scsi_dispatch_cmd_error
Date: Wed, 21 May 2025 09:17:11 +0800
Message-ID: <20250521011711.1983625-1-quic_yingangl@quicinc.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01b.na.qualcomm.com (10.47.209.197)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Authority-Analysis: v=2.4 cv=V9990fni c=1 sm=1 tr=0 ts=682d29a4 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=GEpy-HfZoHoA:10 a=dt9VzEwgFbYA:10 a=COk6AnOGAAAA:8 a=HDVQ9ilCK7Bs7oLMxKUA:9
 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-ORIG-GUID: g-H7kPjUAHiROBR8CfZoPl2kAU2mehUV
X-Proofpoint-GUID: g-H7kPjUAHiROBR8CfZoPl2kAU2mehUV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIxMDAxMCBTYWx0ZWRfX53i3AVIcRQZf
 HeXpEIiU62iNdR+8RPNpPu5dYaTMCnPMvZa1TQfiEzoezPNdA40+MJWWRwY1FBvkSvwsiLgUVjV
 ff3HlNymYtoBnUOuw/NKy/0T+KFxsoKRyEJFXck+e7K4wFM95BYreH4UbG07R0W3GPa1Ogvua3a
 F8oQVEqthxdZj1wLJr9WwlKX7P3hqB3GCpH/fsYCD+m+XcogsLJTtSBUnY0Xg6ptQ5LxoL9X008
 zpTcpOURUzNZ8n2dJoQ+tc+/xRQgnW86E1d3qOUDl7/OFRbfcKzcZO7Hb5coIiM1gSqk+pxP6WR
 cIu5WXlCgoStcZsxu2RZHAazkj18pAyv6onAXZ5hXzZkARws7ZVaM4I3H2z00kHB75mncAV98ZI
 WQoxL/yMr6NDQRREVNsaB+xsc84kIiJF+axCLaKpH1bKzH42LhDdix8Rp4FfyIIHqPtsWbgl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-20_10,2025-05-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 mlxlogscore=999 bulkscore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 mlxscore=0 spamscore=0 phishscore=0 suspectscore=0
 adultscore=0 malwarescore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505210010

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

Changes in v5:
- last backslash aligns.

Signed-off-by: Kassey Li <quic_yingangl@quicinc.com>
---
 include/trace/events/scsi.h | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
index 8e2d9b1b0e77..1decb51fbf6e 100644
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
+		scsi_rtn_name(SCSI_MLQUEUE_EH_RETRY),		\
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

