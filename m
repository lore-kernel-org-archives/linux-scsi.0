Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 587F2C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 17:21:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C37860ED8
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 17:21:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237273AbhIMRXK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 13:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbhIMRXK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Sep 2021 13:23:10 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E9FC061574;
        Mon, 13 Sep 2021 10:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ozDu2C9KwJDzUHmqI8L8ZS+TLMmJ1vttUQXVZymGuXw=; b=luWWEIGyIZ+r8nBZzOJgzAJsGx
        N7oDNxgPF3OFmLGgbOPfFjf02fv1ISLc3zvjj4zwkR3ngVeDFoBg7Rkyv8mSPTvmKkXt7bSAXti/9
        R9iY/fZEkesX3BRkVDPaUYhI5ZVJAmf9pJ9amuMKXN9I1A0qj9K6hB9CNHTxNXjZ4LiDoRa1aKw6u
        OUGwFvrmsqa3QOnqAltvdpvADc9fuLcHfFKdTOuFM26DVcVbWUL0CHsaQPCf1HTG5zJqz5CVqQ2VF
        UsurmMzg0xrJvEN2AiG/3SjuJJXUQG1qj45oxztVARgLk7FaNR9pDlE3SjbrPxclCpERbHXedjJr2
        dSlpvPyQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mPpe0-002eih-G4; Mon, 13 Sep 2021 17:21:24 +0000
Date:   Mon, 13 Sep 2021 10:21:24 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     axboe@kernel.dk, martin.petersen@oracle.com, jejb@linux.ibm.com,
        kbusch@kernel.org, sagi@grimberg.me, adrian.hunter@intel.com,
        beanhuo@micron.com, ulf.hansson@linaro.org, avri.altman@wdc.com,
        swboyd@chromium.org, agk@redhat.com, snitzer@redhat.com,
        josef@toxicpanda.com, hch@infradead.org, hare@suse.de,
        bvanassche@acm.org, linux-scsi@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-mmc@vger.kernel.org,
        dm-devel@redhat.com, nbd@other.debian.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 1/8] scsi/sd: add error handling support for add_disk()
Message-ID: <YT+IlJnSZzG0j0ON@bombadil.infradead.org>
References: <20210830212538.148729-1-mcgrof@kernel.org>
 <20210830212538.148729-2-mcgrof@kernel.org>
 <YTbAYyo0+rqUZ+L0@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTbAYyo0+rqUZ+L0@T590>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Sep 07, 2021 at 09:29:07AM +0800, Ming Lei wrote:
> On Mon, Aug 30, 2021 at 02:25:31PM -0700, Luis Chamberlain wrote:
> > We never checked for errors on add_disk() as this function
> > returned void. Now that this is fixed, use the shiny new
> > error handling.
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> > ---
> >  drivers/scsi/sd.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> > index 610ebba0d66e..8c1273fff23e 100644
> > --- a/drivers/scsi/sd.c
> > +++ b/drivers/scsi/sd.c
> > @@ -3487,7 +3487,11 @@ static int sd_probe(struct device *dev)
> >  		pm_runtime_set_autosuspend_delay(dev,
> >  			sdp->host->hostt->rpm_autosuspend_delay);
> >  	}
> > -	device_add_disk(dev, gd, NULL);
> > +
> > +	error = device_add_disk(dev, gd, NULL);
> > +	if (error)
> > +		goto out_free_index;
> > +
> 
> The error handling is actually wrong, see 
> 
> 	https://lore.kernel.org/linux-scsi/c93f3010-13c9-e07f-1458-b6b47a27057b@acm.org/T/#t
> 
> Maybe you can base on that patch.

Done, thanks!

 Luis
