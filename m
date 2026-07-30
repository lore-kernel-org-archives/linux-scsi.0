Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371E25464C
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 22:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451702; cv=none; b=G6uD5fCwwHda/ZZGPMtFiziKffkcr0NBcKju882UQEauZC/T8BStZIUu5WGq3j69O1i05eiVhDHOPvMfABCbMrGlW3yvHo3yeUts0DF83gWEvbOvlwLZj4ACBCyeIo79aTAnjal79qMwz1x/PzUejXb6LVmbqwm66LtaR/7kaiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451702; c=relaxed/simple;
	bh=oxLfLw+1zSl0q5HJ4yTJRyf8Z2BcH2NCBu+r01F6gjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mC7ISS1hcm/11QcCTF+CdaD08O3qkeARUPJrieKbjB1TfR9P1NyMFisvX3d261ALDwU5GzBkl6zfw2rupVt0SfH1Tyy+b9QWrb95e7i3E3uZUv88r5IgPjdnwjqcwEFbeEPgakvyAnqWka87mDcIz2TTmSlVXtX8TAf2bLTZxKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=MYNIK3cy; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="MYNIK3cy"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hB49c6lr7z1XM4TB;
	Thu, 30 Jul 2026 22:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785451698; x=1788043699; bh=pvrYG
	9jYH/10/4mM0pbHYfk6dn0YuY0jW5cvbz+qljI=; b=MYNIK3cy3MOjD78GNspLF
	PBHixQr8KfuewsDYgrzu/LbQkUqnyLKVsy+hmzXNx5OMzW929vD/KDMi8roYOjpX
	lZSqIRsXvDSxjsmbf3nrVK/VVHhTHnYAzFsOONtFbUbW0VH/Y8uMkf4u/r9ohHHE
	HP7Hiz4XRuSqGyssF8i883kshtCb0yxSpkBcFbhpCfa94malLqDm1E/tbZUsjue7
	fHYv1Mfqyseqku33sxzcr/qkRF5WVHNHZza+5jI18iWu65ZNwc0qo8kgOC+IUE1r
	SI4KLdwTY6LokejlU3+EaqfwNRzTM6KB6pmxM+nOa60VXl1if1drRDCIkELE4u4w
	A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id JaU1pVqe6HBD; Thu, 30 Jul 2026 22:48:18 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hB49X4xN4z1XM30r;
	Thu, 30 Jul 2026 22:48:16 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 32/57] scsi: ips: Prepare for enabling lock context analysis
Date: Thu, 30 Jul 2026 15:45:15 -0700
Message-ID: <af0effbc214b28654685796b43f2783236c52c14.1785451174.git.bvanassche@acm.org>
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

Annotate ips_next() with __no_context_analysis because it performs
conditional locking.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ips.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 41ed73966a48..5ef70f058ecd 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -2506,6 +2506,7 @@ ips_hainit(ips_ha_t * ha)
 /***********************************************************************=
*****/
 static void
 ips_next(ips_ha_t * ha, int intr)
+	__context_unsafe(conditional locking)
 {
 	ips_scb_t *scb;
 	struct scsi_cmnd *SC;
