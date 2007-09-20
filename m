From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] aic94xx: fix smartctl utility problem
Date: Thu, 20 Sep 2007 14:52:05 -0400
Message-ID: <46F2C155.2090307@torque.net>
References: <1189792710.6030.3.camel@linux.site>	 <1189875940.3339.12.camel@localhost.localdomain>	 <1189960632.3383.4.camel@localhost.localdomain> <46EDB5B7.10101@torque.net> <1189984871.3383.17.camel@localhost.localdomain>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:37205 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757334AbXITSxN (ORCPT
	<rfc822;Linux-scsi@vger.kernel.org>); Thu, 20 Sep 2007 14:53:13 -0400
In-Reply-To: <1189984871.3383.17.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Gilbert Wu <Gilbert_Wu@adaptec.com>, Linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Sun, 2007-09-16 at 19:01 -0400, Douglas Gilbert wrote:
>> James Bottomley wrote:
>>> On Sat, 2007-09-15 at 12:05 -0500, James Bottomley wrote:
>>>> On Fri, 2007-09-14 at 10:58 -0700, Gilbert Wu wrote:
>>>>> Fixed the problem that "smartctl -a /dev/some_sata_disk -d ata"  does
>>>>> not work on SATA device. ( The smartctl v5.38 does need "-d ata"
>>>>> option.)
>>>>>   The aic94xx need to return ATA output register for all ATA commands
>>>>> except ATA Read/Write commands.
>>>>>   The aic94xx also mark out the DRQ bit from status register which is
>>>>> treated as AC_ERR_HSM (host state machine violation) error by top layer
>>>>> if it set to one.
>>>>>  The firmware of aic94xx chip handle all ATA handshaking, data transfer
>>>>> and return ATA output register which is sent by the device.  So the DRQ
>>>>> bit may not reflect the last state of device when the command finished
>>>>> and it is no meaning for the caller.
>>>>>
>>>>> Signed-off-by: Gilbert Wu <gilbert_wu@adaptec.com>
>>>> I'm afraid this can't go in.  It has a bad effect on my expander remote
>>>> ATAPI device:
>>> OK, found the root cause: your CSMI_TASK flag is getting set on all
>>> packet commands.  I can think of two fixes: either smartctl should never
>>> be used on ATAPI devices (reasonable, since smart is a disc protocol),
>> Feature code 101h in MMC seems to sink your argument for
>> cd/dvd drives.
> 
> I was more thinking that smartctl is a pure ATA type thing (The problem
> which the flag is set for is to allow smartctl to muck with ATA
> commands)... the MMC devices supporting smart features report this via
> the informational exceptions mode page to conform to the MMC command
> set.  So, when smartctl does SCSI transports, they'll go via a packet
> command anyway.

I'm not sure what you mean by "smartctl is a pure ATA type
thing". smartctl is hybrid ATA and SCSI "type of thing"
(as is smartd). And I'm the maintainer of the SCSI part.

Life used to be simple in linux: a device name like "/dev/hd*"
would be sent ATA commands to fetch SMART information
while a device name like "dev/sd*" (or "/dev/*st*") would
be sent SCSI commands to fetch SMART information.

Trying to guess the preferred command set of a device based
on its device name (or initiator transport) is lame and
getting lamer. If SAT was fully implemented, smartctl
wouldn't have to worry when it detected an ATA device, as
SAT defines the correct translations for the SCSI commands
associated with SMART (e.g. self test results log page).

In the real world, SAT "compliance" usually means that the
SCSI ATA PASS-THROUGH(16) command is supported. So the
approach of smartctl is to start using SCSI commands (i.e.
an INQUIRY) and if SAT is detected, switch to ATA commands
tunnelled through the SCSI ATA PASS-THROUGH(16).

Note that the SCSI ATA PASS-THROUGH(16) command support may
be needed to detect and change the logical unit's transport
level characteristics but that is not really a concern of
smartmontools.


As for the MMC reference, I was countering your "smart is a
disc protocol" observation. smartmontools doesn't need to
send ATA commands (if it supported SMART for cd/dvd drives)
to cd/dvd drives.
Some other apps (e.g. hdparm) may want to send an ATA SET
FEATURES command tunnelled via an SCSI ATA PASS-THROUGH(16)
command to a cd/dvd drive connected, for example, to a
SAS expander.

>> Also tape drives may support SMART and if they do,
>> smartmontools can access the associated data. And tape
>> drives may be on an ATAPI transport.
> 
> That's probably via the same mechanism, isn't it?

Yes, apart from the fact (until recent kernels) that such
an ATAPI tape device would appear with a device name like
"/dev/hdc". That further confuses the "guess which command
set the device would like to use" game.

Doug Gilbert


