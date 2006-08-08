From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [sbp2] external hard disk shutdown timer
Date: Tue, 08 Aug 2006 10:04:55 +0200
Message-ID: <44D845A7.9040104@s5r6.in-berlin.de>
References: <E1GACIH-00043x-00.olecom-mail-ru@f58.mail.ru> <44D7D2E1.9010104@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:60589 "EHLO
	hp3.statik.tu-cottbus.de") by vger.kernel.org with ESMTP
	id S932558AbWHHIIb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Aug 2006 04:08:31 -0400
In-Reply-To: <44D7D2E1.9010104@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: olecom@mail.ru, Linux SCSI <linux-scsi@vger.kernel.org>

Douglas Gilbert wrote:
> olecom@mail.ru wrote:
>> Hallo ! Let me ask a question.
>> 
>> I couldn't change some values (f.e IDLE or ICT), while its
>> "changing" flag is "y".
> 
> I would be surprised if you could change IDLE or
> ICT on a SCSI disk and even more surprised if
> that could be done through a bridge to an ATA
> disk (as is happening in your case).
> 
> What the SAT draft is doing is instructive here. It
> maps the SBC "stop" state (as in when START STOP UNIT
> with start=0 is sent to a disk) to the ATA "standby"
> state.
[...]
> Further, the SAT draft only outlines the partial
> translation of 4 mode pages:
>   - caching
>   - control
>   - informational exceptions control
>   - read write error recovery
> 
> Notice no power condition mode page. I'm not familiar
> enough with the SBP-2 standard and the corresponding
> sbp2 driver but I doubt whether that mode page is
> really supported. Alternatively it could be the SCSI
> to ATA protocol bridge software being unhelpful.

I think RBC and SBC are more relevant than SBP-2 in this case. SBP-2
doesn't specify supported commands and mode parameters.

And then there is also a Power Management specification issued by the
1394-TA as a companion to IEEE 1394(a,b) but I doubt that it is
implemented by most of current desktop hardware/firmware/software.

Mac OS X is known to spin down (many) SBP-2 HDDs on certain occasions,
notably when devices are "ejected" i.e. prepared by the Mac OS Finder to
disconnect. My guess is Mac OS uses START STOP UNIT (with whatever
parameters). I should test this some day.

Also, some SBP-2 bridges "sense" when the host PC is powered off or put
into a suspended mode and switch the HDD off. Some other SBP-2 bridges
spin HDDs down after an idle timeout which appears to be a fixed value
in the firmware. A few of these firmwares are able to transparently spin
the HDD back up again on next access, others require START STOP UNIT
with start=1 to spin up. So, power management of available SBP-2
products is quite heterogeneous AFAI have seen and read. These automatic
features are not standardized by SBP-2 or IEEE 1394(a,b).

>> Would you like to explain meaning of that flag and, possibly,
>> why change doesn't apply ? Maybe i'm doing or understanding
>> something wrong ?
> 
> I just think trying to manipulate mode pages
> for ATA devices via the current and previous
> generations of USB mass storage and 1392 sbp2
> chips is a lost cause. Hopefully the next
> generation will have a SAT standard to guide them.

Even reading mode pages via MODE SENSE is not properly (let alone
extensively) implemented by many current SBP-2 bridges.

Oleg mentioned in another post that this is an Initio bridge. These
bridges are known to return bogus mode page headers on MODE SENSE, so I
am not very surprised about the following sense keys after REQUEST SENSE.

>> All i want is to switch off timers (AFAIR from spcecs i've found t10.org),
>> that shutdown ieee1394/usb-storage external HDD.
>>  
>> TIA.
>>  
>>  deen:/home/olecom# sdparm --set=IDLE=0 -6 /dev/sda
>>     /dev/sda: WD        2500JB External   2.23  [simplified direct access device]

AFAIK all Initio bridges show Peripheral Device Type 0x00 (SBC disk/
direct access device) in their INQUIRY data if HDDs are connected, not
device type 0x0E (RBC disk/ simplified direct access device) like by far
most SBP-2 HDDs. It is not clear to me whether Initio's firmwares
actually implement SBC or RBC.

How does sdparm determine the Peripheral Device Type?

>>  Request sense detected:  Sense key: Blank Check
>>   ASC=55, ASCQ=55
>>     continuing ...
> 
> Not a good start. The REQUEST SENSE ** seems to get a wild
> sense key and an unknown asc/ascq combination.

Yes, sense key "Blank Check" and ASC/ASCQ 0x55/0x55 seem rather random.
The sbp2 driver has to convert sense data from the SBP-2 status block
but I hope (and experience agrees with) that sbp2 does this properly and
the mistake happens in the firmware here.

>>  deen:/home/olecom# sdparm -p po -6 /dev/sda
>>     /dev/sda: WD        2500JB External   2.23  [simplified direct access device]
>>  Request sense detected:  Sense key: Medium Error
>>   ASC=55, ASCQ=55
> 
> It is not normal to get a Medium Error when accessing mode
> pages. [If the disk did store mode information on the media
> and could not read it, then it would probably fail its
> initial self test.]
> 
>>     continuing ...
>>  Power condition mode page:
>>  >>> warning: mode page seems malformed, try '--flexible'
> 
> hmm, 'malformed'
> 
>>   IDLE        1  [cha: y, def:  1, sav:  1]
>>   STANDBY     0  [cha: n, def:  0, sav:  0]
>>   ICT       4095  [cha: y, def:4095, sav:4095]
>>   SCT       4278190080  [cha: y, def:4278190080, sav:4278190080]
> 
> the SCT is 0xff000000 .

i.e. 4952 days if I calculate correctly --- may be random data or
shifted bytes of the mode page or a data from a different mode page than
requested.

>>  deen:/home/olecom#
> 
> Looks like garbage in, garbage out.
> 
> Lots of error paths were checked and nothing
> died badly which indicates various drivers
> are working well, so that is good.
> 
> 
> ** the initial REQUEST SENSE command used in
> sdparm-0.98 has been removed in sdparm-0.99
> because it broke broken software. Sadly the
> major problem was with libata which doesn't
> support REQUEST SENSE. If other see sdparm
> version 0.98 failing on a REQUEST SENSE, please
> upgrade to version 0.99 .
> 
> Doug Gilbert

-- 
Stefan Richter
-=====-=-==- =--- -=---
http://arcgraph.de/sr/
