Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E636B4EFFD2;
	Fri,  9 Oct 2026 16:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791563223; cv=none; b=oPlwci5BCqqWEszsFl+j2/Mgcs6JOtQ4i0L+KVxw+jYeOxGASOLnIMtKK6uY5KWrlSs3nwoRw9Drx24/Oe1vbVF5VRQIQ4sLIobJR+WCDWzOftGBp0cIHsXUR+u3rB6CpWPNJBFi3hrIn3VNWud68VgGstK6Rl++sF43zgCwU9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791563223; c=relaxed/simple;
	bh=e66Ku4eMrlZk9Mf7DZypUZoYGLT8LlKStT42+SIKXuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pbXfc3z9xLoLqly7uluZvbnMM+/EIfGp3AUnbjVoYcEik1/GSGK2GMEiPn3kMAslAQE4pOfDRCaemCFdIF+MxknnBx2/6IM6uKdTSVZl0ok75lhaFZTh+zvvFbV7t5c4O+t7NvnmZLqUWxiMbiSm8ow4pwzODtuCtSNysj/PdSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=YmrphajS; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="YmrphajS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1791563214;
	bh=e66Ku4eMrlZk9Mf7DZypUZoYGLT8LlKStT42+SIKXuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YmrphajSyNAhzV4mwFhJRv/ZhHTbGasz8DizvrVSmmiF2rhwyJTDI4yMFrVvDRsT5
	 c9Yoxwl6Pfis2M8mKfAjIGD2GMYiV+ABJfyESeGQizX2JQssEB1Zn+IrPr9u+zcerg
	 zYq1yfOqS0qtW5rLz1VUGDsZ2RxbmILp/IeJwbcU=
Received: from wolf.philpem.me.uk (unknown [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id DB362BE58A;
	Fri,  9 Oct 2026 16:26:54 +0000 (UTC)
Received: from cheetah.homenet.philpem.me.uk (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id 993535FADC;
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
	Phil Pemberton <philpem@philpem.me.uk>
Subject: [PATCH v10 01/15] ata: libata-acpi: pin the SCSI device while emitting a bay event
Date: Fri,  9 Oct 2026 16:55:08 +0100
Message-ID: <20261009155522.593045-2-philpem@philpem.me.uk>
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

ata_acpi_uevent() reads dev->sdev without taking a reference. SCSI device
removal can clear the pointer and release the device after the notifier
has obtained its kobject, leaving kobject_uevent_env() accessing freed
memory. Dock notification ordering does not exclude independent SCSI
removal, such as deletion through sysfs.

Acquire a SCSI device reference while holding ap->lock, which protects
clearing dev->sdev during removal. Emit the event and drop the reference
outside the spinlock because both operations may sleep. Preserve the
existing port-level event behavior and skip devices that cannot be pinned.

Fixes: 1253f7aabfeb ("dock: introduce .uevent for devices in dock, eg libata")
Assisted-by: LLM
Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
---
 drivers/ata/libata-acpi.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 4433f626246b..bee738b68b3f 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -149,19 +149,29 @@ static void ata_acpi_uevent(struct ata_port *ap, struct ata_device *dev,
 	u32 event)
 {
 	struct kobject *kobj = NULL;
+	struct scsi_device *sdev = NULL;
+	unsigned long flags;
 	char event_string[20];
 	char *envp[] = { event_string, NULL };
 
 	if (dev) {
-		if (dev->sdev)
-			kobj = &dev->sdev->sdev_gendev.kobj;
-	} else
+		spin_lock_irqsave(ap->lock, flags);
+		sdev = dev->sdev;
+		if (sdev && scsi_device_get(sdev))
+			sdev = NULL;
+		spin_unlock_irqrestore(ap->lock, flags);
+		if (sdev)
+			kobj = &sdev->sdev_gendev.kobj;
+	} else {
 		kobj = &ap->dev->kobj;
+	}
 
 	if (kobj) {
 		snprintf(event_string, 20, "BAY_EVENT=%d", event);
 		kobject_uevent_env(kobj, KOBJ_CHANGE, envp);
 	}
+	if (sdev)
+		scsi_device_put(sdev);
 }
 
 static void ata_acpi_ap_uevent(struct acpi_device *adev, u32 event)
-- 
2.43.0

