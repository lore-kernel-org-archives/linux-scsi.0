From: Greg KH <greg@kroah.com>
Subject: Re: raid 5 creation fails on usb3 connected drives kernel 4.4.x, 4.5
Date: Sat, 16 Apr 2016 21:53:08 -0700
Message-ID: <20160417045308.GA9148@kroah.com>
References: <20160407144413.GD10853@kroah.com>
 <57067E1B.60706@westnet.com.au>
 <20160407155908.GA8655@kroah.com>
 <57077BC8.7010300@westnet.com.au>
 <20160408142435.GA4793@kroah.com>
 <5708D6F2.7000608@westnet.com.au>
 <20160416160840.GC10824@kroah.com>
 <1460823913.2333.3.camel@HansenPartnership.com>
 <20160416164623.GA3104@kroah.com>
 <5713140F.6070304@westnet.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:51256 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751217AbcDQE4N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 Apr 2016 00:56:13 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
	by mailout.nyi.internal (Postfix) with ESMTP id D35B320967
	for <linux-scsi@vger.kernel.org>; Sun, 17 Apr 2016 00:56:11 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <5713140F.6070304@westnet.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian Chadwick <brianchad@westnet.com.au>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>, James Bottomley <JBottomley@Odin.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Sun, Apr 17, 2016 at 02:41:51PM +1000, Brian Chadwick wrote:
> On 17/04/16 02:46, Greg KH wrote:
> > On Sat, Apr 16, 2016 at 09:25:13AM -0700, James Bottomley wrote:
> > > On Sat, 2016-04-16 at 09:08 -0700, Greg KH wrote:
> > > > On Sat, Apr 09, 2016 at 08:18:26PM +1000, Brian Chadwick wrote:
> > > > > On 09/04/16 00:24, Greg KH wrote:
> > > > > > On Fri, Apr 08, 2016 at 07:37:12PM +1000, Brian Chadwick wrote:
> > > > > > > On 08/04/16 01:59, Greg KH wrote:
> > > > > > > > On Fri, Apr 08, 2016 at 01:34:51AM +1000, Brian Chadwick
> > > > > > > > wrote:
> > > > > > > > > On 08/04/16 00:44, Greg KH wrote:
> > > > > > > > > > On Thu, Apr 07, 2016 at 03:04:55PM +1000, Brian Chadwick
> > > > > > > > > > wrote:
> > > > > > > > > > > On 06/04/16 19:53, Greg KH wrote:
> > > > > > > > > > > > On Tue, Apr 05, 2016 at 06:42:51PM +1000, Brian
> > > > > > > > > > > > Chadwick wrote:
> > > > > > > > > > > > > SETUP:
> > > > > > > > > > > > > 
> > > > > > > > > > > > > i7 16GB Computer.
> > > > > > > > > > > > > 
> > > > > > > > > > > > > 1 x PCI-x USB3 adaptor card (i think uses xhci
> > > > > > > > > > > > > -hcd)04:00.0 USB controller:
> > > > > > > > > > > > > Renesas Technology Corp. uPD720202 USB 3.0 Host
> > > > > > > > > > > > > Controller (rev 02)
> > > > > > > > > > > > >          Kernel driver in use: xhci_hcd
> > > > > > > > > > > > > 
> > > > > > > > > > > > > 2 x USB3 to dual SATA HDD docks. uses JMicron
> > > > > > > > > > > > > JMS56x Series controllers,
> > > > > > > > > > > > > uses uas.ko kernel module
> > > > > > > > > > > > > Bus 004 Device 002: ID 152d:9561 JMicron Technology
> > > > > > > > > > > > > Corp. / JMicron USA
> > > > > > > > > > > > > Technology Corp.
> > > > > > > > > > > > > Bus 004 Device 003: ID 152d:9561 JMicron Technology
> > > > > > > > > > > > > Corp. / JMicron USA
> > > > > > > > > > > > > Technology Corp.
> > > > > > > > > > > > > 
> > > > > > > > > > > > > 3 x Western Digital 320GB 3.5" SATA drives
> > > > > > > > > > > > > 
> > > > > > > > > > > > > USE:
> > > > > > > > > > > > > 
> > > > > > > > > > > > > RAID 5
> > > > > > > > > > > > > 
> > > > > > > > > > > > > KERNEL:
> > > > > > > > > > > > > 4.3.5
> > > > > > > > > > > > > 
> > > > > > > > > > > > > System works perfectly as expected.
> > > > > > > > > > > > > 
> > > > > > > > > > > > > 
> > > > > > > > > > > > > Change to kernel 4.4.x or 4.5 and RAID 5 doesnt
> > > > > > > > > > > > > work. I am not sure whether
> > > > > > > > > > > > > its actually RAID 5 at fault or if its the USB
> > > > > > > > > > > > > Attached SCSI driver uas.ko,
> > > > > > > > > > > > > or maybe the host driver xhci-hcd.
> > > > > > > > > > > > Can you run 'git bisect' to try to track down the
> > > > > > > > > > > > offending commit?
> > > > <instructions about git-bisect snipped>
> > > > 
> > > > > Hi, well to my surprise git bisect has come up with a commit about
> > > > > which I
> > > > > had no inkling. I may have to go to another mailing list it doesnt
> > > > > look like
> > > > > a usb problem.
> > > > > 
> > > > > This is the final output of 'git bisect view' :
> > > > > 
> > > > > 
> > > > > commit 64d513ac31bd02a3c9b69ef04444f36c196f9a9d
> > > > > Author: Christoph Hellwig<hch@lst.de>
> > > > > Date:   Thu Oct 8 09:28:04 2015 +0100
> > > > > 
> > > > >      scsi: use host wide tags by default
> > > > > 
> > > > >      This patch changes the !blk-mq path to the same defaults as the
> > > > > blk-mq
> > > > >      I/O path by always enabling block tagging, and always using
> > > > > host wide
> > > > >      tags.  We've had blk-mq available for a few releases so bugs
> > > > > with
> > > > >      this mode should have been ironed out, and this ensures we get
> > > > > better
> > > > >      coverage of over tagging setup over different configs.
> > > > > 
> > > > >      Signed-off-by: Christoph Hellwig<hch@lst.de>
> > > > >      Acked-by: Jens Axboe<axboe@kernel.dk>
> > > > >      Reviewed-by: Hannes Reinecke<hare@suse.de>
> > > > >      Signed-off-by: James Bottomley<JBottomley@Odin.com>
> > > > > 
> > > > > 
> > > > > 
> > > > > Thank you for your help in narrowing this down, and in educating me
> > > > > about
> > > > > git bisect (its a neat tool) ... I await your advice as how to
> > > > > proceed from
> > > > > here.
> > > > Sorry for the delay, nice work tracking down the problem.
> > > > 
> > > > Christoph, any ideas?  This patch is breaking this user's system as
> > > > described above.  Is there a more recent fix for this, or did
> > > > something
> > > > forget to get changed in the large patch you did here?
> > > If this is UAS connected devices, then this is likely the fix:
> > > 
> > > http://marc.info/?l=linux-scsi&m=146045685829613
> > Ah, nice, it's planned to go to Linus later today...
> > 
> > Brian, can you test that patch out to see if it resolves your issue or
> > not?
> > 
> > thanks,
> > 
> > greg k-h
> > 
> Hi Greg, that patch has resolved the issue; I tested in 4.4.7 and 4.5.1. I
> am not sure how to test in the git tree so I'll just wait for git pull to
> get the change.

This patch is in Linus's tree now and I'll suck it into the next release
of the 4.4 and 4.5-stable trees soon.

thanks for testing and letting me know it works,

greg k-h
