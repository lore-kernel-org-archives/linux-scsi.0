Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23178C432BE
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Aug 2021 07:38:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED213610CD
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Aug 2021 07:38:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233494AbhH1Hje (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 28 Aug 2021 03:39:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233466AbhH1Hje (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Aug 2021 03:39:34 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30BA9C0613D9;
        Sat, 28 Aug 2021 00:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0ts55k9K+AeTzI9UinkPG1HeoaDA8i8L+H7cb7KVKcM=; b=gQt5y7F7KIDyZaXkososCL+fcG
        T2PIBhRo7HPDBmFHt+eO5KVFvLgVeZGwIKrYR2niVA+3/g2ZgL6e5pKHzjoJmm0lyXek03Dv0Du9P
        aZPQdbYOqZW9kGWcEzCGEYiBC3pfLH7iGVFSfZM5kWNvH0m++Rshqf/nGe+kSXO61lpgRAxS2aPru
        Uo7s6HzZswFEg9QYlOpn1F2dRXGqoTY6EN01HI7Kx5/EERLBx+3USkpv/0tBhHPTid8VxgaTIH1K8
        0szPfLe0HpykgcgAKjnsv0AbqbOddfn9BTTTgLf36cdVT819hgNoou8J9itvpsS1yuvX6iIb4uQTj
        9lt1aQUw==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mJssf-00FNYs-A6; Sat, 28 Aug 2021 07:36:12 +0000
Date:   Sat, 28 Aug 2021 08:35:57 +0100
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
Subject: Re: [PATCH 08/10] dm: add add_disk() error handling
Message-ID: <YSnnXdKLvxEY8yay@infradead.org>
References: <20210823202930.137278-1-mcgrof@kernel.org>
 <20210823202930.137278-9-mcgrof@kernel.org>
 <YSSP6ujNQttGN2sZ@infradead.org>
 <YSk1EhUIr9OjIoVv@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YSk1EhUIr9OjIoVv@bombadil.infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Aug 27, 2021 at 11:55:14AM -0700, Luis Chamberlain wrote:
> > I think the add_disk should just return r.  If you look at the
> > callers they eventualy end up in dm_table_destroy, which does
> > this cleanup.
> 
> I don't see it. What part of dm_table_destroy() does this?

Sorry, dm_destroy, not dm_table_destroy.  For dm_early_create it's
trivial as that calls both dm_table_destroy and dm_destroy in the error
path.  The normal table_load case is a separate ioctl, but if that
fails userspace needs to call the DM_DEV_REMOVE_CMD to cleanup
the state - similar to any other failure.
