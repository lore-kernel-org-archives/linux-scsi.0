Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EF04C07545
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Oct 2023 06:25:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232627AbjJXGZi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Oct 2023 02:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230304AbjJXGZh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Oct 2023 02:25:37 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A81DD
        for <linux-scsi@vger.kernel.org>; Mon, 23 Oct 2023 23:25:36 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id BBA336732D; Tue, 24 Oct 2023 08:25:33 +0200 (CEST)
Date:   Tue, 24 Oct 2023 08:25:33 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org,
        Dan Carpenter <dan.carpenter@linaro.org>
Subject: Re: [PATCH] megaraid: fixup debug message in
 megaraid_abort_and_reset()
Message-ID: <20231024062533.GD8258@lst.de>
References: <20231023073021.21954-1-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231023073021.21954-1-hare@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Oct 23, 2023 at 09:30:21AM +0200, Hannes Reinecke wrote:
> @@ -1925,10 +1925,12 @@ megaraid_abort_and_reset(adapter_t *adapter, struct scsi_cmnd *cmd, int aor)
>  	struct list_head	*pos, *next;
>  	scb_t			*scb;
>  
> -	dev_warn(&adapter->dev->dev, "%s cmd=%x <c=%d t=%d l=%d>\n",
> -	     (aor == SCB_ABORT)? "ABORTING":"RESET",
> -	     cmd->cmnd[0], cmd->device->channel,
> -	     cmd->device->id, (u32)cmd->device->lun);
> +	if (aor == SCB_ABORT)
> +		dev_warn(&adapter->dev->dev, "ABORTING cmd=%x <c=%d t=%d l=%d>\n",

Please avoid the overly long line here.

Otherwise looks good.

