Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 586A8395AF0
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790361196; cv=none; b=NAC0BvF4PcnoP7ahc0KWl+Jn0mAqNj0dDO2LESQULwDyCQQOoK93f3m3A34lFPG41yph4zTiXIC46Q7ZmpLFaH3sGmgJL7pcG1tYBkb/jo9d5Opgp3/wYhcUR93aN/cfAeWNS4p0tLypYYjVXp80weXFm0Nm/C5qygODEeRww60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790361196; c=relaxed/simple;
	bh=OB+HnxD8bXxEIxw9vh0A+aul7O/XOT0PpPT0l6/58Lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cT4PdnvTi+eLZVVMQSIRpF/hBnPrHu53EOoI3sWd6rwUQjJF1ElZP+tlF2s9VaTCCo6TnbA2KCthkYWYiTMgldrVYWNZAFggo0jB8m8yA82/UHpQaFCC8lUoNrnlkf5c7pKhfwuYB/mXNwhp1aC9X9iddBSSR/ey9a+jXYEUeJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=1mmOWDsL; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="1mmOWDsL"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrzpz0m9fz1XM4Sx;
	Fri, 25 Sep 2026 18:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790361192; x=1792953193; bh=OB+Hn
	xD8bXxEIxw9vh0A+aul7O/XOT0PpPT0l6/58Lg=; b=1mmOWDsL9towtxAmT5vjQ
	v6yhiR7BWjjmtj87WNkWv6sbTjF0DX2c+FGwurlLAw4ennoxIHr8bqPWdHnB+zl5
	uPh588ME4pTblY+TMxkko75EvjKI6UpQydDyhZ6CaUC/BPjl5948Fu/+m/uPJxUI
	6M2Ig2IKG1kV0C9KJ4h+xDigrMxnLR+qp7TgvB+PEnbxD8L500Iy8FAU2ZPF7Fbs
	WnH4UDa82vmX9D6NSl0syWwRe+L3/6ozRFg5SK3aeqqauz7NOwvg1ILgqrrWqMiv
	9IVHQyHX2ywn8soBW7koYJwTXYd0f8sR21W73S8YjWFqJumXlEi+dBLozOJaNbg7
	A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id QT54Hk4Gh1Io; Fri, 25 Sep 2026 18:33:12 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrzpt2s9Kz1XM4Tl;
	Fri, 25 Sep 2026 18:33:10 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Matthew Wilcox <willy@infradead.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH v4 53/54] scsi: sym53c8xx_2: Enable lock context analysis
Date: Fri, 25 Sep 2026 11:26:31 -0700
Message-ID: <385ccf5f15b469a4909249e60ae7332b733e943d.1790360262.git.bvanassche@acm.org>
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

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sym53c8xx_2/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/sym53c8xx_2/Makefile b/drivers/scsi/sym53c8xx_2=
/Makefile
index 0751e2a0cd82..c28fb2b65622 100644
--- a/drivers/scsi/sym53c8xx_2/Makefile
+++ b/drivers/scsi/sym53c8xx_2/Makefile
@@ -1,5 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 # Makefile for the NCR/SYMBIOS/LSI 53C8XX PCI SCSI controllers driver.
=20
+CONTEXT_ANALYSIS :=3D y
+
 sym53c8xx-objs :=3D sym_fw.o sym_glue.o sym_hipd.o sym_malloc.o sym_nvra=
m.o
 obj-$(CONFIG_SCSI_SYM53C8XX_2) :=3D sym53c8xx.o
