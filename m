From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [dm-devel] dm-mpath: always return reservation conflict
Date: Mon, 26 Sep 2016 12:06:24 -0700
Message-ID: <1474916784.2765.64.camel@HansenPartnership.com>
References: <1470141392-25479-1-git-send-email-hch@lst.de>
         <1470141392-25479-2-git-send-email-hch@lst.de>
         <20160811183832.GA27144@lst.de> <20160815130829.GA14829@redhat.com>
         <20160815134039.GA5569@redhat.com> <20160926165230.GA5787@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:37586 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S941581AbcIZTG2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Sep 2016 15:06:28 -0400
In-Reply-To: <20160926165230.GA5787@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, dm-devel@redhat.com, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Mon, 2016-09-26 at 09:52 -0700, Christoph Hellwig wrote:
> Getting back to this after Hannes recovered from his vacation
> and I had a chat with him..
> 
> On Mon, Aug 15, 2016 at 09:40:39AM -0400, Mike Snitzer wrote:
> > Seems we still need a more sophisticated approach.  But I'm left
> > wondering: if we didn't do it would anything notice?  Sadly, the
> > same
> > big question from the original thread from a year ago:
> 
> Yes.  I have a customer looking to push the pNFS SCSI layout into
> a product, and the major show stopper right now is that we can
> trivially get into failver loops without this (or and equivalent)
> fix.
> 
> A year ago SCSI layout was still work in progress in the IETF,
> people use the similar block layout instead that doesn't use
> PRs and we also didn't have the in-kernel PR API, so you effectively
> couldn't use PRs with multipathing.
> 
> > https://patchwork.kernel.org/patch/6797111/
> > 
> > > So this is throw-away for now (and I'll get Hannes' patch applied
> > > for
> > > 4.8-rc3, with the tweak of returning -EBADE immediately):
> > 
> > Unfortunately, I'm _not_ staging Hannes' patch until I have James
> > Bottomley's Ack (given his original issues with the patch haven't
> > been
> > explained away AFAICT).
> 
> I've added James to the Cc.  His argument was that the old behavior
> could be implemented to use some non-standard use of reservations
> without a specific example.  I don't really think his example even
> is practical - once we use dm-mpath it exclusively claims the 
> underling block devices, so any sort of selective reservations would 
> have had to happen before even starting dm-multipath.

Well, now that you've made me reread the thread from 14 months ago that
wasn't quite my objection.  The objection hinged on the fact that
anything that uses path specific reservations would now fail instead of
retrying on a different path.  I thought the IBM SVC did this and
Hannes implied he'd be able to check this ... did anyone check?  If
we've checked and there's no issue with the SVC, then I don't have any
other objections.

>   So a dynamic SAN controller would have to tear down and rebuild the
> dm-multipath setup at all the time.

That was the job of the SVC: it sat in the middle of the SAN and
controlled which node saw what storage.

https://www.ibm.com/support/knowledgecenter/STPVGU/com.ibm.storage.svc.console.720.doc/svc_svcovr_1bcfiq.html

The SVC can issue its own reservations in those circumstances.  What
I'm not at all clear on is whether they'll interact badly with the dm
-mp reservations.

James

