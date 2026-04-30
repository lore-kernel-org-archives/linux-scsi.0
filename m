Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748D839D6DE
	for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 18:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777573357; cv=none; b=F4QuRhKoxnNv5PcRwv6Wa9I8Y/4a6y3fxObdVNs5uLqtRruxgTVA+VyuJGqcpEy0+H3plgIgt8qHPd2xSwVfpgle+CFhxwOn3WKvFbgxqLXKOciLJXuLCz5kQK61crOM1WxxDhyapvYwCtOpTsUhbe8pz5zBjm4oVH6m+KLe6rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777573357; c=relaxed/simple;
	bh=rA9dcjB/53gL6plQiDABo3vtxCT7CnlACpzZLBieCY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m0l2QVhs5GHk1Jna9uzGXo+RbIcZGbcwroHvahwbmK0n65evupQY+0/IZRsHBcx7M41Cz/s9mI4uIeKfm19cIaOEJF5QKEKWIKWdQDgVY7VBbwO/s+cbApPpn36eRbuARRazcDT9nohYzrUQBuZ1XJaNanBTEX4Dlu4nErbZzOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=SrhsLQun; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="SrhsLQun"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4g62b00g2tzlfftl;
	Thu, 30 Apr 2026 18:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1777573353; x=1780165354; bh=3mD38
	fc+TmPeJmfhZePNhtdCoHpJbmZh+Kw2gU6HX2s=; b=SrhsLQundOen9dhh47wk2
	PE38HjeRhcmENUyurkSnpevmc8/4CPI46Xx1bkzuy+M/yBr+LI45PsawyCLLzp8L
	7qRJinb/Pt5aF0/ZVGLxCMJ/OzZff23yYcD5b1ri7KLxGoy8n52n65o2suu4Gifr
	Fw+Y7SeJgsQti8Rf/6u78lkxRZeAEU8QLlycLQDByS9FphbvzZesuxLEaeG4JbZv
	Ce5v1Rj5UFkjqD/1n5ijOqbp3aUWZYpWLrn0zSZE87S3yK0Bfh1aRPLv+nY+ocE8
	d6tW36jslws+pzZe7DAlb6e5Dyy7vjG+qZ4d/Tpkswxslm6Hq11S3ZtrxNHKqyN4
	g==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 3UPfx9dQISBY; Thu, 30 Apr 2026 18:22:33 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4g62Zw0LQRzlffts;
	Thu, 30 Apr 2026 18:22:31 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Marco Elver <elver@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Russell King <linux@armlinux.org.uk>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 14/56] scsi: arm: Enable lock context analysis
Date: Thu, 30 Apr 2026 11:19:44 -0700
Message-ID: <20260430182130.1978347-15-bvanassche@acm.org>
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
 drivers/scsi/arm/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/arm/Makefile b/drivers/scsi/arm/Makefile
index b576d9276f71..417d47644a8d 100644
--- a/drivers/scsi/arm/Makefile
+++ b/drivers/scsi/arm/Makefile
@@ -3,6 +3,8 @@
 # Makefile for drivers/scsi/arm
 #
=20
+CONTEXT_ANALYSIS :=3D y
+
 acornscsi_mod-objs	:=3D acornscsi.o acornscsi-io.o
=20
 obj-$(CONFIG_SCSI_ACORNSCSI_3)	+=3D acornscsi_mod.o queue.o msgqueue.o
