Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832BE18EB0;
	Fri, 20 Sep 2024 18:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726856623; cv=none; b=fK+5XPMmhj6cf4dg+LMuU5g1JKHb481MDYxmoMBQ6+E/UavzZvTT11WVgHT7vgpkI+tmA8s1RvW7ubqaYKPipyKGro6zQur3CIhtHqL+wvA9te9e/oL0b0WXH9Q995Qn5JTPAMgg86OjM9nG0Oe4ttB1uiFI584IlLq6TR87kfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726856623; c=relaxed/simple;
	bh=QB8PHONZTTBAn+/q0fy6UL6ky3Xg7Imqk2lRddd9XtQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=noZXixhRdtYJQgd3JHyzDyYq+H/yT0D27sF1M8azT3swegBAZu9qioMjRW5xaLgo7ajTydcJSG/SQyVWruHhj7eoPLs9ZJ9kU95PpphZsnNpacOGvZ7XH0DvG3cQwJab27cBQJnq22gqesK4sTs4196sZfdM61WOsYz+KoZ49uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=QjU8ovvl; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="QjU8ovvl"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X9LP8696fz6Cnk8t;
	Fri, 20 Sep 2024 18:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1726856618; x=1729448619; bh=xw0PD47y/tmMyW+r+5y1TzjP
	Xkw788ZDK1OacXWzjJY=; b=QjU8ovvlXPJUDUop/erBX8U84qeMX+maEQ4rtoUe
	c+OMNfAANf8J7uRRitQWT4gduyzH51HHXwJAIrMS6ht2IBE1rslgylAfpRhbIhdX
	fkCvytnR5vAxYI2YcmbGkrGpShiEzdmrE5m0DPt+17vTWvHzZym1xL2FX33S7EYX
	p2iV7mwEMO0gQuyPOiif2kXSfcSP1waJWK+Lid//NRSSkqgNvzqX3QAjknY9tdCF
	8mqae/lfpcenuNVSi6URD/Kzpc0pTiWCOlzLDF37YZxLcBFq9R5gNYwyM3SDJT+4
	6r3Eq+cTPiOwLKRB30Qt6vPIR5DERFpuKoch85LIhvrwBA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id I1CJUo1pThuK; Fri, 20 Sep 2024 18:23:38 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X9LP62BkSz6ClY96;
	Fri, 20 Sep 2024 18:23:38 +0000 (UTC)
Message-ID: <ff33de4f-d111-4499-afff-231baaccf61c@acm.org>
Date: Fri, 20 Sep 2024 11:23:37 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: Do not open code read_poll_timeout
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240919112442.48491-1-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240919112442.48491-1-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/19/24 4:24 AM, Avri Altman wrote:
> ufshcd_wait_for_register practically does just that - replace with
> read_poll_timeout.
> 
> Signed-off-by: Avri Altman <avri.altman@wdc.com>
> ---
>   drivers/ufs/core/ufshcd.c | 22 ++++++----------------
>   1 file changed, 6 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 8ea5a82503a9..e9d06fab5f45 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -739,25 +739,15 @@ EXPORT_SYMBOL_GPL(ufshcd_delay_us);
>    * Return: -ETIMEDOUT on error, zero on success.
>    */
>   static int ufshcd_wait_for_register(struct ufs_hba *hba, u32 reg, u32 mask,
> -				u32 val, unsigned long interval_us,
> -				unsigned long timeout_ms)
> +				    u32 val, unsigned long interval_us,
> +				    unsigned long timeout_ms)
>   {
> -	int err = 0;
> -	unsigned long timeout = jiffies + msecs_to_jiffies(timeout_ms);
> -
> -	/* ignore bits that we don't intend to wait on */
> -	val = val & mask;
> +	u32 v;
>   
> -	while ((ufshcd_readl(hba, reg) & mask) != val) {
> -		usleep_range(interval_us, interval_us + 50);
> -		if (time_after(jiffies, timeout)) {
> -			if ((ufshcd_readl(hba, reg) & mask) != val)
> -				err = -ETIMEDOUT;
> -			break;
> -		}
> -	}
> +	val &= mask; /* ignore bits that we don't intend to wait on */
>   
> -	return err;
> +	return read_poll_timeout(ufshcd_readl, v, (v & mask) == val,
> +				 interval_us, timeout_ms * 1000, false, hba, reg);
>   }
>   
>   /**

Has it been considered to remove the ufshcd_wait_for_register() function
and to use read_poll_timeout() directly in the
ufshcd_wait_for_register() callers? The above patch makes
ufshcd_wait_for_register() so short that it's probably better to remove
this function entirely.

Thanks,

Bart.
