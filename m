Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A81482FF;
	Wed, 14 May 2025 07:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747208722; cv=none; b=jlShfJKAeWJDZFmlNmSpr5T1kWBWk2tTP7plAOTE8GaMLoio9iQNYzBaVNK8rUdb20DDc8FPu5+Tl3ZbjXLp63GWI0lKQkEGdj2nzFIwfLGxtjSIcx4Fkl4WFGyZqg/AMZjZ+d3MnKMT+If1GBLVXEEisQDFdMss1e/AFuIDd/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747208722; c=relaxed/simple;
	bh=+BKoEaHej4c6uoezAbL/2f6kRIpP7JX3LII8sswKkmg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=gyOpirTN9Kynh8Dn5K6REzn3P1wSEo/G/E9MHsP/jiB5g2GGAnN0fNV0D9sbJ2wRRFDeC4bzyyxu6gdy9giFgyLG/vPnLg4uB8Mpx/rJDFjwju1qFavC1IIMf3ToZQJjv02iEtiK8m7f8sC82kDsSk7nBphoyL3bQCKW8by2gQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=IwEB5H6/; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="IwEB5H6/"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54E3AKJM012811;
	Wed, 14 May 2025 07:45:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=YfwFrlu5srY1lu+uHZEV7M
	RBETyqo3wY+V0Rp/d/8ec=; b=IwEB5H6/Fg2KwxkD6tbSwqcY7HUJ+dNItwJi2t
	o4foNEyruaaBio5kuCTiXDSdrwuKRi+uiYQDZtB6UvMhZ7RnXAZUUvxpnXTwyPzv
	16cmU0Az0lvHqZrRMS2clvvwqecRxRg4AgSxfAJ7s+cXk/UeCRfOO4XXdH2ydLTe
	x833dtOzC8sK22xSeNaEOWfvNwPZvr2aoJd8z6Gp+5YorXcX/Haevxx2Uazn+iMo
	YP54nL7Y3KaNurbMBB6m4IQdfnjQEIWcDIfncBJkblOJdZ2C6d4mn62Mky0VVwjr
	O5vuQRYIAoJQ5QbAfQ+tpFGTmDKK+H8ZTIR88D3zvIzwtLPg==
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 46mbcp9tp3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 May 2025 07:45:14 +0000 (GMT)
Received: from nalasex01b.na.qualcomm.com (nalasex01b.na.qualcomm.com [10.47.209.197])
	by NALASPPMTA04.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 54E7jDNU017632
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 May 2025 07:45:13 GMT
Received: from maow2-gv.qualcomm.com (10.80.80.8) by
 nalasex01b.na.qualcomm.com (10.47.209.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Wed, 14 May 2025 00:45:10 -0700
From: Kassey Li <quic_yingangl@quicinc.com>
To: <rostedt@goodmis.org>, <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>, <mathieu.desnoyers@efficios.com>,
        <linux-kernel@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
CC: <quic_yingangl@quicinc.com>
Subject: [PATCH v2] scsi: trace: change the rtn log in string
Date: Wed, 14 May 2025 15:44:56 +0800
Message-ID: <20250514074456.450006-1-quic_yingangl@quicinc.com>
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
X-Proofpoint-GUID: OcqBC6ia3V5twApc2YNHKPFqiit3mJig
X-Proofpoint-ORIG-GUID: OcqBC6ia3V5twApc2YNHKPFqiit3mJig
X-Authority-Analysis: v=2.4 cv=cO7gskeN c=1 sm=1 tr=0 ts=68244a0a cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=GEpy-HfZoHoA:10 a=dt9VzEwgFbYA:10 a=COk6AnOGAAAA:8 a=V0V25F8n1wzCnFKlgSkA:9
 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE0MDA2NiBTYWx0ZWRfX4o9AImrEs86h
 ydZ2/ApO3UShDsivR5QayJCs4fq5dMskVyVrP4TB9mxIkHVST+TQH10oV/bPb9uyVraib9VFvZU
 rm2d5Nbj/YozOcVOibm3cgvtcbv087ldnNkF4LBBNm+Np7L8AGb0CQpATejWTgQdqi8HVkccjA6
 JP/Goz/Z0ojUFF+EOhc4l7+rMTMDjoSOJNTEefIJg2uIdrnNeVjGblX1z4H1MgXCVJDAWmCoiMl
 7ud1O+QHC6RYV0yPo6QFZbaR9llrmsZ6xF+4hkbE2R0oHfE5CC7Nn1+ybB7C9lyHCsHc8wsj57w
 lk6epMnTvGvmHVblu3//8mxbyV5ea7YrBTL3fhHBKzmNTYqlQAYgbtZcerRPgQcIcHQByktYfM3
 2+E9Lny6UF0pC31kNt4kP/HavfSgv0pelaIxxT1GP/JLshUq54RhbOgQsiUAV/cjX9e/f97/
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-14_02,2025-05-14_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 mlxlogscore=999 spamscore=0 suspectscore=0 phishscore=0 lowpriorityscore=0
 adultscore=0 bulkscore=0 malwarescore=0 impostorscore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505070000
 definitions=main-2505140066

In default it showed rtn in decimal.

kworker/3:1H-183 [003] ....  51.035474: scsi_dispatch_cmd_error: host_no=0 channel=0 id=0 lun=4 data_sgl=1  prot_sgl=0 prot_op=SCSI_PROT_NORMAL cmnd=(READ_10 lba=3907214  txlen=1 protect=0 raw=28 00 00 3b 9e 8e 00 00 01 00) rtn=4181

In source code we define these possible value as hexadecimal:

include/scsi/scsi.h

SCSI_MLQUEUE_HOST_BUSY   0x1055
SCSI_MLQUEUE_DEVICE_BUSY 0x1056
SCSI_MLQUEUE_EH_RETRY    0x1057
SCSI_MLQUEUE_TARGET_BUSY 0x1058

This change shows the string type.

Signed-off-by: Kassey Li <quic_yingangl@quicinc.com>
---
 include/trace/events/scsi.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
index bf6cc98d9122..56987f98ba4a 100644
--- a/include/trace/events/scsi.h
+++ b/include/trace/events/scsi.h
@@ -240,14 +240,18 @@ TRACE_EVENT(scsi_dispatch_cmd_error,
 
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
+		  __print_symbolic(rtn, { SCSI_MLQUEUE_HOST_BUSY, "HOST_BUSY" },
+			  { SCSI_MLQUEUE_DEVICE_BUSY, "DEVICE_BUSY" },
+			  { SCSI_MLQUEUE_EH_RETRY, "EH_RETRY" },
+			  { SCSI_MLQUEUE_TARGET_BUSY, "TARGET_BUSY" })
+		  )
 );
 
 DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
-- 
2.34.1

