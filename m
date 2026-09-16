Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C4D4CDA39;
	Wed, 16 Sep 2026 23:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789600184; cv=none; b=AxgoDmchSQEySL4fOjOeFHRW0k1uBYIGlQBlG8gLxIMJLf2RlLEGsV1SKHERZnQ3Bp/gFmu3qu7YJDEwjYGUF5GVLWBc2KJdbQgbTPyJJVAt8UcKquRuJy+CEtExT8+Lws75+Y7X2Hh/Qc3Xwi2a5orfTdS94DsCAHkKVhiIPcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789600184; c=relaxed/simple;
	bh=zJ6L1QAlhR+1HXypefU7avEpVe9R03mjn5C+8OtqXyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fnBtf76FOFt5A3SJxBUyWU5XGbOk8BN5vtYmX+E5lkPdzpSlq/Zrugvb3ZXkbG5D+H1bN6wkeionlX2S80i3xWek+GAX8sU7awkyyUKSOEPD38Vs3tvX1YkFLXUqeciiIb9jjT0JjsUWJsCYQdaopiu5HA8GGIHspMTSkKrplXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=CN6Bpi7s; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="CN6Bpi7s"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68GG1Yx5045799;
	Wed, 16 Sep 2026 23:09:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Ssa+kO
	Pw6tapYQKMBt9xIFOJDUDAQJSNTivqb+/sVdg=; b=CN6Bpi7sEvDtB0CK3sDMsv
	TShXRLUgtwallfyey8xYjkfyKdr7D0VCD0XUMmcmYYzJxfgqznosDLZ9I5DcSNs8
	6ZbZLLFKcLUDLHHw10BTrVO/RqxXQf53IuwnUFp3T08/zC0G2nOlhgaFMj9V+i1L
	ssIcuclccsm241fPSjMYqWXS7olIoyJAof9htZLfB7TBUYr2t01IVlwaQwAmzIJK
	zzU1AbahxSdkXI6RgAj2yN5RPSmnwZ7yq6ceNcy86VDVwOG0uhfHEiyfBJESVhUP
	ejTyslb1pZGbn8tevxFquPl/TyiTZrNrWHvcQZ3xfqQc4D1EUbOJfvAF6ieU0Riw
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmxcv6y0y-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 16 Sep 2026 23:09:35 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68GN12qB1713037;
	Wed, 16 Sep 2026 23:09:34 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gpywf0w4j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Sep 2026 23:09:34 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68GN9WVB16646910
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 23:09:33 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CEC615804E;
	Wed, 16 Sep 2026 23:09:32 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DE7B058054;
	Wed, 16 Sep 2026 23:09:31 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.141.190])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 16 Sep 2026 23:09:31 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 05/20] scsi: ibmvfc: fix uninitialized _done dereference for TMF events on send failure
Date: Wed, 16 Sep 2026 16:09:06 -0700
Message-ID: <20260916230921.2204729-6-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916230921.2204729-1-tyreld@linux.ibm.com>
References: <20260916230921.2204729-1-tyreld@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDMyMiBTYWx0ZWRfX+5CyZkki3zac
 ZffQLbGS3a8xsEtlqKUhepjTrP25egmPF6XoZPnQdfA+HlEfvfBirQ9rW7EGu/4XozvGqL8aP1l
 FCQivsiTB2h8MadJDl7iMx9Yddg7t60=
X-Proofpoint-ORIG-GUID: 7nnLSzqbydesDcX92fMzEmzKZ3KIbfiK
X-Proofpoint-GUID: 7nnLSzqbydesDcX92fMzEmzKZ3KIbfiK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDMyMiBTYWx0ZWRfX76mJxO8I8vCp
 mBK/9voZHmRIV5qqBN61rTFrY24cHfQ3LBPwbmSO6eDSHVLTSdOHpD99y/h8C6ht9uF4Dg4vHNG
 CwqbC3WzCtXeuuASuJQRg1iPl6VogbTTAedilx+B+5gfPA7hLhDcsQwgxGxjOUxlRPv/gTxvBLQ
 o8lGXxWRVNtB90R0zNawe9706aCnvpqdbzOzRIEB4GAzT1cdJIaslfA+eAThL0K7MGNmTEBgMT0
 iJYIk0nKU/Sm6mEDwZu37v88vCOdl5vq3cVLsR2xNsSKJXml0EuD7KWOUdpYN06/Tsl+6kC7TyL
 jWTcQGx/+myQZZtKEBnwSTvEfY4cCYIYUe+C9C1hayh+AN5XoEl9X67/Vr+xjDdNiiYdMJKcVc8
 YTZU4bgnvwuQ3BvoxPmHQKe9drZWSqbfomytNYlG4k38G7lzW9yrlCleQYi3+jrtFdQmv9U0SW/
 KrQ91Ojlw8jP7ZHg8Ig==
X-Authority-Analysis: v=2.4 cv=F+7C5ahN c=1 sm=1 tr=0 ts=6aab21af cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8
 a=qtjYkiDot-WfiDIOCeAA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=O8hF6Hzn-FEA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-16_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 phishscore=0 clxscore=1015 malwarescore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609160322

In ibmvfc_send_event(), the non-H_CLOSED error path uses a bare else
clause to handle the case where evt->cmnd is NULL, assuming the event
must be a MAD and reassigning evt->done = evt->_done before calling it.

However, SCSI Task Management Function (TMF) events created by
ibmvfc_init_tmf() are initialised with IBMVFC_CMD_FORMAT, not
IBMVFC_MAD_FORMAT. ibmvfc_init_event() only populates evt->_done for
IBMVFC_MAD_FORMAT events; for IBMVFC_CMD_FORMAT events evt->_done is
never set. Since TMF events also have evt->cmnd == NULL (cleared by
ibmvfc_init_event()), they fall through to the bare else branch,
copying the uninitialised evt->_done into evt->done and immediately
calling it — a wild function-pointer dereference that results in a
kernel panic during SCSI error recovery under SAN error conditions.

Fix this by replacing the bare else with
'else if (evt->crq.format == IBMVFC_MAD_FORMAT)', gating the _done
reassignment strictly on the MAD format where evt->_done is guaranteed
to be valid. TMF events (IBMVFC_CMD_FORMAT, cmnd==NULL) no longer reach
this branch; their evt->done (ibmvfc_locked_done wrapping
ibmvfc_sync_completion) remains correct as initialised, allowing the
waiting ibmvfc_cancel_all_sq/mq paths to receive the completion
normally.

Fixes: 98e0f82a0d3f ("ibmvfc: split NVMe support into separate source file and add transport stubs")
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 420ddb958466..89d271adccd0 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -1859,7 +1859,7 @@ int ibmvfc_send_event(struct ibmvfc_event *evt,
 			evt->done = ibmvfc_vfc_eh_done;
 		} else if (evt->fcp_req || evt->ls_req) {
 			evt->done = ibmvfc_vfc_eh_done;
-		} else {
+		} else if (evt->crq.format == IBMVFC_MAD_FORMAT) {
 			evt->xfer_iu->mad_common.status = cpu_to_be16(IBMVFC_MAD_CRQ_ERROR);
 			evt->done = evt->_done;
 		}
-- 
2.55.0

