From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: RE: [PATCH] fusion: streamline ->slave_alloc/->slave_destroy
Date: Wed, 6 Oct 2004 14:25:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E570526244E@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:63484 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S269357AbUJFS0F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Oct 2004 14:26:05 -0400
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

On Saturday, October 02, 2004 2:24 AM,  Christoph Hellwig wrote:
> @@ -2812,59 +2796,33 @@
>  mptscsih_slave_destroy(struct scsi_device *device)
>  {
>  	struct Scsi_Host	*host = device->host;
> -	MPT_SCSI_HOST		*hd;
> -	VirtDevice		*vdev;
> -	int 			raid_volume=0;
> +	MPT_SCSI_HOST		*hd = (MPT_SCSI_HOST *)host->hostdata;
> +	VirtDevice		*vdev =  hd->Targets[device->id];
> +	uint			target = device->id;
> +	uint			lun = device->lun;
>  
> -	hd = (MPT_SCSI_HOST *)host->hostdata;
> +	mptscsih_search_running_cmds(hd, target, lun);
>  
> -	if (hd == NULL)
> +	vdev->luns[0] &= ~(1 << lun);

Ok - I'm finally getting around to testing this patch.

The driver will oops on this line because this routine is 
sometimes called when vdev=NULL.  Your patch had removed the
check for this NULL pointer. We probally should add it back.

Eric
