From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] libsas: Don't issue commands to devices that have been
 hot-removed.
Date: Tue, 04 Dec 2007 17:48:33 -0500
Message-ID: <4755D941.2060903@garzik.org>
References: <200711301022.08001.kb@sysmikro.com.pl> <200712031709.54168.kb@sysmikro.com.pl> <20071203193652.GB7066@tree.beaverton.ibm.com> <200712032106.44176.kb@sysmikro.com.pl> <20071204223516.GA6767@tree.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:53052 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458AbXLDWsn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Dec 2007 17:48:43 -0500
In-Reply-To: <20071204223516.GA6767@tree.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: =?UTF-8?B?S3J6eXN6dG9mIELFgmFzemtvd3NraQ==?= <kb@sysmikro.com.pl>, linux-scsi@vger.kernel.org, vst@vlnb.net, Alexis Bruemmer <alexisb@us.ibm.com>

Darrick J. Wong wrote:
> Hrm... does this patch help?  You'll get a bunch of ATA/SAS disk errors
> printed to the screen if you yank the disk, but at least libsas won't
> get stuck waiting for the cache-flush commands to time out.
> ---
> sd will get hung up issuing commands to flush write cache if a SAS device
> is unplugged without warning.  Change libsas to reject commands to domain
> devices that have already gone away.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> 
>  drivers/scsi/libsas/sas_ata.c       |    4 ++++
>  drivers/scsi/libsas/sas_expander.c  |    3 +++
>  drivers/scsi/libsas/sas_port.c      |    2 ++
>  drivers/scsi/libsas/sas_scsi_host.c |    7 +++++++
>  include/scsi/libsas.h               |    1 +
>  5 files changed, 17 insertions(+), 0 deletions(-)

Seems sane...


> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
> index 0829b55..f5e5213 100644
> --- a/drivers/scsi/libsas/sas_ata.c
> +++ b/drivers/scsi/libsas/sas_ata.c
> @@ -161,6 +161,10 @@ static unsigned int sas_ata_qc_issue(struct ata_queued_cmd *qc)
>  	unsigned int num = 0;
>  	unsigned int xfer = 0;
>  
> +	/* If the device fell off, no sense in issuing commands */
> +	if (dev->gone)
> +		return AC_ERR_SYSTEM;
> +
>  	task = sas_alloc_task(GFP_ATOMIC);
>  	if (!task)
>  		return AC_ERR_SYSTEM;

As an aside, issues like this really really imply a need to move libsas 
away from the old libata EH stuff (like brking did with ipr, in patches).

	Jeff



