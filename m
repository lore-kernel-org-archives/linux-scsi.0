Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD4C64F055E;
	Fri,  9 Oct 2026 16:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791563232; cv=none; b=LZ2cLEhA6aRIbiYlkRzM8DSyD+e2VpUTrt6TgOpbeUYT1sq4Rv040EtBhwc7nErdWMSMoouzkGX/cKEWgv1MUVzOa3fGwThZi40VDebQPuyiYbgNP+RMEDGpEI/jZBGPMeNyzLpvYBFojRzt/rCNyoeK5qmcDYiDo7j2eIkYS7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791563232; c=relaxed/simple;
	bh=bcwmmhNFt+qRQme4ZMk+Lwe36j5GoYDFsy1YbwtHarw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Swaeai9+p6KyzaLMbmfRJIg6oYXREst3F29WYGor7Ki1s0lOOgeFuS9uQ4iT9NG6lLToQrk5qEozHKaHo2Gdtow/AsMGMktfnB4S6OX9s07a05SkpMU/jgnl6QSRDYB0meYYIQOLEUDbZTYtSMvsSZ7RbN8cIX9j9IvCH0blkww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=Rvam/DNF; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="Rvam/DNF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1791563215;
	bh=bcwmmhNFt+qRQme4ZMk+Lwe36j5GoYDFsy1YbwtHarw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rvam/DNFrih6t7HkkNmj4f9ItXFUiIarLCJa7eP/cXpal/Gr04VYpTO+Pw0tmxkdW
	 1eUWbL6jdYv3TO+CEVH+09L6os+uMUXIIZBffdbIzNPmSTPictkvz29qvtOjZA2nlO
	 bV1AwzDYBJ7mIUky/Je0FYvFrq0Y0iYrWl+g7pt8=
Received: from wolf.philpem.me.uk (unknown [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id 21F60BE76C;
	Fri,  9 Oct 2026 16:26:55 +0000 (UTC)
Received: from cheetah.homenet.philpem.me.uk (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id C870C5FC4F;
	Fri,  9 Oct 2026 17:26:54 +0100 (BST)
From: Phil Pemberton <philpem@philpem.me.uk>
To: linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <mkp@kernel.org>,
	Hannes Reinecke <hare@kernel.org>,
	Phil Pemberton <philpem@philpem.me.uk>,
	stable@vger.kernel.org
Subject: [PATCH v10 04/15] ata: libata-zpodd: publish initialized state before registering notifications
Date: Fri,  9 Oct 2026 16:55:11 +0100
Message-ID: <20261009155522.593045-5-philpem@philpem.me.uk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261009155522.593045-1-philpem@philpem.me.uk>
References: <20261009155522.593045-1-philpem@philpem.me.uk>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

zpodd_init() installs the ACPI notification handler before assigning
zpodd->dev and dev->zpodd. A notification delivered in that window can
enter zpodd_wake_dev() with a NULL context pointer. In particular,
initialization retried during EH can already have a suspended SCSI device,
allowing the callback to reach its from_notify assignment.

Initialize the back pointer and publish dev->zpodd before installing the
handler, so every callback observes initialized state. Keep removal of the
handler before freeing the state, as acpi_remove_notify_handler() waits
for queued notifications to complete.

Fixes: f064a20dded8 ("libata: move acpi notification code to zpodd")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
---
 drivers/ata/libata-zpodd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/libata-zpodd.c b/drivers/ata/libata-zpodd.c
index 581eb41ea0f3..c57c49316fbd 100644
--- a/drivers/ata/libata-zpodd.c
+++ b/drivers/ata/libata-zpodd.c
@@ -311,9 +311,9 @@ void zpodd_init(struct ata_device *dev)
 
 	zpodd->mech_type = mech_type;
 
-	ata_acpi_add_pm_notifier(dev);
 	zpodd->dev = dev;
 	dev->zpodd = zpodd;
+	ata_acpi_add_pm_notifier(dev);
 	dev_pm_qos_expose_flags(&dev->tdev, 0);
 }
 
-- 
2.43.0

