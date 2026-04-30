Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA48144D688
	for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 18:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777573414; cv=none; b=Hy2PWKJFfGKE5jAo6olTc5ZvJ356cZwj1n76OwGMAdu+UPuiX/PpYwhAJ0zSJY0dMwAyBqOuDiCtN1I0gL1e3dzSYujEcZ8VvOtATargqaNw0sFEKO+3crA0mRcyxdPas3tXKWzTEYmoZaah7+yA3qQGBLvzbkG4Atvxt6KYDJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777573414; c=relaxed/simple;
	bh=k4tldGNR5CErhM5sxtZLS/GW+khBvOrodyLMisdkMLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=giI3WX5WQoDCeKcLhQucq+yaNd3rAUdnd97eignAkfVP7DI0+RbwiLlI9HTqo+5ZGPrNTBzQzagHr5kmYPbHl6XeIKNIN9N9AnvKNGxy56NoCgxzhCN4+9Kpg3m39oIeuN22uJCIzWKUB1/ixHZt6FfxJqm6xAj8ZcnLGJATFdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=J0c1LmHS; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="J0c1LmHS"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4g62c50CdZzlffts;
	Thu, 30 Apr 2026 18:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1777573410; x=1780165411; bh=8EX99
	Tg7aEDSo+xYJ5hBUWcZ/pki/1tzNSzfGgBln+8=; b=J0c1LmHS1CvH4sP2l3ci7
	it/HW7tC1Hw+UBNBgDSUZ7Tmy/WKdPZnGNRMlfxz4arcS/DPS+YXNvSWFu9/3pA5
	JDcuJvUR+ycsZN0PoIIlc92lwEDyX3bgyuFnKYWh4Xl+D70Mb31n19vsrGla2blQ
	eZYKyWNWeJalLOmQKZUn6sKXZZtCql3JcOeLwEfnpC+uTCbNpwCQ9NJ/UryrVTEF
	lDWy8lFn1jWvBStGfcq8ucoPrzey1+0qW5o9+KDdqSYWbNHe0QrLdXYaH3ZRfFx0
	KBvdn46kTcyUKic8UaC2aiGsBVL+sxIT4kN+y0bBKLVlj99NUNQS96oBNqXkD/rF
	A==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Vf0FnfF4ycHP; Thu, 30 Apr 2026 18:23:30 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4g62c1080hzlfl89;
	Thu, 30 Apr 2026 18:23:28 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Marco Elver <elver@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Yihang Li <liyihang9@h-partners.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 27/56] scsi: hisi_sas: Enable lock context analysis
Date: Thu, 30 Apr 2026 11:19:57 -0700
Message-ID: <20260430182130.1978347-28-bvanassche@acm.org>
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
 drivers/scsi/hisi_sas/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/hisi_sas/Makefile b/drivers/scsi/hisi_sas/Makef=
ile
index 742e732cd51d..8576c78d4afe 100644
--- a/drivers/scsi/hisi_sas/Makefile
+++ b/drivers/scsi/hisi_sas/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
+
+CONTEXT_ANALYSIS :=3D y
+
 obj-$(CONFIG_SCSI_HISI_SAS)		+=3D hisi_sas_main.o
 obj-$(CONFIG_SCSI_HISI_SAS)		+=3D hisi_sas_v1_hw.o hisi_sas_v2_hw.o
 obj-$(CONFIG_SCSI_HISI_SAS_PCI)		+=3D hisi_sas_v3_hw.o
