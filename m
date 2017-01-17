From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] ses: Fix SAS device detection in enclosure
Date: Tue, 17 Jan 2017 08:56:34 +0100
Message-ID: <20170117075634.GA6067@linux-x5ow.site>
References: <1483997616-18900-1-git-send-email-emilne@redhat.com>
 <yq1ziiqk9b3.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50027 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751140AbdAQH4l (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Jan 2017 02:56:41 -0500
Content-Disposition: inline
In-Reply-To: <yq1ziiqk9b3.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@hansenpartnership.com>

On Mon, Jan 16, 2017 at 04:02:24PM -0500, Martin K . Petersen wrote:
> >>>>> "Ewan" == Ewan D Milne <emilne@redhat.com> writes:
> 
> Ewan> The call to scsi_is_sas_rphy() needs to be made on the SAS
> Ewan> end_device, not on the SCSI device.
> 
> Ewan> Fixes: 835831c57e9b ("ses: use scsi_is_sas_rphy instead of
> Ewan> is_sas_attached") Reviewed-by: Johannes Thumshirn
> Ewan> <jthumshirn@suse.de> Signed-off-by: Ewan D. Milne
> Ewan> <emilne@redhat.com> ---
> Ewan>  drivers/scsi/ses.c | 2 +- 1 file changed, 1 insertion(+), 1
> Ewan>  deletion(-)
> 
> Ewan> diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c index
> Ewan> 8c9a35c..50adabb 100644
> Ewan> --- a/drivers/scsi/ses.c
> Ewan> +++ b/drivers/scsi/ses.c
> Ewan> @@ -587,7 +587,7 @@ static void ses_match_to_enclosure(struct
> Ewan> enclosure_device *edev,
>  
> Ewan>  	ses_enclosure_data_process(edev,
> Ewan>  	to_scsi_device(edev->edev.parent), 0);
>  
> Ewan> - if (scsi_is_sas_rphy(&sdev->sdev_gendev))
> Ewan> + if (scsi_is_sas_rphy(sdev->sdev_target->dev.parent))
> Ewan>  		efd.addr = sas_get_address(sdev);
>  
> Ewan>  	if (efd.addr) {
> Ewan> -- 1.8.3.1
> 
> James?

FWIW I have positive test results from a customer of ours with this as well.

Thanks,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
