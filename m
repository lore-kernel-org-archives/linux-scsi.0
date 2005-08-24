From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] libata: write cache and read ahead
Date: Wed, 24 Aug 2005 21:03:49 +1000
Message-ID: <430C5415.5000603@torque.net>
References: <43085209.50405@torque.net> <430914C2.8030301@pobox.com> <43095EB3.2020202@torque.net> <430BAFD3.9000702@adaptec.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:16361 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S1750808AbVHXLDl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Aug 2005 07:03:41 -0400
In-Reply-To: <430BAFD3.9000702@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, Tejun Heo <htejun@gmail.com>

Luben Tuikov wrote:
> On 08/22/05 01:12, Douglas Gilbert wrote:
> 
>>I was surprised how much code needed changing.
>>With MODE SELECT's issues with libata addressed
>>various other SAT "extras" should be much easier
>>to implement. That should make libata more attractive
>>as a SAT layer for SAS LLDDs (that don't do it already
>>in firmware).
> 
> 
> Doug, how about never needing a SAT layer for SAS LLDDs
> for ATA/ATAPI devices.

Well that might make things easier for the SAS LLDD
driver writer but may not change things a lot
upstream.

The primary target for SAT is a layer within SAS
enclosures/expanders sitting between a SATA
transport with one or more SATA disks at the other
end and SSP. Evidently SSP has advantages over STP
in this role. Further, SATL isolating SATA devices from
a multi-initiator SAS fabric, can manage SCSI tags
from multiple initiators and map them onto the SATA
disk's NCQ tags.
Basically SATL adds value at that level. [It is also
a useful document to improve all those horrible USB/1394
mass storage SCSI translation layers out there (but
I'm not holding my breath)].

So from the point of view of a SAS LLDD, SATA disks
(LUs) will appear both via STP and SSP.

> Would you object if I "give" you a "domain device" to which
> you can send FISes (+ the packet if ATAPI) through
> a SAM-4 intefrace: Execute Task + TMFs?

Well that is what CSMI (SDI) does and I think we will
be implementing its functionality one way or another ;-).
I just checked SDI and it allows the STP_PASSTHROUGH
to be replaced by a SAT (like) emulation. That is when
the SDI_STP_PASSTHROUGH ioctl can return SDI_SCSI_EMULATION
which tells the user to go away and use the SAT like
interface :-). That is why I said that it may not change
things a lot upstream.

As for ATAPI, 99% of the time it is conveying MMC set.
With BD and HD-DVD coming down the line, app writers
in that space probably won't want to worry about
transport issues any more than they absolutely need to.
SAT defines a "ATA information" VPD page (0x89) which
conveys back the response to IDENTIFY DEVICE (for
non-packet devices) or IDENTIFY PACKET DEVICE. SAT
also defines 12 byte and 16 bytes ATA PASSTHROUGH
SCSI commands which would be handy for smartmontools.

Looking at SAT draft, I would suggest that it is an immature
state, being work in progress (most recent teleconference:
yesterday). And libata is trailing SAT by a good bit.
And libata needs to slide over something like you are
suggesting to be useful in the SAS context.

I intend to take up the issue of SMP in another post.


Doug Gilbert



