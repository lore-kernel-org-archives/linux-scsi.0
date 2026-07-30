Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D065464C
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 22:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451636; cv=none; b=TmuvX0bYSzOveIdsWQzd9PFOSgZoAKhJkx7RyxlURV162kstdy1kCQRg0872REnVq25Lx31yTGZ4q9A6K5p1NwsJtaKmwnWgfXCyQSMKlWQJgHk4Q9K6K62s2KFV+8K2ArtKZBEUy9gKa6SllzLZBLiaTRiMy0lalwBQyAgHMVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451636; c=relaxed/simple;
	bh=iM8n37gaChXnY6R0qz9AmdgjOGV29aL6mcWE/W4R030=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XMJ3L4XKKUKK7aAKlIEqpt1H30lWgB9l85Ua0dpGr2p/5KX3yplj0u+GE2RvqdHnwK9zT2VJi7I5EaMO+T0IGQqep8kmv3PXm+kmpxl3f5jCZnkIUFezaOrOiWKLj+o+f65Bnqlf9KJBATAQROv6cxcpQzJOeH+hKJPOxi5godw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=OBz2inRb; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="OBz2inRb"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hB48L6mb9z1XM30k;
	Thu, 30 Jul 2026 22:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785451631; x=1788043632; bh=IbAMm
	sJV7UqSrgZRuvJcn4RACkeBQPhXm7nCv/4QU1U=; b=OBz2inRbs5AhUQq0CR4IN
	6aZiN7Tyj+xA9xdTlZU9tyDFL7bORG6YTgWehNlCf+4nM171Rhen1lWAunWHbwdW
	CvhcFLdmQZr+qZHUwzL4+Hg4MRiLbnBPJ1ugLGaQRvwomLCkmRAlVqYSl6KU+U3x
	ClEHQ+8ex3Jq+vgGJZgccdhLpMIx9CsK0r5Z1XnFEw98tP/zjIJ/F1ZnmQ7BfZYD
	oYI5vZb+J9//OTWTITXbp9Asw7Q3/Aoponuvxc28qHJddR1GaLIa79oUMjLSfDY+
	zk/GGqLP/Kj994eZsIXYq7FXd4NOFH6invKca7baaK6MP7yLFCffToiUbg+Nl21e
	w==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id KHA2H67Sikmf; Thu, 30 Jul 2026 22:47:11 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hB48F52yGz1XM4TB;
	Thu, 30 Jul 2026 22:47:09 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Finn Thain <fthain@linux-m68k.org>,
	Michael Schmitz <schmitzmic@gmail.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 07/57] scsi: NCR5380: Prepare for enabling lock context analysis
Date: Thu, 30 Jul 2026 15:44:50 -0700
Message-ID: <56108ada4f0efa8b17b49dca1749043315a2ad1a.1785451174.git.bvanassche@acm.org>
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
