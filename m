Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F70C2B9D4
	for <linux-scsi@vger.kernel.org>; Mon,  8 Jul 2024 10:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720433589; cv=none; b=CTt1VFm4cQk9aGCllLpmNf3S+Mtagw8PYmVYx9JtivabeMBKdzqeYXmmecmBx/dhXF7fC3Z9X4braUf4dlvxCY/lTtLwQ7J6nG6Qxsu4L7VNY2/9UimGGV/UpXeyk6cq4CHMf7YwB0CA9ARpnXkyd8qa2HEJGSNrGyj0HnySr/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720433589; c=relaxed/simple;
	bh=2RmdxV+3VSNyvZhEEgpIWbdydLkzqKnXJBVxNC6Ml3s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t1J8cpUJy4rYVmVLxqrG8zPTZ/5/70t8aTu73r7axfKHfdmkcd78wVMv6+1XMGaNymj9sE989Ad2XOipT8aJ2/HrsXVz6dqXCL/RWfFAzPzLOwvRYYN4w2/wM0x4PqqBm5t5yGKDGvDKuTk4jAKMaG/00AL+ooqfM97j5PHVQkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hGBA/mAh; arc=none smtp.client-ip=209.85.161.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hGBA/mAh"
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-5b9a35a0901so1272967eaf.0
        for <linux-scsi@vger.kernel.org>; Mon, 08 Jul 2024 03:13:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1720433585; x=1721038385; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NynB88z8W6QEiHA6gsmDf2tTIxeEI7sjADoAf98ZwG8=;
        b=hGBA/mAhUJsOR8FxfY9p67HU1zm2G8Pqq5jkJJlEUDbLS3FO9VNmnsXcMh45DczdyR
         Zo1ckDCcYiDVt+YLl1hjlgKYBFBnYhA6aQdio+/65/gYn4QDd1fOO2X2PpiHOUud1ebH
         qdZKnppYRMmNm/0FmEtzEq781Srt61tdrv2COra9Ti9TyUfLxddtuP9JAlmFfu1B9EOa
         HvSD9pKtUYubdg1yULJ5LzHcnJ3WvcIC+7xCOHwXjtcY6g8qHhB3k8zZN8JiZYDVNzNL
         s30cdkH0x12wZm0N51KqC2yUpuioSwLo9xqoKAtVuW7n35gcKlo4Or/4ZAWdssHgN02z
         8C0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720433585; x=1721038385;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NynB88z8W6QEiHA6gsmDf2tTIxeEI7sjADoAf98ZwG8=;
        b=ftGHIRxJo7jaPW7BD/2W3IsF9BMB4BdjfZKnxDqcfWbtP4jLk9Z1BEkQRAqnMyDrnF
         HA3JUv43NJn3zPb+dSUtpWMisKGbp3u6Mm8cN6hwTgMjTR2dOOCFNgeAg3SJogb1d/UD
         jB9krW3rsokT6V24EE9ucfUOf6RPLfdNeFKzz+1udWoO5+CA82sUHJeloJjy8shlboMD
         i8tyWWWf/kuwVTx2uVHlhG/COWl+gVVGXsRvc3sNILjBsMDBqKqSfMOAgvvutzJZWhOI
         DXzpAJblOIDdUXvbvcyvwWdDV9H4hV5LSk3QWbFYtHiFBPYXUlKh/ytHwqLGsQpb/RMg
         BDzw==
X-Gm-Message-State: AOJu0YzktBA2JlbgmjyRrkHkkmk/Fi4iEDnDI6VNhLpeFkODIaq8LDIv
	OX2RhfzABnjpxq1QW+vhLaGh2aWnp6cxuNArOEoZ0XxbCFxs7jvM5nd3GHQpqPJBcMhbKHx3WIV
	gWSp4AJNiDVT+6GPEm+74f1J6+qVx7cGm6Olflw==
X-Google-Smtp-Source: AGHT+IGivyDRrIsg9lng9e/JVVkngxmkaCgNcGy0evjFYNtJazKIxfyqs/mZGknAEQ9yczSNL2j+NXR7PUtpSN+8eKE=
X-Received: by 2002:a4a:5404:0:b0:5c4:57b6:ffbf with SMTP id
 006d021491bc7-5c646cda66dmr9779604eaf.0.1720433585464; Mon, 08 Jul 2024
 03:13:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240702072510.248272-1-ebiggers@kernel.org> <20240702072510.248272-5-ebiggers@kernel.org>
In-Reply-To: <20240702072510.248272-5-ebiggers@kernel.org>
From: Peter Griffin <peter.griffin@linaro.org>
Date: Mon, 8 Jul 2024 11:12:54 +0100
Message-ID: <CADrjBPqXOJ6h+Vx9tUgvC7fGPPySzZDA+M80rEDBsqBHEMsCqg@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] scsi: ufs: core: Add fill_crypto_prdt variant op
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-samsung-soc@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, =?UTF-8?Q?Andr=C3=A9_Draszik?= <andre.draszik@linaro.org>, 
	William McVicker <willmcvicker@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi Eric,

On Tue, 2 Jul 2024 at 08:28, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Add a variant op to allow host drivers to initialize nonstandard
> crypto-related fields in the PRDT.  This is needed to support inline
> encryption on the "Exynos" UFS controller.
>
> Note that this will be used together with the support for overriding the
> PRDT entry size that was already added by commit ada1e653a5ea ("scsi:
> ufs: core: Allow UFS host drivers to override the sg entry size").
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---

Reviewed-by:  Peter Griffin <peter.griffin@linaro.org>

[..]

regards,

Peter
