From: Doug Chapman <doug.chapman@hp.com>
Subject: Re: [PATCH] fix for BZ 8426 - massive slowdown on SCSI CD/DVD
	drive connected to mptspi driver
Date: Tue, 22 May 2007 14:25:10 -0600
Message-ID: <1179865510.5479.17.camel@phobos>
References: <1178567987.27671.20.camel@deimos.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atlrel9.hp.com ([156.153.255.214]:55047 "EHLO atlrel9.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756514AbXEVUZX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 May 2007 16:25:23 -0400
In-Reply-To: <1178567987.27671.20.camel@deimos.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: eric.moore@lsi.com
Cc: linux-scsi@vger.kernel.org

Eric,

Sorry to bother you on this again, I realize you are very busy.

>From our off-list email and from your comments to Chip Coldwell in
redhat BZ 225177 it sounded like you were prepared to ACK this.  Any
chance you could send your official ACK so this can be committed?

much appreciated,

- Doug


On Mon, 2007-05-07 at 15:59 -0400, Doug Chapman wrote:
> Patch for: http://bugzilla.kernel.org/show_bug.cgi?id=8426
> 
> A recent code cleanup that moved code from mptscsih to mptspi
> inadvertently change the order some code was called.  This caused
> a massive slowdown (of 150x to 300x) on the CD/DVD drive on the
> high-end HP Integrity servers.
> 
> Signed-off-by: Doug Chapman <doug.chapman@hp.com>
> 
> 
> 
> 
> diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
> index 85f21b5..2eb5741 100644
> --- a/drivers/message/fusion/mptspi.c
> +++ b/drivers/message/fusion/mptspi.c
> @@ -726,13 +726,15 @@ static int mptspi_slave_configure(struct scsi_device *sdev)
>  	struct _MPT_SCSI_HOST *hd =
>  		(struct _MPT_SCSI_HOST *)sdev->host->hostdata;
>  	VirtTarget *vtarget = scsi_target(sdev)->hostdata;
> -	int ret = mptscsih_slave_configure(sdev);
> +	int ret;
> +
> +	mptspi_initTarget(hd, vtarget, sdev);
> +
> +	ret = mptscsih_slave_configure(sdev);
>  
>  	if (ret)
>  		return ret;
>  
> -	mptspi_initTarget(hd, vtarget, sdev);
> -
>  	ddvprintk((MYIOC_s_INFO_FMT "id=%d min_period=0x%02x"
>  		" max_offset=0x%02x max_width=%d\n", hd->ioc->name,
>  		sdev->id, spi_min_period(scsi_target(sdev)),
> 
> 

