From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] fc_transport: Write outside array bounds
Date: Tue, 28 Jul 2009 09:28:22 -0400
Message-ID: <4A6EFCF6.4040105@emulex.com>
References: <4A6EF1A3.6040607@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:38060 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbZG1N3E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Jul 2009 09:29:04 -0400
In-Reply-To: <4A6EF1A3.6040607@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roel Kluin <roel.kluin@gmail.com>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>

This shouldn't be the case, and if it is, isn't the right way to handle it.
It may simply be someone forgot to update FC_HOST_NUM_ATTRS. I'll double
check and get back shortly.

-- james s


Roel Kluin wrote:
> If it's possible to turn on all the optional attributes, there are more
> attributes than the length of array i->private_host_attrs[], so the last one
> will be out-of-bounds. (There is a BUG_ON there, but it's after the write,
> rather than before).
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> Found with Parfait, http://research.sun.com/projects/parfait/
> 
> in fc_attach_transport()
> ...
> count=0;
> 14 x SETUP_HOST_ATTRIBUTE_RD()
> if (ft->vport_create)
> 	2 x SETUP_HOST_ATTRIBUTE_RD_NS()
> 1 x SETUP_HOST_ATTRIBUTE_RW()
> 1 - 4 x SETUP_PRIVATE_HOST_ATTRIBUTE_RW()
> 
> all these definitions set private_host_attrs[count] (21 elements)
> and increase the index count thereafter.
> 
> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
> index 292c02f..8092e56 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -2123,8 +2123,12 @@ fc_attach_transport(struct fc_function_template *ft)
>  		SETUP_PRIVATE_HOST_ATTRIBUTE_RW(issue_lip);
>  	if (ft->vport_create)
>  		SETUP_PRIVATE_HOST_ATTRIBUTE_RW(vport_create);
> -	if (ft->vport_delete)
> -		SETUP_PRIVATE_HOST_ATTRIBUTE_RW(vport_delete);
> +	if (ft->vport_delete) {
> +		if(count < FC_HOST_NUM_ATTRS)
> +			SETUP_PRIVATE_HOST_ATTRIBUTE_RW(vport_delete);
> +		else
> +			count++;
> +	}
>  
>  	BUG_ON(count > FC_HOST_NUM_ATTRS);
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
