From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: hch's native NVMe multipathing [was: Re: [PATCH 1/2] Don't
 blacklist nvme]
Date: Thu, 16 Feb 2017 10:13:37 -0500
Message-ID: <20170216151337.GA12678@redhat.com>
References: <1487107154-24883-1-git-send-email-keith.busch@intel.com>
 <20170215145617.GA4241@infradead.org>
 <20170216025357.GA9241@redhat.com>
 <20170216142621.GA21972@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46804 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932082AbdBPPNh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Feb 2017 10:13:37 -0500
Content-Disposition: inline
In-Reply-To: <20170216142621.GA21972@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Keith Busch <keith.busch@intel.com>, dm-devel@redhat.com, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org

On Thu, Feb 16 2017 at  9:26am -0500,
Christoph Hellwig <hch@infradead.org> wrote:

> On Wed, Feb 15, 2017 at 09:53:57PM -0500, Mike Snitzer wrote:
> > going to LSF/MM?).  Yet you're expecting to just drop it into the tree
> > without a care in the world about the implications.
> 
> I am planning to post it for comments, and then plan to "drop it in the
> tree" exactly because I think of the implications.
> 
> Keith did that

Not following what you're saying Keith did.  Please feel free to
clarify.

But we definitely need to devise a way for NVMe to inform DM multipath
(and vice-versa): hands off this device.  Awkward details to work
through to be sure...

> But once we already do the discovery of the path
> relations in the transport (e.g scsi_dh) we can just move the path
> selectors (for which I'm reusing the DM code anyway btw) and the
> bouncing of I/O to the block layer and cut out the middle man.

The middle man is useful if it can support all transports.  If it only
supports some then yeah the utility is certainly reduced.

> The main reason is that things will just work (TM) instead of having
> to carry around additional userspace to configure a an unneded
> additional device layer that just causes confusion.  Beyond the
> scsi_dh equivalent there is basically no new code in nvme, 

I'm going to look at removing any scsi_dh code from DM multipath
(someone already proposed removing the 'retain_attached_hw_handler'
feature).  Not much point having anything in DM multipath now that scsi
discovery has the ability to auto-attach the right scsi_dh via scsi_dh's
.match hook.  As a side-effect it will fix Keith's scsi_dh crash (when
operating on NVMe request_queue).

My hope is that your NVMe equivalent for scsi_dh will "just work" (TM)
like scsi_dh auto-attach does.  There isn't a finished ALUA equivalent
standard for NVMe so I'd imagine at this point you have a single device
handler for NVMe to do error translation?

Anyway, the scsi_dh equivalent for NVMe is welcomed news!

> just a little new code in the block layer, and a move of the path
> selectors from dm to the block layer.  I would not call this
> fragmentation.

I'm fine with the path selectors getting moved out; maybe it'll
encourage new path selectors to be developed.

But there will need to be some userspace interface stood up to support
your native NVMe multipathing (you may not think it needed but think in
time there will be a need to configure _something_).  That is the
fragmentation I'm referring to.

> Anyway, there is very little point in having an abstract discussion
> here, I'll try to get the code ready ASAP, although until the end of
> next week I'm really pressed with other deadlines.

OK.

FYI, I never wanted to have an abstract discussion.  We need a real nuts
and bolts discussion.  Happy to have it play out on the lists. 

I'm not violently opposed to your native NVMe multipathing -- especially
from a reference implementation point of view.  I think that in practice
it'll  keep DM multipath honest -- help drive scalability improvements, etc.
If over time the native NVMe multipathing _is_ the preferred multipathing
solution for NVme, then so be it.  It'll be on merits.. as it should be.

But I'm sure you're well aware that I and Red Hat and our partners have
a vested interest in providing a single multipath stack that "just
works" for all appropriate storage.
