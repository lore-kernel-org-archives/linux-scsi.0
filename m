From: Benny Halevy <bhalevy@panasas.com>
Subject: Re: [PATCH] Enable 16-bit CDBs for aic7xxx/aic79xxx
Date: Tue, 24 Jul 2007 13:29:08 +0300
Message-ID: <46A5D474.3020602@panasas.com>
References: <46A46B1B.4010306@suse.de> <46A46C86.3000407@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:18962 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751721AbXGXK3O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jul 2007 06:29:14 -0400
In-Reply-To: <46A46C86.3000407@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Just wondering, have you tried testing it with our patches to support
long cdb?  If not, it would be great if you could try doing that.
A snapshot of them is in http://www.bhalevy.com/open-osd/download/sgtable_bidi_varlen/

Benny

Hannes Reinecke wrote:
> Hannes Reinecke wrote:
>> Hi James,
>>
>> this patch enables 16-bit CDBs for aic7xxx and aic79xx. aic7xxx actuallys
>> supports up to 32-bit CDBs, so it might be that aic79xx does that, too.
>> But this would include some more hacking, so this is way easier.
>>
> Yeah, grand. That should read '16-byte CDBs', of course.
> 
> But at least I've been consistent :-)
> New patch attached.
> 
> Cheers,
> 
> Hannes
> 
> 
> ------------------------------------------------------------------------
> 
> Enable 16-byte CDBs for aic7xxx/aix79xx
> 
> The patch enables support for 16-byte CDBs in aic7xxx and aic79xx.
> aic7xxx can actually support up to 32-byte CDBs, should they ever see
> the light of day.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> 
> diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
> index 286ab83..8502085 100644
> --- a/drivers/scsi/aic7xxx/aic79xx_osm.c
> +++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
> @@ -1089,6 +1089,7 @@ ahd_linux_register_host(struct ahd_softc *ahd, struct scsi_host_template *templa
>  	host->max_id = (ahd->features & AHD_WIDE) ? 16 : 8;
>  	host->max_lun = AHD_NUM_LUNS;
>  	host->max_channel = 0;
> +	host->max_cmd_len = MAX_CDB_LEN;
>  	host->sg_tablesize = AHD_NSEG;
>  	ahd_lock(ahd, &s);
>  	ahd_set_unit(ahd, ahd_linux_unit++);
> diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
> index 1803ab6..a6b3071 100644
> --- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
> +++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
> @@ -1047,6 +1047,7 @@ ahc_linux_register_host(struct ahc_softc *ahc, struct scsi_host_template *templa
>  	host->max_id = (ahc->features & AHC_WIDE) ? 16 : 8;
>  	host->max_lun = AHC_NUM_LUNS;
>  	host->max_channel = (ahc->features & AHC_TWIN) ? 1 : 0;
> +	host->max_cmd_len = 32;
>  	host->sg_tablesize = AHC_NSEG;
>  	ahc_lock(ahc, &s);
>  	ahc_set_unit(ahc, ahc_linux_unit++);

