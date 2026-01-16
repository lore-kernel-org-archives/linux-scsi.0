Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B79834B43F
	for <linux-scsi@vger.kernel.org>; Fri, 16 Jan 2026 18:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768588003; cv=none; b=sYkhqGbwypNAbm69XEZg5ljNwSW1SeAv6IDNSSaDmA/Z7e4Xx5zneohKVgvQverVV2WCZhJ/Idbyfc47TebkGYGqjKI223wPZ9c9v/XvqGl6X4pCXUo1blwOCGb9fdqEshQNHGrEIzHGNkfeAdZqTW1/MDVF2Ly8Kwka8pFXhpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768588003; c=relaxed/simple;
	bh=2qzD7G/bbV2SYzE3D0Hm7mCC8ILukeLm9D3tETlnn6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EGx2Wx3iMRnVF+RuRRsR9XDLeOTicRsH58YZH3BgSsQzWkZz5Gbx8aPag81hH1ibsRdFdCinpktiDXyMLGrexfrVab2L+Baezscfz4fxm/H/QZnnPIrUH+zrHc+jjoJeIYJkoPUwsMZ3EctMIzZ113UqpOGR/Bb7SdXrcOMAjF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=uH1yXz/8; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="uH1yXz/8"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dt7bj5rhbzlgr4B;
	Fri, 16 Jan 2026 18:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1768588000; x=1771180001; bh=pKs5i30EzOw44zsUWK3lQCOcg0BZv3JltYd
	QPazTv24=; b=uH1yXz/8ZMFSsmxQ4h3Iecq64TI9lXZeeWqnI0htQ1dXFZoFdZU
	cDoK5NW2ToF2ejYt+qZ1QPhWCcQjM3obWeahCO1L8m83XU0y3QvoveGq/is80s9M
	HhhuE7QbXJhPZ6XmyUNZAlWaboVWvwuAq7sWYA1pfi/6rUijGN9rQBTPNnwp1t8l
	JQX0qO4gEtXBSQDiXDxNGqg5AEC8Ug7gX6SF9r8wSPN6mzesGYRQZP5I9jFYuO1l
	mzMfmQWyKxgq7RFn7yXWGHvaVJRPkZC7Y4mRLYVbcpqYcrGV9+vYBu278peLlzE8
	hYGeU40ZTLU1Ct8FEKwtlkyIWdSat4D6+tg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id g5ENY5xQbx7Y; Fri, 16 Jan 2026 18:26:40 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dt7bh2l8czlfl7l;
	Fri, 16 Jan 2026 18:26:40 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/7] ufs: Remove the clock gating code
Date: Fri, 16 Jan 2026 10:26:02 -0800
Message-ID: <20260116182628.3255116-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Martin,

There is some duplicate code in the UFS driver: both the runtime power
management (RPM) code and the clock gating code switch between the same
low-power and fully-powered state. Since the RPM code is more efficient,
this patch series remove the clock gating code. This change has been
realized without modifying the driver behavior and without breaking the U=
FS
driver sysfs interface.

Please consider this patch series for the next merge window.

Thanks,

Bart.

Bart Van Assche (7):
  ufs: core: Change the type of an ufshcd_clkgate_delay_set() argument
  ufs: host: mediatek: Use ufshcd_clkgate_delay_set()
  ufs: core: Redirect clock gating to RPM
  ufs: core: Switch from clock gating to RPM
  ufs: core: Remove unused code and data structures
  ufs: core: Remove superfluous ufshcd_{hold,release}() calls
  ufs: core: Remove ufshcd_{hold,release}() calls from the I/O path

 drivers/ufs/core/ufs-sysfs.c    |   2 -
 drivers/ufs/core/ufs_trace.h    |  27 ---
 drivers/ufs/core/ufshcd.c       | 319 +++++---------------------------
 drivers/ufs/host/ufs-mediatek.c |   5 +-
 include/ufs/ufshcd.h            |  37 +---
 5 files changed, 48 insertions(+), 342 deletions(-)

