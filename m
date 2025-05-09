Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC162686B1;
	Fri,  9 May 2025 05:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746769173; cv=none; b=Yvspfzsg2IjB2HA4hwDD1WEu67LvCbwEo3VNwsjLundxiBm3wGnbYhNZuxUrXtRGPrk8jCdNbr8s2IRFm15aDHd+XSzPTB88wvkm6pShNhUbc71d7Umou4TlVKfJD7wJsNlkK/L/2MwVAuAKnAlZFwVcxs8rw+NYnfIlASVYE7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746769173; c=relaxed/simple;
	bh=FfcO1bmJ9TwVyGmwWvdOKtV4qaOdRW/kxoyTI2FoTcM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=sGykwkdMlqmVJ0tT0k/SaauppVyWTR1ZSRW3UlvRfZNGDXt4rcUYXsqZg4HxcOCFF0GvBA8c5lnwL4YYhDzzXnMCXpZj9sgqETJbF/VUOJPEBPoloHZVwxRCX+glEibYsdjhPOtPKfTqp3O6KZdA09B3xqtAzSbs6nejInxDqhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=ENMBgqxV; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="ENMBgqxV"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5493Hg5p009206;
	Fri, 9 May 2025 05:39:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=rE1RR5SpAq6CGFJwO2E2zk
	Hp8UtvOPLpNZiWJ8e/wvE=; b=ENMBgqxV6p9l4mexn3odt9U0Y+dNIc67nQRgTM
	Vhdqi3s1I4Lwrkn1CpP+fzeaUnmIh8UGDNRlG9/IJFuZ3Olxk6CIQcvx27lSBSpt
	w47H/XKAT+sD1u2ir3YzAN06CgEofYEa9Nynpa/E+SQo3kYw7X4jVceooZrux14d
	OjX8px/CAuSfAo9tGG8vu4fc108XwW8g9PMyhjzpGAgFdc7OPK8uwt8Cgl0f9Oo7
	3fQXddC0UUbiWLkoWOf70xXvXqhpXJh+/BZXyV3rbz27+wwWgaEWYlrOgqf1EZUL
	Eq5aTU8NR8RBawlUsh6kPPUIKD4jXijnGCag2HvhVGZb3iCQ==
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 46gnpeuena-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 09 May 2025 05:39:25 +0000 (GMT)
Received: from nalasex01b.na.qualcomm.com (nalasex01b.na.qualcomm.com [10.47.209.197])
	by NALASPPMTA01.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 5495dOPw024358
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 9 May 2025 05:39:24 GMT
Received: from maow2-gv.qualcomm.com (10.80.80.8) by
 nalasex01b.na.qualcomm.com (10.47.209.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Thu, 8 May 2025 22:39:22 -0700
From: Kassey Li <quic_yingangl@quicinc.com>
To: <rostedt@goodmis.org>, <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>, <mathieu.desnoyers@efficios.com>,
        <linux-kernel@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
CC: <quic_yingangl@quicinc.com>
Subject: [PATCH] scsi: trace: change the rtn log in hex format
Date: Fri, 9 May 2025 13:38:40 +0800
Message-ID: <20250509053840.2990227-1-quic_yingangl@quicinc.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA5MDA1MiBTYWx0ZWRfXxvFD6Oz8Cxdb
 ILwR18aa2E0GULZhSl71E3AR+vsD/t8H+U+zryxYgnZvxQ+zDNJwBl2+6d7sLgn9/gWrFEpvvx3
 FbVV/KKGLm7tpjDE9xWW78qNk/gDOBIxA/bv5YqplRENKQaCkR7cQ3DW2CrCb+W1ByxAev7ScCw
 VLSgv+96lJNpnFP7TvSmcQ41xi3onw8BpI0ZmFBtVBAJpw56sQ8Htxdbnik/1WqSRB+XsQ2gvij
 dKg91W9KIZ38EwcnTDCpYe3JgoGKYhy4/0sirAPc+llbjHVsgX3Pp/t1dXZ3voy3IAXI3Wf45sb
 kDJhBApONbHFaCi9kKb0WtAWsTCjeFSOXD2bt0PACiEOyhjBeDh5XG/4TZB7oJ+Bf1VJACfewMX
 HdQFYHrYZCkcf8USQr1DnPPjeH8p2kr0RwqeBtLBQPh0O9iXo3OQFCkkfJjt5yUo8PtFaCFe
X-Proofpoint-ORIG-GUID: twzLnnVKHtcYEp0HqzyGlrUiXT8tJREt
X-Proofpoint-GUID: twzLnnVKHtcYEp0HqzyGlrUiXT8tJREt
X-Authority-Analysis: v=2.4 cv=Yt4PR5YX c=1 sm=1 tr=0 ts=681d950d cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=GEpy-HfZoHoA:10 a=dt9VzEwgFbYA:10 a=COk6AnOGAAAA:8 a=BHyZBowvuSOj8lr59awA:9
 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-09_02,2025-05-08_04,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 mlxscore=0 adultscore=0 spamscore=0 impostorscore=0
 phishscore=0 lowpriorityscore=0 mlxlogscore=999 suspectscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 classifier=spam authscore=0
 authtc=n/a authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2504070000 definitions=main-2505090052

In default it showed rtn in decimal.

kworker/3:1H-183 [003] ....  51.035474: scsi_dispatch_cmd_error: host_no=0 channel=0 id=0 lun=4 data_sgl=1  prot_sgl=0 prot_op=SCSI_PROT_NORMAL cmnd=(READ_10 lba=3907214  txlen=1 protect=0 raw=28 00 00 3b 9e 8e 00 00 01 00) rtn=4181

In source code we define these possible value as hexadecimal:

include/scsi/scsi.h

SCSI_MLQUEUE_HOST_BUSY   0x1055
SCSI_MLQUEUE_DEVICE_BUSY 0x1056
SCSI_MLQUEUE_EH_RETRY    0x1057
SCSI_MLQUEUE_TARGET_BUSY 0x1058

This change converts the rtn in hexadecimal.

Signed-off-by: Kassey Li <quic_yingangl@quicinc.com>
---
 include/trace/events/scsi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
index bf6cc98d9122..a4c089ac834c 100644
--- a/include/trace/events/scsi.h
+++ b/include/trace/events/scsi.h
@@ -240,7 +240,7 @@ TRACE_EVENT(scsi_dispatch_cmd_error,
 
 	TP_printk("host_no=%u channel=%u id=%u lun=%u data_sgl=%u prot_sgl=%u" \
 		  " prot_op=%s driver_tag=%d scheduler_tag=%d cmnd=(%s %s raw=%s)" \
-		  " rtn=%d",
+		  " rtn=0x%x",
 		  __entry->host_no, __entry->channel, __entry->id,
 		  __entry->lun, __entry->data_sglen, __entry->prot_sglen,
 		  show_prot_op_name(__entry->prot_op), __entry->driver_tag,
-- 
2.34.1

