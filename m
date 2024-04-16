Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F64C1292C9
	for <linux-scsi@vger.kernel.org>; Tue, 16 Apr 2024 10:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713264763; cv=none; b=TX3MThU3Nvq0oyZV+p7zSF/GdWieRd+rrxzhlO/7uy6xFBRNPOdO+oUqUeZIh/KpX0w/xUNEr3Cfyw/rHrhEgyXTpy6UBj+CCd2yxrImofWZWcRjXzHfFCvQMP/2p8gzqru4C3eD7mwYf4drQ8l/EKHPeUbAfgpDs0VmWV7bqTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713264763; c=relaxed/simple;
	bh=jpcWEFpjeFpqj4mlg7734V1qNoTx1GGeLMyhzIC8jTI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lP3qOGdWShfhCAk0iWmiaYftVOMCLonwfzQOcNvPYL80NZR+h0snXpL4o0ZInYI3+wzvI2jjjYdl7kSX+BxlE3ZQJ7wu/W4GqgQMRy1LFH7XVnGHk/vSwlD7zLlDbIpAKrR2s7Ns0Pk1mPZnWvBA3juWi5RFNbdMZUN64ytQYUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wclPlGpv; arc=none smtp.client-ip=209.85.161.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wclPlGpv"
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-5aa1fe2ad39so2914936eaf.2
        for <linux-scsi@vger.kernel.org>; Tue, 16 Apr 2024 03:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1713264761; x=1713869561; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E0TxxrwK3iCE49uLbQ7sQ5tDEvF/HbWHLGi4XWFVqlw=;
        b=wclPlGpvY+oztbeNpgoJ4mU+4bHlRx1Jq8mzNA9YLYsoUzGWAAqVEoDYgR0C3ZDV2v
         XvAyuG1yY7sgXsCOtK66cOzKhcGsnk/cgCrOkpDUn0mt3rRFzjTwcyyyOGOzL9fZcPS6
         BVvI5SzwXrNUv7idZgf/bBaCjZOdEiVePaN+L/QH3rYtfLmBiNluht4bI5+ZSX6mU28j
         xx6hCYv+0j6F2RB2sUZrSuzYazBEqFlQUWOobHvqqjCdtnO5ynnCepD1T9pYtyctkpGj
         6NXFp5fruJ0rGK8CVQAFRkl8rHHyEG4YiO3QNdmVp0wp52tlmJrQoo6c0+ZgjA04SvJV
         JcGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713264761; x=1713869561;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E0TxxrwK3iCE49uLbQ7sQ5tDEvF/HbWHLGi4XWFVqlw=;
        b=TV/KBqO3doB+hyUeyV60jP9vKpbB5mp6rKFy+S9D0Tc49zZhtLtukcJ0Sdud5RTlE3
         Pp2mw07IDRbeil98XIGvreRHqHleUV5ZddhR1NQ1wy5arm4q314cnlIzh+xuhRQDu4xk
         2tBhAf86INf70CU+EMJWHTUcrA+D+4QaV6ztoD0RC4lZ8m9KvyWKKMRH08tb6/lbOnAj
         5cK+1mG3i3XuoytMP36Vwc/kQOoRZiNeeqrUIvMJ+9cI0g4coCFZIUHFTCI24EWUX5lR
         LFAlhdexuQ4EvL/5pd9QipFBd1FWB8VtU8aPkQmOQOGeueZfzzPVaBiOO1biHt35Sb11
         99aQ==
X-Forwarded-Encrypted: i=1; AJvYcCUyCqlXF+UPaiUp8hda1Ug+0z63io8grePn9B/Tr/xrTaiqTZP27631MLXGB4/gqtww/j1DaNxCa5KQjmSeMrjimcR0xIXMVhplaQ==
X-Gm-Message-State: AOJu0Yx2m8F4SRQVfroZq6WStoQ9BijBv3AuzhOE6r4I19avVrCuzoCc
	/5kpiHzs9FXGKRKeFiGoRSFzXuoaOut9uSeVxS6rpQcDeqP+gX9jHM5hC7m8eWvKFaAO2Q7Fdky
	pQ820P8kWzCHnC/xEDmikEK8rV3yQEA78MmmHTg==
X-Google-Smtp-Source: AGHT+IEqEeJmQdQehCPTNQQMD/tcR6Uw0Nol676WtmyqwgXlvaaJnzKAMXtuWis/RQBtHTHTt/sD2iWj7telCINa9U0=
X-Received: by 2002:a4a:aecb:0:b0:5ac:9efc:3b02 with SMTP id
 v11-20020a4aaecb000000b005ac9efc3b02mr5382919oon.8.1713264761347; Tue, 16 Apr
 2024 03:52:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240404122559.898930-1-peter.griffin@linaro.org>
 <20240404122559.898930-2-peter.griffin@linaro.org> <d1aaa3a350315b8eb60aaee416fad4382385ca3a.camel@linaro.org>
In-Reply-To: <d1aaa3a350315b8eb60aaee416fad4382385ca3a.camel@linaro.org>
From: Peter Griffin <peter.griffin@linaro.org>
Date: Tue, 16 Apr 2024 11:52:30 +0100
Message-ID: <CADrjBPoMWDqUQiW3YUxKxCRJAXzJb=-eL_kfpeMHgaqg8c1HJg@mail.gmail.com>
Subject: Re: [PATCH 01/17] dt-bindings: clock: google,gs101-clock: add HSI2
 clock management unit
To: =?UTF-8?Q?Andr=C3=A9_Draszik?= <andre.draszik@linaro.org>
Cc: mturquette@baylibre.com, sboyd@kernel.org, robh@kernel.org, 
	krzk+dt@kernel.org, conor+dt@kernel.org, vkoul@kernel.org, kishon@kernel.org, 
	alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org, 
	s.nawrocki@samsung.com, cw00.choi@samsung.com, jejb@linux.ibm.com, 
	martin.petersen@oracle.com, chanho61.park@samsung.com, ebiggers@kernel.org, 
	linux-scsi@vger.kernel.org, linux-phy@lists.infradead.org, 
	devicetree@vger.kernel.org, linux-clk@vger.kernel.org, 
	linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, tudor.ambarus@linaro.org, 
	saravanak@google.com, willmcvicker@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Andr=C3=A9,

Thanks for the review feedback.

On Fri, 5 Apr 2024 at 08:15, Andr=C3=A9 Draszik <andre.draszik@linaro.org> =
wrote:
>
> Hi Pete,
>
> On Thu, 2024-04-04 at 13:25 +0100, Peter Griffin wrote:
> > Add dt schema documentation and clock IDs for the High Speed Interface
> > 2 (HSI2) clock management unit. This CMU feeds high speed interfaces
> > such as PCIe and UFS.
> >
> > Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> > ---
> >  .../bindings/clock/google,gs101-clock.yaml    | 30 +++++++++++++++++--
> >  1 file changed, 28 insertions(+), 2 deletions(-)
> >
> > diff --git a/Documentation/devicetree/bindings/clock/google,gs101-clock=
.yaml b/Documentation/devicetree/bindings/clock/google,gs101-
> > clock.yaml
> > index 1d2bcea41c85..a202fd5d1ead 100644
> > --- a/Documentation/devicetree/bindings/clock/google,gs101-clock.yaml
> > +++ b/Documentation/devicetree/bindings/clock/google,gs101-clock.yaml
> > @@ -32,14 +32,15 @@ properties:
> >        - google,gs101-cmu-misc
> >        - google,gs101-cmu-peric0
> >        - google,gs101-cmu-peric1
> > +      - google,gs101-cmu-hsi2
>
> Can you keep this alphabetical and add hsi before misc please.

Will fix

> >
> >    clocks:
> >      minItems: 1
> > -    maxItems: 3
> > +    maxItems: 5
> >
> >    clock-names:
> >      minItems: 1
> > -    maxItems: 3
> > +    maxItems: 5
> >
> >    "#clock-cells":
> >      const: 1
> > @@ -112,6 +113,31 @@ allOf:
> >              - const: bus
> >              - const: ip
> >
> > +  - if:
> > +      properties:
> > +        compatible:
> > +          contains:
> > +            enum:
> > +              - google,gs101-cmu-hsi2
>
> this block should also come before misc please.

Will fix

>
> Once done, feel free to add
>
> Reviewed-by: Andr=C3=A9 Draszik <andre.draszik@linaro.org>

Thanks!

regards,

Pete
