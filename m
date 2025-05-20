Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9C6258CE3;
	Tue, 20 May 2025 01:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747703099; cv=none; b=DNzclRiNPY1kctjTTz/KgZzTKNM1XNTfwkiPF5q/Yn+ZDzENT/gdH0lB4Qj4aZQ90JS73TsK4FsWHXNUINuKaQr8OrLFNCjponItZo7DK0V/wtt/jRAM2h1H+b9O+cefiTi2dcyI7WdFvCb5RngSPclQe12+jR3MLKkpPC5+iuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747703099; c=relaxed/simple;
	bh=qxL0sxC3ikvznPtpYSETaU9ZgOXK6CJlYrOyyeeQLoc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=IjZTZ7AbP9dGJmWwg0QY/N0GQ6LF0udTcMK2q4Vx9L4CVDN833HT8mzPbPeVbchTDV53V3jnSmrA5atP3ME4jhbZhios510qGqxTCPx1/GktVUAs41lbdjHKliI2TnD5+p3hID9FhObCQ1m5o2yR6xWuFmPzzEGUkRxPApC7RHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=gM/h4veb; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="gM/h4veb"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54JJ4C98026316;
	Tue, 20 May 2025 01:04:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=4CPOi1v0yKYGARHRINzWgd
	xyDDR2M7vyUiK6PwzWUfM=; b=gM/h4vebIsbtotI2FEs6PXHalTsDlXc5lJU4kW
	AkW3611VqcEaGi8AotYmu46isqgxFMH+UB/Y0rybJ/69Oxqbr5fmY0fbvfCZs6La
	FNLAiE/Dbpn6WCtdFWCA0atb9KFdfBE7x0CcPL42Y3ctO5E/S8g1K1taLtCR76sJ
	+NGNH4bulRkEFHUP2b0iakCWBWX7y7C/TzsZZ941dAdfOmda1yIyyRH4A2kRCvb0
	q2Wjuk3zYN1jLbrXkhqfrH8WZGC3wFeCM/YJAdlKxrIuAK7KatiXw8byMZj6T9o9
	VBUkbpVzi/F2v4ZDLxQRbNKqEa5Ox3IKZLZ/WQ7dohkc7GNA==
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 46pjnyp2nb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 May 2025 01:04:49 +0000 (GMT)
Received: from nalasex01b.na.qualcomm.com (nalasex01b.na.qualcomm.com [10.47.209.197])
	by NALASPPMTA03.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 54K14mol010465
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 May 2025 01:04:48 GMT
Received: from maow2-gv.qualcomm.com (10.80.80.8) by
 nalasex01b.na.qualcomm.com (10.47.209.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Mon, 19 May 2025 18:04:46 -0700
From: Kassey Li <quic_yingangl@quicinc.com>
To: <rostedt@goodmis.org>, <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>, <mathieu.desnoyers@efficios.com>,
        <linux-kernel@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
CC: <quic_yingangl@quicinc.com>
Subject: [PATCH v3] scsi: trace: change the rtn log in string
Date: Tue, 20 May 2025 09:04:05 +0800
Message-ID: <20250520010405.3844511-1-quic_yingangl@quicinc.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIwMDAwNyBTYWx0ZWRfX9uFak1KM8D6y
 ruOHT7aLSUS2aDwW3ebKB2wvKTAWlj2Pehz1sw8Rp9fELAE4nhPUvEXFh5axfH8aWQOlsUbRKwJ
 XecY+GMk8YaQ4NxV1xS3eHUzV1QxIGGZONLNbXKkBriVfga8qJ7YcXbNgPgop63OjhL9Z8BfwfN
 mFz/zFVTJVfdVaSMHf5L9bdan6fFgCCYy3mTGS48vgbManoIsjezYkIOybWm0yQh1zJ5Mrgra4u
 BtqOcn5LJ+HuBrpSkY7pTthu4ds1Ij594mOcdpXpslnsx/eodwYIrNmOvLzzQz8ozsfs+bLUV6b
 3B0jlGT3B+SdwaMpNgIU2oNTop3RNV48UZ/C8EmlWFx8KncfXYMLBI35pFu2uW2KiLi3IdO6Xae
 /wIcgkfrFCjmCn4E2IDnq4WaTRGbpBUyVQgl5KKhNuQl5PyslJmoQjO0YQvVDCOs1/eMpcmL
X-Authority-Analysis: v=2.4 cv=Z9XsHGRA c=1 sm=1 tr=0 ts=682bd531 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=GEpy-HfZoHoA:10 a=dt9VzEwgFbYA:10 a=COk6AnOGAAAA:8 a=52FsFnDYgQl_Zd7y7DoA:9
 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-GUID: 11wJzFwrYS0IkOW9MRDrx9tLjNF25Z6K
X-Proofpoint-ORIG-GUID: 11wJzFwrYS0IkOW9MRDrx9tLjNF25Z6K
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-20_01,2025-05-16_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501
 adultscore=0 impostorscore=0 bulkscore=0 suspectscore=0 clxscore=1015
 malwarescore=0 spamscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505070000
 definitions=main-2505200007

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

dd-1090    [007] .....    23.485300: scsi_dispatch_cmd_error: host_no=0 channel=0 id=0 lun=4 data_sgl=64 prot_sgl=0 prot_op=SCSI_PROT_NORMAL driver_tag=18 scheduler_tag=9 cmnd=(READ_10 lba=384 txlen=128 protect=0
raw=28 00 00 00 01 80 00 00 80 00) rtn=HOST_BUSY

Signed-off-by: Kassey Li <quic_yingangl@quicinc.com>
---
 include/trace/events/scsi.h | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
index bf6cc98d9122..92a5b6a411b5 100644
--- a/include/trace/events/scsi.h
+++ b/include/trace/events/scsi.h
@@ -200,6 +200,12 @@ TRACE_EVENT(scsi_dispatch_cmd_start,
 		  __print_hex(__get_dynamic_array(cmnd), __entry->cmd_len))
 );
 
+#define show_rtn_name(rtn)    \
+	__print_symbolic(rtn, { SCSI_MLQUEUE_HOST_BUSY, "HOST_BUSY" }, \
+	  { SCSI_MLQUEUE_DEVICE_BUSY, "DEVICE_BUSY" }, \
+	  { SCSI_MLQUEUE_EH_RETRY, "EH_RETRY" }, \
+	  { SCSI_MLQUEUE_TARGET_BUSY, "TARGET_BUSY" })
+
 TRACE_EVENT(scsi_dispatch_cmd_error,
 
 	TP_PROTO(struct scsi_cmnd *cmd, int rtn),
@@ -240,14 +246,15 @@ TRACE_EVENT(scsi_dispatch_cmd_error,
 
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
+		  show_rtn_type(__entry->rtn)
+	  )
 );
 
 DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
-- 
2.34.1

