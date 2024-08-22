Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99A71D0DF7
	for <linux-scsi@vger.kernel.org>; Thu, 22 Aug 2024 20:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724356827; cv=none; b=HZVwDwddJ3Jvqbz7mskUFOM/JZnHe4lWH/P/e2QFAGHF1OtM9/C3LR+8iOmtZDD88PIyNzXv/b79UzePSyRjV1x8Y0V2AHdVOoGQnlIiwSnFRDRwr/YeJWZRV9YfA+yjW5VvFP/fpYIKWs5MccaAmJxoCjODpEAmbVkiT4ofBR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724356827; c=relaxed/simple;
	bh=7nGf1avZ8XzYh4Jo/5xXziYrWN4ZpJANrQpBr0PjxYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eh93goo5XMRUx7397DZt0SwPF5hrVrmCt9drGQ3VAb3qi4RKjV+/sxFq9dcPCft7Ru7pHUecnPyGg5jZZ0Q+yq8blgdL/TJADB2/MP8tpH2mEpMUDLPedNFEr5WE2cC8mgkGWJ8FaqbOURgrOXd0RZsKQ9uzSO+aBBeleDvF1zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=G2e7nfqG; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="G2e7nfqG"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WqYw80ZDXz6ClY9N;
	Thu, 22 Aug 2024 20:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1724356821; x=1726948822; bh=FvyvV
	epn9Ef318j/BW4eY2hkqG5sJ6CUqIzNn60Mg04=; b=G2e7nfqGdeMUgjP+oRjQd
	M86yAjHD+Ag3zVeaet/ny2/Ye3fLQxVznzF9a4JAEp4FBDb7VJQW/QeRwTvqG9Oa
	BcLglpoVb6CN0RV82K8IIpI3PTxhp2e2skQwAcmET7Dfy/dfA+fdjwdg8v5+n0eL
	eM2BbrTPSG5yF21hB/kAUSiwUCiAElGhXBZrE4I8/PwT8+kRc9gNBN3GBBKWDbUI
	stqeG7nZJTJ+5ilomyKKGGYpw5bS5So70EUdPGM46PWpBpjHlXH8BE2tZL429XOa
	7wit3dD8CUqOb6jW1zFJyRB9L+uv1WP0tlMiajGDbdfxwSBdYZeBcOy1ZlIsRzPl
	g==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id iS9m3i3WyYoG; Thu, 22 Aug 2024 20:00:21 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WqYw44G6Mz6ClY9S;
	Thu, 22 Aug 2024 20:00:20 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 13/18] scsi: qedi: Simplify an alloc_workqueue() invocation
Date: Thu, 22 Aug 2024 12:59:17 -0700
Message-ID: <20240822195944.654691-14-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
In-Reply-To: <20240822195944.654691-1-bvanassche@acm.org>
References: <20240822195944.654691-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Let alloc_workqueue() format the workqueue name instead of calling
snprintf() explicitly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qedi/qedi_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.=
c
index 319c1da549f7..c5aec26019d6 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -2776,9 +2776,9 @@ static int __qedi_probe(struct pci_dev *pdev, int m=
ode)
 			goto free_cid_que;
 		}
=20
-		sprintf(host_buf, "qedi_ofld%d", qedi->shost->host_no);
-		qedi->offload_thread =3D
-			alloc_workqueue("%s", WQ_MEM_RECLAIM, 1, host_buf);
+		qedi->offload_thread =3D alloc_workqueue("qedi_ofld%d",
+						       WQ_MEM_RECLAIM,
+						       1, qedi->shost->host_no);
 		if (!qedi->offload_thread) {
 			QEDI_ERR(&qedi->dbg_ctx,
 				 "Unable to start offload thread!\n");
