Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A131B4223
	for <linux-scsi@vger.kernel.org>; Mon, 27 Jul 2026 14:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785161471; cv=none; b=AjkSxIactc/EFienDmoww2YphNTpgquWKxRmX76zKh+cBhsXRI04sjm1E88dl2iXJ2oxffjN8Vm4WJ5gHNbxAOTFLFq5eOUBuIyVZJMnlVzfzgteRY4viDm06A32/4lve4NZGd/eOvlmQSrUMVw2Ce/XLFMG5Y7QJxVuxurTZhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785161471; c=relaxed/simple;
	bh=FpK9q6QaRy1fdWGEeJRWgTwCq9/HVYjd62KuAt5L3+w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=svh/Mig4w6kIK+4ib2V5PyNJw9DOUBcoOqvP1HFDSNuG/qQKLshgHfJYs0ExDraEPqf/avmg2Ra3yLmsbWdhAksUXK8HdzlkE/AmsNk8B/BKziddfUb0J898ukyWAQkzOLgzxk8moMpg0HSAdlQqqSt8OnnRC7zHPa+IaXsbZ0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rowland.harvard.edu; spf=fail smtp.mailfrom=g.harvard.edu; dkim=pass (2048-bit key) header.d=rowland.harvard.edu header.i=@rowland.harvard.edu header.b=WVtxVHzg; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rowland.harvard.edu
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=g.harvard.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rowland.harvard.edu header.i=@rowland.harvard.edu header.b="WVtxVHzg"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-92ed3993c1eso151255085a.1
        for <linux-scsi@vger.kernel.org>; Mon, 27 Jul 2026 07:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rowland.harvard.edu; s=google; t=1785161469; x=1785766269; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2TbMgEYjEWwwfW5EaSXEZIaucNreF4PLtIU/CMB3YiM=;
        b=WVtxVHzgs8PIwDMeVrnII4dHGxfRgjJps7jNvCHTgDq4gqtSsqINVsZ0sLuyoZ64yr
         2f/EsWrnfvnQ9/kMOauFLI1QGPNtCWgerSrrpr5bhJVk+KqBnXNdbPJAmnElcf9xLevf
         M4FBw1BngDYbyLMkpESYj+T1ej98WSqHrLqiaXbMcja5Kz7XDcYc0BnLvKdbaog/FN++
         vqwxkA1RieVgQEl2eIrgWo6innSAkhOLApvHcaXl7l2fA+p+8zrPkBp0tlTLd9a57fPu
         2AjTdzqosAZBHXyWk6NIY/VE9cW0mEhyDPCYAmq4CX7obikfijy8s2sK2wIQk/G6AMAV
         AfdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785161469; x=1785766269;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2TbMgEYjEWwwfW5EaSXEZIaucNreF4PLtIU/CMB3YiM=;
        b=sc5PNf1EVoVPcU6XPHXxDLi5iUV4aeVDWEfTCQZccAIIyBjUA+S2BV6GYrq9AJRMoe
         O5Uw5p3X/CTNfiiVwfcJ978EjWI4YqekivT5eL3XEmkeqh10ZCbaaTSeq/hoYfnBOD0/
         oNKRR2KLdHctpYAz/ny004h5dF8GbAHYTTqLCbQN0bUsONpZ9qMSHdDoZF2GxxE4uZ9J
         swQalUEmbFVXzxLshxrv6xJVu9S8yY0MNlv1nl4yZUcHnPJSiykqUMBkRcLpNjHjmX1E
         BnvlR3F/UjCzx9IfvIlJKlzoTXbOFAJWx4bwjCXrYDK2byu79iXRWtY8xtADjSDRQmrs
         5+1g==
X-Forwarded-Encrypted: i=1; AHgh+Rpn9T0lRRooBaifT/n8LMu0HUTZtf1pmvor19KCVoihULWOsu9xatVgYiex8a1RE1IIfXY4NV1b3X+K@vger.kernel.org
X-Gm-Message-State: AOJu0YzB/z/oQLCfSim9tW4LfWEnC1/LIj+z2rTmQS1e7sRbTKC4q727
	4EKYZOUzEAlUpiTC9y30aALjEMJc4LMWhGZng/+4InKWOUaNrhQDqFac72lTs5JzyAuaf2gsPaK
	dwn0TlA==
X-Gm-Gg: AR+sD13NzBjLTCN6+XPNfgwuVPwCn5WBATDfXQah3tNtZq7YZfhtLTvX37g2jBiYnWV
	xdyB9ptgSlVBY+LxoWJMVmy6qeQQZIvTx2b7b3ofhbhORiMo5VNOwLo+UCeen0vThQzTTklsv+a
	XD2GaDxfEyUHtM/LmgJH0DO5gDB9t3FmFIXrg7X8tEsI146TYrY8rNQa2CsIRPhVgwgCDrbB5/A
	3TFGVJVht3XpHS+O1reWoHulQQ4qmawOPBYDvak4022UZGKo2epaYqY0zehXQ0Q8fC0nkm5xKy7
	dt1v/sGGkPhM+ybB1lZCuh+SPDCXXKdVwep/pXOEueOLapexei1nMt2/51xYn5Fg5vT8unLjKS6
	3zXUnRohbj/c0y5HHpUPyOS63dzbKiMGVyHOxIgAzlfNluLvPVX11h0ceN2AxplCMpTHDcbjJgW
	xYn8pWzv+dXP5cgJ/211S8
X-Received: by 2002:a05:620a:8904:b0:92e:f3ca:2ec8 with SMTP id af79cd13be357-932df62802emr822585385a.19.1785161468774;
        Mon, 27 Jul 2026 07:11:08 -0700 (PDT)
Received: from rowland.harvard.edu ([140.247.181.15])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-932de635f7asm625306885a.29.2026.07.27.07.11.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 07:11:08 -0700 (PDT)
Date: Mon, 27 Jul 2026 10:11:05 -0400
From: Alan Stern <stern@rowland.harvard.edu>
To: Hongjie Fang <hongjiefang@asrmicro.com>
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
	jgarzik@redhat.com, bvanassche@acm.org, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: core: pair EH runtime PM get and put
Message-ID: <a432da46-7b3e-46a8-8c6d-1269d51b44b8@rowland.harvard.edu>
References: <20260727055615.2287217-1-hongjiefang@asrmicro.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727055615.2287217-1-hongjiefang@asrmicro.com>

On Mon, Jul 27, 2026 at 01:56:15PM +0800, Hongjie Fang wrote:
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
> Fix this by snapshotting shost->eh_noresume once per EH iteration and
> using that snapshot for both runtime PM get and put decisions.
> 
> Fixes: ae0751ffc77e ("[SCSI] add flag to skip the runtime PM calls on the host")
> Signed-off-by: Hongjie Fang <hongjiefang@asrmicro.com>
> ---
>  drivers/scsi/scsi_error.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 147127fb4db9..a216f56044d9 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -2342,6 +2342,7 @@ static void scsi_unjam_host(struct Scsi_Host *shost)
>  int scsi_error_handler(void *data)
>  {
>  	struct Scsi_Host *shost = data;
> +	bool eh_noresume;
>  
>  	/*
>  	 * We use TASK_INTERRUPTIBLE so that the thread is not
> @@ -2383,7 +2384,8 @@ int scsi_error_handler(void *data)
>  		 * what we need to do to get it up and online again (if we can).
>  		 * If we fail, we end up taking the thing offline.
>  		 */
> -		if (!shost->eh_noresume && scsi_autopm_get_host(shost) != 0) {
> +		eh_noresume = shost->eh_noresume;

You should be aware that simply reading a variable does not snapshot its 
value unless the read is protected by a lock or something else.  In this 
case, the compiler is allowed to eliminate the eh_noresume variable and 
use shost->eh_noresume instead, both here and below, under the 
assumption that shost->eh_noresume doesn't change in the meantime.

To truly snapshot the the value in a way that's immune to changes from 
other threads, you have to use READ_ONCE():

		eh_noresume = READ_ONCE(shost->eh_noresume);

The compiler is then not allowed to assume that shost->eh_noresume 
remains unchanged later on.  This is all explained (along with a _lot_ 
of other material -- search for "READ_ONCE") in 
Documentation/memory-barriers.txt.

Alan Stern

> +		if (!eh_noresume && scsi_autopm_get_host(shost) != 0) {
>  			SCSI_LOG_ERROR_RECOVERY(1,
>  				shost_printk(KERN_ERR, shost,
>  					     "scsi_eh_%d: unable to autoresume\n",
> @@ -2407,7 +2409,7 @@ int scsi_error_handler(void *data)
>  		 * which are still online.
>  		 */
>  		scsi_restart_operations(shost);
> -		if (!shost->eh_noresume)
> +		if (!eh_noresume)
>  			scsi_autopm_put_host(shost);
>  	}
>  	__set_current_state(TASK_RUNNING);
> -- 
> 2.25.1
> 
