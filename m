Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2480B21B9FD;
	Tue, 24 Jun 2025 16:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750781714; cv=none; b=PIVNrGyhP3LMeYSNDHgStDLGlX9VhpaMmtwWE9S7+9Jucn7Ysjsn8AGFeLcrjvuam6MF0AhPDFKMS9bpizj+Z1ePZVlfqE7GUU4UZ3AFb7O/rqdwKRyljqV4aYgERKS6NDh1q2yM1DHyz7H2HA6x2G7XQNlbbWXpfelRSyfC958=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750781714; c=relaxed/simple;
	bh=Jw+jii3AqB7qQ/n+MMga6gdlZNbQILmRGO7Jr1wVD9Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gOtXmqWOaEMT8EyrvLFmtzydBbyTbQMMfnuOZRFIj8ND5J9ytdYJzhGn2zsfuaAv1ds3OucpmBY/5/tml93zB5XD6Z615lxuQHOyeby3gO6XCuZFW1zxGWMG60cZfP4w4OLeLsJAeT7xo0Tg4IIWfFnKFu6tDLfE9/rP9pyuqq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=XsaIiYkM; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="XsaIiYkM"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bRVR30xytzlgqV2;
	Tue, 24 Jun 2025 16:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1750781708; x=1753373709; bh=7qcQNUHgV1N9LnFZH512TXGo
	pEde8MG1HM/QzXXuiMs=; b=XsaIiYkMwpmUAdL/lZgWAvTZXX1aPpkSW5v7Il8l
	w1mziKN33dNk2cls8t+ni5BZYk39g4iXojYDJbtV6hbmkwtdlrntD5jMQM1CkzMW
	yj2FhBurP9YCByVxo2Gn55Z9y9U8gD3BVRHoRmfuVv9flnYypA8mQ8fg3fSD5nm+
	XJxNeTDZsgJTpxKiNvTNWb3u+/GjyvIf4WdT0kBOzZxj5rNn1e3/oDKhZGEWBuYX
	bm4fHzHoQQ4K4PrCoRjvqBxdBVoPaKlSag3rV+LwFEb9bTufwNxG1tK8k07XE2Ta
	eWIhIeCNQjocrks1rNsOyQSkLqTI6dvFWnlrbH/rIbCRqw==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id a3X19X6cxwTP; Tue, 24 Jun 2025 16:15:08 +0000 (UTC)
Received: from [100.118.141.242] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bRVQp006CzlgqTy;
	Tue, 24 Jun 2025 16:14:56 +0000 (UTC)
Message-ID: <a15b8f6e-5ad5-4d16-98d4-79cf63619f6e@acm.org>
Date: Tue, 24 Jun 2025 09:14:52 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: preventing bus hang crash during emergency
 power off
To: Bo Ye <bo.ye@mediatek.com>, Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@wdc.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: xiujuan.tan@mediatek.com, Qilin Tan <qilin.tan@mediatek.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org
References: <20250519073814.167264-1-bo.ye@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250519073814.167264-1-bo.ye@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/19/25 12:38 AM, Bo Ye wrote:
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 7735421e3991..a1013aea8e90 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -10262,6 +10262,7 @@ static void ufshcd_wl_shutdown(struct device *dev)
>   		scsi_device_set_state(sdev, SDEV_OFFLINE);
>   		mutex_unlock(&sdev->state_mutex);
>   	}
> +	ufshcd_wait_for_doorbell_clr(hba, 5 * USEC_PER_SEC);
>   	__ufshcd_wl_suspend(hba, UFS_SHUTDOWN_PM);
>   
>   	/*

This code path is not only triggered when using a UFSHCI 3.0 controller
but also when using a UFSHCI 4.0 controller.
ufshcd_wait_for_doorbell_clr() only supports the legacy single doorbell
mode. Please make sure that the fix supports both the legacy single
doorbell mode and MCQ.

Thanks,

Bart.
