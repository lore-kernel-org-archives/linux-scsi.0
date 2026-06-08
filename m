Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B6A3D669B
	for <linux-scsi@vger.kernel.org>; Mon,  8 Jun 2026 14:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780928901; cv=none; b=lhCYo/nPABmDWc8zORLedhL49WIVm4JHJu2BG2vzB6zr2fHe/Cs0p8JyXlazt5Bg/snn4Es6ViKntyvurUkYk9SdGkKllMYpWAIP88lTijya1pNfKpbiV06ZpImnM02uErwftV0c2QEYIZ/Y9M87XFMeZmP+9m6O3SQOxWho1Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780928901; c=relaxed/simple;
	bh=qLq31BYjVwoita8p3VYbMVHsnGBFQquUbQzcOZAQW8k=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=krNWvNKsPt0WjV6/O0s/BDCTJX4H7LI1SWqVdk/gRi3nK4ZsClGKMh7B15uyYSPEg7giwHJJ0/Bu6RS/ZTKwdSLmpMQbD9+OIqARTzb1WV2gX8A3yxEjGxiQCqFi49OFQ6xdWUkPKg7VPYRMrhsG2Zt1dqlTtsbiwfgPAj2enHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ge3ejgzB; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ge3ejgzB"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-45efb698ef2so2014939f8f.3
        for <linux-scsi@vger.kernel.org>; Mon, 08 Jun 2026 07:28:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780928898; x=1781533698; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fx/LUhwU/PuBYtkBp+ygwfhlhplOE7zsRH3troT6KA8=;
        b=Ge3ejgzB/KrAHeBQywsZEmHlINxno9LmmqQONI4R6lU57Mp35QbZF0Gr2RhPU8HGjj
         ag2XqpoTR5/IAkWCwJqsezVXQpLpRXYdSwcslPWqUy/r82yo1uKg2rWBmgXfy9xAjiB8
         mY4eR7KSHK/dQYwORfDxWwWEu0ULugEN0JLy+KmYNwc6rd7HOXFMI5da8m5oUZ8gHSu/
         APmByU6qvSFV1UHpt2JMqgamKfn+2hUJ77DNnYD1eJEzjGAPMdPb505cE/xIXtiQI1Ky
         DmkW/uW0zd7vQ2qMs6+a5LcRUfGeEtoFsr8izMjz+qpyQqoMpb0PskL91sQ7osUXqP6Y
         Yy3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780928898; x=1781533698;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fx/LUhwU/PuBYtkBp+ygwfhlhplOE7zsRH3troT6KA8=;
        b=stec3Swb7KXXShy0/dXL18z8zRMOZxq8+mMeusI0KdQUzbOrt2OOdIASkeBhcrFlB8
         /uZbV0Ar8zgiPL/9zHvCFLlXyLG/H7bxjfY6JAb4P1S3AzMLT5EYzovlusLv/+y0yNaT
         +2doj/raJb4h7kzF5w0N/jqxD1kZRt+5M9cfIFgeIgwZYzTCA77r9IcvdyGSQA6sIa1e
         K/m0iO3UgAQZz/vKTTlBe6Sezi/wppBZ8kB75ENdqVPq6VVAcTWEAe/DZ8zZDaAYtXtY
         VaLf+3jRzPvaYsFtcIvtknN9lxS3OMssXYJktDpRvQhWs+qZ5LmCjuSoxMboACCqupSq
         zzpA==
X-Forwarded-Encrypted: i=1; AFNElJ/zAtyqAH0z3DHad00uLc1/hCiiiCF8mDwvWMvzLu9XCGzC97N5erGJwl5z2kne6I2myndlA/CGFNcA@vger.kernel.org
X-Gm-Message-State: AOJu0YzucaTQ5MnU+GZq8zKO0DhBpgmVGxTo35anNKWsuM0HxBLYRUCQ
	yP2foXqb3imLxV4yBgEqZWwAttspfwKmBoE+XROfI4mCrwIh5TL7Gm5UV1ozNtcL
X-Gm-Gg: Acq92OHwfcRHwVJbvPUZsU2plOXSg9bhFqreed+6TDHwdlaqst8WX42YGL/VGYTqIxT
	zAwd5ciPTezfobOHRfO/mLS0d6e5NNXJgiCe7cXQEhSZ8A05SWtGMNYppw4kB20bgf0B6iZjahG
	7ZhcnzZic6RqNMcVtoU2ULG0PJcTJOsoq9Ef46tZBr/sUFlgz6qoacrPlI0PAtpHId3lCJkvRGS
	qS5FdrtElOlofIzLx/FXZonbrOceAtgG4KNQAHr6bLJv+nvKts322jIuJ6vgvNLF6lGgSA14quA
	2XYLfZhaA1y/BA8WPoFt196Z4wn9qQUVI6eDL6MzN4+7U8ZkgLBy7y719o2oWu8av28Fcb1Qok6
	VXiGn+22QFF+gJHqul6UONydJoKu1Z+j14YXX9k0owD91t9bRf0BAVznJ+6pvylcRyGXswv6yxJ
	t8R9eh8QiIi1F6afDt4oolbNEFUJAWDDpO
X-Received: by 2002:a5d:4688:0:b0:45e:da9b:97d6 with SMTP id ffacd0b85a97d-4603061e47amr18261428f8f.27.1780928898275;
        Mon, 08 Jun 2026 07:28:18 -0700 (PDT)
Received: from localhost ([94.53.77.213])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f35eae5sm53479588f8f.33.2026.06.08.07.28.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 07:28:17 -0700 (PDT)
From: Catalin Iacob <iacobcatalin@gmail.com>
Date: Mon, 08 Jun 2026 17:29:19 +0300
Subject: [PATCH v4 4/5] sh: Remove remaining defconfig reference to the
 pktcdvd driver
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260608-remove-pktcdvd-references-v4-4-72f88b04cc87@gmail.com>
References: <20260608-remove-pktcdvd-references-v4-0-72f88b04cc87@gmail.com>
In-Reply-To: <20260608-remove-pktcdvd-references-v4-0-72f88b04cc87@gmail.com>
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
 Jens Axboe <axboe@kernel.dk>
Cc: linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org, 
 sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org, 
 Catalin Iacob <iacobcatalin@gmail.com>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=686; i=iacobcatalin@gmail.com;
 h=from:subject:message-id; bh=qLq31BYjVwoita8p3VYbMVHsnGBFQquUbQzcOZAQW8k=;
 b=owGbwMvMwCX261qtXAKXKjvjabUkhiy1iwcM25Xkd7+XZ3G9wyYlevnK8Zv9mgt/OF0QYeZ7+
 P0Jb8vnjlIWBjEuBlkxRZYX5663bdhzJuBekl0LzBxWJpAhDFycAjCRzYGMDJ+t787f9PvFqugg
 5uYn71v4UnluLU1gP+LcFD053+vXsV8Mf+WeCd1hD5963TmiXkXBOS3zxWLWM2JmYbsczBx3M8p
 t4wIA
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

