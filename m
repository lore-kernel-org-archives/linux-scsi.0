From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/3] PCI: Handle device quirks when accessing sysfs
 resource<N> entries
Date: Sat, 06 Apr 2013 09:49:24 +0100
Message-ID: <1365238164.2787.6.camel@dabdike>
References: <20130321043449.7229.81056.stgit@amt.stowe>
	 <20130321043502.7229.43877.stgit@amt.stowe> <514BAB13.3000101@gmail.com>
	 <CAErSpo4FajG4hz8ELinnFLjk_3j=gQpC9zi4jR6pi=qoOda5cg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55153 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932637Ab3DFIte (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Apr 2013 04:49:34 -0400
In-Reply-To: <CAErSpo4FajG4hz8ELinnFLjk_3j=gQpC9zi4jR6pi=qoOda5cg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Robert Hancock <hancockrwd@gmail.com>, Myron Stowe <myron.stowe@redhat.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Xiangliang Yu <yuxiangl@marvell.com>, xiangliang yu <yxlraid@gmail.com>, Greg Kroah-Hartman <greg@kroah.com>, "alex.williamson@redhat.com" <alex.williamson@redhat.com>, Kay Sievers <kay@vrfy.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Thu, 2013-04-04 at 12:06 -0600, Bjorn Helgaas wrote:
> On Thu, Mar 21, 2013 at 6:51 PM, Robert Hancock <hancockrwd@gmail.com> wrote:
> > On 03/20/2013 10:35 PM, Myron Stowe wrote:
> >>
> >> Sysfs includes entries to memory regions that back a PCI device's BARs.
> >> The pci-sysfs entries backing I/O Port BARs can be accessed by userspace,
> >> providing direct access to the device's registers.  File permissions
> >> prevent random users from accessing the device's registers through these
> >> files, but don't stop a privileged app that chooses to ignore the purpose
> >> of these files from doing so.
> >>
> >> There are devices with abnormally strict restrictions with respect to
> >> accessing their registers; aspects that are typically handled by the
> >> device's driver.  When these access restrictions are not followed - as
> >> when a userspace app such as "udevadm info --attribute-walk
> >> --path=/sys/..." parses though reading all the device's sysfs entries - it
> >> can cause such devices to fail.
> >>
> >> This patch introduces a quirking mechanism that can be used to detect
> >> accesses that do no meet the device's restrictions, letting a device
> >> specific method intervene and decide how to progress.
> >>
> >> Reported-by: Xiangliang Yu <yuxiangl@marvell.com>
> >> Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
> >
> >
> > I honestly don't think there's much point in even attempting this strategy.
> > This list of devices in the quirk can't possibly be complete. It would
> > likely be easier to enumerate a white-list of devices that can deal with
> > their IO ports being read willy-nilly than a blacklist of those that don't,
> > as there's likely countless devices that fall into this category. Even if
> > they don't choke as badly as these ones do, it's quite likely that bad
> > behavior will result.
> 
> I agree, I'm not inclined to add a bunch of code that only fixes one
> device when there are likely many others with similar problems.
> 
> > I think there's a few things that need to be done:
> >
> > -Fix the bug in udevadm that caused it to trawl through these files
> > willy-nilly,
> 
> We can argue about whether this is actually a bug in udevadm, but
> either way, my opinion is that the data that udevadm prints out from
> these files is uninteresting in the same way the data from "uevent,"
> "dev," "modalias," "resource," etc. is uninteresting.  So to me, a
> udevadm change seems justified for that reason.
> 
> > -Fix the kernel so that access through these files complies with the
> > kernel's mechanisms for claiming IO/memory regions to prevent access
> > conflicts (i.e. opening these files should claim the resource region they
> > refer to, and should fail with EBUSY or something if another process or a
> > kernel driver is using it).
> >
> > -Reconsider whether supporting read/write on the resource files for IO port
> > regions like these makes any sense. Obviously mmap isn't very practical for
> > IO port access on x86 but you could even do something like an ioctl for this
> > purpose. Not very many pieces of software would need to access these files
> > so it's likely OK if the API is a bit ugly. That would prevent something
> > like grepping through sysfs from generating port accesses to random devices.
> 
> This is the approach I'd like to push on for a kernel fix.

Me too.  I think the quirks approach is unsupportable.  Worst case I
think we should have an ability for the *driver* to mark the region as
having strange access rules.

>   I'm not a
> VM person, but if it were possible to support .mmap() in such a way
> that a handler would be called for every access to the region, we
> could easily support I/O port access that way.

We could ... the OS could trigger a page fault on every access using the
COW mechanism ... however, that mechanism wasn't intended for write
combining, so although it's theoretically possible to add it, I'd be a
bit wary.

> Along that line, I'm concerned that we may have a hole in the MEM BAR
> .mmap() path.  What happens if we have BARs from two different devices
> in the same page, and we mmap() one of them?  Does the user also get
> access to the second device's BAR on the same page?  If so, that could
> also be fixed with an .mmap() trap approach.  Performance would suck
> for these small BARs, of course.

Pure protections are done at the page level.  That said, you can emulate
offset protections by marking the page inaccessible in the CPU, which
causes a trap on every access.  Then you can mediate the write based on
its address.  That said, this is a bit complex and we don't really have
the mechanism for it.

James


