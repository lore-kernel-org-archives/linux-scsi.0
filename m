Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4AFDEEA8;
	Thu, 23 Jul 2026 00:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784764924; cv=none; b=U+bCPuVDMBKapFP6QEbhbDDxXf8tr9WSRYFVhwslcw+7Wkszk05VFcmMCmJ4qvuJ1gDMimCabV/m7h9rmYmYM3Z37OOkFUdHUeG8ayhrMeTNwYOhp1pFt22WjgcHizAsy7NV/eE1tv6blTDCZ7t4Ht9kgpdMn3iWASKCD5gDmgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784764924; c=relaxed/simple;
	bh=kPwMDJfn8oY3sPtqsePW84/vl0bf/i7xxG7ZJicuvm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PCY+VnWTvqorc+oWcymoPUZvyX1E2m/8vaJyvVMl1vCF6CD5aq2tuW0d8y0jO20njEg0u8ktQEkN6+4GBPt7Zm3DSrB8413u9FLTEIF/9p9Zk3qFSueSvdZBowikIPkn8uK3k12I77WB9tL+IZLiNlAcczX7OtyDfO823NptPX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=nwp9Anr2; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="nwp9Anr2"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MIC26j606737;
	Thu, 23 Jul 2026 00:01:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=MfXlpQ9U0Pnz7LP8n
	XUemnalX3ZKpIT95W7d8gsiaeY=; b=nwp9Anr2SdtaXxx5koRl8SdcF4eR9LxJ6
	ZCOcsrBAQzM+1aWVNTo0BNrRk/WsxawZJrPA2cHIUaIky9zVCT2Clz0AsPV7jqwM
	TuImG4cTwzHbKmnCEGsxL3rZ4Zmr6Pgn1qMuBIAlMghEtEVvPPuPC8zMiO+Ca67W
	2933dQpTwLYljyHR8PZBHQ1jRmPAISQaFjx0fqMq1PMUvrks8Q2tkze4PWR/PGph
	71pE7tyGMamxiqyjFbeciQy7rgzOtXJb1XXFw+6uCBzoikJzIxBa4q8vrdFUh5N9
	WcVVQTybltliMBP5pKzfWs3b3x9fD1PMdRAo0HYr/Sp7BWN7wzhaw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fg78gcbyn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 00:01:56 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66MNnaeJ009366;
	Thu, 23 Jul 2026 00:01:56 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fgp1ghj9e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 00:01:56 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66N01sTg15598258
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 00:01:54 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 265C75803F;
	Thu, 23 Jul 2026 00:01:54 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7C94A58056;
	Thu, 23 Jul 2026 00:01:53 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.118.58])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 23 Jul 2026 00:01:53 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v2 01/33] ibmvfc: don't call locked done variant for MADs on send failure
Date: Wed, 22 Jul 2026 17:01:17 -0700
Message-ID: <20260723000149.969416-2-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260723000149.969416-1-tyreld@linux.ibm.com>
References: <20260723000149.969416-1-tyreld@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIyMDIzNCBTYWx0ZWRfX+UGoEHsSfV84
 4AykICTcnrCNO3UHhQitPlkW8P5ms0YuPhHfDN6OoSWYbUAADTdtvJEq/737rhCz+45eiI7MJei
 tNmhJ/1Vw3qdUvlEamzLM462datFxWW48du2FSOkwFpdWt3h0U4lzVocnuJSpPxrIdSmYAHzRzI
 DFsK1zY7KcrXTwtClSJM/mvUz/m6KhrDhmD8XdwJQ1rbrxJ2OJnMskMWZLMosUjhtmu4ozGAeUe
 ncjM8u+HMmpCUVTZ0OUADDmj4obLRoeyqWJiGylj8Bg0UbXuQk8sYjiRf3o24mOYP9UrpfAFJJf
 FsbR5nyy5xzs2LdODzCU1PmQ1Pqxoo9zN0oSdu1VgExAquWMx9ZiSX6eZCM9fRX4BeIPO9FsY/r
 jX+2areW/0S9SfW5Ow3/zkL8D2w769VTli1Su687QLU0T+dcSiShAN2jowD3geyBc2WwzW1mb4R
 FAQSSQeeMLpmO91XX/w==
X-Proofpoint-GUID: eYZ2FdG2RZhtR2cR-OVyG95BKalfOkGS
X-Authority-Analysis: v=2.4 cv=MelcfZ/f c=1 sm=1 tr=0 ts=6a6159f4 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8 a=4c2M-Vx5SB3eEEvsMGgA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIyMDIzNCBTYWx0ZWRfX4Ttoal5cik/N
 Fe2A/znflOSltnIqHYmcykn6GOCiZ8laGzLk8VHMen2JhTBOL+LPN+ge+ktI6ObqGVFXa9eVw4H
 p5lzmLrqEr5M/zP2+QZ10Wzq+XCwCt8=
X-Proofpoint-ORIG-GUID: eYZ2FdG2RZhtR2cR-OVyG95BKalfOkGS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-22_05,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0 spamscore=0
 clxscore=1015 malwarescore=0 phishscore=0 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607220234

MADs are processed with the requirement that the host_lock is held for
MAD sends and completions. When a MAD job step is called the host lock
is already held and there is an unlikely scenario where h_send_crq fails
with something other than H_CLOSED. If this happens there is a special
done handler for MADs that tries to take the host lock.

In this failure scenario fall back to the saved evt->_done unlocked
completion handler.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 3dd2adda195e..0a5f73df8d7d 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1774,8 +1774,10 @@ static int ibmvfc_send_event(struct ibmvfc_event *evt,
 		if (evt->cmnd) {
 			evt->cmnd->result = DID_ERROR << 16;
 			evt->done = ibmvfc_scsi_eh_done;
-		} else
+		} else {
 			evt->xfer_iu->mad_common.status = cpu_to_be16(IBMVFC_MAD_CRQ_ERROR);
+			evt->done = evt->_done;
+		}
 
 		evt->done(evt);
 	} else {
-- 
2.55.0

