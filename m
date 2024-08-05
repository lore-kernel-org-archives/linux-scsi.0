Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048E214A0AD
	for <linux-scsi@vger.kernel.org>; Mon,  5 Aug 2024 23:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722900045; cv=none; b=F/NAseKIckrQfa0iO3klOelIby23m2NznvB5xUqzIPSlaqLvwIzr3cOY7csD+WDXnCoP1DLzFINSJM1rGtNeFvTj2iL6cYYTFeloj78Gaav+UScwhLbNg1Sb6gRf9NQ1BXJCVjsqwa31I5mzSKzR+l/AViM1UOXs4wJklrV4Gr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722900045; c=relaxed/simple;
	bh=pgAURswA+t3rHU/fj5ExWvdeWjL6LaptP1u5vJEU1gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PFHzOQH6/jDA+BimbTo9gq+uxpp2KLDG0v5MhW12i0ZMa5CA7EVdASSrduHyLLdbleZixbl5CjcwcH6asBdxVYnFpnDBIkT8eXLb3AszUazKD0Baqq/fCR3m8PJ95wSZlvdQZPtJe82gnks8jwYIRqk9IlAHOW32OUPFIV2frqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Pvdsg/Af; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Pvdsg/Af"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WdC960RC0z6ClY9C;
	Mon,  5 Aug 2024 23:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1722900038; x=1725492039; bh=K31dC
	3OCWxXKwSXFGb9jxV9EkPYqC/Fm/a9pLsKX2Mk=; b=Pvdsg/AfbWVNh3nxHugXI
	CK3Xu/hhPIX/mdgC9wWNmYOBP1d7WQZt0pKTvfcir3Gq4pxIkYVuxaRsgPCRSmhf
	EhgKUtdLteyAw8Alpb/CbYkZHTKT5LpDMh41MfnBwMoc60MoPE9K3cIrB+8+fs2U
	N0pt8+Von5GswUamecWOWT8+YG8kAes8G/ZpUqW3ZaY6xl16Q9VaX/RjimZEq3Y+
	0y43Y55mwu/HzMeqZkC13FsMS+rQufm1rM4F2zLCJka8ZZ5j3v5rSuwM4jc6gtfn
	LrtAj+KlnXykTgPPIKKwAAPnY1GjfO3aG5Q4atdsdEr1Ix0QMi3OyY34HYMqmAwd
	A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id M4oZ0-mW3EsC; Mon,  5 Aug 2024 23:20:38 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WdC912CLVz6ClY9D;
	Mon,  5 Aug 2024 23:20:37 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Genjian Zhang <zhanggenjian@kylinos.cn>,
	"Ricardo B. Marliere" <ricardo@marliere.net>,
	Sumit Garg <sumit.garg@linaro.org>,
	Alex Elder <elder@kernel.org>
Subject: [PATCH 2/2] mips: sgi-ip22: Fix the build
Date: Mon,  5 Aug 2024 16:20:21 -0700
Message-ID: <20240805232026.65087-3-bvanassche@acm.org>
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
Fixes: d69d80484598 ("driver core: have match() callback in struct bus_ty=
pe take a const *")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 arch/mips/sgi-ip22/ip22-gio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/sgi-ip22/ip22-gio.c b/arch/mips/sgi-ip22/ip22-gio.=
c
index 2738325e98dd..d20eec742bfa 100644
--- a/arch/mips/sgi-ip22/ip22-gio.c
+++ b/arch/mips/sgi-ip22/ip22-gio.c
@@ -111,7 +111,7 @@ void gio_device_unregister(struct gio_device *giodev)
 }
 EXPORT_SYMBOL_GPL(gio_device_unregister);
=20
-static int gio_bus_match(struct device *dev, struct device_driver *drv)
+static int gio_bus_match(struct device *dev, const struct device_driver =
*drv)
 {
 	struct gio_device *gio_dev =3D to_gio_device(dev);
 	struct gio_driver *gio_drv =3D to_gio_driver(drv);
