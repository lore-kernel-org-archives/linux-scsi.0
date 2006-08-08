From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [sbp2] external hard disk shutdown timer
Date: Tue, 08 Aug 2006 11:27:12 -0400
Message-ID: <44D8AD50.3070609@torque.net>
References: <E1GACIH-00043x-00.olecom-mail-ru@f58.mail.ru> <44D7D2E1.9010104@torque.net> <44D845A7.9040104@s5r6.in-berlin.de>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:49600 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S964955AbWHHP13 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Aug 2006 11:27:29 -0400
In-Reply-To: <44D845A7.9040104@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: olecom@mail.ru, Linux SCSI <linux-scsi@vger.kernel.org>

Stefan Richter wrote:
> Douglas Gilbert wrote:
>> olecom@mail.ru wrote:
>>> Hallo ! Let me ask a question.
>>>
>>> I couldn't change some values (f.e IDLE or ICT), while its
>>> "changing" flag is "y".
>> I would be surprised if you could change IDLE or
>> ICT on a SCSI disk and even more surprised if
>> that could be done through a bridge to an ATA
>> disk (as is happening in your case).

It seems that <olecom@mail.ru> hopes the the SCSI "idle"
power condition will map to the ATA STANDBY command
(as the ATA IDLE command action looks pretty vague).

I'm not sure SCSI disk vendors want to use "idle" and
"standby" states, or at least don't want them externally
manipulated. They design their disks for 24x7 access
and have lower "start stop cycle" spec-ed counts over
the device lifetime than ATA units.

The design of SAT seems to be when it is not emulating
typically SCSI disk behaviour, then it says nothing;
leaving the "extras" to the ATA PASS THROUGH SCSI
commands.

So hopefully those 1394 and usb scsi to ata bridges
will soon implement those ATA PASS THROUGH SCSI
commands. Then tools like hdparm and smartmontools
can work with ATA disks connected via a non-ata
transport.

<snip>

> Even reading mode pages via MODE SENSE is not properly (let alone
> extensively) implemented by many current SBP-2 bridges.
> 
> Oleg mentioned in another post that this is an Initio bridge. These
> bridges are known to return bogus mode page headers on MODE SENSE, so I
> am not very surprised about the following sense keys after REQUEST SENSE.
> 
>>> All i want is to switch off timers (AFAIR from spcecs i've found t10.org),
>>> that shutdown ieee1394/usb-storage external HDD.
>>>  
>>> TIA.
>>>  
>>>  deen:/home/olecom# sdparm --set=IDLE=0 -6 /dev/sda
>>>     /dev/sda: WD        2500JB External   2.23  [simplified direct access device]
> 
> AFAIK all Initio bridges show Peripheral Device Type 0x00 (SBC disk/
> direct access device) in their INQUIRY data if HDDs are connected, not
> device type 0x0E (RBC disk/ simplified direct access device) like by far
> most SBP-2 HDDs. It is not clear to me whether Initio's firmwares
> actually implement SBC or RBC.
> 
> How does sdparm determine the Peripheral Device Type?

A standard INQUIRY response. Adding a few '-v' options to sdparm will
show what it is doing.

Doug Gilbert
