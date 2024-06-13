Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA202F50;
	Thu, 13 Jun 2024 19:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718306147; cv=none; b=i95OW8wzvflyvLhRC93I+JfDk2YGcIJydlWyE8wDEKAZ4UuMA6Tvgq0WW6QgCpaQGyGBKdR0lX+YGAI+58DhDxbdy01nPvuWplt6L3bQEgABGRFwHeAWUSxZHPvrb6SpHJ+jYTd2Q2x/eyXCLrbhajbx30rTsRo4+O7ulizZ49E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718306147; c=relaxed/simple;
	bh=2hYJ1+rDlXCuBR0CUzbbS2iEQjVVQVKf91ppyer216k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T1/O/qU95psSvSqYYzIoRq+JqJYnXsOt7rrg4UR1TJDA4fwEep5RvS2Zw+LVpQNixyX0uLPxijJfwI9U4pTf85PTMqWMX1KyAy48u8bRRuc+0/iraUjWc51+/hkW9tRnFo6w1If7xoMJ2SRxhThbsZZ9z0dUCNkbqiMKtENOL3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=qQioH8/K; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="qQioH8/K"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4W0XDq3Y9WzlgMVW;
	Thu, 13 Jun 2024 19:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1718306136; x=1720898137; bh=p7GSh5AJbu1HIUJECGqYLdu+
	1gbsYjlaIo0jC08KkBw=; b=qQioH8/K5NkFNarm8vJpHj+GK7kRyPZX3b104AMj
	mbsc6DDCg8i0Cn9oBzrU4fkhU+jc6gAPmWMz59G/exyiwPBxMjScTPjKTFHEPnV7
	5eB7HT5YwCgGdkZCEByxcxM3B5e0Ek00dHYbHBtAONpWsQUkry9+k2DSmqKv1dNO
	e1d/y86AlL8hgsqWo82x4sM86F3nOBCEceiL/+XoS4Hn/2j8pmULR1pfI6i0VeUC
	r3SdoJZj1lUKyUegQmgIS1GjiO3G1xC2d7nnzvooytXLqAs6wUPBtXVCEZecMMvc
	2Eu8EDLQ/uAfu1ScdgZeSCTjTpXCBmiKNyaBy3LbWqz/Tg==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id wZM3m8HDnaEw; Thu, 13 Jun 2024 19:15:36 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4W0XDl38K1zlgMVV;
	Thu, 13 Jun 2024 19:15:35 +0000 (UTC)
Message-ID: <812c519a-1a00-4ace-a0f7-d8c587f7e59f@acm.org>
Date: Thu, 13 Jun 2024 12:15:34 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: core: Free memory allocated for model before
 reinit
To: Joel Slebodnick <jslebodn@redhat.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, alim.akhtar@samsung.com,
 avri.altman@wdc.com, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, peter.wang@mediatek.com,
 manivannan.sadhasivam@linaro.org, ahalaney@redhat.com, beanhuo@micron.com
References: <20240613182728.2521951-1-jslebodn@redhat.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240613182728.2521951-1-jslebodn@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/13/24 11:27 AM, Joel Slebodnick wrote:
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 0cf07194bbe8..a0407b9213ca 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -8787,6 +8787,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params)
>   	    (hba->quirks & UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH)) {
>   		/* Reset the device and controller before doing reinit */
>   		ufshcd_device_reset(hba);
> +		ufs_put_device_desc(hba);
>   		ufshcd_hba_stop(hba);
>   		ufshcd_vops_reinit_notify(hba);
>   		ret = ufshcd_hba_enable(hba);

Please add Fixes: and Cc: stable tags. Otherwise this patch looks good to me.
Hence:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

Thanks,

Bart.
