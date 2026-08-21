Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A0B3749FE;
	Fri, 21 Aug 2026 07:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787295722; cv=none; b=VuOifNC6J+sXA74agP04mwOtxJqWg/oRIY2Z/nvtq6CPfkFtKHDyDLWnx7JeGjFM/yd9jSBgfPhDLGNTI1oLqpTzSLHBOtSKFEn7+eifZ4zGuNGmulIv5Yg8iSxUKGCwLNfh6cWXzcK+eEMUqkDMY9L4lehwpaVAEnuLELZiyc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787295722; c=relaxed/simple;
	bh=4TX2QahjiTkyoA/041QEuWjdMqU/ERjIlAbKvUgkb1w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YX48ny+eR5asrKa0uQQia/pRbH0+61sq3TzdQnkW05GI+kvj1tNbX9jrxkmn/7bhltkhNJc4XA0LnOZrnFNzwfjpyYxHA6a48bNRzbczsC2iFj7cAr4Jy95lJyzNhxIwoAgPJX7VRY3HtISmYFn22Dgsru0Dy5rmm0BUtuCQQDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SFa5IRuc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SFa5IRuc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C90B91F000E9;
	Fri, 21 Aug 2026 07:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787295720;
	bh=Li4JoMUOzi4rNaTGXD33henUn+xHZ19aKX74D4YdsnI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SFa5IRuc5UU8310Ou2Yl+dQpFpQyakRFZyUvDB0hpwFkNMGn3PVIKFo02NW67I00q
	 eEVZ/jE7E1l46Zq0AMrBRjbWzU3CBI+iFdBoBz6DChb36beSBI7BuDdV9RLRwBnPsh
	 AI7hDRxlloTz3lF9J5BfK8NMUN74SCqB0zgFtSZQ=
Date: Fri, 21 Aug 2026 09:00:21 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Runyu Xiao <runyu.xiao@seu.edu.cn>
Cc: "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, Jianhao Xu <jianhao.xu@seu.edu.cn>
Subject: Re: [PATCH] scsi: pmcraid: shut down command timers before reuse
Message-ID: <2026082153-twentieth-football-2afa@gregkh>
References: <20260821062351.72658-1-runyu.xiao@seu.edu.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821062351.72658-1-runyu.xiao@seu.edu.cn>

On Fri, Aug 21, 2026 at 02:23:51PM +0800, Runyu Xiao wrote:
> pmcraid removes a command from the pending pool and then either
> completes it or reuses it for reset. timer_delete() only removes a
> pending timer; it does not wait for a callback already running and does
> not prevent the callback from rearming the timer. A timeout callback can
> therefore access a command block after it has been returned or
> reinitialized.
> 
> The response paths run in hardirq or softirq context, so they cannot
> wait synchronously for a normal timer callback. Shut down the timer there
> and defer completion to a work item. The worker uses
> timer_shutdown_sync() before calling the original completion function.
> The reset cleanup path also defers the reset command when it is still
> pending so the reset engine cannot reinitialize it before its timer
> callback has finished.
> 
> Flush command work before releasing command and control buffers.

How was this found and tested?

> 
> Fixes: 89a3681041507773 ("[SCSI] pmcraid: PMC-Sierra MaxRAID driver to support 6Gb/s SAS RAID controller")
> 
> Cc: stable@vger.kernel.org
> 
> Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>

Why the extra whitespace?  Didn't checkpatch complain about this?


> 
> diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
> index 942a99393204..ed2ebe68c816 100644
> --- a/drivers/scsi/pmcraid.c
> +++ b/drivers/scsi/pmcraid.c
> @@ -55,6 +55,43 @@ static unsigned int pmcraid_enable_msix;
>   */
>  static atomic_t pmcraid_adapter_count = ATOMIC_INIT(0);
>  
> +static void pmcraid_cmd_work(struct work_struct *work);
> +static void pmcraid_complete_reset_cmd(struct pmcraid_cmd *cmd);
> +
> +static void pmcraid_complete_reset_cmd(struct pmcraid_cmd *cmd)

Why the prototype right before the definition?  Did a LLM create this
patch?  If so, you should upgrade to a better coding model :)

thanks,

greg k-h
