From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/3] scsi: Move user-shareable stuff in scsi/scsi.h to
 uapi/scsi/scsi.h
Date: Fri, 09 Jan 2015 09:44:11 -0800
Message-ID: <1420825451.2064.12.camel@HansenPartnership.com>
References: <1420746479-25949-1-git-send-email-agrover@redhat.com>
	 <1420746479-25949-3-git-send-email-agrover@redhat.com>
	 <20150109101422.GA23804@lst.de>
	 <1420817266.2064.1.camel@HansenPartnership.com>
	 <20150109154613.GA29124@lst.de>
	 <1420818638.2064.5.camel@HansenPartnership.com>
	 <20150109160140.GA29372@lst.de>
	 <1420821180.2064.10.camel@HansenPartnership.com>
	 <20150109171148.GA17380@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:46427 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750922AbbAIRoN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jan 2015 12:44:13 -0500
In-Reply-To: <20150109171148.GA17380@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Andy Grover <agrover@redhat.com>, linux-scsi@vger.kernel.org

On Fri, 2015-01-09 at 18:11 +0100, Christoph Hellwig wrote:
> On Fri, Jan 09, 2015 at 08:33:00AM -0800, James Bottomley wrote:
> > Yes, but they have to be delivered to users somehow.  If you look at
> > debian, they deliver the headers through the linux-dev-libc package
> > which installs into the /usr/include directory.
> 
> linux-libc-dev despite the name is provided from the kernel source package:
> 
> https://packages.debian.org/sid/linux-libc-dev

I know ... I actually took a look in the source to see if they'd
commented why they weren't including any SCSI files ... it's not just
the clashing files, it's also things like scsi/fc.  The reason is that
glibc is slowly incorporating those.  So first question is: do we want
to supply the linux-libc-dev package or are we happy with the glibc
route?

> > Since glibc currently
> > owns the entirety of /usr/include/scsi, we have to help the distros
> > figure out how we deliver the headers, otherwise all uapi exports of
> > SCSI stuff just gets ignored ...
> 
> That's why I've been arguing for adding a new linux/scsi_ioctl.h header
> to bypass that whole conflict since my first mail in this thread.

If we go that route, I have a marginal preference for the linux/scsi/
namespace.  We still also need a co-existence and transition plan,
because if we don't export the opcodes, glibc is going to have to supply
them in scsi/scsi.h anyway and we're going to have to not clash with
some of its extraneous definitions, like device types, status codes and
some ioctls.

James


