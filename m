Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DCBB137750
	for <linux-scsi@vger.kernel.org>; Mon,  3 Jun 2024 17:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717435427; cv=none; b=fcjAylb1oEN7PguQdmA0yydVxEg/ie9bRPHNjw7kgwKoFhF8nXKSWxDPruAByEoRmUsHqyYliYqq6xcrAFSz+QrUCzrfdQq2BAz2iXgrP/ny1fCwr8Mw2YygXbb1kAJav6gD3v1aLdPC08U/m2ZX4CaB4J2vEbnfLxj+O6cdAJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717435427; c=relaxed/simple;
	bh=GBgeSF6rlzurcfKrtey93szxzSZhCMcVRmz6FLzGW7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RVoUGMqhoTu0CqHuIVFfLF0nzEW+AWpiAtODVV52c1Aw+09lPwu+f83WeH83ZYG7xkxjmV2l9qTo/xMtiDjHYNXllUHnRBihnCZFunbyhMOWXxjbHzCU7rL8Ihyb4TjWTkQr5N7lib9eI88EypUo0fQdtg7xJCnXEYfJBZEpZY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=OvbstpI8; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="OvbstpI8"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4VtLDK39fjzlgMVY;
	Mon,  3 Jun 2024 17:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1717435423; x=1720027424; bh=UfaT6
	jmzoOYg2d312u9jWha/9o+/ic1r8sEDMdkxLFU=; b=OvbstpI81sDrK69A4cuIm
	FRA5RIWKz+BR1G+w6RT/L2WMiU9hN3zEsxIK8MYEB16TCpMWAhBj0zqkNuO8YGWJ
	epdnRtJcnzUa1hxJhCtjVxw2zCvwVUqDHXNpcuJ1y35SPQbS3erGgP75G8nELcxl
	JhJt7uEYhMTHb1zfTlpjz2+sWaFUSvQioeZTk6MxolfgSvMPuZnE20w1TjPgBi8t
	+gz6GVoXMMnw+4M4/BZ6bQI6if/CiZcJeiWUAU0pEttwmTJrP+fkSz8sCViZaice
	Co8rS8zLrzLwFvDkyFT82bc20SNc9h0pVlwHdLLERhOXHZpPJrEXDWaC6qiuYCob
	g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id gTJh_qcqMkSJ; Mon,  3 Jun 2024 17:23:43 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4VtLDH1RhFzlgMVw;
	Mon,  3 Jun 2024 17:23:43 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Russell King <linux@armlinux.org.uk>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 4/4] scsi: powertec: Declare local functions static
Date: Mon,  3 Jun 2024 10:23:11 -0700
Message-ID: <20240603172311.1587589-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
In-Reply-To: <20240603172311.1587589-1-bvanassche@acm.org>
References: <20240603172311.1587589-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/arm/powertec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/arm/powertec.c b/drivers/scsi/arm/powertec.c
index 3b5991427886..823c65ff6c12 100644
--- a/drivers/scsi/arm/powertec.c
+++ b/drivers/scsi/arm/powertec.c
@@ -184,7 +184,7 @@ powertecscsi_dma_stop(struct Scsi_Host *host, struct =
scsi_pointer *SCp)
  * Params   : host - driver host structure to return info for.
  * Returns  : pointer to a static buffer containing null terminated stri=
ng.
  */
-const char *powertecscsi_info(struct Scsi_Host *host)
+static const char *powertecscsi_info(struct Scsi_Host *host)
 {
 	struct powertec_info *info =3D (struct powertec_info *)host->hostdata;
 	static char string[150];
