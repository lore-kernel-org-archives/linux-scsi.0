From: Douglas Gilbert <dougg@torque.net>
Subject: Re: IO transfer limits
Date: Thu, 11 Jan 2007 16:50:24 -0500
Message-ID: <45A6B120.7070903@torque.net>
References: <8260533.post@talk.nabble.com> <45A5250E.3020205@cs.wisc.edu> <8269227.post@talk.nabble.com> <45A58FA5.2090003@torque.net> <45A6620C.3040807@s5r6.in-berlin.de>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:53834 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbXAKVuo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Jan 2007 16:50:44 -0500
In-Reply-To: <45A6620C.3040807@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: john clyne <clyne@ucar.edu>, linux-scsi@vger.kernel.org

Stefan Richter wrote:
> Douglas Gilbert wrote:
>> john clyne wrote:
>>> What do the different hostX in /sys/class/scsi_host corespond to? There are
>>> seven hostX directories, 5 with sg_tablesize set to 128 and two set to 255.
>> A Linux "host" is a SCSI initiator port (e.g. FC) or a
>> SCSI initiator device (e.g. SAS). Another way of looking
>> at a "host" is as a bridge between a computer bus (e.g. PCI)
>> and a storage transport. There is usually one (low level)
>> driver (LLD) controlling all hosts associated with a
>> specific class of hardware.
>>
>> If you fetch the lsscsi utility and load it then you can
>> try 'lsscsi --hosts' to list the active hosts on a
>> system (numbered on the left) and see the names of the
>> various LLDs associated with them. Here is an example:
>>
>> # lsscsi --hosts
>> [0]    sata_nv
>> [1]    sata_nv
>> [2]    sata_nv
>> [3]    sata_nv
>> [4]    mptsas
>> [5]    aic94xx
>> [6]    sbp2
>>
>> The first four are SATA ports (connectors) on the motherboard,
>> all controlled by the same driver. Then there is a LSI SAS
>> HBA (whose driver is mptsas), an Adaptec SAS HBA (48300) and
>> finally an Adaptec IEEE 1394 controller.
> 
> A side note:
> I don't think a Scsi_Host has a well-defined meaning beyond "the
> kernel-internal resource which LLDs use to connect to the Linux SCSI mid
> layer". It may have further meaning for many LLDs, but not for all.
> Specifically, the host6 in your example is in the current implementation
>  indeed nothing more than an internal resource. lsscsi is nevertheless
> able to determine the actual initiator port by means of knowledge of the
> implementation.

There are two sides to a "host": a kernel side (e.g. a
PCI device or virtual) and a storage transport side.
A host can be seen as a bridge between the two sides.

SCSI command sets need the concept of an initiator.
For queuing, mode page policy and reservations (i.e.
in multi-initiator environments) those initiators
(actually initiator ports) need domain unique identifiers,
preferably world wide unique. The identifier is an
attribute of the external side (i.e. the storage
transport side) of a linux "host".

So even if you consider the kernel side of a host
is a kludge, there is still the storage transport
side to consider.

In the case of sbp, the initiator (device and port) has
a EUI-64 wwn. SBP, USB mass storage, and iSCSI all set up
SCSI hosts in Linux on a session basis (just-in-time if
you like). As long as the initiator port identifiers are
stable (predictable from one session to the next) it seems
to me little different to SAS, SPI and FC which maintain
their hosts for as long as their HBAs are present.


There are cheap external boxes out there that have 1394,
USB and (e)SATA interfaces. I wonder what would happen
if one tried to use two interfaces connected to different
machines at the same time :-)

Doug Gilbert


