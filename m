From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [usb-storage] Re: PATCH: exclude certain commands from emulated
 SCSI hosts
Date: Wed, 09 Apr 2003 17:45:04 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E93CF80.5050904@torque.net>
References: <20030408132949.36191.qmail@web21103.mail.yahoo.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:39434 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S262879AbTDIHdX (for <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Apr 2003 03:33:23 -0400
List-Id: linux-scsi@vger.kernel.org
To: p.lavarre@ieee.org
Cc: linux-usb-devel@lists.sourceforge.net, usb-storage@one-eyed-alien.net, linux-scsi@vger.kernel.org

Pat LaVarre wrote:
>>From: Patrick Mansfield [mailto:patmans@us.ibm.com]
>>Sent: Mon 4/7/2003 4:33 PM ...
>>
>>Besides the current b/w listed items (except for
>>the BLIST_INQUIRY_36/58 flags), we have:
>>
>>... too long an INQUIRY request,
>>... report back wrong INQUIRY length
>>... don't like EVPD INQUIRY
> 
> 
> And more.  Talk like Windows means say -x "12 0 0 0 24
> 0" -i x24 // op x12 Inquiry for 36, nothing else, at
> least until broken 64-bit motherboards force us to x20
> or x28.
> 
> 
>>Why can't usb storage conditionally modify the
>>INQUIRY to request no more than 36 bytes
>>(allocation length), and modify any results to be
>><= 36 (additional length)?
> 
> 
> sd.c isn't the only client of usb storage.
> 
> In particular, we need to hold on to some way of
> letting sg pass thru op x12 Inquiry arbitrary enough
> to copy In the vendor-specific data out past 36 bytes.
>  Or to copy In the Ans-specified data out there that
> lets an SFF/ ANSI MMC compliant device report an
> attempt to comply simultaneously with the somewhat
> contradictory ANSI SPC.
> 
> No?

Pat,
The sg policy is basically "you want, you got it" **. Andre
Hedrick found out that in some dark corner of the ATA
instruction set it was possible to overspeed an ATA disk.
He proposed filtering out that instruction but the linux-kernel
list consensus was not to do that.

Back to one of my favourite subjects: replacing the emulated
flag with a protocol identifier. Table 237 in section 8.5
(Protocol Specific parameters) of a recent SPC-3 draft
has a table of transport protocol identifiers:
   0      Fibre Channel
   1      Parallel SCSI
   2      SSA
   3      IEEE 1394
   4      RDMA (infiniband)
   5      Internet SCSI
   6      SAS
7-15     reserved

Perhaps we could borrow 15 for ATAPI and 14 for USB mass storage
and we should have current transports covered. As for the OO
encapsulation counter argument, the transport protocol _is_
significant for parts of the SCSI command set (see SAM-3 and
SPC-3) as well as device identification/discovery, async
error notification ....

So then we could associate a "quality of implementation" metric
with each protocol and program defensively within the kernel
accordingly.  For those using the pass through  interface (i.e.
sg [and the SG_IO ioctl now in the block layer]) it remains
'caveat emptor'.

There are many other uses for a protocol identifier: a "bus scan"
based device discovery on protocol 5 doesn't make much sense.


** There is a little magic inside sg's SG_IO ioctl that
only allows through non-modifying SCSI commands (e.g. INQUIRY
and READ) when a file is opened O_RDONLY.

Doug Gilbert




