Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3FAB2581;
	Mon, 14 Apr 2025 16:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744647389; cv=none; b=WQwY6fwHbZqcd2CQrsFqH9I2vgocTSvzY2bv/4i+EqGdufv+cPSqz7RseDWxSNyQCpDvS5jlZNd4nwJEsA2/IUAf9PEne2THzww7b4cPGHZ/QriTnCEIC/DcmhPHc8nEEYS5UfoihD/5ievO4x2K77Dc7vV4s0j0ttIUTPgg4Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744647389; c=relaxed/simple;
	bh=JW3DZlESxFpH/J8R2XOqvNVZDI3osLBTkD5mXT4x/Tw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fVwsLM+Aqj84q/ccvAXj4geY4KMzdFnFhy8vtoEQKu6Y4kubrANGsbk5aPpM3iy4GNoG/P3xInu1xRsvGxHSkvCSFc7lLZhlyemQFoizlBJolMcD716OXUEdUHiMXyeAj6D7XzjBkYdRetLamKTz2gjTPp1cUR01cgLgZ2vV+Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=2HDvSMa3; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="2HDvSMa3"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4Zbsq83ZpFzm0ySN;
	Mon, 14 Apr 2025 16:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1744647378; x=1747239379; bh=rSsUk9uG/IxXmmElRZckPLD1
	w7rzdsFKjqCbyTaMZB0=; b=2HDvSMa3UebxqOen6fHTfLBvpMkgZK15rrKZv+i0
	Aw4fDtYsy2jc63wl8bNWmwOzN2FFpGsV2fPqCFdJdL65KJ1l9xE/j9V5sv+2568D
	dnACiNlri/5B0O2q6a+X/q1Th8jWcOFPQPSKZ8eAXNPNwT72eQokvV3/r5QF1dZ1
	3ly080uzmkWmNq3jRH1kMpAtRtiseGaRMkIpB42GB8waPUCdN0kN5oMTbpcHH+vd
	rZe30hI6lRltjTV/5XLulS8ZE4S8YovoTLDp4+8e+FUwm1bB4BkQ/Mu/md6AZfqz
	7zIh3zoMCAlY+dwP5UlJbE5YgjDNXf8oxtghTQ+kos8c8g==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 7unPeglGk_UE; Mon, 14 Apr 2025 16:16:18 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4Zbsq30mf0zm0pKn;
	Mon, 14 Apr 2025 16:16:13 +0000 (UTC)
Message-ID: <e038e519-c301-4928-a246-ebd25f16bb32@acm.org>
Date: Mon, 14 Apr 2025 09:16:12 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ufs: bsg: Add hibern8 enter/exit to
 ufshcd_send_bsg_uic_cmd
To: Arthur Simchaev <arthur.simchaev@sandisk.com>
Cc: avri.altman@sandisk.com, Avi.Shchislowski@sandisk.com,
 beanhuo@micron.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250414120257.247858-1-arthur.simchaev@sandisk.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250414120257.247858-1-arthur.simchaev@sandisk.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/14/25 5:02 AM, Arthur Simchaev wrote:
> This patch adds functionality to allow user-level applications to send
> the Hibern8 Enter command via the BSG framework. With this feature,
> applications can perform H8 stress tests. Also can be used as one
> of the triggers for the Eye monitor measurement feature added to the
> M-PHY v5 specification.
> For completion, allow the sibling functionality of hibern8 exit as well.
> 
> Signed-off-by: Arthur Simchaev <arthur.simchaev@sandisk.com>
> 
> ---
> Changed since v1:
>   - elaborate commit log
> ---
>   drivers/ufs/core/ufshcd.c | 10 ++++++++++
>   1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index be65fc4b5ccd..536b54ccc860 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -4363,6 +4363,16 @@ int ufshcd_send_bsg_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
>   		goto out;
>   	}
>   
> +	if (uic_cmd->command == UIC_CMD_DME_HIBER_ENTER) {
> +		ret = ufshcd_uic_hibern8_enter(hba);
> +		goto out;
> +	}
> +
> +	if (uic_cmd->command == UIC_CMD_DME_HIBER_EXIT) {
> +		ret = ufshcd_uic_hibern8_exit(hba, uic_cmd);
> +		goto out;
> +	}
> +
>   	mutex_lock(&hba->uic_cmd_mutex);
>   	ufshcd_add_delay_before_dme_cmd(hba);

This is wrong. The BSG interface shouldn't alter the power state without
informing the SCSI core about these power state changes. Please use
existing sysfs attributes to modify the power state or add new sysfs
attributes if necessary.

Bart.
