From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] scsi: osd_uld: fix mismerge
Date: Thu, 20 Apr 2017 09:26:13 +1000
Message-ID: <20170420092613.1ac7c403@canb.auug.org.au>
References: <20170419174415.4029467-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:43685 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966081AbdDSX0V (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 19 Apr 2017 19:26:21 -0400
In-Reply-To: <20170419174415.4029467-1-arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Boaz Harrosh <ooo@electrozaur.com>, Benny Halevy <bhalevy@primarydata.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Dan Carpenter <dan.carpenter@oracle.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>, Linux-Next Mailing List <linux-next@vger.kernel.org>

Hi Arnd,

On Wed, 19 Apr 2017 19:44:01 +0200 Arnd Bergmann <arnd@arndb.de> wrote:
>
> A mismerge between two branches in linux-next reintroduced a warning that was
> previously resolved:
> 
> drivers/scsi/osd/osd_uld.c: In function 'osd_probe':
> drivers/scsi/osd/osd_uld.c:457:2: error: ignoring return value of 'scsi_device_get', declared with attribute warn_unused_result [-Werror=unused-result]
> 
> The original fix had more complex error unrolling, but as far as I
> can tell, this simpler version is now sufficient.
> 
> Fixes: c02465fa13b6 ("scsi: osd_uld: Check scsi_device_get() return value")
> Fixes: ac1ddc584e98 ("scsi: utilize new cdev_device_add helper function")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/scsi/osd/osd_uld.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c
> index 8b9941a5687a..0e56f1eb05dc 100644
> --- a/drivers/scsi/osd/osd_uld.c
> +++ b/drivers/scsi/osd/osd_uld.c
> @@ -454,7 +454,8 @@ static int osd_probe(struct device *dev)
>  	/* hold one more reference to the scsi_device that will get released
>  	 * in __release, in case a logout is happening while fs is mounted
>  	 */
> -	scsi_device_get(scsi_device);
> +	if (scsi_device_get(scsi_device))
> +		goto err_retract_minor;
>  	osd_dev_init(&oud->od, scsi_device);
>  
>  	/* allocate a disk and set it up */

I will add this as a merge fix patch for the merge of the char-misc and
scsi trees today.  Someone needs to let Linus know when these trees are
merged.

-- 
Cheers,
Stephen Rothwell
