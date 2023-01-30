Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49BFCC54EED
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Jan 2023 07:58:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbjA3H65 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Jan 2023 02:58:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjA3H6y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jan 2023 02:58:54 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D43D855A9
        for <linux-scsi@vger.kernel.org>; Sun, 29 Jan 2023 23:58:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=RVuQpWnpOTxgRi4sC3VBZ65Raxq44SDP/V5avyhvi4Y=; b=3ulvi1lXb1ZP1wH3SyCGCtp2wD
        OuSctVoVYVTRg6l0WNKINhnDXTVkbIAQOjbevDbmTna5Amua42/RHQ9KtPZn9o5UGfKBilzOhUqx5
        EhKdtmVaWq0NdvS8JqYaCIMRIZO055fd4bpkToLiMjWcgw8alUViwb8kXEAjDUFn8HUNWV9k3HLEs
        af8b3QFIKPcf/nDG3boDkISh7BswfAdtyboKZv4bNoD5FdSIaAA3VKMN20WEJd5H+kqB0LdeB5Luj
        cCWlpXTdl8/C8kwN+4aA4ojfkRfKnKmnyquOAvT6v0XJITUIpA7V15vzRUht8s08jbOvXQ9gJ4jv8
        kdaRS4fg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pMP3p-002bCE-Hh; Mon, 30 Jan 2023 07:58:41 +0000
Date:   Sun, 29 Jan 2023 23:58:41 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
        Martin Wilck <mwilck@suse.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Hannes Reinecke <hare@suse.de>,
        Sachin Sant <sachinp@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>
Subject: Re: [PATCH] scsi: core: Fix the scsi_device_put() might_sleep
 annotation
Message-ID: <Y9d4sfc9hCydhHwb@infradead.org>
References: <20230125194311.249553-1-bvanassche@acm.org>
 <167478903314.4070509.17553562843256554477.b4-ty@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167478903314.4070509.17553562843256554477.b4-ty@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jan 26, 2023 at 10:22:12PM -0500, Martin K. Petersen wrote:
> On Wed, 25 Jan 2023 11:43:11 -0800, Bart Van Assche wrote:
> 
> > Although most calls of scsi_device_put() happen from non-atomic context,
> > alua_rtpg_queue() calls this function from atomic context if
> > alua_rtpg_queue() itself is called from atomic context. alua_rtpg_queue()
> > is always called from contexts where the caller must hold at least one
> > reference to the scsi device in question. This means that the reference
> > taken by alua_rtpg_queue() itself can't be the last one, and thus can be
> > dropped without entering the code path in which scsi_device_put() might
> > actually sleep. Hence move the might_sleep() annotation from
> > scsi_device_put() into scsi_device_dev_release().
> > 
> > [...]
> 
> Applied to 6.2/scsi-fixes, thanks!

This is a really bad idea.  Instead of actually catching scsi_device_put
put from a wrong context all the time, it now limits to the final put
and thus making the annotation a lot less useful.
