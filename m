Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E202D63E5
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790361116; cv=none; b=YmnYDQIdXvWMptFwduLReBuIQ8O+VvWk020dDtnfMgIXkUhnVgMqDnmoqJSOw4wyAz2zdD7we7kPm+t2rybXxTAP5Szrk7r3IaOYzXMAumduylybWgDeTloTJIqg87uQ5x7U/hZZu2uk5dzwr1EX7wUiptCPfuPxFt0KQ7KdALA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790361116; c=relaxed/simple;
	bh=CRvx+ItOcFP6LmsKOFabth3WFn7zhbfNKNofd0lRfOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UZsf8GrwCFFVqXPJiB0cFFq0O/unYdgmguSgRYnFMJkOrAYHxtHK8LZyhBXQJtFFdfxqYtHIdbY8jDFHBkD3NmI73iGLLWNmfOfeKfPD4N/p4zrx+xAGDCMxfQxoM2oq2xPaqJZrUmZYWVwK8Q/3HsAQ4BLKOgHHb15foEFq2Co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=OqWaFUTR; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="OqWaFUTR"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrznQ6WZ5z1XM5kt;
	Fri, 25 Sep 2026 18:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790361111; x=1792953112; bh=o340g
	BCdCsmaSWxHExqx0swu61/kjuuQKNXuHDSKsXA=; b=OqWaFUTRnQyEXJvGe4k+n
	jvqGpyZRaJGNLQicDV9fU+U+vqdqkeOJPNUuwyH+3m6p3BrcDFxSYtJ0jPQyBo82
	EQ2RfUeTRXZaEGsNCgzIibUkPqCqFCpHjMfaXumUcHY0jmzenY3+sB2LZKjZ9Aws
	pZl2GNH2GPCMDs3vxA7bEXKTwqXR+U8s560HkBMrvJ59At2ALG3BvtykBa0z8xAb
	NCO5DgkpEtE+d40hSfOaOqpAfbzg81dHy+GhsVu0qIALYHDQZnG70W0UuIY6JdHs
	yG6o+NOicyK0HbbBMDHZSJ935FOgPyx+qAXHgkNT5J94ePOOmq+45L/0vfWkVl1O
	A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Pb73n7_u1lzW; Fri, 25 Sep 2026 18:31:51 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrznK6H3Hz1XM5kW;
	Fri, 25 Sep 2026 18:31:49 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH v4 34/54] scsi: ips: Prepare for enabling lock context analysis
Date: Fri, 25 Sep 2026 11:26:12 -0700
Message-ID: <f55b7075d5703ab7d95c1f063e2f78377a7250a8.1790360262.git.bvanassche@acm.org>
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

Annotate ips_next() with __context_unsafe() because it performs condition=
al
locking.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ips.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 45c5b9acb664..c7d6c5aae340 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -2506,6 +2506,7 @@ ips_hainit(ips_ha_t * ha)
 /***********************************************************************=
*****/
 static void
 ips_next(ips_ha_t * ha, int intr)
+	__context_unsafe(/*conditional locking*/)
 {
 	ips_scb_t *scb;
 	struct scsi_cmnd *SC;
