From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [RFQ] New driver architecture questions
Date: Thu, 14 May 2009 00:16:13 -0400
Message-ID: <4A0B9B0D.6080006@garzik.org>
References: <6C678488C5CEE74F813A4D1948FD2DC7A95E6D37@cosmail02.lsi.com>,<4A0B858F.3080405@garzik.org> <6C678488C5CEE74F813A4D1948FD2DC7A95E6D38@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:47459 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900AbZENEQR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 May 2009 00:16:17 -0400
In-Reply-To: <6C678488C5CEE74F813A4D1948FD2DC7A95E6D38@cosmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mukker, Atul" <Atul.Mukker@lsi.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Austria, Winston" <Winston.Austria@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Mukker, Atul wrote:
> Interesting answer :-)
> 
> But it definitely makes few things clear:
> 
> 1. The possibility definitely exists, if done right. We will review Intel's code and try to use as a reference.
> 2. Earlier the code is made public, more likely that it would stay on the "right" track.

Agreed!


> Are there known pitfalls we should guard against? Why's your focus on Linux "drivers"? Do you expect more than one?

Good questions :)  I use "drivers", plural, to illustrate how Linux 
maintainers attempt to take a whole-system approach to driver evaluation.

We have to consider the user experience, support and maintenance of 
multiple Linux drivers from multiple hardware vendors.

To pick an easy example in my area of expertise, every major vendor of 
[typically non-firmware-based] SATA controllers that I deal with, such 
as Intel, NVIDIA, Silicon Image, Promise and Marvell, ship a Windows 
driver that includes software code in the OS driver for
	* supporting their hardware controller
	* implementing software RAID levels 0, 1, and 5

This is fine because the hardware vendor is only concerned with their 
own hardware.

However, in Linux, we aim to maintain a consistent level of support 
_across_ multiple hardware vendors.  This is the same why the same 
driver, drivers/ata/ahci.c, is used for AHCI controllers from
	- Intel
	- NVIDIA
	- ULi
	- SiS
	- VIA
	- JMicron
	- Marvell
	- ACard/Artop

When a bug is fixed in the ahci.c driver, _all_ customers benefit from 
this bug fix.  When a new feature is added, _all_ customers benefit from 
a new feature.

Of course, if there is an NVIDIA-specific hardware feature, that does 
not apply to other hardware vendors, that is welcomed!  It is placed in 
an NVIDIA-specific driver module.

To pick another example, cross-OS layers from hardware vendor A, created 
in the past, have included workarounds for errata in system platforms 
from hardware vendor B.  In Linux, we typically put system workarounds 
in drivers/pci/quirks.c or arch/* so that the workaround is applied to 
all _systems_ that need it.  (of course, if the errata is truly specific 
only to A+B, then yes, the workaround should be in A's driver generally)

Additionally, minimizing duplicate code across hardware vendors 
MAXIMIZES TESTING across all Linux drivers.

In Linux, when there is a change to software RAID-5, it is instantly 
tested and verified across multiple hardware vendors, on multiple system 
architectures and technologies.


So, what does this mean for LSI?  In my humble opinion :)

1) A driver should be modular, in order to properly separate out 
hardware-specific and OS-specific pieces.  Taking drivers/net/e1000e as 
an example,

	hw.h		hardware-specific defines, ~cross-OS
	82571.c		code specific to 8257x chip family, ~cross-OS
	ich8lan.c	code specific to ICH8+ chip family, ~cross-OS
	netdev.c	core driver code, Linux-specific

A key engineering task is decomposing the driver into fine-grained, 
OS-specific OR hardware-specific operations.

Avoid large amounts of C pre-processor wrappers, and maximize use of 
native C types and enums.


2) Highly standardized, not-specific-to-LSI-hardware routines such as 
SAS discovery or software RAID5 XOR'ing should be separate from the 
driver itself.

This is very different from Windows!!

As an example, the Adaptec 94xx and Marvell 6440 drivers share the same 
SAS discovery code -- drivers/scsi/libsas, because discovery is 99% in 
the OS driver.

However, LSI's mpt2sas is more firmware-based, so more of the discovery 
process is found in hardware-specific drivers/scsi/mpt2sas.

Another example:  RAID5 and RAID6 algorithms in Linux have been 
hand-optimized for specific CPU architectures (drivers/md/raid6*). 
Implementing your own software RAID would decrease performance and 
eliminate the years of field testing performed on the existing code base.

For implementations of RAID that are largely firmware-based, most of the 
RAID implementation is found in microcontroller firmware.  This relieves 
you of the burden of driver code duplication.


3) Ensure that the userland Application Binary Interface (ABI) for your 
driver is consistent with other Linux drivers, for the same features.

If there is a feature NOT unique to LSI, attempt to maintain consistency 
with existing Linux driver APIs.

If the feature is LSI-specific, use your best design judgement.

This ensures that existing Linux tools work.


4) For reasons stated above, we are FORCED to consider your driver in 
the context of other Linux drivers from other hardware vendors.

The main reason, as I said, is to avoid code duplication.

Two implementations of software RAID 5 mean twice the bugs, and twice 
the support/maintenance costs for Linux maintainers and distributors.

It is unfortunate but true that Linux maintainers must consider when a 
chip reaches end-of-life support, or a hardware vendor goes out of 
business, and users still want to keep using their hardware.


Whew, that was long.  I hope this makes sense...

Regards,

	Jeff





