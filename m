Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A873D4129;
	Sat, 19 Sep 2026 01:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789781610; cv=none; b=jiQdYZrYDwtUmC7dkiJffm3udwZZ35V16Tqt0hMvJvrW/gfj5rLW97MUCglE2MZpNdz6hNJXty+hS8kYrFl/0D9r/1nTeQs0hg414V4Er53yoxiMisv4YI0dvoIXiRoT5IKcL3oWV6dhxhB8t0qK8ASOykyjq/YhP71fITLDd/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789781610; c=relaxed/simple;
	bh=I7MPEmdLh5S0FczeQBdUO91A9FPzoJlynBHXiz9a4LE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JEah+iZaBvLjX+oHhQwkBuouRWs+cXPl1+WAfUZjmajkhYdcMD9YB+J7Yc7BoI3pLQ9nDuHXcb1/oj7U4EjAjFVQeOfPMOalkJMMcgRHgdJrw5aREp8JDf6GPjHDHw/48a88SnPvttRSiVNGyQFoRq2jJGk2eq5ESIAmqz9O/Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=knvNFol6; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="knvNFol6"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68J1VjaC1676537;
	Sat, 19 Sep 2026 01:33:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=QpaebJl3tZG/L721S
	cz4SlnmolMwITmlKToP1Y8Cl/g=; b=knvNFol6/GaiM3cfax9p/2wRMmk43yPCj
	m3EKaTDGxkqr4ldcJavikZNp7Egm4k1yvtmuT4t8UkSbPUlt3NM1D2yqQPwrv7rK
	MElgkU39oU+iZeMgm8bt4dD4/Mg4WTJKDaRNtzmNv7VPvGzB/Lj7dA1QLePMXl1I
	0Nm/MK1bxV+pAPvyhVe5LRXAobLrTEqNtSoHxc5qssgooy3QANQRIkgLMNYu8n0e
	MHRIhLrhhtqOUIO+JSUCqx7Pr+n39RcDlQPjTPHTOjGON7Ji7A4OLvZFGTQCtxdk
	EZLUxvZEKwRBKDvWEDnMkp0rDiIveN/HceejrAdoNk1XAQ7+kl9jA==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gsgtd803u-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 19 Sep 2026 01:33:25 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68J1TW5E1630405;
	Sat, 19 Sep 2026 01:33:24 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gsgsar08t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 19 Sep 2026 01:33:24 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68J1XNRj23200284
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 19 Sep 2026 01:33:23 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 10AA058051;
	Sat, 19 Sep 2026 01:33:23 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 687D35805A;
	Sat, 19 Sep 2026 01:33:22 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.101.145])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Sat, 19 Sep 2026 01:33:22 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v2 16/20] scsi: ibmvfc: fix NVMe local port leak on fabric link bounce
Date: Fri, 18 Sep 2026 18:33:02 -0700
Message-ID: <20260919013306.2948028-17-tyreld@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE5MDAxOCBTYWx0ZWRfX2Pp/iwHOqAk3
 AkUcdmDpx/yOblhVjwgCrpkteRWDqTcttPUcGUXv5Rim7F1PebpPb1hBzzXYY0BMULJpjfGfD+m
 FlzKoYCu5bEV9u3rpo/6NT5yWrNenoUrmNWgooYzKcvpItic0VRHrF7OlOc8nOYR5k3YY1wTbPw
 pWmiu877bR+fKqBHPMDes3DRwpIcjNGwaCQA9iDhaYEq3rhYTxSIp7OKLAdlhUQWo/M/peet4SD
 ErOY4q7Acgs+OyRgeYPgT0NjFX5JyJ4XI6tT4kR+MHUSIj3s8r1JyX3e887SQY+dZ50wq3CgcEa
 9KH5Iem4F6kV3Njmkhx38K6Bnf7PDuuEdT6nO54EGKOPtaRWmXV1SloGvdx+TnXYdRvQWaFZ6zm
 jOcc1FCkeidauP1Ij8w/yuDnHt18d3QEdRWcRwt4hobsNLuFi+8DYwnmGN64b/JJJa8vGxK6+qS
 eaEBMFc5a8NTP71nang==
X-Proofpoint-GUID: v8hJccpHPGFD9hQsO_34xyYYFIFtcDLz
X-Proofpoint-ORIG-GUID: v8hJccpHPGFD9hQsO_34xyYYFIFtcDLz
X-Authority-Analysis: v=2.4 cv=Q49HcI2a c=1 sm=1 tr=0 ts=6aade665 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8 a=uX4RykLYdoWrl-1yWP0A:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE5MDAxOCBTYWx0ZWRfXzDapPuHNM4jk
 4GZULHXmzO+Wep7Ha+9ZZFsqvSSiHPxix+XMTYPxVnsNaUfA6hFgFuDAH+UkXk8YBEaJTrrsUTS
 v/fPEoQjgJbKXbg6HuZKMBi6OEJ7FxE=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_07,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 suspectscore=0 spamscore=0 impostorscore=0
 phishscore=0 malwarescore=0 clxscore=1015 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609190018

When the fabric link goes down, ibmvfc_link_down() does not call
ibmvfc_nvme_unregister(), so vhost->nvme_local_port remains set across
the link bounce.  When the adapter re-initializes and completes fabric
login, ibmvfc_nvme_register() is called again unconditionally.
nvme_fc_register_localport() finds the still-live port in the transport's
list (FC_OBJSTATE_ONLINE) and returns -EEXIST, writing NULL into
*portptr.  The original local port is now orphaned in the transport with
no way to reach it, while vhost->nvme_local_port is NULL, leaving NVMe
functionality permanently broken for the lifetime of the adapter.

Fix by unregistering any existing local port at the top of
ibmvfc_nvme_register() before attempting to register a new one.
ibmvfc_nvme_register() is called from ibmvfc_do_work() with host_lock
dropped, so ibmvfc_nvme_unregister()'s wait_for_completion() is safe
there.  This makes ibmvfc_nvme_register() idempotent across link bounces
without requiring changes to the link-down path.

Fixes: 3831863f9f56 ("scsi: ibmvfc: register local nvme fc port after fabric login")
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-nvme.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
index 475177cda103..89ad7680beb4 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
@@ -537,6 +537,10 @@ int ibmvfc_nvme_register(struct ibmvfc_host *vhost)
 	if (!IS_ENABLED(CONFIG_NVME_FC))
 		return 0;
 
+	/* Unregister any stale local port left from a previous link-up */
+	if (vhost->nvme_local_port)
+		ibmvfc_nvme_unregister(vhost);
+
 	pinfo.node_name = fc_host_node_name(vhost->host);
 	pinfo.port_name = fc_host_port_name(vhost->host);
 	pinfo.port_id = fc_host_port_id(vhost->host);
-- 
2.55.0

