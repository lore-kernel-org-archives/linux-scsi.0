From: Douglas Gilbert <dougg@torque.net>
Subject: Re: IO transfer limits
Date: Wed, 10 Jan 2007 20:15:17 -0500
Message-ID: <45A58FA5.2090003@torque.net>
References: <8260533.post@talk.nabble.com> <45A5250E.3020205@cs.wisc.edu> <8269227.post@talk.nabble.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:60478 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965292AbXAKBP0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jan 2007 20:15:26 -0500
In-Reply-To: <8269227.post@talk.nabble.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: john clyne <clyne@ucar.edu>
Cc: linux-scsi@vger.kernel.org

john clyne wrote:
> What do the different hostX in /sys/class/scsi_host corespond to? There are
> seven hostX directories, 5 with sg_tablesize set to 128 and two set to 255.

A Linux "host" is a SCSI initiator port (e.g. FC) or a
SCSI initiator device (e.g. SAS). Another way of looking
at a "host" is as a bridge between a computer bus (e.g. PCI)
and a storage transport. There is usually one (low level)
driver (LLD) controlling all hosts associated with a
specific class of hardware.

If you fetch the lsscsi utility and load it then you can
try 'lsscsi --hosts' to list the active hosts on a
system (numbered on the left) and see the names of the
various LLDs associated with them. Here is an example:

# lsscsi --hosts
[0]    sata_nv
[1]    sata_nv
[2]    sata_nv
[3]    sata_nv
[4]    mptsas
[5]    aic94xx
[6]    sbp2

The first four are SATA ports (connectors) on the motherboard,
all controlled by the same driver. Then there is a LSI SAS
HBA (whose driver is mptsas), an Adaptec SAS HBA (48300) and
finally an Adaptec IEEE 1394 controller.

> Is the implication that the hard limit is 255 * page_size, or is page_size
> simply the default?

There are "big" pages (around 1 MB in size) but I'm
unaware that anything in the SCSI subsystem uses them.
Otherwise the kernel page size is typically 4 KB.
When the scsi generic driver builds its scatter gather
lists, then it attempts to place 8 contiguous pages in
each scatter gather element.

"Arm waving" was a term used when I tried to explain
to several kernel people that there were users out there
that needed larger IO transfer limits. So I suggest that
you talk the the management and tell them why you
need higher limits. Linux is retarded in this area.

Doug Gilbert

> Mike Christie wrote:
>> john clyne wrote:
>>> Can anyone give me some guidance on where in the IO stack I might be
>>> running
>>> into a 512KB limit on IO transfer sizes to an external FC device? I've
>>> checked IO scheduler parameter
>>> (/sys/block/<dev>/queue/{max_sectors_kb,max_hw_sectors_kb}. Both are set
>>> to
>>> 32767. I'm using Qlogic HBAs (qla2312), but I don't see any relevent
>>> parameters. I'm running RHEL 4.0 with a 2.6.9-34 kernel. Any pointers
>>> would
>>> be greatly appreciated.
>>>
>> There are also scatterlist limits.
>>
>> /sys/class/scsi_host/hostX/sg_tablesize is a limit for the number of
>> scatter list entries. For qla2xxx it is 255.
>>
>> The scsi layer sets the queue's max_phys_segments to 128 by default. I
>> thought there was ia scsi compile time option to increase this, but
>> maybe you have to just modify the SCSI_MAX_PHYS_SEGMENTS define by hand.
>>
>> So with the default value and with 4 K pages if you end up getting pages
>> that cannot be clustered you will end up with 4K * 128.
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
> 

