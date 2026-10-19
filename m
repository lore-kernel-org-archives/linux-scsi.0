Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832A44EFFDA;
	Mon, 19 Oct 2026 13:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792416603; cv=none; b=uQc3mvXZ4UQfYSLI2dvOjcnA0yb9VzSr3PyFzJZBU9WwZ2wnFBN9WmR5jDDeAHVt9BtWfBMDpZnTmKNIUzayrkUmiTJwoYVdaQoSCL8SSk2yPCD8axhYafS1WiTmnXOLk+Rf+4ipRpRwV1Mv140KB6Mf5bxkpVPMzc0O8ECdXdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792416603; c=relaxed/simple;
	bh=4edqWoO4BtHuw6wsM7+aehcde8yUXgyeTW4Syto0Gp0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JtDHfm24pSLs9M6wUgCK/ecgio3YUKS5JFJVXoOJsSmLTfxcdnLvUXRRU2bCxWYrOo05eTH2dDugkH8jIOdi7iSlaI+YRdvY9qrIzwDd3xFu4O0kqqYnlAmMEfxuMMYFDMIrAZQwmQYAbb/bVx0SzR0F/yUaWNpbfIWH+xPGJXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=GY6awD07; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=7NXhReUL; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="GY6awD07";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="7NXhReUL"
Date: Mon, 19 Oct 2026 15:29:59 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1792416600;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OOfOpAADPpkAm+yYaZybu39Zph8JXuRjRbssHcMIQMc=;
	b=GY6awD07614OvcT0YkJTMjHB1x1s/Ffujde6mRxEhQeyyE3eG+4p+Hfl2c2QtRDtNlSLi5
	hYz2MbEYovpj+qhGG1fmsfwXMM/2CIj8OgnlqdqWTLUAAtxz+8AFopG/+uRvUPOJSfsd2Q
	ox/foxGmFGXgu5uORwi0jcrwF7jUSEDjVTP7nEDdnLEAu4nra4F+9Qh6qqkMS2DlbaDJnR
	gnJHa0YfYlSTZf7BgPx0Ncl1s1Z4bQupEfe7ZzCFyuBT8VgQ9gMUFcbnVOl9cNUKV015Uv
	XlUZlnHLkp4gUgH5ucJeH9Lv/r1CI5xRtvg8WsMzBdywhgBsEOZ6Pg7L1222Fg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1792416600;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OOfOpAADPpkAm+yYaZybu39Zph8JXuRjRbssHcMIQMc=;
	b=7NXhReUL62MaWL0ZZcVtwwIglobziljA1RMaxAe9QBgX36QTH6dT7fjaSdjvveSUT1xjd/
	XYGj61XqBNYocfAw==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Haoran Wang <haoranwangsec@gmail.com>
Cc: Varun Prakash <varun@chelsio.com>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-rt-devel@lists.linux.dev, linux-scsi@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libcxgb: use raw_cpu_ptr() in ppm_get_cpu_entries()
Message-ID: <20261019132959.vUxChMBS@linutronix.de>
References: <179241614797.5916.13928836073297916808@whr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <179241614797.5916.13928836073297916808@whr>

On 2026-10-19 21:22:27 [+0800], Haoran Wang wrote:
> diff --git a/drivers/net/ethernet/chelsio/libcxgb/libcxgb_ppm.c b/drivers/net/ethernet/chelsio/libcxgb/libcxgb_ppm.c
> index 2e3973a32..5f68c5d57 100644
> --- a/drivers/net/ethernet/chelsio/libcxgb/libcxgb_ppm.c
> +++ b/drivers/net/ethernet/chelsio/libcxgb/libcxgb_ppm.c
> @@ -125,10 +125,9 @@ static int ppm_get_cpu_entries(struct cxgbi_ppm *ppm, unsigned int count,
>  	if (!ppm->pool)
>  		return -EINVAL;
>  
> -	cpu = get_cpu();
> -	pool = per_cpu_ptr(ppm->pool, cpu);
> +	cpu = raw_smp_processor_id();
> +	pool = raw_cpu_ptr(ppm->pool);

cpu needs too be obtained after the lock has been acquired.
Please also explain why it is okay to obtain pool belonging to CPU1 on
CPU0.

>  	spin_lock_bh(&pool->lock);
> -	put_cpu();
>  
>  	i = ppm_find_unused_entries(pool->bmap, ppm->pool_index_max,
>  				    pool->next, count, 0);


Sebastian
