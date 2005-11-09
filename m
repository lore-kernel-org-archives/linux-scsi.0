From: thomas schorpp <t.schorpp@gmx.de>
Subject: Re: [usb-storage] [Merging ATA passthru] on integrating	SMART/ATA-Security
 in usb-storage driver
Date: Wed, 09 Nov 2005 10:45:59 +0100
Message-ID: <4371C557.80807@gmx.de>
References: <CA45571DE57E1C45BF3552118BA92C9D69BF4A@WDSCEXBECL03.sc.wdc.com> <4371BB82.3090208@gmx.de>
Reply-To: t.schorpp@gmx.de
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:31159 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1751356AbVKIJqH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2005 04:46:07 -0500
In-Reply-To: <4371BB82.3090208@gmx.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: USB Storage list <usb-storage@lists.one-eyed-alien.net>
Cc: Timothy Thelin <Timothy.Thelin@wdc.com>, James Bottomley <James.Bottomley@SteelEye.com>, linux-ide@vger.kernel.org, Linux SCSI list <linux-scsi@vger.kernel.org>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Patrick Mansfield <patmans@us.ibm.com>

thomas schorpp wrote:
> Timothy Thelin wrote:
> 
>>>On Mon, 7 Nov 2005, James Bottomley wrote:
>>>
>>
>>It was generated against Linus' git repo after
>>applying Alan's patch.
>>
>>With both patches applied I can now do passthru cdbs on the
>>cypress part without issue, and I still don't see any IO issues.
>>
>>Anyone out there have a better selection of hardware to test with?
>>
> 
> 
> first i need better software, the 2.6.14-git-11 snapshot wont boot, cause
> it tries to mount root without detecting partitions before :/
> 
> did i miss some patch since this snapshot?
> 

ok, applies against 2.6.14.0. device: cypress -A- bridge.

no change with smartctl:

tom1:/usr/src/sm5/debug# ./smartctl -a -r ioctl,2 -T verypermissive /dev/sda
smartctl version 5.34 [i686-pc-linux-gnu] Copyright (C) 2002-5 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

 [inquiry: 12 00 00 00 24 00 ]
  scsi_status=0x0, host_status=0x0, driver_status=0x0
  info=0x0  duration=0 milliseconds
  Incoming data, len=36:
 00     00 00 00 00 1f 00 00 00  49 43 33 35 4c 30 33 30
 10     41 56 56 4e 30 37 2d 30  20 20 20 20 20 20 20 20
 20     00 30 00 30
  status=0x0
Device: IC35L030 AVVN07-0         Version:
 [mode sense: 1a 00 1c 00 40 00 ]
  scsi_status=0x2, host_status=0x0, driver_status=0x8
  info=0x1  duration=0 milliseconds
  Incoming data, len=64:
 00     00 00 00 00 1f 00 00 00  49 43 33 35 4c 30 33 30
 10     41 56 56 4e 30 37 2d 30  20 20 20 20 20 20 20 20
 20     00 30 00 30 00 00 00 00  00 00 00 00 00 00 00 00
 30     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
  >>> Sense buffer, len=18:
 00     70 00 05 00 00 00 00 0a  00 00 00 00 24 00 00 00
 10     00 00
  status=2: sense_key=5 asc=24 ascq=0
 [inquiry: 12 01 80 00 40 00 ]
  scsi_status=0x0, host_status=0x0, driver_status=0x0
  info=0x0  duration=4 milliseconds
  Incoming data, len=64:
 00     00 00 00 00 1f 00 00 00  49 43 33 35 4c 30 33 30
 10     41 56 56 4e 30 37 2d 30  20 20 20 20 20 20 20 20
 20     00 30 00 30 00 00 00 00  00 00 00 00 00 00 00 00
 30     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
  status=0x0
Vital Product Data (VPD) bit ignored in INQUIRY
Device type: disk
 [mode sense: 1a 00 19 00 40 00 ]
  scsi_status=0x2, host_status=0x0, driver_status=0x8
  info=0x1  duration=4 milliseconds
  Incoming data, len=64:
 00     00 00 00 00 e8 30 ef c7  80 35 23 c5 00 00 00 00
 10     70 6a bd c5 a0 84 11 c0  00 01 10 00 00 02 20 00
 20     18 5e 3f d0 20 af 02 c8  00 00 00 00 70 6a bd c5
 30     a0 84 11 c0 00 01 10 00  00 02 20 00 18 be db c5
  >>> Sense buffer, len=18:
 00     70 00 05 00 00 00 00 0a  00 00 00 00 24 00 00 00
 10     00 00
  status=2: sense_key=5 asc=24 ascq=0
Local Time is: Wed Nov  9 10:34:46 2005 CET
 [test unit ready: 00 00 00 00 00 00 ]
  scsi_status=0x0, host_status=0x0, driver_status=0x0
  info=0x0  duration=0 milliseconds
  status=0x0
Device does not support SMART [unsupported field in scsi command]
 [log sense: 4d 00 40 00 00 00 00 00 04 00 ]
  scsi_status=0x2, host_status=0x0, driver_status=0x8
  info=0x1  duration=0 milliseconds
  Incoming data, len=4:
 00     54 5a 69 66
  >>> Sense buffer, len=18:
 00     70 00 05 00 00 00 00 0a  00 00 00 00 20 00 00 00
 10     00 00
  status=2: sense_key=5 asc=20 ascq=0
Log Sense for supported pages failed [unsupported scsi opcode]
 [request sense: 03 00 00 00 12 00 ]
  scsi_status=0x0, host_status=0x0, driver_status=0x0
  info=0x0  duration=4 milliseconds
  Incoming data, len=18:
 00     70 00 00 00 00 00 00 0a  00 00 00 00 00 00 00 00
 10     00 00
  status=0x0
 [read defect list(10): 37 00 0c 00 00 00 00 00 04 00 ]
  scsi_status=0x2, host_status=0x0, driver_status=0x8
  info=0x1  duration=0 milliseconds
  Incoming data, len=4:
 00     70 00 00 00
  >>> Sense buffer, len=18:
 00     70 00 05 00 00 00 00 0a  00 00 00 00 20 00 00 00
 10     00 00
  status=2: sense_key=5 asc=20 ascq=0
Read defect list (10) Failed: unsupported scsi opcode

Error Counter logging not supported
 [mode sense: 1a 00 0a 00 40 00 ]
  scsi_status=0x2, host_status=0x0, driver_status=0x8
  info=0x1  duration=0 milliseconds
  Incoming data, len=64:
 00     00 00 00 00 1f 00 00 00  49 43 33 35 4c 30 33 30
 10     41 56 56 4e 30 37 2d 30  20 20 20 20 20 20 20 20
 20     00 30 00 30 00 00 00 00  00 00 00 00 00 00 00 00
 30     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
  >>> Sense buffer, len=18:
 00     70 00 05 00 00 00 00 0a  00 00 00 00 24 00 00 00
 10     00 00
  status=2: sense_key=5 asc=24 ascq=0
Device does not support Self Test logging
tom1:/usr/src/sm5/debug#
tom1:/usr/src/sm5/debug#
tom1:/usr/src/sm5/debug# ./smartctl -a -r ioctl,2 -T verypermissive /dev/sg0
smartctl version 5.34 [i686-pc-linux-gnu] Copyright (C) 2002-5 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

 [inquiry: 12 00 00 00 24 00 ]
  scsi_status=0x0, host_status=0x0, driver_status=0x0
  info=0x0  duration=0 milliseconds
  Incoming data, len=36:
 00     00 00 00 00 1f 00 00 00  49 43 33 35 4c 30 33 30
 10     41 56 56 4e 30 37 2d 30  20 20 20 20 20 20 20 20
 20     00 30 00 30
  status=0x0
Device: IC35L030 AVVN07-0         Version:
 [mode sense: 1a 00 1c 00 40 00 ]
  scsi_status=0x2, host_status=0x0, driver_status=0x8
  info=0x1  duration=0 milliseconds
  Incoming data, len=64:
 00     00 00 00 00 1f 00 00 00  49 43 33 35 4c 30 33 30
 10     41 56 56 4e 30 37 2d 30  20 20 20 20 20 20 20 20
 20     00 30 00 30 11 00 00 00  06 00 00 00 00 00 00 00
 30     00 00 00 00 11 00 00 00  07 00 00 00 00 00 00 00
  >>> Sense buffer, len=18:
 00     70 00 05 00 00 00 00 0a  00 00 00 00 24 00 00 00
 10     00 00
  status=2: sense_key=5 asc=24 ascq=0
 [inquiry: 12 01 80 00 40 00 ]
  scsi_status=0x0, host_status=0x0, driver_status=0x0
  info=0x0  duration=4 milliseconds
  Incoming data, len=64:
 00     00 00 00 00 1f 00 00 00  49 43 33 35 4c 30 33 30
 10     41 56 56 4e 30 37 2d 30  20 20 20 20 20 20 20 20
 20     00 30 00 30 00 00 00 00  00 00 00 00 00 00 00 00
 30     00 00 00 00 11 00 00 00  07 00 00 00 00 00 00 00
  status=0x0
Vital Product Data (VPD) bit ignored in INQUIRY
Device type: disk
 [mode sense: 1a 00 19 00 40 00 ]
  scsi_status=0x2, host_status=0x0, driver_status=0x8
  info=0x1  duration=0 milliseconds
  Incoming data, len=64:
 00     00 00 00 00 1f 00 00 00  49 43 33 35 4c 30 33 30
 10     41 56 56 4e 30 37 2d 30  20 20 20 20 20 20 20 20
 20     00 30 00 30 00 00 00 00  00 00 00 00 00 00 00 00
 30     00 00 00 00 11 00 00 00  07 00 00 00 00 00 00 00
  >>> Sense buffer, len=18:
 00     70 00 05 00 00 00 00 0a  00 00 00 00 24 00 00 00
 10     00 00
  status=2: sense_key=5 asc=24 ascq=0
Local Time is: Wed Nov  9 10:35:47 2005 CET
 [test unit ready: 00 00 00 00 00 00 ]
  scsi_status=0x0, host_status=0x0, driver_status=0x0
  info=0x0  duration=0 milliseconds
  status=0x0
Device does not support SMART [unsupported field in scsi command]
 [log sense: 4d 00 40 00 00 00 00 00 04 00 ]
  scsi_status=0x2, host_status=0x0, driver_status=0x8
  info=0x1  duration=0 milliseconds
  Incoming data, len=4:
 00     00 00 00 00
  >>> Sense buffer, len=18:
 00     70 00 05 00 00 00 00 0a  00 00 00 00 20 00 00 00
 10     00 00
  status=2: sense_key=5 asc=20 ascq=0
Log Sense for supported pages failed [unsupported scsi opcode]
 [request sense: 03 00 00 00 12 00 ]
  scsi_status=0x0, host_status=0x0, driver_status=0x0
  info=0x0  duration=0 milliseconds
  Incoming data, len=18:
 00     70 00 00 00 00 00 00 0a  00 00 00 00 00 00 00 00
 10     00 00
  status=0x0
 [read defect list(10): 37 00 0c 00 00 00 00 00 04 00 ]
  scsi_status=0x2, host_status=0x0, driver_status=0x8
  info=0x1  duration=0 milliseconds
  Incoming data, len=4:
 00     70 00 00 00
  >>> Sense buffer, len=18:
 00     70 00 05 00 00 00 00 0a  00 00 00 00 20 00 00 00
 10     00 00
  status=2: sense_key=5 asc=20 ascq=0
Read defect list (10) Failed: unsupported scsi opcode

Error Counter logging not supported
 [mode sense: 1a 00 0a 00 40 00 ]
  scsi_status=0x2, host_status=0x0, driver_status=0x8
  info=0x1  duration=0 milliseconds
  Incoming data, len=64:
 00     70 00 00 00 00 00 00 0a  00 00 00 00 00 00 00 00
 10     00 00 56 4e 30 37 2d 30  20 20 20 20 20 20 20 20
 20     00 30 00 30 00 00 00 00  00 00 00 00 00 00 00 00
 30     00 00 00 00 11 00 00 00  07 00 00 00 00 00 00 00
  >>> Sense buffer, len=18:
 00     70 00 05 00 00 00 00 0a  00 00 00 00 24 00 00 00
 10     00 00
  status=2: sense_key=5 asc=24 ascq=0
Device does not support Self Test logging
tom1:/usr/src/sm5/debug# 

no change with sdparm:

tom1:/usr/src/sm5/debug# sdparm -avl /dev/sda
    /dev/sda: IC35L030  AVVN07-0
Read write error recovery [PS=0] mode page:
  AWRE        0  [cha: n, def:  0, sav:  0]  Automatic write reallocation enabled
  ARRE        0  [cha: n, def:  0, sav:  0]  Automatic read reallocation enabled
  TB          0  [cha: n, def:  0, sav:  0]  Transfer block
  RC          0  [cha: n, def:  0, sav:  0]  Read continuous
  EER         0  [cha: n, def:  0, sav:  0]  Enable early recover
  PER         0  [cha: n, def:  0, sav:  0]  Post error
  DTE         0  [cha: n, def:  0, sav:  0]  Data terminate on error
  DCR         0  [cha: n, def:  0, sav:  0]  Disable correction
  RRC         0  [cha: n, def:  0, sav:  0]  Read retry count
  WRC         0  [cha: n, def:  0, sav:  0]  Write retry count
  RTL         0  [cha: n, def:  0, sav:  0]  Recovery time limit (ms)
>> Format (SBC) mode page not supported
>> Rigid disk (SBC) mode page not supported
>> Verify error recovery (SBC) mode page not supported
Caching (SBC) [PS=0] mode page:
  IC          0  [cha: n, def:  0, sav:  0]  Initiator control
  ABPF        0  [cha: n, def:  0, sav:  0]  Abort pre-fetch
  CAP         0  [cha: n, def:  0, sav:  0]  Caching analysis permitted
  DISC        0  [cha: n, def:  0, sav:  0]  Discontinuity
  SIZE        0  [cha: n, def:  0, sav:  0]  Size (1->CSS valid, 0->NCS valid)
  WCE         0  [cha: n, def:  0, sav:  0]  Write cache enable
  MF          0  [cha: n, def:  0, sav:  0]  Multiplication factor
  RCD         0  [cha: n, def:  0, sav:  0]  Read cache disable
  DRRP        0  [cha: n, def:  0, sav:  0]  Demand read retension priority
  WRP         0  [cha: n, def:  0, sav:  0]  Write retension priority
  DPTL        0  [cha: n, def:  0, sav:  0]  Disable pre-fetch transfer length
  MIPF        0  [cha: n, def:  0, sav:  0]  Minimum pre-fetch
  MAPF        0  [cha: n, def:  0, sav:  0]  Maximum pre-fetch
  MAPFC       0  [cha: n, def:  0, sav:  0]  Maximum pre-fetch ceiling
 >> skipping rest as field position exceeds mode page length=12
>> Control mode page not supported
>> XOR control (SBC) mode page not supported
>> Protocol specific logical unit mode page not supported
>> Protocol specific port mode page not supported
>> Power condition mode page not supported
>> Informational exceptions control mode page not supported
>> Background control (SBC) mode subpage not supported
tom1:/usr/src/sm5/debug#
tom1:/usr/src/sm5/debug#
tom1:/usr/src/sm5/debug#
tom1:/usr/src/sm5/debug# sdparm -avl /dev/sg0
    /dev/sg0: IC35L030  AVVN07-0
Read write error recovery [PS=0] mode page:
  AWRE        0  [cha: n, def:  0, sav:  0]  Automatic write reallocation enabled
  ARRE        0  [cha: n, def:  0, sav:  0]  Automatic read reallocation enabled
  TB          0  [cha: n, def:  0, sav:  0]  Transfer block
  RC          0  [cha: n, def:  0, sav:  0]  Read continuous
  EER         0  [cha: n, def:  0, sav:  0]  Enable early recover
  PER         0  [cha: n, def:  0, sav:  0]  Post error
  DTE         0  [cha: n, def:  0, sav:  0]  Data terminate on error
  DCR         0  [cha: n, def:  0, sav:  0]  Disable correction
  RRC         0  [cha: n, def:  0, sav:  0]  Read retry count
  WRC         0  [cha: n, def:  0, sav:  0]  Write retry count
  RTL         0  [cha: n, def:  0, sav:  0]  Recovery time limit (ms)
>> Format (SBC) mode page not supported
>> Rigid disk (SBC) mode page not supported
>> Verify error recovery (SBC) mode page not supported
Caching (SBC) [PS=0] mode page:
  IC          0  [cha: n, def:  0, sav:  0]  Initiator control
  ABPF        0  [cha: n, def:  0, sav:  0]  Abort pre-fetch
  CAP         0  [cha: n, def:  0, sav:  0]  Caching analysis permitted
  DISC        0  [cha: n, def:  0, sav:  0]  Discontinuity
  SIZE        0  [cha: n, def:  0, sav:  0]  Size (1->CSS valid, 0->NCS valid)
  WCE         0  [cha: n, def:  0, sav:  0]  Write cache enable
  MF          0  [cha: n, def:  0, sav:  0]  Multiplication factor
  RCD         0  [cha: n, def:  0, sav:  0]  Read cache disable
  DRRP        0  [cha: n, def:  0, sav:  0]  Demand read retension priority
  WRP         0  [cha: n, def:  0, sav:  0]  Write retension priority
  DPTL        0  [cha: n, def:  0, sav:  0]  Disable pre-fetch transfer length
  MIPF        0  [cha: n, def:  0, sav:  0]  Minimum pre-fetch
  MAPF        0  [cha: n, def:  0, sav:  0]  Maximum pre-fetch
  MAPFC       0  [cha: n, def:  0, sav:  0]  Maximum pre-fetch ceiling
 >> skipping rest as field position exceeds mode page length=12
>> Control mode page not supported
>> XOR control (SBC) mode page not supported
>> Protocol specific logical unit mode page not supported
>> Protocol specific port mode page not supported
>> Power condition mode page not supported
>> Informational exceptions control mode page not supported
>> Background control (SBC) mode subpage not supported
tom1:/usr/src/sm5/debug#
tom1:/usr/src/sm5/debug#
tom1:/usr/src/sm5/debug#
tom1:/usr/src/sm5/debug# sdparm -avl6 /dev/sg0
    /dev/sg0: IC35L030  AVVN07-0
Read write error recovery [PS=0] mode page:
  AWRE        0  [cha: n, def:  0, sav:  0]  Automatic write reallocation enabled
  ARRE        0  [cha: n, def:  0, sav:  0]  Automatic read reallocation enabled
  TB          0  [cha: n, def:  0, sav:  0]  Transfer block
  RC          0  [cha: n, def:  0, sav:  0]  Read continuous
  EER         0  [cha: n, def:  0, sav:  0]  Enable early recover
  PER         0  [cha: n, def:  0, sav:  0]  Post error
  DTE         0  [cha: n, def:  0, sav:  0]  Data terminate on error
  DCR         0  [cha: n, def:  0, sav:  0]  Disable correction
  RRC         0  [cha: n, def:  0, sav:  0]  Read retry count
  WRC         0  [cha: n, def:  0, sav:  0]  Write retry count
  RTL         0  [cha: n, def:  0, sav:  0]  Recovery time limit (ms)
>> Format (SBC) mode page not supported
>> Rigid disk (SBC) mode page not supported
>> Verify error recovery (SBC) mode page not supported
Caching (SBC) [PS=0] mode page:
  IC          0  [cha: n, def:  0, sav:  0]  Initiator control
  ABPF        0  [cha: n, def:  0, sav:  0]  Abort pre-fetch
  CAP         0  [cha: n, def:  0, sav:  0]  Caching analysis permitted
  DISC        0  [cha: n, def:  0, sav:  0]  Discontinuity
  SIZE        0  [cha: n, def:  0, sav:  0]  Size (1->CSS valid, 0->NCS valid)
  WCE         0  [cha: n, def:  0, sav:  0]  Write cache enable
  MF          0  [cha: n, def:  0, sav:  0]  Multiplication factor
  RCD         0  [cha: n, def:  0, sav:  0]  Read cache disable
  DRRP        0  [cha: n, def:  0, sav:  0]  Demand read retension priority
  WRP         0  [cha: n, def:  0, sav:  0]  Write retension priority
  DPTL        0  [cha: n, def:  0, sav:  0]  Disable pre-fetch transfer length
  MIPF        0  [cha: n, def:  0, sav:  0]  Minimum pre-fetch
  MAPF        0  [cha: n, def:  0, sav:  0]  Maximum pre-fetch
  MAPFC       0  [cha: n, def:  0, sav:  0]  Maximum pre-fetch ceiling
 >> skipping rest as field position exceeds mode page length=12
>> Control mode page not supported
>> XOR control (SBC) mode page not supported
>> Protocol specific logical unit mode page not supported
>> Protocol specific port mode page not supported
>> Power condition mode page not supported
>> Informational exceptions control mode page not supported
>> Background control (SBC) mode subpage not supported
tom1:/usr/src/sm5/debug#   





