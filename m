Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC618192D82;
	Wed, 21 Aug 2024 12:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724244584; cv=none; b=u7txUQdrlywPpONGd3OZcQo3wfZA2el8g+LRoGLaD3d0lOx6FZ8ar6Dw2k5UMZ+WIWLLFi1nWPL2z4gR+X2qKKdS06pTT+bgakxT/JRLJL1mIn71vpsZD+UreYhysqLL5Z5uGiRfpT3xDcHbsQVB692gn+ngTRAqbWifzBYExXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724244584; c=relaxed/simple;
	bh=ivBLmAjrAdfXQCnNJnRfb3XazdZTgFVx5cfbyrli2GU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=We6Crb3h2vKitLVySaVgW1b2YPIOoT086N9aDzG1Pq6D1suC9EyMWLNvJECIhWmH8DmfkJn1AFBAtR1+VrC999i8vQCYoTA7eOpCU4UXul5JCacwphuejNadnEHr8XkIPUiQaulETSB5XhJJZAw23Dma7UZbjHU6Yl5u5I6JIUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e+9qBNNI; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e+9qBNNI"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a7abe5aa9d5so729188466b.1;
        Wed, 21 Aug 2024 05:49:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724244581; x=1724849381; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ivBLmAjrAdfXQCnNJnRfb3XazdZTgFVx5cfbyrli2GU=;
        b=e+9qBNNI/8S4YtHz50D4k0dim4wHZOwnSkjk/NVkx+x7/zjz0wzVjrjvcnnznw4/Ka
         lscGPvGti6HAapIJ7LnSV6YIARBBNhhgZxazPHtvKxEL+R3OLUJNwz6rYcksDXVml4Ns
         6SP6SSnMBD9MH+NH+9D81h5zXz7CuKwyN6XM1kEYiaPUelP7pQWWdWhBg5nEdn5d2Zc4
         P5diKJ6gCu5cvPIkfWHusG6HlFkbhXac1GbSRqFfqd6G/M5c8fPruIKFZzVms18nupIh
         XOXL18hyF4tcQdN0DBIuPggrho4NP4v/LsUvlxoLLHbCPTt3Cq9w5ViaYvdKPsHWqCd6
         0j2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724244581; x=1724849381;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ivBLmAjrAdfXQCnNJnRfb3XazdZTgFVx5cfbyrli2GU=;
        b=hJZwNvBZdoesdcdb9Lzm/p48veKhstoP+Wf+B07EA2WEZyKBclnFnYyMAjBP8jy3vX
         NI70YJHWFBdSZ3+LOxQZrjVlnwTxnKirq+I5Qwxx4VYB4ZMsppkwSX+CrprPVj51yq4k
         d4CFVyuDmGqDR2wa+u5MFknAfSr6EK34+fDC7RVJj+0/2Iqnq7nhbptDMl+AA8bgsduV
         Ry2LFhnO3kgEDKavDG7kcEsoujLJAAxQFR03RdmXAdr9XlwxQ/mKtk+8NS+Z9KrBscxF
         TohIsCmxgrrbQdxqIjd0VZnYEZvLgSmXWKZWoHEErjU8mkvGu+kvLFH3O/8WVThNafw7
         pHag==
X-Forwarded-Encrypted: i=1; AJvYcCUZpFCpRWdq7i9KGf5otbkDAFaAe3grzNs3wa35oiKG3841he4pYKj5tUYijxd2rCge9HawgXY4nkAzECI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxCRgeq2Y1p6GZGUZjWRglre6HRkWqwTylTn6Jlk5mCxIQqjXIV
	QUzOk0ar0q+44fdRiowv6KBkajGn1mmVWvg9iQ/LlGuGVL0rTq1q0QeerRBD
X-Google-Smtp-Source: AGHT+IFuNF65BQB77WK5NFqDaCMrwDijcbzYxVS+HyalkmdLsChj9w/zp8rXB+PM8qihnngfuxkyKQ==
X-Received: by 2002:a17:906:cae0:b0:a7d:2fb2:d852 with SMTP id a640c23a62f3a-a866f72e01dmr160152366b.52.1724244580426;
        Wed, 21 Aug 2024 05:49:40 -0700 (PDT)
Received: from [10.176.235.56] ([137.201.254.41])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8383949e45sm904788566b.145.2024.08.21.05.49.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2024 05:49:40 -0700 (PDT)
Message-ID: <40361ef4723db11ec484a7265627cd77276772bd.camel@gmail.com>
Subject: Re: [PATCH v2] scsi: ufs: Move UFS trace events to private header
From: Bean Huo <huobean@gmail.com>
To: Avri Altman <avri.altman@wdc.com>, "Martin K . Petersen"
	 <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Bart Van
 Assche <bvanassche@acm.org>, Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Date: Wed, 21 Aug 2024 14:49:38 +0200
In-Reply-To: <20240821055411.3128159-1-avri.altman@wdc.com>
References: <20240821055411.3128159-1-avri.altman@wdc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2024-08-21 at 08:54 +0300, Avri Altman wrote:
> ufs trace events are called exclusively from the ufs core drivers.=C2=A0
> Make
> those events private to the core driver.
>=20
> The MAINTAINERS file does not need updating as the maintainership
> remains the same and the relevant directory is already covered.
>=20
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: Avri Altman <avri.altman@wdc.com>
Acked-by: Bean Huo <beanhuo@micron.com>
