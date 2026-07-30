Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34DC55464C
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 22:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451659; cv=none; b=dQf1VvTMBOUdY31BJKVZXrCRyleaPAHf1eImxgORNyJLDJrIhtdAnxxA65+vxF/fiYT6QtdBMm9+h/EHM65aZvKNLheAGydq5sT6Or/l6FX0j551Y5QbYTQTDVRFVOyB4E8U0aovp+vCx5UsoM6RCpBhlAeziiEDcafEqJigk2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451659; c=relaxed/simple;
	bh=ulaH0sjY527GhmuqwS/UKr75UbYd1YaFmBdUmUsZZJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SuqaPpZYEJ+Lcd8psxVyymTlpAYSW4EMkroIJKJHs2DwDIHxFn691CmL5JOgXNcYXyCRhBtAcJAfw9gcXxz8oj0GhaXd2nWQKZ/D9cF634GY1nfPMjVqXH3inr2s5Og60za67XHsWNRokdDue0wYkwnyTcAJ06T1w/NBwIeX6JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=c0FzC3XO; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="c0FzC3XO"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hB48n5Dyhz1XM30k;
	Thu, 30 Jul 2026 22:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785451655; x=1788043656; bh=atTcM
	VdPwDlERu1BqJx+BaA1RNeieDATxylIhLZqnUY=; b=c0FzC3XOvWHOuRSUn2u2n
	eMrSpxRpyFZG8ZbVRABRhisYdLv2B1vRfvAK/j3hW9gNhG30K39YM8fARk0QK9LC
	E6jeHjwXpuUgwfskdD/yjfgMFYmGzn0aW4cMtKp4GkVHC7hPJP1LfjevVpazEom8
	M6ITnOMQh2zFjREHK3Nk7eDbX1kSisJM2fvkzs1YXaAfkfY05wQoI/lkAdr4yjV6
	2H12oQ6U+XhSdJqWVVd7uvxzDDAqIgcY/Y9jQJR+elbGjFOvha9Vb6BNtW52DLn8
	6ddf5rJag+oufpkBQTyYNvhkNJRMml+ZSTr2W9kiyebJt014B2ptLeIOpLwzRmt8
	A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id D3b8rDRd3TMd; Thu, 30 Jul 2026 22:47:35 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hB48j5yWgz1XM30r;
	Thu, 30 Jul 2026 22:47:33 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 17/57] scsi: cxgbi: Enable lock context analysis
Date: Thu, 30 Jul 2026 15:45:00 -0700
Message-ID: <884cf21024a707d65c02c74b8fe76211b5615f7c.1785451174.git.bvanassche@acm.org>
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
 drivers/scsi/cxgbi/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/cxgbi/Makefile b/drivers/scsi/cxgbi/Makefile
index abfd38a26fec..c614afa18a33 100644
--- a/drivers/scsi/cxgbi/Makefile
+++ b/drivers/scsi/cxgbi/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
+
+CONTEXT_ANALYSIS :=3D y
+
 ccflags-y +=3D -I $(srctree)/drivers/net/ethernet/chelsio/libcxgb
=20
 obj-$(CONFIG_SCSI_CXGB3_ISCSI)	+=3D libcxgbi.o cxgb3i/
