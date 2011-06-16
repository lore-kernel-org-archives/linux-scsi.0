From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/3] [RFC] genhd: add a new attribute in device
 structure
Date: Thu, 16 Jun 2011 16:31:29 -0400
Message-ID: <1308256290.2436.143.camel@mulgrave>
References: <20110615081610.2237.44767.stgit@ltc233.sdl.hitachi.co.jp>
	 <20110615081627.2237.9620.stgit@ltc233.sdl.hitachi.co.jp>
	 <20110615153337.GA10160@kroah.com> <4DF9F11F.705@hitachi.com>
	 <20110616154129.GA31498@kroah.com> <1308239454.2436.34.camel@mulgrave>
	 <20110616161442.GA32113@kroah.com> <1308241506.2436.44.camel@mulgrave>
	 <20110616181943.GB1439@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38597 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757724Ab1FPUbd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Jun 2011 16:31:33 -0400
In-Reply-To: <20110616181943.GB1439@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Nao Nishijima <nao.nishijima.xt@hitachi.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kay.sievers@vrfy.org, jcm@redhat.com, hare@suse.de, stefanr@s5r6.in-berlin.de, yrl.pp-manager.tt@hitachi.com

On Thu, 2011-06-16 at 11:19 -0700, Greg KH wrote:
> On Thu, Jun 16, 2011 at 12:25:06PM -0400, James Bottomley wrote:
> > On Thu, 2011-06-16 at 09:14 -0700, Greg KH wrote:
> > > > All userspace naming will be taken care of by the usual udev rules, so
> > > > for disks, something like /dev/disk/by-preferred/<fred> which would be
> > > > the usual symbolic link.
> > > 
> > > No, udev can not create such a link after the preferred name is set, as
> > > it has no way of knowing that the name was set.
> > 
> > It can if we trigger a uevent.  Note: I'm not advocating this ... I'd be
> > equally happy having whatever sets the kernel name create the link (or
> > tickle udev to create it).  We definitely require device links, though,
> > to get this to work.
> 
> And no, I don't want to trigger a uevent, Kay pointed out where this
> will go very wrong very quickly if this is done.

As I said: we just need a by-preferred type of link.

> > > This will ensure that kernel output and udev input are consistent.  It
> > > > will still require that user space utilities which derive a name for a
> > > > device will need modifying to print out the preferred name.
> > > 
> > > It also doesn't solve the issue of userspace wanting to use such a
> > > "preferred" name in the command line of tools, as there will not be a
> > > link back to the "kernel" name directly in /dev/.
> > 
> > Right ... most tools use the name they're given (and all variants
> > including the preferred one have links in /dev), which means they will
> > show the preferred name by default (if they were given that name as
> > input).  The only problem is tools that attempt to derive a device name,
> > which is quite a small subset.
> 
> Douglas pointed out that those tools look in /dev/ which would not work
> properly for this type of thing.

Not all tools try to deduce the name ... most just use what they're
given.  So some tools need changing, but it's by no means all tools.

> > > So as userspace tools will still need to be fixed, I don't see how
> > > adding a kernel file for this is going to help any.  Well, a bit in that
> > > the kernel log files will look "different", but again, that really isn't
> > > a problem that userspace couldn't also solve with no kernel changes
> > > needed.
> > 
> > This is true, but I think for the small effort it takes to implement the
> > feature in-kernel compared with what we'd have to do to the
> > distributions to get it implemented in userspace (we'd need klogd to do
> > the conversion for dmesg ... I'm entirely unclear what we need to modify
> > for /proc/partitions, etc.) the benefit outweighs the cost.
> > 
> > Additionally, since renaming is something users seem to want (just look
> > at net interfaces), if we can make this work, we now have a definitive
> > answer to point people at.
> 
> Renaming is something that we do NOT want to do, as we have learned our
> lesson of the network device renaming mess.  And as Kay pointed out, we
> already have an "alias" name there, which no one uses.

Look at this as an opportunity to get it right.  The original proposal
was for renaming.  By iterating over the actual requirements, we have it
reduced to simply having the kernel print a preferred name.  I think
that's a nice achievement which we can point other proponents of
renaming to as they arise.

> So again, I really don't like this, just fix the userspace tools to map
> the proper device name that the kernel is using to the userspace name
> the tool used, and all is fine.  This has been done already today,
> succesfully, by many of the big "enterprise" monitoring systems that
> work quite well on Linux, proving that this is not something that the
> kernel needs to provide to implement properly.

Well, it's expediency.  Sure we could try to patch the world, but I
think the simple patch of getting the kernel to print a preferred name
solves 90% of the problem.  Sure there is a long tail of userspace
components that needs fixing, but that can be done gradually if we take
the kernel route.  If we go the userspace route, it will be a long while
before we even get to 50% coverage.

James


