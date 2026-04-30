Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D20BF39D6DE
	for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 18:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777573354; cv=none; b=JS8ePJXSReU6ymZ2Z0NF5V9VUecExa8lUrgRzkQcz8wVXEpTDOB9P2cOsxs3kEoy6z04X1DU73rrHmq0JPh7mUPrSQvConwZw7Yk7VGMb9hmvWgxuQiVxgZ+I2u2MQAtvdpmPdGnKiQXErEhxEU6iI2Afg/QhQ/IXFyJ6QBhdoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777573354; c=relaxed/simple;
	bh=eR+lxdrj9h43hWxvPvQYuh4o4+yZXm2dLUA5q7qAUCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cZGV2lKc7L97jS2jx6aXZEaeGiY7U+Bd9mJ2BpxS898+EKo/JDtdXJIKGc/gbmF0EYGC05nyBq2e06DBlpn14mnMX3uQD/dodvEp3OypNtKF6/C22IyNk37L7rheUQg/07SvQWlA9zD5w5QJwfAGileVG8lTK/YI6NNxOWSsRHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=IExq+bcR; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="IExq+bcR"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4g62Zx4JbXzm1n9v;
	Thu, 30 Apr 2026 18:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1777573351; x=1780165352; bh=eR+lx
	drj9h43hWxvPvQYuh4o4+yZXm2dLUA5q7qAUCI=; b=IExq+bcRJe4HIK/ApafEY
	os7z9FGOXZyrgZKzBVlzWzSWuO89lhfk6DosExIKqERcqCSca5xgajU9b69NSN/N
	aH2KVA9M6WRWUfm6hwqbuAQ2bjTjcT8TZlLWhTBLp3HhD6gsTiIBLcIsp4dZ2+Fw
	FMegrw9yx5ec0iAKc8Osz7DAbHEWfZPhRou3cKF9Lx3wtQkUztq99ynUpTFrjDnn
	gagVc3R1GmAu+CBIUBbP94wyzZ2HuO1Bl1IxtZm5ap/Dl7lA97sEPkPj4oPvUDen
	WqOVLAheO/QwiYQ5v4e42sQlmcIcSA0WCs8XuWaNyth/3IkNIuQwWeSBzQEkcWxK
	g==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id HO37XFRpvNdq; Thu, 30 Apr 2026 18:22:31 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4g62Zt0WCLzm1W0n;
	Thu, 30 Apr 2026 18:22:29 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Marco Elver <elver@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 13/56] scsi: arcmsr: Enable lock context analysis
Date: Thu, 30 Apr 2026 11:19:43 -0700
Message-ID: <20260430182130.1978347-14-bvanassche@acm.org>
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
 drivers/scsi/arcmsr/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/arcmsr/Makefile b/drivers/scsi/arcmsr/Makefile
index 9051f66cae36..6c12d36994da 100644
--- a/drivers/scsi/arcmsr/Makefile
+++ b/drivers/scsi/arcmsr/Makefile
@@ -2,6 +2,8 @@
 # File: drivers/arcmsr/Makefile
 # Makefile for the ARECA PCI-X PCI-EXPRESS SATA RAID controllers SCSI dr=
iver.
=20
+CONTEXT_ANALYSIS :=3D y
+
 arcmsr-objs :=3D arcmsr_attr.o arcmsr_hba.o
=20
 obj-$(CONFIG_SCSI_ARCMSR) :=3D arcmsr.o
