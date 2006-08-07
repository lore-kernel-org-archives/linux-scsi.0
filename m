From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [sbp2] external hard disk shutdown timer
Date: Mon, 07 Aug 2006 19:55:13 -0400
Message-ID: <44D7D2E1.9010104@torque.net>
References: <E1GACIH-00043x-00.olecom-mail-ru@f58.mail.ru>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:44205 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932428AbWHGXzS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Aug 2006 19:55:18 -0400
In-Reply-To: <E1GACIH-00043x-00.olecom-mail-ru@f58.mail.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: olecom@mail.ru
Cc: Linux SCSI <linux-scsi@vger.kernel.org>

olecom@mail.ru wrote:
> Hallo ! Let me ask a question.
> 
> I couldn't change some values (f.e IDLE or ICT), while its
> "changing" flag is "y".

I would be surprised if you could change IDLE or
ICT on a SCSI disk and even more surprised if
that could be done through a bridge to an ATA
disk (as is happening in your case).

What the SAT draft is doing is instructive here. It
maps the SBC "stop" state (as in when START STOP UNIT
with start=0 is sent to a disk) to the ATA "standby"
state. Further, the SAT layer bounces subsequent media
access command (e.g. READ) and sends back a NOT READY
sense key with a asc of "initializing command required ...".
Actually if that READ had got through to the ATA disk
(e.g. sent as an ATA READ via the ATA PASS THROUGH SCSI
command) then the ATA disk would have spun up! However
a design goal of SAT is to make an ATA disk look like
a SCSI disk which once spun down need a START STOP UNIT
(start=1) command prior to subsequent media access.

And that is about it. Does anyone know of SCSI disks
that implement the power condition mode page with real
changeable fields? Also what does "idle" state mean for
a disk? [Heads parked, media spinning?]

Further, the SAT draft only outlines the partial
translation of 4 mode pages:
  - caching
  - control
  - informational exceptions control
  - read write error recovery

Notice no power condition mode page. I'm not familiar
enough with the SBP-2 standard and the corresponding
sbp2 driver but I doubt whether that mode page is
really supported. Alternatively it could be the SCSI
to ATA protocol bridge software being unhelpful.

> Would you like to explain meaning of that flag and, possibly,
> why change doesn't apply ? Maybe i'm doing or understanding
> something wrong ?

I just think trying to manipulate mode pages
for ATA devices via the current and previous
generations of USB mass storage and 1392 sbp2
chips is a lost cause. Hopefully the next
generation will have a SAT standard to guide them.

> All i want is to switch off timers (AFAIR from spcecs i've found t10.org),
> that shutdown ieee1394/usb-storage external HDD.
>  
> TIA.
>  
>  deen:/home/olecom# sdparm --set=IDLE=0 -6 /dev/sda
>     /dev/sda: WD        2500JB External   2.23  [simplified direct access device]
>  Request sense detected:  Sense key: Blank Check
>   ASC=55, ASCQ=55
>     continuing ...

Not a good start. The REQUEST SENSE ** seems to get a wild
sense key and an unknown asc/ascq combination.

>  deen:/home/olecom# sdparm -p po -6 /dev/sda
>     /dev/sda: WD        2500JB External   2.23  [simplified direct access device]
>  Request sense detected:  Sense key: Medium Error
>   ASC=55, ASCQ=55

It is not normal to get a Medium Error when accessing mode
pages. [If the disk did store mode information on the media
and could not read it, then it would probably fail its
initial self test.]

>     continuing ...
>  Power condition mode page:
>  >>> warning: mode page seems malformed, try '--flexible'

hmm, 'malformed'

>   IDLE        1  [cha: y, def:  1, sav:  1]
>   STANDBY     0  [cha: n, def:  0, sav:  0]
>   ICT       4095  [cha: y, def:4095, sav:4095]
>   SCT       4278190080  [cha: y, def:4278190080, sav:4278190080]

the SCT is 0xff000000 .

>  deen:/home/olecom#

Looks like garbage in, garbage out.

Lots of error paths were checked and nothing
died badly which indicates various drivers
are working well, so that is good.


** the initial REQUEST SENSE command used in
sdparm-0.98 has been removed in sdparm-0.99
because it broke broken software. Sadly the
major problem was with libata which doesn't
support REQUEST SENSE. If other see sdparm
version 0.98 failing on a REQUEST SENSE, please
upgrade to version 0.99 .

Doug Gilbert
