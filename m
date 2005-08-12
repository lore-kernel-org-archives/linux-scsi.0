From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: hwo to adjust interrupt?
Date: Fri, 12 Aug 2005 15:27:58 -0400
Message-ID: <1123874878.5546.119.camel@localhost.localdomain>
References: <OF33C7B841.0ED0EFDF-ON8825705B.00600DDB-8825705B.0060A40B@us.ibm.com>
	 <1123873551.5546.116.camel@localhost.localdomain>
	 <20050812191400.GB18979@parcelfarce.linux.theplanet.co.uk>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from leviathan.ele.uri.edu ([131.128.51.64]:5776 "EHLO
	leviathan.ele.uri.edu") by vger.kernel.org with ESMTP
	id S1750884AbVHLT21 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Aug 2005 15:28:27 -0400
In-Reply-To: <20050812191400.GB18979@parcelfarce.linux.theplanet.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Bryan Henderson <hbryan@us.ibm.com>, Arjan van de Ven <arjan@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2005-08-12 at 20:14 +0100, Matthew Wilcox wrote:
> On Fri, Aug 12, 2005 at 03:05:51PM -0400, Ming Zhang wrote:
> > i tried to remove the SA_SHIRQ option when request_irq(), unfortunately
> > it seems that the IO-APIC will only try to allocate same # to it and
> > once that slot is used, the request_irq will fail.
> 
> Yes.  These two interrupts are physically on the same wire attached to
> the IO-APIC.  You need to put the card in a different slot to change
> which interrupt it gets.
> 
thanks.

i tried to move aic7xxx into another slot and now it uses 17 and 18
instead of previously 16 17.

thus my question is how many intr available in APIC? what if i have a
quad port nic card and 1-2 scsi dual port controllers on board? then
they must share anyway?

[root@sc420 root]# cat /proc/interrupts
           CPU0       CPU1
  0:     103368      60018    IO-APIC-edge  timer
  1:         80         68    IO-APIC-edge  i8042
  4:          7          0    IO-APIC-edge  serial
  8:          3          0    IO-APIC-edge  rtc
  9:          0          0   IO-APIC-level  acpi
 14:        494          0    IO-APIC-edge  ide0
 16:        740          0   IO-APIC-level  eth1
 17:         15          0   IO-APIC-level  aic7xxx
 18:         28         43   IO-APIC-level  uhci_hcd:usb4, eth0, aic7xxx
 20:       4178        179   IO-APIC-level  libata
 21:          0          0   IO-APIC-level  ehci_hcd:usb1, uhci_hcd:usb2
 22:          0          0   IO-APIC-level  uhci_hcd:usb3
 23:          0          0   IO-APIC-level  uhci_hcd:usb5
NMI:          0          0
LOC:     163279     163330
ERR:          0
MIS:          0


