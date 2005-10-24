From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH RFC 7/n] HCIL drivers update
Date: Mon, 24 Oct 2005 08:43:14 +0200
Message-ID: <435C8282.4030801@s5r6.in-berlin.de>
References: <20051023024104.GA20128@havoc.gtf.org> <20051023195128.GA12102@havoc.gtf.org> <20051024034922.GA28581@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:61592 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1751028AbVJXGnn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Oct 2005 02:43:43 -0400
In-Reply-To: <20051024034922.GA28581@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> More sdev->{command,id,lun} work.  DO NOT APPLY.
...
> diff --git a/drivers/ieee1394/sbp2.c b/drivers/ieee1394/sbp2.c
> index 12cec7c..87d381d 100644
> --- a/drivers/ieee1394/sbp2.c
> +++ b/drivers/ieee1394/sbp2.c
> @@ -2513,7 +2513,7 @@ static int sbp2scsi_queuecommand(struct 
>  	 * Until we handle multiple luns, just return selection time-out
>  	 * to any IO directed at non-zero LUNs
>  	 */
> -	if (SCpnt->device->lun)
> +	if (!scsilun_zero(&SCpnt->device->lun))
>  		goto done;
>  
>  	/*

and

@@ somewhere @@ static int sbp2_start_device(
- error = scsi_add_device(scsi_id->scsi_host, 0, scsi_id->ud->id, 0);
+ const struct scsi_lun slun = {{0,0,0,0,0,0,0,0}};
+ error = scsi_add_device(scsi_id->scsi_host, 0, scsi_id->ud->id, &slun);

or something like that. I wonder whether something else than scsi_add_device()
should be used though.

Once better multi LU support is implemented in sbp2, the 2-byte SBP-2 LUN
can be converted into a SAM LUN.
-- 
Stefan Richter
-=====-=-=-= =-=- ==---
http://arcgraph.de/sr/
