From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH 1/4] sas: add flag for locally attached PHYs
Date: Wed, 19 Oct 2005 15:24:13 -0400
Message-ID: <43569D5D.1000801@adaptec.com>
References: <20051019180117.GB21488@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:61102 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1751240AbVJSTY2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Oct 2005 15:24:28 -0400
In-Reply-To: <20051019180117.GB21488@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, Eric.Moore@lsil.com, linux-scsi@vger.kernel.org

On 10/19/05 14:01, Christoph Hellwig wrote:
> Add a flag to mark a PHY as attached to the HBA as opposed to beeing on
> an expander.  This is needed because various features are only supported
> on those.  This is a crude hack, the proper fix would be to use
> different classes for host-attached vs expander phys.  I'm looking into
> that.

The phy isn't quite "attached" -- i.e. at software level you do not
care about that.  At least I've never heard anyone (not of "the community")
say that a phy is "attached".

You don't need to represent that.  While you can, you completely do not
need to do it.  All you should care about is the _port_.  Take a look
at SAS section 4.

Also take a look at:
drivers/scsi/sas/sas_phy.c,
drivers/scsi/sas/sas_port.c and
drivers/scsi/sas/sas_discover.c .

Storage GUI applications can read the expander configuration using SMP
and show this as I've shown in Announcement 1 here:
http://marc.theaimsgroup.com/?l=linux-scsi&m=112629509826900&w=2

All you should care about is the _local_ phys since those are
under your control, and the port formed.

	Luben


> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6/drivers/message/fusion/mptsas.c
> ===================================================================
> --- linux-2.6.orig/drivers/message/fusion/mptsas.c	2005-10-19 15:30:29.000000000 +0200
> +++ linux-2.6/drivers/message/fusion/mptsas.c	2005-10-19 19:49:35.000000000 +0200
> @@ -760,7 +760,7 @@
>  }
>  
>  static int mptsas_probe_one_phy(struct device *dev,
> -		struct mptsas_phyinfo *phy_info, int index)
> +		struct mptsas_phyinfo *phy_info, int index, int local)
>  {
>  	struct sas_phy *port;
>  	int error;
> @@ -853,6 +853,9 @@
>  		break;
>  	}
>  
> +	if (local)
> +		port->local_attached = 1;
> +
>  	error = sas_phy_add(port);
>  	if (error) {
>  		sas_phy_free(port);
> @@ -918,7 +921,7 @@
>  		}
>  
>  		mptsas_probe_one_phy(&ioc->sh->shost_gendev,
> -				     &port_info->phy_info[i], *index);
> +				     &port_info->phy_info[i], *index, 1);
>  		(*index)++;
>  	}
>  
> @@ -989,7 +992,8 @@
>  			}
>  		}
>  
> -		mptsas_probe_one_phy(parent, &port_info->phy_info[i], *index);
> +		mptsas_probe_one_phy(parent, &port_info->phy_info[i],
> +				     *index, 0);
>  		(*index)++;
>  	}
>  
> Index: linux-2.6/include/scsi/scsi_transport_sas.h
> ===================================================================
> --- linux-2.6.orig/include/scsi/scsi_transport_sas.h	2005-10-19 15:30:29.000000000 +0200
> +++ linux-2.6/include/scsi/scsi_transport_sas.h	2005-10-19 19:49:35.000000000 +0200
> @@ -56,6 +56,9 @@
>  	enum sas_linkrate	maximum_linkrate;
>  	u8			port_identifier;
>  
> +	/* internal state */
> +	unsigned int		local_attached : 1;
> +
>  	/* link error statistics */
>  	u32			invalid_dword_count;
>  	u32			running_disparity_error_count;
> Index: linux-2.6/drivers/scsi/scsi_transport_sas.c
> ===================================================================
> --- linux-2.6.orig/drivers/scsi/scsi_transport_sas.c	2005-10-19 19:49:35.000000000 +0200
> +++ linux-2.6/drivers/scsi/scsi_transport_sas.c	2005-10-19 19:50:55.000000000 +0200
> @@ -266,6 +266,9 @@
>  	struct sas_internal *i = to_sas_internal(shost->transportt);	\
>  	int error;							\
>  									\
> +	if (!phy->local_attached)					\
> +		return -EINVAL;						\
> +									\
>  	error = i->f->get_linkerrors(phy);				\
>  	if (error)							\
>  		return error;						\
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
http://linux.adaptec.com/sas/
http://www.adaptec.com/sas/
