Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27AFB32E686;
	Tue,  9 Dec 2025 17:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765302840; cv=none; b=qQE0FgmxTAe27IzpN9QquDUnizAUxwENesQ9kNgaDovJ5v6YsLhd+jElIQNDvH4sKM6fIzUYKj+zzrSqQd0dD3xHpeao5XQVO2VaSksh4y8G5Q1bROtJ0UgOgwD6XqXLoV1wtlBnVemfKtr3YaouAiCUiUPt6qFofJjTyzDx3Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765302840; c=relaxed/simple;
	bh=kIU58lX2I0WyiVgrrM89Sz5lEnzBF5dOS3VpImKIU8I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=necTWb3yrOh4zW7lOvjDjSbXoZhTuEiCrNQFmN9CZbUVpBrjPoLjSsthTv2p5MrGX6LKVOql+wMuah5j2EwN3fWhTRWynzkvNvLcANn6RbVvtwNMa6nSwIoNBl3m1Xl2TDuYEQZqY8RUNWfE87kvTo4FlTD7U3l9guDDezzz+30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=kUpWFiyR; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="kUpWFiyR"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dQmgV4GXYzllCmP;
	Tue,  9 Dec 2025 17:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1765302836; x=1767894837; bh=N9Xh9NKHh0RisCHaVAkhfiek
	XTa5Hp5BK06hiPEjz1w=; b=kUpWFiyRmFYBYK/tKfn1M68PcnHfptKaeWHg3pad
	jelmMVQJ+baTZln5rVfLEHikSdeuMquRaff9DoGf977xDWAtMc2eRgCRkyEyKndN
	Zeq8xjjJGmrja4I7+aWelZdRPH2qF5kvPGOOpOw/5JvB1kIKFwrMR8v+/gwarRJX
	lBATQuXSITB+PlsQzkOfcTOgSQ6jz2nLpe0eyowteQFuxE3E0oRd9szxpPNRE9Rg
	2mhwFOE5nogVNMuajitwk7/yfjjwOwqMAcZmExh2syljwi8j+bBERLW6no5tSqV6
	/f1yA7jRjaMX6XvXFgjKXzp6iwLb0pkqsk6SroZuUPp1PQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id bQUYt3kGPJTO; Tue,  9 Dec 2025 17:53:56 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dQmgP2ccfzllvdD;
	Tue,  9 Dec 2025 17:53:52 +0000 (UTC)
Message-ID: <a00f5bc6-02a0-41cb-8da6-1df779831430@acm.org>
Date: Tue, 9 Dec 2025 09:53:51 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] scsi: ufs: core: Fix error handler encryption support
To: Po-Wen Kao <powenkao@google.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "open list:UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER"
 <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>,
 Christoph Hellwig <hch@lst.de>, Eric Biggers <ebiggers@kernel.org>
References: <20251208025232.4068621-1-powenkao@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251208025232.4068621-1-powenkao@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/7/25 6:52 PM, Po-Wen Kao wrote:
> From: Brian Kao <powenkao@google.com>
> 
> The UFS driver utilizes block layer crypto fields, such as
> rq->crypt_keyslot and rq->crypt_ctx, to configure hardware for inline
> encryption. However, the SCSI error handler (EH) reuses the
> Protocol Data Unit (PDU) from the original failing request when issuing
> EH commands (e.g., TEST UNIT READY, START STOP UNIT).
> 
> This can lead to issues if the original request of reused PDU contains
> stale cryptographic configurations, which are not applicable for
> the simple EH commands. These commands should not involve data
> encryption.
> 
> This patch fixes this by checking if the command was submitted by the
> SCSI error handler. If so, it bypasses the cryptographic setup for
> the request, ensuring UTRDs are not inadvertently
> configured with potentially incorrect encryption parameters.
> 
> Signed-off-by: Brian Kao <powenkao@google.com>
> ---
>   drivers/ufs/core/ufshcd-crypto.h | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/core/ufshcd-crypto.h b/drivers/ufs/core/ufshcd-crypto.h
> index c148a5194378..26a0699c8412 100644
> --- a/drivers/ufs/core/ufshcd-crypto.h
> +++ b/drivers/ufs/core/ufshcd-crypto.h
> @@ -16,7 +16,12 @@
>   static inline void ufshcd_prepare_lrbp_crypto(struct request *rq,
>   					      struct ufshcd_lrb *lrbp)
>   {
> -	if (!rq || !rq->crypt_keyslot) {
> +	/*
> +	 * Do not use the crypto settings if the SCSI error handler has replaced
> +	 * the SCSI command
> +	 */
> +	if (!rq || !rq->crypt_keyslot ||
> +	    unlikely(lrbp->cmd->submitter == SUBMITTED_BY_SCSI_ERROR_HANDLER)) {
>   		lrbp->crypto_key_slot = -1;
>   		return;
>   	}

(+Christoph Hellwig and Eric Biggers)

Cc: stable@vger.kernel.org
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
