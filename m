Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57044258CD7
	for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2026 05:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776405392; cv=none; b=WG9TYpnObXGQ9tv42Gf966WmTouGNkUN2GgK/P37ui0XCTqxDnfmt7gxnsnCFEvR9oSA96GCYkSWEWfgjgsHkIngTU/WMCNZr4urmCYksPE5JBZRnVNKGgt4oOnI4n8ffMfiPVoB0KeQf433Cm6LsWCSWhOmfEuU4l3/IOPmipw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776405392; c=relaxed/simple;
	bh=n1WhHEo42t+lWUW/csAqxQ/xX1NCS+1cWRNXzxDUJfQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=On5LkowEJm70ZpXv6IuwLPuog7Q5Fg4IGKGxVWfUJHxMIc+2lSgA640hZkXe4Jv+RxqwEbX8aee6oUIglUncO/7F8nDouEYDb40qHN2XYUr+MA4i1zGe06My/XhXi54wdskEJW+XExKDTcHx9K50FtXYVGX27r4HgAjlHK3NziM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gf7gl+Yn; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gf7gl+Yn"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-488e1a8ac40so3554145e9.2
        for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2026 22:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776405390; x=1777010190; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rCNwB0p4fo3KBgBAhuhSg3ltFf7brNQ1Ddfg4S9ESs8=;
        b=gf7gl+YncMi6XM38kAb4wEw2EKb2riIU3pVoRbSgPoTePm1hWHqVyn6OAPI+7eMmt/
         Ia/mte40JfPzDeLlBuavH3UbBqzhQs5euSCJsu0tyT43cnE0Q8Z9lkdaKIm1zLPDGUi4
         F3XZ3jioebSj+138mTbU2fCc4zogIC3QwJ5mCSfYNZo21Tk69320xQzaGsTTFw9L26dw
         VabFajaRCUqXorhDYMopTW+4r3OyucIpr9hCqoMBwkb8GZ4vrrpJYr5CSn28cFbyL4r+
         ts7yagBOxPNwqgOWfM+UByHVYZn/0JY/EyDuJIFjdiwHhQQGAHoIIyWeVTY7c5rL7r0R
         COog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776405390; x=1777010190;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rCNwB0p4fo3KBgBAhuhSg3ltFf7brNQ1Ddfg4S9ESs8=;
        b=V625iG8+QJNP0l5ZBSdYD4Drw7jBo8yGdYogvQGRPW+ZuaJsDbgbNjxSAwFASVwrY6
         wR1+OC9ISyaVfw0lIQylzuGewUqb7LPCcINQHyTbiguwlcgkevkTBN06cxSdbD5/rhz+
         E0IbPcq48r4p6KwCPuEZljewz16XR2m3ckF4TF6j0AXbNwOr0IQt9J8lO/NHtT2pJ+t/
         Z0jVvmxBhQc9Wdg1oU1XVbI2GlLhKhXPxl50Uk7sFXIxeC4+vLE9oRL3HimW8EFKEIyb
         PyaQZ9vf6tsXhp1Uw//kZJhRfSCIp87OdjqtZ29sGYN/j3DtZ+LB1W8nVHdF5+X4aEB1
         /Tcw==
X-Forwarded-Encrypted: i=1; AFNElJ+on0VJA2I9vRhCM4X7dN/NA5uIevNLLjBY5c6v0b3jbcEhMWbFwbUsBFUDRhnt0wUyCjHedsnrptzL@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4ZMxdz6aZ15yLGlTvGs3l0Pf7VZ15FVA3VInz4Ok2cgT2NVif
	tOn6vjM3wC5ydyg7jqomt+7SfefzWDZqpY4cyvUaAtKojDLLmIyCgdLBhcC6baYSOm0=
X-Gm-Gg: AeBDiesiIOqS3HV1CdmZyC8FzgDqFL0HO0KM0GtxaU382FiENmdBivF4J7Tt40meHEi
	MqLvOPBTRNc56OBNTiXQrvPMcZDokpJnzq18mZpdixIC3a6ZTEcjZ9JVnUTt4W+ifkDoWGdgkxQ
	432+iqQncVsKQBgSIShgN3DugQvTIDWPr4FkbOn3PwFEUBdJJcbWwBDFScsyU8CjDpCzQ5d3umE
	1ddJiw/Osp7XLpyh8sopQdfmKJPOwqwhom55iRWfHpuhrafgv4vM2vYjBE4HYyaByrRGw/pDC1l
	jLVyYjhVUwSvZKX2fAjnsB+fHSogQENZyOQ50joWUOC6zgNOMszDV8sgFaRdki4LTya7L5Px3UE
	Pxkkzbyni5IZzzL2w/0hBM00cb3WItMnm4LaB1zlyvRp25X50ifwCJLCWFXVw2Z9waXXGRrLJwk
	W/oacB60hmA0NgUsFQtgQAFOpUCTAxDWIfNk68IRbFAqhzf0bBrzmShPGb+FB+7lvqEa62
X-Received: by 2002:a05:6000:1889:b0:43d:7b7b:ab76 with SMTP id ffacd0b85a97d-43fe3dc54ddmr1953516f8f.10.1776405389723;
        Thu, 16 Apr 2026 22:56:29 -0700 (PDT)
Received: from ?IPV6:2001:a61:2ae4:301:12fa:de76:8d51:fc21? ([2001:a61:2ae4:301:12fa:de76:8d51:fc21])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4e3a174sm1936117f8f.18.2026.04.16.22.56.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2026 22:56:29 -0700 (PDT)
Message-ID: <b1a6b96d-07d2-4a19-b9db-2cd8d878895c@suse.com>
Date: Fri, 17 Apr 2026 07:56:28 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] [SCSI] advansys: fix host resource leak in EISA probe
 error path
To: Guangshuo Li <lgs201920130244@gmail.com>,
 Matthew Wilcox <willy@infradead.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
References: <20260416165935.3958686-1-lgs201920130244@gmail.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260416165935.3958686-1-lgs201920130244@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/16/26 18:59, Guangshuo Li wrote:
> A manual code audit found that advansys_eisa_probe() frees saved
> Scsi_Host objects directly in its error path.
> 
> Those hosts have already been successfully initialized by
> advansys_board_found(), so freeing them directly bypasses the normal
> teardown path and leaks host resources such as IRQs, DMA or MMIO
> resources, and the Scsi_Host release path.
> 
> Fix this by releasing the saved hosts with advansys_release() and
> dropping their corresponding I/O regions before freeing the probe data.
> 
> Fixes: d361db483241 ("[SCSI] advansys: Sort out irq number mess")
> Cc: stable@vger.kernel.org
> Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
> ---
>   drivers/scsi/advansys.c | 14 +++++++++++---
>   1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
> index fcf059bf41e8..022a8190ae31 100644
> --- a/drivers/scsi/advansys.c
> +++ b/drivers/scsi/advansys.c
> @@ -11373,9 +11373,17 @@ static int advansys_eisa_probe(struct device *dev)
>   	return 0;
>   
>    free_data:
> -	kfree(data->host[0]);
> -	kfree(data->host[1]);
> -	kfree(data);
> +	for (i = 0; i < 2; i++) {
> +		struct Scsi_Host *shost = data->host[i];
> +		int ioport;
> +
> +		if (!shost)
> +			continue;
> +
> +		ioport = shost->io_port;
> +		advansys_release(shost);
> +		release_region(ioport, ASC_IOADR_GAP);
> +	}
>    fail:
>   	return err;
>   }

You must be kidding ... EISA is died over a decade ago.

If you _really_ are concerned about this please remove EISA support 
completely from the driver.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
