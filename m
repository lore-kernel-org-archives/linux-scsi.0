From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/3] [RFC] genhd: add a new attribute in device
 structure
Date: Thu, 16 Jun 2011 18:45:21 -0400
Message-ID: <1308264321.2436.161.camel@mulgrave>
References: <20110615081610.2237.44767.stgit@ltc233.sdl.hitachi.co.jp>
	 <20110615081627.2237.9620.stgit@ltc233.sdl.hitachi.co.jp>
	 <20110615153337.GA10160@kroah.com> <4DF9F11F.705@hitachi.com>
	 <20110616154129.GA31498@kroah.com> <1308239454.2436.34.camel@mulgrave>
	 <20110616161442.GA32113@kroah.com> <1308241506.2436.44.camel@mulgrave>
	 <20110616181943.GB1439@kroah.com> <1308256290.2436.143.camel@mulgrave>
	 <BANLkTikfCMR_=5Jp7tLhM_Wr3vxihEL+rA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:46956 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756522Ab1FPWpZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Jun 2011 18:45:25 -0400
In-Reply-To: <BANLkTikfCMR_=5Jp7tLhM_Wr3vxihEL+rA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>, Nao Nishijima <nao.nishijima.xt@hitachi.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jcm@redhat.com, hare@suse.de, stefanr@s5r6.in-berlin.de, yrl.pp-manager.tt@hitachi.com

On Fri, 2011-06-17 at 00:05 +0200, Kay Sievers wrote:
> On Thu, Jun 16, 2011 at 22:31, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > On Thu, 2011-06-16 at 11:19 -0700, Greg KH wrote:
> >> On Thu, Jun 16, 2011 at 12:25:06PM -0400, James Bottomley wrote:
> >> > On Thu, 2011-06-16 at 09:14 -0700, Greg KH wrote:
> 
> >> > > No, udev can not create such a link after the preferred name is set, as
> >> > > it has no way of knowing that the name was set.
> >> >
> >> > It can if we trigger a uevent.  Note: I'm not advocating this ... I'd be
> >> > equally happy having whatever sets the kernel name create the link (or
> >> > tickle udev to create it).  We definitely require device links, though,
> >> > to get this to work.
> >>
> >> And no, I don't want to trigger a uevent, Kay pointed out where this
> >> will go very wrong very quickly if this is done.
> >
> > As I said: we just need a by-preferred type of link.
> 
> And if the user changes the name, the link and all earlier uses will
> be dangling, even /proc/mounts might show non-existing device names.

I don't understand this.  If a user decides to call sda "fred" by doing
an echo to the preferred named file, then there should be a link

/dev/disk/by-preferred/fred -> ../../sda

Even if the name later changes to "angela", /dev/disk/by-preferred/fred
will be valid if we don't clean it up.

> I honestly don't think there will ever be _the_ name for a device.
> We've been there, stuff seems not to work that way in the real world.

So that's not really the point ... all we do with it in-kernel is use it
as the device name for log prints and some basic /proc files (again,
mainly as prints); nothing more.

> I really like to hear how stuff is supposed to compose _the_ name in a
> real world use-case like a multipath setup, in initramfs, in a heavy
> hotplug setup, and so on ... And with more details than "udev will set
> _the_ name", I really fail to see how that is supposed to happen to be
> useful.

All that really has to happen is that we get a database of 1:1
correspondence between preferred name and actual name (with device
links).

> I think any solution that assumes the name can change later after it
> is possibly already used, is just wishful thinking.

The ability to change on the fly isn't part of the original hitachi
proposal, but I don't really see why it can't ... it just alters the way
the kernel prints out the name, nothing more.

> We need many names, and we need all of them from the very beginning,
> and they should not change during device lifetime unless the device
> state changes.

So that's actually an argument for leaving the links, surely?  We can
have many inbound links, but the kernel can only print one name in
messages, which would be the preferred name that was currently set.

> >> > > So as userspace tools will still need to be fixed, I don't see how
> >> > > adding a kernel file for this is going to help any.  Well, a bit in that
> >> > > the kernel log files will look "different", but again, that really isn't
> >> > > a problem that userspace couldn't also solve with no kernel changes
> >> > > needed.
> >> >
> >> > This is true, but I think for the small effort it takes to implement the
> >> > feature in-kernel compared with what we'd have to do to the
> >> > distributions to get it implemented in userspace (we'd need klogd to do
> >> > the conversion for dmesg ... I'm entirely unclear what we need to modify
> >> > for /proc/partitions, etc.) the benefit outweighs the cost.
> >> >
> >> > Additionally, since renaming is something users seem to want (just look
> >> > at net interfaces), if we can make this work, we now have a definitive
> >> > answer to point people at.
> >>
> >> Renaming is something that we do NOT want to do, as we have learned our
> >> lesson of the network device renaming mess.  And as Kay pointed out, we
> >> already have an "alias" name there, which no one uses.
> >
> > Look at this as an opportunity to get it right.  The original proposal
> > was for renaming.  By iterating over the actual requirements, we have it
> > reduced to simply having the kernel print a preferred name.  I think
> > that's a nice achievement which we can point other proponents of
> > renaming to as they arise.
> 
> Sure, we absolutely don't want renaming, and we can provide countless
> solid technical reasons why we should not allow it to happen. But I'm
> also pretty sure, we also don't want just-another-single-name to put
> somewhere in the kernel.

I understand why we don't want renaming.  However, the technical reason
why we want a preferred name is that it's often associated with a name
printed somewhere on the box (say a label on the disk enclosure, or
ethernet port).  Not being able to use this name to address the device
is a usability issue which annoys the enterprise enormously.

So if we stop there, regardless of solution (in-kernel or fix all
userspace), does everyone see what the actual problem is?

> >> So again, I really don't like this, just fix the userspace tools to map
> >> the proper device name that the kernel is using to the userspace name
> >> the tool used, and all is fine.  This has been done already today,
> >> succesfully, by many of the big "enterprise" monitoring systems that
> >> work quite well on Linux, proving that this is not something that the
> >> kernel needs to provide to implement properly.
> >
> > Well, it's expediency.  Sure we could try to patch the world, but I
> > think the simple patch of getting the kernel to print a preferred name
> > solves 90% of the problem.  Sure there is a long tail of userspace
> > components that needs fixing, but that can be done gradually if we take
> > the kernel route.  If we go the userspace route, it will be a long while
> > before we even get to 50% coverage.
> 
> I need to ask again ask for an explanation why logging all symlinks at
> device discovery from udev, does not solve exactly this problem. With
> that tag in the syslog message stream, all later kernel names can be
> safely associated with _all_ the current device names in question,
> until the next tag from udev is found.

So if the user has one preferred name, us logging all the names (and we
have quite a few for disks) doesn't really help because the user might
want to choose a different name.  However, even if we assume they choose
one of the current names, they still have to do the mapping manually;
even if they have all the information, they can't just cut and paste
from dmesg say, they have to cut, edit the buffer to put in the
preferred name and then paste ... that's just one annoying step too far
for most users.  I agree that all the output tools within reason can be
fixed to do this automatically, but fixing cat say, just so
cat /proc/partitions works would never be acceptable upstream.

The reason for storing this in the kernel is just that it's easier than
trying to update all the tools, and it solves 90% of the problem, which
makes the solution usable, even if we have to update tools to get to
100%.

James


