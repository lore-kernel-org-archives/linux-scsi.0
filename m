Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53839FBF6
	for <linux-scsi@vger.kernel.org>; Sat, 15 Nov 2025 16:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763223008; cv=none; b=Hkud2kGI13ihZmp8U7NNP8RO3DwCYTKuJtfCusyrr+7vaia4Mt7KentyXoCRdeLmeKIobNnkQh9Riw+Nve2G4cA+uoJnP1W+hBDOWmmf0WWZejJd4wXLq0mMUICV2yryHkJnH2DGaLdxlGhDPJ4hxC3QNFAs5IcjWZd+nQMGKJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763223008; c=relaxed/simple;
	bh=I14kLesRGajc8rUqwKsLdg+/ND1r/lbjM/lRzyYc6TY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iZN2BDtU8uhd5zI0fPQ+p8KHWVVDyk18XLkJ7twOcpmQ0BjW7mSC42Kk3h9vEL8XZPFyavxOf2s9IzvOdUJljNVImNkqRWXHliB8aCKEW8IZyQdTIixJrEhZ1u9wpffQQz+Q2+7OJDXZdJoKluWbQJjIwfN3VM1AVz9+U0LWgJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=h/cdUL4q; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="h/cdUL4q"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-42b3c965df5so1846521f8f.1
        for <linux-scsi@vger.kernel.org>; Sat, 15 Nov 2025 08:10:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1763223002; x=1763827802; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=I14kLesRGajc8rUqwKsLdg+/ND1r/lbjM/lRzyYc6TY=;
        b=h/cdUL4q+umN9zy+/ovbDhteqKOE2tE98ZLv1ST47guZDWRur6/M1FBUomXJudE5yJ
         DDXySKKDA9AJpQ7eyuJhsMy7xARxEBZxv5NezLpJxy3vnTBlWjwXxbb3pjpqD1OSnUlf
         gmJ/tUu1dcNwj8zUZ8O8E+zp7TxBIEF+m9m7tvem1QensNN46jsPkk71+cfBj+U5+mY4
         dbMyeU3nYS9mAL63qeF8UqDF96WjMTAQlO5t3bT0lV0zJp+YlZgq1hHFEAFrpxmDcYuV
         S9fUkh2wbifFFdm2mHDTOSiheoBZ3idG+03oga6GqZeRDhB5t4Be+9qIf2bAXgFrXiWk
         LFtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763223002; x=1763827802;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I14kLesRGajc8rUqwKsLdg+/ND1r/lbjM/lRzyYc6TY=;
        b=GqbOg7A/kV/N3R8TarJr5mQCxSWh16ClNue6GnWMh79PMMgKKS48iwKjGsmJCfCxN9
         po9pHZmsDv69BGqJ58Bq5C2HTDiM8yLeg3+8mwcSFhDKTlAqcCb3WBTwsVQbIdGVKnii
         6rX50CnKac6LbEVkYs88xwKeGDy+F3z/GF/sr+1A/VZt2bi5uuw3ktQaHzvBhqM61MsQ
         QNzsTZi3VnulhfJt1rmc8IOF+DBulWXRHMMIGCuMQgWSDffby7OwOhLr/nVMs1iBmT2K
         Wn5izrXwwlcsdXlXfUftZDqgLWiInw/LRKxXgXF20hNChlXjK14AIiKFVsMu6qzCS+gA
         WPvw==
X-Gm-Message-State: AOJu0YyipOKjwVCpcanIgICRZsNyvDLoOdCZY6tEhXioiUrTanU+hwGe
	aj4WgXu4nm5fRsxO/Kk/GlelY8OUWHRQM+K5yadgfd8iNtzJNkCN45NnmoqLLoNRIBE=
X-Gm-Gg: ASbGncsaivnOcZc/V9tfFzsWqE9flcsCYC3R6spoVvHrU4r5Y0syNfKTxQ5wKL/MfdA
	7tl28Hi5cUUNRcDFN4F+SDPBKik0YYNVrA8/AWwQuHeUAOICFoUZsTa7HKqUXnIL3mhWDCrfAyU
	reMIXNHwiQ9NLSybdmJ8IT+NWOGHiKTLlp93IZ4ZqR+WXImFrMjxlIoN3Sp+UzayT53i9Lq1SoQ
	EVwJpqNNn614O/+YwKPjWXlyMV5ZWM1Sx5FgrkE/E5VLbjKOwGF7P3GwTrA6ybcvYRhcHljc6AB
	LR9c8EZJe6+Pi00Zu1bwMeJe70iDzM9V2ME9wab7w1M/HgwmFnZ9BQoWDxbcKWZOXBNEyXIMBvg
	c66xBr/LSLSTllTOp0AOrrnci2DwAITX8Fph9XT/AFX9ss5qH5NmfuXP/hJ6zc+axZt55dGwngi
	+983y1SGbuJECpx0UotVAkENl/TeMh
X-Google-Smtp-Source: AGHT+IF2tHbeirwKQq5pa1wrWzTfmU4GKsrRbeI0+mHbXGLg9rgfyo4AKK4FDHApeGHxQ4Gh5R4Qbw==
X-Received: by 2002:a05:6000:3111:b0:42b:5603:3ce6 with SMTP id ffacd0b85a97d-42b593503e9mr6224322f8f.18.1763223002469;
        Sat, 15 Nov 2025 08:10:02 -0800 (PST)
Received: from draszik.lan ([212.129.81.164])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53e85627sm17589088f8f.16.2025.11.15.08.10.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Nov 2025 08:10:01 -0800 (PST)
Message-ID: <9de4a893e2c3cf8c5d8337589b02b3eb883afeef.camel@linaro.org>
Subject: Re: [PATCH] ufs: core: Fix single doorbell mode support
From: =?ISO-8859-1?Q?Andr=E9?= Draszik <andre.draszik@linaro.org>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	 <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>,
  "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, Peter Wang
 <peter.wang@mediatek.com>, Ziqi Chen	 <quic_ziqichen@quicinc.com>, Can Guo
 <quic_cang@quicinc.com>, Manivannan Sadhasivam <mani@kernel.org>, "Bao D.
 Nguyen" <quic_nguyenb@quicinc.com>, Bean Huo <beanhuo@micron.com>
Date: Sat, 15 Nov 2025 16:10:02 +0000
In-Reply-To: <20251114193406.3097237-1-bvanassche@acm.org>
References: <20251114193406.3097237-1-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-2+build3 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2025-11-14 at 11:34 -0800, Bart Van Assche wrote:
> Commit 22089c218037 ("scsi: ufs: core: Optimize the hot path")
> accidentally broke support for the legacy single doorbell mode.
> The tag_set.shared_tags pointer is only !=3D NULL if shared tag support i=
s
> enabled. The UFS driver only enables shared tag support in MCQ mode.
>=20
> Fix this by handling legacy and MCQ modes differently in
> ufshcd_tag_to_cmd().
>=20
> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Closes: https://lore.kernel.org/linux-scsi/c988a6dd-588d-4dbc-ab83-bbee17=
f2a686@samsung.com/
> Reported-by: Andr=C3=A9 Draszik <andre.draszik@linaro.org>
> Closes: https://lore.kernel.org/linux-scsi/83ffbceb9e66b2a3b6096231551d96=
9034ed8a74.camel@linaro.org/
> Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Fixes: 22089c218037 ("scsi: ufs: core: Optimize the hot path")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> =C2=A0drivers/ufs/core/ufshcd-priv.h | 7 ++++++-
> =C2=A01 file changed, 6 insertions(+), 1 deletion(-)

This fixes it for me on Pixel 6, too.

Tested-by: Andr=C3=A9 Draszik <andre.draszik@linaro.org>


Thanks Bart for the quick fix!
