Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 259A3C43214
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 18:29:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D80E60E97
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 18:29:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbhH0SaN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Aug 2021 14:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbhH0SaM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Aug 2021 14:30:12 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2820C061757;
        Fri, 27 Aug 2021 11:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=AUMiADqeBGFQaMKc9cx2vrmBW7Wcwtbw7Je/QSFxSbQ=; b=LaCxdIm2Zc6DkoIIu5Dj4I6WOS
        XX4xg9rxE8Mc+ybHnX26/zyaE5gVVNXp6X3ZPOds2VV4A1JJIwtGEMY7jV7g7WOYoGzUJeApuHRht
        Cr3RyH7KLNWOu6FMiODVq5p6mzPeRAxelMiwumvvdMsyxfEZ5vprK1y3NU0IdfLbsP9PRoPcPDZEv
        HmS1WjnHgIcI5JamGFEvK75UNtbPLJfgKrhqhH4hwnskUl5/LCBxvWhrYCSz6/XootHre8dvGh9Bl
        JLYTNkxoFOQ0WQqz7JrRo+K9dLT/8IY+DxAmJOuOZ4LrSxIQxpySXVFE8On+0yn8nuJ+Y13REd1Yu
        y04b03uA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mJgb3-00CxJs-B2; Fri, 27 Aug 2021 18:28:57 +0000
Date:   Fri, 27 Aug 2021 11:28:57 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     axboe@kernel.dk, martin.petersen@oracle.com, jejb@linux.ibm.com,
        kbusch@kernel.org, sagi@grimberg.me, adrian.hunter@intel.com,
        beanhuo@micron.com, ulf.hansson@linaro.org, avri.altman@wdc.com,
        swboyd@chromium.org, agk@redhat.com, snitzer@redhat.com,
        josef@toxicpanda.com, hare@suse.de, bvanassche@acm.org,
        ming.lei@redhat.com, linux-scsi@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-mmc@vger.kernel.org,
        dm-devel@redhat.com, nbd@other.debian.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/10] scsi/sr: use blk_cleanup_disk() instead of
 put_disk()
Message-ID: <YSku6VaEOzitSTOg@bombadil.infradead.org>
References: <20210823202930.137278-1-mcgrof@kernel.org>
 <20210823202930.137278-4-mcgrof@kernel.org>
 <YSSK+0afMcpUAKyK@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YSSK+0afMcpUAKyK@infradead.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Aug 24, 2021 at 07:00:27AM +0100, Christoph Hellwig wrote:
> On Mon, Aug 23, 2021 at 01:29:23PM -0700, Luis Chamberlain wrote:
> > The single put_disk() is useful if you know you're not doing
> > a cleanup after add_disk(), but since we want to add support
> > for that, just use the normal form of blk_cleanup_disk() to
> > cleanup the queue and put the disk.
> > 
> > Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> 
> .. not needed as the cleanup is done by the core scsi code.

Dropped.

  Luis
