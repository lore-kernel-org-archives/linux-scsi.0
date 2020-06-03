Return-Path: <SRS0=gfFE=7Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C757C433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Jun 2020 12:54:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE0F720738
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Jun 2020 12:54:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725937AbgFCMyE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Jun 2020 08:54:04 -0400
Received: from verein.lst.de ([213.95.11.211]:50672 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725833AbgFCMyC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 3 Jun 2020 08:54:02 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id D74BA68B05; Wed,  3 Jun 2020 14:53:59 +0200 (CEST)
Date:   Wed, 3 Jun 2020 14:53:59 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Doug Gilbert <dgilbert@interlog.com>,
        Daniel Wagner <daniel.wagner@suse.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCHv4 0/6] scsi: use xarray for devices and targets
Message-ID: <20200603125359.GA12995@lst.de>
References: <20200602113311.121513-1-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200602113311.121513-1-hare@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jun 02, 2020 at 01:33:05PM +0200, Hannes Reinecke wrote:
> Hi all,
> 
> based on the ideas from Doug Gilbert here's now my take on using
> xarrays for devices and targets.
> It revolves around two ideas:
> 
> - The scsi target 'channel' and 'id' numbers are never ever used
>   to the full 32 bit range; channels are well below 10, and no
>   driver is using more than 16 bits for the id. So we can reduce
>   the type of 'channel' and 'id' to 16 bits, and use the 32 bit
>   value 'channel << 16 | id' as the index into the target xarray.
> - Nearly every target only ever uses the first two levels of the
>   4-level SCSI LUN structure, which means that we can use the
>   linearized SCSI LUN id as an index into the xarray.
>   If we ever come across targets utilizing more that 2 levels of
>   the LUN structure we'll allocate the first unused index and have
>   to resort to a less efficient lookup instead of direct indexing.
> 
> With these changes we can implement an efficient lookup mechanism,
> devolving into direct lookup for most cases. It also allows us to
> detect duplicate entries or accidental overwrites of existing elements
> by using xa_cmpxchg().
> And iteration over targets and devices should be as efficient as the
> current, list-based, approach.
> 
> As usual, comments and reviews are welcome.

I see absolutely no argument for what the point of this series.  It adds
more code, and I don't really see any indications for it fixing bugs,
speeding up workloads, or reducing memory usage.
