From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [linux-usb-devel] Re: Unaligned scatter-gather buffers and
 usb-storage
Date: Thu, 20 Nov 2003 00:06:58 +0200 (EET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0311192331370.2166@kai.makisara.local>
References: <20031110095914.B22518@beaverton.ibm.com> <20031118143720.A6411@beaverton.ibm.com>
 <20031119084729.GA1106@suse.de> <200311191401.34540.oliver@neukum.org>
 <20031119130400.GG1106@suse.de> <1069252642.10768.7.camel@mulgrave>
 <20031119143901.GI1106@suse.de> <1069253904.10768.13.camel@mulgrave>
 <20031119150011.GJ1106@suse.de> <Pine.LNX.4.58.0311191854560.2166@kai.makisara.local>
 <20031119201952.GT1106@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep02-0.kolumbus.fi ([193.229.0.44]:10163 "EHLO
	fep02-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S264024AbTKSWHA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Nov 2003 17:07:00 -0500
In-Reply-To: <20031119201952.GT1106@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Oliver Neukum <oliver@neukum.org>, Patrick Mansfield <patmans@us.ibm.com>, Alan Stern <stern@rowland.harvard.edu>, Douglas Gilbert <dougg@torque.net>, SCSI development list <linux-scsi@vger.kernel.org>, USB development list <linux-usb-devel@lists.sourceforge.net>

On Wed, 19 Nov 2003, Jens Axboe wrote:

> On Wed, Nov 19 2003, Kai Makisara wrote:
...
> > As usual, I am against this 512-byte alignment (thinking as st
> > maintainer). Don't default to more strict aligment requirements than is
> > necessary. It creates hidden performance problems for character device
> > drivers.
>
> But you have to honor hardware restrictions, though. Where is the
> performance impact?
>
Yes, I agree that we must not try to do things the hardware does not
allow. On i386, most SCSI adapter accept any alignment. It is a waste to
require 512-byte alignment with these adapters just because USB requires
that. I think there should be a way for the high-level drivers to know
about the absolutely necessary alignment requirements for the actual
adapter being used with a device.

If the user buffer is not aligned according to the required rules, the
driver must copy the data into a temporary buffer for i/o. This consumes
bandwidth and with the current faster tape drives this leads to
significant waste of cpu cycles (according to measurements).

The software using tapes tends to malloc() the buffers and then the
alignment is not guaranteed to 512 byte boundaries. Other Unices don't
have alignment requirements for tape buffers and I think we should avoid
requiring this in Linux if possible.

Someone may think that this is theory. I checked one common low-end backup
program tar (from SuSE 9.0). In the first test (tar cb 64 xxx) the user
buffer address was 0806e508 except in one write it was 08051000. A test
with dd gave the address 0806e508. cpio used the addresses 0806e508 and
08057cd8.

-- 
Kai
