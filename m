From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] Enable 16-bit CDBs for aic7xxx/aic79xxx
Date: Tue, 24 Jul 2007 13:04:04 -0400
Message-ID: <1185296644.3488.11.camel@localhost.localdomain>
References: <46A46B1B.4010306@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:39961 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754143AbXGXREG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jul 2007 13:04:06 -0400
In-Reply-To: <46A46B1B.4010306@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2007-07-23 at 10:47 +0200, Hannes Reinecke wrote:
> Hi James,
> 
> this patch enables 16-bit CDBs for aic7xxx and aic79xx. aic7xxx actuallys
> supports up to 32-bit CDBs, so it might be that aic79xx does that, too.
> But this would include some more hacking, so this is way easier.
> 
> Please apply.
> 
> Cheers,
> 
> Hannes
> plain text document attachment (aic7xxx-enable-16byte-cdbs)
> Enable 16-bit CDBs for aic7xxx/aix79xx
> 
> The patch enables support for 16-bit CDBs in aic7xxx and aic79xx.
> aic7xxx can actually support up to 32-bit CDBs, should they ever see
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

If aic79xx only supports 16 byte CDBs without modification, shouldn't
this be set to 16?  MAX_CDB_LEN could easily end up being patched to be
larger and then aic79xx would be in trouble.

James


