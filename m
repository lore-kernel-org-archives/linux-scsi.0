From: thomas schorpp <t.schorpp@gmx.de>
Subject: Re: [usb-storage] [Merging ATA passthru] on integrating SMART/ATA-Security
 in usb-storage driver
Date: Sat, 05 Nov 2005 17:20:17 +0100
Message-ID: <436CDBC1.3010208@gmx.de>
References: <CA45571DE57E1C45BF3552118BA92C9D69BF3F@WDSCEXBECL03.sc.wdc.com> <20051104154613.189d5f43.zaitcev@redhat.com>
Reply-To: t.schorpp@gmx.de
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:6531 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1751246AbVKEQUZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Nov 2005 11:20:25 -0500
In-Reply-To: <20051104154613.189d5f43.zaitcev@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: usb-storage@lists.one-eyed-alien.net, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Pete Zaitcev wrote:
> On Fri, 4 Nov 2005 10:30:44 -0800, "Timothy Thelin" <Timothy.Thelin@wdc.com> wrote:
> 
> 
>>The problem then is with vendor specific commands as SCSI core
>>mangles those as well.  The vendor specific command I had issues
>>with is the "ATACB" ATA passthru cdb that cypress boards understand.
>>CDB[1] is a signature byte that must be 0x24.  Needless to say,
>>that leading 2 gets masked off to a 0, and the drive aborts the
>>ATACB.  Now cypress could have been smarter about designing their
>>cdb, but they wern't, and so there really needs to be a way to tell
>>SCSI core "hands off the cdb".
> 
> 
> If this issue is real, you can use ub with that device for now.
> 
> -- Pete
> -

hello Pete

nice idea :)

unfortunately it doesnt work with latest smartctl cvs on my usb2 drive, no smart functionality
tom1:/usr/src/sm5# ./smartctl -a -d scsi /dev/uba
smartctl version 5.34 [i686-pc-linux-gnu] Copyright (C) 2002-5 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

Device: IC35L030 AVVN07-0         Version:
Device type: disk
Local Time is: Sat Nov  5 16:49:28 2005 CET
Device does not support SMART

Error Counter logging not supported
Device does not support Self Test logging
tom1:/usr/src/sm5#

hdparm cant work(?). not implemented.

tom1:/usr/src/sm5# sdparm -alv /dev/uba
    /dev/uba: IC35L030  AVVN07-0
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
tom1:/usr/src/sm5#

device is in locked state, ata-security.

hmm, could someone supply me a sdparm commandline and data to test unlock (if supported), pls ?
im not through with all the specs from T10.org yet and they want money for more docs.

thx,
tom




