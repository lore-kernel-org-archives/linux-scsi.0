From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/3] [RFC] genhd: add a new attribute in device
 structure
Date: Thu, 16 Jun 2011 12:25:06 -0400
Message-ID: <1308241506.2436.44.camel@mulgrave>
References: <20110615081610.2237.44767.stgit@ltc233.sdl.hitachi.co.jp>
	 <20110615081627.2237.9620.stgit@ltc233.sdl.hitachi.co.jp>
	 <20110615153337.GA10160@kroah.com> <4DF9F11F.705@hitachi.com>
	 <20110616154129.GA31498@kroah.com> <1308239454.2436.34.camel@mulgrave>
	 <20110616161442.GA32113@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110616161442.GA32113@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Nao Nishijima <nao.nishijima.xt@hitachi.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kay.sievers@vrfy.org, jcm@redhat.com, hare@suse.de, stefanr@s5r6.in-berlin.de, yrl.pp-manager.tt@hitachi.com
List-Id: linux-scsi@vger.kernel.org

On Thu, 2011-06-16 at 09:14 -0700, Greg KH wrote:
> On Thu, Jun 16, 2011 at 11:50:54AM -0400, James Bottomley wrote:
> > > And again, why not just fix the userspace tools?  That is trivial to do
> > > so and again, could have been done by now in the years this has been
> > > discussed.
> > 
> > So I can summarise where I think we are in these discussions:
> > 
> > We provide the ability to give all kernel devices a "preferred name".
> > By default this will be the device name the kernel would have originally
> > assigned.  the dev_printk's will use the preferred name, and it will be
> > modifiable from user space.  All the kernel will do is print out
> > whatever it is ... no guarantees of uniqueness or specific format will
> > be made.  Since we're only providing one preferred_name file, the kernel
> > can only have one preferred name for a device at any given time
> > (although it is modifiable on the fly as many times as the user
> > chooses).
> > 
> > The design is to use this preferred name to implement what Hitachi wants
> > in terms of persistent name, but we don't really care.
> > 
> > All userspace naming will be taken care of by the usual udev rules, so
> > for disks, something like /dev/disk/by-preferred/<fred> which would be
> > the usual symbolic link.
> 
> No, udev can not create such a link after the preferred name is set, as
> it has no way of knowing that the name was set.

It can if we trigger a uevent.  Note: I'm not advocating this ... I'd be
equally happy having whatever sets the kernel name create the link (or
tickle udev to create it).  We definitely require device links, though,
to get this to work.

> > This will ensure that kernel output and udev input are consistent.  It
> > will still require that user space utilities which derive a name for a
> > device will need modifying to print out the preferred name.
> 
> It also doesn't solve the issue of userspace wanting to use such a
> "preferred" name in the command line of tools, as there will not be a
> link back to the "kernel" name directly in /dev/.

Right ... most tools use the name they're given (and all variants
including the preferred one have links in /dev), which means they will
show the preferred name by default (if they were given that name as
input).  The only problem is tools that attempt to derive a device name,
which is quite a small subset.

> So as userspace tools will still need to be fixed, I don't see how
> adding a kernel file for this is going to help any.  Well, a bit in that
> the kernel log files will look "different", but again, that really isn't
> a problem that userspace couldn't also solve with no kernel changes
> needed.

This is true, but I think for the small effort it takes to implement the
feature in-kernel compared with what we'd have to do to the
distributions to get it implemented in userspace (we'd need klogd to do
the conversion for dmesg ... I'm entirely unclear what we need to modify
for /proc/partitions, etc.) the benefit outweighs the cost.

Additionally, since renaming is something users seem to want (just look
at net interfaces), if we can make this work, we now have a definitive
answer to point people at.

James
