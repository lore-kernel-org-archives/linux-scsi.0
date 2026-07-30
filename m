Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5505F3E173B
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 22:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451770; cv=none; b=WUxx6L8JNmXtBt7PeB/6Y7EcNtNDHnamSBNKvSTdI0SYF4m/3J1Eh2PnvWmWVUb4mDT/uL2Vgr029rQDIyBg6LVyQhHZ7+lDlBMI6/AY0RQyQn4RkzOOvIdgI04lVbKUOKNjjNDT8RKZOg2XWqsG4SsrdxqeqRtbyP0XYNgySow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451770; c=relaxed/simple;
	bh=OB+HnxD8bXxEIxw9vh0A+aul7O/XOT0PpPT0l6/58Lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BYXMrdaxqAtUKNz1/rxREEJcwi7EqZChO1xThzwRr0s7gFlHO2HoEVci1+xcRpmM7Ed27NWsxlYmq1geGYojEbjissxl4meuITnhLnMBF0ib0gjYuMn8vLfv70dvg42O2RpxkVaTa6QVAy7AqARec/cEmN6M8YMoLhfdcMn7xL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=PiQMHTSE; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="PiQMHTSE"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hB4Bx0TfYz1XM30k;
	Thu, 30 Jul 2026 22:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785451766; x=1788043767; bh=OB+Hn
	xD8bXxEIxw9vh0A+aul7O/XOT0PpPT0l6/58Lg=; b=PiQMHTSEt0rJDs4kGwPJl
	bvz/XCvUnfaf4NZJ0DnAxDaLHog0oVXF1zvp+VmwqbIT2S64MtH/bQGcxvKZCnCN
	LoO0aqVoSyOQ1Z99RNON5Kou0DNB35ReX3WZ3kQSESyedkkQq78esjV3WXguCt+T
	vHbziRKQOJguuWr2stcghx855lvY4k23XzDHoTMq77zHJ53WT9rpFjhyxYDoutTg
	L5nskL2gwZ1qstBkyFnII6mYhQ2K3DtCXKnAon8giryQtZ4FDqnaupPEr0IAmmbg
	KztRCFf4ELpSTJQlyzUCgw1Lv06wyvhgxZ1J6p89uH17z1spQpcvZGPzQPSSB+Qr
	Q==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id AHbX4F_ZgKB5; Thu, 30 Jul 2026 22:49:26 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hB4Br0TN0z1XM30r;
	Thu, 30 Jul 2026 22:49:23 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Matthew Wilcox <willy@infradead.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 54/57] scsi: sym53c8xx_2: Enable lock context analysis
Date: Thu, 30 Jul 2026 15:45:37 -0700
Message-ID: <8edf4f7f4d8de5bacbcb89ebfd2fdea74a60f7f8.1785451174.git.bvanassche@acm.org>
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
