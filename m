From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Report luns
Date: Wed, 10 Nov 2004 14:47:55 +1000
Message-ID: <41919D7B.5040703@torque.net>
References: <20041028143734.GA16358@beaverton.ibm.com> <20041028153522.GC1915@astral.ro> <20041028164210.GA16905@beaverton.ibm.com> <20041028172143.GA20949@praka.san.rr.com> <20041029085800.GF6671@astral.ro> <20041029180633.GA27267@beaverton.ibm.com> <20041101105611.GJ22603@astral.ro> <20041101194845.GA27913@us.ibm.com> <41903031.3050205@torque.net> <4190DCE0.1070606@adaptec.com> <20041109211055.GA11459@us.ibm.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:1483 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S261876AbUKJEr6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Nov 2004 23:47:58 -0500
In-Reply-To: <20041109211055.GA11459@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
>>Douglas Gilbert wrote:
>>
>>>So if that fails scsi_scan.c might issue a REPORT LUNS command to
>>>this lun: 0xc101 which is the value of the REPORT LUNS well-known lu.
>>>Note that this is a 16 bit quantity (not 64 bit as I said in a
>>>previous post about luns). For simplicity let us assume that
>>>that it is at the top level. [If a device returns HiSup=1 in its
>>>standard INQUIRY response then it claims to support a 4 level
>>>hierarchy in its luns (with 16 bits in each level).]
>>
>>And also supports REPORT LUNS.
>>
>>So in either case, we send REPORT LUNS to LUN 0 and if
>>this fails to REPORT LUNS W-LUN (0xC101...).
> 
> 
> Do we also have to change to send the INQUIRY to the well known LUN?

Yes, all well known lus have mandatory support for INQUIRY.

> And then someday add black and white list flags and code for them ...

Hope not. If an INQUIRY to lun 0 fails (and perhaps the transport level
doesn't object) then send an INQUIRY to lun 0xc101 . If that succeeds
then send a REPORT LUNS to lun 0xc101 ...

> Why is stuff like this even added to the standard??? Why not use LUN 0
> (all zeroes) or at worst have one well known LUN like the all f's?

All f's is already defined in SAM-3 as "lu not specified", whatever
that means :-)

> The hierarchical LUN stuff and the various address modes are dumb, just
> treat the LUN as a tag/identifier (similiar to a TCP/IP network port) and
> leave the interpretation of it up to the target device (or at worst the
> transport).

As you have worked in the scsi_scan.c area you are well placed
to comment. I have only recently been looking at luns. I also
wonder about the device peripheral type returned by an INQUIRY
sent to a W-LUN (i.e. well known lun). If it was closely associated
with disks (e.g. a RAID) and returned a "direct access" device then
the sd driver wouldn't make much sense of a W-LUN device. Note this
is not a problem while select=0 is set in scsi_scan's REPORT LUN
commands.


An example, inspired by the BCC draft, involving well
known logical units might help. Say we have
a bridge from SAS (or FC, it doesn't matter) to SPI-4 (U320).
One way to implement the bridge is to map the 15 possible
devices on the U320 bus to luns behind a single target in
a SAS domain (or SAS bus, it's the same thing). Lets assume
there are 5 U320 disks connected to the SPI bus and assume
SPI target ids 0 to 4 map to SAS luns 0 to 4.

So now if one sends a REPORT LUNS to lun 0 that U320 disk is
expected to know about its sibling disks!? That is why I used
the term "hack" with respect to lun 0. What really happens
is the device server in the bridge intercepts the REPORT LUNS
command and produces a response reflecting its knowledge of
those 5 U320 disks present. Why play this game? Why not talk
directly to the device server (addressed via a well known lu).
This way an INQUIRY to a W-LUN yields information about
the bridge, while an INQUIRY to lun 0 yields information about
that disk.
If the TARGET LOG PAGES W-LUN is supported then the
bridge can supply logs from its point of view (a SAS
bridge device) while a LOG SENSE command sent to lun 4
reports that U320 disk's logs.


Luben is probably correct in saying manufacturers will
support both lun 0 and the REPORT LUNS well known lu
in advanced products such as bridges. In Linux currently
we can detect the presence of well known lus (e.g.
sg_luns --select=1 /dev/sg3). If anything is found we
have no mechanism to probe them.

Doug Gilbert
