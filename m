Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A9415DBC5
	for <linux-scsi@vger.kernel.org>; Wed, 28 Feb 2024 22:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709161159; cv=none; b=svH2NaISfaa/H0ilgqbCc234CByYlJLZUbEN6qzzZGUb7wziURv1GG7ZYZXo+Z709NQc9/SEH4dw1z4oJyL3XGT4X5Wwkt/z7E5kQxZTq6jEKZUPeY1kWJA5Wz5xeKgOOsWUt9Ycwnx6DoUkURHVbAjaWtoeKBOqY1c561tzvRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709161159; c=relaxed/simple;
	bh=sByDsDMKp44vyq2pot5Hhxm/eaP0ttE9ltVB3LqVHFs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RYyajHDqD7BBl/9ni/kF1OeUhyOHeEuhK8Ycm2Q1z/R49Fu52+PRQGO+rD5+q182Yi6NKh3/FaLndmVgkwH4Vj+pf0QSLxB8O0NASX/UYXJBC5EZryEmgfl4EnjEOCqr2y7BND80bmfR1Can/kAuS5SNSVoeaQyh56FRtC0DRyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--justinstitt.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x7FQIIbi; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--justinstitt.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x7FQIIbi"
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-36576ec006aso3702145ab.1
        for <linux-scsi@vger.kernel.org>; Wed, 28 Feb 2024 14:59:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709161157; x=1709765957; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YAj5OZXxeaW4sKlBVmOyaWiE/dDaeK+k40BuTuu533I=;
        b=x7FQIIbiUTu8GEWN+AawAD1f6igoVfjJyAGlagzRpY4ZMwmrpQBQ370WbKMVvyJnip
         p9gK4lILU51xV0OTG+Lvb10hA1fIzcOUKq6L+GZjHVlVKNTQsu+e2WUhw/Ioadiuu7Eh
         cHiitHCRQ3PL8HP8gWrcViZIT8MUn13REIhbsGbC0ZKIVEOnTZD2pcORiLGTrWEo/GkD
         eGT9EFaOpFMEehUh+fi65Sz02YD6f7lSAsS3ZZsVDFLO/d6TOLGpPI3Q5VMoDPM1GlVX
         +5iksbasBiZp4rwR9GfEaYQc80Ika3S3bxBwFkR6QVLuuj66jo8A86wHRBNVFtgLPVVh
         XMig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709161157; x=1709765957;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YAj5OZXxeaW4sKlBVmOyaWiE/dDaeK+k40BuTuu533I=;
        b=gLQY/PrDZccVbQx5fYRgIAnb8r45BEygZ8n7q9W57eY2Dk0G8QqcBp61Znun2ad4si
         BjbFZHtX5+bkAboHGiNZb0ZsuMVciK1cSaJx/9I28pksOmMmDm2bqpbdKJ1iRGMvhPLp
         dVID6YMME08aijIYkW++d1qecagGMdsyOKJw0nC2jYnuR05YPL35BH6S1hgoe2hiMgMD
         1Zi+dQ3jbH8/W5vAt5xqW37DYN3WJOcSnGsFmiRc+/5EJ+81n0ivVE5E6bJrUS71u0eh
         QOeLm+KJs7q5Ew6o0AnM39n4gBke7r/RNsgvSuGIZfVLsODIOXpcRmtf2NCqvO2BJH/E
         YpBA==
X-Forwarded-Encrypted: i=1; AJvYcCX+EG5UlOYK2Aq8b6unsT+IJpX/Zuemu9LZ0QxkGR6B3v9QJzQ5g3ssmz6F3ijxrMGNpszj1Qrr5E/9HBXNGd14bRHoUBv3+wQ/aA==
X-Gm-Message-State: AOJu0YyY0Z4hMOsNM+pIq5WtoIMyMXgICWsSmMo6mH2tLKUZeavKuvbJ
	RTMdPlb9VDy8Wx2mP+hDKdOCxBofGBpHZjUtxR4jKpLCABo6P1VBf3VwqtGc77JJFYXyz7ioVm9
	XpD6ccWnahnKB5Z1iumlMKw==
X-Google-Smtp-Source: AGHT+IHoQVSAKtTKWMR9HqVfcdvMQJ5TQ9kT4Qfz/mA8h9PaGzJ6iHCM0QJAjUXmqcpaYEmHg0FOvRz7HtCHG9nbhg==
X-Received: from jstitt-linux1.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:23b5])
 (user=justinstitt job=sendgmr) by 2002:a92:c563:0:b0:365:21f4:700d with SMTP
 id b3-20020a92c563000000b0036521f4700dmr34184ilj.2.1709161156751; Wed, 28 Feb
 2024 14:59:16 -0800 (PST)
Date: Wed, 28 Feb 2024 22:59:06 +0000
In-Reply-To: <20240228-strncpy-drivers-scsi-mpi3mr-mpi3mr_fw-c-v2-0-dacebd3fcfa0@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240228-strncpy-drivers-scsi-mpi3mr-mpi3mr_fw-c-v2-0-dacebd3fcfa0@google.com>
X-Developer-Key: i=justinstitt@google.com; a=ed25519; pk=tC3hNkJQTpNX/gLKxTNQKDmiQl6QjBNCGKJINqAdJsE=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1709161149; l=1441;
 i=justinstitt@google.com; s=20230717; h=from:subject:message-id;
 bh=sByDsDMKp44vyq2pot5Hhxm/eaP0ttE9ltVB3LqVHFs=; b=MQmDO4s1joPg8qz5k1DfkUDPX+8AhggVdiQ9eJscb4HSloFwaCNCdz/nFzT/ALueyz6YmZ8NY
 6fbXI+QlUapD1QbsdKWY+t/Yuw1thXdsz72jHdrFaniAPlmI60I+0Zw
X-Mailer: b4 0.12.3
Message-ID: <20240228-strncpy-drivers-scsi-mpi3mr-mpi3mr_fw-c-v2-6-dacebd3fcfa0@google.com>
Subject: [PATCH v2 6/7] scsi: smartpqi: replace deprecated strncpy with strscpy
From: Justin Stitt <justinstitt@google.com>
To: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, 
	Sumit Saxena <sumit.saxena@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, 
	"James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Ariel Elior <aelior@marvell.com>, 
	Manish Chopra <manishc@marvell.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Saurav Kashyap <skashyap@marvell.com>, Javed Hasan <jhasan@marvell.com>, 
	GR-QLogic-Storage-Upstream@marvell.com, Nilesh Javali <njavali@marvell.com>, 
	Manish Rangankar <mrangankar@marvell.com>, Don Brace <don.brace@microchip.com>
Cc: mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org, 
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kees Cook <keescook@chromium.org>, MPT-FusionLinux.pdl@broadcom.com, 
	netdev@vger.kernel.org, storagedev@microchip.com, 
	Justin Stitt <justinstitt@google.com>
Content-Type: text/plain; charset="utf-8"

buffer->driver_version is sized 32:
|	struct bmic_host_wellness_driver_version {
|	...
|		char	driver_version[32];
... the source string "Linux " + DRIVER_VERISON is sized at 16. There's
really no bug in the existing code since the buffers are sized
appropriately with great care taken to manually NUL-terminate the
destination buffer. Nonetheless, let's make the swap over to strscpy()
for robustness' (and readability's) sake.

Signed-off-by: Justin Stitt <justinstitt@google.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index ceff1ec13f9e..bfe6f42e8e96 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -1041,9 +1041,8 @@ static int pqi_write_driver_version_to_host_wellness(
 	buffer->driver_version_tag[1] = 'V';
 	put_unaligned_le16(sizeof(buffer->driver_version),
 		&buffer->driver_version_length);
-	strncpy(buffer->driver_version, "Linux " DRIVER_VERSION,
-		sizeof(buffer->driver_version) - 1);
-	buffer->driver_version[sizeof(buffer->driver_version) - 1] = '\0';
+	strscpy(buffer->driver_version, "Linux " DRIVER_VERSION,
+		sizeof(buffer->driver_version));
 	buffer->dont_write_tag[0] = 'D';
 	buffer->dont_write_tag[1] = 'W';
 	buffer->end_tag[0] = 'Z';

-- 
2.44.0.rc1.240.g4c46232300-goog

