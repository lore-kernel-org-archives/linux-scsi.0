Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E199420298B
	for <linux-scsi@vger.kernel.org>; Fri, 14 Mar 2025 15:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741967988; cv=none; b=O7/d+98yhJ8V/72eN1BatgDKhg/lfhZpNcnA2ee+K2C3muu9sCk/tzPEnDCXM38JLM3lZFFq4kNZjff/XPmr7iaZDyK3mOyiYDkwIQb9CA+H8buno5JBSRf5QHCLx5mzqRRPsqukZUb0NFCGFV9r7TJVOY4NH4Ddee1vztq5qBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741967988; c=relaxed/simple;
	bh=qbAf7RLJv6RsTwMHx91Z6PJ5PYNVMVgiR3uOKlVTE8s=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gbGN1KJSq+H5Qj2vpl7fjBd5CeIGJtkvBjYLU4OHtVUE1hpdCDlRqN9BjnPhRcxsF4n0c/NVzxIokZlFMlM7tmHTERAjzGf9AQAY3IEkin6T3KqmchXvgFAtqg/q/MjH08Ow3JorIoXqrEZ5uvxhbtFkFD0LMrVgXUBQ2XJJ4Gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pbdD17BP; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pbdD17BP"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-43690d4605dso15956055e9.0
        for <linux-scsi@vger.kernel.org>; Fri, 14 Mar 2025 08:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741967985; x=1742572785; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qbAf7RLJv6RsTwMHx91Z6PJ5PYNVMVgiR3uOKlVTE8s=;
        b=pbdD17BPKnXsMKsBtrq1RoP+o6fqRqO8bb5yu7ddTufgEuzYwiuIDowaw7504uNHPb
         Wfd4KSKMBcZjA7vr/GwlLg3vyrgB3DDzphXemPHz6+1Hgah13e7Eoa24wka11cjXGp2g
         f1J861OMCg/JyjPY0RSm4tWuKsS0JcSCygPtLFJ+E+FJXhV8OkgpTkeWPNyvWUnSpZk5
         2mh+CitzJ3vUXhyhaSkLtIyDlXRe073Kuug7k8HwPyQrhS0+3DnGqkI1QXtap1VlAmnz
         V7B4aM6HX6hVGIIbROJuMM1pIUQGmGEirmEQJS8vG/bQI2XEbK799RoDOi+vxKmjP1VE
         CbXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741967985; x=1742572785;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qbAf7RLJv6RsTwMHx91Z6PJ5PYNVMVgiR3uOKlVTE8s=;
        b=Xur8vVqpDaMscle42ccGQ8lmjJmpsQzq8TyNvdtY44w7BRtlhqelqUZy0yTf8qPwX8
         vnBba3jXCZq3xesXwxv6fPhgn464VyBaq0RUN5j4hhqZEH1wphbZRDCSpjBKgmhfrc6q
         09C0TWaP9Ui25g9wKwLWyhqNYTrYKmyLh0gmn5p9OyV9Xb/oypyzRzufRFqy3IJ7oGev
         oyFNdiatYKIOdQ+g3Csmqtcri2/DAOQRSbpP7B9fdKPKQE+T7ZbQ3yaz2YlXo40jZkPw
         KY+bmKsDKfTSI0u/poJfmZ0Y+47dumxn+dfKMaL5IL3C4ZspqYTMUMtcB3djXs4zZWZz
         Cq0Q==
X-Forwarded-Encrypted: i=1; AJvYcCWc6qWLqN/DgG11GtpbCl6h1erbe4emCnX59zCckFcccM6287xosc63z4rBKuOYpnUhXKvuv9dPtDPO@vger.kernel.org
X-Gm-Message-State: AOJu0Yxe3aqFkQ4s7lz9NJvjO6Kxld00dDpiOFXupitCVRhfdkpgDj4+
	mIwgvJsBmhapdqmYuBxs+0fyP5+2DCAhNH7MeD0KxFkCEkCTIq3HBG3SM/v1Ahg=
X-Gm-Gg: ASbGnct1l1KsWBhHSC+lsDprVXiXCzzcZZpX8lHViEyiQ4kVXT+isaB7M2aCFr8/twx
	gxfXouU/Pir4fAdqeKpVurfyNbGInfRFmskf0XeArVzJKTsSioELGwI8s1fdaQlqvPOmzOiASwf
	BcTJQ/rmmxhcKIj+6vePfad1El8oeVXTXUlUg8UWoYEUFOP/YS4TXvLQMrbVySq7tzkpuRoDEbY
	pTqZiAAF5yg3Tao8JHTJnm6GnC4hwWnyAilBX+X56qmmkmm8Xle2LKqRjNdhd5kzT2sDdSOZrJn
	JI54/qJqKxr5QIQvOuZba5WhMUCJVySYZ9h/neOCW6FhRHEO
X-Google-Smtp-Source: AGHT+IHxwHHx6Fb/u1dWZbQ1qTy60BcLwUz4P4SvmS/UEUbzjpP8/AFJeuPq9qAxmx2U4YpAhe3Dbw==
X-Received: by 2002:a05:600c:41d3:b0:43c:f689:dd with SMTP id 5b1f17b1804b1-43d20e467c7mr27073105e9.19.1741967985037;
        Fri, 14 Mar 2025 08:59:45 -0700 (PDT)
Received: from draszik.lan ([80.111.64.44])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d200fac7asm21846905e9.28.2025.03.14.08.59.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Mar 2025 08:59:44 -0700 (PDT)
Message-ID: <931e5e0b07d598912712b091d99a636b796fe19f.camel@linaro.org>
Subject: Re: [PATCH 2/2] scsi: ufs: dt-bindings: exynos: add dma-coherent
 property for gs101
From: =?ISO-8859-1?Q?Andr=E9?= Draszik <andre.draszik@linaro.org>
To: Peter Griffin <peter.griffin@linaro.org>, Tudor Ambarus	
 <tudor.ambarus@linaro.org>, Rob Herring <robh@kernel.org>, Krzysztof
 Kozlowski	 <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, Alim
 Akhtar	 <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Bart
 Van Assche	 <bvanassche@acm.org>, "Martin K. Petersen"
 <martin.petersen@oracle.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>, 
	linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-scsi@vger.kernel.org, kernel-team@android.com,
 willmcvicker@google.com, 	stable@vger.kernel.org
Date: Fri, 14 Mar 2025 15:59:43 +0000
In-Reply-To: <20250314-ufs-dma-coherent-v1-2-bdf9f9be2919@linaro.org>
References: <20250314-ufs-dma-coherent-v1-0-bdf9f9be2919@linaro.org>
	 <20250314-ufs-dma-coherent-v1-2-bdf9f9be2919@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.53.2-1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi Pete,

On Fri, 2025-03-14 at 15:38 +0000, Peter Griffin wrote:
> dma-coherent property is required for gs101 as ufs-exynos enables
> sharability.
>=20
> Fixes: 438e23b61cd4 ("scsi: ufs: dt-bindings: exynos: Add gs101 compatibl=
e")
> Cc: stable@vger.kernel.org
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> ---
> =C2=A0Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml | 2 +=
+
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yam=
l b/Documentation/devicetree/bindings/ufs/samsung,exynos-
> ufs.yaml
> index 720879820f6616a30cae2db3d4d2d22e847666c4..5dbb7f6a8c354b82685c521e7=
0655e106f702a8d 100644
> --- a/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
> +++ b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
> @@ -96,6 +96,8 @@ allOf:
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 clock-names:
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 minItems: 6
> =C2=A0
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dma-coherent: true
> +

This is allowed globally already in this file. Did you meant to make it 're=
quired'?

Cheers,
Andre'

> =C2=A0=C2=A0=C2=A0=C2=A0 else:
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 properties:
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 clocks:
>=20

