Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03F13B7B76
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 22:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451728; cv=none; b=l8kQGuy9GgYW05DPcqpvi8UZwP0WMtlItvR5deMZyrkqNQBMJ5snNW+q79ehi99mYhgf7pUQQTAW+oo43o+OhQTLG7qICFX/9nXZxdD9OPFGqIC5tjjNjLqbetAgno3dPnojAYw5yYSRlajpLdGAiqzF4Ggq/PwnTCD/DW+Eaow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451728; c=relaxed/simple;
	bh=Js2hHP5yjftrVDnXotiRryJGKmhiMAyy4S7KEls5pvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=szqtg13PeFXlLvNWMY9dSDbnCByCKayksfgew9K4JLVSPXBnUAHNX+l6/5Ft87xIwLDVH31Cwdit1yCZI5epm9PRMFy5tPz6fa74Z7x+LxMKO8sNVzWZouV7FH2ozGDfqgUz0BThQwCsE6MAX5fpd5S8xOoqqebzZRvflYbgJAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=kh5bX2mH; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="kh5bX2mH"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hB4B732PCz1XM6Jk;
	Thu, 30 Jul 2026 22:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785451723; x=1788043724; bh=AN4sN
	jZ3SZFM0Iubrh4KE8ooAJscwAkC2AOQFYh6LR8=; b=kh5bX2mHUp1HwYE2tOhWq
	eDGVSpI0LLILsU8xV+p1mfZ+Z+VC+XaIkvQEHP4BXfG4XKRuMDO4doxgGYz+2/OC
	aSWzlYYOWGY40RaePvj0xn0bZceUskZE3KxGChvg3QKqcVl6DwJqcPJzQC81plAc
	I5hhGOkNQGK1MNQzaEpaoM4wJ712KWsUPCMHYa/lcOXNmpwJR/d5XIecYOftvmVD
	RNGRkAcv/98gsV+PYZrOw94DIDh9W/NJqH3SlX7lT3bOELyjzzZjmec3J8IGHNb4
	bkR8PIalk1f7UIcUL8tv3liSy6zet6CRI75zV9SF3recK/wEP5KSTq+nM+uJnQiV
	w==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id PIUP_LC5FcR4; Thu, 30 Jul 2026 22:48:43 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hB4B14X7dz1XM30k;
	Thu, 30 Jul 2026 22:48:41 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 41/57] scsi: mpt3sas: Enable lock context analysis
Date: Thu, 30 Jul 2026 15:45:24 -0700
Message-ID: <347f00c05651b9137b01d5541f03c8a0e71a2192.1785451174.git.bvanassche@acm.org>
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

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/mpt3sas/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/mpt3sas/Makefile b/drivers/scsi/mpt3sas/Makefil=
e
index 18e2d87eb4a2..c698a106f3e3 100644
--- a/drivers/scsi/mpt3sas/Makefile
+++ b/drivers/scsi/mpt3sas/Makefile
@@ -1,5 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 # mpt3sas makefile
+
+CONTEXT_ANALYSIS :=3D y
+
 obj-$(CONFIG_SCSI_MPT3SAS) +=3D mpt3sas.o
 mpt3sas-y +=3D  mpt3sas_base.o     \
 		mpt3sas_config.o \
