Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6224D3A782B
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790361094; cv=none; b=Gcmw2jTlXa3eRQvHujmi4IWPpX82XaRhDvfGFau3ilo/JjXGgrV1t1iITWufLGIsJxUBW+/mxjVDgtz7kBZBg0lNkc2BIBOsdCBSkXGnTC0/F0/g2DpGeMZ7KrynnfDZRYOudjvuUoF1sm/UHS+BsFQq9OX1G/cS9QCN2GMXzks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790361094; c=relaxed/simple;
	bh=2Ajq4twRtu3Ah13A0nWzEPgLRrpUWHI7qaECBIp/A3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iZJRbfbKO8HJuZ+ci60dS7/DSBnVgPpyQfq9boSmAXTGHEZwbPjDRkvkDRxte+kAHAZNvEM357T9lPUGg92sTDBsHdW4vz+QkuJS4vlk20xXU01a7EWOP2WFU/6AtAnBtpZuHoTR0BQ+/MdMPtLcG9vm62D+0JmFa680YUgo29M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=d347A9Ny; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="d347A9Ny"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrzn111bcz1XM4Sx;
	Fri, 25 Sep 2026 18:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790361089; x=1792953090; bh=WKZHK
	syXqZpF9Q11eqqjVxVQP2/TLsdX2OXqUARK6Ws=; b=d347A9NyUyUqrM/rdWqxu
	UZbRAuRP9ygJcYXVoGiPk/KBLoME6zMthb9mLY6DaL8HMs7TIh5FcWGLn3b4//k/
	QQ0UiaRX8tpItQCGatNU9CT8ZxWp7Qs16Z4Ag7nobkJ7oM+tB98eZF6Cjev0u0Tg
	fDlGctIhZrUdIBaOAdzCU5iO0P+qn6dkMKb+gCM59lgi0clWplyKdcOTDPsW03gT
	GhsaZnLDkl64eVt/4U7x5xPUq16V/Al7h9M0JwPqu7Xe127rm+uTiyoqXm1sLbZb
	X6SOGToc03W7iqYKfe9FNDwagBLyCg8AY4To1JDJSoXmHR3+wVi1gGJKuSnsIaNp
	A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id OPr4-vL5z10a; Fri, 25 Sep 2026 18:31:29 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrzmq5nJYz1XM30g;
	Fri, 25 Sep 2026 18:31:22 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Don Brace <don.brace@microchip.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH v4 28/54] scsi: hpsa: Prepare for enabling lock context analysis
Date: Fri, 25 Sep 2026 11:26:06 -0700
Message-ID: <4e3a71e82eb2deac956ac51f9019c410037526b4.1790360262.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
In-Reply-To: <cover.1790360262.git.bvanassche@acm.org>
References: <cover.1790360262.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

mutex_lock_interruptible() returns a negative value upon failure or zero
upon success. Since the Clang thread-safety analyzer only supports =3D=3D=
 0
and !=3D 0 tests for functions that perform conditional locking, change
the =3D=3D -EINTR test into !=3D 0. This change does not modify the behav=
ior
of hpsa_do_reset().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/hpsa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 795e8c7592af..2e11f0f5e8d3 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3166,7 +3166,7 @@ static int hpsa_do_reset(struct ctlr_info *h, struc=
t hpsa_scsi_dev_t *dev,
 	int rc =3D 0;
=20
 	/* We can really only handle one reset at a time */
-	if (mutex_lock_interruptible(&h->reset_mutex) =3D=3D -EINTR) {
+	if (mutex_lock_interruptible(&h->reset_mutex)) {
 		dev_warn(&h->pdev->dev, "concurrent reset wait interrupted.\n");
 		return -EINTR;
 	}
