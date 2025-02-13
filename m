Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4635F155326;
	Thu, 13 Feb 2025 20:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739478908; cv=none; b=N7rvCESB/hvgxIQLVrWVBeWaG2hhGHnYE/DQusDqDI7UiOdyAf6whHrnBl5zVQYIGzypXUsX1miNEPy3UDi/CU6hMeJgOYp6ClhRs/DHQR1YliAjv7n5e62PyaUSKY+A559f2dVO4/r8r3Ya+WBrw0TBauUCWaLtVrttTZ+Dvno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739478908; c=relaxed/simple;
	bh=kMW0q3OhgSSXCCfHm9nB8oIwCWbTxs3HgyDLSYJzpmE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=chpJxUERWT4p9A+pmI2mDXtxTLWyZtg0fS1LxFHY8QTOGYojjwwBtyoU9H0sOXo1SZz4e5LAssh+z3d/qoDf1bO4YYGnsDaElPtfb78GdYb/HbMx8UhsL+5+HygTMlp5r6Hu4br0uufnJYnTT4l6mwNnrX/lOPgy2+LCh1/q9n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Ud2tXkYx; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Ud2tXkYx"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Yv6PH6hGZz6ClRMw;
	Thu, 13 Feb 2025 20:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1739478898; x=1742070899; bh=V7S8X9A0Q615GkJ6tApkvTVy
	C5cAvw5qdKEA6BRL/FM=; b=Ud2tXkYx7jqJ6ZnAvD6HYuQlJrCygmkj3nLfOkL/
	Iqp8yK9wc0Lohy625a3jcOhcQZ9upgIY25WmAciK1ueT4Qmf62APrsRxX0sf9vM+
	H978Y9WXJqeJ3PaqZ4vdurPn++LgoincboF23AINew92V23zVEpd9Jb709MhUNCf
	skrVgMQmof/6ekLCFita5PuWJDEeufGBysih9WospHjU50l6+0450nPXgkJdXhZe
	T3ONWRv8ZfPoykC4OVrqq/Fnyf5leTIUYt5ahvOFoFPfNlDfs9uaA4ACkrd+NnA9
	e+q97lmmtDAi+pXPC8uEYjFM1cBIVHy5i/5vMxwI7zD+UA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ZfvtwrqdSM8a; Thu, 13 Feb 2025 20:34:58 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Yv6PD6FFJz6CmR07;
	Thu, 13 Feb 2025 20:34:56 +0000 (UTC)
Message-ID: <065b6317-8da8-42ec-8084-1a5058c0798a@acm.org>
Date: Thu, 13 Feb 2025 12:34:55 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: hpsa: Replace deprecated strncpy() with
 strscpy()
To: Thorsten Blum <thorsten.blum@linux.dev>,
 Don Brace <don.brace@microchip.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-hardening@vger.kernel.org, storagedev@microchip.com,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250213195332.1464-3-thorsten.blum@linux.dev>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250213195332.1464-3-thorsten.blum@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/13/25 11:53 AM, Thorsten Blum wrote:
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 84d8de07b7ae..c7ebae24b09f 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -460,9 +460,8 @@ static ssize_t host_store_hp_ssd_smart_path_status(struct device *dev,
>   
>   	if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
>   		return -EACCES;
> -	len = count > sizeof(tmpbuf) - 1 ? sizeof(tmpbuf) - 1 : count;
> -	strncpy(tmpbuf, buf, len);
> -	tmpbuf[len] = '\0';
> +	len = min(count + 1, sizeof(tmpbuf));
> +	strscpy(tmpbuf, buf, len);
>   	if (sscanf(tmpbuf, "%d", &status) != 1)
>   		return -EINVAL;
>   	h = shost_to_hba(shost);
> @@ -484,9 +483,8 @@ static ssize_t host_store_raid_offload_debug(struct device *dev,
>   
>   	if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
>   		return -EACCES;
> -	len = count > sizeof(tmpbuf) - 1 ? sizeof(tmpbuf) - 1 : count;
> -	strncpy(tmpbuf, buf, len);
> -	tmpbuf[len] = '\0';
> +	len = min(count + 1, sizeof(tmpbuf));
> +	strscpy(tmpbuf, buf, len);
>   	if (sscanf(tmpbuf, "%d", &debug_level) != 1)
>   		return -EINVAL;
>   	if (debug_level < 0)

Something I should have noticed earlier: this code occurs inside sysfs
write callbacks. The strings passed to sysfs write callbacks are
0-terminated. Hence, 'buf' can be passed directly to sscanf() and
tmpbuf[] can be removed. From kernfs_fop_write_iter() in fs/kernfs.c:

	buf[len] = '\0';	/* guarantee string termination */

Thanks,

Bart.
