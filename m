Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70583C432BE
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 05:59:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C75D6124B
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 05:59:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbhHXF75 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Aug 2021 01:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbhHXF7z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Aug 2021 01:59:55 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA1C2C061575;
        Mon, 23 Aug 2021 22:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=nxCjIIPElSqhCdgo8hNsrZTfzyz3uEXAdzaL8siyKA4=; b=SXYaBLqKWP/frBwB8zI2Zucfr5
        0/+veg5jWJ6Kfk/QszuC5jPagukx8ODt6uyKxEUJwSPMT421Vdmt0/C6tWxwD6wF5fKRHHnKsBrXT
        lHh4JKs6Mae3P6aKLDd2Rc1w1Ct3e3hiGtrEBVxib59XxlDS8UX1Bb8ei4ULVCQ3oTVTZPrJf2x8K
        vPv3ihshzkIR1BJYOKoiVb/TuIaIvVHlKDizUFn/dTILcwJoSXpRy2TbYsSyjdjUwum+CbWiWDRlr
        k8nVlg+ZfypZ5fof5hEQvH3rS5pR7+XguMeBeHds3S0Mk2J0UGWPAzrReERc+4WTJU6IMoQbPwRvY
        K76Tn2Iw==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mIPMj-00AcGi-Ei; Tue, 24 Aug 2021 05:54:07 +0000
Date:   Tue, 24 Aug 2021 06:52:53 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     axboe@kernel.dk, martin.petersen@oracle.com, jejb@linux.ibm.com,
        kbusch@kernel.org, sagi@grimberg.me, adrian.hunter@intel.com,
        beanhuo@micron.com, ulf.hansson@linaro.org, avri.altman@wdc.com,
        swboyd@chromium.org, agk@redhat.com, snitzer@redhat.com,
        josef@toxicpanda.com, hch@infradead.org, hare@suse.de,
        bvanassche@acm.org, ming.lei@redhat.com,
        linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-mmc@vger.kernel.org, dm-devel@redhat.com,
        nbd@other.debian.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/10] scsi/sd: use blk_cleanup_queue() insted of
 put_disk()
Message-ID: <YSSJNTxyLHu/LsNJ@infradead.org>
References: <20210823202930.137278-1-mcgrof@kernel.org>
 <20210823202930.137278-2-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210823202930.137278-2-mcgrof@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Aug 23, 2021 at 01:29:21PM -0700, Luis Chamberlain wrote:
> The single put_disk() is useful if you know you're not doing
> a cleanup after add_disk(), but since we want to add support
> for that, just use the normal form of blk_cleanup_disk() to
> cleanup the queue and put the disk.

Hmm, I don't think this is correct.  The request_queue is owned by the
core SCSI code.
