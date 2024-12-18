Received: from smtp.eurecom.fr (smtp.eurecom.fr [193.55.113.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C794B1FCF53
	for <linux-scsi@vger.kernel.org>; Wed, 18 Dec 2024 23:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.55.113.210
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734566377; cv=none; b=hRxl/F5nYK5/jzr2+OuWeIwTMhxje3ldKiQrWvN4ngj1olON+97C4xe90OrGdBDrRW0+0pEgk4GodxguvYAYqseqrxEQug3QGnJXnXJ2OVXA2fNdeP/m2r9hZqLWXg01XETJCUfST0FPcv4zGgWUWMSUa+zT51uE49bpL8qn41k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734566377; c=relaxed/simple;
	bh=0X8cYXDW0JAL1YuYwPEc8aX/TtH/ve/TpBRYfUhx6R4=;
	h=From:In-Reply-To:Content-Type:References:Date:Cc:To:MIME-Version:
	 Message-ID:Subject; b=nUkFoKzC5OR8WJPCm7k4yWYua+zQor9iof31BcLHceX4po5TI6jpOhiGJNvKX26asdHvyRc2AE598n1kipjctyJr8Wpn+BmD7B48D4wqP/Eq8ijnrWk7WSiYA8XPPyC9s5mOEjmLTFAGRgmqkQ07+LD97CY6BhcFlN11ftQdmFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=eurecom.fr; spf=pass smtp.mailfrom=eurecom.fr; dkim=pass (1024-bit key) header.d=eurecom.fr header.i=@eurecom.fr header.b=JICEgc77; arc=none smtp.client-ip=193.55.113.210
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=eurecom.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eurecom.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=eurecom.fr header.i=@eurecom.fr header.b="JICEgc77"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=eurecom.fr; i=@eurecom.fr; q=dns/txt; s=default;
  t=1734566375; x=1766102375;
  h=from:in-reply-to:references:date:cc:to:mime-version:
   message-id:subject:content-transfer-encoding;
  bh=0X8cYXDW0JAL1YuYwPEc8aX/TtH/ve/TpBRYfUhx6R4=;
  b=JICEgc77x+xNiRcl8idwBsxTJTkjzyhG+9Y1A0+s55zS1+hf2U/S3pRO
   PWFjz/pFou23AFfSvtbMVCRB9at5Xha7b80gtE2jUmWc3B3EubuYpPIGQ
   EG6w0fhWzfqA4bX+SZnGOceuLe5OrHrU3b9L+8FTURht7/CpKb4FdbrKy
   0=;
X-CSE-ConnectionGUID: RalZdA1fRzK0ndKxqq2b8w==
X-CSE-MsgGUID: IjlOj+3PTSWzTFDMN63SLA==
X-IronPort-AV: E=Sophos;i="6.12,246,1728943200"; 
   d="scan'208";a="28246520"
Received: from quovadis.eurecom.fr ([10.3.2.233])
  by drago1i.eurecom.fr with ESMTP; 19 Dec 2024 00:59:27 +0100
From: "Ariel Otilibili-Anieli" <Ariel.Otilibili-Anieli@eurecom.fr>
In-Reply-To: <20241213225852.62741-2-ariel.otilibili-anieli@eurecom.fr>
Content-Type: text/plain; charset="utf-8"
X-Forward: 88.183.119.157
References: <20241213225852.62741-1-ariel.otilibili-anieli@eurecom.fr> <20241213225852.62741-2-ariel.otilibili-anieli@eurecom.fr>
Date: Thu, 19 Dec 2024 00:59:27 +0100
Cc: linux-scsi@vger.kernel.org, "Hannes Reinecke" <hare@kernel.org>, =?utf-8?q?James_E=2EJ=2E_Bottomley?= <James.Bottomley@HansenPartnership.com>, =?utf-8?q?Martin_K=2E_Petersen?= <martin.petersen@oracle.com>
To: "Ariel Otilibili" <ariel.otilibili-anieli@eurecom.fr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <2f7a86-67636200-8e2f-26131fc0@196789333>
Subject: [PING] =?utf-8?q?drivers/scsi=3A?= remove dead code
User-Agent: SOGoMail 5.11.1
Content-Transfer-Encoding: quoted-printable

Hello,

Is there any news of the patch? Your feedback is much appreciated.

Have a good day,
Ariel

On Friday, December 13, 2024 23:57 CET, Ariel Otilibili <ariel.otilibil=
i-anieli@eurecom.fr> wrote:

> * reported by Coverity ID 1602240
> * ldev=5Finfo is always true, therefore the branch statement is never=
 called.
>=20
> Fixes: 081ff398c56cc ("scsi: myrb: Add Mylex RAID controller (block i=
nterface)")
> Cc: Hannes Reinecke <hare@kernel.org>
> Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Signed-off-by: Ariel Otilibili <ariel.otilibili-anieli@eurecom.fr>
> ---
>  drivers/scsi/myrb.c | 2 --
>  1 file changed, 2 deletions(-)
>=20
> diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
> index 363d71189cfe..dc4bd422b601 100644
> --- a/drivers/scsi/myrb.c
> +++ b/drivers/scsi/myrb.c
> @@ -1627,8 +1627,6 @@ static int myrb=5Fldev=5Fsdev=5Finit(struct scs=
i=5Fdevice *sdev)
>  	enum raid=5Flevel level;
> =20
>  	ldev=5Finfo =3D cb->ldev=5Finfo=5Fbuf + ldev=5Fnum;
> -	if (!ldev=5Finfo)
> -		return -ENXIO;
> =20
>  	sdev->hostdata =3D kzalloc(sizeof(*ldev=5Finfo), GFP=5FKERNEL);
>  	if (!sdev->hostdata)
> --=20
> 2.47.1
>

