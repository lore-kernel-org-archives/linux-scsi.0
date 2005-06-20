From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH, scsi-block-2.6] remove bio_map_user
Date: Mon, 20 Jun 2005 12:59:42 +0200
Message-ID: <20050620105941.GF15021@suse.de>
References: <20050619092946.GA16872@lst.de> <20050620103709.GA15021@suse.de> <20050620103656.GA4164@lst.de> <20050620104114.GD15021@suse.de> <20050620104229.GB4246@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:33513 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261189AbVFTK6Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2005 06:58:24 -0400
Content-Disposition: inline
In-Reply-To: <20050620104229.GB4246@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

On Mon, Jun 20 2005, Christoph Hellwig wrote:
> On Mon, Jun 20, 2005 at 12:41:14PM +0200, Jens Axboe wrote:
> > > That would be?
> > 
> > Stacking drivers or file systems.
> 
> Doesn't make sense, a stacking driver must not deal with locking down
> user memory at all, and for filesystem there's better helpers in

That's a very generic statement to make, there could be valid uses of
that. But the point of the matter is that I don't think we should just
remove bio_map_user() and intentionally break an exported API to save a
few bytes. We are not talking a lot of code, it's just a wrapper.

> fs/direct-io.c

That's true, I'll give you that.

> > > > While I do agree with the change, I know of external users of
> > > > bio_map_user().
> > > 
> > > Who's that?
> > 
> > ocfs2, iirc.
> 
> ocfs2 doesn't use bio_map_user

It did at some point in time, I don't track the tree so apparently they
stopped doing so at some point.

-- 
Jens Axboe

