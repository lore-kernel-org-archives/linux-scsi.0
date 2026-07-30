Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BCDB5464C
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 22:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451714; cv=none; b=ofUJcSZ7yyGFxB4OVt5ABtCajaShK+2MydDwYMUTWvAnhC+sxJ924gNFBIvjYK2lBAQyuDYgsKeqipXtOKNwdC+foU3UXTZGELW6+iVxLDGDgrqDfZX5LGGOkcAqqgCEvh7dn26zfInmbmgXrBkqGFdTvaCT0VMlfJQ80+7ZiW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451714; c=relaxed/simple;
	bh=342vbo+jSWIuvus37ymB6JWKPsI1lGe4DPDO3gcGr4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gyzmc7UEbt6JDL6uZvMly7jd/PAu8Jaje+/st1EM5ltbsXvNZsOg4BwCB+6M113dpa1N5+B8cPnJSiEFsH261oAFw4Mft96wsfy4zWWSxyE6IH9q6/AW4sXx/zJhYT809ptyl3MyA7wxICsQ7qVyhNeA2hbimbg7rnDrSutWHW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=2Mu/7nzu; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="2Mu/7nzu"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hB49r6sVgz1XM6Jm;
	Thu, 30 Jul 2026 22:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785451709; x=1788043710; bh=03fq5
	As8Qpku8FY12z+wW/QDg5KsqYGNC+LpLlFZhEE=; b=2Mu/7nzukck3HBmdTtjEd
	5ZNCkygcf5jFd4aGQhjTrqN1vbc14NikjMONnux/qeecNXVg0vztZwL+CEot2nRp
	orXwGx5UBTx0rmI8X/uB7vyM/ORSzuLxgWwmdxKZcsgp6dGye8AWVNtNnPB/Kosl
	WTrqt2uVFW7TXJ/medIt/B+xOt3v40B3GMNffBn1YhqDdc9qI1eiNMa8wBv7pDdt
	bC1YRtF9/VRWwRK4/F31H33FsnoVQ63hTZUKtEFJ/UKrJCyOwKULS8R8WvCBzqHO
	1NclOVvYCJdSXbsCYYOLMUbeybZViuxLVbECsol1TQe9wm0UJfFpGIg4tvENvy/c
	g==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ciUfIUQ9qA9w; Thu, 30 Jul 2026 22:48:29 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hB49m171Fz1XM4TB;
	Thu, 30 Jul 2026 22:48:27 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <kees@kernel.org>
Subject: [PATCH v3 36/57] scsi: libsas: Prepare for enabling lock context analysis
Date: Thu, 30 Jul 2026 15:45:19 -0700
Message-ID: <6be350770193c35ae122f164d54086eb37cd4b50.1785451174.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
In-Reply-To: <cover.1785451174.git.bvanassche@acm.org>
References: <cover.1785451174.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Since Clang requires that lock context annotations only refer to
variables that are visible, modify a __must_hold() annotation.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/libsas/sas_ata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.=
c
index 61368e55bf86..2340790c9f6b 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -153,7 +153,7 @@ static void sas_ata_task_done(struct sas_task *task)
 }
=20
 static unsigned int sas_ata_qc_issue(struct ata_queued_cmd *qc)
-	__must_hold(ap->lock)
+	__must_hold(qc->ap->lock)
 {
 	struct sas_task *task;
 	struct scatterlist *sg;
