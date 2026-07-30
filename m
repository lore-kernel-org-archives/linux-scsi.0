Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E1C3CAE80
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 22:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451652; cv=none; b=Y/IFRmNSQNowY2gmqzxWOwhzdmsUMnmlzwu99PxPtjhzyRpDUMtzJrljLsgLdiNHKWebfHHRBevMLpwjvnG2Ia3BlKgkZWSfYGwPsGzXLPFai2Nw1RuHx0VOOcdbtqHXbW2p0Mi4IdLfphoBCFHslLkNYDuh9U5HKas2Mih25Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451652; c=relaxed/simple;
	bh=rA9dcjB/53gL6plQiDABo3vtxCT7CnlACpzZLBieCY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rw89HqTC0Da3FtgJXzHGQNEi81TFQWutoH+tSOhVb5Z815u7quPjGII8SBCCMnmCQ5il+PHCe3qJ1i/FKLz0F6yukF+gGNvNwgjpOtDRhMbN+LT/fjWU32RnX024E3dgrLRf+z7zQyZXQXnE/PgkbrtD7ZLG+loqv60m3Tm3U2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=t2xp72ci; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="t2xp72ci"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hB48f38tSz1XM6Jk;
	Thu, 30 Jul 2026 22:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785451647; x=1788043648; bh=3mD38
	fc+TmPeJmfhZePNhtdCoHpJbmZh+Kw2gU6HX2s=; b=t2xp72ci+SNL87HlIny2b
	C2XojDfdfWXS9g+3OyL9mc5wY/PuVqW3wIRKc+CWkO9KTz1Vegm6I9O5b489Wq/0
	8GWjSsLItLO/g5ZSJiW8hQ2ezpeO3X0h/zQq0gV48kbIvtYVd4usfhKIAQJ5aR7d
	uxDoSndu7qfN5Cvht2+SKAWdPWu6xvCLOfuTcsN9dceNQ5sc+MTr9urxG9F1DLHM
	NFVsvF7H8mB0dERkKNP46tZnn2Jp2H2XxlmpYrZTXZp/YyfDjOHK7iknkNCrZLI4
	l15axud6e8hKl7leIH1YdKg0EbTv9FjgpqLhDuo7R/lsTYQ828HMc2vO92ZYrD/9
	Q==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id W6kBaMXAP6jL; Thu, 30 Jul 2026 22:47:27 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hB48Z1hFsz1XM4TB;
	Thu, 30 Jul 2026 22:47:25 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Russell King <linux@armlinux.org.uk>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 14/57] scsi: arm: Enable lock context analysis
Date: Thu, 30 Jul 2026 15:44:57 -0700
Message-ID: <24acc7e1cd0f9bdf8b08aa52c22c98c8b599d7e7.1785451174.git.bvanassche@acm.org>
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
