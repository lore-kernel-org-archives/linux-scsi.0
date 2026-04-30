Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5906F3537FF
	for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 18:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777573536; cv=none; b=eDxDJ/RpxIQKRo7llKWMiTiKcJjF95mzWzJwlZ667chFDX9o6pRS8/Q5riiaEfKh4UvUzHmIJOz7Zgw24Ui0o5iYqlK+VbIn0RgSAvi+HcR4X47t2JTCgjsWcGqayAmC37zBGTSSB+kccSFN47TZcSVa7Gzh+on7SRdqadRR4+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777573536; c=relaxed/simple;
	bh=LIEZBpvY8uRzc9vJoXAQ4psB8RmGy4jsw1mpu2/kmxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mx7UpsnysBhZBOIGvwFnpLkiKTdirAjh6QR6kfCxB+aQdU2k88hhiyXgdMNQQBx+aJL31U8T2ZVh/5W33VTw2sBkKiFDp1Rq+vlvM80ZrX3kLRPLElzksOD1ySxWPUhbsJmke+6v7on6MMZVC78dngxdSxVotQFXdA5d0Kem41c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=OfSG3CsN; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="OfSG3CsN"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4g62fR0xJRzlfdfN;
	Thu, 30 Apr 2026 18:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1777573531; x=1780165532; bh=LIEZB
	pvY8uRzc9vJoXAQ4psB8RmGy4jsw1mpu2/kmxE=; b=OfSG3CsN4s/sEQpydiqRO
	WiKoG7fsE3FNAW5E84dkdOc3zc5VhL0qgol/E0BPDJG9EIedw5QoL2qkJ6iEkH7u
	6xJK8s7FKDyQ/iWHr+LWKFAker4qZmDhSfb3UGbMWdCT1wGxab1JBeJ4mfH266Ve
	Xq1PSKmvG4egGe9ABrKGqrzj5IAjnmV+3g026GqUt48UfqWeqXDpzlv2xwUhY/vu
	hUnIoLnDKERbmiplXQxTyVFPvOLt/lZWTxur5ql+CG/Yvq4Qh1eiVxnrFmfrcJwD
	H3rFct1OSTbopCMlBrStQzKDEiSpUTvR/v0wrZ02j/ouEF34N+zg6z4hvRCqoAFE
	A==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id OrHTRFTm99eh; Thu, 30 Apr 2026 18:25:31 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4g62fK6PXbzlh1Rp;
	Thu, 30 Apr 2026 18:25:29 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Marco Elver <elver@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	Narsimhulu Musini <nmusini@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 53/56] scsi: snic: Enable lock context analysis
Date: Thu, 30 Apr 2026 11:20:23 -0700
Message-ID: <20260430182130.1978347-54-bvanassche@acm.org>
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

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/snic/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/snic/Makefile b/drivers/scsi/snic/Makefile
index 41546e3cb701..b12563cb174d 100644
--- a/drivers/scsi/snic/Makefile
+++ b/drivers/scsi/snic/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
+
+CONTEXT_ANALYSIS :=3D y
+
 obj-$(CONFIG_SCSI_SNIC) +=3D snic.o
=20
 snic-y :=3D \
