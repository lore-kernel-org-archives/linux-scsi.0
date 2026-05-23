Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF8A2EC54C
	for <linux-scsi@vger.kernel.org>; Sat, 23 May 2026 14:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779547356; cv=none; b=i4TrHurnNnHY83yEP+dZjKsQoxFV1SZLlryaEp5hIPjKnJ5CX13vfuedPzj5o4geBNdu76h9P6BZexBOevSvKnrDp26knbFgQ6s7X3uCR31/LMsOOVj1h68T3h0wY3QtDgxbsEVciahpvZIQkp/ZL4F8jJK0qrjHlP2vxgde4vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779547356; c=relaxed/simple;
	bh=A844K3vVWkLYrK36su93HM6gBVK4k6ESb8ewM5a9hKM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jh2rDqfhlrjcxxiqAE8BEDl7uf81x3cCLYUX3EN8Vk4uq1aEPAU7qzLIhg/d1xW5uRFRe5/ka/jiWROXCTroFaoqUmqhqsjfFqpNOS5Grf9DBvOGt6yyKmfluuTVKtwLdo46NAhnEsRwatzAPh9PPKcDGuulX10FyUWJfjJ0Cbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rowland.harvard.edu; spf=fail smtp.mailfrom=g.harvard.edu; dkim=pass (2048-bit key) header.d=rowland.harvard.edu header.i=@rowland.harvard.edu header.b=tFJ5u85X; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rowland.harvard.edu
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=g.harvard.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rowland.harvard.edu header.i=@rowland.harvard.edu header.b="tFJ5u85X"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-516d65a15f6so20341811cf.1
        for <linux-scsi@vger.kernel.org>; Sat, 23 May 2026 07:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rowland.harvard.edu; s=google; t=1779547354; x=1780152154; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wcsS0wyM+mpDDyzESHv6rHjfUqcY7Y8STflNdYbJkGc=;
        b=tFJ5u85XRZv6Wl1XynNx+XXp77Zk7my4vWU4Y+WxWB7CmSyiRlk0G8ZTUaqMH3Xmyx
         SXyvXC4Qrw9BTWwH31ZMBTVeIE+BZ+X5luNynqq1nUo2izaux2qJkqg2sUYp4WfptKRB
         IhSexCbnGGxKIVQD0pgJVTe86hUpFBWUx0E6ZTrd2gLqACwgB1s7wnhH6URFUi//3r9R
         y7uyi9l0GfWE1OCwKPbXlaSaDxo0+pygrQ9pVaNQ1bIEG2Ht7w9cIh9+CmMSxAIXpPX3
         D67FPR+OIqvMtkjU1YPvrO7Vdo0RIhlPDd8wSBtl3eQBQmn/yvVjlbC2XiJvxxvqo/ma
         I9mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779547354; x=1780152154;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wcsS0wyM+mpDDyzESHv6rHjfUqcY7Y8STflNdYbJkGc=;
        b=YwNjx+lNZNM3FP7XxZRtHI0v/OAhxc+hpMaYy/W/UdNfbf+9iIXXknacOICcDkT6AX
         UF1JgfOaDu4XuNaNCDi3cvpHSgbnj9xblfY8osx/FDOs3Q3SpOIXrlkdCzfxp0jP3dB1
         5rJUMS67g2AbwJ/1s10XitSUc7l/HD9hs38M93WA7tVLsh69CM0KB7JIJoYFONRq1Exa
         fniSP+lgWJ/PM55ipt+EXvd0YzizewQp6tvuRztGHHdM+ar1PiWbdbG0tPxlW45vYv4k
         74rrcWSJ791+ur+5xmUCdN34TStU7njvxP6sWpXzrC9BiPSf3YwlgAaQX/NfOjcZiFA+
         ymOQ==
X-Forwarded-Encrypted: i=1; AFNElJ98dkaow0V/d4wWI8U2L/l/FNxKy/wThisYJP3lj7itM1mfLE5IBpEHqGXXgWUX40sorv/T/OZFxVS3@vger.kernel.org
X-Gm-Message-State: AOJu0YwsUYaBIIeVHaZaLiGy33dfHtSjhXhtXbHNMUIlSafbgnmbK737
	AGa8LUAop98arxEkgy/A/J6q+y6nF4Xtfp7NUGaE06d4rwieePGZ4Awkx23x3aQRnA==
X-Gm-Gg: Acq92OGqf7XaD6ugeiZKWnWl709aE3wGpdmE2rf+sWA55nMVRsP56qquiyL1LW+QqxA
	Yt6/zyR+qwSXlm9kbWhu1mo03AM6uh+ndS2gnGrzKpS2LP/ByX8rYOgrIIHKJslkK7sld4L/tdR
	3MQOg6zrCVldGmxU7X6LoPnPe9iMTDZ6AsblO5k6F+f+dR5iNnRsxGfsxVY2YZs0ABsyg0KGGrF
	JEMV0nONyXJh6iPKtrrpwgZz8UZEuB5K0nv0WTQQEpwarcJN9eYzQtBarO7VpFOIF/CWMWdGM6o
	MQN9bs1C0dHLl3C1W7x5+/zk7XFvy03aPltDMvEzbDqNI50Rd5rzXa8ql4NV9l39exw1bZ7t/DZ
	fehBg+HrF0iWXVqTrzL+f6+fJ6t5TUN3IQLaWumTWkSD6d08LvHDHkVAyPmhjp/yBjvNf5RnCUr
	1IwBjPKvwoHey7i4IaeWNd/lpWfzWUN28riC9u/jo2Mgk=
X-Received: by 2002:a05:622a:60f:b0:516:e0e7:6e42 with SMTP id d75a77b69052e-516e0e77392mr40339581cf.13.1779547353574;
        Sat, 23 May 2026 07:42:33 -0700 (PDT)
Received: from rowland.harvard.edu ([2601:19b:d01:d210:d62f:1911:f952:16ba])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cc8130d4desm48561276d6.39.2026.05.23.07.42.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2026 07:42:32 -0700 (PDT)
Date: Sat, 23 May 2026 10:42:22 -0400
From: Alan Stern <stern@rowland.harvard.edu>
To: Hongjie Fang <hongjiefang@asrmicro.com>
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
	jgarzik@redhat.com, ming.m.lin@intel.com,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: core: pair EH runtime PM get/put with eh_noresume
 snapshot
Message-ID: <88f98e04-4ccc-416c-b677-f49a46ec97fb@rowland.harvard.edu>
References: <20260523033438.3547549-1-hongjiefang@asrmicro.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260523033438.3547549-1-hongjiefang@asrmicro.com>

On Sat, May 23, 2026 at 11:34:38AM +0800, Hongjie Fang wrote:
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
> In that case one EH iteration can skip autoresume on entry and still drop a
> runtime PM reference on exit. That leaves an unmatched runtime PM put and
> can trigger a runtime PM usage count underflow.
> 
> Fix this by snapshotting shost->eh_noresume once at the beginning of each
> EH iteration and by calling scsi_autopm_put_host() only if the same
> iteration successfully acquired a runtime PM reference through the
> scsi_autopm_get_host().
> 
> Fixes: ae0751ffc77e ("[SCSI] add flag to skip the runtime PM calls on the host")
> Signed-off-by: Hongjie Fang <hongjiefang@asrmicro.com>
> ---
>  drivers/scsi/scsi_error.c | 21 ++++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 147127fb4db9..d83bfa24f184 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -2342,6 +2342,8 @@ static void scsi_unjam_host(struct Scsi_Host *shost)
>  int scsi_error_handler(void *data)
>  {
>  	struct Scsi_Host *shost = data;
> +	bool autopm_get;
> +	bool skip_autopm;
>  
>  	/*
>  	 * We use TASK_INTERRUPTIBLE so that the thread is not
> @@ -2383,12 +2385,17 @@ int scsi_error_handler(void *data)
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
> +		skip_autopm = shost->eh_noresume;
> +		if (!skip_autopm) {

Since this is the only place you use the skip_autopm variable, you may 
as well not introduce it at all.  Just test shost->eh_noresume directly.

Alan Stern

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
> @@ -2407,7 +2414,7 @@ int scsi_error_handler(void *data)
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
