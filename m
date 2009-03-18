From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] Add 'tpgs' sysfs attribute for SCSI devices
Date: Wed, 18 Mar 2009 13:58:55 +0000
Message-ID: <1237384735.3350.0.camel@localhost.localdomain>
References: <20090318120206.0BB1418C79D@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:33793 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754103AbZCRN7D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Mar 2009 09:59:03 -0400
In-Reply-To: <20090318120206.0BB1418C79D@pentland.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: sekharan@us.ibm.com, linux-scsi@vger.kernel.org

On Wed, 2009-03-18 at 13:02 +0100, Hannes Reinecke wrote:
> We need to export the 'TGPS' setting of the
> inquiry data to properly support ALUA.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/scsi_scan.c   |    1 +
>  drivers/scsi/scsi_sysfs.c  |    2 ++
>  include/scsi/scsi_device.h |    3 ++-
>  3 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index a14d245..d1619ed 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -836,6 +836,7 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
>  	sdev->inq_periph_qual = (inq_result[0] >> 5) & 7;
>  	sdev->lockable = sdev->removable;
>  	sdev->soft_reset = (inq_result[7] & 1) && ((inq_result[3] & 7) == 2);
> +	sdev->tpgs = (inq_result[5] >> 4) & 3;

As far as I can tell, this is a read only parameter, isn't it?

In that case, why not just do what we do for the SPI inquiry data and
have a wrapper pulling it out of sdev->inquiry instead of a new flag in
sdev?

James


