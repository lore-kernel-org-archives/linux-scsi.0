From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: RE: [PATCH] fusion: streamline ->slave_alloc/->slave_destroy
Date: Tue, 26 Oct 2004 12:02:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57053AF0AF@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:12535 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261234AbUJZQC2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Oct 2004 12:02:28 -0400
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Matt_Domsch@Dell.com
Cc: linux-scsi@vger.kernel.org

On Tuesday, October 26, 2004 6:55 AM, Christoph Hellwig wrote:
> That was not just with my patch but with your new monster 
> update, right?
> 
> It contains this totally bogus line:
> 
> +                       
> +                       /* remove the device from our 
> internal data structures */
> +                       if(hd->Targets[pScsiReq->TargetID] != NULL) {
> +                               mptscsih_slave_destroy(sc->device);
> +                       }
> +                   
> 
> in mptscsih_io_done
>

This code was added by request of the megalib team, and Matt Domsch.
This was added for support of hot swap in non-raid environment.  
The IOCSTATUS=MPI_IOCSTATUS_SCSI_DEVICE_NOT_THERE will be received 
when drive has been removed, and this code was added to automatically
remove the instance of the device.  Thus an application such as megalib
would
know real time that devices have been removed, instead of waiting on a scsi
bus scan.

Eric
