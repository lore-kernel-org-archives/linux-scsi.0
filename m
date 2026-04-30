Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0A139D6DE
	for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 18:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777573332; cv=none; b=m9U0F33d+/S2ozsJvS2qVkE9m9pwT8bbqLJbdQyyBudwQn6mxNCQYuiqqLA0TAu9J5g1ucqoq6P39xR+ihjchyGCwsheXHE+6FBWXRHCGRTdHTXzAqnXE92S+Y5EhY44CkoXJJv5gIeq2QrsGHnMLEOI1F7iotuV8iHHqbEVfuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777573332; c=relaxed/simple;
	bh=iM8n37gaChXnY6R0qz9AmdgjOGV29aL6mcWE/W4R030=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m4PJvxCdGfFjalkOM/ZfeC1F7oJtJYiLfjYsb835TpBfgMxyQ/A85nNfiZmkB9B874gWPY/i47dpeoQ5PIiW0IklSDkjsPm4YTSnRVL7yq+p5zNiEDA5+OYaP28eCljjsaUm5AASZiCLBbZX9d6A7zAjvZhDVkzowx/mVDOlgWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=NPWOWgK3; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="NPWOWgK3"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4g62ZV4nxXzlfdfN;
	Thu, 30 Apr 2026 18:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1777573327; x=1780165328; bh=IbAMm
	sJV7UqSrgZRuvJcn4RACkeBQPhXm7nCv/4QU1U=; b=NPWOWgK3qO874h2WjhdEl
	Cx3dHaX/4l8CplXzUzyqT8LEUc9IABLt54cHYJi1ivfEg9XN9bbFT3cN9B6Yuu/m
	BUFrbEQovGRUYRlo1/zxTWh9xEnIWgx0+ak9wYFGMhliLUtcmVjYQ21y9Uwhn3bF
	7F/UbyvCjuty9b74QyMbSfeYmOSU25FbQPea6jxSLg8DsRzRjd3ZPYn5soBoxy0I
	e8pctVBbqhjLmB5Hrhj6KixEntFsy/xBl9+CFuvHRzwMI9f7PY0ks+ziovwONucE
	RNoKx6VelU4XZbIHE5IiMsPNjWsyTgQe0n8e4jBpmUgErJvpBg0CoyqUE1dT6jnA
	Q==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id KzAIkTGd0_-2; Thu, 30 Apr 2026 18:22:07 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4g62ZP1SWXzlkMYB;
	Thu, 30 Apr 2026 18:22:04 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Marco Elver <elver@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Finn Thain <fthain@linux-m68k.org>,
	Michael Schmitz <schmitzmic@gmail.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 07/56] scsi: NCR5380: Prepare for enabling lock context analysis
Date: Thu, 30 Apr 2026 11:19:37 -0700
Message-ID: <20260430182130.1978347-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
In-Reply-To: <20260430182130.1978347-1-bvanassche@acm.org>
References: <20260430182130.1978347-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Expand 'hostdata' in the lock context annotations because 'hostdata' is
not a function argument.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/NCR5380.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 006dcf981218..029fe6362629 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -961,7 +961,7 @@ static irqreturn_t __maybe_unused NCR5380_intr(int ir=
q, void *dev_id)
  */
=20
 static bool NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd =
*cmd)
-	__releases(&hostdata->lock) __acquires(&hostdata->lock)
+	__must_hold(&((struct NCR5380_hostdata *)shost_priv(instance))->lock)
 {
 	struct NCR5380_hostdata *hostdata =3D shost_priv(instance);
 	unsigned char tmp[3], phase;
@@ -1657,7 +1657,7 @@ static int NCR5380_transfer_dma(struct Scsi_Host *i=
nstance,
  */
=20
 static void NCR5380_information_transfer(struct Scsi_Host *instance)
-	__releases(&hostdata->lock) __acquires(&hostdata->lock)
+	__must_hold(&((struct NCR5380_hostdata *)shost_priv(instance))->lock)
 {
 	struct NCR5380_hostdata *hostdata =3D shost_priv(instance);
 	unsigned char msgout =3D NOP;
