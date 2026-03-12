Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352A53CAE8E
	for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2026 21:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773350276; cv=none; b=SAfYUBHC1xR8riEZ4Pl1ig98QL1Mxd/uE6qDN17bSZW2hlKKRmFQFALlWDx+y5msdJeCyOW8x8oQHXKITP2Jth/KtucBae7aalHJ7KEdQN8mF7eGVYeqjqOlnYp0qIqXD8VGOC0Stv+EnOFcY6cvgLTes6zf5aWgAP4EwCHUWNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773350276; c=relaxed/simple;
	bh=DOnvxuBA9tgzrDEA2GQWusZumAAFkWXu7Wx5D7CTj9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aX1YqZtO2Sxbcy38ROyWB8R2q2Jq55udOI98ZvUDFG8OVqfMILLFuRcCyUj2pVA4zsPQEICFv3QQoi4XO08f6BllUmfAFHmnou0+rpWsjO/x9Qk3NBC9P+2sRc3SBa3x/Y6AnMHYgAwJ3tArAAn1EpUqEFAzXQyXdPjrdaMQKQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=FR3kL4fO; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="FR3kL4fO"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fX0nt5trdzlfl5V;
	Thu, 12 Mar 2026 21:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1773350272; x=1775942273; bh=2hn5S
	QbAWE7a24Fv4He10plUnzSimUKiz04laKm4XWI=; b=FR3kL4fOBsv1JidxXmsV2
	Oi+2UPS2QNxS+a/GDNBeIgR5ONKEhx5T8i4YvLatTB7y/pGz1hvnLgxaEbubF2uj
	XiBVOPuQwnqlVBcdQh1yi6Xo7x+G6D6MyXBir35nvVky0xse824DrBUEVV+Q/Ikj
	tNdxNr/F8x8kd+T7hA+0wPh/DwzT1tsXPqzRWczDeaCdozP+J2PXRM4VvEDlvKEg
	9wFvBRMKaagfnYYzYlsCZ0EHMbmdvJNhGwDa9HTNVG5o04qNrr0iDPvUnqg0ZdzA
	r4tTu79zDmaAZXcGUjJQLSk8ErtAufb8T64ndid/Mykmh084kH7Ht9LGl8mlkqOM
	Q==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id c6cWkXOerpBf; Thu, 12 Mar 2026 21:17:52 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fX0nm2v2Wzlfl5l;
	Thu, 12 Mar 2026 21:17:48 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 20/36] scsi: ips: Prepare for enabling lock context analysis
Date: Thu, 12 Mar 2026 14:15:31 -0700
Message-ID: <20260312211636.3245119-21-bvanassche@acm.org>
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
In-Reply-To: <20260312211636.3245119-1-bvanassche@acm.org>
References: <20260312211636.3245119-1-bvanassche@acm.org>
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
index 41ed73966a48..3de7b90a2e56 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -2506,6 +2506,7 @@ ips_hainit(ips_ha_t * ha)
 /***********************************************************************=
*****/
 static void
 ips_next(ips_ha_t * ha, int intr)
+	__no_context_analysis /* conditional locking */
 {
 	ips_scb_t *scb;
 	struct scsi_cmnd *SC;
