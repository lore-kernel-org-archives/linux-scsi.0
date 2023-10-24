Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B9F8C07545
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Oct 2023 06:25:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232616AbjJXGZC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Oct 2023 02:25:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232589AbjJXGZB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Oct 2023 02:25:01 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B31DC0
        for <linux-scsi@vger.kernel.org>; Mon, 23 Oct 2023 23:24:59 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 0A3546732D; Tue, 24 Oct 2023 08:24:57 +0200 (CEST)
Date:   Tue, 24 Oct 2023 08:24:56 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org,
        Dan Carpenter <dan.carpenter@linaro.org>
Subject: Re: [PATCH] aic79xx: fix up NULL command in ahd_done()
Message-ID: <20231024062456.GC8258@lst.de>
References: <20231023073014.21438-1-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231023073014.21438-1-hare@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Oct 23, 2023 at 09:30:14AM +0200, Hannes Reinecke wrote:
> +++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
> @@ -1834,7 +1834,7 @@ ahd_done(struct ahd_softc *ahd, struct scb *scb)
>  		} else {
>  			ahd_set_transaction_status(scb, CAM_REQ_CMP);
>  		}
> -	} else if (ahd_get_transaction_status(scb) == CAM_SCSI_STATUS_ERROR) {
> +	} else if (cmd && ahd_get_transaction_status(scb) == CAM_SCSI_STATUS_ERROR) {

Please avoid the overly long line here.

Otherwise looks good.

