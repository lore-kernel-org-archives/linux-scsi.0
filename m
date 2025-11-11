Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD413AA19B
	for <linux-scsi@vger.kernel.org>; Tue, 11 Nov 2025 18:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762886910; cv=none; b=oTy5oDNgPt7ih8ie1HkquA/aAerpWy1JpXSKRK9W52V1WQxHC9CB73OpZXFdDNOoclWLAP+rRXhFXF7vaz8sIr44uFjbrDQrxYKLuvVqlVhjxP6Z5d2sq/PAsaZhl7YiC5/ORl4n4WiQ1DlwL4Psk4DEq7IbzASDbzvUSVWDLVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762886910; c=relaxed/simple;
	bh=GUGJ+HiGxwv4qm7lu1iuymNEeNFrSu59YeibNUyvnuU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dGaWaF0MErkfvGBzOfcdUSG3Xg+EtOpgSJdMHZvfHbUcLujzj3YlBTolnm7kbdKpAVT6rULdvdD6fSMiyE0KWxeRZygCzy2xyIQTSU5FqFk7bUH3zJr7RWEe4YvT1e9BaBcqAv2TR3JQdyBAF26Uwdn2gjFiBFdRQ/JdmPQO290=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=FKQNxQ4e; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="FKQNxQ4e"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4d5bC91ZDnzlyt8G;
	Tue, 11 Nov 2025 18:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1762886899; x=1765478900; bh=2GjlgcTIXUCE8UjAPlBqV2JErkQ5NUXZGDb
	tCI7AUxc=; b=FKQNxQ4eCZUbQjPrzUFtKoo/mt08FtLvF3RLs61UGVOYXfCs7kU
	gDFAGI45i61bChZ0yff9wuEB2sv976rF5GUWI82cE6ZoslpYvYOwFtWlXSiNKxBD
	pueu/bysWLimxh+yLEEhGvX31h0Y4Xhb6UHxP3Pdz3zTa2NXwjpKz3Qf2fX0a9ci
	NHx08S05Aqt49SSf84uVKX9EqmgMcYsUmb8NKqoHMq2oGyevA3V+IA1sJQa0qFxS
	2Rx+JpzOrR57SrwTVOx6w8KMsL+yMiIW1QSrkxOcpzoLxFA9brYTFTZzEnM6NZYJ
	u9wEBWVkmWzPjfKsHudHPvoTwFZEnqya9UA==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id jcnpTj2F2LV4; Tue, 11 Nov 2025 18:48:19 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4d5bC048Hlzlyt8q;
	Tue, 11 Nov 2025 18:48:11 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bean Huo <beanhuo@micron.com>,
	Guixin Liu <kanie@linux.alibaba.com>,
	Ziqi Chen <quic_ziqichen@quicinc.com>,
	Arthur Simchaev <arthur.simchaev@sandisk.com>
Subject: [PATCH] ufs: core: Remove an unnecessary NULL pointer check
Date: Tue, 11 Nov 2025 10:47:59 -0800
Message-ID: <20251111184802.125111-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

The !payload check tests the address of a member of a data structure. We
know that the start address of this data structure (job) is not NULL
since the 'job' pointer has already been dereferenced. Hence, the
!payload check is superfluous. Remove this test. This was reported by
the CodeSonar static analyzer.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufs_bsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c
index 252186124669..58b506eac6dc 100644
--- a/drivers/ufs/core/ufs_bsg.c
+++ b/drivers/ufs/core/ufs_bsg.c
@@ -105,7 +105,7 @@ static int ufs_bsg_exec_advanced_rpmb_req(struct ufs_=
hba *hba, struct bsg_job *j
=20
 	if (dir !=3D DMA_NONE) {
 		payload =3D &job->request_payload;
-		if (!payload || !payload->payload_len || !payload->sg_cnt)
+		if (!payload->payload_len || !payload->sg_cnt)
 			return -EINVAL;
=20
 		sg_cnt =3D dma_map_sg(hba->host->dma_dev, payload->sg_list, payload->s=
g_cnt, dir);
