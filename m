Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1BC2F5A25
	for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2025 15:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761751315; cv=none; b=uOiAn0KT3BaHo5JUVxNSJ/EpascZgcY7QrvJf+vohmf+uu9xE4Mf6D43XXw0JGUiXeV7ZKqArjm5wmMgLt227B1xWnFB0D1i9at/GdMiVbVy+TEUQXfOxTeuElHvnirhhEO6AwMCdQg1OpBfublvVDTcfRs55AYiWE1CBe7gaHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761751315; c=relaxed/simple;
	bh=jaa9bcdSWpCQeAxNp6BWkzZgNqK0hw+0TvkBTFPpJhI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Rok5fLrH2r/4wk/1o6YgCDoVfiC64ihLg4fy47zDomXC7v/YoI+zSFdfW8H0bbzUgtwDWLii+ybvvUFuNLK+kddBbLgdop3hjWgJmQ+/x2cpQqyE2JteawPq1u3NPyOT9wUqNii+p8xpUQi8Sp1pd4T7+w1x5yW19yB2q0PahCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=qTOy/WTy; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="qTOy/WTy"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cxWDw4kNhzlw7Mt;
	Wed, 29 Oct 2025 15:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1761751311; x=1764343312; bh=WLWnAWDrJdoVijuzpsqN4GUl
	Aa0zvWNCClK5puhkDmM=; b=qTOy/WTyCo/kPH5qAgV96ka2lr0cnXpsROhoeT1c
	idY0+c6zoIjZLM6xXk/DZcltAIjg+Ini1PGNMLNjBByYN3EAW2YWtAzRXrRZcnWj
	HL/r2868iZzI5BgCYbDSHhPmJR+KC71+lGuoYGv0Lgw3/Y8tGjNxVChyWVZEYYft
	T5H0E90w7NMbjYjr45s6JM6j7dtbNZkNphzS+uIoQad3v2qg76pMikoJ7fO9U8a0
	lhUEs5pCQRQXZyIJHFGufVqhL7YR6gvgCpS2V3VMAkij8yj05X/7W73VHZpfvrKr
	dzRJUCaiDd4T6nmQy1CzSu3PPxqbDQ32mq1ADscMam7Mew==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id GTpMmkAt5Rip; Wed, 29 Oct 2025 15:21:51 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cxWDr3d3yzlw927;
	Wed, 29 Oct 2025 15:21:47 +0000 (UTC)
Message-ID: <172ce63b-fdd7-4482-8130-62f74fe1d332@acm.org>
Date: Wed, 29 Oct 2025 08:21:46 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] scsi: block: pm: Remove redundant
 pm_runtime_mark_last_busy() calls
To: Sakari Ailus <sakari.ailus@linux.intel.com>, linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20251029104648.795582-1-sakari.ailus@linux.intel.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251029104648.795582-1-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/29/25 3:46 AM, Sakari Ailus wrote:
> pm_runtime_put_autosuspend(), pm_runtime_put_sync_autosuspend(),
> pm_runtime_autosuspend() and pm_request_autosuspend() now include a call
> to pm_runtime_mark_last_busy(). Remove the now-reduntant explicit call to
> pm_runtime_mark_last_busy().
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>   drivers/scsi/scsi_pm.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
> index d581613d87c7..2652fecbfe47 100644
> --- a/drivers/scsi/scsi_pm.c
> +++ b/drivers/scsi/scsi_pm.c
> @@ -205,7 +205,6 @@ static int scsi_runtime_idle(struct device *dev)
>   	/* Insert hooks here for targets, hosts, and transport classes */
>   
>   	if (scsi_is_sdev_device(dev)) {
> -		pm_runtime_mark_last_busy(dev);
>   		pm_runtime_autosuspend(dev);
>   		return -EBUSY;
>   	}

To me this patch looks like a duplicate of an earlier posted patch.
See also
https://lore.kernel.org/linux-scsi/20251027-scsi-pm-improv-v1-1-cb9f0bceb4be@analog.com/

Bart.
