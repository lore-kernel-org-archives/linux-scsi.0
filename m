From: Nix <nix@esperi.org.uk>
Subject: Re: [SCSI REGRESSION] 3.10.2 or 3.10.3: arcmsr failure at bootup / early userspace transition
Date: Mon, 29 Jul 2013 21:04:41 +0100
Message-ID: <87d2q1dteu.fsf@spindle.srvr.nix>
References: <87r4ehfzhf.fsf@spindle.srvr.nix> <51F667C2.4020801@fastmail.fm>
	<87mwp5frdl.fsf@spindle.srvr.nix> <51F67959.2060803@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <51F67959.2060803@fastmail.fm> (Bernd Schubert's message of "Mon,
	29 Jul 2013 16:16:57 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, nick.cheng@areca.com.tw
List-Id: linux-scsi@vger.kernel.org

On 29 Jul 2013, Bernd Schubert spake thusly:
> Could you try to run these commands with 3.10.1?
>
> # # check if reporting opcodes works
> # sg_opcodes -v  -n /dev/sdX

spindle:/boot# sg_opcodes -v -n /dev/sda
    inquiry cdb: 12 00 00 00 24 00
    Report Supported Operation Codes cmd: a3 0c 00 00 00 00 00 00 20 00 00 00
Report Supported Operation Codes:  Fixed format, current;  Sense key: Illegal Request
 Additional sense: Invalid command operation code
  Info fld=0x0 [0]
  Sense Key Specific: Error in Command byte 3840
Report supported operation codes: operation not supported

(sdb is the same, obviously, since they are both separate RAID volumes
controlled by the same controller.)

> # check ata information page
> # sg_vpd --page=0x89 /dev/sdX

spindle:/boot# sg_vpd --page=0x89 /dev/sda
ATA information VPD page:
fetching VPD page failed

Not very helpful, I know :(

I'll try rebooting into a kernel with that commit reverted next.

Areca controllers appear to be a bit weird: e.g. they needed special
support in smartctl...

>> No changes to arcmsr between those versions... I suspect I'll have to
>> bisect, which will be a complete pig because every failure means a hard
>> powerdown of this box. Always-on servers rarely appreciate hard
>> powerdowns :(
>
> Maybe just revert this commit? Helpful would be some scsi logging to
> see which command actually fails. I guess you don't have a serial
> console?

I could set one up, in theory, but the problem is that all my machines
are rather dependent on my NFS-mounted $HOME. Guess where it's mounted
from... in any case, the machine has no serial port, so it would have to
be a usb-serial console, and we know exactly how reliable those are :/

-- 
NULL && (void)
