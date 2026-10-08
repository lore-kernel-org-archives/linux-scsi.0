Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE4733122A
	for <linux-scsi@vger.kernel.org>; Thu,  8 Oct 2026 22:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791499371; cv=none; b=Ymt76CKD1SX2F36zYhuF8TceeoYDrLWOJPZaf2E3QcW5vJh95+aSd1nSgEXM2JvG4ioNjlB5wn7o4loh1yCqBXZdSYKDVl7CmbzSPQ5o+AEoejlaq5OlVgQlIZwa2AG3gmsdZKQbfF4o0A3saZb0agrbaWEjf2aSOu6BdgtgyfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791499371; c=relaxed/simple;
	bh=dM4sRFEqNCR9x1u7fWc02bYsKonZD3wyAUnia+USyyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jp5/PUO89g2M1kCR6o2DJi6sLT/CcnqV8chRRYFML14Vsaqg0QHYY/85lfb85crPDews4peY/J0MOBKXsHRpaZMb7UBZdnNTCIg64PK8hzZIvUi8If2BUEGXxBNUu4a3qGhpt4IsPfWxxPgPl6zZzb1PNGicw7uTNNjemWktPv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=0Af/0rY0; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="0Af/0rY0"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4j14ky0CYdz1XM30h;
	Thu,  8 Oct 2026 22:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1791499367; x=1794091368; bh=dM4sR
	FEqNCR9x1u7fWc02bYsKonZD3wyAUnia+USyyI=; b=0Af/0rY0EZM3ST9Up1Odl
	uboepGTL3UysklOSEcylaLaFfM34w4MIuzqGmJCw0i4SjABkqYE5fHM216mAt48n
	Wtga0fwnm5h5LdHn8C1QLa1ms8tIF+yUZF/UbkRUwDJ2d2uyrPcGPobhHqR0H0p0
	XRasg5EiccxpjHBrKvVdSrmoPL1Lgfs0uUdD2+mq6RUroyMaQDmcLuwje/5wT0Ho
	6AMlAvuOjXoByXdnSNhJFFtCOIclC3kVmT/WXiXyEYZZHNkC5q8PFXDYBeQrnPHM
	3VKVGLa4wyvqp7lKmiHji/k/7raEdbU71m/RP4JjStuspHQtVm2PRRQ5CXF4AZQ3
	g==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Zic225eRLYyq; Thu,  8 Oct 2026 22:42:47 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (245.199.118.34.bc.googleusercontent.com [34.118.199.245])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4j14ks5krZz1XM30g;
	Thu,  8 Oct 2026 22:42:45 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.garry@linux.dev>,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v5 8/8] scsi: core: Enable lock context analysis for the scsi_debug driver
Date: Thu,  8 Oct 2026 15:42:19 -0700
Message-ID: <420bbd4520467018dd5bd8afc0e2c7c7f898c13b.1791499174.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.170.g584c36229d-goog
In-Reply-To: <cover.1791499174.git.bvanassche@acm.org>
References: <cover.1791499174.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Enable lock context analysis now that all lock context analysis warnings
have been fixed.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.garry@linux.dev>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 533623382eca..32d816e942d6 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -18,6 +18,7 @@ CONTEXT_ANALYSIS_constants.o :=3D y
 CONTEXT_ANALYSIS_hosts.o :=3D y
 CONTEXT_ANALYSIS_scsi.o :=3D y
 CONTEXT_ANALYSIS_scsi_common.o :=3D y
+CONTEXT_ANALYSIS_scsi_debug.o :=3D y
 CONTEXT_ANALYSIS_scsi_devinfo.o :=3D y
 CONTEXT_ANALYSIS_scsi_dh.o :=3D y
 CONTEXT_ANALYSIS_scsi_error.o :=3D y
