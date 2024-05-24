Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD901E52C;
	Fri, 24 May 2024 13:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716558998; cv=none; b=b2/oMG1IVDwKX2rWDsgUaJHvqC5M6CW81ar263lAjKVhczPyE0HpY6qOBHaEEL3wYQnNKagPau6QUpkctNJ+WVWxGBirX/O2IwZHe7lvdsxAg4VMc+2rpbPIaX3X33B2weCmG19omWvFZhARZzmsOASVRn6P4EGRF4CTomy17AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716558998; c=relaxed/simple;
	bh=Lt4Ysqyp3DAJQDdpLcTWTsF1u1XL683siKidltmMTlQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MGUUW+KHskk0eEN36Or3q3hqMHRHK0LmtdFqDx5hHZe6kKX/svaYAWftU/qk4tSZlMNPA4LAoeuDyGarg4itp6wGLm1FT6b95TKYQQXfQKu6he4be0NL5c4bAe1YTwDsoMOYlwkVjvL+JzMY1edaM89/1j7Q/RP6oBAxka/upK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=D69qkga7; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="D69qkga7"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Vm65v6p0Fz6Cnk98;
	Fri, 24 May 2024 13:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1716558992; x=1719150993; bh=IIIctu9hujJGoH9Xop4DEZcp
	4zNfKuFNTzuRxNev4TE=; b=D69qkga7f2UqaNV+tMiQb8H1SmohgcZGJPtGQHnk
	IRdvpKssq+lEDxVs3rY8daA3kDUKBwFTS75KwOzL6ppdFbId2Cu+gIb/2PKurUyI
	qLCVb5K2D+0n7hRvB9klY3TFuwJeuAi3D905J6Ncwm9DpDK3d89MLKUodEsauxct
	FWSJwnK7l+ovwGhXOQlQ3pUxNmYUN9eqevZNjpAWjClXQ2CBJsJLDZlS/ffFcgiB
	hmBeEZVMmVAPiO3POfspDOYy4kZf/gzJRoCvNnKxMooc21LhDhR/pDELs2pOPQS8
	yUJGn8jFTCS2m0nUcxQC3Quzj9Eb1+AQzIUjlrUgVSaQ+A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id uvIgXipl3rIb; Fri, 24 May 2024 13:56:32 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Vm65p0CJcz6Cnk94;
	Fri, 24 May 2024 13:56:29 +0000 (UTC)
Message-ID: <7d719385-beee-4780-ac6b-8c5cace90b1e@acm.org>
Date: Fri, 24 May 2024 06:56:27 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/3] scsi: ufs: Allow platform vendors to set rtt
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "hch@infradead.org" <hch@infradead.org>,
 "Avri.Altman@wdc.com" <Avri.Altman@wdc.com>
Cc: "beanhuo@micron.com" <beanhuo@micron.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
References: <20240523125827.818-1-avri.altman@wdc.com>
 <20240523125827.818-3-avri.altman@wdc.com> <Zk8-rwjFvgP714Mn@infradead.org>
 <DM6PR04MB65758584960580363D43AED4FCF42@DM6PR04MB6575.namprd04.prod.outlook.com>
 <Zk9Anwk1HEjUzSxc@infradead.org>
 <0a57d6bab739d6a10584f2baba115d00dfc9c94c.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <0a57d6bab739d6a10584f2baba115d00dfc9c94c.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 5/23/24 23:06, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-
> mediatek.c
> index c4f997196c57..f8725f3374f7 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c
> @@ -1777,6 +1777,32 @@ static int ufs_mtk_config_esi(struct ufs_hba
> *hba)
>          return ufs_mtk_config_mcq(hba, true);
>   }
>  =20
> +static void ufs_mtk_set_rtt(struct ufs_hba *hba)
> +{
> +       struct ufs_dev_info *dev_info =3D &hba->dev_info;
> +       u32 rtt =3D 0;
> +       u32 dev_rtt =3D 0;
> +
> +       /* RTT override makes sense only for UFS-4.0 and above */
> +       if (dev_info->wspecversion < 0x400)
> +               return;
> +
> +       if (ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
> +                                   QUERY_ATTR_IDN_MAX_NUM_OF_RTT, 0,
> 0, &dev_rtt)) {
> +               dev_err(hba->dev, "failed reading bMaxNumOfRTT\n");
> +               return;
> +       }
> +
> +       /* override if not mediatek support */
> +       if (dev_rtt =3D=3D MTK_MAX_NUM_RTT)
> +               return;
> +
> +       rtt =3D MTK_MAX_NUM_RTT;
> +       if (ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
> +                                   QUERY_ATTR_IDN_MAX_NUM_OF_RTT, 0,
> 0, &rtt))
> +               dev_err(hba->dev, "failed writing bMaxNumOfRTT\n");
> +}
> +
>   /*
>    * struct ufs_hba_mtk_vops - UFS MTK specific variant operations
>    *
> @@ -1805,6 +1831,7 @@ static const struct ufs_hba_variant_ops
> ufs_hba_mtk_vops =3D {
>          .op_runtime_config   =3D ufs_mtk_op_runtime_config,
>          .mcq_config_resource =3D ufs_mtk_mcq_config_resource,
>          .config_esi          =3D ufs_mtk_config_esi,
> +       .set_rtt             =3D ufs_mtk_set_rtt,
>   };
>  =20
>   /**
> diff --git a/drivers/ufs/host/ufs-mediatek.h b/drivers/ufs/host/ufs-
> mediatek.h
> index 3ff17e95afab..05d76a6bd772 100644
> --- a/drivers/ufs/host/ufs-mediatek.h
> +++ b/drivers/ufs/host/ufs-mediatek.h
> @@ -189,4 +189,7 @@ struct ufs_mtk_host {
>   /* MTK delay of autosuspend: 500 ms */
>   #define MTK_RPM_AUTOSUSPEND_DELAY_MS 500
>  =20
> +/* MTK RTT support number */
> +#define MTK_MAX_NUM_RTT 2
> +
>   #endif /* !_UFS_MEDIATEK_H */

The above patch would result in duplication of code. We should avoid
code duplication if that's reasonably possible. Instead of applying the
above patch, I propose to add a callback function pointer in struct
ufs_hba_variant_ops that returns the maximum RTT value supported by the
host driver.

Thanks,

Bart.

