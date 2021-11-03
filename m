Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8BAFC433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 16:59:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A54BF610EA
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 16:59:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233026AbhKCRBs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 13:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232997AbhKCRBm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2021 13:01:42 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3379C061714;
        Wed,  3 Nov 2021 09:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1ysNiQ1TLmxwE/+AfokQREzqcHxxXerJCPmtx2qtDtg=; b=Ng7SrRaVFmZs39ThyvoGQSWsZo
        joy3PijbQbL8CgsXLAf2Uxi+0FiYXjT35EPfaqUjGIgjvFGpTzzM6Bpisb33a2Jl3eOvhs0BoW8GK
        D7u9A8ESjbqMKLQasAI+zXoSwzYTP1KcXwpXO5LiUyihokpEk01J0BZ/VgkLkIUR+zYHfDbRsyHRS
        4GizR1DUHJ2gUnE4jTuTA2RH0bkO51vTEB/Fydxkz1N/2Ph9o/VO7YcTTJf1cPJJI72BjgkVNuUjU
        mI7XlP9+XwkYjJU9ljga1MdoOAaHfnEqOCIms7Up6LiLFSYuwE1gRguMehfpPk4BgtAyiEx+pYklV
        SpQhyMwg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1miJbA-005son-1Y; Wed, 03 Nov 2021 16:58:52 +0000
Date:   Wed, 3 Nov 2021 09:58:52 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     axboe@kernel.dk, penguin-kernel@i-love.sakura.ne.jp,
        dan.j.williams@intel.com, vishal.l.verma@intel.com,
        dave.jiang@intel.com, ira.weiny@intel.com, richard@nod.at,
        miquel.raynal@bootlin.com, vigneshr@ti.com, efremov@linux.com,
        song@kernel.org, martin.petersen@oracle.com, hare@suse.de,
        jack@suse.cz, ming.lei@redhat.com, tj@kernel.org,
        linux-mtd@lists.infradead.org, linux-scsi@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 01/13] nvdimm/btt: do not call del_gendisk() if not
 needed
Message-ID: <YYK/zBcQcuEx5B5j@bombadil.infradead.org>
References: <20211103122157.1215783-1-mcgrof@kernel.org>
 <20211103122157.1215783-2-mcgrof@kernel.org>
 <20211103160243.GA31562@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211103160243.GA31562@lst.de>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Nov 03, 2021 at 05:02:43PM +0100, Christoph Hellwig wrote:
> On Wed, Nov 03, 2021 at 05:21:45AM -0700, Luis Chamberlain wrote:
> > del_gendisk() is not required if the disk has not been added.
> > On kernels prior to commit 40b3a52ffc5bc3 ("block: add a sanity
> > check for a live disk in del_gendisk") it is mandatory to not
> > call del_gendisk() if the underlying device has not been through
> > device_add().
> 
> And even with the sanity check is it wrong, and will trigger a WARN_ON.
> So maybe this commit log could use a little update?
> 
> With that fixed I think this should go into 5.16 and -stable.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

OK true, the first WARN_ON() was added on v5.11 through commit 6b3ba9762f9f9
("block: cleanup del_gendisk a bit") though, before that, it is still
wrong. Will send a v3 for this patch alone.

  Luis
