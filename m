Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04170C4320E
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Aug 2021 21:01:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF3A760FA0
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Aug 2021 21:01:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235846AbhH3VCW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Aug 2021 17:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbhH3VCW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Aug 2021 17:02:22 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18734C061575;
        Mon, 30 Aug 2021 14:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=YLeyIh36W9KZ0EdnGoneLXaI1P2Sf43R5mGsowkdW0g=; b=rHUGs8PC9SNCLr8+68pmjJ6j+O
        LtaWTZh9Q5B1+nQ2hrTGPF1fcfbSR3Bc4MaZvFu5VphNn3uzQki+n35xkL0bVrh1LapvtJXCTf9x2
        aX8wRYUgYbB46/sh+IyauBD/d0v+EUJxIYc5tPiQ59XAdDbtIw4Bl5TuloVoTzanjLZH6B4zEyu9Z
        cJfxaSEUPDqzy73KINJtfXG3JQEC+OVcdV8NY+mlstsLgVUnda0SZf0UpWRWmmrSNYHh6ccI4qX6Q
        jujgcYNbGhmMrYwBPve3x8mENOXlAOUdzlGIdtNTAxg2GKSXah81G/vdsWSHpKSkvVupm5BhcGwQl
        0RhmffIA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mKoOo-000ZII-6j; Mon, 30 Aug 2021 21:00:58 +0000
Date:   Mon, 30 Aug 2021 14:00:58 -0700
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
Subject: Re: [PATCH 08/10] dm: add add_disk() error handling
Message-ID: <YS1HCgP/XdWmMtFN@bombadil.infradead.org>
References: <20210823202930.137278-1-mcgrof@kernel.org>
 <20210823202930.137278-9-mcgrof@kernel.org>
 <YSSP6ujNQttGN2sZ@infradead.org>
 <YSk1EhUIr9OjIoVv@bombadil.infradead.org>
 <YSnnXdKLvxEY8yay@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YSnnXdKLvxEY8yay@infradead.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Aug 28, 2021 at 08:35:57AM +0100, Christoph Hellwig wrote:
> On Fri, Aug 27, 2021 at 11:55:14AM -0700, Luis Chamberlain wrote:
> > > I think the add_disk should just return r.  If you look at the
> > > callers they eventualy end up in dm_table_destroy, which does
> > > this cleanup.
> > 
> > I don't see it. What part of dm_table_destroy() does this?
> 
> Sorry, dm_destroy, not dm_table_destroy.  For dm_early_create it's
> trivial as that calls both dm_table_destroy and dm_destroy in the error
> path.  The normal table_load case is a separate ioctl, but if that
> fails userspace needs to call the DM_DEV_REMOVE_CMD to cleanup
> the state - similar to any other failure.

I see, ok sure I'll document this on the commit log as its not so
obvious.

  Luis
