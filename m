Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EDDF20127E
	for <linux-scsi@vger.kernel.org>; Fri, 14 Mar 2025 15:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741966701; cv=none; b=Yui3h6DY89x9beFJvyXk1o5CCDSnF14f9f1l5oj3xvOJYfDhG6YlmO0ANRAHMYudHOoBVm7Gtv6508gObI3Y7saDgC6UTrtMwvFPYT1r8ivWhQZcl5UMCbpSrEY1URJg01cT6+Ck/IsoCjTRj/wZSmth2LWRjUoknN89IB6Cy1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741966701; c=relaxed/simple;
	bh=g4f90mwDJuR26wqS/1igJqcdIvIeUlPUF9yUW95/6IM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=BQpV+lpTvUsq3E4EYWJ/HMIBNsNvmjGirW3y3uTqeeo0bJljw/bw8Ee4+F488LAUAEni8+tdpYNXnHy+LApi3TxGhKPrvbvYr1999+ygVFls5JmJrSSfzPfDLo3NQBMQC/DnlFCb1UWqCFbzyjzsmZ8mQy0lYfNC/azzWNco2HQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=YoDhXhrE; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YoDhXhrE"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43cf680d351so21403605e9.0
        for <linux-scsi@vger.kernel.org>; Fri, 14 Mar 2025 08:38:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741966698; x=1742571498; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eMYM/Y59VrWiEn+/FGX1UKrQNBbRBPg1viYvIvRGXN8=;
        b=YoDhXhrEM5WDMs/QmHYeIwMkLROYI4h5NvS7NSDB7oNXnbRob72zHj1eJAZ2pSdSlA
         W8ed5qcrDmEkSXFqL/8kTxsnez+8p04IZNmVzBKQhWibdpdeKARfYRHyXMQ9Bv2tCf4e
         wl7qdIVO2AnGMzIHoPyV3MQ33YTXPiHgx3zoO1y7PpYrbg8gwmZd2dGYNjL9yALL2XZF
         hBN4qOu30oSMKDL3GdiKrBZCRJT4YK6vhmE565GMy42VqdNmcgM5M/U8V5mUwR02w1a4
         jFjxyN+GSAF/qohk1iupIoD5cIy6sacX4O8t0ZGXLtKQ55+dz6j0ktkvw629PYzvl68V
         7urw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741966698; x=1742571498;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eMYM/Y59VrWiEn+/FGX1UKrQNBbRBPg1viYvIvRGXN8=;
        b=sJLD2a+zCBNONAE4XAq/Eka8m7PS4M0Kjkzn9DsWIqa6cDRacef/SCmg/1Zow0gsIN
         lgpVER0CvnWtkbJHgsW3hbWIit0vHnabbWmeK2QgO1md9m7kfQshynMAbP19LvyjSf3i
         1SMeKcicvFasOvQ/fOLQEqZjMR7gM9HXkEUY797WqDPCd3ble3w4/2vZ+AAx/5yN8G9b
         v/Gq3QM6IAdPhxqF4a2nwEPIwQ15vkIW0gEMrcDbKVU6NUzeFgvJzkdben3zADuuoaGy
         BHYYtvkTjq/X8Vlw6CkCo9LeKoFuoYLr7pzW46q/GEiTPoVtlUF3zBJHIze86NA+T/z7
         3kZg==
X-Forwarded-Encrypted: i=1; AJvYcCVlxE/YSWhxRU/nyYCUC8oa3+/8xpzoWy9ceoFI8mK4JjkBPeWgdibtoeArV04p5GdKiHs56IqwN8vv@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9DJ+Zs6SKCDhAZ/caKWl0jecgUIsNO/CMiwMDt7kkh0fa02QE
	pWA4xDuwwpKund5as71953PlyVGYT4F2L3+o44CmTFCP3N8h8NOSECiTZOHD9/c=
X-Gm-Gg: ASbGncu+SgIBpgPx1m+nXIQG5tRr51YdKmrFtsLh0F8NmeeMWQeePgZkfEo0KsJ3WVz
	VUYHU8aY6iIJqZcoloJ6AlfABhn/Y/NtmyNXmWKm7im50kPKVLDSdPLFyiGthipyPJvtkX3p1nL
	gw04FrFhaUwg1AdWsXSbNoFEfbFIw1c3ORjBMtNHkGkiYM/KagxGUle8NMEf5PAwrwE05FBMId8
	D6G/JJlxhOw3x9FTcBO30g0wann0aa80Hf7EURy4/IE/OkwN4f3ZoKq0v3UOYdghWXoxX/gnj7x
	wcVQcfbSFIgCZb3+5puOEPfMwQ4LO3VNVc6YeE4kRGLgSHqYLOm9X0RXbeNJYEzEbKwX5KSwHRE
	n
X-Google-Smtp-Source: AGHT+IF0c1R4A731Yp+i5adNCqzDyfMiv32JNj/6QGvQRIP7C/RfyrTNHmzLFbxoNZ8YFJMzjNoGcg==
X-Received: by 2002:a05:6000:1acd:b0:390:dec3:2780 with SMTP id ffacd0b85a97d-3971dae92ddmr4101987f8f.24.1741966697719;
        Fri, 14 Mar 2025 08:38:17 -0700 (PDT)
Received: from gpeter-l.roam.corp.google.com ([209.198.129.214])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395cb40cdafsm5944388f8f.62.2025.03.14.08.38.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Mar 2025 08:38:17 -0700 (PDT)
From: Peter Griffin <peter.griffin@linaro.org>
Date: Fri, 14 Mar 2025 15:38:03 +0000
Subject: [PATCH 2/2] scsi: ufs: dt-bindings: exynos: add dma-coherent
 property for gs101
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250314-ufs-dma-coherent-v1-2-bdf9f9be2919@linaro.org>
References: <20250314-ufs-dma-coherent-v1-0-bdf9f9be2919@linaro.org>
In-Reply-To: <20250314-ufs-dma-coherent-v1-0-bdf9f9be2919@linaro.org>
To: =?utf-8?q?Andr=C3=A9_Draszik?= <andre.draszik@linaro.org>, 
 Tudor Ambarus <tudor.ambarus@linaro.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>, 
 linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-scsi@vger.kernel.org, kernel-team@android.com, 
 willmcvicker@google.com, Peter Griffin <peter.griffin@linaro.org>, 
 stable@vger.kernel.org
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=931;
 i=peter.griffin@linaro.org; h=from:subject:message-id;
 bh=g4f90mwDJuR26wqS/1igJqcdIvIeUlPUF9yUW95/6IM=;
 b=owEBbQKS/ZANAwAKAc7ouNYCNHK6AcsmYgBn1E1lrzk8wn/m7Z3q3ttJavIAK2e1eKNBbYLA5
 JQ2Q5NtdqiJAjMEAAEKAB0WIQQO/I5vVXh1DVa1SfzO6LjWAjRyugUCZ9RNZQAKCRDO6LjWAjRy
 utKED/4hPCY3Gp6xFZBVY2H08Ll2kfO1GsRnfO//B8bkd3czF2j30oImYeJvcg4bM7d1oc1Yr4V
 NGPH8Hk9EKbtDZSaYpRnRIP4rkb+QW/ni2ntZ6I9J1cKEDpb8KjUQaSVgz4ajIDGlbqGO6o7HF7
 0GwOjCQaEJ2c1rBTIzfat/7Zhz7sBKa5gxkLH5KGhejx0/kzvYm3PS+yOMnjEWNfg9ROeum5kPV
 HCWq/4Tt46gwj5WiwgHQB1MY+luGeAm72KnCHBfYqMVY0Ol/i55IhRcvT6oUUbbPUrhFRnAUTae
 V0HlLhfPlhSZiosyZB/Vk42oKcZOWUw/8aARs9r2YJbPbP+Tc69vfThTN/ixsCtNTPGSRjrNHV0
 nWyhBJGLiKC91dKYCYXFm4rv/1LDHvb8PXTkIMGYxpA8VLzr9QiwczgdTUKGR/4NF3mw7nRwjpj
 u4IAE3Es/t7lMP0Lay6/zsYvjzh/j6ucCXB/wPn42KWTu64Jb5fCdeHomQBuCXfNgRuthaKp6Qk
 1eyV/LwD7l4aAh/Wyso4tYsVALuREJEuE6Ilddr17L5PUmF7+C/Y3SkcYRtT0FcWBVRmfni5fte
 g1rLHY5w4qyb/3TF+CJfvYIIKPjLTfUkvQxNJ62Aj7hiDV5SPiTkAfjQknnzLuU4UAy/lNq9vvz
 vIv5kje8ghGwFPQ==
X-Developer-Key: i=peter.griffin@linaro.org; a=openpgp;
 fpr=0EFC8E6F5578750D56B549FCCEE8B8D6023472BA

dma-coherent property is required for gs101 as ufs-exynos enables
sharability.

Fixes: 438e23b61cd4 ("scsi: ufs: dt-bindings: exynos: Add gs101 compatible")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
index 720879820f6616a30cae2db3d4d2d22e847666c4..5dbb7f6a8c354b82685c521e70655e106f702a8d 100644
--- a/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
@@ -96,6 +96,8 @@ allOf:
         clock-names:
           minItems: 6
 
+        dma-coherent: true
+
     else:
       properties:
         clocks:

-- 
2.49.0.rc1.451.g8f38331e32-goog

