From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] iscsi_tcp: make iscsi compile again after recent netlink
 changes
Date: Thu, 08 Sep 2005 14:17:27 -0500
Message-ID: <43208E47.9010603@cs.wisc.edu>
References: <1126192451.4845.10.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:23209 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S964936AbVIHTRe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Sep 2005 15:17:34 -0400
In-Reply-To: <1126192451.4845.10.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Alex Aizman <itn780@yahoo.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> netlink_kernel_create now has two new arguments; the module (which is
> easy) and the number of groups, which I arbitrarily set to one.
> 

Thanks. Are you going to apply this to scsi-misc? We are building a 
patchset for fixes to send this weekend hopefully so we can take the 
patch and incorporate it or patch over the updated scsi-misc.


> James
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -1230,7 +1230,8 @@ static __init int iscsi_transport_init(v
>  	if (err)
>  		goto unregister_session_class;
>  
> -	nls = netlink_kernel_create(NETLINK_ISCSI, iscsi_if_rx);
> +	nls = netlink_kernel_create(NETLINK_ISCSI, 1, iscsi_if_rx,
> +				    THIS_MODULE);
>  	if (!nls) {
>  		err = -ENOBUFS;
>  		goto unregister_notifier;
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

