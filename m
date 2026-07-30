Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63CDC3DA5C3
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 22:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451641; cv=none; b=MMqcn1jistKJ4/8/AZ6fSE6tHbLRBNthHbJYo4NEA+ElOctD/RQqT1h+mjY3QAXicT9++7gmtZBZ8VqXWEZa17CHSh/wQd9NPUspf7I3Nl1Yk9k8NNidzEFD188v3m4ioYBvjQDeQJGygbvoGOmctwSdS3vSc7ftLCuCzMJlkMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451641; c=relaxed/simple;
	bh=76u1kUdSOMdw1vAjVXt4g3N7fVwAJKLab7WirB4o6pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j8FcdmtGzet3XuIoHt19h6FCDEYPbsJKZH1iOSSehd937RuhPCfgR2K9s6AhUS+a89alPYQzmzwnXX8Qy+eQlDUPee5xXe4ZAlFWCZhYlVLvVyk7XM4hEQVFxWSghN7zpXq9WqEnlO4v+yl3Prq2SWoMfZOzrG+8GcID2gk9rGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=4drQohe8; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="4drQohe8"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hB48R6shVz1XM30k;
	Thu, 30 Jul 2026 22:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785451637; x=1788043638; bh=56XqI
	xnR3+CKVjP7ELXa8qEDxDHIlibcqQYsgKj+vhw=; b=4drQohe8IIUQpYpK2E3CI
	b/rtpP99xguuQTEc4X6zH9QeCPpdFB8a3HvhYrDHLyKdCj/UNtS+GFTlxMyrd7CE
	wGst5BspBlltbS1gZSsvWlM4xv23FVXsgSeTUE9QwgPS6U4YHoM1lE1Dav9weHAF
	ig+MahhXua9hSG9fkKsYU1FMm2ynWEc8Yuv3ZXDCWnLKy4emf/qfmvXAU9TmBipn
	tYVN1fFdhXIMdjfYq8Zu2YaKVJLtG17lZ4ODG3GejflUivgea+E3Wmf46D+8+mob
	7VoShiGxoXKt6IDzkUJwbf0rgrvlcqZVtetb8qzHcjhYycEoh8mqiajTBIW1gaEo
	g==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Y79ulZRiZ2ec; Thu, 30 Jul 2026 22:47:17 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hB48M4pntz1XM4TB;
	Thu, 30 Jul 2026 22:47:15 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"Juergen E. Fischer" <fischer@norbit.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 10/57] scsi: aha152x: Prepare for enabling lock context analysis
Date: Thu, 30 Jul 2026 15:44:53 -0700
Message-ID: <f721bb8e817434bf1449bcdba0f305e3f69fd9d4.1785451174.git.bvanassche@acm.org>
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

Annotate is_complete() with __context_unsafe() because it performs
conditional locking.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/aha152x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index e3ccb6bb62c0..c16dcb9274eb 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -2319,6 +2319,7 @@ static void rsti_run(struct Scsi_Host *shpnt)
  *
  */
 static void is_complete(struct Scsi_Host *shpnt)
+	__context_unsafe(conditional locking)
 {
 	int dataphase;
 	unsigned long flags;
