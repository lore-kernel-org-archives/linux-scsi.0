From: Douglas Gilbert <dougg@torque.net>
Subject: SAS overview
Date: Tue, 16 Mar 2004 21:46:31 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4056E917.7050502@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:24580 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S261181AbUCPLqH
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Mar 2004 06:46:07 -0500
Received: from torque.net (d-232-251.stlucia.uq.net.au [203.101.232.251])
	by bunyip.cc.uq.edu.au (8.12.10/8.12.10) with ESMTP id i2GBk2ZE021546
	for <linux-scsi@vger.kernel.org>; Tue, 16 Mar 2004 21:46:03 +1000 (GMT+1000)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Serial Attached SCSI (SAS) is projected to become available
later this year. Many of the usual suspects that supply the
parallel SCSI world have recently been making SAS product
announcements. See http://www.scsita.org .

Also on that site is an instructive 10 part tutorial by
Rob Elliot on various aspects of SAS. SAS borrows a lot
from SATA (and Fibre Channel) and is designed for
internal storage (as is SATA and it uses the same plugs
and cables) and "near" external storage (up to around
10 metres away). Even though the Ultra 640 standard
(SPI-5) is ratified it seems that vendors are going to
bypass it and go to SAS.

A SCSI domain is a set of SCSI initiators and targets (at
least one of each) interconnected by a service delivery
subsystem. In the SCSI Parallel Interface (SPI) the service
delivery subsystem is passive: a multi-drop cable. In SAS
the service delivery subsystem is either a cable (e.g. a
SATA cable) or one or more expanders. Over 16000 SAS
initiators and targets can be interconnected by a set of
expanders in a single SAS domain. To simplify routing,
multiple paths between SAS initiators and targets within
a single SAS domain are not allowed. This leads to some
interesting topologies (see question 1 of Rob Elliot's
tutorial after you understand wide links).

The unit of serial communication is a "phy". The current
generation of SATA phys run at 1.5 Gb/sec while the SAS
phys run at 3.0 Gb/sec. [A byte is encoded in 10 bits in
the serial stream so for maximum megabyte/sec throughputs,
just divide by 10.] The SAS standard shows expanders with
optional SAS-SATA bridges and SATA phys. The standard
defines the STP protocol for tunnelling the ATA/ATAPI
command set through the SAS infastructure. Evidentally
there are autosensing phys that can have either a SAS or
SATA disk connected to them. It seems as though the first
generation of SAS HBAs will also have this capability.

SAS initiators, targets and expanders are identified by SAS
addresses which are a (world wide unique ?) 64 bit number
(naa==5). From what I read typical SAS elements will have
the following:
   SAS HBA:      4 phys, 1 SAS address
   SAS disk:     2 phys each with a separate SAS address
                 (dual ported)
   Expander:     3 or (usually) more phys, 1 SAS address **
   SATA disk:    1 (SATA) phy, SAS address??

Now things start to get interesting. SAS can aggregate
individual phy interconnects to form "wide" links. So
if two (single phy) cables are run from a HBA (occupying
two of its phys) to phys on the same expander then that
is a wide link. Seen from Linux driving that HBA that is
two PCI devices (each HBA phy) but only one SCSI initiator
port. Up to 256 phy interconnects can be ganged to make
a very wide SAS link (a parallel bus you might say).

On the other hand if those two HBA phys were cabled to the
two phys on a SAS disk then that would _not_ be a wide link
since the two phys at the SAS disk end do _not_ have the same
SAS address. Further it is two SAS domains since the two
narrow links are separate service delivery subsystems.

Hopefully any errors I have made above will be corrected by
those who have practical experience with SAS. The SAS
architectural overview tutorial (url given above) has
diagrams to illustrate.

Linux implementation thoughts:
   - SAS addresses are 64 bit and correspond to the Linux
     SCSI id (i.e. third item of <host,channel,id,lun> tuple)
     which is currently 32 bit
   - wide links break the one to one relationship between
     PCI devices (i.e. a phy) and a SAS initiator.
   - SAS introduces a SAS Management Protocol (SMP) for
     discovery and configuring SAS expanders and attached
     devices. SAS expanders are not SCSI devices yet they
     need to be addressable from the user space for
     discovery and configuration to be offloaded from the
     LLD to user space programs. Perhaps a new role for the
     scsi generic driver (with a guard of 'M' rather than
     'S')??


Notes:
  **  The SAS standard permits an expander to have multiple
      SAS addresses: the mandatory one for SMP routing
      purposes and optional ones for embedded devices such
      as bridges and enclosure services devices.

   -  some SAS disks will have a 2.5" form factor
   -  as I write the www.scsita.org is down, hopefully it
      is a temporary outage. The (latest draft before) the
      SAS standard is at www.t10.org


Doug Gilbert

