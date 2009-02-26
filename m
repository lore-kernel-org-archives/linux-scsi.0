From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: RFC: Transport identifier
Date: Thu, 26 Feb 2009 09:39:31 -0600
Message-ID: <49A6B7B3.7070003@cs.wisc.edu>
References: <yq1iqmxg6o4.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:36684 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891AbZBZPjo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Feb 2009 10:39:44 -0500
In-Reply-To: <yq1iqmxg6o4.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

Martin K. Petersen wrote:
> There are a few cases where it would be useful to know which transport
> is associated with a scsi_device.  For instance when determining whether
> to send a READ CAPACITY(16) to a device or not:
> 
>     static int sd_try_rc16_first(struct scsi_device *sdp)
>     {
> 	if (scsi_device_transport(sdp) == SCSI_TRANSPORT_USB)
> 	   return 0; /* Run screaming for the hills */
>     [...]
> 
> This patch implements support for a transport identifier in the
> scsi_host.  The id defaults to SPI and it is explicitly overridden in
> the host templates for FC, SAS, USB, etc. drivers.
> 
> It also looks like the availability of this transport id could improve
> the sysfs parsing in lsscsi.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> 


> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -1594,6 +1594,7 @@ static struct scsi_host_template srp_tem
>  	.cmd_per_lun			= SRP_SQ_SIZE,
>  	.use_clustering			= ENABLE_CLUSTERING,
>  	.shost_attrs			= srp_host_attrs
> +	.transport_id			= SCSI_TRANSPORT_ISCSI,
>  };


This one is a new type, SCSI_TRANSPORT_SRP.

There is a new iscsi driver in Linus and James's current tree in 
drivers/scsi/cxgb3i. And there is a new fc one in drivers/scsi/fcoe.
