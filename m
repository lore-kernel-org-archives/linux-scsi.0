From: Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH] xen-scsifront: correct return value checks on
 xenbus_scanf()
Date: Thu, 7 Jul 2016 14:34:16 +0200
Message-ID: <577E4C48.5080705@suse.com>
References: <577E288D02000078000FBF10@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58077 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbcGGMeT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Jul 2016 08:34:19 -0400
In-Reply-To: <577E288D02000078000FBF10@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Beulich <JBeulich@suse.com>
Cc: xen-devel <xen-devel@lists.xenproject.org>, linux-scsi@vger.kernel.org

On 07/07/16 10:01, Jan Beulich wrote:
> Only a positive return value indicates success.
> 
> Signed-off-by: Jan Beulich <jbeulich@suse.com>

Acked-by: Juergen Gross <jgross@suse.com>

> ---
>  drivers/scsi/xen-scsifront.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- 4.7-rc6-xenbus_scanf.orig/drivers/scsi/xen-scsifront.c
> +++ 4.7-rc6-xenbus_scanf/drivers/scsi/xen-scsifront.c
> @@ -1000,14 +1000,14 @@ static void scsifront_do_lun_hotplug(str
>  		snprintf(str, sizeof(str), "vscsi-devs/%s/state", dir[i]);
>  		err = xenbus_scanf(XBT_NIL, dev->otherend, str, "%u",
>  				   &device_state);
> -		if (XENBUS_EXIST_ERR(err))
> +		if (err <= 0)
>  			continue;
>  
>  		/* virtual SCSI device */
>  		snprintf(str, sizeof(str), "vscsi-devs/%s/v-dev", dir[i]);
>  		err = xenbus_scanf(XBT_NIL, dev->otherend, str,
>  				   "%u:%u:%u:%u", &hst, &chn, &tgt, &lun);
> -		if (XENBUS_EXIST_ERR(err))
> +		if (err != 4)
>  			continue;
>  
>  		/*
> 
> 

