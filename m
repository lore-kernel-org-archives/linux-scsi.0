Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F792F25F9
	for <linux-scsi@vger.kernel.org>; Wed,  8 Oct 2025 07:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759910196; cv=none; b=pYP0sVLJEvrq/UUmKcxDlb8b+NEYnJe2pxmqDMHtkkbGWRpky+bzSky6M9llk8qCg3JrxXmx0xNoEyBcNCkLJ9Xg2poMuJmjJJ1v+8816JoTjLXOEWt+LETiQOvoeMsYKo6rqmaG3wpcWfrOFw4FCDqFJPzQ9wS+G5HaihyROIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759910196; c=relaxed/simple;
	bh=yY6/uGBggjr7DPOeg8CZY+oS1HkBeSOBG2tcETPEWsE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=vCWIyYaCIDys20/UxCNhPBnHsDP0UFLuFG+BXEjTGakEjwSTScAaqKk8v08gWCfYO+93pxpZkQhspNUThBUus16uCxM+T6+agpriHeQ4jbO3vmVPlF8WqTMQb8UsURnQFOyd84zzt71TKREF8Ua2OUMFaIsuelbNwLX4aE3eWbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FgKGoOFH; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FgKGoOFH"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b50645ecfbbso220613066b.1
        for <linux-scsi@vger.kernel.org>; Wed, 08 Oct 2025 00:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759910191; x=1760514991; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yY6/uGBggjr7DPOeg8CZY+oS1HkBeSOBG2tcETPEWsE=;
        b=FgKGoOFHGZDoX2zKAwtxgvU1mPSAuFxSpRZkUpacp8RjZuub+9h+v6WL1ArT1GCdDe
         qLjWoW2xLCkVfb1xyOSkNzk32/8q3/uoEUwSxQLEKADoISWQ1kZ/3Oq8n5deKKMFV+2O
         6rkiUKMi7gR090cPNDiGhEbd8IcXJa5OfHq8VtPF6dFm7/wdYmbxUNYiiv0sXAwP2rqs
         vRiGNlMETRM7ESdmiLZdlPD6XodYPCQyxag+d0eBE474O2HDsTaaXx/wtSZozBx0yDa6
         vsVhTjBhLu0XQO9qd0YK8nhh2EnRcS3aC9bx+BT8imsVYTBqf9rDkQbhxvUkjyN2PSHI
         Bafw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759910191; x=1760514991;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yY6/uGBggjr7DPOeg8CZY+oS1HkBeSOBG2tcETPEWsE=;
        b=eHkNBR42AURBUoq0GgmGKpW66no7wYi0r4mzluxQbxxGjZubCDJ9f5gaj/+XVYwFJp
         HQ6vt1rHzq5ry2BYs60YYvm8owTsN0oartO5k5sOoJQZTMTeYNQzxBO639KRRQpDrl4l
         mrD1Y/UAXyjH3M1YsavOozwOUzYe23qnKr/pXcFFkeRbXg00rRsVw/lnpLu4bzZtsg9O
         kmyqMYMuEppQnmcxDj/i9VUzFc95r8iFl8gOGSzELSoNE0064XejoFmOxut0rlAxYMoe
         JK1cjHSfDIPJwJzRws18glbzo14ZjNifTEy444+clZQVYoXp3qYMm5ySc9VebkzueRSD
         ZuTg==
X-Forwarded-Encrypted: i=1; AJvYcCUp7kfxKescuAeM8shqAYNgArlyZdYBtIZlEoqDUuWUxEL5Qz/NbuX2hTB4KNMqp0kFABjv8yb50B0n@vger.kernel.org
X-Gm-Message-State: AOJu0YycDs/ugHPhbMIoDFl1Ks+msTWeXqKlesJmzHbr+UWl9gn02+f8
	FoY5pFT2JcmmDAHK+gUeOH4hkxEg5cSzulGZDxri19U8QvJnpiN3fwiPadRMz8wksZc=
X-Gm-Gg: ASbGncsV3rnaw8uDr5syTDXNv+c6zlG46Ue+OdO6evq6tGj7K30F4Ow7wzvyQOk6YP2
	D8BBGDQ24ny42dinH9ib08UbtGbjOmy1Q7vXb5Bbo3amjGEqbMUmgDiehY8FWRNQuYLuMKdwvHc
	uUL9Fy1+cS6PsMDBJRoNXK9uJBoPGCNMSz8y0+DIzNnHuWxP+d4BiO7ucL/P7g0CnYweDhWI87f
	F4Fo0AGrzUGNBXGHt9I/gba0786Wip2/nqG7EJVfDmM7xXqlmEbUlImgio2qlbR19Eu2LPNpRIX
	fa+ZK7ma1JYiLULlVj73hoTiib2dy0bjI+itOAt3O1wkyxfEOapUGRnOvv1rqOJhAqpQL6OE0/z
	Rr8sE4JxjWnzMjVgCGr/7Cs8fPV8vSHa2FtzyY1XAG7jZ+pWhEWjARA==
X-Google-Smtp-Source: AGHT+IFp07FRs5tCn/Ul46jxxqRkTyRGCpgeXeTG3+gc53OiL7gYrGNYmAqkEff6f/cTzyfRxNMOiQ==
X-Received: by 2002:a17:907:72d3:b0:b4f:4940:6a23 with SMTP id a640c23a62f3a-b50aa899e80mr258485166b.24.1759910190618;
        Wed, 08 Oct 2025 00:56:30 -0700 (PDT)
Received: from draszik.lan ([80.111.64.44])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b4869b4d9f5sm1618847766b.66.2025.10.08.00.56.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 00:56:30 -0700 (PDT)
Message-ID: <ff3a0b96980669f326ed02ed81b97d34c104b09d.camel@linaro.org>
Subject: Re: [PATCH] scsi: ufs: dt-bindings: exynos: add power-domains
From: =?ISO-8859-1?Q?Andr=E9?= Draszik <andre.draszik@linaro.org>
To: Alim Akhtar <alim.akhtar@samsung.com>, 'Avri Altman'
 <avri.altman@wdc.com>,  'Bart Van Assche'	 <bvanassche@acm.org>, 'Rob
 Herring' <robh@kernel.org>, 'Krzysztof Kozlowski'	 <krzk+dt@kernel.org>,
 'Conor Dooley' <conor+dt@kernel.org>
Cc: 'Peter Griffin' <peter.griffin@linaro.org>, 'Tudor Ambarus'	
 <tudor.ambarus@linaro.org>, 'Will McVicker' <willmcvicker@google.com>, 
	kernel-team@android.com, linux-scsi@vger.kernel.org,
 devicetree@vger.kernel.org, 	linux-arm-kernel@lists.infradead.org,
 linux-samsung-soc@vger.kernel.org, 	linux-kernel@vger.kernel.org
Date: Wed, 08 Oct 2025 08:56:29 +0100
In-Reply-To: <001501dc3815$601ec450$205c4cf0$@samsung.com>
References: 
	<CGME20251007155631epcas5p2cbf4c7b52bd217128c156bf6f5f1ea82@epcas5p2.samsung.com>
		<20251007-power-domains-scsi-ufs-dt-bindings-exynos-v1-1-1acfa81a887a@linaro.org>
	 <001501dc3815$601ec450$205c4cf0$@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2025-10-08 at 11:05 +0530, Alim Akhtar wrote:
>=20
>=20
> > -----Original Message-----
> > From: Andr=C3=A9 Draszik <andre.draszik@linaro.org>
> > Sent: Tuesday, October 7, 2025 9:26 PM
> > To: Alim Akhtar <alim.akhtar@samsung.com>; Avri Altman
> > <avri.altman@wdc.com>; Bart Van Assche <bvanassche@acm.org>; Rob
> > Herring <robh@kernel.org>; Krzysztof Kozlowski <krzk+dt@kernel.org>;
> > Conor Dooley <conor+dt@kernel.org>
> > Cc: Peter Griffin <peter.griffin@linaro.org>; Tudor Ambarus
> > <tudor.ambarus@linaro.org>; Will McVicker <willmcvicker@google.com>;
> > kernel-team@android.com; linux-scsi@vger.kernel.org;
> > devicetree@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux=
-
> > samsung-soc@vger.kernel.org; linux-kernel@vger.kernel.org; Andr=C3=A9 D=
raszik
> > <andre.draszik@linaro.org>
> > Subject: [PATCH] scsi: ufs: dt-bindings: exynos: add power-domains
> >=20
> > The UFS controller can be part of a power domain, so we need to allow t=
he
> > relevant property 'power-domains'.
> >=20
> In Exynos, power domains has a boundary at _block_ level. I assume in thi=
s
> case it is BLK_HSI, which contains, multiple IPs within block, including =
UFS
> controller.

On gs101, there are three hsi power domains:
* hsi0 (USB)
* hsi1 (PCIe)
* hsi2 (UFS)

I have not looked at hsi1 so far.

From what I can gather, hsi2-pd affects:
* cmu_hsi2
* sysreg hsi2
* pinctrl (gpio) hsi2
* ufs
* ufs-phy
(not sure if there is more)

hsi0-pd is similar, except that there is no pinctrl (gpio) hsi0.

They're all modelled as individual nodes in DT, so we need to add the
power-domains =3D <>
to each of them.

> I hope you will be sending the corresponding DTS changes as well.=20

Yes, of course :-)

> Feel free to add=20
> Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>

Thanks :-)

Cheers,
Andre'
