From: Mike Snitzer <snitzer@redhat.com>
Subject: bio-based DM multipath is back from the dead [was: Re: Notes from
 the four separate IO track sessions at LSF/MM]
Date: Wed, 25 May 2016 22:38:56 -0400
Message-ID: <20160526023855.GA20659@redhat.com>
References: <1461800389.2311.70.camel@HansenPartnership.com>
 <20160428121108.GA9903@redhat.com>
 <1461858038.2307.16.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752761AbcEZCi6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 May 2016 22:38:58 -0400
Content-Disposition: inline
In-Reply-To: <1461858038.2307.16.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-block@vger.kernel.org, lsf@lists.linux-foundation.org, device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, hch@lst.de

On Thu, Apr 28 2016 at 11:40am -0400,
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Thu, 2016-04-28 at 08:11 -0400, Mike Snitzer wrote:
> > Full disclosure: I'll be looking at reinstating bio-based DM multipath to
> > regain efficiencies that now really matter when issuing IO to extremely
> > fast devices (e.g. NVMe).  bio cloning is now very cheap (due to
> > immutable biovecs), coupled with the emerging multipage biovec work that
> > will help construct larger bios, so I think it is worth pursuing to at
> > least keep our options open.

Please see the 4 topmost commits I've published here:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-4.8

All request-based DM multipath support/advances have been completly
preserved.  I've just made it so that we can now have bio-based DM
multipath too.

All of the various modes have been tested using mptest:
https://github.com/snitm/mptest

> OK, but remember the reason we moved from bio to request was partly to
> be nearer to the device but also because at that time requests were
> accumulations of bios which had to be broken out, go back up the stack
> individually and be re-elevated, which adds to the inefficiency.  In
> theory the bio splitting work will mean that we only have one or two
> split bios per request (because they were constructed from a split up
> huge bio), but when we send them back to the top to be reconstructed as
> requests there's no guarantee that the split will be correct a second
> time around and we might end up resplitting the already split bios.  If
> you do reassembly into the huge bio again before resend down the next
> queue, that's starting to look like quite a lot of work as well.

I've not even delved into the level you're laser-focused on here.
But I'm struggling to grasp why multipath is any different than any
other bio-based device...

FYI, the paper I reference in my "dm mpath: reinstate bio-based support"
commit gets into what I've always thought the real justification was for
the transition from bio-based to request-based.
