Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E05239D6DE
	for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 18:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777573457; cv=none; b=pemfndFbKjU2kDbUxKk4xt9MlkmotmoCjsKPVjqUwK2VwEgz+LgBI0Kwm4qtAtZZtDi5fjccejQyNq/wEvv4cmOMo4Uj5c6byZR9jlMBDrwEFD09qSCm7tZULUqtmwX2oUuLPnbx+43+0VQhWD9tKrgI1RSRiaS4j3SHPykki6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777573457; c=relaxed/simple;
	bh=hoU1RLin0DNMXMT5udDNLQMX35saEE5M+h2kf04To+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kVZGUJLZpBeHsmzeKEC1Rpg+FcB9IVjeL/v2Nm+bOyQOin/3kDGWtnwo3Ce5i6wj5PHC88drXwiDpXP6PMLv3ZImyiAZ/y6poFj02m6VbCHfxcxYkbmtfineZDNL0JiqtPEyV45qVbMxDmAEUIfASyXBb616RhEvpPsydHg3NAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=3MiP/XnK; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="3MiP/XnK"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4g62cv620jzm1W1C;
	Thu, 30 Apr 2026 18:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1777573453; x=1780165454; bh=ynU3i
	vhsNTS4KIPvKelbycWkUFCLJkNLlLPqgqH7FE0=; b=3MiP/XnK4W561+cA5hN+/
	S1J66OuTmJCkAyFo41zb5bbt5qIFk899MxxVufsUPo9icewSNV0GCiA2Qy8uI+1n
	oKn7JLpZIvqZJxS4xcpykA72RXHeTXSn6Kd/YyJUe5RiEExUMoXp2rRA/31+LRPF
	04sqS4o9vwm8JiCpDU5z7ute1FOFzattwnhOUHoQE4gAfpRdTXjXKxFW6HTN83HE
	bILtskgd3DpfLzPcp7U5ZDdCUTQ6vaFh7ZmsAxjf+c6yy+LBpGScDqHf8gk0ZmKy
	q3S0SOKgGspzei/64yNZEQKXE1KJB9DLWIlr/be6LihsaHOUlkUsU1rmXFuoQh4D
	g==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id pSFeWTZPtx19; Thu, 30 Apr 2026 18:24:13 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4g62cr35NSzlfl89;
	Thu, 30 Apr 2026 18:24:12 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Marco Elver <elver@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 37/56] scsi: libsas: Enable lock context analysis
Date: Thu, 30 Apr 2026 11:20:07 -0700
Message-ID: <20260430182130.1978347-38-bvanassche@acm.org>
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
