Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52A86C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 17:26:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E34360238
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 17:26:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239464AbhIMR1r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 13:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233121AbhIMR1r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Sep 2021 13:27:47 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D25BC061574;
        Mon, 13 Sep 2021 10:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=n6IoAZ8B/kEcoizb/4oIl8YoC6PaMi7dZ4UmJ7FfTuc=; b=pK5QwDIEOUYgR3LtlFvUy5fURG
        9u45mAqM1M9DAu9Zww5qGhwL7DkhW606ory3IOBDIiQw5bkR5CbNS1SnMZCioV+m24ylfkxb7A6ge
        2tsX3nC1XrVrNY/xrt2K0/CbkDq4gqhlSc36DUyXHmcmx7U/KtCkShut18PHWMXO8eKaqzv2/nEDF
        fpmHTPjhk8b8IQe0jTE2AKFDSU3Nj0ipIbcN+0M6LFLuck79b71sJareQfNB69tQztBEyElRHIVdE
        YXsLWDnPX/zVc4jzgcfn3FHMudr5LNLi338cljUuC9wVwpsxEPKs0rw9FnVgbReeQCs/XMBa1XJ4b
        hxPQRrPQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mPpib-002gGS-4q; Mon, 13 Sep 2021 17:26:09 +0000
Date:   Mon, 13 Sep 2021 10:26:09 -0700
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
Subject: Re: [PATCH v3 2/8] scsi/sr: add error handling support for add_disk()
Message-ID: <YT+JsQ7pgtz0E2ZK@bombadil.infradead.org>
References: <20210830212538.148729-1-mcgrof@kernel.org>
 <20210830212538.148729-3-mcgrof@kernel.org>
 <YTbCQdieHG07Bz8W@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTbCQdieHG07Bz8W@T590>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Sep 07, 2021 at 09:37:05AM +0800, Ming Lei wrote:
> On Mon, Aug 30, 2021 at 02:25:32PM -0700, Luis Chamberlain wrote:
> > We never checked for errors on add_disk() as this function
> > returned void. Now that this is fixed, use the shiny new
> > error handling.
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> > ---
> >  drivers/scsi/sr.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> > index 2942a4ec9bdd..72fd21844367 100644
> > --- a/drivers/scsi/sr.c
> > +++ b/drivers/scsi/sr.c
> > @@ -779,7 +779,10 @@ static int sr_probe(struct device *dev)
> >  	dev_set_drvdata(dev, cd);
> >  	disk->flags |= GENHD_FL_REMOVABLE;
> >  	sr_revalidate_disk(cd);
> > -	device_add_disk(&sdev->sdev_gendev, disk, NULL);
> > +
> > +	error = device_add_disk(&sdev->sdev_gendev, disk, NULL);
> > +	if (error)
> > +		goto fail_minor;
> 
> You don't undo register_cdrom(), maybe you can use kref_put(&cd->kref, sr_kref_release);
> to simplify the error handling.

Works with me, thanks!

  Luis
