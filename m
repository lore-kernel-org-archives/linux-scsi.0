From: "Zou, Yi" <yi.zou@intel.com>
Subject: RE: scsi/fcoe: Fix preempt count leak in fcoe_filter_frames()
Date: Fri, 11 Nov 2011 12:24:11 -0800
Message-ID: <5A9BD224CEA58D4CB62235967D650C1613EA103B@orsmsx509.amr.corp.intel.com>
References: <alpine.LFD.2.02.1111112049370.2694@ionos>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:21966 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753933Ab1KKUYe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Nov 2011 15:24:34 -0500
In-Reply-To: <alpine.LFD.2.02.1111112049370.2694@ionos>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>, "devel@open-fcoe.org" <devel@open-fcoe.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <JBottomley@parallels.com>

> The error exit path leaks preempt count. Add the missing put_cpu().
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
> index cefbe44..f3f440c 100644
> --- a/drivers/scsi/fcoe/fcoe.c
> +++ b/drivers/scsi/fcoe/fcoe.c
> @@ -1624,6 +1624,7 @@ static inline int fcoe_filter_frames(struct
> fc_lport *lport,
>  	stats->InvalidCRCCount++;
>  	if (stats->InvalidCRCCount < 5)
>  		printk(KERN_WARNING "fcoe: dropping frame with CRC error\n");
> +	put_cpu();
>  	return -EINVAL;
>  }
Thanks,

Reviewed-by: Yi Zou <yi.zou@intel.com>

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
