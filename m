Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 571BA2931D3;
	Sat, 19 Sep 2026 01:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789781602; cv=none; b=X3VTnzDXUYtJ/MZU1atiHMlXfwow5WyOxpcKayobdJt2+140+grU4h8pzoj/5ht0js9EeiyCX/SL3//fZkhUwMpp/oaW11/hWdqoJWy5HmA5JvEl8SbxWd3BqAl+vwUfXHjaqPb+R//vEQuZ0W9XlrkvJHte5BIW1R/XE7L2huw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789781602; c=relaxed/simple;
	bh=zgxjKpn1kyNMIBVwaF12Kde+LXaxrhu50R6RDuOyIJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JBQKndvZMNxuT1jZTFFukDeGUc0ECWe+L99DvJgTNSgoy2bwaJF8TqKAtPBJcDo6+pzRTMTdJEaiacMOdijCeK5B+Y7ExX+1/JMIWKsjY3i4rOsMSeZ3aNw3U78hj0R33kxaxqUUBHyMFGWykMTe7wgi6sfxGWY8wP60YgW+wDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=UsVT/QAS; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="UsVT/QAS"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68J01m9m2706907;
	Sat, 19 Sep 2026 01:33:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=ClrGPMR2eCl1PGakK
	33NKTydd8/M9xCYys0xvOiUDi8=; b=UsVT/QASmz5vWWbXgEmBbkC37V07kFZeh
	Ua38cAQ3mhFlrrmAPmQcQZ3dhAY0WeItxV8F2fymdmPfeFc3IyKmyMvOwmoft/6n
	bfl+yiLDx1/mAkVVaaYCXwWvRFhWgSuON8Ho4WnNn6B5ajrneF5HgJ4bQAAgoCqx
	VDKDUJBLNkMk3afWwkDy7JCqO7RpFGKxpaFgeNQ5ZHnF4tXJ0Mt0wPKSipyYxdVm
	aUwxSy5jbZhel+eajASV9Y7x660hxrO/W7GERq1nQu12AR0CIDE9mYf1XY8kywHa
	5c+OQiocOrvqCqZznl4dJW70d97zc1mB/Dw6Wv0jKdrUDW4h0rFfw==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmxcvj9mb-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 19 Sep 2026 01:33:13 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68J1UJDq2574299;
	Sat, 19 Sep 2026 01:33:12 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gsgssg066-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 19 Sep 2026 01:33:12 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68J1XBo117891892
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 19 Sep 2026 01:33:11 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B109358051;
	Sat, 19 Sep 2026 01:33:11 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 135935805A;
	Sat, 19 Sep 2026 01:33:11 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.101.145])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Sat, 19 Sep 2026 01:33:10 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v2 01/20] scsi: ibmvfc: initialize evt->tgt for NVMe FCP commands
Date: Fri, 18 Sep 2026 18:32:47 -0700
Message-ID: <20260919013306.2948028-2-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260919013306.2948028-1-tyreld@linux.ibm.com>
References: <20260919013306.2948028-1-tyreld@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE5MDAxOCBTYWx0ZWRfX8KuuHX5p7DbH
 pyQe3WxsZ8bXKvsPLTAZc6a31X+CQGwK4OeOQN2YLmmy6mvJ6wIeHZnNPWz2n6pzPnTw0vdclR0
 mhfeX/MdheZoUsY55Ad/3/ri340BrSw=
X-Proofpoint-ORIG-GUID: Rb0heMknMFAYqjXtnDCzp8iOtvtRZFzy
X-Proofpoint-GUID: Rb0heMknMFAYqjXtnDCzp8iOtvtRZFzy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE5MDAxOCBTYWx0ZWRfXz7azyFtaSsd3
 XdbVURY6puhdBKY+C9VChVrv8CdTkR44A0+6VRkvR6mPj/DP1u60/iwpfJCS/CURVBVv5eDQH4A
 kdHQDwdJIuykrYxQyVzFrAFj1ZHH/6FFQcujIqmlpBhHAq6XZZXmWFYqum2eLocMybi7pc2FxA/
 vYUySvrpm+HZ8jO0gGvrf15VwsicKZKIOydREIvHFkEHae7I7o5/WMxcKaWxmm6yLTYEr2IYhcD
 lRxkbI9vPjyOtxZXj5avPAzFXmam5TbhJczcNumvcg4bVVuOuYf/l7y7b5msWV8REDP3t+zk4KJ
 2HZwAFiqm7Ro02yc8APYdOpa6k+ilVcmYhqTOLq/6abhsGp7U2l8uh/GRwrKMkbiZ7QKwiCYxRc
 YtRi910g2CZv/TiV0VJmDeULjDYhK46JHFzI/B5lZIX8CuR0SxHxrsGfCoz/ayGJoNJP+vvKfq4
 jZasvkBNufpGWOWL5Fw==
X-Authority-Analysis: v=2.4 cv=F+7C5ahN c=1 sm=1 tr=0 ts=6aade659 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8 a=24aaq1eNYdOIN5PvXmkA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_07,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 phishscore=0 clxscore=1015 malwarescore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609190018

ibmvfc_nvme_fcp_io() submits NVMe FCP requests without setting evt->tgt
on the allocated event. ibmvfc_init_event() does not initialize this
field, so it retains whatever value was left in the pool-allocated event
structure.

When an FCP request times out the NVMe-FC transport calls
ibmvfc_nvme_fcp_abort(), which in turn calls ibmvfc_init_fcp_abort() to
build the cancel MAD. That function derives the target pointer from
abt_evt->tgt:

  struct ibmvfc_target *tgt = abt_evt->tgt;
  ...
  tmf->target_wwpn = cpu_to_be64(tgt->wwpn);
  tmf->assoc_id    = cpu_to_be64(tgt->assoc_id);

Because abt_evt->tgt was never initialized this is a guaranteed NULL or
stale-pointer dereference on the first NVMe I/O timeout, resulting in a
kernel panic.

Fix this by assigning evt->tgt = rport->private immediately after
ibmvfc_init_event(), consistent with how ibmvfc_nvme_ls_req() already
sets evt->tgt for LS requests. This also has the benefit of making the
associated remote port target visible on in-flight FCP events, which is
useful for live debugging (e.g. reading tgt->wwpn from a hung command
in a crash/kdump context).

Fixes: 4e70b8795ee3 ("scsi: ibmvfc: implement nvme-fc FCP abort callback")
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-nvme.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
index 9ac2671a3567..9ed6522c2e9e 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
@@ -359,6 +359,7 @@ static int ibmvfc_nvme_fcp_io(struct nvme_fc_local_port *lport,
 	ibmvfc_dbg(vhost, "vfc-nvme-mq-%d\n", evt->hwq);
 
 	ibmvfc_init_event(evt, ibmvfc_nvme_done, IBMVFC_CMD_FORMAT);
+	evt->tgt = rport->private;
 	evt->fcp_req = fcp_req;
 	fcp_req->private = evt;
 
-- 
2.55.0

