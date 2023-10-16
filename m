Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEA86CDB465
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Oct 2023 13:37:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233949AbjJPNhX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Oct 2023 09:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233941AbjJPNhA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Oct 2023 09:37:00 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2934D40
        for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2023 06:36:54 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id EC32268C7B; Mon, 16 Oct 2023 15:36:51 +0200 (CEST)
Date:   Mon, 16 Oct 2023 15:36:51 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 08/17] xen-scsifront: rework scsifront_action_handler()
Message-ID: <20231016133651.GD28162@lst.de>
References: <20231016092430.55557-1-hare@suse.de> <20231016092430.55557-9-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231016092430.55557-9-hare@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Oct 16, 2023 at 11:24:21AM +0200, Hannes Reinecke wrote:
> Rework scsifront_action_handler() to add the SCSI device as the
> first argument, and select between abort and device reset by
> checking whether the scsi_cmnd argument is NULL.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/xen-scsifront.c | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/xen-scsifront.c b/drivers/scsi/xen-scsifront.c
> index a0c13200d53a..26dd229aeb22 100644
> --- a/drivers/scsi/xen-scsifront.c
> +++ b/drivers/scsi/xen-scsifront.c
> @@ -668,11 +668,11 @@ static int scsifront_queuecommand(struct Scsi_Host *shost,
>   * We have to wait until an answer is returned. This answer contains the
>   * result to be returned to the requestor.
>   */
> -static int scsifront_action_handler(struct scsi_cmnd *sc, uint8_t act)
> +static int scsifront_action_handler(struct scsi_device *sdev, struct scsi_cmnd *sc)

Please avoid the overly long line here.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
