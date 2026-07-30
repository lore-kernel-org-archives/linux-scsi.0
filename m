Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0AD3E3156
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 22:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451716; cv=none; b=R7EwAeCNwc9I87We/MynyYaK82g7SwOwavACORJ5ejIIkUW+wEMVD5iyyHwxB6gzr9Pn3BAwWWgCdL4Frjj82T/e8swl1Ec8McDu5u0LNeDOC6gtF/27ZXH60GtjvlKYEoDG8bsaWtjxm7mfBAoZJ/u7GiuCp64bT5gRg06KETo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451716; c=relaxed/simple;
	bh=hoU1RLin0DNMXMT5udDNLQMX35saEE5M+h2kf04To+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iYUcca07Xma80QgIfuBhpFKrlfEVjOs2Wlul2qokT1MpwIn+MTiWy1TdPB3sBYlcL4n8NQIYXfFTrQB6VaPwWY3wWtkbYyTIi5hEsHuGHTZF1J5r8uWJUz8bX0hstgGGhJnupjxCJToL4cE+y+HxOYXTZLP4VGXnTcn/TrMMjOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=s/X4kpIx; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="s/X4kpIx"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hB49v2PDHz1XM6Jm;
	Thu, 30 Jul 2026 22:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785451713; x=1788043714; bh=ynU3i
	vhsNTS4KIPvKelbycWkUFCLJkNLlLPqgqH7FE0=; b=s/X4kpIxOU0Gjz8KrM2iZ
	9F7z5uklrc8XoE0QrQXzInRUNYPrV7Hv6hlgDNG79RUT3FxQLIpLdhnXh0XMg9eR
	i3t8Z+CjLUinhAgOyye59j0eNDTgTd5x2V7U4LZop4lTm9/6mvBmuDT2bqtm8MTY
	iX+8M8LsjilmZfwvVXnaSWsd+z5WKG4/hkcwdY7nz+CoF2pg7P6c97H/nY1yA7pa
	KKsjcFesKj2wrecc4yTg6Qz1xX6hKa2CWP7GXYY6HSnCXaJxlibBw0noyvz9Svkn
	dBbAaVPFuBi9b6s8QAIDO6LK1eCzdaB46Ln7SHnYpsxcsDfW032b4uje4nLRzWAG
	Q==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 8LklMxzi6bwc; Thu, 30 Jul 2026 22:48:33 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hB49q6JnWz1XM30r;
	Thu, 30 Jul 2026 22:48:31 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 37/57] scsi: libsas: Enable lock context analysis
Date: Thu, 30 Jul 2026 15:45:20 -0700
Message-ID: <b98cb2f5e38bf5c46ee2a38cef410338944ca47c.1785451174.git.bvanassche@acm.org>
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
 drivers/scsi/libsas/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/libsas/Makefile b/drivers/scsi/libsas/Makefile
index 9dc32736cf21..6f6f1336b438 100644
--- a/drivers/scsi/libsas/Makefile
+++ b/drivers/scsi/libsas/Makefile
@@ -6,6 +6,8 @@
 # Copyright (C) 2005 Luben Tuikov <luben_tuikov@adaptec.com>
 #
=20
+CONTEXT_ANALYSIS :=3D y
+
 obj-$(CONFIG_SCSI_SAS_LIBSAS) +=3D libsas.o
 libsas-y +=3D  sas_init.o     \
 		sas_phy.o      \
