From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] New QStor SATA/RAID Driver for 2.6.9-rc2
Date: Wed, 15 Sep 2004 14:22:36 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4147C38C.3000104@torque.net>
References: <414711AC.5030200@rtr.ca> <41471A84.4090200@pobox.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:59873 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S267386AbUIOEX2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Sep 2004 00:23:28 -0400
In-Reply-To: <41471A84.4090200@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, Mark Lord <lsml@rtr.ca>
Cc: linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> Mark Lord wrote:
> 
>> My first attempt at posting this seems to have gone AWOL,
>> so here it comes again.  Also being posted to linux-scsi.
>>
>> Here is the first public release of the 2.6.xx driver
>> source code for the Pacific Digital Corporation QStor SATA/RAID chip.
>>
>> This 4-channel chip has hardware-assisted RAID0/RAID1/RAID10,
>> host-queuing, per-request TCQ/NCQ support, support for hot insertion
>> and removal of drives, etc..  The 64-bit/66Mhz chip shows throughput
>> in excess of 200MByte/sec on my ancient P3-1GHz test system,
>> and can do much better when installed in a PCI-X slot.
> 
> 
> How much of the RAID is actually hardware-assisted?
> 
> 
>> The driver (attached) supports most of the chip features,
>> including host, native and legacy tagged queuing,
>> but does not yet include boot-from-raid support (coming soon).
>>
>> Both hdparm and smartmontools are fully supported by this driver.

Mark,
I'm curious how smartmontools is supported. Does the driver
support SCSI LOG SENSE commands on the physical units or does
it take the 3ware/Marvell route?
There is no sign of QStor specific code in smartmontools's CVS.

> Linus vetoed future SCSI->ATA translators.  He only allowed libata 
> because I promised to remove the translation and make it a native block 
> driver in the future, which I have been working towards.

As Jeff is aware, SCSI->ATA translation (SAT) is in
the process of being standardized at t10.org . The
model being used outlines a SAT layer going into any
of three places:
   - in the host OS above a SATA/ATA HBA driver (i.e.
     what libata does and Linus frowns upon)
   - in the host OS above a SAS HBA driver which,
     amongst other protocols, has the SAS Tunnelling Protocol
     (STP) which conveys ATA/ATAPI7 commands through SAS
     infrastructure
   - somewhere in the service delivery subsystem, specifically
     in SAS expanders which have phys connected to SATA disks
     (Linus vetoes have no influence here)

Consider this pathological situation:
Start with one SATA II disk and connect it to a port selector
(a SATA II device) which effectively makes the SATA disk dual
ported. Connect one of those ports to a SATA HBA that lives
in the Linux ATA subsystem (where no SAT is allowed). Connect the
other port to a SAS expander which includes a SAT layer and then
connect that expander to a SAS HBA in the Linux SCSI subsytem.
That should confuse the !@#$ out of any application client
trying to get a handle on what is happening.

I assume that OS-based ATA->SCSI translation is also out of
the question.

Doug Gilbert
