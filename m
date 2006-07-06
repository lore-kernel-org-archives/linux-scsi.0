From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] mptsas: use unnumbered port API and remove driver porttracking
Date: Thu, 6 Jul 2006 11:10:36 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D701F5CCB@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:5803 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S965200AbWGFRKm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Jul 2006 13:10:42 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Sunday, July 02, 2006 10:13 AM, James Bottomley wrote:  

> This allows us to be rid of the machinery in mptsas for creating and
> tracking port numbers.  Since mptsas is merely inventing the numbers,
> the SAS transport class may as well do it instead.

Thanks for doing this.

Can you remove the displaying of the port_id's from all 
the dsaswideprintk's, except for the one in mptsas_probe_one_phy?
The reasons are embedded below.


> @@ -352,7 +351,7 @@
>  
>  	dsaswideprintk((KERN_DEBUG "%s: [%p]: port=%02d num_phys=%02d "
>  	    	"bitmask=0x%016llX\n",
> -		__FUNCTION__, port_details, port_details->port_id,
> +		__FUNCTION__, port_details, 
> port_details->port->port_identifier,
>  		port_details->num_phys, port_details->phy_bitmask));
>  
>  	for (i = 0; i < port_info->num_phys; i++, phy_info++) {


This function is called after sas_port_delete, thus I 
can't expect any of the data in the port object to be valid.


> @@ -557,7 +551,7 @@
>  			"%s: [%p]: phy_id=%02d port_id=%02d 
> num_phys=%02d "
>  		    	"bitmask=0x%016llX\n",
>  			__FUNCTION__,
> -			port_details, i, port_details->port_id,
> +			port_details, i, 
> port_details->port->port_identifier,
>  			port_details->num_phys, 
> port_details->phy_bitmask));
>  		dsaswideprintk((KERN_DEBUG"\t\tport = %p rphy=%p\n",
>  			port_details->port, port_details->rphy));

This function can be called prior to the creation 
of the port object, thus may be pointing to an
invalid or NULL pointer.   This case would happen
during driver load, or hot adding devices.


> @@ -1608,11 +1602,10 @@
>  	if (phy_info->sas_port_add_phy) {
>  
>  		if (!port) {
> -			port = sas_port_alloc(dev,
> -			    phy_info->port_details->port_id);
> +			port = sas_port_alloc_num(dev);
>  			dsaswideprintk((KERN_DEBUG
>  			    "sas_port_alloc: port=%p dev=%p 
> port_id=%d\n",
> -			    port, dev, 
> phy_info->port_details->port_id));
> +			    port, dev, port->port_identifier));
>  			if (!port) {
>  				error = -ENOMEM;
>  				goto out;
> 

We need to move this dsaswideprintk to after the NULL pointer
check.  I would like to only display the port identifier here.
