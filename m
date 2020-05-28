Return-Path: <SRS0=GT1C=7K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE55EC433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 07:24:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACFA4207BC
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 07:24:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbgE1HYN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 May 2020 03:24:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:56414 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbgE1HYN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 28 May 2020 03:24:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7E743AB3D;
        Thu, 28 May 2020 07:24:14 +0000 (UTC)
Date:   Thu, 28 May 2020 09:24:09 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Doug Gilbert <dgilbert@interlog.com>,
        Daniel Wagner <daniel.wagner@suse.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/4] scsi: convert target lookup to xarray
Message-ID: <20200528072409.s6jqoaty2zvks7ei@beryllium.lan>
References: <20200527141400.58087-1-hare@suse.de>
 <20200527141400.58087-2-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200527141400.58087-2-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, May 27, 2020 at 04:13:57PM +0200, Hannes Reinecke wrote:
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -1512,15 +1512,19 @@ void scsi_remove_target(struct device *dev)
>  {
>  	struct Scsi_Host *shost = dev_to_shost(dev->parent);
>  	struct scsi_target *starget;
> +	unsigned long tid = 0;
>  	unsigned long flags;
>  
> -restart:
>  	spin_lock_irqsave(shost->host_lock, flags);
> -	list_for_each_entry(starget, &shost->__targets, siblings) {
> +	starget = xa_find(&shost->__targets, &tid, ULONG_MAX, XA_PRESENT);
> +	while (starget) {
>  		if (starget->state == STARGET_DEL ||
>  		    starget->state == STARGET_REMOVE ||
> -		    starget->state == STARGET_CREATED_REMOVE)
> +		    starget->state == STARGET_CREATED_REMOVE) {
> +			starget = xa_find_after(&shost->__targets, &tid,
> +						ULONG_MAX, XA_PRESENT);
>  			continue;
> +		}
>  		if (starget->dev.parent == dev || &starget->dev == dev) {
>  			kref_get(&starget->reap_ref);
>  			if (starget->state == STARGET_CREATED)
> @@ -1530,7 +1534,10 @@ void scsi_remove_target(struct device *dev)
>  			spin_unlock_irqrestore(shost->host_lock, flags);
>  			__scsi_remove_target(starget);
>  			scsi_target_reap(starget);
> -			goto restart;
> +			spin_lock_irqsave(shost->host_lock, flags);
> +			starget = xa_find_after(&shost->__targets, &tid,
> +						ULONG_MAX, XA_PRESENT);
> +			continue;
>  		}

Is there a special reason why don't use xa_for_each to iterate through all
entries?
