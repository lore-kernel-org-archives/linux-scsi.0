From: Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH] xen-scsiback: correct return value checks on
 xenbus_scanf()
Date: Thu, 7 Jul 2016 14:34:46 +0200
Message-ID: <577E4C66.6010800@suse.com>
References: <577E286802000078000FBECF@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58133 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbcGGMew (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Jul 2016 08:34:52 -0400
In-Reply-To: <577E286802000078000FBECF@suse.com>
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
>  drivers/xen/xen-scsiback.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- 4.7-rc6-xenbus_scanf.orig/drivers/xen/xen-scsiback.c
> +++ 4.7-rc6-xenbus_scanf/drivers/xen/xen-scsiback.c
> @@ -1071,7 +1071,7 @@ static void scsiback_do_1lun_hotplug(str
>  	/* read status */
>  	snprintf(state, sizeof(state), "vscsi-devs/%s/state", ent);
>  	err = xenbus_scanf(XBT_NIL, dev->nodename, state, "%u", &device_state);
> -	if (XENBUS_EXIST_ERR(err))
> +	if (err <= 0)
>  		return;
>  
>  	/* physical SCSI device */
> @@ -1089,7 +1089,7 @@ static void scsiback_do_1lun_hotplug(str
>  	snprintf(str, sizeof(str), "vscsi-devs/%s/v-dev", ent);
>  	err = xenbus_scanf(XBT_NIL, dev->nodename, str, "%u:%u:%u:%u",
>  			   &vir.hst, &vir.chn, &vir.tgt, &vir.lun);
> -	if (XENBUS_EXIST_ERR(err)) {
> +	if (err != 4) {
>  		xenbus_printf(XBT_NIL, dev->nodename, state,
>  			      "%d", XenbusStateClosed);
>  		return;
> 
> 

