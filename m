Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE4047B429
	for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 18:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777573428; cv=none; b=kLvhywtzmC33JLGslvlCHxkJXMzn0apyGj+ikMynm4+yOmWla8VdAw2qDaKWDkySh4tMMLaPHwnyuGv7BYW01dSf7dUFfQ7dzm1hDmRgISccXhaiZgl4P09WqfCRP+4QHx+ljJxO2JqpWMcpxlP6XoeEKHKUZC7tIsAwoObgTdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777573428; c=relaxed/simple;
	bh=oxLfLw+1zSl0q5HJ4yTJRyf8Z2BcH2NCBu+r01F6gjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aGHTT17n0YDLriyN2cxKbEiTrQzNa/9wMr7SYLCaNlQYbk4oDFJCtI6JL+wEWuJYj3jkIFzEtLSnzEmYyg+ihAFYlt6W/4YJtaxtGi5zhJA6uLdyS7Sfs077RulcgjB/uoxYnt2LA+AbBBB+/sLcUAM6f8DBW09BkFSSkuN4x5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=YD0KkvEA; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="YD0KkvEA"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4g62cL4mwpzlfvpH;
	Thu, 30 Apr 2026 18:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1777573423; x=1780165424; bh=pvrYG
	9jYH/10/4mM0pbHYfk6dn0YuY0jW5cvbz+qljI=; b=YD0KkvEA8OZ6eVyn1Rwmd
	1XjRFIksUOoJR8LfU4BgRKKYnG0z4NsNUfrTiSshOsyToZKkRBrV1ziK1usfZDWl
	/UIg+g3/8Q3d1IxzCMBqUlOK/Oz/E6OUdoHQHIvoJRY71g8pvHTEK7U8jVHoVoBK
	YS1CtSfi3aoR1WfS2YoBV7sFmr9Rkjv363h6gXYI9+f6xhewx2nXarTRLSE065aU
	zsCJoC/YmkrfxFgOuvPKTC1wulbblMRsj3auMk/xq9+WxmPwHz5OY/sr4wxWdzPy
	NFgoJadx2d8HdtJ4fghY9tCibU7wxs+B8rFKACVYK49xfcCkimbtq/1vv6cvG09I
	g==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 8Dch6m58KGcb; Thu, 30 Apr 2026 18:23:43 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4g62cG1mxhzlhpgv;
	Thu, 30 Apr 2026 18:23:41 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Marco Elver <elver@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 32/56] scsi: ips: Prepare for enabling lock context analysis
Date: Thu, 30 Apr 2026 11:20:02 -0700
Message-ID: <20260430182130.1978347-33-bvanassche@acm.org>
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

Annotate ips_next() with __no_context_analysis because it performs
conditional locking.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ips.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 41ed73966a48..5ef70f058ecd 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -2506,6 +2506,7 @@ ips_hainit(ips_ha_t * ha)
 /***********************************************************************=
*****/
 static void
 ips_next(ips_ha_t * ha, int intr)
+	__context_unsafe(conditional locking)
 {
 	ips_scb_t *scb;
 	struct scsi_cmnd *SC;
