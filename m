From: Doug Maxey <dwm@maxeymade.com>
Subject: Re: [RFC] mode pages for ATA/ATAPI devices via libata
Date: Fri, 13 May 2005 01:03:45 -0500
Message-ID: <200505130603.j4D63jCX020390@falcon30.maxeymade.com>
References: <428438EB.6050400@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from falcon30.maxeymade.com ([24.173.215.190]:27085 "EHLO
	falcon30.maxeymade.com") by vger.kernel.org with ESMTP
	id S262252AbVEMGFa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 May 2005 02:05:30 -0400
In-reply-to: <428438EB.6050400@torque.net> 
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Doug Maxey <dwm@maxeymade.com>, Patrick Mansfield <patmans@us.ibm.com>, Jeff Garzik <jgarzik@pobox.com>, Albert CC Lee <albertcc@tw.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>


On Fri, 13 May 2005 15:19:39 +1000, Douglas Gilbert wrote:
>Doug Maxey wrote:
>> ahem, the neural pathways are not just worn, they have become ruts. =) 
>> 
>> s/mode/vpd/.
>> 
>> On Wed, 11 May 2005 13:01:25 CDT, Doug Maxey wrote:
>> 
>>>Howdy,
>>>
>>>When a ATA/ATAPI device is attached via libata, what should the handling 
>>>be for mode pages that do not exist in the device?
>>>
>>>Assuming the page being asked for is 0x83, should libata fake up the
>>>page from the IDENTIFY (PACKET) DEVICE data?  Or should it just respond
>>>there is no page 0x83 as it does now in INQUIRY?  Likewise for 0x80?
>
>Doug,
>For ATAPI, the packet interface is almost always
>carrying a SCSI command set (exceptions anybody??),

call it 95% SCSI, and I will agree.

>typically MMC (for CD/DVD drives). Recent SPC-3 drafts
>(to which MMC-4,5 should comply) have made the device
>identification VPD page (0x83) mandatory. I haven't
>seen any compliance yet (or for that matter a drive that
>implements feature 0x108: LU serial number).

I have recently been looking at the specs for a rebranded Panasonic
Slimline DVD/RAM/+R/+RW drive.  The EVPD bit on the inquiry page is marked
as optional, but returns CHECK CONDITION if set, and you get a 5/24/00
back. :-/  So even if the device had the pages, we can't get to them.
Nowhere in the device spec is there an indication they even exist.

Of the few ATAPI drive specs I have seen, this seems to be the standard 
behavior.  The data (serial number, anyway), is ostensibly available 
from the IDENTIFY DEVICE data.  However, the bytes available are 
invariably smashed to a sequence of 0x20.

Lastly, looking at a recent version of MtFuji 6.08, support for the EVPD bit
is optional.  I just suspect it's one of those things that is interpreted
as a MUST NOT implement in the cost conscious manufacturing environment. 
Nor are there any references to VPD data other than the Standard 
INQUIRY data.

>
>For ATA, work is being done on a SCSI-ATA Translation
>draft standard see:
>http://www.t10.org/ftp/t10/drafts/sat/sat-r03.pdf
>section 8.1.3.3 .
>

Ah yes, the other 90% of ATA.  But that is just for disks.

The optical drive vendors seem to pretty closely follow
ftp://ftp.avc-pioneer.com/Mtfuji_6/Spec/Fuji6r08.pdf

>Doug Gilbert
>

++doug

