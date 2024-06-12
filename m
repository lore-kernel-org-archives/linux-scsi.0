Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C922E84FB7;
	Wed, 12 Jun 2024 20:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718224673; cv=none; b=mw3B7fsur3xBklFjCebqXro+dZbF1W56YbnoLkHJAmDVdkRCxyP6gYpXDaabJ1qNAiabqmVBvIDjVM40Vj9Hm8qOcru0294jzCqC2xSXkLcaaNCZQxsdzKX0Eg/xXpoOmzW/v1GUq4aGX5TGl7kW6onfDhc2evtHMMF1Q3hQxHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718224673; c=relaxed/simple;
	bh=P6YdIf+4h9Mbh9g27KC45uffOCN8bhGX+6xrXGja70g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qesKk0HRkJFqULcFT21kW/BPcbab6/cMTdkcOsZ1rC9DMVUtfaQsCLrUxa7i8kpyiVmLlAfA2siVOcl3OERfA+vrDd1xQoEFex0NRlGQQinq5owdSv4FLWf1+iyZDdxIyCm1/CGAWRyjImk7BTTa8yW4RKUpM2mESMeXKpYOkpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=c3RB1txl; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="c3RB1txl"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Vzy673jwwz6Cnv3g;
	Wed, 12 Jun 2024 20:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1718224664; x=1720816665; bh=vkQHJ
	TTJIwL9c+V0Yep/xL4oLUQVR0FrLfLA/m0LXvA=; b=c3RB1txlv0ZhRUvtUzF5C
	oyLtvY4KZ6BFV/kxYGR/rCofpz6ld4hik7ATC7+b01pZIcOTF6rq6f7EnT0/gs61
	XbVuW6ODBrzDv13OYwk4vFOnKRJ5Gmv4xPB37z8lNCMqG+6AsguJYJsRtvrQCZab
	EOy1HaYVA3L287J4OgzPt5tF9iD7HrG1dGOr9jrdeDhcVqUPMfgY3wCbIatJNTmR
	dZo9BjMG4mcmTSTrdPtKWLoFVGlpg90uqYu/5Hzsf4/VuCl0me6KmYVLfWvTrKb9
	TVGdA88GvNfobr0ckF0XdXPSguBcd7VT1REqtrgDBN+yrqYug7dMiMsYKNa3h3DD
	Q==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id wX-nDI5cUhJu; Wed, 12 Jun 2024 20:37:44 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Vzy600hxFz6Cnk9Y;
	Wed, 12 Jun 2024 20:37:44 +0000 (UTC)
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
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH v2 2/2] scsi: core: Do not query IO hints for USB devices
Date: Wed, 12 Jun 2024 13:37:34 -0700
Message-ID: <20240612203735.4108690-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
In-Reply-To: <20240612203735.4108690-1-bvanassche@acm.org>
References: <20240612203735.4108690-1-bvanassche@acm.org>
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
 drivers/usb/storage/scsiglue.c | 6 ++++++
 drivers/usb/storage/uas.c      | 7 +++++++
 2 files changed, 13 insertions(+)

diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglu=
e.c
index b31464740f6c..b4cf0349fd0d 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -79,6 +79,12 @@ static int slave_alloc (struct scsi_device *sdev)
 	if (us->protocol =3D=3D USB_PR_BULK && us->max_lun > 0)
 		sdev->sdev_bflags |=3D BLIST_FORCELUN;
=20
+	/*
+	 * Some USB storage devices reset if the IO hints VPD page is queried.
+	 * Hence skip that VPD page.
+	 */
+	sdev->sdev_bflags |=3D BLIST_SKIP_IO_HINTS;
+
 	return 0;
 }
=20
diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index a48870a87a29..77fdfb6a90c8 100644
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
+	 * Some USB storage devices reset if the IO hints VPD page is queried.
+	 * Hence skip that VPD page.
+	 */
+	sdev->sdev_bflags |=3D BLIST_SKIP_IO_HINTS;
+
 	sdev->hostdata =3D devinfo;
 	return 0;
 }
