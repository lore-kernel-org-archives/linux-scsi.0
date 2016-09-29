From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-mpath: always return reservation conflict
Date: Thu, 29 Sep 2016 11:01:33 -0400
Message-ID: <20160929150132.GA31965@redhat.com>
References: <1470141392-25479-1-git-send-email-hch@lst.de>
 <1470141392-25479-2-git-send-email-hch@lst.de>
 <20160811183832.GA27144@lst.de>
 <20160815130829.GA14829@redhat.com>
 <20160815134039.GA5569@redhat.com>
 <20160926165230.GA5787@infradead.org>
 <1474916784.2765.64.camel@HansenPartnership.com>
 <9f7ee494-1432-90ad-55e2-dbd223cd7bf3@suse.de>
 <1475002249.2716.31.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37698 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932897AbcI2PBe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Sep 2016 11:01:34 -0400
Content-Disposition: inline
In-Reply-To: <1475002249.2716.31.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Tue, Sep 27 2016 at  2:50pm -0400,
James Bottomley <James.Bottomley@hansenpartnership.com> wrote:

> On Tue, 2016-09-27 at 08:34 +0200, Hannes Reinecke wrote:
> > On 09/26/2016 09:06 PM, James Bottomley wrote:
> > > On Mon, 2016-09-26 at 09:52 -0700, Christoph Hellwig wrote:
> > > > Getting back to this after Hannes recovered from his vacation
> > > > and I had a chat with him..
> > > > 
> > > > On Mon, Aug 15, 2016 at 09:40:39AM -0400, Mike Snitzer wrote:
> > > > > Seems we still need a more sophisticated approach.  But I'm 
> > > > > left wondering: if we didn't do it would anything notice? 
> > > > >  Sadly, the same big question from the original thread from a
> > > > > year ago:
> > > > 
> > > > Yes.  I have a customer looking to push the pNFS SCSI layout into
> > > > a product, and the major show stopper right now is that we can
> > > > trivially get into failver loops without this (or and equivalent)
> > > > fix.
> > > > 
> > > > A year ago SCSI layout was still work in progress in the IETF,
> > > > people use the similar block layout instead that doesn't use
> > > > PRs and we also didn't have the in-kernel PR API, so you 
> > > > effectively couldn't use PRs with multipathing.
> > > > 
> > > > > https://patchwork.kernel.org/patch/6797111/
> > > > > 
> > > > > > So this is throw-away for now (and I'll get Hannes' patch 
> > > > > > applied for 4.8-rc3, with the tweak of returning -EBADE
> > > > > > immediately):
> > > > > 
> > > > > Unfortunately, I'm _not_ staging Hannes' patch until I have 
> > > > > James Bottomley's Ack (given his original issues with the patch
> > > > > haven't been explained away AFAICT).
> > > > 
> > > > I've added James to the Cc.  His argument was that the old 
> > > > behavior could be implemented to use some non-standard use of 
> > > > reservations without a specific example.  I don't really think 
> > > > his example even is practical - once we use dm-mpath it 
> > > > exclusively claims the underling block devices, so any sort of 
> > > > selective reservations would have had to happen before even
> > > > starting dm-multipath.
> > > 
> > > Well, now that you've made me reread the thread from 14 months ago 
> > > that wasn't quite my objection.  The objection hinged on the fact 
> > > that anything that uses path specific reservations would now fail
> > > instead of retrying on a different path.  I thought the IBM SVC did 
> > > this and Hannes implied he'd be able to check this ... did anyone 
> > > check?  If we've checked and there's no issue with the SVC, then I 
> > > don't have any other objections.
> > > 
> > > >   So a dynamic SAN controller would have to tear down and rebuild 
> > > > the dm-multipath setup at all the time.
> > > 
> > > That was the job of the SVC: it sat in the middle of the SAN and
> > > controlled which node saw what storage.
> > > 
> > > https://www.ibm.com/support/knowledgecenter/STPVGU/com.ibm.storage.
> > > svc.console.720.doc/svc_svcovr_1bcfiq.html
> > > 
> > > The SVC can issue its own reservations in those circumstances. 
> > >  What I'm not at all clear on is whether they'll interact badly 
> > > with the dm-mp reservations.
> > > 
> > In the end SVC is (for us) just another storage array.
> > If and what SVC does in the background is of no interest to us.
> 
> How can that be true?  It sits *on* the san and manages devices, it
> doesn't sit between the initators and the devices.  It applies
> reservations to devices under management, but every node usually sees
> everything else, so devices under SVC management are visible to all
> initators unless you zone them off.
> 
> The last SVC manual I saw included a procedure for manually releasing
> stuck SVC reservations from an initator, which illustrates the
> expectation.
> 
> > OTOH I'd be very surprised if the SVC would be allowing us to see
> > remnants of its internal working (like persistent reservation 
> > errors); in doing so third-party applications would be able to see 
> > and possibly modify these persistent reservations and the SVC would 
> > find itself in a very fragile operating scenario.
> 
> Because unless you zone the fibre, that's precisely what you do see.
> 
> > Also interactions with GPFS (which uses it's own set of reservations)
> > will become very tricky.
> > 
> > So I sincerely doubt we'll ever see SVC-originated persistent
> > reservations errors.
> > 
> > And as a side-note, this particular patch is included in SLES since
> > 2011. With no noticeable side-effect.
> 
> OK, so can you actually say that someone has tested this scenario?  If
> not, do you have the capacity to test it?

I've elected to just take this change for 4.9.  Please see:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.9&id=8ff232c1a819c2e98d85974a3bff0b7b8e2970ed
