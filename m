Received: from forward102d.mail.yandex.net (forward102d.mail.yandex.net [178.154.239.213])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76142E413;
	Sat,  1 Nov 2025 08:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.213
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761986762; cv=none; b=qChXUAjadHD0qxczRW4iv3Wr28IJAUYXL77LI7wF9/pOGOKD7tDhObh5aVU7UA8/HdJnhr5r1XOtIusA8ahJsF3Vu4M+Mt97oJcl8xgkys6qxZdnrrnOtYyKWLjYPQwUHT/aNioKltul9Q5nIbi4MUfn47dE6QwcAyQHSV95T1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761986762; c=relaxed/simple;
	bh=MiSNbImamJAeG6qVM7lPWJcD7rUUYB+gl/D/eCejcz8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=s//QxP3AGX0mvv+ut7ZZ+Pa63Wa2jMy18wlb1MXlyvwvEZucQHuwrfSj4BLRThMuwDjuSWlKXIMGLDOk2eMDbkPXyW8AX9scMnYhM5KTopIq6nfoWOKRnXnWS7yswv+Z/HmCp5iL6YAVDrqv+q0LJ2PE4nILad9vb+g6XDo7v8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=pOn36EQX; arc=none smtp.client-ip=178.154.239.213
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="pOn36EQX"
Received: from mail-nwsmtp-smtp-production-main-95.klg.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-95.klg.yp-c.yandex.net [IPv6:2a02:6b8:c42:2a21:0:640:9c41:0])
	by forward102d.mail.yandex.net (Yandex) with ESMTPS id E3011C0017;
	Sat, 01 Nov 2025 11:45:54 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-95.klg.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id rjcvGoBLIGk0-VJr80xMQ;
	Sat, 01 Nov 2025 11:45:54 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1761986754; bh=wU/WgYfevpdN1x884hcDbNGKdz4hZOvVHa3GTpWNm2A=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=pOn36EQXZRSAYXL3TXZmEC2V/65ku3GlBA/z9xAIDpEk7gXXAqLFTL66KqMER14tg
	 qbfXFfj1/BI9n2mxQ9Z6TNGdGInlWXB0NOOrkJxezjDu5uiVM6fKAzcdw+tFKp9wxe
	 ZCUb0FEGnUMMat8WC6RxmwwRT+AUDWqbEKKDJcOg=
Authentication-Results: mail-nwsmtp-smtp-production-main-95.klg.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH] scsi: target: core: simplify target_fabric_make_mappedlun()
Date: Sat,  1 Nov 2025 11:45:49 +0300
Message-ID: <20251101084550.383624-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In 'target_fabric_make_mappedlun()', prefer convenient
'kstrdup()' over 'kzalloc()' and 'snprintf()'.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 drivers/target/target_core_fabric_configfs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 7156a4dc1ca7..80aece81d1a1 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -275,12 +275,11 @@ static struct config_group *target_fabric_make_mappedlun(
 	unsigned long long mapped_lun;
 	int ret = 0;
 
-	buf = kzalloc(strlen(name) + 1, GFP_KERNEL);
+	buf = kstrdup(name, GFP_KERNEL);
 	if (!buf) {
 		pr_err("Unable to allocate memory for name buf\n");
 		return ERR_PTR(-ENOMEM);
 	}
-	snprintf(buf, strlen(name) + 1, "%s", name);
 	/*
 	 * Make sure user is creating iscsi/$IQN/$TPGT/acls/$INITIATOR/lun_$ID.
 	 */
-- 
2.51.0

