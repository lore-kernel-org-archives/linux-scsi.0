Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03CD3C5532
	for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2026 21:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773350237; cv=none; b=e+q51HXiizeOr+HQL85b/UpFxipsMY0nBPf8DroAjl6nxGEHLLYeDq31ys3NXQ8BYV/uNi/AjhyAa5UVflf/2s1TCh6ZUX/ULYE3E4nqpRfaZJVpJPQjYdaFL09cyZuWrB0cijj9zfzYf1ijOsjesY0WCp2RMXMrNcKy5U31JxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773350237; c=relaxed/simple;
	bh=jgHtAUetBAMqIth81WubE/GeJHc2FgmTvEBZmcQhU9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UozQEWb6sKlFbYbpn6qwmYvov4fTwBaa4lMc3nQUeCNgH0fhEdc7ZGgH60ceKbOn8SkjOPx22pARphg1lw5uTBUMHJx6i/yrzHXWEnpkMsewGwGUPmhhtzytu8bTcSitydMP3HZpyN6imzti1ltXQaxsWrvzt9ZhIygni4SfafQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=M21tFcpR; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="M21tFcpR"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fX0n72R58zlfl5h;
	Thu, 12 Mar 2026 21:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1773350232; x=1775942233; bh=XafUO
	nQWsOIb4/g19CDM1nA0LzU9mACC/txY6BlS2xo=; b=M21tFcpRNQwqdJ5UHnGxv
	rnO+P+MLv+wJupuGlOrnC/OaCBFOzCM8Io6KFiGVDr0NWlfbUeNuASVWN0nJFyLb
	9TTf82i+JMOr8mIFIHvPxedKxyDE3tfctuBlFFH8pxmoSeqPl0O39THzwUWmRs2e
	bCGONiIB/mJfGrc6a5quaPKvpSBMnbuj7Om6Uzjtd7Ai6UDPFItTCGgfuBO8LFUz
	NbcKwYMZRARDQ97PW00xQfoWrEWkanvyZ9ohnbE9PYG5rIMdnTWeJTAQ4RQl+v8W
	3yzmIJF66ByQTNPJIIL7eZFSkEpzj6JQ4JGSroC3T0l/M+hfeTqutqSRiLpycUS2
	g==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Zgs-sb6S7YG6; Thu, 12 Mar 2026 21:17:12 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fX0n35XpNzlfl7l;
	Thu, 12 Mar 2026 21:17:11 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Doug Gilbert <dgilbert@interlog.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 03/36] scsi: sg: Prepare for enabling lock context analysis
Date: Thu, 12 Mar 2026 14:15:14 -0700
Message-ID: <20260312211636.3245119-4-bvanassche@acm.org>
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

Annotate open_wait() with __must_hold() since it unlocks and locks a
mutex.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 2b4b2a1a8e44..ec405cb56a40 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -245,6 +245,7 @@ static int sg_allow_access(struct file *filp, unsigne=
d char *cmd)
=20
 static int
 open_wait(Sg_device *sdp, int flags)
+	__must_hold(sdp->open_rel_lock)
 {
 	int retval =3D 0;
=20
