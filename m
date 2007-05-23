From: Douglas Gilbert <dougg@torque.net>
Subject: Re: SMART support for SATA drives in SAS enclosures
Date: Wed, 23 May 2007 15:49:23 -0400
Message-ID: <46549AC3.4090105@torque.net>
References: <46488711.9020903@macroscoop.nl>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:50096 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459AbXEWTye (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 May 2007 15:54:34 -0400
In-Reply-To: <46488711.9020903@macroscoop.nl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pim Zandbergen <P.Zandbergen@macroscoop.nl>
Cc: linux-scsi@vger.kernel.org

Pim Zandbergen wrote:
> Is SMART support available for SATA drives in SAS enclosures?
> 
> I'm testing this setup
> 
> LSI Logic SAS3800X PCI-X SAS controller (mptsas driver)
> Promise V-Trak J300S SAS/SATA enclosure/expander
> 12x Seagate ST3500630NS
> Linux kernel 2.6.21.1 x86_64
> smartmontools-5.37-1.1.fc6 from Fedora Core 6
> 
> "smartctl -i -d sat /dev/sdc" gives me
> 
> Smartctl: Device Read Identity Failed

I presume /dev/sdc is an actual disk rather than a
RAID device made up of several disks. The SAT standard
(and smartmontools) don't have a general way of
addressing individual disks behind RAID infrastructure.

For recent versions of smartmontools version 5.37 and
MPT Fusion SAS HBAs this should work if /dev/sdc is
a SATA disk. Your HBA may need a firmware upgrade.


You might fetch sg3_utils version 1.24 and try:
  sg_sat_identify /dev/sdc
That needs to work before smartctl has a hope.

> Same with "-d ata".
> 
> If I treat the disk as SCSI ("-d scsi"), the command
> will not fail, but wil only retrieve the serial number.

With MPT Fusion SAS hardware (that I have seen) the SAT
layer is in the HBA firmware. Only later versions of the
firmware support the SCSI ATA PASS-THROUGH command.

Doug Gilbert

