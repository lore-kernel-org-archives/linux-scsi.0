Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53618C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 16:45:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24C276112E
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 16:45:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232959AbhKCQrs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 12:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232949AbhKCQrp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2021 12:47:45 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA88C061205;
        Wed,  3 Nov 2021 09:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=yLyQ8KE6lPd/IDI3kCHAp5LbA5OYjfq5O1psyk0qtAI=; b=vmMOglKBt8PDh/bUAN1+rlzdv6
        3Fhy+NAF7mIdRCDHGJFypodYYTID/u5YqF+Nac/z6PQHg/+WYIYvo5NVIioG+jXEKB1t0MyeX73H0
        gzRWV/cRlpFZXnFU1F7+T2y9UwuoBrNOpj46zNFSyA417zS/smYZ7wxNEGVyZezSndckLMJXnl0O5
        EtqNqC4F55mhbG2W7nlt9waF1Q4Jxm786PeCFtG3TPSP7fO7BNIENDd98IGSRAZ0CgtVjAHAAmvxZ
        taLs5GVIppZEWpJrcF26PHINNyyldspZAuf3C2hr/BIcXaGud5wZ7/Peo1RiiBs7ByTEF93GyC9E2
        CpeGLfSw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1miJNd-005ogn-8t; Wed, 03 Nov 2021 16:44:53 +0000
Date:   Wed, 3 Nov 2021 09:44:53 -0700
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
Subject: Re: [PATCH v2 12/13] block: make __register_blkdev() return an error
Message-ID: <YYK8hY/giSBFN8YJ@bombadil.infradead.org>
References: <20211103122157.1215783-1-mcgrof@kernel.org>
 <20211103122157.1215783-13-mcgrof@kernel.org>
 <20211103160933.GK31562@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211103160933.GK31562@lst.de>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Nov 03, 2021 at 05:09:33PM +0100, Christoph Hellwig wrote:
> On Wed, Nov 03, 2021 at 05:21:56AM -0700, Luis Chamberlain wrote:
> > This makes __register_blkdev() return an error, and also changes the
> > probe() call to return an error as well.
> > 
> > We expand documentation for the probe call to ensure that if the block
> > device already exists we don't return on error on that condition. We do
> > this as otherwise we loose ability to handle concurrent requests if the
> > block device already existed.
> 
> I'm still not really sold on this - if the probe fails no bdev will
> be registered and the lookup will fail.  What is the benefit of
> propagating the exact error here?

Here's the thing, prober call a form of add_disk(), and so do we want
to always ignore the errors on probe? If so we should document why that
is sane then. I think this approach is a bit more sane though.

  Luis
