Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84BFB372B39;
	Thu, 23 Apr 2026 23:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776988555; cv=none; b=RtxdCQmSvHsdyEtko4OaJkKkAb8irKXnJJegSSnhFlPqfVNtC0ikwfW88aNRePGbGg98Zr4Q/LeMqm50RCIEdWtrMzKn7RXnOUYiWi1MciD3uBprT+mpTURsSlYscm7c+xcQYruFQ/PK3L7YVgcRIRJPyzZC2hCAVOzgFhbQI4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776988555; c=relaxed/simple;
	bh=XdmrAKfpGfNntmLzeZw5dHPWWxSqnTeKXV86t7/Dw1E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DC7d2zprzqW9RA5I99KRzeNH8RadMm77o4UTAflk394N7enlsT/dyxMvr+LSXg1jdOPikvsmIHJTQQVbJbZgcscHExb7fhHe1kEBNbRQAcUb5U08f6gSpfmVYRRzl+P8XRrlGSQ5AVVjTp+gYPVrjoIcKTmk2kIJLX9eSI0Nxto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=xr88QLT9; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="xr88QLT9"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4g1tJp00N2z1XM0p8;
	Thu, 23 Apr 2026 23:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1776988550; x=1779580551; bh=1F6NVt6eYpQRp0CXCpbb0Beo
	MjPvDIgNqQa60cpYT94=; b=xr88QLT90njORJusHv+4ioPbIQAc3niuMLuggRg7
	N/PFsaS355o++39yxp25sGPZD+trP9xXNNQKX78e8PKSuzpNBhqQgWDr+nh1Ui62
	sxhhzUxtBhCzHgb1uOek8AksOzR6jSMiXwvpyoevZdoccVOMIJQDP1m6cKMjnoWB
	WTlWFInwu2nVx6WhizXtYg4tOP2RiF1LZ8GSmAsOrBVEyY6k+wjPo48L1dJ/f1F/
	+oxtjp6PIkyYCv7pO5g00brA7OWdlIwILFhmJ2lWb5SY7rDfg1bmO3uFTak87RaN
	5Qv8vzc1OGEkBQwGsE5e8SE5bvBMuTYpgLrUW8CQDfDv0A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Q9kHaZkEJfPH; Thu, 23 Apr 2026 23:55:50 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4g1tJj0DRCz1XM0nq;
	Thu, 23 Apr 2026 23:55:48 +0000 (UTC)
Message-ID: <2334cec9-c80f-4fe5-a2e9-e35d4dfddbba@acm.org>
Date: Thu, 23 Apr 2026 16:55:47 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: sd: Use string_choices to fix Coccinelle warnings
To: Nick Spooner <nicholas.spooner@seagate.com>,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260423211644.3481898-1-nicholas.spooner@seagate.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260423211644.3481898-1-nicholas.spooner@seagate.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/23/26 2:16 PM, Nick Spooner wrote:
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index adc3fa55ca2c..dd284647ed64 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -50,6 +50,7 @@
>   #include <linux/rw_hint.h>
>   #include <linux/major.h>
>   #include <linux/mutex.h>
> +#include <linux/string_choices.h>
>   #include <linux/string_helpers.h>
>   #include <linux/slab.h>
>   #include <linux/sed-opal.h>
> @@ -3084,7 +3085,7 @@ sd_read_write_protect_flag(struct scsi_disk *sdkp, unsigned char *buffer)
>   		set_disk_ro(sdkp->disk, sdkp->write_prot);
>   		if (sdkp->first_scan || old_wp != sdkp->write_prot) {
>   			sd_printk(KERN_NOTICE, sdkp, "Write Protect is %s\n",
> -				  sdkp->write_prot ? "on" : "off");
> +				  str_on_off(sdkp->write_prot));
>   			sd_printk(KERN_DEBUG, sdkp, "Mode Sense: %4ph\n", buffer);
>   		}
>   	}
> @@ -3235,8 +3236,8 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
>   		    old_rcd != sdkp->RCD || old_dpofua != sdkp->DPOFUA)
>   			sd_printk(KERN_NOTICE, sdkp,
>   				  "Write cache: %s, read cache: %s, %s\n",
> -				  sdkp->WCE ? "enabled" : "disabled",
> -				  sdkp->RCD ? "disabled" : "enabled",
> +				  str_enabled_disabled(sdkp->WCE),
> +				  str_disabled_enabled(sdkp->RCD),
>   				  sdkp->DPOFUA ? "supports DPO and FUA"
>   				  : "doesn't support DPO or FUA");

My opinion is that the sd code is easier to read *without* this patch. 
But that's just my opinion. Maybe there are other opinions.

Bart.


