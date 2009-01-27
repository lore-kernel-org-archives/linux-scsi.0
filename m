From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi_scan.c : add missing interim SDEV_DEL state if
	slave_alloc fails
Date: Tue, 27 Jan 2009 16:27:31 +0000
Message-ID: <1233073651.3231.49.camel@localhost.localdomain>
References: <1233070798.22506.5.camel@ogier>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:43525 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752286AbZA0Q1c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jan 2009 11:27:32 -0500
In-Reply-To: <1233070798.22506.5.camel@ogier>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

On Tue, 2009-01-27 at 10:39 -0500, James Smart wrote:
> We were running i/o and performing a bunch of hba resets in a loop.
> This forces a lot of target removes and rescans. Since the resets
> are occuring during scan it's causing the scan i/o to timeout or fail,
> invoking error recovery, etc.  We end up getting a nasty crash
> in scsi_scan.c due to references to old sdevs that had some
> lingering references that kept them around.
> 
> Fix by setting device state to SDEV_DEL if the LLD's slave_alloc
> fails. This will fail reference taking in subsequent teardown/scan paths.
> 
> -- james s
> 
> 
>  Signed-off-by: James Smart <james.smart@emulex.com>
> 
>  ---
> 
>  scsi_scan.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> 
> diff -upNr a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> --- a/drivers/scsi/scsi_scan.c	2009-01-27 09:44:31.000000000 -0500
> +++ b/drivers/scsi/scsi_scan.c	2009-01-27 10:12:04.000000000 -0500
> @@ -310,6 +310,7 @@ static struct scsi_device *scsi_alloc_sd
>  			 */
>  			if (ret == -ENXIO)
>  				display_failure_msg = 0;
> +			scsi_device_set_state(sdev, SDEV_DEL);

A minor nit (since we only have one user of out_device_destroy) is that
the state setting should be done in the out_device_destroy: branch

James


