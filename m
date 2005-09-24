From: Douglas Gilbert <dougg@torque.net>
Subject: Re: SATA Drive Information (vs hdparm -i)?
Date: Sat, 24 Sep 2005 13:18:07 +1000
Message-ID: <4334C56F.8010208@torque.net>
References: <7744a2840509221206254d2109@mail.gmail.com> <43334AFF.8010901@torque.net> <43340FB7.3080708@adaptec.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:24792 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S1751386AbVIXDRg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Sep 2005 23:17:36 -0400
In-Reply-To: <43340FB7.3080708@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Richard Bollinger <rabollinger@gmail.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

Luben Tuikov wrote:
> On 09/22/05 20:23, Douglas Gilbert wrote:
> 
>>However an improved "sdparm -i" is not what you seem to be
>>asking for. Most of the above information is derived from
>>the response to the IDENTIFY [PACKET] DEVICE ATA command.
>>There seems to be two options for providing this:
>>  1) libata to implement ioctls like HDIO_GET_IDENTITY
>>  2) libata to implement SCSI ATA Translation [SAT]
>>     facilities such as:
>>       a) the ATA Information VPD page
>>       b) SCSI ATA pass through commands
>>       c) MODE SELECT SCSI command
>>
>>Option 1) is the simplest but it requires that the SAT layer
>>is on the host computer [as it is in the case of libata].
>>Hopefully external USB and Firewire storage enclosures will
>>be enhanced to support the [draft] SAT standard and in
>>that case the SAT layer will be in the enclosure. SATA
>>disks [and S-ATAPI devices] in a SAS fabric may either
>>tunnel through the SAS fabric [via SAS Tunnelling Protocol
>>[STP]] or have a SAT layer in the fabric [typically in the
>>enclosure holding the disks].
> 
> 
> There will be no SAT layer in a SAS fabric.  STP is just
> that, a _tunneling_ protocol.  Thus, either in Option 1,
> or Option 2 if you want to present the device to
> SCSI Core as a SCSI Device you need SAT somewhere below
> SCSI Core (on the host).

Luben,
The folks at HP, Intel and WDC seemingly driving the
SAT draft write in the overview [in sat-r06 section 5.1]
of the SAT layer (SATL):

"Examples of SATL implemented in accordance to this
standard include:
   a) a SATL contained within a SCSI target ...
   b) An ATA/ATAPI Host Bus Adapter (HBA) directly
      connected to ATA/ATAPI devices ...
   c) A SAS STP initiator port to connect ATA/ATAPI
      devices ...
"

There are figures (diagrams) of these three later in
the draft: figure 7 (page 81), figure 5 (page 79) and
figure 6 (page 80) respectively.

For point a) they give as examples FCP, SPI and SBP-3
(but not SAS). One reason for putting a SAT layer in
a SAS target is multi-initiator and mult-port command
queuing support (sat-r05 section 6.2.4). Converting
port multipliers to luns may also be useful. [Perhaps
you could confirm this: a 1.5 GB SATA disk chews up
3 GB of SAS bandwidth when doing STP data transfers
(thanks to ALIGNs inserted every other word).] A RAID
of SATA disks in a SAS target (enclosure) would be
another candidate for a SAT layer (with luns > 0 to
access the individual disks (e.g. for SMART diagnostics)).

> In general, lower (hardware) layers want to do the
> _absolute_ minimum as far as their function is concerned.

Some folks have reported beta testing disks that, via
firmware download, can change between having a SATA and
a SAS interface. So I think that what you say is
basically true, but intelligence is being distributed
as well. "Nice to have" features like SMART in disks
must consume a lot of firmware (and flash) but support
(and standard's compliance) seems to be improving.

> Thus, for example, you can expect an incomplete
> USB/IEEE1394 SAT layer on the device.

Yep. Judging from my mail, lots of these users would
be happy with START STOP UNIT (well, at least as a
start).

>>Only the STP route allows for option 1) .
> 
> 
> Option 2 as well: you'll just treat the device as
> SCSI and SAT will emulate as much as possible.

True; point c) from the SAT overview.

Doug Gilbert


