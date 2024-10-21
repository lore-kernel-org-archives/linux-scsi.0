Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B551C8FDB;
	Mon, 21 Oct 2024 20:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729542426; cv=none; b=tI7X24UcKkVX2Y1B3oKXotgWURxfRSrnZ4irmdQNkj2JFXOa861NBa4gt5AwxeeAVTAkzt/skn/RJIFbQgfXJcMBG801yWJRSynlVljuV9uqNJ156IoBRLRal225wDd39WxRCTTYO0nAD1t6vKJD2yNx/vr8MYebKIFy3zXRB0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729542426; c=relaxed/simple;
	bh=uv/3dU54aB+BWa8iRJDUGpKGAfzi3mrkwGikkdU0Z7E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VTtQpeDb1JlG5X9+YgQwzqCOG/OaxZa2Wxwq6jFgBNyCUaMiadDXyoxrTdo0PUy2c94jTNtQluKR0xCObAOzv+v9iOLIjGCaCMZ73el/7qFM6xsSpeJz1BJ/3ogjtLfHAXafIlyxp/0aTBK1g6gU0zJa8gn7NpEj2hcDhKTqFQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=hPa7TEX/; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="hPa7TEX/"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XXRgD1dy8z6ClY9Z;
	Mon, 21 Oct 2024 20:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1729542422; x=1732134423; bh=+GBkNOXBsz0NYwxOvcvtsHP0
	TzQ/xVpm3t32Z//Wj98=; b=hPa7TEX/+pbyvQiUcc0lSfUaKWhajLG+8q/vkKCe
	d8NrYLgriwFXPl2ZHsg//t+SoteDISfZ4q9Ejzv8ClO2kdWvzGBSqxfepyWTr09n
	d2rdpZFN/Nzgi+XpYOX+W8WQutwp+AxMgKVAOgI6Cj4GUD01HZN5LfMsFpIanof1
	hQVUaD15oDZIoT2wszFDkxeDvUJJ8RV+rR2xpIc6yMYvnOInWkKJqZMfigZUi7O7
	Q0g3wLQ54jqYEcdi6Fc8SpRnMMkfI75VWhx0r44R/xhPCvpzRk2+C4VSkRmsvojK
	3bcIsKQWir9mivL7wyu4wE2odcYyMHrzsoeuv+EmQN54HQ==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 4V4-_IhGqtiC; Mon, 21 Oct 2024 20:27:02 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XXRg863Bnz6ClY9V;
	Mon, 21 Oct 2024 20:27:00 +0000 (UTC)
Message-ID: <0a1a0c85-e2f1-4a7c-ad0d-86ad8a84e624@acm.org>
Date: Mon, 21 Oct 2024 13:26:58 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] scsi: ufs: core: Use reg_lock to protect UTRLCLR
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20241021120313.493371-1-avri.altman@wdc.com>
 <20241021120313.493371-4-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241021120313.493371-4-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/21/24 5:03 AM, Avri Altman wrote:
> @@ -3100,9 +3100,9 @@ static int ufshcd_clear_cmd(struct ufs_hba *hba, u32 task_tag)
>   	mask = 1U << task_tag;
>   
>   	/* clear outstanding transaction before retry */
> -	spin_lock_irqsave(hba->host->host_lock, flags);
> +	spin_lock_irqsave(&hba->reg_lock, flags);
>   	ufshcd_utrl_clear(hba, mask);
> -	spin_unlock_irqrestore(hba->host->host_lock, flags);
> +	spin_unlock_irqrestore(&hba->reg_lock, flags);
>   
>   	/*
>   	 * wait for h/w to clear corresponding bit in door-bell.

Hi Avri,

A similar comment as for the previous patch applies to this patch:
ufshcd_utrl_clear() performs a single MMIO write so I don't think that
calls of this function have to be serialized.

Thanks,

Bart.
