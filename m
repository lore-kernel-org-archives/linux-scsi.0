Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 098FAC43216
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Aug 2021 07:29:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5F25610A4
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Aug 2021 07:29:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233466AbhH1Ha3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 28 Aug 2021 03:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233348AbhH1HaU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Aug 2021 03:30:20 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32659C0613D9;
        Sat, 28 Aug 2021 00:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=AFQaUzUuTEkMjtfZe6vMif4NxOxYH1tc9yvqOWpaGoU=; b=Vs4fikiD3b55mVdKmwPinQOrql
        2AK33dcgloSKhkn3nQm8xle7mYrgJmLXAgTipd9aFP5lr84o1zbAU3TPW2gaOy/9PC9RjmDSU77eh
        W5g66CdX4UtfAWObohVlVtaWpEvcJB7SYXwghgc5PinRypDaQ9Ul9ftmpWp3nZmqmNrOXQRo6RYLj
        I1GNzV2d8ZOkQOMPt43abeCgMW7JLoZnq07JzKclv09cdG6BstHMpOqcTg4KAznS4BOBsifgIENfn
        IppcKUZOYarvjyhvlYas+2pl8emMMGCZHR1/eaXF0J4oz00GH8XZRstaxf66G63sob0aEQ20KB9eR
        5cPJv5CA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mJsjt-00FNDf-Vc; Sat, 28 Aug 2021 07:27:05 +0000
Date:   Sat, 28 Aug 2021 08:26:53 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk,
        martin.petersen@oracle.com, jejb@linux.ibm.com, kbusch@kernel.org,
        sagi@grimberg.me, adrian.hunter@intel.com, beanhuo@micron.com,
        ulf.hansson@linaro.org, avri.altman@wdc.com, swboyd@chromium.org,
        agk@redhat.com, snitzer@redhat.com, josef@toxicpanda.com,
        hare@suse.de, bvanassche@acm.org, ming.lei@redhat.com,
        linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-mmc@vger.kernel.org, dm-devel@redhat.com,
        nbd@other.debian.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/10] scsi/sd: use blk_cleanup_queue() insted of
 put_disk()
Message-ID: <YSnlPZD/LrVRZWx6@infradead.org>
References: <20210823202930.137278-1-mcgrof@kernel.org>
 <20210823202930.137278-2-mcgrof@kernel.org>
 <YSSJNTxyLHu/LsNJ@infradead.org>
 <YSkumJBTztoYdzC7@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YSkumJBTztoYdzC7@bombadil.infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Aug 27, 2021 at 11:27:36AM -0700, Luis Chamberlain wrote:
> On Tue, Aug 24, 2021 at 06:52:53AM +0100, Christoph Hellwig wrote:
> > On Mon, Aug 23, 2021 at 01:29:21PM -0700, Luis Chamberlain wrote:
> > > The single put_disk() is useful if you know you're not doing
> > > a cleanup after add_disk(), but since we want to add support
> > > for that, just use the normal form of blk_cleanup_disk() to
> > > cleanup the queue and put the disk.
> > 
> > Hmm, I don't think this is correct.  The request_queue is owned by the
> > core SCSI code.
> 
> Alright, I'll drop this one. For the life of me I can't find the respective
> probe call on the scsi layer.

What probe call?  SCSI allocates the request_queue using the normal
blk_mq_init_queue function in scsi_alloc_sdev.  It it then used to
send SCSI passthrough commands for probing before eventually binding
an upper level driver using the driver model (or something not binding
one at all if there is none for the device type).
