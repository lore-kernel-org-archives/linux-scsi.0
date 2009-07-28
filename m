From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] scsi_transport_sas: Write outside array bounds
Date: Tue, 28 Jul 2009 16:10:23 -0400
Message-ID: <4A6F5B2F.7020905@garzik.org>
References: <4A6ED0ED.1090707@gmail.com> <1248799145.3855.237.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:41922 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743AbZG1UK0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Jul 2009 16:10:26 -0400
In-Reply-To: <1248799145.3855.237.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Roel Kluin <roel.kluin@gmail.com>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

James Bottomley wrote:
> In this case, as you can see all of the SETUP_X are using count to step
> through an array and when we're finished we add a NULL to the end.  For
> the case of SETUP_PORT_ATTR, the array is i->port_attrs, so the bug here
> is apparently that the NULL is going in the wrong array.  Trying to put
> a NULL at the zero element is manifestly wrong because sas_internal is
> zero allocated.
> 
> Actually, as a final weirdness, we have a duplicate initialisation of
> this anyway, so the correct patch is below.
> 
> James
> 
> ---
> 
> diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
> index 0895d3c..fd47cb1 100644
> --- a/drivers/scsi/scsi_transport_sas.c
> +++ b/drivers/scsi/scsi_transport_sas.c
> @@ -1692,10 +1692,6 @@ sas_attach_transport(struct sas_function_template *ft)
>  	i->f = ft;
>  
>  	count = 0;
> -	SETUP_PORT_ATTRIBUTE(num_phys);
> -	i->host_attrs[count] = NULL;
> -
> -	count = 0;
>  	SETUP_PHY_ATTRIBUTE(initiator_port_protocols);
>  	SETUP_PHY_ATTRIBUTE(target_port_protocols);
>  	SETUP_PHY_ATTRIBUTE(device_type);

er, eh?

It's not a duplicate initialization, as port attributes != phy 
attributes.  Different macro, same counter variable.

Your fix seems quite strange - num_phy attribute goes away?

	Jeff


