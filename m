Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8161181D01;
	Wed, 12 Jun 2024 16:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718211203; cv=none; b=IlOYXAoARzuwMDr1AFyqrm3hrNanDFkKMPhax+Jf12kLepotgZ0gKBiUAuPO2umS33LEROgq1Btb2TX6PAPkcrBLZvAc47fjzN2F9AEmX2PhZJSvAagu43lsdiJEDtQ2DSwdPG2LrFMQHyZYn11hIIOXL9lDpPY9+Oetoww2ufE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718211203; c=relaxed/simple;
	bh=GnXrini9kvjKB6PymCGTaMHkBYBaav4pYss53a8Nv74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iwViwaSxKQkvBmtd3t0hT+n+ZFsE3HFOAmz8TAy5tfcLjyszXuXK7nGh1J4cEdenrJxaXWJselJsFXb2RzfZ6aqzuIde/ZZGxS7UybzfOAVcrGb2pUuICQR0jGxtU4847t47bdROdgGx4XwNVokZzrDYAozYi5QJo9IYlnWwfu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=pN5+8aWM; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="pN5+8aWM"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Vzs730bBBz6Cnv3Q;
	Wed, 12 Jun 2024 16:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1718211194; x=1720803195; bh=OykQL
	Uc2yA9sX2reQeKvyYOC/XKz0F9amrbbyilPiMc=; b=pN5+8aWMIixdbxBKKSBIR
	PgZVor3vcZykzDPJzktRphPMgMoELWA/IsfGPwVzncJE8bzUmzCDMdcRMQe70HcK
	S6eSQJadlG4ZPN2vl34GQ/g8iY4AMS2r0vk0dUfA/R4qBSu0dvUaLwQrXane7tgi
	2Ix29dgtMi/jkHBYWFFXmA3OTjfAm48tobbFn0w3YyfcmRmUdYdILUJbOcFRvcbQ
	jUdukUlt4JQhGAOX8L9uIRqn24jDIu2DMfsjOXTfhIezv6pN5C3yGoUHUuU+EgGR
	IFQ4/5o4bYZXjYBH0SLJnzyENX355Bqc4pioBZ+F9s+L+6cGsT6xMlISC8JUPFXq
	g==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 9pPfjm44_aos; Wed, 12 Jun 2024 16:53:14 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Vzs6x25ghz6Cnv3g;
	Wed, 12 Jun 2024 16:53:13 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
	linux-scsi@vger.kernel.org,
	linux-usb@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Joao Machado <jocrismachado@gmail.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Christian Heusel <christian@heusel.eu>,
	stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 2/2] scsi: core: Do not query IO hints for USB devices
Date: Wed, 12 Jun 2024 09:52:49 -0700
Message-ID: <20240612165249.2671204-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
In-Reply-To: <20240612165249.2671204-1-bvanassche@acm.org>
References: <20240612165249.2671204-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Recently it was reported that the following USB storage devices are unusa=
ble
with Linux kernel 6.9:
* Kingston DataTraveler G2
* Garmin FR35

This is because attempting to read the IO hint VPD page causes these devi=
ces
to reset. Hence do not read the IO hint VPD page from USB storage devices=
.

Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org
Cc: Joao Machado <jocrismachado@gmail.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Christian Heusel <christian@heusel.eu>
Cc: stable@vger.kernel.org
Fixes: 4f53138fffc2 ("scsi: sd: Translate data lifetime information")
Reported-by: Joao Machado <jocrismachado@gmail.com>
Closes: https://lore.kernel.org/linux-scsi/20240130214911.1863909-1-bvana=
ssche@acm.org/T/#mf4e3410d8f210454d7e4c3d1fb5c0f41e651b85f
Tested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Bisected-by: Christian Heusel <christian@heusel.eu>
Reported-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Closes: https://lore.kernel.org/linux-scsi/CACLx9VdpUanftfPo2jVAqXdcWe8Y4=
3MsDeZmMPooTzVaVJAh2w@mail.gmail.com/
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/usb/storage/scsiglue.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglu=
e.c
index b31464740f6c..9a7185c68872 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -79,6 +79,8 @@ static int slave_alloc (struct scsi_device *sdev)
 	if (us->protocol =3D=3D USB_PR_BULK && us->max_lun > 0)
 		sdev->sdev_bflags |=3D BLIST_FORCELUN;
=20
+	sdev->sdev_bflags |=3D BLIST_SKIP_IO_HINTS;
+
 	return 0;
 }
=20
