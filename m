Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C15A1149DF7;
	Thu, 13 Jun 2024 21:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718313543; cv=none; b=uVm4WrEFAURZOURxmWuaWspIaBcPWW59cTTXonk47t2cLyHtVv+2cunLDC4B8nBvY/E0HHqbHPhEfUDCto6jomMfxfPshce/6mwwDx+dTJBSHQdRXzZHw4ncjXPcna9DzhpY/HOZ9ZmSkEEFDLXQgAnclQ339UF2g+uh3Q1oVog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718313543; c=relaxed/simple;
	bh=tZvJB1zZMlZ/8ONQM8FRNxl/VRbTmnA/DEVVz4TVs9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sWStXt52dl91ckZvsT6gmxdfa1rv232OtR19DXCPGhFaFwdur5P1G1A90sXALElp+s7uo0oCR4mC8aeddOHNFVyLNvmKEP+mpB3nm6kHPkCzVJRi8eDEbVPO7kyx3mygmWOwd09tMIG9OqYqOqEnJ0fuL6ewmgZojteQw5o8wno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=X10ZHZc9; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="X10ZHZc9"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4W0Zz91nL8zlgMVW;
	Thu, 13 Jun 2024 21:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1718313535; x=1720905536; bh=3P4N3
	+6ifBdgnmu9uA3MOujTvZ1LycpwhELSBY2Mf2o=; b=X10ZHZc9rqFtJO7Ji/Ayc
	K9dz9pkQ8tiTkTorj+wKLoRScQaB0zb4p0SxXhM/6Bk7dEMewrGW8giZlmTSPJQ2
	EUdLSM6cAD8vOUbxEam3aO3EUhROu1gCeQqa4oGFR1uW4orW2r067BSoxXjB5r2w
	i3YgwBucT3bf4MP9uYpw4q41VRJeIMarmudJkHMvkwbHa+yk0fRSHH/0CCgZc3XU
	tcbx7dPd0z03EcOPXRChnxu2bU1quEStvxqHxcWI/UnU2SJnGEPeiIxI2pi5NAbV
	6v+EuWywGM1N4oDGgSEAuDSg22SnuS6Wc25Z2XiwlHwOWgiUXEvO5j+ERIno4A1K
	g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id CODr6Bz3qUgG; Thu, 13 Jun 2024 21:18:55 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4W0Zz25qZRzlgMVX;
	Thu, 13 Jun 2024 21:18:54 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
	linux-scsi@vger.kernel.org,
	linux-usb@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	stable@vger.kernel.org,
	Joao Machado <jocrismachado@gmail.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Christian Heusel <christian@heusel.eu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH v3 2/2] usb: Do not query the IO advice hints grouping mode page for USB devices
Date: Thu, 13 Jun 2024 14:18:27 -0700
Message-ID: <20240613211828.2077477-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.2.627.g7a2c4fd464-goog
In-Reply-To: <20240613211828.2077477-1-bvanassche@acm.org>
References: <20240613211828.2077477-1-bvanassche@acm.org>
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

This is because attempting to read the IO advice hints grouping mode page
causes these devices to reset. Hence do not read the IO advice hints grou=
ping
mode page from USB storage devices.

Acked-by: Alan Stern <stern@rowland.harvard.edu>
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
 drivers/usb/storage/scsiglue.c | 6 ++++++
 drivers/usb/storage/uas.c      | 7 +++++++
 2 files changed, 13 insertions(+)

diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglu=
e.c
index b31464740f6c..8c8b5e6041cc 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -79,6 +79,12 @@ static int slave_alloc (struct scsi_device *sdev)
 	if (us->protocol =3D=3D USB_PR_BULK && us->max_lun > 0)
 		sdev->sdev_bflags |=3D BLIST_FORCELUN;
=20
+	/*
+	 * Some USB storage devices reset if the IO advice hints grouping mode
+	 * page is queried. Hence skip that mode page.
+	 */
+	sdev->sdev_bflags |=3D BLIST_SKIP_IO_HINTS;
+
 	return 0;
 }
=20
diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index a48870a87a29..b610a2de4ae5 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -21,6 +21,7 @@
 #include <scsi/scsi.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_dbg.h>
+#include <scsi/scsi_devinfo.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
@@ -820,6 +821,12 @@ static int uas_slave_alloc(struct scsi_device *sdev)
 	struct uas_dev_info *devinfo =3D
 		(struct uas_dev_info *)sdev->host->hostdata;
=20
+	/*
+	 * Some USB storage devices reset if the IO advice hints grouping mode
+	 * page is queried. Hence skip that mode page.
+	 */
+	sdev->sdev_bflags |=3D BLIST_SKIP_IO_HINTS;
+
 	sdev->hostdata =3D devinfo;
 	return 0;
 }
