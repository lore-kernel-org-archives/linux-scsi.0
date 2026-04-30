Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8FA421F06
	for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 18:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777573406; cv=none; b=AwFf8/F8ZgQ8wdFeObP/+aFkrqApIREnEEEjA9zNROH1OWUG2OvZ6GPb9JmGfR1AEOkGpltdaRYu+oFYf2OB5RT0mZbFdHNcq3hWWLWLqIdIOXjrW0wJgsU6UOaIMzU5ABzi/93VKlZWXzzckvJseS0nNCCUskCnV2lf78CksJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777573406; c=relaxed/simple;
	bh=cbcqL4QI+no/ZvQ/XpchMGVdbNtQdDoE/vHVIlB9tvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VSWd8nP3b63DAd2ywq+BS3MuLjqIW/3II+NmHcjly3333l7qyqknGN8Bv03cu0MO4Z768/Ba0eivfXLSpKU6ZK9qVb87N3W8kv4VQDhI2kjSMp+RRumFIc3Z6d6y7yac9B/1oKxWbCWvONd+XUHGybctMgmuPo2t7MRp+s78gN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=J32L61cF; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="J32L61cF"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4g62bv4gBqzlfdfN;
	Thu, 30 Apr 2026 18:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1777573400; x=1780165401; bh=32TSW
	CbHjiskeo0J6OtY7X7eOhcxxx0DKaL+PCFqP+0=; b=J32L61cFLKKCJgMybNv+m
	O46jLu/v873qE2tt/WCyTbdrhAvl9Y/uIeDdvLeLenIL170PAs1e84WiDTms/Ie9
	iU1QHpNbL+YI8WG++++dCeI+U1rpjsILJ+qOtNICGvOhlj5q1gGGlo+Az+l5xdgM
	JCYLCNO7+kZUc9uSdyYmdYx8Bwjk2Ileyu0TOSReEzesJdjTIGvIX+bL2coO0z6u
	nhtuQww9ci7QKBNWjRc5q8bV4trLXgVJdo3xh3SB/tL4Dqtv2i0jRuH+nfnNZrVR
	7XjQbZhgvtPoqknBb222NzGMquJWaNWI/ZIvtyJ/N7xEr4dr2SzivHGUuSr8mR8N
	w==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id LoRJ0rOCpev2; Thu, 30 Apr 2026 18:23:20 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4g62bp6YJdzlfdds;
	Thu, 30 Apr 2026 18:23:18 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Marco Elver <elver@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 24/56] scsi: esas2r: Enable lock context analysis
Date: Thu, 30 Apr 2026 11:19:54 -0700
Message-ID: <20260430182130.1978347-25-bvanassche@acm.org>
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
 drivers/scsi/esas2r/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/esas2r/Makefile b/drivers/scsi/esas2r/Makefile
index 279d9cb3ca69..325fa0e634fa 100644
--- a/drivers/scsi/esas2r/Makefile
+++ b/drivers/scsi/esas2r/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
+
+CONTEXT_ANALYSIS :=3D y
+
 obj-$(CONFIG_SCSI_ESAS2R)	+=3D esas2r.o
=20
 esas2r-objs :=3D esas2r_log.o esas2r_disc.o esas2r_flash.o esas2r_init.o=
 \
