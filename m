Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7A13264D9
	for <linux-scsi@vger.kernel.org>; Mon, 25 May 2026 15:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779721941; cv=none; b=hDe25UY520bPkPxCq8lKNU5Jd5yY3R3P1LKrRHwNB+KdrTI+9X0Q+xMY89jDjXDfQzoOZI1EWLzDquZuhLDnBe30bDhT7WOiBRtz108ErpDIiUFYMWGsShUeIffygNZ0wt0lbMpEMKLClKLmzzILrPHcjq2rnQp59CCHMwKqmSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779721941; c=relaxed/simple;
	bh=TYnwg244YdkMwiVOpi76Bl6s2iv4v36Jo7hc+qbA0wA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZRs1gipa5dkYQhRESzWVgjtVUNYRtIVnQfV/ploCa+H+TOxZMQU39fHpKC+yPRsmiEOVNRflH2wQhHmQpSIiH0I1z87DCJAkpRBfU4B7VfPdXVbM6wYvz7AoWOQmUXVBI1LPKA35eh2oTJgaD0LSjT8C/QmSHrZvB13D9y2e2x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rowland.harvard.edu; spf=fail smtp.mailfrom=g.harvard.edu; dkim=pass (2048-bit key) header.d=rowland.harvard.edu header.i=@rowland.harvard.edu header.b=bgsE+4Df; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rowland.harvard.edu
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=g.harvard.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rowland.harvard.edu header.i=@rowland.harvard.edu header.b="bgsE+4Df"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-50fc496c8baso110200991cf.3
        for <linux-scsi@vger.kernel.org>; Mon, 25 May 2026 08:12:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rowland.harvard.edu; s=google; t=1779721939; x=1780326739; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BmdB1yygutO+scbhY9LQ/5YYX2QO8lbv/7XfmMzUbk8=;
        b=bgsE+4Dfm9iq5d4rFDhd25nEHA/aC/4sqQquz0uYhbapcchKEAB8hRDjZWuX0XtE/V
         Aie+E97A/314i/8HmjEQFIc02uNO2axdgO2yOmC3c6eyolrE4Ym8BDXeSmDIGEUP2Nd+
         ehpP+W4b5XjFDPEkZPPjJXcdplmvaWxJKXE7LJRBf3+ZgVnzcdoapMzPb/z8h99xoPHZ
         geE6EWef0CpDFifbWu4EyevDor5cwM6W+NAnC3T3/P7khgm5NO7yarNtno9KPDzqvoGK
         uBe1yywDa2ypdqTyvBeSSUmHCspNbtxBkGhomUoDtU0z3bzK0DnSB5+7W60TLr1pYQa2
         r8IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779721939; x=1780326739;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BmdB1yygutO+scbhY9LQ/5YYX2QO8lbv/7XfmMzUbk8=;
        b=q2p82nFgfCsyxVq6ZWF2u7sT1uMZPWafQbdDHk/0bRKlIfMnDClc01SBfp9nBC0jS3
         sM7Ku3etllgpKJ5H3+S6VG7cjkvH2vLohZ2AKSuqlQVw0wEaymmt06H9+tJzczXwu6LH
         sdktGEOlaBxeRHz/Up19+TyQ350tN+3ZrqKFGlN0JAH42reGlpth2CNccMhp0E3j/5Cr
         qPK6/Q+zry5PvSXGIMaa3Q0PS98u2rm84GVZSGvZNYNhRs7SVWoKcj2h93252PP79TtW
         iXe8YdkUYCozgjezEJtI0zuRqzitcJvwZrMI9vBFFfUhTRxpqIjzjGBAfcKiFksL41nt
         qaZQ==
X-Forwarded-Encrypted: i=1; AFNElJ8HehL9HXFE9WGHF5lFzWwNROWd3uQOCpQDAOsiApomlCkfbI8bZypEXKRlAZbYFk4LD0HAtgfO/H2l@vger.kernel.org
X-Gm-Message-State: AOJu0YzjIs4SGiavsz+yP5zmMHfjGd2vrerBBPWkyp+D/rYMbjvUmI4e
	OMUxB8EnTR5jZNW2RaW1lywBunwbVHGBEmQp9vUPoLC+ggwfHcVC1ixE7CU3C34otQ==
X-Gm-Gg: Acq92OE2h5PofCtyEps0JG5L5/G5ofseHww6CZfIcJPsTVop9JyJlUtNvnvOKGcAxhL
	+TuDB0YS9lR1X+D1KDeTFa37zNY38niUHmlGeMt/H2kdBh9vpvSuHUA3fx2TZZo4CclO4iOMOsR
	yn+egKVUOp/KoB7GvSfeVSIjS2OKKVoW+nOKMAiO1XqIAkv6MoOAkclkwd+Cu1zWKJecfETF1fj
	sWM0Gu7ADrCb4oVrS2jjImbOvA0uKgnexmwpvN1EwrgEtjkCtruiv0wCoWbkVnPuTw5h/gqzhd/
	MEbAQDfhXpi/XtJyrGOuXH0ax8tiM91d3lcq/vujYi8jDI+TSc/cyJ42hCFmI8pPkzs/MdzJ1w3
	9hQqWsLwBcIvenB8cWQkm5iyuaSPJp/JwXKdTSEVsye1AWVFU6kONKVFadSsdGWmKO3sg8P/iTy
	9OOL+lc/8uqgtLoUXfIWg7C35onkaMTxFHiu17Tq6vRwg=
X-Received: by 2002:ac8:598d:0:b0:516:e189:3482 with SMTP id d75a77b69052e-516e189373cmr122908691cf.29.1779721938490;
        Mon, 25 May 2026 08:12:18 -0700 (PDT)
Received: from rowland.harvard.edu ([2601:19b:d01:d210:d62f:1911:f952:16ba])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cca9c02e56sm14661306d6.43.2026.05.25.08.12.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2026 08:12:17 -0700 (PDT)
Date: Mon, 25 May 2026 11:12:15 -0400
From: Alan Stern <stern@rowland.harvard.edu>
To: Hongjie Fang <hongjiefang@asrmicro.com>
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
	jgarzik@redhat.com, ming.m.lin@intel.com,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: core: pair EH runtime PM get/put
Message-ID: <1daf2edf-b517-41b6-92ae-cc113d95215e@rowland.harvard.edu>
References: <20260525064556.1277177-1-hongjiefang@asrmicro.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260525064556.1277177-1-hongjiefang@asrmicro.com>

On Mon, May 25, 2026 at 02:45:56PM +0800, Hongjie Fang wrote:
> shost->eh_noresume is currently consulted twice in one error handling
> iteration: once before scsi_autopm_get_host() and once again before
> scsi_autopm_put_host().
> 
> That is racy when a PM-triggered error path flips shost->eh_noresume while
> the SCSI EH thread is still running.
> 
> The problem flow looks like this:
> PM path
>   ufshcd_set_dev_pwr_mode()
>     shost->eh_noresume = 1
>     ufshcd_execute_start_stop  <-- trigger EH
>     ...
>     shost->eh_noresume = 0
> 
> EH path
>   scsi_error_handler()
>     if (!shost->eh_noresume)
>       scsi_autopm_get_host()  <-- skipped
>     ...
>     if (!shost->eh_noresume)
>        scsi_autopm_put_host()  <-- executed later
> 
> In that case one EH iteration can skip autoresume on entry and still drop
> a runtime PM reference on exit. That leaves an unmatched runtime PM put
> and can trigger a runtime PM usage count underflow.
> 
> Fix this by calling scsi_autopm_put_host() only if the same iteration
> successfully acquired a runtime PM reference through the
> scsi_autopm_get_host().
> 
> Fixes: ae0751ffc77e ("[SCSI] add flag to skip the runtime PM calls on the host")
> Signed-off-by: Hongjie Fang <hongjiefang@asrmicro.com>

Acked-by: Alan Stern <stern@rowland.harvard.edu>

> ---
>  drivers/scsi/scsi_error.c | 19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 147127fb4db9..faa5cc818e5b 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -2342,6 +2342,7 @@ static void scsi_unjam_host(struct Scsi_Host *shost)
>  int scsi_error_handler(void *data)
>  {
>  	struct Scsi_Host *shost = data;
> +	bool autopm_get;
>  
>  	/*
>  	 * We use TASK_INTERRUPTIBLE so that the thread is not
> @@ -2383,12 +2384,16 @@ int scsi_error_handler(void *data)
>  		 * what we need to do to get it up and online again (if we can).
>  		 * If we fail, we end up taking the thing offline.
>  		 */
> -		if (!shost->eh_noresume && scsi_autopm_get_host(shost) != 0) {
> -			SCSI_LOG_ERROR_RECOVERY(1,
> -				shost_printk(KERN_ERR, shost,
> -					     "scsi_eh_%d: unable to autoresume\n",
> -					     shost->host_no));
> -			continue;
> +		autopm_get = false;
> +		if (!shost->eh_noresume) {
> +			if (scsi_autopm_get_host(shost) != 0) {
> +				SCSI_LOG_ERROR_RECOVERY(1,
> +					shost_printk(KERN_ERR, shost,
> +						     "scsi_eh_%d: unable to autoresume\n",
> +						     shost->host_no));
> +				continue;
> +			}
> +			autopm_get = true;
>  		}
>  
>  		if (shost->transportt->eh_strategy_handler)
> @@ -2407,7 +2412,7 @@ int scsi_error_handler(void *data)
>  		 * which are still online.
>  		 */
>  		scsi_restart_operations(shost);
> -		if (!shost->eh_noresume)
> +		if (autopm_get)
>  			scsi_autopm_put_host(shost);
>  	}
>  	__set_current_state(TASK_RUNNING);
> -- 
> 2.25.1
> 
