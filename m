Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 576B1C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Mar 2022 15:52:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234126AbiCAPxd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Mar 2022 10:53:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbiCAPxc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Mar 2022 10:53:32 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F1A38BE11
        for <linux-scsi@vger.kernel.org>; Tue,  1 Mar 2022 07:52:50 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 55D2C68AFE; Tue,  1 Mar 2022 16:52:47 +0100 (CET)
Date:   Tue, 1 Mar 2022 16:52:47 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 1/4] aic7xxx: use scsi device as argument for
 BUILD_SCSIID()
Message-ID: <20220301155247.GA6667@lst.de>
References: <20220301143957.40998-1-hare@suse.de> <20220301143957.40998-2-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301143957.40998-2-hare@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Mar 01, 2022 at 03:39:54PM +0100, Hannes Reinecke wrote:
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/aic7xxx/aic7xxx_osm.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
> index d3b1082654d5..16d7a7310e90 100644
> --- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
> +++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
> @@ -799,10 +799,10 @@ struct scsi_host_template aic7xxx_driver_template = {
>  /**************************** Tasklet Handler *********************************/
>  
>  /******************************** Macros **************************************/
> -#define BUILD_SCSIID(ahc, cmd)						    \
> -	((((cmd)->device->id << TID_SHIFT) & TID)			    \
> -	| (((cmd)->device->channel == 0) ? (ahc)->our_id : (ahc)->our_id_b) \
> -	| (((cmd)->device->channel == 0) ? 0 : TWIN_CHNLB))
> +#define BUILD_SCSIID(ahc, sdev)						    \
> +	((((sdev)->id << TID_SHIFT) & TID)			    \
> +	| (((sdev)->channel == 0) ? (ahc)->our_id : (ahc)->our_id_b) \
> +	| (((sdev)->channel == 0) ? 0 : TWIN_CHNLB))

How about converting this to a function while you're at it?

Otherwise this looks good.

Same comment for aic79xx.
