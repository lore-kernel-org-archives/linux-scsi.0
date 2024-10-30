Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C5F1E6DC1
	for <linux-scsi@vger.kernel.org>; Wed, 30 Oct 2024 11:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730287935; cv=none; b=vFsgWxEv8p5c3OY2ACTRyAPtvA5BMXPcec045Tj2iZH4qgBh6cgUfr+e1cE0bJcnT2tVti3OlrnMX275tSdPri+91C679hTcA/l3zqXGbiw2pzGOFDYGEU6jnUSDtwCIdFoOJOLaZQrp6ck3OLQrLIxeRQkAaa4jzeD3NNSUQiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730287935; c=relaxed/simple;
	bh=k9O/VCkYKLFGLLz5VK9IVO5AXC7ZgN1iqzf8qQY9YxM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H7/krcOm2p+9GEvxtkVkeUgP6C25MNQevcwFq3nkSnplr/KoG+Ayq7DCUa0zN4qVSOJLB3diBYnkzaeeIFe9vGAEXWPeq/sZFmfXSnExDak1JR6gHR97eXGiVuvZ8d+ySH1QqBw29TXpsXfyYCwxpNYss58NHzrGOVDOaVFiSrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=yhvrqPCo; arc=none smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yhvrqPCo"
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-5eb5be68c7dso3521597eaf.0
        for <linux-scsi@vger.kernel.org>; Wed, 30 Oct 2024 04:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730287932; x=1730892732; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+ZnP8od1AoS68OxrD2EKkqTHcwqcNcZbwTyrj6OQuRU=;
        b=yhvrqPCoaLTYq2FW9XD16KFOPPIuLIVtN0MOP2QSqU+IqzuEDIHXcUizOcYprjYKgc
         HgK4Z9imwxuTyDJlngg0k9ErEMGE0k6GXLxEaAcdxQDkVndfisrhznZUr9S1YFrWtp0S
         OmvYjSSUFQeaTYr0lfQgYI9W2pUV/K/D9/u69LnzMjcujIazmEhG8sf39ZD4GfR9Gypm
         haezwr1fZZKCc2y1z9t9W6jtScyyQ65LxNNAC2aLWh2FaLC/cef+Pj03orqftzJOr309
         VSyewk7igcIagIVOyC6gHGbXxuRL1u4IIaB33Lvx466h6iBp95ay4jDM92NU0hLP/Bn7
         8hBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730287932; x=1730892732;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+ZnP8od1AoS68OxrD2EKkqTHcwqcNcZbwTyrj6OQuRU=;
        b=sSsZATQ1pyVJZnEh1T0GRLQjPaBDrbBX8m5VU4vnRsoETuI0oy9JNmKEWsSUx6yjjg
         VwGsRzmZIG+g21IO+F9+3Fyc7jpnsttTB5AtYc5mhC/du9kluzeP1yDOrGTvOcZXbo0A
         VFlLWD4JHl7YiCkROioL7eTZgmQgeYKkNanEYsELS10Q7rFwubMy6e2kz1G1gmne39he
         uD/pUyIpSJSgra5aYEexJy3HMbBXYRa1PpzYpNpfPtks07o0j/rD3cyOstFOc1vmUx0Q
         nuOr33u4llV8KKnxh+Qt6K3w57IgegOWrlRQinT4E1rNmQH4mfhOGlfF3BgiuffXSO3q
         GTGg==
X-Forwarded-Encrypted: i=1; AJvYcCUTSC06d/yHSWVdTCx9Gmx06eXbvLRWMP+v0GUKjnvPSTzm2TwIYFQ4T86ncJOxmQaJOxUjcjFZk3e8@vger.kernel.org
X-Gm-Message-State: AOJu0YydXHh9wiJ7KT9wzrlwzTi9psoF/vuw3Gouv8mncvgPGBEMknf+
	Jvkdxy9TmTQkne1Z4tSbjz4+otY+qhUJ2QnEGe4nA9P2BwEYcWzjnV8dErV5NbIBByn/EZcvr9A
	GRz7elNZWguzBRc/S+nWXKdgn0a4wQXWH1xCmIQ==
X-Google-Smtp-Source: AGHT+IH5be5Mr1er2W4DdwEw1rjAXcGrKtgAvcc+9eVHVJEX4M1n7mMvnvbRCoX7iQbyEopTs/p0KKfykVLViPIPPBE=
X-Received: by 2002:a05:6820:229c:b0:5eb:fc8c:46ad with SMTP id
 006d021491bc7-5ec23612f9amr11574862eaf.0.1730287931746; Wed, 30 Oct 2024
 04:32:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241025131442.112862-1-peter.griffin@linaro.org>
 <20241025131442.112862-9-peter.griffin@linaro.org> <436b02c6-a262-4015-92e3-454d444e877f@linaro.org>
In-Reply-To: <436b02c6-a262-4015-92e3-454d444e877f@linaro.org>
From: Peter Griffin <peter.griffin@linaro.org>
Date: Wed, 30 Oct 2024 11:32:00 +0000
Message-ID: <CADrjBPoq2jbrMC7wBrjGxMwQ1ebTtBNRQzQ7NfE9=Gw9_4LQ6A@mail.gmail.com>
Subject: Re: [PATCH v2 08/11] scsi: ufs: exynos: enable write line unique
 transactions on gs101
To: Tudor Ambarus <tudor.ambarus@linaro.org>
Cc: alim.akhtar@samsung.com, James.Bottomley@hansenpartnership.com, 
	martin.petersen@oracle.com, avri.altman@wdc.com, bvanassche@acm.org, 
	krzk@kernel.org, andre.draszik@linaro.org, kernel-team@android.com, 
	willmcvicker@google.com, linux-scsi@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ebiggers@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Tudor,

On Wed, 30 Oct 2024 at 11:25, Tudor Ambarus <tudor.ambarus@linaro.org> wrote:
>
>
>
> On 10/25/24 2:14 PM, Peter Griffin wrote:
> > Previously just AXIDMA_RWDATA_BURST_LEN[3:0] field was set to 8.
>
> where was this set?

It is set to 0xf in exynos_ufs_post_link() function, see the following line
hci_writel(ufs, 0xf, HCI_AXIDMA_RWDATA_BURST_LEN);

As all other SoCs expect the current value, I've left that assignment
in the common function, and we update it in the  gs101_ufs_post_link()
specific hook.

>
> >
> > To enable WLU transaction additionally we need to set Write Line
> > Unique enable [31], Write Line Unique Burst Length [30:27] and
> > AXIDMA_RWDATA_BURST_LEN[3:0].
> >
> > To support WLU transaction, both burth length fields need to be 0x3.
> >
>
> typo, s/burth/burst

Will fix.

Peter
