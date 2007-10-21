From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 4/4] aic7xxx: Enable 16-bit CDBs
Date: Sun, 21 Oct 2007 11:19:22 -0500
Message-ID: <1192983563.3339.4.camel@localhost.localdomain>
References: <20071019083239.D88FE18C61E@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:51126 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751525AbXJUQTZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Oct 2007 12:19:25 -0400
In-Reply-To: <20071019083239.D88FE18C61E@pentland.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org

On Fri, 2007-10-19 at 10:32 +0200, Hannes Reinecke wrote:
> The patch enables support for 16-bit CDBs in aic7xxx and aic79xx.
> aic7xxx can actually support up to 32-bit CDBs, should they ever see
> the light of day.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/aic7xxx/aic79xx.h     |    2 ++
>  drivers/scsi/aic7xxx/aic79xx_osm.c |    1 +
>  drivers/scsi/aic7xxx/aic7xxx_osm.c |    1 +
>  3 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/aic7xxx/aic79xx.h b/drivers/scsi/aic7xxx/aic79xx.h
> index ce638aa..883f26a 100644
> --- a/drivers/scsi/aic7xxx/aic79xx.h
> +++ b/drivers/scsi/aic7xxx/aic79xx.h
> @@ -413,6 +413,8 @@ struct target_status {
>   * the sense buffer address in the SCB.  This allows
>   * us to retrieve sense information without interrupting
>   * the host in packetized mode.
> + * The current firmware relies on a CDB len of 16, so
> + * don't change it unless you know what you're doing.
>   */
>  typedef uint32_t sense_addr_t;
>  #define MAX_CDB_LEN 16
> diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
> index 2d02040..f4e12e1 100644
> --- a/drivers/scsi/aic7xxx/aic79xx_osm.c
> +++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
> @@ -1090,6 +1090,7 @@ ahd_linux_register_host(struct ahd_softc *ahd, struct scsi_host_template *templa
>  	host->max_id = (ahd->features & AHD_WIDE) ? 16 : 8;
>  	host->max_lun = AHD_NUM_LUNS;
>  	host->max_channel = 0;
> +	host->max_cmd_len = 16;

Actually, the aic79xx doc we now have through the LF NDA programme says
that the 79xx can also go up to 32 byte CDBs.

>  	host->sg_tablesize = AHD_NSEG;
>  	ahd_lock(ahd, &s);
>  	ahd_set_unit(ahd, ahd_linux_unit++);
> diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
> index 390b0fc..d488764 100644
> --- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
> +++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
> @@ -1048,6 +1048,7 @@ ahc_linux_register_host(struct ahc_softc *ahc, struct scsi_host_template *templa
>  	host->max_id = (ahc->features & AHC_WIDE) ? 16 : 8;
>  	host->max_lun = AHC_NUM_LUNS;
>  	host->max_channel = (ahc->features & AHC_TWIN) ? 1 : 0;
> +	host->max_cmd_len = 32;
>  	host->sg_tablesize = AHC_NSEG;
>  	ahc_lock(ahc, &s);
>  	ahc_set_unit(ahc, ahc_linux_unit++);

But, I suppose the main point is: is this really necessary?  The
default, when unspecified, is 16 bytes and the mid-layer can't deliver
anything larger.  I would anticipate the large CDB infrastructure will
have some separate enabling, so why not simply do nothing until that
gets merged?

James


