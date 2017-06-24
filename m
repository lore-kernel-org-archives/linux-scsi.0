From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 35/35] scsi: Do not allocate scsi command in
        scsi_ioctl_reset()
Date: Sat, 24 Jun 2017 09:09:04 +0200
Message-ID: <20170624070904.GB14437@lst.de>
References: <1498222975-71858-1-git-send-email-hare@suse.de> <1498222975-71858-36-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:56873 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751239AbdFXHJG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 24 Jun 2017 03:09:06 -0400
Content-Disposition: inline
In-Reply-To: <1498222975-71858-36-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Fri, Jun 23, 2017 at 03:02:55PM +0200, Hannes Reinecke wrote:
> As we now have moved the error handler functions to not rely on
> a scsi command we can drop the out-of-band scsi command allocation
> from scsi_ioctl_reset().
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/scsi_error.c | 112 +++++++++++++++++-----------------------------
>  1 file changed, 42 insertions(+), 70 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 4a7fe97f..c9bd7a4 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -728,16 +728,22 @@ static void scsi_eh_done(struct scsi_cmnd *scmd)
>  		complete(eh_action);
>  }
>  
> +static void __scsi_report_device_reset(struct scsi_device *sdev, void *data)
> +{
> +	sdev->was_reset = 1;
> +	sdev->expecting_cc_ua = 1;
> +}

Please have aversion without the data argument, which is only
needed for the target iterator.
