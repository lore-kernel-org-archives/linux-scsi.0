Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E7263C552D
	for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2026 21:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773350249; cv=none; b=i/hyi3VyAzW70l5NMxRhxmwtmtttuulYrEPNn0ery7FzQK5sK/gsOMeQ+7WPXgg6dRrOCogoOFjkVmrNwgXI8nrHtb6Q7M5EGCyUkKR3LFK8MeGqgF7nJgt2eKTodwhPgjtoVEO0wgtbIYTEk1O8LOLhlXWct834+feipo7Kohg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773350249; c=relaxed/simple;
	bh=N+gr+hqGOB5Q54sI/oUwLcBcZAewEvXR2LeWogI9g3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p8DibIT6FjPcvLIN2G0HONTXrIDPQCE9/zDCbnUKkBtHgwz/0GaYC8JkbAAovcer9aGczOYcUdYXvsLUkr97Y+RGGOF+wDEjHVQj9ccymqVKdmu1/wo4LNahlvMsQaXDifK+aW9kiBxzItKSZ7jLY1gQxOlusGEPztfbkYAp0Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=EaB9PLlx; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="EaB9PLlx"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fX0nM4df4zlfl5h;
	Thu, 12 Mar 2026 21:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1773350244; x=1775942245; bh=o1Tld
	l7ZiAgdLI3MPfWFzUQAcKs61rgRkDsylVWtMtU=; b=EaB9PLlxU7nfqQHc7QevW
	u5GMtyjkb/gcV7NTpb1lzICTaqWsfZK/+OcXZ0dps9Y54jMv3JbYmkBKfuzSVpx2
	YSZF29Y1oJzNhsFGVlYLDWmuYiUYmSH3QhyEPMw2loJ3GZpVv1aidagxyHDac9X6
	BQTtJMAbWs1G9I/NvL78pxw8CS3k/0w2K4YiJJnrVnENON/2xlR24gFWR1UrLnOe
	MI24rcidSuKHmxqv5zuD1MUdrM8WdXIKrUcleyatxzQHQNwew/oXr32ucijGCUD2
	evcqR41GAv9fUo22sHhiFoRrk7ugIe6eIVrDRwxeNaSB5lBGfp6CpNCHTKAvHplZ
	A==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ze3PlHCOs52q; Thu, 12 Mar 2026 21:17:24 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fX0nH5BRlzlfl7l;
	Thu, 12 Mar 2026 21:17:23 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Hannes Reinecke <hare@suse.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 10/36] scsi: aic7xxx: Prepare for enabling lock context analysis
Date: Thu, 12 Mar 2026 14:15:21 -0700
Message-ID: <20260312211636.3245119-11-bvanassche@acm.org>
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

Document locking requirements with __acquires() and __releases().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/aic7xxx/aic79xx_osm.h | 2 ++
 drivers/scsi/aic7xxx/aic7xxx_osm.h | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.h b/drivers/scsi/aic7xxx/ai=
c79xx_osm.h
index 793fe19993a9..c6eb2b97e929 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.h
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.h
@@ -376,12 +376,14 @@ ahd_lockinit(struct ahd_softc *ahd)
=20
 static inline void
 ahd_lock(struct ahd_softc *ahd, unsigned long *flags)
+	__acquires(&ahd->platform_data->spin_lock)
 {
 	spin_lock_irqsave(&ahd->platform_data->spin_lock, *flags);
 }
=20
 static inline void
 ahd_unlock(struct ahd_softc *ahd, unsigned long *flags)
+	__releases(&ahd->platform_data->spin_lock)
 {
 	spin_unlock_irqrestore(&ahd->platform_data->spin_lock, *flags);
 }
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.h b/drivers/scsi/aic7xxx/ai=
c7xxx_osm.h
index 51d9f4de0734..5e78fe7d3f32 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.h
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.h
@@ -389,12 +389,14 @@ ahc_lockinit(struct ahc_softc *ahc)
=20
 static inline void
 ahc_lock(struct ahc_softc *ahc, unsigned long *flags)
+	__acquires(&ahc->platform_data->spin_lock)
 {
 	spin_lock_irqsave(&ahc->platform_data->spin_lock, *flags);
 }
=20
 static inline void
 ahc_unlock(struct ahc_softc *ahc, unsigned long *flags)
+	__releases(&ahc->platform_data->spin_lock)
 {
 	spin_unlock_irqrestore(&ahc->platform_data->spin_lock, *flags);
 }
