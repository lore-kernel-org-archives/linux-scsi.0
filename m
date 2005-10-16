From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Adaptec SAS integration notes
Date: Sun, 16 Oct 2005 11:05:07 +1000
Message-ID: <4351A743.3040105@torque.net>
References: <20051014180615.5604.qmail@web31808.mail.mud.yahoo.com> <43510FEA.6070109@s5r6.in-berlin.de>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:58063 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S1751270AbVJPBEL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Oct 2005 21:04:11 -0400
In-Reply-To: <43510FEA.6070109@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi@vger.kernel.org, ltuikov@yahoo.com, Jeff Garzik <jgarzik@pobox.com>, Mike Anderson <andmike@us.ibm.com>, Luben Tuikov <luben_tuikov@adaptec.com>, James Bottomley <James.Bottomley@steeleye.com>, Christoph Hellwig <hch@infradead.org>, linux-ide@vger.kernel.org

Stefan Richter wrote:
> Luben Tuikov wrote:
> 
>> --- Jeff Garzik <jgarzik@pobox.com> wrote:
>>
>>> (HCIL should get marginalized, as all agree)
> 
> 
> "Marginalized" was not the term that I remember.
> 
>>> * Put HCIL mapping into top-level helper code, for sharing between FC
>>> and SAS (hopefully!)
>>
>>
>> One step further: eliminate the ugly legacy SPI-centric HCIL from
>> SCSI Core.  Minimise and streamline SCSI Core.
> 
> 
> I agree. FC, SAS, USB, SBP et al do not need to _share_ some HCIL
> mapping helpers --- they and the core need to get rid of HCIL mapping
> entirely. Why spend energy on optimization of existing HCIL mappings?
> 
> usb-storage and sbp2 already implement the leanest possible HCIL mapping
> (1 logical unit to 1 H).

Stefan,
Here is a counter example from a USB multicard reader:

$ lsscsi -v
[0:0:0:0]    disk    Generic  USB SD Reader    1.00  /dev/sda
  dir: /sys/bus/scsi/devices/0:0:0:0
[/sys/devices/pci0000:00/0000:00:07.2/usb1/1-1/1-1:1.0/host0/target0:0:0/0:0:0:0]
[0:0:0:1]    disk    Generic  USB CF Reader    1.01  /dev/sdb
  dir: /sys/bus/scsi/devices/0:0:0:1
[/sys/devices/pci0000:00/0000:00:07.2/usb1/1-1/1-1:1.0/host0/target0:0:0/0:0:0:1]
[0:0:0:2]    disk    Generic  USB SM Reader    1.02  /dev/sdc
  dir: /sys/bus/scsi/devices/0:0:0:2
[/sys/devices/pci0000:00/0000:00:07.2/usb1/1-1/1-1:1.0/host0/target0:0:0/0:0:0:2]
[0:0:0:3]    disk    Generic  USB MS Reader    1.03  /dev/sdd
  dir: /sys/bus/scsi/devices/0:0:0:3
[/sys/devices/pci0000:00/0000:00:07.2/usb1/1-1/1-1:1.0/host0/target0:0:0/0:0:0:3]

That is 4 logical units to 1 host. [Since I'm often
critical of USB mass storage device SCSI support, in
this case it is good to see some thought went into the
INQUIRY string namings.]

There is an argument for the SCSI subsystem to keep
at least the "l" part of the maligned <h:c:i:l> tuple
because the "l" part really is SCSI (and should be u8[8]).
SATA-II is beginning to struggle along that path as well
with port multipliers of up to 15 devices. SCSI luns
can easily cope with that.

Doug Gilbert

