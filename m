From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [LSF/MM TOPIC][LSF/MM ATTEND] multipath redesign
Date: Wed, 11 Jan 2017 17:23:39 -0500
Message-ID: <20170111222339.GC19051@redhat.com>
References: <00700606-3005-c82b-ee37-127417fbd201@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <00700606-3005-c82b-ee37-127417fbd201@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, device-mapper development <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jan 11 2017 at  4:44am -0500,
Hannes Reinecke <hare@suse.de> wrote:

> Hi all,
> 
> I'd like to attend LSF/MM this year, and would like to discuss a
> redesign of the multipath handling.
> 
> With recent kernels we've got quite some functionality required for
> multipathing already implemented, making some design decisions of the
> original multipath-tools implementation quite pointless.
> 
> I'm working on a proof-of-concept implementation which just uses a
> simple configfs interface and doesn't require a daemon altogether.
> 
> At LSF/MM I'd like to discuss how to move forward here, and whether we'd
> like to stay with the current device-mapper integration or move away
> from that towards a stand-alone implementation.

I'd really like open exchange of the problems you're having with the
current multipath-tools and DM multipath _before LSF_.  Last LSF only
scratched the surface on people having disdain for the complexity that is
the multipath-tools userspace.  But considering how much of the
multipath-tools you've written I find it fairly comical that you're the
person advocating switching away from it.

But if less userspace involvement is needed then fix userspace.  Fail to
see how configfs is any different than the established DM ioctl interface.

As I just said in another email DM multipath could benefit from
factoring out the SCSI-specific bits so that they are nicely optimized
away if using new transports (e.g. NVMEoF).

Could be lessons can be learned from your approach but I'd prefer we
provably exhaust the utility of the current DM multipath kernel
implementation.  DM multipath is one of the most actively maintained and
updated DM targets (aside from thinp and cache).  As you know DM
multipath has grown blk-mq support which yielded serious performance
improvement.  You also noted (in an earlier email) that I reintroduced
bio-based DM multipath.  On a data path level we have all possible block
core interfaces plumbed.  And yes, they all involve cloning due to the
underlying Device Mapper core.  Open to any ideas on optimization.  If
DM is imposing some inherent performance limitation then please report
it accordingly.
