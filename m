Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE3A42CB02
	for <linux-scsi@vger.kernel.org>; Wed,  5 Aug 2026 11:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785929588; cv=none; b=En/01r8+J+i7K8d4ZcSXjvMJLll/SE3493/q0a75537e+n4u10M9x9KxzjYAdKHuSkF1MckZN99zasvNUSwKHlF7lFMzkUyinOThv5jistGTkZS1m5sEcUXdTLnjbVX0NrxxO7NRmTPh0RLfH5qkq1Md6iqEnJ3CN42gcn+U4gE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785929588; c=relaxed/simple;
	bh=3qxq+62sZMEMjn70jSju1LCjkeiYuOHtEr8Twi9LWaA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=HWFhCPoqr79RayDfMZ/Lhzu2rZZa9V3nhx7Rsttw2iOGT9C+MuyJa7GtHDTWsyv3AG2mPebS1Ws5LIO+p9M7TTv1A3OkMSJ5I4Zqi0V5icCGo6aOu5yumRIyt9FzDvrLpC6YXjghiJo0mp0MpbQJifPMaS7SLkLfzRsDKBPhiBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UEoU5Nvx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UEoU5Nvx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C23AE1F000E9;
	Wed,  5 Aug 2026 11:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785929585;
	bh=/aNPC4sS4MsJpdtnHQrlWybLca3Fghcu5Y61DHfXePg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UEoU5Nvx2z3oLvgviPhfftrFEiOv+p6BwfC/4Hu2uzkT5KOgnokoe9mDU2EHudL7i
	 ofq4fubUhB0TyVP8UD5sUvVL+dadFfvJqy5V8BQ/AAs15pWK3+7/pDesihSrUoGbPd
	 ZNA31VhXaYBtpCm7lc7wNNLClkb8V7+Is7M490BhQ9qo6jUERTwvyjp2cv48YeTqew
	 Fugt6c1SYyqYher71d5Xho0UyYBWDEOcX8ZrTYHIOiMH5yMQA0iPI3cpMKx2yiZYVt
	 CBJzqAQoDYAKVu1wcggDwpGm3/uozsXsi3m4owKIk+1JwD1UOomFhzslFf4ak3+h+X
	 PmhUyK2LfzcQg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 02/10] mpi3mr: Update MPI Headers to revision 41
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ranjan Kumar" <ranjan.kumar@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260805110634.346670-3-ranjan.kumar@broadcom.com>
References: <20260805110634.346670-1-ranjan.kumar@broadcom.com>
 <20260805110634.346670-3-ranjan.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 05 Aug 2026 11:33:04 +0000
Message-Id: <20260805113305.C23AE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Incorrect shift macro definition `MPI3_MAN10_ISTWI_CTRLR_FLAGS_BUS_=
SPEED_SHIFT` for mask `0x000c`.
--

--- Patch [2]: [PATCH v4 02/10] mpi3mr: Update MPI Headers to revision 41 -=
--
commit e227f986541dd8cdc45ad47d1ea7374c1b7cfc9c
Author: Ranjan Kumar <ranjan.kumar@broadcom.com>

mpi3mr: Update MPI Headers to revision 41

This commit updates the MPI headers to revision 41.

> diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h b/drivers/scsi/mpi3mr/m=
pi/mpi30_cnfg.h
> index 33dd303c97bb5..7cf16a5c15b72 100644
> --- a/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
> +++ b/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
[ ... ]
> @@ -492,10 +498,31 @@ struct mpi3_man10_istwi_ctrlr_entry {
>  };
> =20
>  #define MPI3_MAN10_ISTWI_CTRLR_FLAGS_BUS_SPEED_MASK         (0x000c)
> -#define MPI3_MAN10_ISTWI_CTRLR_FLAGS_BUS_SPEED_100K         (0x0000)
> -#define MPI3_MAN10_ISTWI_CTRLR_FLAGS_BUS_SPEED_400K         (0x0004)
> +#define MPI3_MAN10_ISTWI_CTRLR_FLAGS_BUS_SPEED_100_KHZ		(0x0000)
> +#define MPI3_MAN10_ISTWI_CTRLR_FLAGS_BUS_SPEED_400_KHZ		(0x0004)
>  #define MPI3_MAN10_ISTWI_CTRLR_FLAGS_TARGET_ENABLED          (0x0002)
>  #define MPI3_MAN10_ISTWI_CTRLR_FLAGS_INITIATOR_ENABLED         (0x0001)
> +#define MPI3_MAN10_ISTWI_CTRLR_FLAGS_I2C_GLITCH_FLTR_MASK	(0xc000)
> +#define MPI3_MAN10_ISTWI_CTRLR_FLAGS_I2C_GLITCH_FLTR_SHIFT      (14)
[ ... ]
> +#define MPI3_MAN10_ISTWI_CTRLR_FLAGS_I3C_MAX_DATA_RATE_2_MHZ    (0x0800)
> +#define MPI3_MAN10_ISTWI_CTRLR_FLAGS_BUS_SPEED_MASK             (0x000c)
> +#define MPI3_MAN10_ISTWI_CTRLR_FLAGS_BUS_SPEED_SHIFT            (0)

[Severity: Low]
Is this shift value defined correctly?

The mask MPI3_MAN10_ISTWI_CTRLR_FLAGS_BUS_SPEED_MASK is defined as 0x000c,
which covers bits 2 and 3. Should MPI3_MAN10_ISTWI_CTRLR_FLAGS_BUS_SPEED_SH=
IFT
be 2 instead of 0 to ensure any future bitwise operations work properly?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260805110634.3466=
70-1-ranjan.kumar@broadcom.com?part=3D2
