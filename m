Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD2438BF8D;
	Tue, 23 Jun 2026 01:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782178267; cv=none; b=Q3MkcCDxFNf4XVIwvqxwZoug5fwVPvmAzfV5ha2X2dr/pZ4KC2WrnREo0BhQEBO6RxKjeozUKUf9TYlPofECO+iH7b2vnoxM//fob0RmYzJrMLIKkCaW1s7MnvdxfZNaHRLycirp9YMvlPVr7nLh9LK+tIGAiOnj6NbTg6J7bkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782178267; c=relaxed/simple;
	bh=zfNo0n+C/iuCZR0n4TJu59dUquCle4jhtz3KRqrv6no=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LhTu2D3adb1uBLcWnETLEXC9LU4ZvOFOKm8UcwrJf45IBwbsyyfDjJxcDtg7bFBjaSwiFbZW9i2BDOk8FY1xZnLGI8bEk3kCMVkX7SUTrULqxeV521sm4pr645cSma9jRBTAvouKN9JKxwVBwhjPR/GlHbhs/tWknwD6XlFQjLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=IaTvE2d/; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="IaTvE2d/"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65N0nvvU348179;
	Tue, 23 Jun 2026 01:30:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=F/IuTa2oLvliPlBdB
	iKh1cn8/0kCUId2UQAFrDdWN6o=; b=IaTvE2d/Ul44p6flWOGNDO2ZSa0EiZUei
	1zlhlr5zEbbB1UhOqFQKkyBga4Y1V8NB6jtBKhWAKG7bSWW6m03epe2NDqZtEFgP
	xWVcxhDTyD3f/h4KKZgjyhJFZqMUHZPDcMidMzUnM0Hzpq7K6RleMExOE47EiGI/
	ePRHPGgVzR498DJ6p/FpYCnKXt1uEuEnUy5gjZnwaY4vWE0AnlQx4xhI4G+5wIuU
	C+SSwlM7QdRW7wW/Hp3OAUlF7yEPuziuV7BEXzyfd5dyvhcYvs3nKxgTp+BWOvKg
	5ibAXZY1NqcrN/zdbj5CphvgQYK1N2PNxL+aWSmIM5CTkdakZIdLw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ewh9gc43e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jun 2026 01:30:53 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65N1Jdhw026295;
	Tue, 23 Jun 2026 01:30:53 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ex7dg0qwd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jun 2026 01:30:53 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65N1Up1I27853318
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jun 2026 01:30:51 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2DFB45805A;
	Tue, 23 Jun 2026 01:30:51 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 938E058056;
	Tue, 23 Jun 2026 01:30:50 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.188.206])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 23 Jun 2026 01:30:50 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 18/29] ibmvfc: update state machine to process NVMe/FC targets
Date: Mon, 22 Jun 2026 18:30:24 -0700
Message-ID: <20260623013035.3436640-19-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260623013035.3436640-1-tyreld@linux.ibm.com>
References: <20260623013035.3436640-1-tyreld@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8OdxX9v3bP7sdRhyNLX3gcNlbK43O-dj
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIzMDAwOCBTYWx0ZWRfX7kTGj5GCroMO
 tICFUgP9dUuRGkRvKmSWzhAkcGkG6mEkcLiBplfC1oKyTkZVKD2GGBM+Fuxtb/sVYZmQgKrzBo5
 jOfnQI/DDCQgyJ0QllW48QwPHwPXXzE=
X-Authority-Analysis: v=2.4 cv=c62bhx9l c=1 sm=1 tr=0 ts=6a39e1cd cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8 a=-uFVuYJf3eyC8FhR5LMA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIzMDAwOCBTYWx0ZWRfXyPYiUY13piOC
 HLsNKtpoPSm2MkohuOsAsISh0l/i1hmylMyINwSaEkHf75rKKhpl9g3VwxwbSrrA7yzB0yGpk9Y
 MpFmriBJBv1c3Uy0gU2yqzd/FZPN5+BHUNociVEBBsP/8VFPL7pMo4U1qwydzFyrDJHioKHqALI
 Br5E6jzJ6XaL5be8sWwP+SuA7IeMN+9fLlykK2p51If1nTdgqrGZl+5wCTM6FlvmnJwPHICfuj3
 c61UMiFpij/JfJqsiBMnTPl3b0hji6Bi6AYkNabrAf4KaUXOzrtpQYXXl3t1llzcnAXH1/u8y8k
 eoE7cZF84XbVWJxk+zxGuQyDmTAXnhJw4TKldY1qSSBQ5E994y1y+UpA6OQOcZHlnFPbcPPv1KU
 AZXjmC0BgqP0/J2JPhAwCx3U68CLtRgeTEghIE1SSDyBjOjNpBM/o8ChY26bpZP6pkLIaxup+d/
 4PQJ1yAlThmMlUWQbbw==
X-Proofpoint-ORIG-GUID: 8OdxX9v3bP7sdRhyNLX3gcNlbK43O-dj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-23_01,2026-06-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 impostorscore=0 adultscore=0 clxscore=1015 suspectscore=0
 priorityscore=1501 phishscore=0 spamscore=0 bulkscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606230008

Update the host work loop and target state-machine helpers to process
NVMe targets in addition to SCSI targets.

Check both protocol-specific target lists when determining whether there
is initialization or logout work pending, and extend the query, target
init, and target delete phases to dispatch work for NVMe targets using
the same common state-machine callbacks.

This allows the existing discovery and login state machine to drive
NVMe/FC targets through query, login, and deletion without duplicating
the control flow.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 42 +++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 13e513bfd0a8..9a6a885aa57e 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -5692,6 +5692,11 @@ static int ibmvfc_dev_init_to_do(struct ibmvfc_host *vhost)
 		    tgt->action == IBMVFC_TGT_ACTION_INIT_WAIT)
 			return 1;
 	}
+	list_for_each_entry(tgt, &vhost->nvme_scrqs.targets, queue) {
+		if (tgt->action == IBMVFC_TGT_ACTION_INIT ||
+		    tgt->action == IBMVFC_TGT_ACTION_INIT_WAIT)
+			return 1;
+	}
 
 	return 0;
 }
@@ -5712,6 +5717,11 @@ static int ibmvfc_dev_logo_to_do(struct ibmvfc_host *vhost)
 		    tgt->action == IBMVFC_TGT_ACTION_LOGOUT_RPORT_WAIT)
 			return 1;
 	}
+	list_for_each_entry(tgt, &vhost->nvme_scrqs.targets, queue) {
+		if (tgt->action == IBMVFC_TGT_ACTION_LOGOUT_RPORT ||
+		    tgt->action == IBMVFC_TGT_ACTION_LOGOUT_RPORT_WAIT)
+			return 1;
+	}
 	return 0;
 }
 
@@ -5740,9 +5750,15 @@ static int __ibmvfc_work_to_do(struct ibmvfc_host *vhost)
 		list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue)
 			if (tgt->action == IBMVFC_TGT_ACTION_INIT)
 				return 1;
+		list_for_each_entry(tgt, &vhost->nvme_scrqs.targets, queue)
+			if (tgt->action == IBMVFC_TGT_ACTION_INIT)
+				return 1;
 		list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue)
 			if (tgt->action == IBMVFC_TGT_ACTION_INIT_WAIT)
 				return 0;
+		list_for_each_entry(tgt, &vhost->nvme_scrqs.targets, queue)
+			if (tgt->action == IBMVFC_TGT_ACTION_INIT_WAIT)
+				return 0;
 		return 1;
 	case IBMVFC_HOST_ACTION_TGT_DEL:
 	case IBMVFC_HOST_ACTION_TGT_DEL_FAILED:
@@ -5751,9 +5767,15 @@ static int __ibmvfc_work_to_do(struct ibmvfc_host *vhost)
 		list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue)
 			if (tgt->action == IBMVFC_TGT_ACTION_LOGOUT_RPORT)
 				return 1;
+		list_for_each_entry(tgt, &vhost->nvme_scrqs.targets, queue)
+			if (tgt->action == IBMVFC_TGT_ACTION_LOGOUT_RPORT)
+				return 1;
 		list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue)
 			if (tgt->action == IBMVFC_TGT_ACTION_LOGOUT_RPORT_WAIT)
 				return 0;
+		list_for_each_entry(tgt, &vhost->nvme_scrqs.targets, queue)
+			if (tgt->action == IBMVFC_TGT_ACTION_LOGOUT_RPORT_WAIT)
+				return 0;
 		return 1;
 	case IBMVFC_HOST_ACTION_LOGO:
 	case IBMVFC_HOST_ACTION_INIT:
@@ -5941,6 +5963,8 @@ static void ibmvfc_do_work(struct ibmvfc_host *vhost)
 	case IBMVFC_HOST_ACTION_QUERY:
 		list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue)
 			ibmvfc_init_tgt(tgt, ibmvfc_tgt_query_target);
+		list_for_each_entry(tgt, &vhost->nvme_scrqs.targets, queue)
+			ibmvfc_init_tgt(tgt, ibmvfc_tgt_query_target);
 		ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_QUERY_TGTS);
 		break;
 	case IBMVFC_HOST_ACTION_QUERY_TGTS:
@@ -5950,6 +5974,12 @@ static void ibmvfc_do_work(struct ibmvfc_host *vhost)
 				break;
 			}
 		}
+		list_for_each_entry(tgt, &vhost->nvme_scrqs.targets, queue) {
+			if (tgt->action == IBMVFC_TGT_ACTION_INIT) {
+				tgt->job_step(tgt);
+				break;
+			}
+		}
 
 		if (!ibmvfc_dev_init_to_do(vhost))
 			ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_TGT_DEL);
@@ -5962,6 +5992,12 @@ static void ibmvfc_do_work(struct ibmvfc_host *vhost)
 				break;
 			}
 		}
+		list_for_each_entry(tgt, &vhost->nvme_scrqs.targets, queue) {
+			if (tgt->action == IBMVFC_TGT_ACTION_LOGOUT_RPORT) {
+				tgt->job_step(tgt);
+				break;
+			}
+		}
 
 		if (ibmvfc_dev_logo_to_do(vhost)) {
 			spin_unlock_irqrestore(vhost->host->host_lock, flags);
@@ -6049,6 +6085,12 @@ static void ibmvfc_do_work(struct ibmvfc_host *vhost)
 				break;
 			}
 		}
+		list_for_each_entry(tgt, &vhost->nvme_scrqs.targets, queue) {
+			if (tgt->action == IBMVFC_TGT_ACTION_INIT) {
+				tgt->job_step(tgt);
+				break;
+			}
+		}
 
 		if (!ibmvfc_dev_init_to_do(vhost))
 			ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_TGT_DEL_FAILED);
-- 
2.54.0

