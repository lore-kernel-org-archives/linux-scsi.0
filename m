Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795533443;
	b=OEEnqlVJwLPgjjxC1ERIVnZNAgKAsWZl+s5mH2hEq//r22eoklkIaJ84U1r+Cz9vymNK
	 uT5aXZG7pyd74OIb57AoZeu+gQtWVC7P3lcrdZH+tCkto9ZS24B5a4fk5tCGAjOCMT3BW
	 NhOXtJg9Vr31p97Q+ZSfP5DbnJ7Cy7O/JLQDjQQYKPbH+kYvmrd+FL6ACyshPuYXwyY/y
	 oMokkk7QWNUfP44NudqXlYvNVkBKCXbwzxfjIXULJadwnhuJpnRrEXxY7KAWVHTCRf2ac
	 JmxzDSs5M30zjDsBlmvRlKr3ickK/Sx9/08aO+pc9DlLhsv/AjEqvOHjsANe4kvr9dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795533443;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:MIME-Version:Content-Transfer-Encoding:X-Scanned-By;
	bh=NInVpi9m9+7xtPHG/vNnoru7PXN05LiAEU7EjFn1UrY=;
	b=yKyA5QdGTXVHhwN+R5m4G4X6IHLFtNBeL6iZptAGK2kvi83OY2qc8BBwGHhgUfaWD7+X
	 lKVFXhzwdBk0HSWZ2BWhJdZ6SuNBEwNKBOFSHy7oV7zybD+98dH4NaiDzBGOiF5w2WL4T
	 viU/JSNQTFcqKf5JEBjrIopmn5ZbK8xzWyCLy4X0JZlLqRHw9FwIuNfzAmxDSlhOuxLTB
	 Uye1kR9TjxpSrbAI7uROY8mlJopjBjsPLP/m/TLtmwoCQhmei0BEvJ23/TMcsRROZFj2G
	 tWAhM1tQeAQgZPfVGS83SpN2yRNLcsWpMsP5sf3ww8zf5RZH2Uu2ReqKqz4hRpLuxDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=YTCIc+aQ;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75533606A321
	for <linux-scsi@vger.kernel.org>; Tue, 24 Nov 2026 15:17:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 75533606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=YTCIc+aQ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795533441;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=NInVpi9m9+7xtPHG/vNnoru7PXN05LiAEU7EjFn1UrY=;
	b=YTCIc+aQn98Y22b/pUHYdSTNR7LzisaIJJU6+nvlwMrDlw4sWmamxWczs89MARvXiFqvo4
	H5mq3pRmCgsNXO3eQLs2hTD74FsIiGS+YXNTyEuUt/pQ3A2ez6OlKUiPZctmMrhIXANm7k
	9riKGAc20C1BmxORBQ1dGh1K+KJkEcw=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-609-ClvOeDGhOb-tVRlfd4IFXg-1; Tue,
 24 Nov 2026 15:17:14 +0000
X-MC-Unique: ClvOeDGhOb-tVRlfd4IFXg-1
X-Mimecast-MFC-AGG-ID: ClvOeDGhOb-tVRlfd4IFXg_1795533433
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CACA418045E0;
	Tue, 24 Nov 2026 15:17:11 +0000 (UTC)
Received: from jtaubepe-thinkpadx1carbongen12.ibmlowe.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A8F4618011E8;
	Tue, 24 Nov 2026 15:17:10 +0000 (UTC)
From: Jesse Taube <jtaubepe@redhat.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Jesse Taube <jtaubepe@redhat.com>
Subject: [PATCH] aic7xxx_core: Avoid shift overflow in aic7xxx init
Date: Tue, 24 Nov 2026 10:17:09 -0500
Message-ID: <20261124151709.169575-1-jtaubepe@redhat.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

When built with _FORTIFY_SOURCE there was a shift overflow in ahc_init.
Target mode was conditionally disabled based on `ahc->unit` which was
initialized to -1 and later is set to the real unit number.
The Linux kernel does not support target mode so undconditionally
disable target mode.

Signed-off-by: Jesse Taube <jtaubepe@redhat.com>
---
 drivers/scsi/aic7xxx/aic7xxx_core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index b9761f9f0bbc..eeae5965f79f 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -5276,10 +5276,9 @@ ahc_init(struct ahc_softc *ahc)
 	ahc->flags |= AHC_INITIATORROLE;
 
 	/*
-	 * Only allow target mode features if this unit has them enabled.
+	 * Only disallow target mode features.
 	 */
-	if ((AHC_TMODE_ENABLE & (0x1 << ahc->unit)) == 0)
-		ahc->features &= ~AHC_TARGETMODE;
+	ahc->features &= ~AHC_TARGETMODE;
 
 	ahc->init_level++;
 
-- 
2.56.0

