Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B773315760;
	Fri, 16 Jan 2026 09:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768554015; cv=none; b=Lpc/VJNzmUzyaVIQXhHn/bzqbO0TB0gYcfPG2x8lR9mZCd8+WnTcVKcbAApQ/XxzsGjTlmoXTAW73V8/gIZg7JM32B7NTEBe5R39XJ/8d+M7RmDrxZSbw8U+JgYLntiCOFUBGIAjZc6kwukt0Fl4rCFBNy/J2nogUCQDY81pZt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768554015; c=relaxed/simple;
	bh=R3MauWsP6Xl0kNM58V4ibYDwwPFe2SpduEH9T7itIFw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EzM2ZF5Ojf/HB1o3fwDFGB6OeM2dytEappau964UILFNJI4pHgTV6WjLmt/O57Xw6GTLMrcaiT50N7CviPlutch6g/6ED++V8DnvWkfAG7pxRDGggj8N0ANDUJ/7Fgc0rEqInt2QeoF5Iq2qGIkA3AvCdExzqeVOwMG5MgDi51Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zdwzyaXi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zdwzyaXi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C62AC116C6;
	Fri, 16 Jan 2026 09:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768554014;
	bh=R3MauWsP6Xl0kNM58V4ibYDwwPFe2SpduEH9T7itIFw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=zdwzyaXi3fCNymTj1Rc8HAGr1xTIgdgvQBoyt4sYcfn9tFq+Q29v9iitZsrjjlUTN
	 47bt+Vqrvi66QJdrM+MFXiucyy2L3xtuahzG1G5ZBoyW8YhxrC70hTqoxKQNzJ01ix
	 uAfn8xg8iCV5CURnKr0Km15iVTdKwkDFu9+5x/V8=
Date: Fri, 16 Jan 2026 10:00:11 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Tzung-Bi Shih <tzungbi@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] scsi: core: Correct wrong kfree() usage for `kobj->name`
Message-ID: <2026011614-exile-raisin-0ec4@gregkh>
References: <20260116081359.353256-1-tzungbi@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116081359.353256-1-tzungbi@kernel.org>

On Fri, Jan 16, 2026 at 08:13:59AM +0000, Tzung-Bi Shih wrote:
> `kobj->name` should be freed by kfree_const()[1][2].  Correct it.
> 
> [1] https://elixir.bootlin.com/linux/v6.18/source/lib/kasprintf.c#L41
> [2] https://elixir.bootlin.com/linux/v6.18/source/lib/kobject.c#L695
> 
> Cc: stable@vger.kernel.org
> Fixes: b49493f99690 ("Fix a memory leak in scsi_host_dev_release()")
> Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
> ---
>  drivers/scsi/hosts.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index e047747d4ecf..50ec782cf9f4 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -373,7 +373,7 @@ static void scsi_host_dev_release(struct device *dev)
>  		 * name as well as the proc dir structure are leaked.
>  		 */
>  		scsi_proc_hostdir_rm(shost->hostt);
> -		kfree(dev_name(&shost->shost_dev));
> +		kfree_const(dev_name(&shost->shost_dev));

Shouldn't the struct device name be freed by the driver core for this
device when it goes out of scope?  Why is it being manually freed here
at all?

thanks,

greg k-h
