Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00A91C4320A
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 22:57:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF7D66101A
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 22:57:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236408AbhHSW6J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 18:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbhHSW6I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 18:58:08 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C57C061575;
        Thu, 19 Aug 2021 15:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jN6ytmfG1G2fsajoHZih2MkPavNSC55GOqTyscGelew=; b=cILTUHVymX/jwm1VvrbYRNeWre
        wFxQJDEe5WkQhUZ1WkKXFProOz2CgrmP78tWTHlqQxBxd4F5TUxx6XjfKAxxQS1WBx734fxwXDDDs
        4eTe1rL/Z29gO6b2WRz+U/iS6xBKajXPhbtGPvpwkLK8zf2jHT5c3DP2vPc6koY/TKOkubvSPojpK
        cuSNdcn3v5Xl/ImvrFn/zOyANJ9pgH+YlGkPpAAn74/pqu2gQsfpavTv+Evd1P5RjdipOPt50UNuk
        7vAFHEpFQUWxIzj2guU5bNWhudoAqSE9JDJOCPO3UCM7+JEYVE5ZBinCRj1viC8eYbFd8PG69aDXp
        isrdPZRw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mGqyR-009gVU-HW; Thu, 19 Aug 2021 22:57:23 +0000
Date:   Thu, 19 Aug 2021 15:57:23 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        Kai =?iso-8859-1?Q?M=E4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/9] nvme: use blk_mq_alloc_disk
Message-ID: <YR7h0w6rJc9GYpaf@bombadil.infradead.org>
References: <20210816131910.615153-1-hch@lst.de>
 <20210816131910.615153-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210816131910.615153-2-hch@lst.de>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Aug 16, 2021 at 03:19:02PM +0200, Christoph Hellwig wrote:
> Switch to use the blk_mq_alloc_disk helper for allocating the
> request_queue and gendisk.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/nvme/host/core.c | 33 +++++++++++++--------------------
>  1 file changed, 13 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> index 1478d825011d..a5878ba14c55 100644
> --- a/drivers/nvme/host/core.c
> +++ b/drivers/nvme/host/core.c
> @@ -3762,15 +3759,14 @@ static void nvme_alloc_ns(struct nvme_ctrl *ctrl, unsigned nsid,
>  	if (!nvme_mpath_set_disk_name(ns, disk->disk_name, &disk->flags))
>  		sprintf(disk->disk_name, "nvme%dn%d", ctrl->instance,
>  			ns->head->instance);
> -	ns->disk = disk;
>  
>  	if (nvme_update_ns_info(ns, id))
> -		goto out_put_disk;
> +		goto out_unlink_ns;
>  
>  	if ((ctrl->quirks & NVME_QUIRK_LIGHTNVM) && id->vs[0] == 0x1) {
>  		if (nvme_nvm_register(ns, disk->disk_name, node)) {
>  			dev_warn(ctrl->device, "LightNVM init failure\n");
> -			goto out_put_disk;
> +			goto out_unlink_ns;
>  		}
>  	}

This hunk will fail because of the now removed NVME_QUIRK_LIGHTNVM. The
last part of the patch  then can be removed to apply to linux-next.

  Luis
