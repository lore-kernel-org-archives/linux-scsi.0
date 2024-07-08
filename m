Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D99377101
	for <linux-scsi@vger.kernel.org>; Mon,  8 Jul 2024 10:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720433198; cv=none; b=E7LSWHKvHO3TPkFZlVDJgSJsIgoJZPEqeS8sR/EYnyxicrxpd84UVoWhz39SM5t4dcgjJzW+NCENwV/71LRBTcIqGdCcj0Wor01E3HTu8GoEXh5ge0HiLpHlFW+QxmhqC75aYdBoFMtu6jXpNTSkBDn45W6R+oRyH/K5n7TQT3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720433198; c=relaxed/simple;
	bh=P7OaU1ezIgpW6/4WHytXBtMimP58RhF0QQzrz4kizWM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=k8IDZiYRD5oAa9Y6KwuKdMKwQMWOipoAUP/tVB6A6hXmtWiVkU6onssKGA8PKLJnzsbyQn2eU9rDLkee31TgtbPmqLPYUb5FgdiAy/Puk/6XTqaoqDd87bYdtavpkRM8AxqHtBSqnRp8foERv2A5UB0ZAYZYQjtDNTL8OaOkDQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dK/6uR6G; arc=none smtp.client-ip=209.85.167.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dK/6uR6G"
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-3d921528d92so888696b6e.3
        for <linux-scsi@vger.kernel.org>; Mon, 08 Jul 2024 03:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1720433196; x=1721037996; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qWX5Q5O5NiALQ1tJK5ppQuf8O8WFA9Gn/tOulONtFsw=;
        b=dK/6uR6GigwEiu8Jg+E+PwJtnzceh+Yf8HPkKqDUSTE83sabD9HqcI0Yx1dG8yB0Im
         FYdldXPEadysLEm9nsYjE44BA/XMfJ9C3NlZ5bw49QVt6pHozjHgExATuYb69weKk6OZ
         yzOaf6FUWJEsVBaQjQ3KmqEZX8mN0KMCT53fx31CnScoW1hEYmAsGKiWnkwqs0Qq5+g5
         zkvfqqg7C3krJeugC/P2ga0NHzXO5AyVnk+oYJhAtDmI+oGLhuXL2lsNNawMJ5ChrUGg
         9SaD/IqnUNEiEd9oWGTX5ckAdSKFVDqSLePZ5iw2j+aw6TuE0SJSlp6f/5ETmuH+NA0z
         la0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720433196; x=1721037996;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qWX5Q5O5NiALQ1tJK5ppQuf8O8WFA9Gn/tOulONtFsw=;
        b=doJkoabFYkYFXM6Vyg+0OI/YLxqQlCGv1Kq+vhqrxGZQW2TthcURLeeizixBOcuNjA
         Qk9IfREsyCO0m3Xw0bFOhnPcQWUJY05qljryqPkGdTUZatJH8fLfdt9OCvL6TwW2jKsf
         gjKSwbHf9snAx2NWdzxoUZ43dzSg0tBMVjRM2mFlbSYHGYl3B0Sko30g2+JfI6ldOQ7u
         n3OKE0JfHm4zQTxUDv3HnnbplwuhQbRSCtz7B80790rQjvZF2ERJlkNulF1lACKyAA4B
         SgWj1cazyRV0FoOj05Zaw3ntTxugNpFssU/Y1sQkR/2UUZeqVjaYhR9ndiWta2ZHxCXT
         /BJg==
X-Gm-Message-State: AOJu0YyjdwXyz7moTZFa+g/re6tn4TdM89KBcpr637jAU/iH6nClAaAL
	VS522wALXzxnOq/xEnOFMgBN722uugxXrRIuJ1Xb9TY3el56kbswieMcKxF/M4RIRPNcOvjvO/E
	mZLxZPdTnXh4cEg+mKZjIjv8AeSRCzKSPVa2tYw==
X-Google-Smtp-Source: AGHT+IEgQYbQmWGrt9fgyJiO0ChAtyKfDdrUCIsSNJAN0RS6Om+uFgWmAgNurVJ6JWmy+EN9h5OUoOAEjttb3PLpzLI=
X-Received: by 2002:a05:6871:798e:b0:25e:1551:a2ec with SMTP id
 586e51a60fabf-25e2b9ea912mr7049472fac.3.1720433196248; Mon, 08 Jul 2024
 03:06:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240702072510.248272-1-ebiggers@kernel.org> <20240702072510.248272-4-ebiggers@kernel.org>
In-Reply-To: <20240702072510.248272-4-ebiggers@kernel.org>
From: Peter Griffin <peter.griffin@linaro.org>
Date: Mon, 8 Jul 2024 11:06:25 +0100
Message-ID: <CADrjBPqVXHh1gPxQxuLHej76yWh6imJ9CAe-fFrX84gccc7_-g@mail.gmail.com>
Subject: Re: [PATCH v2 3/6] scsi: ufs: core: Add UFSHCD_QUIRK_BROKEN_CRYPTO_ENABLE
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
> Add UFSHCD_QUIRK_BROKEN_CRYPTO_ENABLE which tells the UFS core to not
> use the crypto enable bit defined by the UFS specification.  This is
> needed to support inline encryption on the "Exynos" UFS controller.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---

Reviewed-by:  Peter Griffin <peter.griffin@linaro.org>

[..]

regards,

Peter
