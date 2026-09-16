Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E086C521228;
	Wed, 16 Sep 2026 23:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789600195; cv=none; b=H0jRNGdlzqN/ihVP5rS1Ugwv9epfPth3Ari1hHK7LYzNvl9wlam57SypMKI1+u6r0UAViUsmoMHc3NhxnYxY+pGm6YNN14PHO16yRRiSus+hfSWVrxPbkEFfamG/4sn1CX6j11x7PYnwSIecox3f+lo94Qe8UXV4zU47hukKyAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789600195; c=relaxed/simple;
	bh=yzljTAN/xFVSW/xr1JEq/dyZNh+qNkWtPWqweFKR2WU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CYSUjgo71kVUcGnHvwj22SxkMZdyhGsGTv4cs+1zIypG3KLSMJHxGNF7lFlE5DXuvC+R6VVK5eb/6s+bSHezGC4+rjYmmSIIYd0/nECFI8+0dATYJ8v+HmgTpoL4XxtUhea2pwCq4niJDmOBk6kY0fPZtkUI1+QKLYK8hNedxR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Dl0z1F2m; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Dl0z1F2m"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68GG1m87018184;
	Wed, 16 Sep 2026 23:09:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=cRBHCOWvtFPK+YojD
	/uI/RizSP1RwudTAkTqAH3Fv9A=; b=Dl0z1F2mj6XRITVPEylqh9ZkmIaPoZ4nW
	gM7XynmcEiw2IuUqq9c77fFaR92EQ0JdJ8zrCnizYzGxDzC+PK/cTKYYooseGaV5
	rul+mcszfQorEHaOKLEnQXsrIm4hpcM0ovS2T4fD+xBlUt0nuTl1a48IVDPGXNXU
	X0Mk3Ehk9/wiFDH1y1wFXnwpGAAlx4dCR62TGXwjVWicLSj4fNzxHajguSaRc7mM
	Apo/W1LhgInCaqpo2ppZ674/jz0HQn5cZ7vnsQmaMf/6GzhJhO8Xt3omd9KQ1Jt6
	R23hcO1VcL9nOf4Ns6PpbGKdpNNfANfRgAei8NwwWK/6CImRw9FRA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmxf57dxe-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 16 Sep 2026 23:09:47 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68GMrtMO2599742;
	Wed, 16 Sep 2026 23:09:46 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gpw6d9e9e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Sep 2026 23:09:46 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68GN9jHP64160104
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 23:09:45 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 27E4958054;
	Wed, 16 Sep 2026 23:09:45 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 382B45804E;
	Wed, 16 Sep 2026 23:09:44 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.141.190])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 16 Sep 2026 23:09:44 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 16/20] scsi: ibmvfc: fix NVMe local port leak on fabric link bounce
Date: Wed, 16 Sep 2026 16:09:17 -0700
Message-ID: <20260916230921.2204729-17-tyreld@linux.ibm.com>
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
X-Proofpoint-GUID: Tuw5Gh1vDz90qGZ98JXTbsctV1CxhRTT
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDMyMiBTYWx0ZWRfX/OIQP1zi8+ge
 Qww3X2p7qrzIF261oAKtoyI5iyqza/YwUkmKHqxDjYpDZCzGrr9F8qm+keXOSrxxKYT8BMje35g
 ktl+9zeqZbdJy692WrPNUjnOe0jJvik=
X-Authority-Analysis: v=2.4 cv=cvgOAF4i c=1 sm=1 tr=0 ts=6aab21bb cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8 a=uX4RykLYdoWrl-1yWP0A:9
X-Proofpoint-ORIG-GUID: Tuw5Gh1vDz90qGZ98JXTbsctV1CxhRTT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDMyMiBTYWx0ZWRfX73yP1fnpyaJF
 wKmL0VDI4bLcBb8EFHl/UacHGlwMoSTpjRsTAgiWRmXknLHEJKXaz0888AxHaVLRWZsmV9r+ZG2
 lWuke0OkvUhHCMznLHDm1UF46uIMaHrALDmhMhDJ3nt/oKGHzpK5a+eQYdtl8T9xd6UJ5+ZFaMl
 tbf4IotaoXi60oa/5k+U12uOnDNv1au36Xn3pFSlhtJQtvSABArzHWQhLOwvPIPKGstKyiCqeC7
 rwptYWq0zonP0Bv+2WM6U6bBWoawtyolv+51kIgEa3xst1RMapyVn2UtppsZ5fLLcvNNdJv5/OR
 QcZkm/NycQsJ9zsPP2SPBzEoFATCf8/dN7nfvntgJgIzKpd4OuIYw46E8BJRuoc8S52qjhgILqM
 0HErLdgfwstKloDf9pAVRjuXbwidHqB0CHXJSb2+Vg7x86Iu0DoUDavDlAC8hxQwCib5NFw1G9s
 G4z/uPBzRX2sSShgJow==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-16_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 clxscore=1015 priorityscore=1501
 suspectscore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609160322

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
index 7e18b79ae4cc..a757a3d4fe27 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
@@ -530,6 +530,10 @@ int ibmvfc_nvme_register(struct ibmvfc_host *vhost)
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

