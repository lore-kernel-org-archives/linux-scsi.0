From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Open for adoption: orphan sbp2_target
Date: Thu, 24 Aug 2006 14:19:54 +0200
Message-ID: <44ED996A.4010009@s5r6.in-berlin.de>
References: <5b45756a0608141057s6c00d7cfu388d9d342c5e936d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:41902 "EHLO
	hp3.statik.tu-cottbus.de") by vger.kernel.org with ESMTP
	id S1751192AbWHXMXu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Aug 2006 08:23:50 -0400
In-Reply-To: <5b45756a0608141057s6c00d7cfu388d9d342c5e936d@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hani Mustafa <hani.mustafa@gmail.com>
Cc: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, FUJITA Tomonori <tomof@acm.org>, Mike Christie <michaelc@cs.wisc.edu>

Hani Mustafa wrote to linux1394-devel on 2006-08-14:
> I had finished writing an sbp2_target implementation in the linux
> kernel a year or so ago and was hoping I could get the time to polish
> it, but it got stuck in a vicious procrastination loop.
> 
> The implementation worked fine with a usb-storage device (as it
> appears as a SCSI device) against windows/linux/mac, but otherwise
> panics the kernel when it is a real SCSI controller. Probably
> something wrong with the way I acquire and post CDB's to the SCSI
> device.
> 
> In anycase, if anyone has the motivation to toss this project from the
> ears into a working module, you are more than welcome to contact me
> directly.

Perhaps you are aware of Manish Singh's SBP-2 target implementation
called Endpoint, http://oss.oracle.com/projects/endpoint/. I haven't
tested it myself yet. AFAIU it runs completely in userspace on top of
libraw1394 and implements (only?) RBC. It is available under GPL.

An alternative in-kernel implementation might be interesting
nevertheless because /a/ performance optimization might be easier and
/b/ it could perhaps be adapted to the upcoming generic SCSI target
framework,
http://kernel.org/git/?p=linux/kernel/git/jejb/scsi-target-2.6.git .
This framework pushes parts of the required functionality into userspace
though. I didn't look into the particular goals and features of this
framework yet. Maybe I am wrong and the SBP-2 specific parts to add to
the SCSI target framework would rather end up in userspace, I don't know.

Could someone of the SCSI target folks give a rough outline of a SCSI
target's building blocks when using this framework?

As for taking over maintenance of your SBP-2 target implementation, I
could be a fitting person as I closely watch what is going on with the
1394 drivers and at least losely watch what the SCSI guys are up to. My
ratio of interest in an SBP-2 target to spare time is currently very low
though, therefore I would not do any actual development during at least
the next few months. But I would certainly at least be able to keep the
sources integrated with the current 1394 drivers and kernel
infrastructure. I would certainly make it publicly available in the form
as I do with any other current ieee1394 updates:
http://me.in-berlin.de/~s5r6/linux1394/

I would keep it as an external patch for the time being (i.e. won't
submit it to mainline or even to -mm) until integration with the SCSI
target framework has been evaluated and, if possible and reasonable,
started.

If you want to hand the SBP-2 target code over to me, I need you to
release it under GPL (or compatibly to GPL so that I and other people
can release derivative work under GPL) and to assure that you have the
rights to do so. (cf. linux/Documentation/SubmittingPatches section 11)
-- 
Stefan Richter
-=====-=-==- =--- ==---
http://arcgraph.de/sr/
