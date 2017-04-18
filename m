From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] [SCSI] aic7xxx: remove redundant assignment to error
Date: Tue, 18 Apr 2017 14:05:16 +0200
Message-ID: <20170418120516.GF6056@linux-x5ow.site>
References: <20170418115327.6833-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40280 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751312AbdDRMFT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Apr 2017 08:05:19 -0400
Content-Disposition: inline
In-Reply-To: <20170418115327.6833-1-colin.king@canonical.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Hannes Reinecke <hare@suse.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Apr 18, 2017 at 12:53:27PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> error is initially assigned to ENOENT and a few statements later
> is re-assigned to the error return from the call to ahd_wait_seeprom,
> hence the initial assignment is redundant and can be removed.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/scsi/aic7xxx/aic79xx_core.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
> index 95d8f25cbcca..f5a2714ed82c 100644
> --- a/drivers/scsi/aic7xxx/aic79xx_core.c
> +++ b/drivers/scsi/aic7xxx/aic79xx_core.c
> @@ -10077,7 +10077,6 @@ ahd_write_seeprom(struct ahd_softc *ahd, uint16_t *buf,
>  	int   retval;
>  
>  	AHD_ASSERT_MODES(ahd, AHD_MODE_SCSI_MSK, AHD_MODE_SCSI_MSK);
> -	error = ENOENT;
>  
>  	/* Place the chip into write-enable mode */
>  	ahd_outb(ahd, SEEADR, SEEOP_EWEN_ADDR);
> -- 

Well,
a) the return value of ahd_write_seeprom() is never checked (the only caller
   is ahd_proc_write_seeprom(),
b) Linux error codes are negative,
c) ahd_write_seeprom() has 'retval' and 'error' for returning error values
   back to the caller (which doesn't care...)

So to sum it up, this change doesn't change anything here. But "fixing" the
list above would make a change.

HTH,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
