From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: scsi scan bug when peripheral qualifier of 3 is returned
Date: Thu, 05 Jan 2006 10:56:52 -0600
Message-ID: <43BD4FD4.8020806@cs.wisc.edu>
References: <43BB750A.5050000@cs.wisc.edu> <20060104174019.GA3995@us.ibm.com> <43BC13B3.9030604@cs.wisc.edu> <20060104190119.GA4700@us.ibm.com> <43BC30A2.3090403@cs.wisc.edu> <20060104222522.GA5741@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:6538 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751841AbWAEQ47 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jan 2006 11:56:59 -0500
In-Reply-To: <20060104222522.GA5741@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Patrick Mansfield wrote:
> Then like this?

Yep, this works for our setup. Thanks.

> 
> --- linux-2.6.15/drivers/scsi/orig-scsi_scan.c	2006-01-02 21:52:12.000000000 -0800
> +++ linux-2.6.15/drivers/scsi/scsi_scan.c	2006-01-04 13:03:27.000000000 -0800
> @@ -868,6 +868,8 @@ static int scsi_probe_and_add_lun(struct
>  
>  	if (scsi_probe_lun(sdev, result, result_len, &bflags))
>  		goto out_free_result;
> +	if (bflagsp)
> +		*bflagsp = bflags;
>  
>  	/*
>  	 * result contains valid SCSI INQUIRY data.
> @@ -896,8 +898,6 @@ static int scsi_probe_and_add_lun(struct
>  			sdev->lockable = 0;
>  			scsi_unlock_floptical(sdev, result);
>  		}
> -		if (bflagsp)
> -			*bflagsp = bflags;
>  	}
>  
>   out_free_result:
> 

.....

> 
> Don't forget you can dynamically add devinfo values via modparam and
> /proc/scsi.
> 

I did not know this. I was looking for a writable proc file for some 
reason. Thanks.
