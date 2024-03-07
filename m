Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74850130E30
	for <linux-scsi@vger.kernel.org>; Thu,  7 Mar 2024 17:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709834349; cv=none; b=KWemw8JLFkpawJ68TPk9yqhi0IMDL5FN04ZQCbKWkUxu2H8auPQA2/AaA+TvP1EeCthYJzqcyymOv+xeUd6yS1VIag6+vgBtHrZmwxfQSriagarqmIgrOmt3zdcB8owqJQ+riktgfGD16gKLvQx4oOnNQd6oTwuUPuUAB/6Ll48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709834349; c=relaxed/simple;
	bh=e62SMdrsV+4tn2lYJR5N4yyuYRU/qcW8T9GfkqPdtcQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EBvvFTyAv2NiJUl5yIoFiFheFI2HaKKZB1qblf68VbkHnVWkeEJUDrhvI6hrq+7I3MBkTuwO+88ggQJbiQjKAOYi1NXCgOthO0YxFHQqWHG6rAVUKWLfS7Q9xrzijxlpdjZIH/wn/VNijWywbRSe68m1OKwo8Qg4U3quCZoDTk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=lYw4EORU; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="lYw4EORU"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4TrH9k5qyDz6ClTND;
	Thu,  7 Mar 2024 17:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:references:content-language:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1709834344; x=1712426345; bh=vhvFcC+O7kH5YGk3pO8OOD9T
	yuqj7J/eXdb0ky0HINs=; b=lYw4EORU6LuM3GJT8ANEOEcprCoCo91nrzzw4Opa
	/m5/AMcokwIlXJj0CPc1iLiokwqBxFdHQasYG3azihB0O0lumzQlnhwTG5Y+cDTS
	hGmC5+3Bs0iyjM+f/Gyn4UcZ2GeYWF/LFFVDYLq9849kSG9PZHpRRMIAByv8A0jn
	XR6xKo3K4MQ2aPaaejwMv7ouHkMgBoGMhLqBb2fj0m4reyS3M7d1P5GE6EYyj4ht
	ojv8TWWJ3z12ycjpc0i5n3ije/IQNwnBrvH86Aeg53kM53lwYDnpl1N1usYiK+8w
	IU/pHwDxUnX+bkvVz+5JM3B0T7hHAT/1DjMALIuR4H4rVg==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id hLljrFmqByUT; Thu,  7 Mar 2024 17:59:04 +0000 (UTC)
Received: from [100.96.154.173] (unknown [104.132.1.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4TrH9g06g5z6ClY9v;
	Thu,  7 Mar 2024 17:59:02 +0000 (UTC)
Message-ID: <2f2c14e4-1a8c-4472-9ac4-887b8b0f2689@acm.org>
Date: Thu, 7 Mar 2024 09:59:01 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi_debug: Make CRC_T10DIF support optional
Content-Language: en-US
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20240305222612.37383-1-bvanassche@acm.org>
 <cd54668a-8f01-46d8-a597-3dc25ad1ad00@oracle.com>
 <4fbd2106-1e39-4fd9-b0e0-411105e80bb7@acm.org>
 <218b4bb9-ced8-4480-8b6d-24969180053c@oracle.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <218b4bb9-ced8-4480-8b6d-24969180053c@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 3/7/24 01:37, John Garry wrote:
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index acf0592d63da..5bac3b5aa5fa 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -3471,6 +3471,7 @@ static bool comp_write_worker(struct=20
> sdeb_store_info *sip, u64 lba, u32 num,
>  =C2=A0=C2=A0=C2=A0=C2=A0 return res;
>  =C2=A0}
>=20
> +#if (IS_ENABLED(CONFIG_CRC_T10DIF))
>  =C2=A0static __be16 dif_compute_csum(const void *buf, int len)
>  =C2=A0{
>  =C2=A0=C2=A0=C2=A0=C2=A0 __be16 csum;
> @@ -3509,6 +3510,13 @@ static int dif_verify(struct t10_pi_tuple *sdt,=20
> const void *data,
>  =C2=A0=C2=A0=C2=A0=C2=A0 }
>  =C2=A0=C2=A0=C2=A0=C2=A0 return 0;
>  =C2=A0}
> +#else
> +static int dif_verify(struct t10_pi_tuple *sdt, const void *data,
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 sector_t sector, u32 ei_lba)
> +{
> +=C2=A0=C2=A0=C2=A0 return -EOPNOTSUPP;
> +}
> +#endif
>=20
>  =C2=A0static void dif_copy_prot(struct scsi_cmnd *scp, sector_t sector=
,
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 unsigned int sectors, bool read)
> @@ -7421,7 +7429,12 @@ static int __init scsi_debug_init(void)
>  =C2=A0=C2=A0=C2=A0=C2=A0 case T10_PI_TYPE1_PROTECTION:
>  =C2=A0=C2=A0=C2=A0=C2=A0 case T10_PI_TYPE2_PROTECTION:
>  =C2=A0=C2=A0=C2=A0=C2=A0 case T10_PI_TYPE3_PROTECTION:
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 #if (IS_ENABLED(CONFIG_CRC_=
T10DIF))
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 have_dif_prot =3D tru=
e;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 #else
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pr_err("CRC_T10DIF not enab=
led\n");
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EINVAL;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 #endif
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 break;
>=20
>  =C2=A0=C2=A0=C2=A0=C2=A0 default:
> ----8<-----
>=20
> I know that IS_ENABLED(CONFIG_XXX)) ain't too nice to use, but this is =
a=20
> lot less change and we also don't need multiple files for the driver. A=
s=20
> below, it's not easy to separate the CRC_T10DIF-related stuff out.

The above suggestion violates the following rule from the Linux kernel=20
coding style: "As a general rule, #ifdef use should be confined to
header files whenever possible." See also
Documentation/process/4.Coding.rst.

The approach to use multiple files in order to avoid #ifdefs in .c files
is strongly preferred in Linux kernel code.

Thanks,

Bart.
