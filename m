From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] scsi_transport_sas: remove local_attached flag
Date: Mon, 28 Aug 2006 07:19:49 -0700 (PDT)
Message-ID: <20060828141949.99418.qmail@web31815.mail.mud.yahoo.com>
References: <1156531698.3462.11.camel@mulgrave.il.steeleye.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31815.mail.mud.yahoo.com ([68.142.206.168]:42882 "HELO
	web31815.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1750936AbWH1OTu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Aug 2006 10:19:50 -0400
In-Reply-To: <1156531698.3462.11.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: "Moore, Eric" <Eric.Moore@lsil.com>

--- James Bottomley <James.Bottomley@SteelEye.com> wrote:

> This flag denotes local attachment of the phy.  There are two problems
> with it:
> 
> 1) It's actually redundant ... you can get the same information simply
> by seeing whether a host is the phys parent
> 2) we condition a lot of phy parameters on it on the false assumption
> that we can only control local phys.  I'm wiring up phy resets in the
> aic94xx now, and it will be able to reset non-local phys as well.

Of course, the actual SAS Stack, doesn't have this "local_attached".

> 
> I fixed 2) by moving the local check into the reset and stats function
> of the mptsas, since that seems to be the only HBA that can't
> (currently) control non-local phys.
> 
> James
> 
> Index: BUILD-2.6/drivers/scsi/scsi_transport_sas.c
> ===================================================================
> --- BUILD-2.6.orig/drivers/scsi/scsi_transport_sas.c	2006-08-25 13:22:46.000000000 -0500
> +++ BUILD-2.6/drivers/scsi/scsi_transport_sas.c	2006-08-25 13:29:40.000000000 -0500
> @@ -266,9 +266,6 @@
>  	struct sas_internal *i = to_sas_internal(shost->transportt);	\
>  	int error;							\
>  									\
> -	if (!phy->local_attached)					\
> -		return -EINVAL;						\
> -									\
>  	error = i->f->get_linkerrors ? i->f->get_linkerrors(phy) : 0;	\
>  	if (error)							\
>  		return error;						\
> @@ -299,9 +296,6 @@
>  	struct sas_internal *i = to_sas_internal(shost->transportt);
>  	int error;
>  
> -	if (!phy->local_attached)
> -		return -EINVAL;
> -
>  	error = i->f->phy_reset(phy, hard_reset);
>  	if (error)
>  		return error;
> @@ -849,7 +843,7 @@
>  	 * Only devices behind an expander are supported, because the
>  	 * enclosure identifier is a SMP feature.
>  	 */
> -	if (phy->local_attached)
> +	if (scsi_is_sas_phy_local(phy))
>  		return -EINVAL;
>  
>  	error = i->f->get_enclosure_identifier(rphy, &identifier);
> @@ -870,7 +864,7 @@
>  	struct sas_internal *i = to_sas_internal(shost->transportt);
>  	int val;
>  
> -	if (phy->local_attached)
> +	if (scsi_is_sas_phy_local(phy))
>  		return -EINVAL;
>  
>  	val = i->f->get_bay_identifier(rphy);
> Index: BUILD-2.6/include/scsi/scsi_transport_sas.h
> ===================================================================
> --- BUILD-2.6.orig/include/scsi/scsi_transport_sas.h	2006-08-25 13:23:08.000000000 -0500
> +++ BUILD-2.6/include/scsi/scsi_transport_sas.h	2006-08-25 13:29:59.000000000 -0500
> @@ -57,9 +57,6 @@
>  	enum sas_linkrate	maximum_linkrate_hw;
>  	enum sas_linkrate	maximum_linkrate;
>  
> -	/* internal state */
> -	unsigned int		local_attached : 1;
> -
>  	/* link error statistics */
>  	u32			invalid_dword_count;
>  	u32			running_disparity_error_count;
> @@ -196,4 +193,6 @@
>  		rphy->identify.device_type == SAS_EDGE_EXPANDER_DEVICE;
>  }
>  
> +#define scsi_is_sas_phy_local(phy)	scsi_is_host_device((phy)->dev.parent)
> +
>  #endif /* SCSI_TRANSPORT_SAS_H */
> Index: BUILD-2.6/drivers/message/fusion/mptsas.c
> ===================================================================
> --- BUILD-2.6.orig/drivers/message/fusion/mptsas.c	2006-08-25 13:30:28.000000000 -0500
> +++ BUILD-2.6/drivers/message/fusion/mptsas.c	2006-08-25 13:35:50.000000000 -0500
> @@ -852,6 +852,10 @@
>  	dma_addr_t dma_handle;
>  	int error;
>  
> +	/* FIXME: only have link errors on local phys */
> +	if (!scsi_is_sas_phy_local(phy))
> +		return -EINVAL;
> +
>  	hdr.PageVersion = MPI_SASPHY1_PAGEVERSION;
>  	hdr.ExtPageLength = 0;
>  	hdr.PageNumber = 1 /* page number 1*/;
> @@ -924,6 +928,10 @@
>  	unsigned long timeleft;
>  	int error = -ERESTARTSYS;
>  
> +	/* FIXME: fusion doesn't allow non-local phy reset */
> +	if (!scsi_is_sas_phy_local(phy))
> +		return -EINVAL;
> +
>  	/* not implemented for expanders */
>  	if (phy->identify.target_port_protocols & SAS_PROTOCOL_SMP)
>  		return -ENXIO;
> @@ -1570,9 +1578,6 @@
>  
>  	if (!phy_info->phy) {
>  
> -		if (local)
> -			phy->local_attached = 1;
> -
>  		error = sas_phy_add(phy);
>  		if (error) {
>  			sas_phy_free(phy);
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


