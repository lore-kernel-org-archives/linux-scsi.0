From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] aacraid changes for 2.4.24 kernel to add support of AMD64 (part 1)
Date: Fri, 13 Feb 2004 22:58:36 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040213225835.A21467@infradead.org>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F2552B7@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:55051 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S267289AbUBMW6j (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Feb 2004 17:58:39 -0500
Content-Disposition: inline
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189F2552B7@otce2k03.adaptec.com>; from mark_salyzyn@adaptec.com on Fri, Feb 13, 2004 at 05:27:36PM -0500
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>

> [MGS] We have found commands issued to the controller with no callback
> function under some conditions. Admittedly this may only happen on older
> kernels (?) and sneaks in here, but I would need to test a 2.4.24 kernel
> under those conditions to prove that this code was not needed. What is
> wrong, the fact we need to perform this check, or the check itself?
> Adaptec is paranoid, the test costs little.

	If you get a NULL pointer in here it's a serious bug in an upper
	layer.  That means a) it should get fixed there and b) the system
	should panic ASAP by dererferencing it instead of continuing to
	run and possible corrupting data.
	So no, Adaptec is not beeing paranoid here but rather ACKs the
	problem wit a printk and continues as usual.

> As for the lock, this code is simply moved up from another area of the
> driver so that a prototype was not necessary to head it off. A code
> change to drop the locks introduces risks that can be dealt with in a
> later patch. The code works (in smp environments) reliably, I would be
> nervous to remove the locks as that was not under the prevue of the many
> AMD64 changes required.

	Okay, let's wait for the next patch then..

> 	The num_physpages check is wrong.  There's machines with
> 	non-continguous memory where you can get addresses bigger than
> 	32bits with less than 4 GB of memory.
> 
> [MGS] The driver functions better in a 32 bit environment as we can load
> up more scatter gather elements. Although I agree there is this
> inaccuracy, the cost of bounce buffers in such an environment is a small
> cost to pay for the improved performance options available through the
> ability to retune the driver for larger requests.

	Indeed it would be a good idea to ket pci_set_dma_mask with a > 32
	bit argument fail when the box will never have that big dma addresses.
	But the way you do it in the driver is plain wrong.  Care to send
	a kernel patch to do this right?

> 	This is copletely broken.  a scsi LLDD doesn't know about device
> 	names, it sits below the midlayer.
> 
> [MGS] The Applications depend on this function in order to report device
> linkages. This above code exists in the driver already and was simply
> moved elsewhere because of a restructuring of code. We will need to
> figure out a means to fix this code at another time.

	Then your application is broken.  In Linux 2.4 any number of
	upperlevel drivers can attach to a scsi_device.  And you can
	even replace the disk driver with one of your own if you want.
	It just means someone at Adaptec didn't understand layering.
	You should ask Justin for CAM talk ;-)

> [MGS] I know, and I keep on pushing back because we have *much* more
> serious problems if the applications can not determine if the device is
> busy. We must block the users from making changes to arrays, or causing
> rescans, when the devices are busy, or if the system is dealing with
> error recovery. This code helps us reduce the number of panics users
> experience when they `play' with the arrays. The fact that this code is
> racy is inconsequential; we are dealing with user initiated actions that
> have timeframes of activities that are lengthy enough that the window of
> opportunity for failure is low. Without the test, the window of
> opportunity of failure is *much* higher.

	What about completly stopping those user actions if they can't
	work reliably at all.  Really, the Linux 2.4 scsi stack is just
	not designed for any device reconfigurations.  I know this sucks
	but I didn't write that code.  I spent a lot of effort in Linux
	2.6 to fix up all those races from hell.

