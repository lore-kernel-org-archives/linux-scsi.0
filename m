Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 195FA1F12F8
	for <linux-scsi@vger.kernel.org>; Tue,  7 Oct 2025 15:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759852592; cv=none; b=JoMYMScwpWtwsZCLKiVSQ/8pXEN/QCmDh657HKu3r7yYTKyCVxkhZcu/sqLVNvRObJV2lvvsPO7wPMiaZLl/70rFga1gm9IXC7xqH3vxx6j7KRmFGdEYPos1Fal2Ho8X0uKZ5mmQ/dVyYa5/IS5nQQHzaPwsFl9IWSLdAxIcxAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759852592; c=relaxed/simple;
	bh=2PS1aw7dfUT0k1FWYcqJDnEg5AxccGVN6SkNj7bMjuk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=iIzxSz/QTK5zFb3ycHNR/UvdS87BTD3mo8XLaiUAHn/tJAivoFrAOmYX84RQkleIn2ENDrVTVvAvKseOia1STMjhQJ81CVwMJqgJoRvquO22IjYyYRl1SrJHi21QTe+Bu8XphyFEZNMacUU08lpB9tuauiQRvBxNVzpPP7jCKx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=L922AMHs; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="L922AMHs"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-afcb7ae6ed0so1088693066b.3
        for <linux-scsi@vger.kernel.org>; Tue, 07 Oct 2025 08:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759852589; x=1760457389; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9iDWqoWfueHqY1DQn3UROh93hmAu+K7Xh14JdQEHAgE=;
        b=L922AMHsQ5AJuI4epf0tAPOTsp3RJtAOWMo36afQ1pEbLGwffIShfXVmlPk+lLQQ93
         EeBXopkUAMHLZuemTVYSEJ7m6jnIOVXykOyCs3FEBC0RlVwTrxkJEke+nEDN4W+l8P0u
         aoA9rbAVUARM1+xA/n6y583bzIQ7LWOgAX0H/5SbCLYHdr5fwZYCodBd1+ZZeurkrw6A
         Q3/1Xwy02u/BVJ8rroIOgYduqg082iHUNr5enYcJeaieueNxmVgNdxEHnlVE03tLzdb7
         3TE+G3s+NmYwfC0d2WY46vBYIir3+5fizW/8OQuh3f2Xd2kH0Yt303aTmFk15RzrS437
         8bew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759852589; x=1760457389;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9iDWqoWfueHqY1DQn3UROh93hmAu+K7Xh14JdQEHAgE=;
        b=k1ZX2X/jNFUWs1oWN43VSk2s9Z0YCJNg8k859vlG83uK9nazUvKyKC/KB6biTtmSFw
         Vbsyj8rNHKh4kMi/KAzP1cX5YrT3TciCAEH9a5f8Foy+FkWF6KCze7tnvnV2zkUwcUsc
         agvGwZcwXaX5hRlZr/vB7RODlbVIzQJNAVhYgS9kHtAb+9agkwOYWY47e1dnsiCK1GPn
         J4mE749bWVLTjFDZDibG4jAgaB8hBY6izdUvddWTZ5lZdOeT6HMhLql6ejSEc3XegBck
         BcZquRWr3CG+lQ2v+OD1Hbsgry6LprgY07eMLw8hf7Lt2HEr3pxeeQ4UB4UtcHtVCLvr
         Da1w==
X-Forwarded-Encrypted: i=1; AJvYcCWdAwdyBKOG231ykhPgl8+7lzVWHVaFtukgdTCGvEXOSedLZ8V8D2IOUzUJaxQ8ErYmqneFZT4YCAkC@vger.kernel.org
X-Gm-Message-State: AOJu0YxERxh94/LueVj/ZfO+mVJQ0a99vW9NkoWprHdr+4ztPDfxYMU0
	RKB4b3DMaK2p1whiirlBMx/BwmHa7T/Q5/OWDwKUj6bkY8Nfg+V4qIAB2UJQQqZaLgM=
X-Gm-Gg: ASbGnctGiJju3sKJnGGvqBwdfruO4O13Jh3aLVPRAaYNaio+APRbEUBB3xvNlNqUEan
	tLErhlGnB9WDjSOi4ui0uj/3f6sPDRmo8XbvoGIcnzRJVnuCZBgfrP8I4VDFtjzj9FxTFqv2+uq
	qrnqwPu319fImmnf9bhfUQgd8C24yQcXY1K1aRFjB1vWQr4Ax2Jdfgq8wTz9CZ397CVORVQhnqQ
	L6/s5cqX8uCJyrF4TnmJ0x99kLYnaMFX3guD5K/IzeUkr/0dj0r4aj3mdu2LnFdsS0SrMJYh5eZ
	CwUWqIuTzGDQNHk4dM9yV+TBuRWYZReqhASRceQvfTlfRAfn4rB4o1ebWuyOdt5sUtpXEk27EJl
	+Zcit8qtuLu0QP5hybtpklkqyRY3InIm2255a0q94/uzSiWluaamG9dpaTpx6d71+lOXJ2CRoz3
	tbHyblwpVGTcXCnjFD6+XsuGXsnPD91oic+eZC4DUR
X-Google-Smtp-Source: AGHT+IE9IcJVSPedWcpAGpdnmJW4z9APNCOE9dq2vD2s6GXK/hxjPEw6IveEriVdGAIUqOpPhoFZSg==
X-Received: by 2002:a17:907:934a:b0:b48:730:dbb3 with SMTP id a640c23a62f3a-b50ac1cc3eemr13165366b.32.1759852589395;
        Tue, 07 Oct 2025 08:56:29 -0700 (PDT)
Received: from puffmais2.c.googlers.com (224.138.204.35.bc.googleusercontent.com. [35.204.138.224])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b486a173a5dsm1428820166b.85.2025.10.07.08.56.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Oct 2025 08:56:29 -0700 (PDT)
From: =?utf-8?q?Andr=C3=A9_Draszik?= <andre.draszik@linaro.org>
Date: Tue, 07 Oct 2025 16:56:28 +0100
Subject: [PATCH] scsi: ufs: dt-bindings: exynos: add power-domains
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20251007-power-domains-scsi-ufs-dt-bindings-exynos-v1-1-1acfa81a887a@linaro.org>
X-B4-Tracking: v=1; b=H4sIACs45WgC/x3NPQ6DMAxA4asgz7UUoBVVr4I6kNihHuqgmF8h7
 t6o47e8d4JxFjZ4VSdkXsUkaUF9qyB8Bh0ZhYqhcc2jdq7DKW2ckdJ3EDW0YIJLNKQZvSiJjoa
 8H5oMnx21HLxv491D6U2Zo+z/V/++rh/PMByuewAAAA==
X-Change-ID: 20251007-power-domains-scsi-ufs-dt-bindings-exynos-87d3ecbb3f4b
To: Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>
Cc: Peter Griffin <peter.griffin@linaro.org>, 
 Tudor Ambarus <tudor.ambarus@linaro.org>, 
 Will McVicker <willmcvicker@google.com>, kernel-team@android.com, 
 linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 =?utf-8?q?Andr=C3=A9_Draszik?= <andre.draszik@linaro.org>
X-Mailer: b4 0.14.2

The UFS controller can be part of a power domain, so we need to allow
the relevant property 'power-domains'.

Signed-off-by: André Draszik <andre.draszik@linaro.org>
---
 Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
index b4e744ebffd10aa237e01a675039f173e29c888a..a7eb7ad85a94e588473eab896e48934cd5f72313 100644
--- a/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
@@ -61,6 +61,9 @@ properties:
   phy-names:
     const: ufs-phy
 
+  power-domains:
+    maxItems: 1
+
   samsung,sysreg:
     $ref: /schemas/types.yaml#/definitions/phandle-array
     items:

---
base-commit: 3b9b1f8df454caa453c7fb07689064edb2eda90a
change-id: 20251007-power-domains-scsi-ufs-dt-bindings-exynos-87d3ecbb3f4b

Best regards,
-- 
André Draszik <andre.draszik@linaro.org>

