From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: 2.6.6 + Adaptec I2O
Date: Tue, 1 Jun 2004 15:52:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189FAD5159@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:641 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S265184AbUFATw2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Jun 2004 15:52:28 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@muc.de>
Cc: Matthew Wilcox <willy@debian.org>, linux-scsi@vger.kernel.org

The driver reports that if it is an x86_64, that it is an Intel based
processor that is *not* an i686 driver. It replaces PROC_PENTIUM with
PROC_SEXIUM. Isn't this what you want? Or is it the *name* of this bit
that offends you?

>From the management tool's perspective, the x86-64 driver is identical
to the i686 driver without this bit of information. This driver responds
to 32 bit (legacy and/or remote) management application. The
applications are given the clue that the driver is different via the
PROC_SEXIUM dptsig information. In fact, if we did not touch adding the
bit, the applications would be tricked into thinking they are talking to
a pure i686 driver.

I believe you are reading far too much into the significance of
utilizing this `sub processor class' bit in the management ioctl
channel; and certainly into the significance of this change.

Chose to not make this change, then the management applications
blissfully are reporting incorrect information about the driver.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: Andi Kleen [mailto:ak@muc.de] 
Sent: Tuesday, June 01, 2004 3:26 PM
To: Salyzyn, Mark
Cc: Matthew Wilcox; Andi Kleen; linux-scsi@vger.kernel.org
Subject: Re: 2.6.6 + Adaptec I2O

> The management tools could (but doesn't for linux, this is for sake of
> argument) report the driver was built for an i386 processor, yet we
> could be running on an i686 kernel. Other drivers from DPT/Adaptec for
> other operating systems have the same ioctl call populated with the
same
> information.

Sounds useless to me. At least for linux you would need to report
a lot more than what you currently do to figure out if the driver
is compatible to a given kernel.

 e.g. how the kernel was built (with SMP, without, with PREEMPT etc., 
with what compiler etc.) See what the linux module loader checks.
In addition the distribution vendor may be needed.

Also PROC_SEXIUM is definitely wrong then since an x86-64 driver
is completely different from a i686 driver.

-Andi
