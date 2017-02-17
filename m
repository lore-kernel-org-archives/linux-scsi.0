From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [dm-devel] hch's native NVMe multipathing [was: Re: [PATCH 1/2]
 Don't blacklist nvme]
Date: Fri, 17 Feb 2017 01:33:06 -0800
Message-ID: <20170217093306.GA5389@infradead.org>
References: <1487107154-24883-1-git-send-email-keith.busch@intel.com>
 <20170215145617.GA4241@infradead.org>
 <20170216025357.GA9241@redhat.com>
 <20170216142621.GA21972@infradead.org>
 <20170216151337.GA12678@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:59172 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751838AbdBQJdL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Feb 2017 04:33:11 -0500
Content-Disposition: inline
In-Reply-To: <20170216151337.GA12678@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Keith Busch <keith.busch@intel.com>, dm-devel@redhat.com, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org

On Thu, Feb 16, 2017 at 10:13:37AM -0500, Mike Snitzer wrote:
> Not following what you're saying Keith did.  Please feel free to
> clarify.

Keith demonstrated what it takes to support NVMe with dm.  He also
gave a couple presentations on it in addition to various ptches on
the list.

> The middle man is useful if it can support all transports.  If it only
> supports some then yeah the utility is certainly reduced.

Again let's look at what multipathing involves:

 - discovery of multiple paths for a device, and path preferences:
   Storage protocol specific

 - handling of path state and grouping changes:
   Storage protocol specific

 - handling of path up / down events:
   Storage protocol / transport specific if provided

 - keep alive / path checking:
   Storage protocol specific with possible generic fallback

 - path selection:
   Generic, although building heavily on protocol / transport specific
   information

So most of the hard work is transport specific anyway.  And I fully
agree that generic code should be, well generic.  And with generic
I mean right in the block layer instead of involving a layer block
driver that relies on lots of low-level driver information and setup
from user space.
	
> I'm going to look at removing any scsi_dh code from DM multipath
> (someone already proposed removing the 'retain_attached_hw_handler'
> feature).  Not much point having anything in DM multipath now that scsi
> discovery has the ability to auto-attach the right scsi_dh via scsi_dh's
> .match hook.

Great.

> As a side-effect it will fix Keith's scsi_dh crash (when
> operating on NVMe request_queue).

I think we'll need to have a quick fix for that ASAP, though.

> My hope is that your NVMe equivalent for scsi_dh will "just work" (TM)
> like scsi_dh auto-attach does.  There isn't a finished ALUA equivalent
> standard for NVMe so I'd imagine at this point you have a single device
> handler for NVMe to do error translation?

Yes, error translation for the block layer, but most importantly
discovery of multiple paths to the same namespace.
