From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] aacraid changes for 2.4.24 kernel to add support of AMD64 (part 1&2)
Date: Mon, 16 Feb 2004 16:59:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F25536F@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:36049 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S263868AbUBPV7d convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Feb 2004 16:59:33 -0500
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Additional comments enclosed below ^[MGS]. I do not know if I am
resubmitting, or if the patch will be partially applied with your
comments in consideration? (I suspect the former, but need confirmation
before I spend more engineering cycles).

I appreciate your feedback!

Sincerely -- Mark Salyzyn

-----Original Message-----
From: Christoph Hellwig [mailto:hch@infradead.org] 
Sent: Friday, February 13, 2004 6:04 PM
To: Salyzyn, Mark
Cc: linux-scsi
Subject: Re: [PATCH] aacraid changes for 2.4.24 kernel to add support of
AMD64 (part 2)

On Fri, Feb 13, 2004 at 05:37:44PM -0500, Salyzyn, Mark wrote:
> [MGS] The ioctl that utilizes this structure detects if the caller is
a
> 32 bit or a 64 bit application under the AMD64 environment, and tunes
> itself to the size of the fib element as necessary. I opted to use the
> redefinition of this structure as a means to simplify the split
> personality code that utilizes this structure.
> 
> In a 32 bit environment, there is no need to detect if the caller is a
> 32 bit or a 64 bit application, so the smaller fib element is all that
> is needed.

	Well..  What about ia64 or ppc64 or mips64 or..?  There's much
	more than PCs out there. 

[MGS] Currently management tool support for ia64, ppc64, mips64 or
xscale lag behind. Since the tools are proprietary Adaptec, HP or Dell;
you won't find binaries that serve your purpose (save for the recent
release of aeventd). The Lack of management ioctl support will come in
time I promise!!

> [MGS] Without any test of busy status at all, we run the *high* risk
of
> a panic resulting from a stack overflow. This code is here because of
a
> broken error recovery in the scsi layer resulting in infinite
recursion
> under some sensitive activities.

	You mean the thing rmk fixed?  If that's still not in 2.4 it's
	rather sad indeed..  If you mean something else please explain
	it to the list, a patch would be even better.

[MGS] Admittedly I may be behind the curve. The code Adaptec maintains
must compile on 2.4.2 to 2.4.23 (Linux Distro). Not sure how to
reconcile this, I do not have enough testing resources to chase if the
problem has been resolved. The patch should not contain such paranoia
(to expose deficiencies) perhaps. I have been bit before by producing
workarounds to hide deficiencies, only to have the problems fester when
not observed. Although I wish I had time to fix scsi layer bugs, I still
have to make (or rather hack) the driver function with RH7.3 too.

I apologize if I mix legacy 2.4 with bleeding edge 2.4. I have *not*
tested if this issue continue in the current 2.4 tree.

> Fix the scsi layer, and this code can go away.

	Some cooperation from vendors could also help ;-)

[MGS] If you knew how few clones I have, you'd laugh the kind of laugh
only heard on Armand Schaubroeck vinyl.

> [MGS] Ok, tell me how to rescan for a device? The RAID drivers cause
> asynchronous device changes that need to be reported to the scsi
layer.
> The scan_scsis call is hidden, so we *must* use the proc write to get
to
> it.

	DO NOT DO IT.  Even from userland.  /proc/scsi/scsi's dubious
	scan interface existing is more than bad enough and a _big_
	mistake from the people writing the original linux scsi code.
	But at least we canb blame it on those peopl brave enough.

	But in addition top the rescan beeing bogus opening files from
	kernelspace and writing to them is simply not allowed.

[MGS] I'll have to continue to maintain a schizophrenic source, the
kernel.org variant missing management functionality I guess :-(. I
understand my folly and my station, I *need* the scsi list to filter the
code for any legacy fixes from creeping in.

> Or do you mean the arrangements for register_ioctl32_conversion?
Because
> other drivers do not have 32 bit applications calling a 64 bit ioctl
for
> RAID management functions. The current structure of the x86_64 port in
> the 2.4 tree is to block 32 bit applications from calling the ioctl
> without these arrangements.

	There's quite a lot of drivers using register_ioctl32_conversion
	that don't seem to need it.  But I don't have an x86-64 box so
	don't ask me for details.  It just looked more than strange..

[MGS] You need to register them to pass into the driver, otherwise they
are blocked (tested w/2.4.21-4.EL). Most probably just register blindly,
which would have worked except for the `one' GET_NEXT_ADAPTER_FIB call
in the aacraid driver that needed a virtual address in the packet (the
32/64 bit thingy you commented about).


-----Original Message-----
From: Christoph Hellwig [mailto:hch@infradead.org] 
Sent: Friday, February 13, 2004 5:59 PM
To: Salyzyn, Mark
Cc: Christoph Hellwig; linux-scsi
Subject: Re: [PATCH] aacraid changes for 2.4.24 kernel to add support of
AMD64 (part 1)

> [MGS] We have found commands issued to the controller with no callback
> function under some conditions. Admittedly this may only happen on
older
> kernels (?) and sneaks in here, but I would need to test a 2.4.24
kernel
> under those conditions to prove that this code was not needed. What is
> wrong, the fact we need to perform this check, or the check itself?
> Adaptec is paranoid, the test costs little.

	If you get a NULL pointer in here it's a serious bug in an upper
	layer.  That means a) it should get fixed there and b) the
system
	should panic ASAP by dererferencing it instead of continuing to
	run and possible corrupting data.
	So no, Adaptec is not beeing paranoid here but rather ACKs the
	problem wit a printk and continues as usual.

[MGS] Oakely Dokely

> As for the lock, this code is simply moved up from another area of the
> driver so that a prototype was not necessary to head it off. A code
> change to drop the locks introduces risks that can be dealt with in a
> later patch. The code works (in smp environments) reliably, I would be
> nervous to remove the locks as that was not under the prevue of the
many
> AMD64 changes required.

	Okay, let's wait for the next patch then..

[MGS] I am confused. Since I was moving the code unmodified to drop a
prototype definition, I simply highlighted an existing problem. OR are
you accepting that the dropping of the locking code is acceptable for a
future patch?

> 	The num_physpages check is wrong.  There's machines with
> 	non-continguous memory where you can get addresses bigger than
> 	32bits with less than 4 GB of memory.
> 
> [MGS] The driver functions better in a 32 bit environment as we can
load
> up more scatter gather elements. Although I agree there is this
> inaccuracy, the cost of bounce buffers in such an environment is a
small
> cost to pay for the improved performance options available through the
> ability to retune the driver for larger requests.

	Indeed it would be a good idea to ket pci_set_dma_mask with a >
32
	bit argument fail when the box will never have that big dma
addresses.
	But the way you do it in the driver is plain wrong.  Care to
send
	a kernel patch to do this right?

[MGS] Schizophrenic sources aside, this is worth considering, but will
it not break other drivers?

> 	This is copletely broken.  a scsi LLDD doesn't know about device
> 	names, it sits below the midlayer.
> 
> [MGS] The Applications depend on this function in order to report
device
> linkages. This above code exists in the driver already and was simply
> moved elsewhere because of a restructuring of code. We will need to
> figure out a means to fix this code at another time.

	Then your application is broken.  In Linux 2.4 any number of
	upperlevel drivers can attach to a scsi_device.  And you can
	even replace the disk driver with one of your own if you want.
	It just means someone at Adaptec didn't understand layering.
	You should ask Justin for CAM talk ;-)

[MGS] Not sure if I am the one to defend this, an action to fix this
will follow. The application does it's best to help the users. The
Inaccuracies have not been noticed by the current user base, or someone
in the past declared that the inaccuracies are corner cases.

> [MGS] I know, and I keep on pushing back because we have *much* more
> serious problems if the applications can not determine if the device
is
> busy. We must block the users from making changes to arrays, or
causing
> rescans, when the devices are busy, or if the system is dealing with
> error recovery. This code helps us reduce the number of panics users
> experience when they `play' with the arrays. The fact that this code
is
> racy is inconsequential; we are dealing with user initiated actions
that
> have timeframes of activities that are lengthy enough that the window
of
> opportunity for failure is low. Without the test, the window of
> opportunity of failure is *much* higher.

	What about completly stopping those user actions if they can't
	work reliably at all.  Really, the Linux 2.4 scsi stack is just
	not designed for any device reconfigurations.  I know this sucks
	but I didn't write that code.  I spent a lot of effort in Linux
	2.6 to fix up all those races from hell.

[MGS] The pressures put to bear on me (fix it, or stop ship) say
otherwise. I think there is a dead horse here solved by me acquiescing
to LDN here, and BHD at my day job.

