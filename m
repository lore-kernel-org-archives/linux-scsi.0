Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795163906;
	b=gQUO+leLt1wOzTEvE+x8RP5mRJX5Ei2M3RS09CamCn4MF/kCwd8SCC8423pOdAntqFFL
	 HF3pvmSImiMsGZ/7pJwra3K3UDSawwzSCUIqd04am8frUXv8sfY2NP0V8YSyWgEX2dNDA
	 5Q7seatIvPp7DDz3DAmwivQu8rqdqUczVt1qCTR2X4rl/2lkwU7diqmiE7vMGGRyUdzEK
	 zzLFsFqd8e0pIdlTdA4b37aTWAO8Vy6yAb6dXP/eTsa2ZUOhPiOIcbBJ6QXeqmjGxbPlO
	 a470Vmuc3nV93y2k0kOFC8AYY+GLrN7DMbSiQuOLdxuJucvba+cQWUIPb7A5qYT3QMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795163906;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=VAns/erN1gbUuQwSrun89QnqEDeMU/HsyelzgEbHHK8=;
	b=yM/Qt/slFlm7LQcXutPtoWqEqiBoZ0bLAFRNeX5Uy89ReJbso7AUdHCpWnyWB/Qe/H42
	 f1TKz1aE70OLbAAVOWqVIpvessLtkd6A8eM9GcgK0BSZbEZIXXSCo4QVt+VGB8o/VDGdd
	 WI1VIjGAjx8VC1m+rBGG6rKoB6mcL3yo4MW5o5OkF437FhWa5eBjMoNjej7VKsJGSFYEn
	 3vZlt4/AVZa3nsI/oD40x6tW6rejbHxC21V0SKFhxJKjKV8ofjQ1blPLF1oCcv9cH4F7P
	 4fSnnsoPBJ3tdUQeI3PBTf/e08xt2wSlJo3R3ULuyNIZqxUS4HfK6S6U0hiEmhrij+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cRpmJrFT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A78606A326
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 08:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cRpmJrFT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79DB71F000CF;
	Fri, 20 Nov 2026 08:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795163905;
	bh=VAns/erN1gbUuQwSrun89QnqEDeMU/HsyelzgEbHHK8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cRpmJrFT2HqxY6rjtQpf+mkOWmC9EN/CiiSdGHKvmYsVM+FOENP87Ugm0Fke1nW3M
	 HokGo1Xxa3lInEP/ruC2MwGGIzyRwiio3nVJjuFStwtybV+eGsHCJu1J83fnmN2VgB
	 B9SzboTFb+kE1enl/Dc2HmUXS6/+xsIW4m8vY0Yg1fFlPZ8wX7gMbQ0FocCyq6ffgp
	 sxWBpWti8TYO2ZCjgnSpgmEtsgfXUY4GXqHzXvuDd43nYHuX85wSPzKlxu3TfUV/yv
	 hN3xvKaQZSagpfNC3pHr7gRu7RYcQ8Qt3VViFepzFtFEP5801QB4cMmZffzethk2hm
	 H528xusFb415Q==
Message-ID: <sashiko-outbox-224751@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: leapraid: fix off-by-one in reply frame address
 validation
Reply-To: sashiko-reviews@lists.linux.dev
To: zhangchujun <zhangchujun@cmss.chinamobile.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261120083000.1961-1-zhangchujun@cmss.chinamobile.com>
References: <20261120083000.1961-1-zhangchujun@cmss.chinamobile.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 08:38:25 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] scsi: leapraid: bad reply bounds in
  leapraid_request_descript_handler()
--

commit b7ba75a759881f8671081c0b0994098d97d3921e
Author: zhangchujun <zhangchujun@cmss.chinamobile.com>

scsi: leapraid: fix off-by-one in reply frame address validation

This commit changes the upper bound check on the firmware reply frame
DMA address in leapraid_request_descript_handler() from > to >=3D.

> diff --git a/drivers/scsi/leapraid/leapraid_func.c b/drivers/scsi/leaprai=
d/leapraid_func.c
> index 573bccf1a4cea..c54797e22e744 100644
> --- a/drivers/scsi/leapraid/leapraid_func.c
> +++ b/drivers/scsi/leapraid/leapraid_func.c
> @@ -5667,7 +5667,7 @@ static void leapraid_request_descript_handler(
>  		break;
>  	case LEAPRAID_RPY_DESC_FLG_ADDRESS_REPLY:
>  		rep =3D le32_to_cpu(rpf->addr_rep.rep_frame_addr);
> -		if (rep > (u32)adapter->mem_desc.rep_msg_dma +
> +		if (rep >=3D (u32)adapter->mem_desc.rep_msg_dma +
>  			   adapter->adapter_attr.rep_msg_qd *
>  			   LEAPRAID_REPLY_SIZE ||
>  		    rep < (u32)adapter->mem_desc.rep_msg_dma)

[Severity: Medium]
Can rep still cause an out-of-bounds read and DMA write past
adapter->mem_desc.rep_msg if the firmware returns an address within the
last LEAPRAID_REPLY_SIZE - 1 bytes of the buffer or at an unaligned
offset?

Each reply frame is LEAPRAID_REPLY_SIZE (128) bytes, and
leapraid_init_rep_msg_addr() populates rep_msg_addr[] with addresses at
multiples of LEAPRAID_REPLY_SIZE up to rep_msg_dma + (rep_msg_qd - 1) *
LEAPRAID_REPLY_SIZE.  An address in the trailing 127 bytes still passes
this check, causing completion handlers such as
leapraid_driver_cmds_done() to read up to LEAPRAID_REPLY_SIZE bytes past
the end of rep_msg and reposting rep to rep_msg_addr[] for firmware DMA.

Should this also verify that (rep - (u32)adapter->mem_desc.rep_msg_dma)
is a multiple of LEAPRAID_REPLY_SIZE?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120083000.1961=
-1-zhangchujun@cmss.chinamobile.com?part=3D1
