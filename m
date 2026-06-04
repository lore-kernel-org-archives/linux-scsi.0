Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8A447DFBE
	for <linux-scsi@vger.kernel.org>; Thu,  4 Jun 2026 13:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780579206; cv=none; b=KXudeHaGGi0Y1rjprlOrBXcbzsgsfpvzYt2N1Z/sVYEGJ7McKaSLUZY4NQCeMEMoBxnjdQ+gsBiIYX8OsdL4Tbsy/MbdeX4UGT4IxFIyI3xRbRfM7wXxXRG7e11NhXbc75YtiW36cv47ZxZzUxqjU4cyLU/giHiMNCeq5+TYepY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780579206; c=relaxed/simple;
	bh=qLq31BYjVwoita8p3VYbMVHsnGBFQquUbQzcOZAQW8k=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=X9O3yoY1pVzPpWSEblLaROtP1OBsZB01q+k5nk48+2aE9mNCa+HX9pK3Qv+LxOj+VGXh4QekUnwgitdSAMJdcWN00OOcKmyjzPvyMCw6VzLFzKopxKz9BGw1HZdbH8ZvotoYntQvRvyr05pE9e+nVnJ/cY9bGwFfD7mcjAxpc7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i2ujJrb1; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i2ujJrb1"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-4600cbb06deso407438f8f.1
        for <linux-scsi@vger.kernel.org>; Thu, 04 Jun 2026 06:20:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780579202; x=1781184002; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fx/LUhwU/PuBYtkBp+ygwfhlhplOE7zsRH3troT6KA8=;
        b=i2ujJrb1D9nO/hu9cDbPAjhHHqffMnDb38JHEUX+5GcLatPkLsKhFIfYlks2Wl22h4
         dcEUw1W0YE/3jthQ3eg3mZJQlyoC2bliAPxptg0oGLnn7Yy6idbBe1YqbDTerkMfZMpy
         vKCgmT8X2AgSOo7TTewzY/m8VQ/ld/fbrgBrUabZemG8Xa9zfEkrKqUNZENNGGn9EZSR
         C0iHhx/5A798ar2ZDEzvzG2P11xY9BEd1jFIzrBU1YV/inbVmxJIG5pdlAibDoVuuCI0
         k4ske8v9r+xL4MubZsrDnb1WErNVjmyButUPp1D2iV5gFEVreLaJBzDm9hDnwoj5218/
         xzeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780579202; x=1781184002;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fx/LUhwU/PuBYtkBp+ygwfhlhplOE7zsRH3troT6KA8=;
        b=cVDR689//HQ2+60pda6CaDRtPN75Y6dXqgoR0+6HOHbSHhXC5GARMoCvSREXuIgJi9
         3v1Dn3c4PiPP4LuwDz8bGlNbQ5neTX9eTiGuyd+dHbRcJmuhz5XgJJM5Hq9redRUELkb
         qDyFDfqEyG6CLqIFBqNl8sYAnLQ8e3IYdf494Ir+BpB45KLWgTJt9rt+GbdDfrPgmj0Q
         A2QWa3HN/dd6c3PbrO+60aev2ry4h+09PTwt3DUH8jikrzHwfHoNAfuupQrG37z1JgsZ
         ErPOKBIZd46LnG8N1uEdVczui2ZzV2E8d0O6W7EsVXqzqrwvb/ubE39TlRnzViBkEQJ/
         JfHQ==
X-Forwarded-Encrypted: i=1; AFNElJ9dLsRzY7R7EqB+vS9z1SWKE1jeJFbOEMtWCUbOicWO0mxxVFtVM09ZMdY2n0fgdF806BV9dO9bLjPI@vger.kernel.org
X-Gm-Message-State: AOJu0Yye6nyV/S/2NjhREnIsCvEUZ2kyfdJFz8MBD9abH4TCXQWAl5sr
	7K4jY4I5EVzcG2dch09F0v2RPelg7MlcoMNHjcA10wZ2pSzpsPwkm8uc
X-Gm-Gg: Acq92OFFROK9UWnsapIJ/M5uSgp3Ua36R5URO7xudKe8+j1Orj8WRXChB2q+PbeMotc
	jc50EvxwQvO4wicNPfCYJUv9QHon3K4q8BlNFFNRnPlNykuvC1DWbhQJZn8ubXaiOW2E0rGsFBk
	5Axx5hsKzL3WqTN8XMzQPASy3e+axQLcF6Q43x9FOD0jQm2Yv7gC8OYFLXXV1vfeQ+iNJhYJDuh
	63X3xTZBEHiA1Ry0jEmZfizyGfuBzkxzUOFuJNqYnMfE2knaYT1hGFBhAYH0tOOUOEvxovG3vwr
	hhEVtpYpPhrAD3A0J5Igjp0REETdUosiz2jHV/Q50NHHmNQ4qqUTwhO0kuzXqhDFmhFrCo7MSd+
	wqMt5+gnDFs7ifADDmpoTTvV9Ru0BpwCcks+bxE7heBwHG/MDnMtR+g9l3Fj8rdQQLIrKVv/Stf
	irqLsoiCrLKJWvi4Yv5TxfmA2umeijMM2k
X-Received: by 2002:adf:f9cb:0:b0:450:ad00:86aa with SMTP id ffacd0b85a97d-46027334f00mr4350905f8f.15.1780579201550;
        Thu, 04 Jun 2026 06:20:01 -0700 (PDT)
Received: from localhost ([94.53.77.213])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2f67c6sm16699144f8f.16.2026.06.04.06.20.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2026 06:20:01 -0700 (PDT)
From: Catalin Iacob <iacobcatalin@gmail.com>
Date: Thu, 04 Jun 2026 16:20:28 +0300
Subject: [PATCH v3 5/6] sh: Remove remaining defconfig reference to the
 pktcdvd driver
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260604-remove-pktcdvd-references-v3-5-e2f06fb4eef4@gmail.com>
References: <20260604-remove-pktcdvd-references-v3-0-e2f06fb4eef4@gmail.com>
In-Reply-To: <20260604-remove-pktcdvd-references-v3-0-e2f06fb4eef4@gmail.com>
To: Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 Rich Felker <dalias@libc.org>, 
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, 
 "David S. Miller" <davem@davemloft.net>, 
 Andreas Larsson <andreas@gaisler.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Jens Axboe <axboe@kernel.dk>, Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org, 
 sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org, 
 Catalin Iacob <iacobcatalin@gmail.com>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=686; i=iacobcatalin@gmail.com;
 h=from:subject:message-id; bh=qLq31BYjVwoita8p3VYbMVHsnGBFQquUbQzcOZAQW8k=;
 b=owGbwMvMwCX261qtXAKXKjvjabUkhizF6vUbg4sCfwjVxDoesvyfcbp2wXwO5d1rzS5+q5cTn
 pozz+ZGRykLgxgXg6yYIsuLc9fbNuw5E3Avya4FZg4rE8gQBi5OAZiIMRcjw4LzeSe7T+xV9p50
 z5Yh/ZzHFna1hwXT1+ZHTSp83fXl60FGhj0iy0Jk/1atj4qxP3tw4bVFNxnFYrn//RW9kh8fLuX
 ymhMA
X-Developer-Key: i=iacobcatalin@gmail.com; a=openpgp;
 fpr=F609BFABD84EB5C9DDDC37EDE89C6A3571CD0E33

Commit 1cea5180f2f8 ("block: remove pktcdvd driver") left behind a
CONFIG_CONFIG_CDROM_PKTCDVD reference in defconfigs. Remove it.

Signed-off-by: Catalin Iacob <iacobcatalin@gmail.com>
---
 arch/sh/configs/sh2007_defconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/sh/configs/sh2007_defconfig b/arch/sh/configs/sh2007_defconfig
index 5d9080499485..f287a41cd38c 100644
--- a/arch/sh/configs/sh2007_defconfig
+++ b/arch/sh/configs/sh2007_defconfig
@@ -45,7 +45,6 @@ CONFIG_NETWORK_SECMARK=y
 CONFIG_NET_PKTGEN=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_RAM=y
-CONFIG_CDROM_PKTCDVD=y
 CONFIG_RAID_ATTRS=y
 CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y

-- 
2.54.0

