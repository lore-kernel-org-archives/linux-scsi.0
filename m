Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41EB52741DF;
	Mon, 19 May 2025 15:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747668741; cv=none; b=ZVzjiRe3Jb8UmsoDezr1HFnCiTQB+ecI841OC0gVnplf953ukjbMfPLBb+PADHiuD4vVj8VjUiAss5xCoi497tl/z+2UVrn2OnX90YKIs/K5iYCP+B9gRL6oPbNeuC+G963uZxhjpwATOHX4LKQ49PoX62iG6051HqkCiPUp8I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747668741; c=relaxed/simple;
	bh=zB4I2LonfJrLoU/oFnYvVcKeSMqmTB1hOgWAgigeh5w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tMXdODFh2OXNZGEgoJ92gqlG7zbepVGPgYYD8udAdPCGcesbCGbUEQ7q9t1jOAgVJR+uvsldWFCq8KJ8ICHIZ2TtXUZTlqhbQjVkqPfKduYtF+O2k0m7UMgmT8N+5VrjvRZHRfSdxd+hZODRAzLkAlR/D6TnNKqLATrou7GUbrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Dwco3b/D; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Dwco3b/D"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4b1MB51GSvzm1Hcc;
	Mon, 19 May 2025 15:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1747668730; x=1750260731; bh=1iGvaXPFmlCaD7tO069Z1NW0
	tGPHoKnaB5/b9gvCSeY=; b=Dwco3b/Dya5jpYSEcBA1gsi08sADra3tzFzI0Oz+
	iIjDs2+j+/vYXpMqTvH4WJWNTm51pMVjEtZG8QrKPWCzcxrQTaOcQ68Oa+wJoZbS
	rWGGDx+0U7DQADlDu6h8Zjdy6z6MUdB41jIcK2Sr2iJfx5xyicjdD3emzVr87O7r
	Yt89KL6wDjfInX3pVjcmNj0xgTt+WQ8u39MHw/kdzxlO2C+PQ2niT3RfvdJGs+lb
	X52/UkmgO9BvkRFirjpnxIKRAjWsFpK/C5Z3RLp1oXtJJUB6KdvkUu3KD+plLP55
	Hrz0VqVgdbb597AeklR+NeM1JZidV8XZg0yXOzY5ACRYqA==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id L_M2lBvzyI16; Mon, 19 May 2025 15:32:10 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4b1M9p42Njzm0Hqx;
	Mon, 19 May 2025 15:31:57 +0000 (UTC)
Message-ID: <60c20e1f-ab07-4af9-b7ea-b199364c66d0@acm.org>
Date: Mon, 19 May 2025 08:31:56 -0700
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

UFS driver kernel patches should be prepared against Martin's for-next
branch. Commit a3a951064f7e ("scsi: ufs: Rework 
ufshcd_clock_scaling_prepare()") removed ufshcd_wait_for_doorbell_clr().

Please fix the build failure introduced by this patch.

Bart.
