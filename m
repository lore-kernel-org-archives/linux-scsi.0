Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC56D4E7801;
	Fri,  9 Oct 2026 16:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791563233; cv=none; b=AKvfcRVKr3RHKjLQlrajMlXyFFX29bFzV6cO4iQpPIG3fk95WxKNNHNJAuiDa3TTbMiUAQMe+zQE+WnmNBpOBo1flZ5W4Sa1HaFzt2jQ/N8MD73pL05KpOR9vPrPrUCqWUNez/iOdPfvWd8lc4DY8Mf55PmHX3gOC85OrBSkbCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791563233; c=relaxed/simple;
	bh=yC5GID06Zq/vOzDspY8ywGngMQGZ9stBYo9gNhNJnpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nc26ss3aJCSv0Om1esrtleP4Eo4FiLcehkhG/qPTTUhIHwwcuEhXGwZgKHt/CSvql9g7s5iaAm7qOnIXQ59XQbJ9l0XDffuJr1FxlBvBK6vWZwpoMPyRyHat4mPy84ZPOOAt1YmUvRCHbzIHWtHlB+q6GFCH+nsSkOkecWPuwpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=n6iUHJw3; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="n6iUHJw3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1791563215;
	bh=yC5GID06Zq/vOzDspY8ywGngMQGZ9stBYo9gNhNJnpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n6iUHJw3yjqM7MidGyYH/hEm+myI7i3nslUPiiu2jMOS2klM09TWdDjs1NVNh5i0m
	 GFX0PFJJNkYQ88WSgz+kQSGgijvavGGI+D30J/DwkX5tpm3kyv+ziMnYOzd+hcm9YA
	 NopXyrI2uot0uaMn+WCK2dH9pTS4mzdV1uiBRqnU=
Received: from wolf.philpem.me.uk (unknown [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id 4D74DBE772;
	Fri,  9 Oct 2026 16:26:55 +0000 (UTC)
Received: from cheetah.homenet.philpem.me.uk (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id 0BBEE5FADC;
	Fri,  9 Oct 2026 17:26:55 +0100 (BST)
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
Subject: [PATCH v10 06/15] ata: libata-core: pin SCSI devices during port detach
Date: Fri,  9 Oct 2026 16:55:13 +0100
Message-ID: <20261009155522.593045-7-philpem@philpem.me.uk>
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

ata_port_detach() drops ap->lock before removing dev->sdev. Concurrent
sysfs deletion can release the device before scsi_remove_device() uses it.

Take a device reference and clear the slot under ap->lock, then remove
the saved device. Release the reference outside the lock because device
release can sleep.

Use get_device() to hold the reference during host-driver unload, when
scsi_device_get() can fail its module reference check. The SCSI core
uses the same approach for target removal.

Fixes: 84d76529c650 ("ata: libata-core: Fix port and device removal")
Link: https://lore.kernel.org/linux-ide/20260731220740.7E14E1F00ACF@smtp.kernel.org/
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
---
 drivers/ata/libata-core.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 92233fb25051..5518525357ce 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -26,6 +26,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/device.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/init.h>
@@ -6388,10 +6389,15 @@ static void ata_port_detach(struct ata_port *ap)
 	ata_for_each_link(link, ap, HOST_FIRST) {
 		ata_for_each_dev(dev, link, ALL) {
 			if (dev->sdev) {
+				struct scsi_device *sdev = dev->sdev;
+
+				/* The host driver may already be unloading. */
+				get_device(&sdev->sdev_gendev);
+				dev->sdev = NULL;
 				spin_unlock_irqrestore(ap->lock, flags);
-				scsi_remove_device(dev->sdev);
+				scsi_remove_device(sdev);
+				put_device(&sdev->sdev_gendev);
 				spin_lock_irqsave(ap->lock, flags);
-				dev->sdev = NULL;
 			}
 		}
 	}
-- 
2.43.0

