Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79074C433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Apr 2021 08:33:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38FBE61185
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Apr 2021 08:33:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233714AbhD2Id5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Apr 2021 04:33:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:53716 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229963AbhD2Id5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Apr 2021 04:33:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1619685190; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qak55GfNaKxIGtgsOFH5doKuWUhF4eaklkmtwDAOwtU=;
        b=IB4ZzRukWMYhQGmtKKe3341NMIIwiDKQVVGEjAsbdV3bf7g/jcEoaRBhDreJB0qkrTcFPI
        kweyBhtvO0dQ7Tj/nrvFcZtnagjNQYHB5jhI+rIcbCsDIO1jnAUtgCSJJh8spgBcODZiU4
        QWZ6pPYpSLTvqA8gaIcANANO43mLEUw=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0D247B2BF;
        Thu, 29 Apr 2021 08:33:10 +0000 (UTC)
Message-ID: <26ac367a5a09ff5de628717721425fbc03018f44.camel@suse.com>
Subject: Re: dm: dm_blk_ioctl(): implement failover for SG_IO on dm-multipath
From:   Martin Wilck <mwilck@suse.com>
To:     Mike Snitzer <snitzer@redhat.com>
Cc:     Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com,
        Hannes Reinecke <hare@suse.de>,
        Daniel Wagner <dwagner@suse.de>, linux-block@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Date:   Thu, 29 Apr 2021 10:33:09 +0200
In-Reply-To: <20210428195457.GA46518@lobo>
References: <20210422202130.30906-1-mwilck@suse.com>
         <20210428195457.GA46518@lobo>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-04-28 at 15:54 -0400, Mike Snitzer wrote:
> 
> @@ -626,32 +626,16 @@ static int dm_sg_io_ioctl(struct block_device
> *bdev, fmode_t mode,
>                 }
>  
>                 if (rhdr.info & SG_INFO_CHECK) {
> -                       /*
> -                        * See if this is a target or path error.
> -                        * Compare blk_path_error(),
> scsi_result_to_blk_status(),
> -                        * blk_errors[].
> -                        */
> -                       switch (rhdr.host_status) {
> -                       case DID_OK:
> -                               if (scsi_status_is_good(rhdr.status))
> -                                       rc = 0;
> -                               break;
> -                       case DID_TARGET_FAILURE:
> -                               rc = -EREMOTEIO;
> -                               goto out;
> -                       case DID_NEXUS_FAILURE:
> -                               rc = -EBADE;
> -                               goto out;
> -                       case DID_ALLOC_FAILURE:
> -                               rc = -ENOSPC;
> -                               goto out;
> -                       case DID_MEDIUM_ERROR:
> -                               rc = -ENODATA;
> -                               goto out;
> -                       default:
> -                               /* Everything else is a path error */
> +                       blk_status_t sts =
> scsi_result_to_blk_status(rhdr.host_status, NULL);

This change makes dm_mod depend on scsi_mod. 
Would you seriously prefer that over a re-implementation of the logic?

Regards
Martin


