From: Pat LaVarre <p_lavarre@yahoo.com>
Subject: RE: [usb-storage] Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: Wed, 9 Apr 2003 08:08:59 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030409150859.59908.qmail@web21107.mail.yahoo.com>
Reply-To: p.lavarre@ieee.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web21107.mail.yahoo.com ([216.136.227.109]:59713 "HELO
	web21107.mail.yahoo.com") by vger.kernel.org with SMTP
	id S263485AbTDIO5U (for <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Apr 2003 10:57:20 -0400
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: p.lavarre@ieee.org, linux-usb-devel@lists.sourceforge.net, usb-storage@one-eyed-alien.net, linux-scsi@vger.kernel.org

> From: Douglas Gilbert [mailto:dougg@torque.net]
> Sent: Wed 4/9/2003 1:45 AM
>
> Back to one of my favourite subjects: replacing the
> emulated flag with a protocol identifier ...

In short:  How about removing the emulated flag
altogether?  Answered at a link somewhere, right?

At length ...

> > In particular, we need to hold on to some way of
> > letting sg pass thru ... arbitrary enough
>
> The sg policy is basically "you want, you got
> it" ... [except] a little magic inside ...
> O_RDONLY ...

Glad to find we celebrate the value of utterly
transparent pass thru.

I trust we're all aware that passing intact thru sg
doesn't guarantee passing intact thru
drivers/usb/storage/.

I remember in particular seeing byte 2 of op x12
Inquiry being helpfully changed, also I remember
hearing of op x25 Read Capacity data being helpfully
changed on occasion.

> Back to one of my favourite subjects: replacing the
> emulated flag with a protocol identifier ...

How about removing the emulated flag altogether?

I ask because I find this topic (falsely?) familiar.

Personally I've mostly done the device side of Scsi.

Host folk periodically ask me to teach the device to
identify what protocol it uses.

Trouble is, my device doesn't really know.

Is my device really a parallel SCSI device?  Or is my
device parallel SCSI behind a mostly transparent
USB/SCSI bridge?  Or is my device an ATAPI device
behind a mostly transparent FireWire/ATAPI bridge?
Or ...?

In all my (sharply limited) experience the host folk
in question are mistakenly associating with protocol a
natural and growing variation in the actual device
response to CDB's and Data.

> As for the OO encapsulation counter argument, the
> transport protocol _is_ significant for parts of
> the SCSI command set (see SAM-3 and SPC-3)
> as well as device identification/discovery, async
> error notification ....

I look forward to my education.

Maybe nowadays we should not mention SAM-3 and SPC-3
without also mentioning MMC-4, which I see redefines
elements of SPC-3 to recognise, at last at ANSI, some
of the more prominent binary incompatibilities first
propagated via SFF, such as the op x12 Inquiry data
and the op x5A ModeSense10 CDB.

> There are many other uses for a protocol
> identifier: a "bus scan" based device discovery on
> protocol 5 doesn't make much sense.

Aye, many uses.

For example, a particular mostly transparent PCI/ATAPI
South bridge might be known to scramble copies of
anything but multiples of 8 data bytes.

Where that limitation is known, we could tell the
layers above to jump thru hoops to try and avoid that
case.

Unless we'd rather code to the least common
denominator always.

> Fibre Channel, Parallel SCSI, SSA, IEEE 1394,
> RDMA (infiniband), Internet SCSI, SAS, ...
> ATAPI ... USB ...

I know some folk pass SCSI thru the legacy PC printer
port ... does that fit in here, or is that an N-th
protocol?

> possible to overspeed an ATA disk ...
> proposed filtering ...
> consensus ... not ...

Also good to hear, thanks for talking, Pat LaVarre

P.S. Please ignore Yahoo spam that follows, if any.

__________________________________________________
Do you Yahoo!?
Yahoo! Tax Center - File online, calculators, forms, and more
http://tax.yahoo.com
