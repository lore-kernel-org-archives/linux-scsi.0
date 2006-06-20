From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] scsi_transport_sas: introduce a sas_port entity
Date: Tue, 20 Jun 2006 16:09:14 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D7019A108@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:24014 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751244AbWFTWJR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jun 2006 18:09:17 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Tuesday, June 20, 2006 3:44 PM, James Bottomley wrote:  

> Oh, this one's actually quite simple: the phys aren't being 
> deleted from
> the expander.  Try this fix:
> 
> James
> 
> diff --git a/drivers/scsi/scsi_transport_sas.c 
> b/drivers/scsi/scsi_transport_sas.c
> index 2a5899d..e79d6d3 100644
> --- a/drivers/scsi/scsi_transport_sas.c
> +++ b/drivers/scsi/scsi_transport_sas.c
> @@ -1176,7 +1176,7 @@ sas_rphy_delete(struct sas_rphy *rphy)
>  		break;
>  	case SAS_EDGE_EXPANDER_DEVICE:
>  	case SAS_FANOUT_EXPANDER_DEVICE:
> -		device_for_each_child(dev, NULL, do_sas_phy_delete);
> +		sas_remove_children(dev);
>  		break;
>  	default:
>  		break;


Yes, that solves that issue.

Thanks,
Eric
