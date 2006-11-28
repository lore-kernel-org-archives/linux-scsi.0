From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Disable SCSI-Reservation at the driver level ?
Date: Tue, 28 Nov 2006 14:23:46 -0500
Message-ID: <456C8CC2.5000006@torque.net>
References: <0ca701c71178$528eb3a0$eeeea8c0@aldipc> <1164563196.13612.3.camel@localhost.localdomain>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:64156 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S936050AbWK1TXw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Nov 2006 14:23:52 -0500
In-Reply-To: <1164563196.13612.3.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: roland <devzero@web.de>, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Sun, 2006-11-26 at 17:31 +0100, roland wrote:
>> VMWare ESX refuses to create VMFS Filesystem on SATA disk, attached to a 
>> onBoard SAS controller (lsi1068).
>> When i raid1 two SATA disks, it works, if i use a single SATA disk, the 
>> controller seems to "expose" the disk differently to the operating system 
>> and creation of a VMFS fails due to missing ability to issue SCSI 
>> reservation command.
> 
> There's no SCSI fix for this ... the SAT has no translation for the SCSI
> reservation commands, largely because there's no corresponding ATA
> equivalent and even for SCSI devices they may fail anyway.  The
> application should cope with such a failure, so in this case it's the
> application that needs fixing.

SAT originally did have persistent reservations and it
was dropped and is back on the agenda for SAT-2. A SAT
layer (such as the one found in libata) can do more
that just translate command, it may also emulate SCSI
commands.

And PERSISTENT RESERVE IN and OUT (and maybe the older
RESERVE and RELEASE) would be very good candidates for
emulation. To do this however libata would need to be
a lot more transport aware than it is now. To do such
an emulation a SAT layer needs to know:
  a) whether it has full control over the SATA device
     (i.e. there is no other path to it) and failing
     that, it has some other mechanism such as
     affiliations in SAS with SMP available to control
     them
  b) the identity of the initiator (port) asking for
     the reservation.

If libata could do this it would add a lot of value
over and above simple command translation.

Doug Gilbert


