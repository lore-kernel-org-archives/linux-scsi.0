Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D701114A0AD
	for <linux-scsi@vger.kernel.org>; Mon,  5 Aug 2024 23:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722900039; cv=none; b=KSNwKB0QT+bwxicA3ZD6K5kpddXj4vsDmRdOdsB/SsWZ9vniPj9bntQpG6kOeMoNVymNmXuJ426GiuAjG+S2KMfRG4ZrWrMS+DEm1QcXxeEPlJkzOBtM+UwyOjeuutvMBBUxrxv0iRCTwFeHUVJMWFiDsgHfVr5EzL1z8XovTig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722900039; c=relaxed/simple;
	bh=KQdrpXULtcXJj7qkf2pwZwPE8UT/Q8M3aEaJPKJdjXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jbZ5MsvJ1pCLulImCc9T+s3QbO2cMLd4WRGJwEXRo1xk+yLcEc373WeBLIQE3WLYj4UNscz8eNA5goSG4m84nf2IogmiJSyCy5A7wOri7lGy+8ZCSAFPRNg9DN07AsPQPXNIRNHiQX6K9sWvJ3VOXj/igLEXfKJ5i83BV0J9Q9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=MEa4ZQ4m; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="MEa4ZQ4m"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WdC904rhXz6ClY99;
	Mon,  5 Aug 2024 23:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1722900033; x=1725492034; bh=iPlwl
	QOesAt+5MAf74953zCaHZ7g2MbBTOGNcxAjxcQ=; b=MEa4ZQ4mrTuQSIqU+E/sq
	n1KT8OmQU7G67PmliN8NfpY0ptCfc7ojspF0k9Aq3+oeCphc+5jlydq033R4XoNb
	nUxBwD4CfydOv3OivuN26mnEdx5zSQTLLuQAIMTedmgceBgZCfFuYVk+JV9XFdy3
	YlSWnUWgFd6iaP3TOx1KFuijKOFrwi/l5RQkLUq0iMR6hSpY7N12jbFhig8BjN/f
	dZr7utvv7qZIlQvTrmvv5MgrBNB6rHXEUCGqNRKFXFL1jqibVAQllupAH3qNi0hc
	uQFKyt0Kby5O5NVrQ14V0Y1ReBpsaHn/9jNdfcFTnnUmcwLF+2s4a7cMzJtEdqP0
	A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id VOaX2lBQc3xN; Mon,  5 Aug 2024 23:20:33 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WdC8w6d3cz6ClY9C;
	Mon,  5 Aug 2024 23:20:32 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Russell King <linux@armlinux.org.uk>,
	Sumit Garg <sumit.garg@linaro.org>,
	Alex Elder <elder@kernel.org>
Subject: [PATCH 1/2] ARM: riscpc: ecard: Fix the build
Date: Mon,  5 Aug 2024 16:20:20 -0700
Message-ID: <20240805232026.65087-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
In-Reply-To: <20240805232026.65087-1-bvanassche@acm.org>
References: <20240805232026.65087-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Fix a recently introduced build failure.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Russell King <rmk+kernel@armlinux.org.uk>
Fixes: d69d80484598 ("driver core: have match() callback in struct bus_ty=
pe take a const *")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 arch/arm/mach-rpc/ecard.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-rpc/ecard.c b/arch/arm/mach-rpc/ecard.c
index c30df1097c52..9f7454b8efa7 100644
--- a/arch/arm/mach-rpc/ecard.c
+++ b/arch/arm/mach-rpc/ecard.c
@@ -1109,7 +1109,7 @@ void ecard_remove_driver(struct ecard_driver *drv)
 	driver_unregister(&drv->drv);
 }
=20
-static int ecard_match(struct device *_dev, struct device_driver *_drv)
+static int ecard_match(struct device *_dev, const struct device_driver *=
_drv)
 {
 	struct expansion_card *ec =3D ECARD_DEV(_dev);
 	struct ecard_driver *drv =3D ECARD_DRV(_drv);
