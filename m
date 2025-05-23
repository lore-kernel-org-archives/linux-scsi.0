Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9F51A0BF3;
	Fri, 23 May 2025 16:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748016885; cv=none; b=qJAHsFc0XkjXleYCa7G0NFVdomHtfohrLf54ahQNC2voBv3QgtxXpLEY5746OpjjIvAVC3DAHpqb0xtvWOt3ZSj7izt0ByFeNhPhbix93M94mAgbYwcoAlCC65W1dOHr+sMGAG74TW1KzvXQ22CG5sH3rJ7OE9Wc7ni1RqABEb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748016885; c=relaxed/simple;
	bh=0SzYKSzxQM+1V+XY2it4tfm6cveHMJtM8UUtz4GMRD0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Cqixu2fOp3VgnZg0oKW81HlVkg32FFwnpooBo6dEonb8azeo/Mb1AuyFH38Xyi2U/h/DUD8hw+6xUfFFEauEQx41kPi7dvYTyUFVuWB1HeH1B02HkglNu9vUejOhP9h5OnRsVmlf9bqbXI3vMwovlgiW27LYQKlgk1O6rXx3ZzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=xU9vrABs; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="xU9vrABs"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4b3qx74t2Mzm0yVc;
	Fri, 23 May 2025 16:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1748016872; x=1750608873; bh=TisoT1GJKWQdeL0EC37oUEGl
	p+YGOKzOH7FoNix20D8=; b=xU9vrABsUYq4zcSAfdLkpbXZnnzktvng2o5pI/Q/
	ziOO1dHMJO99+2qQY5SWzAvOo2nYwVg3yc3/eKqGXs5/F1dt80JgzNpcRJQqOw5v
	Jd2gZSRYlzhcnTYNT1Yjx6o5eJPu0ffE09owgUarMo3JEzrtzIAZ6b2jUu3fD2o0
	b+TTyegQqqnknufjqZZI9VF8mfy4agIvigdfMoCwJZM1kUEUQcw5/ibQrLgWpGVN
	71NGqkrf6/xk074GgLtYzyODD1rCOB7gXBZqjDsvQVGTVuZC53XA3gu3sS12xJ+h
	9xnPQNPv4UxRuCSZfj4+vtcQj3SuhwAgNvj9JxMumtCASA==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id jUb281F6MwOT; Fri, 23 May 2025 16:14:32 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4b3qwq3FVSzm0gbW;
	Fri, 23 May 2025 16:14:18 +0000 (UTC)
Message-ID: <c2608cd6-8c77-48f2-bc50-2ff087b0d48f@acm.org>
Date: Fri, 23 May 2025 09:14:17 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] ufs: core: add fatal errors check for LINERESET
To: naomi.chu@mediatek.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org, Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@wdc.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: wsd_upstream@mediatek.com, peter.wang@mediatek.com,
 alice.chao@mediatek.com, chun-hung.wu@mediatek.com, cc.chou@mediatek.com,
 yi-fan.peng@mediatek.com
References: <20250523101041.3615819-1-naomi.chu@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250523101041.3615819-1-naomi.chu@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/23/25 3:10 AM, naomi.chu@mediatek.com wrote:
> +static bool ufshcd_is_linereset_fatal(struct ufs_hba *hba)
> +{
> +	bool needs_reset = true;
> +	unsigned long flags;
> +	int err;
> +
> +	spin_lock_irqsave(hba->host->host_lock, flags);
> +
> +	if (ufshcd_is_saved_err_fatal(hba)) {
> +		spin_unlock_irqrestore(hba->host->host_lock, flags);
> +		goto out;
> +	}
> +
> +	/*
> +	 * Wait for 100ms to ensure the PA_INIT flow is complete,
> +	 * and check for PA_INIT_ERR or other fatal errors.
> +	 */
> +	spin_unlock_irqrestore(hba->host->host_lock, flags);

Please use scoped_guard(spinlock_irqsave) instead of calling 
spin_lock_irqsave() and spin_unlock_irqrestore() directly.

 > +	msleep(100);

Can ufshcd_is_linereset_fatal() be called from IRQ context? If so,
calling msleep() is not allowed. If it can't be called from IRQ
context, saving and restoring 'flags' is not necessary.

Bart.
