Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25DBE3672A8
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790361138; cv=none; b=VbDvUXqumegZhbM8+5KhfQ9nPrBp7+WafsKVhZGwlWb26vHbmXk354xWXG2cBnzuaaaNVuaL8rPD9rGl2HjDVhjoUF7sC6k2baRpk6m61ZgKkcwZsAGE7kQ0rQ+HA3e0oDMMcFrb2jEVM8Z+RSN+Ko1bkyWsdn2ztqdlmSEyJcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790361138; c=relaxed/simple;
	bh=hoU1RLin0DNMXMT5udDNLQMX35saEE5M+h2kf04To+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FZE3iWMXqd3Egj3Y3Joy+zN/Epl8yxWW1QQZa69i8znmDv86VVjeDpEjCRgDufZyH70W5mYIs8ZeXcwCjE/WR83gO8Hl1uH1dkJ2XbmRFubPvFbzpLNbiMs85bvsYTPDmtaPmUtuHvYRCUwusxUvo5pTNTTdSTqbygMtamNvqzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=pWQg17Nw; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="pWQg17Nw"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrznr6JRrz1XM30g;
	Fri, 25 Sep 2026 18:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790361134; x=1792953135; bh=ynU3i
	vhsNTS4KIPvKelbycWkUFCLJkNLlLPqgqH7FE0=; b=pWQg17NwuneTK5yobixYS
	s9ZKpX6duRmp8F0ZIIVi6Z4aY59eaTAd+feAITfPCLTu+kdwtRq3BkTF6/JG+/p8
	WJ9YLHQRQdaGqCewkyARPJRzBX9/9p3KzRZfapHQOaPucB24QLWK+e2M0uUgJ/en
	uzfibeXhKwkn7yxIc0QrAgeIBfjRsBadmmV7sUs+FnwN5qzAN6PGwvaZFX7dOSNu
	TVDnl6AASARnoSkwnik2YpZpP1KjmFoev96fZH3qWctDIwY5kShcKcpA+b3V3oqt
	VwBQbaxHJT7syOmGHmvaT8lV1JpJ4nFhT7EhvOk68CSF0NgMQChqSGpL4TLh8QKl
	Q==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 59OH4ji71i6S; Fri, 25 Sep 2026 18:32:14 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrznm3xwsz1XM5kW;
	Fri, 25 Sep 2026 18:32:12 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH v4 38/54] scsi: libsas: Enable lock context analysis
Date: Fri, 25 Sep 2026 11:26:16 -0700
Message-ID: <20e64720347207239130312c7a7c6ef530ebce38.1790360262.git.bvanassche@acm.org>
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
