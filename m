From: "Falkinder, David Malcolm" <david.falkinder@hp.com>
Subject: RE: sg regression in 2.6.16-rc5
Date: Fri, 3 Mar 2006 20:24:25 -0000
Message-ID: <085C28F775E1B74F82122EF0975E6E76045F08E3@sdcexc02.emea.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sdcsmtp.europe.hp.net ([15.203.169.188]:5344 "EHLO
	sdcrelbas02.sdc.hp.com") by vger.kernel.org with ESMTP
	id S932159AbWCCUYD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2006 15:24:03 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: linux-scsi@vger.kernel.org, dougg@torque.net

Linus,

Got completely ignored last time, so time for some Linus stylee
directness ;-)
 
This thread has moved onto a discuss of transfer limits based entirely
upon "max_sectors"! It's cobblers. I'd love to hear how this applied to
a SCSI tape drive, or a SCSI scanner etc - it's a disk centric concept.

With no disrespect intended, disks are pretty dumb - use largely fixed
transfer sizes, and but a small subset of the SCSI command set. You're
not considering the "bigger picture".

To succinctly re-iterate - you're breaking functionality (albeit an
exploited defect), without providing a timeline / plan for it's
restoration. Again I don't disagree with the plan to make this change in
the medium term, once the lower levels provide large transfer
capability.

Surely the length of this thread is indicative of a need to go for a
third option to the current in or out plans.


	Regards,

	|\
	|/ave
 
-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Linus Torvalds
Sent: 03 March 2006 20:10
To: Jeff Garzik
Cc: Steve Byan; Mark Lord; Matthias Andree; Douglas Gilbert; Mark
Rustad; linux-scsi@vger.kernel.org; Linux Kernel Mailing List
Subject: Re: sg regression in 2.6.16-rc5



On Fri, 3 Mar 2006, Jeff Garzik wrote:
> 
> 256 max sectors IDE driver, 200 max sectors libata (due to driver not 
> hardware).

When I said "lower due to broken hw" I was more thinking about things
like the SiIimage driver, which actually limits the rqsize to 15 sectors
due to some strange hw interactions with seagate SATA devices.

(It will then raise it back up to 128 if it's not a Seagate SATA drive.
I forget what the exact issue was. Some strange corruption in some
limited case, and not allowing big requests worked around it. There's
some strange IDE quirks out there...).

			Linus
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org More majordomo info
at  http://vger.kernel.org/majordomo-info.html
