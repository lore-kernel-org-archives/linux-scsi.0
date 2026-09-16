Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F6B4BF92A;
	Wed, 16 Sep 2026 23:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789600179; cv=none; b=LDqARdQLp9lSfjCVwhrdMBZYepL/hFuCMMHn7dnftkNkr+YjZwQhnFm01eoU9hrc9t2t+OC6jBgGRIHxhjpkv8taJPO22nIPvbdr0BzETEFmcEplnZ8yGaMUqHzIdKoIJE61j8z3PF33Pe8zBHPE68nyN8t8+0eWlp7MQpy8a7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789600179; c=relaxed/simple;
	bh=zgxjKpn1kyNMIBVwaF12Kde+LXaxrhu50R6RDuOyIJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nMOcrzkT98To5T4sDpY3LvUj+EMf4W2G7J0RG0y37TxpgMF3nwxCpO6AB7bXCoioRu2tLsaFROP9DdApupS3ch771006Sr2Gro6e7/766DcSUxZPAoCG53A8j7Pbp0yFMsFujdnCfko+DdT0yprPIo3H/xGvDncEFb1SS9TBhYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=OFhRkpOB; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="OFhRkpOB"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68GG1m86018184;
	Wed, 16 Sep 2026 23:09:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=ClrGPMR2eCl1PGakK
	33NKTydd8/M9xCYys0xvOiUDi8=; b=OFhRkpOBPfgJsJbxJWy67Aa92Frhw3uoE
	uXr0HoA6qMxsbLYBgcBSM+ekV2Qi2cJ5ZdzW9/sllmR1SvWdJBC3Lv8Awx9D5EI/
	C/MuUaEpcz+aMiDQVsq/lGfCC1JRtKhPJyEQjrMXy93SRVuveNwjM7MICILlzbz8
	biauDN9Wv7upWw4tYGwbwZF2Er140GzsapyHwobFc74IG21X3XOyMm9wQedIAc1V
	dA7i550bEvWNG8D13pWMIz6JsIcp+Rz9mJ+djguBNZV4EV8OY195ko+/rDolbX3M
	CXWnUKsF7440pwEz0k9MW0DXSBKArI+4Gn18Tn+mCflt8VzQUXg0Q==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmxf57dwv-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 16 Sep 2026 23:09:30 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68GMxnNW1649291;
	Wed, 16 Sep 2026 23:09:29 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gq03c0une-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Sep 2026 23:09:29 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68GN9SGU59965792
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 23:09:28 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5DCC45804E;
	Wed, 16 Sep 2026 23:09:28 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 696E158056;
	Wed, 16 Sep 2026 23:09:27 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.141.190])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 16 Sep 2026 23:09:27 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 01/20] scsi: ibmvfc: initialize evt->tgt for NVMe FCP commands
Date: Wed, 16 Sep 2026 16:09:02 -0700
Message-ID: <20260916230921.2204729-2-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916230921.2204729-1-tyreld@linux.ibm.com>
References: <20260916230921.2204729-1-tyreld@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _P-5uaKXzyGQGrPy7hqE-hW_xa2qQV9f
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDMyMiBTYWx0ZWRfX9pBpqj6SOcAd
 qFjI1h8NCr/IMSJzeZ/pjvbuQkVhdO5frGSOKRC1J6X2xPDWnH5+560eSfTV72+BvTIfNy5OHO+
 xN+Q31bbfIBa0f5P9gFCxgdnyUwwVFk=
X-Authority-Analysis: v=2.4 cv=cvgOAF4i c=1 sm=1 tr=0 ts=6aab21aa cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8 a=24aaq1eNYdOIN5PvXmkA:9
X-Proofpoint-ORIG-GUID: _P-5uaKXzyGQGrPy7hqE-hW_xa2qQV9f
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDMyMiBTYWx0ZWRfX/cGUYNrN42bH
 t67rMcVJL/uWbsR6A0IB73P5sJYqz/Iv9jmj2DlhoicinHg7YqLKGvEZC+ASOkR6uhhOFkrMJD3
 uX4wUbXpXLqzPd7DkoVm22IfyLelrHGgzXgQp7uOW7omCbNS1BIYF9Dvc350Y/ecyAXs8W2OAa0
 u3BPYQRNx3dDbac0ZbKI6KF6iit7wHbcYY6owqFrAim5Uc2eldRHV/K4nCm1hmRa6wrqtfrSST7
 3bRevoYv4tkW6zpItJhllzO+0cgBzJib9p0tZKVO6GL5sZUj6fb5dAEsXbs0VVJzsIumE/nQjpK
 uCUcua2VgXqktIMe0X4RvJGXMp5iML4Zd4ki3ifO/R14Wx6N/TRWOuya1/fVDo7V8GpIRt66IJ9
 M4DZ/AnfQSMxVjrCElRyPIlmyrCwLauvNXGE3TVEPJ96OorHvIvM3rp1gvHr35Ur9o7IyNBUpcf
 /ZWtp14olIVLKuEOWWw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-16_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 clxscore=1015 priorityscore=1501
 suspectscore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609160322

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

