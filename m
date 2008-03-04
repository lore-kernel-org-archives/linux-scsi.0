From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 7/8] SCSI: add a field to scsi_device to count open
	file references
Date: Tue, 04 Mar 2008 10:52:50 -0600
Message-ID: <1204649571.3091.36.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0803041101200.4039-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42843 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751980AbYCDQw4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Mar 2008 11:52:56 -0500
In-Reply-To: <Pine.LNX.4.44L0.0803041101200.4039-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 2008-03-04 at 11:16 -0500, Alan Stern wrote:
> On Mon, 3 Mar 2008, James Bottomley wrote:
> 
> > On Mon, 2008-03-03 at 18:04 -0500, Alan Stern wrote:
> > > On Mon, 3 Mar 2008, James Bottomley wrote:
> > > 
> > > > On Mon, 2008-03-03 at 15:16 -0500, Alan Stern wrote:
> > > > > This patch (as1050) adds a new field to struct scsi_device, to keep a
> > > > > count of the number of block-device open file references.  This count
> > > > > will be used by usb-storage to determine whether USB-PERSIST should be
> > > > > forced on during a suspend.
> > > > 
> > > > I don't think this does what's advertised if you mean it to keep a count
> > > > as the atomics seem to imply. (->open is only called on first open and
> > > > ->release on last close.  openers was a historical 2.4 field that used
> > > > to count opens but now just flags whether sd is open or not.
> > > 
> > > Um.  The real purpose of that field is to let usb-storage know whether 
> > > or not the device is open at all.  I used a count because that seemed 
> > > like the only way to do it; it doesn't matter if the count value 
> > > doesn't exactly match the actual number of open file references.
> > 
> > OK, so your change log is "whether the device is open" not "a count of
> > openers".
> 
> Yes, sort of.  That is, the new field is used just for its "whether the 
> device is open" meaning, but the only way to keep track of that is to 
> count the calls to the open and release methods.
> 
> BTW, is it really accurate to say that this isn't a count of the
> openers?  I guess it depends on what you mean by "opener".  IIUC, every
> system call to open(2) will go through the driver's open method and
> thus increment the count, whereas calls to dup(2) or dup2(2) will not.  
> It that correct, or is there a stronger distinction at work?

I thought I already explained that it didn't in the previous email, in
the bit quoted above.

---

> > > > > I don't think this does what's advertised if you mean it to keep a count
> > > > > as the atomics seem to imply. (->open is only called on first open and
> > > > > ->release on last close.  openers was a historical 2.4 field that used
> > > > > to count opens but now just flags whether sd is open or not.

---

If you want to see for yourself, it's fs/block_dev.c:do_open().

> > > > Secondly, if you really want an openers count (which I remember SCSI
> > > > rendering a bad idea ages ago), that's held in struct block_device as
> > > > openers, isn't it?  So there's no need to duplicate this in SCSI.
> > > 
> > > But there's no way to get to the block_device structure if all you're 
> > > given is the scsi_device, right?  You would have to know something 
> > > special about it, such as whether it is a disk, a CD, or something 
> > > else.  This is intended to be generic.
> > 
> > OK, but then the obvious question is why this isn't at the block device
> > layer?  It doesn't seem right that we'd have a shadow (and not a very
> > effective one) of bdev->openers just so you can access it from a
> > scsi_device.  We had a similar problem with the AHCI AN patches which
> > were solved by altering the layered accesses.
> 
> Well then, how would you solve the problem?  Given a pointer to the 
> scsi_host, we need to know whether there are any block-device files 
> open for any of the SCSI devices beneath it.  Ideally we would like to 
> know strictly if there are any exclusive opens, but merely knowing 
> about any kind of open device file would be good enough.

OK, but this is the problem.  Shadowing information held at a higher
layer because you can't get at that layer sounds like some type of
layering problem in the code.

The exclusive open information is also held at the block device
structure in the bd_holder/bd_holders fields.

> If you can suggest an alternative approach, I'll be glad to change the
> patch.

Well, since this is the 7th patch of an eight patch series, I don't
really have the context for that.  However, I assume it's all on the
linux-usb list?  If so, I'll add it to my list of things to look at.

James


