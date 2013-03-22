From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 2/3] PCI: Handle device quirks when accessing sysfs
 resource<N> entries
Date: Fri, 22 Mar 2013 19:52:36 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402950DAF0FE@G9W0745.americas.hpqcorp.net>
References: <20130321043449.7229.81056.stgit@amt.stowe>
	<20130321043502.7229.43877.stgit@amt.stowe>	<514BAB13.3000101@gmail.com>
	<CAL-B5D2zJYPNYcCD3StXjnmQit5k05_Zp=cjeeqRLQkzb2g4UQ@mail.gmail.com>
	<CADLC3L33VbGGRPpVA2vUzE1KtT7ow5oTM0KCbSENo456dEYPUg@mail.gmail.com>
 <CAL-B5D3YHUsDfJS4spKkc7sTFM=e8ZwMcaiKoMfHnEdQQsHHBA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <CAL-B5D3YHUsDfJS4spKkc7sTFM=e8ZwMcaiKoMfHnEdQQsHHBA@mail.gmail.com>
Content-Language: en-US
Sender: linux-pci-owner@vger.kernel.org
To: Myron Stowe <myron.stowe@gmail.com>, Robert Hancock <hancockrwd@gmail.com>
Cc: Myron Stowe <myron.stowe@redhat.com>, "bhelgaas@google.com" <bhelgaas@google.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "yuxiangl@marvell.com" <yuxiangl@marvell.com>, "yxlraid@gmail.com" <yxlraid@gmail.com>, "greg@kroah.com" <greg@kroah.com>, "alex.williamson@redhat.com" <alex.williamson@redhat.com>, "kay@vrfy.org" <kay@vrfy.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



> On Fri, Mar 22, 2013 at 9:55 AM, Robert Hancock <hancockrwd@gmail.com>
> wrote:
> > On Fri, Mar 22, 2013 at 9:39 AM, Myron Stowe <myron.stowe@gmail.com>
> wrote:
> >> On Thu, Mar 21, 2013 at 6:51 PM, Robert Hancock
> <hancockrwd@gmail.com> wrote:
> >>> On 03/20/2013 10:35 PM, Myron Stowe wrote:
> >>>>
> >>>> Sysfs includes entries to memory regions that back a PCI device's BARs.
> >>>> The pci-sysfs entries backing I/O Port BARs can be accessed by userspace,
> >>>> providing direct access to the device's registers.  File permissions
> >>>> prevent random users from accessing the device's registers through these
> >>>> files, but don't stop a privileged app that chooses to ignore the purpose
> >>>> of these files from doing so.
> >>>>
> >>>> There are devices with abnormally strict restrictions with respect to
> >>>> accessing their registers; aspects that are typically handled by the
> >>>> device's driver.  When these access restrictions are not followed - as
> >>>> when a userspace app such as "udevadm info --attribute-walk
> >>>> --path=/sys/..." parses though reading all the device's sysfs entries - it
> >>>> can cause such devices to fail.
> >>>>
> >>>> This patch introduces a quirking mechanism that can be used to detect
> >>>> accesses that do no meet the device's restrictions, letting a device
> >>>> specific method intervene and decide how to progress.
> >>>>
> >>>> Reported-by: Xiangliang Yu <yuxiangl@marvell.com>
> >>>> Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
> >>>
> >>>
> >>> I honestly don't think there's much point in even attempting this strategy.
> >>> This list of devices in the quirk can't possibly be complete. It would
> >>> likely be easier to enumerate a white-list of devices that can deal with
> >>> their IO ports being read willy-nilly than a blacklist of those that don't,
> >>> as there's likely countless devices that fall into this category. Even if
> >>> they don't choke as badly as these ones do, it's quite likely that bad
> >>> behavior will result.
> >>
> >> For the device in question, it seems abnormally restrictive in its
> >> access limitations to BAR1 and BAR3.  The device reserves 4 Bytes of
> >> I/O Port space for these BARs, which is likely based on PCI's DWord
> >> based protocol, but "chokes (we still have not received any specifics
> >> on this yet)" on any access other than a single Byte access at offset
> >> 0x2 (x86 supports 1, 2, and 4 Byte I/O Port accesses).  This seems to
> >> imply that the device did not back the other three reserved Bytes it
> >> claims in any way, which again, seems peculiar to this particular
> >> device as other similar devices tend to back the reserved bytes they
> >> claim and return 0's when accessed.
> >
> > I don't think it's really that unusual. IO ports are weird, they're
> > not necessarily emulating any kind of normal memory - doing a 32-bit
> > access on IO port 0 isn't necessarily equivalent at all to doing
> > separate 8-bit accesses on IO ports 0, 1, 2 and 3 for example. They
> > can do completely different things. For legacy SFF ATA controllers,
> > IIRC most of the IO ports only expect 8-bit accesses other than the
> > PIO data register which can do 16 or 32-bit accesses (which just gives
> > you a different amount of data when doing different size reads from
> > the same location - it doesn't give you the data for the IO ports 2 or
> > 3 bytes ahead of that when doing a 32-bit read, like you might expect
> > if you were thinking of it like memory).
> 
> Very good point; I did have a more memory based mindset.
> 
> > So it's not too shocking that
> > the designer of these Marvell devices didn't pay too much attention to
> > what happens if you access the ports in an unexpected way.
> >
> > ...
> >>
> >> ...
> 
> So this suggests that we will never be able to deal with a userspace
> app accessing device registers in a unknowledgable, random, fashion -
> the exact situation we are currently in today.  We could get to the
> point of supporting UIO drivers, which would be more like device
> drivers and have intimate detailed knowledge of what they are driving
> and which would also introduce some of the mutual-exclusive ownership
> issues we have talked about, but not unknowing userspace apps.
> 

The PCI Express specification allows devices to choose what types of accesses they support to the 
IO or memory address spaces provided by their BARs:

Excerpt from PCI Express Base Specification 3.0 page 109:
" When a device's programming model restricts (vs. what is otherwise permitted in PCI Express) the
characteristics of a Request, that device is permitted to "Completer Abort" any Requests which
violate the programming model. Examples include unaligned or wrong-size access to a register
block and unsupported size of request to a Memory Space.

Generally, devices are able to assume a restricted programming model when all communication will
be between the device's driver software and the device itself. Devices which may be accessed
directly by operating system software or by applications which may not comprehend the restricted
programming model of the device (typically devices which implement legacy capabilities) should be
designed to support all types of Requests which are possible in the existing usage model for the
device. If this is not done, the device may fail to operate with existing software."

How the system handles errors like Completer Aborts will vary - NMIs, hangs, or even processing 
bogus data are all possible.

There are some baseline rules on configuration space accesses (so generic PCI topology software
can work with all PCI cards), but not IO and memory space.  It's prudent to not generate IO
or memory accesses you don't know are supposed to work.

---
Rob Elliott    HP Server Storage
