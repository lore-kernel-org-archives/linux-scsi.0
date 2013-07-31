From: Nick Alcock <nick.alcock@esperi.org.uk>
Subject: Re: [SCSI REGRESSION] 3.10.2 or 3.10.3: arcmsr failure at bootup / early userspace transition
Date: Wed, 31 Jul 2013 01:07:47 +0100
Message-ID: <87siyvlhgs.fsf@spindle.srvr.nix>
References: <87r4ehfzhf.fsf@spindle.srvr.nix> <51F667C2.4020801@fastmail.fm>
	<87mwp5frdl.fsf@spindle.srvr.nix> <51F67959.2060803@fastmail.fm>
	<87fvuxdqes.fsf@spindle.srvr.nix> <yq1txjdhree.fsf@sermon.lab.mkp.net>
	<51F80167.1080004@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <51F80167.1080004@fastmail.fm> (Bernd Schubert's message of "Tue,
	30 Jul 2013 20:09:43 +0200")
Sender: stable-owner@vger.kernel.org
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, nick.cheng@areca.com.tw, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 30 Jul 2013, Bernd Schubert told this:

> On 07/30/2013 01:34 AM, Martin K. Petersen wrote:
>> (wheezy)fslab1:~# sg_inq -v /dev/sdc
>>     inquiry cdb: 12 00 00 00 24 00
>> standard INQUIRY:
>>     inquiry cdb: 12 00 00 00 60 00
>>   PQual=0  Device_type=0  RMB=0  version=0x05  [SPC-3]
>>   [AERC=0]  [TrmTsk=0]  NormACA=0  HiSUP=0  Resp_data_format=2
>>   SCCS=0  ACC=0  TPGS=0  3PC=0  Protect=0  BQue=0
>>   EncServ=0  MultiP=0  [MChngr=0]  [ACKREQQ=0]  Addr16=1
>>   [RelAdr=0]  WBus16=1  Sync=0  Linked=0  [TranDis=0]  CmdQue=1
>>   [SPI: Clocking=0x3  QAS=0  IUS=0]
>>     length=96 (0x60)   Peripheral device type: disk
>>  Vendor identification: Hitachi
>>  Product identification: HDS724040KLSA80
>>  Product revision level: R001
>>     inquiry cdb: 12 01 00 00 fc 00
>>     inquiry cdb: 12 01 80 00 fc 00
>>  Unit serial number: KRFS2CRAHXJZVD
>
> Besides the firmware, the difference might be that I'm exporting single disks without any areca-raidset in between.
> I can try to confirm that tomorrow, I just need the system as it is till tomorrow noon.

Aaah. Yeah, it looks like in JBOD mode it's just passing things straight
on to the disk: that vendor ID is a dead giveaway. For all I know my
earlier firmware does the same, but for obvious reasons I can't really
test that! Quite possibly it's passing *everything* on to the disk,
including all SCSI commands, in which case we don't actually know that
your Areca controller supports the VPD page we thought it did: quite
possibly only this underlying disk does.

You can get a degree of info on the underlying disks in the array even
if it's in RAID mode -- smartctl does it, for instance -- but it takes
Areca-specific code and chattering to the sg devices directly. I bet
that in JBOD mode, the sg device is the only exposure the controller has
to the world, and *all* the /dev/sd* devices are just passthroughs.

-- 
NULL && (void)
