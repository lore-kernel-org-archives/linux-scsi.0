Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC3F638D3E2;
	Sat, 19 Sep 2026 01:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789781610; cv=none; b=JwOVHaLiNW5CIuxqUXy5xJT04j0bWNKayZ49Z0je7lkNC+nyCd31nn3dCNfXXIY628shPyTpciZSP4mBBmfjpVs1AvLw73Z/tZkAoi7S7ZVDueMKFho+verYmrZGspWBqnqxiFlNnKLoWGqxkcg2hl4wF79TkiVu5dlwclg7F+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789781610; c=relaxed/simple;
	bh=Ij5VwwdlD8mJy+tK/8w/h56u56NGyOSDleALMcqOj2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HhBMReGjCuVPkiGPfSH6DoJVPvhUsFoz4loado5ujw+qQvvHOK5PPBlAMMYYcQ4SVZLuZMLe3KGh0Ns9MmYXJKdjVSqbTTG7fmfbc7h5ZjWIZlcOFdxrFfmauTvmO55o4iUY9KeIinyx7CHi57jgQzmUGj6vfxTgmh7leICNQ0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=JYH24ieI; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="JYH24ieI"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68J01pJj2707060;
	Sat, 19 Sep 2026 01:33:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=UMdifT
	5cjTUVtdlRLrZWhP9oOLrPKfWFwvBJO5bk5qk=; b=JYH24ieIY0qj9jNygGV4pU
	lqnt0riFB+I/90Z87eTgzcuBFiCHy4Qc6iiXqbkw3pRaeRvlbcaGeB2A4IdugRac
	iglWa7ZRTr101HGSfcA3EN29B0fAZ1/FCXsCvAtcF/Ln40F6fqLkAJAz1+eKo4M9
	u0YEdGxtQdEl7ViJzE94SunDn8CuKw5uHuvG23POnZEoZDZrHjYKusvV+aYZ3efz
	E66ZuSk63ScCu0THWbn+uva2iTdq/70y5TK+klloA3ph7YcDsSF8O3jfDIyVti3t
	SIWrGD3Fwa+0GVhkiq58KQ+vj/gcFbh4DNo3oPYPJFABdQDDA7vRkEFYwlyZHwEw
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmxcvj9mh-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 19 Sep 2026 01:33:20 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68J1UiQr2575638;
	Sat, 19 Sep 2026 01:33:20 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gsgssg06h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 19 Sep 2026 01:33:20 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68J1XJ7p33948240
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 19 Sep 2026 01:33:19 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 46C2358051;
	Sat, 19 Sep 2026 01:33:19 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 983E05805A;
	Sat, 19 Sep 2026 01:33:18 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.101.145])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Sat, 19 Sep 2026 01:33:18 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v2 11/20] scsi: ibmvfc: fix UAF and hang in ibmvfc_cancel_all_mq() on send failure
Date: Fri, 18 Sep 2026 18:32:57 -0700
Message-ID: <20260919013306.2948028-12-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260919013306.2948028-1-tyreld@linux.ibm.com>
References: <20260919013306.2948028-1-tyreld@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE5MDAxOCBTYWx0ZWRfX+vd2ak2XlJOl
 zQpY4RmCrQ2BfgaNoXIvHB/ZFZ8x9lwe8K5bKCBG6FgnCrb9DIKcHytmB2RlHakhi0zLZ1BCG4z
 MxZ7amptCe0crTlwp4V1bMu6ypS15dA=
X-Proofpoint-ORIG-GUID: Ld4m8zdCWjhUiLT8UkVK58QbHfD6ESs9
X-Proofpoint-GUID: Ld4m8zdCWjhUiLT8UkVK58QbHfD6ESs9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE5MDAxOCBTYWx0ZWRfX815Uw9NBDHOA
 O/UQ4qolhx4qJbWvIN2bvTC+zwIMy2wGQ6OwXgybiGppPGeZqNWn66V6M1kP+L5izcOBB53kWrh
 orQeppM6CdHSHnQG8P+8SSy2Cg00iLsbq5JJtau9iXhk++KLWG+Parv+tk5aXyO39YDU8fXU7ae
 oql63NFVbg8Gvl3pPYIqk0xIrGbkoQnVRoHCyzEmnAoyo87wvddil9OIBNZwlRsB+Anh66/QmT5
 w1K6cXSAuv/jJC+uLwiR2y/hoPRc5vMBDVPyW/eCSeAa5QcEGS0yX9RLVTdUyMGpKzaqdzo7cR6
 Ewtv23B7uc2v1qUmexRCHZN0U7+6/izz9mLu29OQsIqqTcjMewAUNK0lxTPnYEMCCb4h6dPCrPo
 xg2ik2Cfm/wIjK7KX8rI28jM8PCskzQzZ9OaWVZspJ72Z9sGpsqJXQCtBzKYo2bbA8xQe4xr5xS
 X0W7SZRzAToxhX6zTiA==
X-Authority-Analysis: v=2.4 cv=F+7C5ahN c=1 sm=1 tr=0 ts=6aade660 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8
 a=nlcoev9x_0hUi8ert_4A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_07,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 phishscore=0 clxscore=1015 malwarescore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609190018

ibmvfc_cancel_all_mq() discards the return value of ibmvfc_send_event().
When ibmvfc_send_event() fails due to H_CLOSED it internally frees the
event before returning SCSI_MLQUEUE_HOST_BUSY. The caller then performs
list_add_tail() on the freed event — a use-after-free — and subsequently
blocks indefinitely on wait_for_completion(&evt->comp) for a completion
that will never arrive.

Fix by capturing the return value. On failure, drop the locks, log the
error (consistent with ibmvfc_cancel_all_sq()), drain and free any
cancel events already queued from earlier loop iterations, then return 0.
Returning 0 on send failure is correct: when the adapter closes the CRQ
the firmware delivers a transport event through ibmvfc_handle_crq() which
completes all outstanding commands, so the error recovery caller will
naturally see them return.

Fixes: 9c2aa65000f6 ("ibmvfc: don't call locked done variant for MADs on send failure")
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 623fff503040..080312ff0a93 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -2696,6 +2696,7 @@ static int ibmvfc_cancel_all_mq(struct scsi_device *sdev, int type)
 	unsigned long flags;
 	int num_hwq, i;
 	int fail = 0;
+	int rc;
 	LIST_HEAD(cancelq);
 	u16 status;
 
@@ -2722,7 +2723,18 @@ static int ibmvfc_cancel_all_mq(struct scsi_device *sdev, int type)
 				return -ENOMEM;
 			}
 			evt->sync_iu = &queues[i].cancel_rsp;
-			ibmvfc_send_event(evt, vhost, default_timeout);
+			rc = ibmvfc_send_event(evt, vhost, default_timeout);
+			if (rc) {
+				spin_unlock(queues[i].q_lock);
+				spin_unlock_irqrestore(&vhost->host->host_lock, flags);
+				sdev_printk(KERN_ERR, sdev, "Failed to send cancel event. rc=%d\n", rc);
+				list_for_each_entry_safe(evt, temp, &cancelq, cancel) {
+					wait_for_completion(&evt->comp);
+					list_del(&evt->cancel);
+					ibmvfc_free_event(evt);
+				}
+				return 0;
+			}
 			list_add_tail(&evt->cancel, &cancelq);
 		}
 
-- 
2.55.0

