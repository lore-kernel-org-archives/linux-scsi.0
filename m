From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: SAS overview
Date: Sat, 27 Mar 2004 22:19:17 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40664435.1060409@pobox.com>
References: <20040316174713.C424976C4F@isis.visi.com> <40664024.2070700@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:41914 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262065AbUC1DTa
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Mar 2004 22:19:30 -0500
In-Reply-To: <40664024.2070700@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: "Scott M. Ferris" <sferris@acm.org>, Matthew Wilcox <willy@debian.org>, linux-scsi <linux-scsi@vger.kernel.org>

Douglas Gilbert wrote:
> Scott M. Ferris wrote:
> 
>> Matthew Wilcox wrote:
>>
>>> On Tue, Mar 16, 2004 at 09:46:31PM +1000, Douglas Gilbert wrote:
>>>
>>>
>>>> Now things start to get interesting. SAS can aggregate
>>>> individual phy interconnects to form "wide" links. So
>>>> if two (single phy) cables are run from a HBA (occupying
>>>> two of its phys) to phys on the same expander then that
>>>> is a wide link. Seen from Linux driving that HBA that is
>>>> two PCI devices (each HBA phy) but only one SCSI initiator
>>>> port. Up to 256 phy interconnects can be ganged to make
>>>> a very wide SAS link (a parallel bus you might say).
>>>
>>>
>>> It's different though (and I suspect you know this, but let's clarify 
>>> for
>>> the audience).  A parallel link would send each bit down a different 
>>> phy.
>>> PCI-E (and probably SAS) send each byte down a different phy.
>>
>>
>>
>> The assumption that each phy will be a different PCI device is likely
>> to be false, at least for initiators.  
> 
> 
> Scott,
> Whether two phys on a SAS HBA are two separate SCSI initiators
> or one initiator on a wide link depends on what those phys are
> attached to. That seems pretty dynamic so it seems to me the HBA
> driver needs to look at phys individually. So if the phys are
> not separate PCI devices then they at least need to be individually
> addressable (and the SAS address isn't going to help since it's
> the same for all HBA phys). At the moment for SPI PCI HBAs sysfs
> has a one to one link between a PCI device and a SCSI host.
> Such sysfs links might look a little different in the presene of
> SAS wide links.

If it's anything like SATA, you have one phy per point-to-point link. 
Thus, 8 sata phys on a single 8-port SATA board.  Each is individually 
controlled and reset-able, and can throw transport error conditions 
independent of the other phys.

	Jeff



