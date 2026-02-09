Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1405228725B
	for <linux-scsi@vger.kernel.org>; Mon,  9 Feb 2026 14:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648715; cv=none; b=VlzRXLtRyDBpsWgV8xsmKpImkN/1wiBKNhJRJlrqwJBsbY81qrOHZUu4XeXkMukiwTroJkKEX1zlcbXO+DYxiEDRa0245wihXEi50fbC8KBOQPRmuwTyIaznYwNguDHZJH95bYa2AMr6hMiDx0kUhbNuBIa3VgKe/dhefcHuFF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648715; c=relaxed/simple;
	bh=lcaV+/NenUzIzdCorLQUAbikrOG7FUJR7yri/AysGyA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=edst3WIzuT5SG+yBk08DV2x9bhWeC5sj4f0JPLth25G/gfG+FNBSJJrbxCnOT3uOdPQRLq580Za/Dgfx+1tKa1RBo0PTzSRnykHRCUuarYQvjA5SsrhOuBD3suS5WNNMw7R1qEuw2tSJaTaCfw9wguk5JxMpeAXgDRGh3pPHKlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WNQcKWJT; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WNQcKWJT"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b884a84e622so789653966b.1
        for <linux-scsi@vger.kernel.org>; Mon, 09 Feb 2026 06:51:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770648713; x=1771253513; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lcaV+/NenUzIzdCorLQUAbikrOG7FUJR7yri/AysGyA=;
        b=WNQcKWJT/XzYKcRzT6H09eqeQoo5QGEvB3qwX9xpXcRdbnHhhTb4ph2IojBSE9hH78
         HhvQrshjolTVWcXSo+SuX241gGayjEsv+8rt+FpuMSXr9V/eWBZcHvfuxuI3pUdZHByr
         Pb+ZvfggPPCB8rEQ3eKWWgFzonWNxKhqDkIESY7ysqMH3vJtIFqssHHs4HX7z7ARGLEQ
         2T2656Z9SVF4zW6CgcGzMRfHiYEh4um7aNjXOfXZ6FGPjiJPr2O/ukbPnWAY2uWiUBxA
         k38pc7PLYVrFw+TS8fr2Ovwqju95eNyDLgHkRvhE2UalDCb1ub2jKzQSzPFQgHxcEe0S
         h9MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770648713; x=1771253513;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lcaV+/NenUzIzdCorLQUAbikrOG7FUJR7yri/AysGyA=;
        b=AjGK0TDfRCuZJKYbp7w89XYsDNgdPThH/moclCOb8ehWYanRY5W9JoqD6wERIHCtWB
         8PSKgLzk/x5Zg5A1GxMMSAT3+LrTlswTLh3B1K4Ho1478isjZgtnMVZFAfOx2gRxlVdC
         O5IA3/L4fbSZ2IqkxQVURqzFKPly1U+kSizCxH6kk4j5Lc85+m3e3ENaC25nEjaJZo08
         35aTYiwbL/ZWoNm8WCrRmoz0xiA29Q5aqI1K34lY8KSy4qqUi4mR79UjYpEkDr+9WizE
         FRAXMz5pr4IOeHsB/s4iv7vTO/brNRBKy6YwqgWrAPQ3gGYfeMFpiaJyXmUsJKD4NO0P
         HsBg==
X-Gm-Message-State: AOJu0Yz2CuEFPFJXp3OPgc157gAnEoDWHg+BYL17n4dN+xx7EOOIN/MW
	3BAYI2THolGYAvExIH4Fe0LZY5HbfnvQoOXKQ0IocnPObepcUU7o71CN
X-Gm-Gg: AZuq6aJgZfyzgpb6ffN0Ot0MM53jmhw6QxicU/Rf0d2GB3nazEUn9saWCUtvFd9UejP
	Hhy++gCsRdG0pE7R3419U9KVq4XNyQZFN5TcMXedL2zFx6aSKuYVIPD7va2WVtXVdretbFJ8kFx
	vnE2akImGHRT8bmq6KfgIq8Zc3sSCuQ1GThrBzew+Kl8fZzjNf9DezU+wNQHorc71noq4Q1xaj3
	jEix83RqWK7LCW0y8ZDJ72pSqXgeU9CfkY6yFj9CRM5337mIAtXLVYa7zf0Mgg6zQx/toxGRg/k
	Id8aJ0OQwE1KTGWgNsXMjcKs8+lKECOLj7I3lqVG1G0ItVpa5BlVJ3vfaS6M5ylviOPx8uAaeYB
	OpTvD1tDHnkvIp1OKz5zPQQcKZn0id9+ElQQr4rx1Jjz1dlyMjHvs5DjdWefGUy3Q1AmCm0uPcq
	ZZ35c/4re3LGIPlA==
X-Received: by 2002:a17:906:730d:b0:b7c:e320:5232 with SMTP id a640c23a62f3a-b8edf11b357mr695742566b.5.1770648713193;
        Mon, 09 Feb 2026 06:51:53 -0800 (PST)
Received: from [10.176.235.211] ([137.201.254.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8eda7a5a31sm406314366b.24.2026.02.09.06.51.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Feb 2026 06:51:52 -0800 (PST)
Message-ID: <e96f69b108eb13a87838581aef9325dd74c556d0.camel@gmail.com>
Subject: Re: [PATCH v2] scsi: ufs: core: Fix RPMB region size detection for
 UFS 2.2
From: Bean Huo <huobean@gmail.com>
To: Alexey Charkov <alchark@flipper.net>, Alim Akhtar
 <alim.akhtar@samsung.com>,  Avri Altman <avri.altman@wdc.com>, Bart Van
 Assche <bvanassche@acm.org>, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, Bean Huo <beanhuo@micron.com>, Can Guo
 <can.guo@oss.qualcomm.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Date: Mon, 09 Feb 2026 15:51:50 +0100
In-Reply-To: <20260205-ufs-rpmb-v2-1-5e1572ee52bf@flipper.net>
References: <20260205-ufs-rpmb-v2-1-5e1572ee52bf@flipper.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2026-02-05 at 12:30 +0400, Alexey Charkov wrote:
> Older UFS spec devices (2.2 and earlier) do not expose per-region RPMB
> sizes, as only one RPMB region is supported. In such cases, the size of
> the single RPMB region can be deduced from the Logical Block Count and
> Logical Block Size fields in the RPMB Unit Descriptor.
>=20
> Add a fallback mechanism to calculate the RPMB region size from these
> fields if the device implements an older spec, so that the RPMB driver
> can work with such devices - otherwise it silently skips the whole RPMB.
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Section 14.1.4.6 (RPMB Unit De=
scriptor)
>=20
> Link: https://www.jedec.org/system/files/docs/JESD220C-2_2.pdf
> Cc: stable@vger.kernel.org
> Fixes: b06b8c421485 ("scsi: ufs: core: Add OP-TEE based RPMB driver for U=
FS
> devices")
> Signed-off-by: Alexey Charkov <alchark@flipper.net>

Hi Alexey,

please address Bart's suggestion in the next version, and add my reviewed t=
ag.

Reviewed-by: Bean Huo <beanhuo@micron.com>


Kind regards,
Bean
