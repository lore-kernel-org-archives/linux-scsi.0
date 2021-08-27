Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F17EEC43214
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 18:28:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA81A60FE7
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 18:28:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbhH0S3B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Aug 2021 14:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbhH0S27 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Aug 2021 14:28:59 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59F26C061757;
        Fri, 27 Aug 2021 11:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=BN0I/ZosD09UMyhqSQvfPnbE77N00K2k+NcNSHrUius=; b=TcPcmN3wc/8PA7Nk30ZO5ftqJr
        /xteMD4uOLnJEPdP2ueY6hcOIuFgkJ2aJgGL8IPl8F9Cf2ahyW8TUqblrtrTIYvXpxjuWgpZBkYkI
        PcMWKPqkSObWHMr7dNi/RHNsOKkWmQFcXaugakKBJol1uVpNCt+HSMVvuQp8VcJEaqkKoViMnyiXM
        YEHr73NdkFCPIOEGTWxjmrUScRMhsQSGFYzqGOobsQbfIi6K7IOuDo4A38X2QXajvW/tvEGg8KiC6
        MBFsjMDtxmN44QKfvur4kL21VGLQ1TJokwsrrEWKoXaCcNwN82Sd1RSH4M+QtHHXETCf6iCQ5vkAj
        Qa9atobg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mJgZk-00Cx8z-5d; Fri, 27 Aug 2021 18:27:36 +0000
Date:   Fri, 27 Aug 2021 11:27:36 -0700
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
Subject: Re: [PATCH 01/10] scsi/sd: use blk_cleanup_queue() insted of
 put_disk()
Message-ID: <YSkumJBTztoYdzC7@bombadil.infradead.org>
References: <20210823202930.137278-1-mcgrof@kernel.org>
 <20210823202930.137278-2-mcgrof@kernel.org>
 <YSSJNTxyLHu/LsNJ@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YSSJNTxyLHu/LsNJ@infradead.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Aug 24, 2021 at 06:52:53AM +0100, Christoph Hellwig wrote:
> On Mon, Aug 23, 2021 at 01:29:21PM -0700, Luis Chamberlain wrote:
> > The single put_disk() is useful if you know you're not doing
> > a cleanup after add_disk(), but since we want to add support
> > for that, just use the normal form of blk_cleanup_disk() to
> > cleanup the queue and put the disk.
> 
> Hmm, I don't think this is correct.  The request_queue is owned by the
> core SCSI code.

Alright, I'll drop this one. For the life of me I can't find the respective
probe call on the scsi layer.

  Luis
