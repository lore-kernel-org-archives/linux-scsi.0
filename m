Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33447C43217
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 15:15:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1196D61052
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 15:15:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232003AbhJUPR5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Oct 2021 11:17:57 -0400
Received: from verein.lst.de ([213.95.11.211]:47039 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232141AbhJUPRk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Oct 2021 11:17:40 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3052D68BEB; Thu, 21 Oct 2021 17:15:21 +0200 (CEST)
Date:   Thu, 21 Oct 2021 17:15:20 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@lst.de>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: please revert the UFS HPB support
Message-ID: <20211021151520.GA31407@lst.de>
References: <20211021144210.GA28195@lst.de> <84fac5a3-135a-2ac8-5929-a1031a311cb7@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84fac5a3-135a-2ac8-5929-a1031a311cb7@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Oct 21, 2021 at 09:13:30AM -0600, Jens Axboe wrote:
> On 10/21/21 8:42 AM, Christoph Hellwig wrote:
> > Hi Martin,
> > 
> > I just noticed the UFS HPB support landed in 5.15, and just as
> > before it is completely broken by allocating another request on
> > the same device and then reinserting it in the queue.  It is bad
> > enough that we have to live with blk_insert_cloned_request for
> > dm-mpath, but this is too big of an API abuse to make it into
> > a release.  We need to drop this code ASAP, and I can prepare
> > a patch for that.
> 
> That sounds awful, do you have a link to the offending commit(s)?

I'll need to look for it, busy in calls right now, but just grep for
blk_insert_cloned_request.
