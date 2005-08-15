From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: internal tape + external zip on TRM-S1040 (dc395x)
Date: Mon, 15 Aug 2005 21:37:39 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0508152114280.7735@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:51912 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S964984AbVHOVgZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2005 17:36:25 -0400
Received: from lyakh (helo=localhost)
	by poirot.grange with local-esmtp (Exim 3.36 #1 (Debian))
	id 1E4kmB-00022c-00
	for <linux-scsi@vger.kernel.org>; Mon, 15 Aug 2005 21:37:39 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi

It might be more an electrical than software question, sorry if somewhat 
OT.

If I connect an external 100MB zip and an internal HP DDS-1 tape drive to 
the dc390 adapter, I can tar zip to the tape. If I connect them to the 
TRM-S1040 (dc315) it aborts with

tar: /dev/st0: Wrote only 0 of 10240 bytes
tar: Error is not recoverable: exiting now

and in dmesg:

dc395x: eh_abort: (pid#37555) target=<06-0> cmd=c5c16b40
dc395x: eh_abort: Command in progress<6>dc395x: eh_abort: (pid#37556) 
target=<06-0> cmd=c5f6ed00
dc395x: eh_abort: Command was waiting
dc395x: eh_abort: (pid#37556) target=<06-0> cmd=c5f6ed00
dc395x: eh_abort: Command was waiting
dc395x: eh_abort: (pid#37557) target=<06-0> cmd=c5c16040
dc395x: eh_abort: Command was waiting
dc395x: eh_abort: (pid#37557) target=<06-0> cmd=c5c16040
dc395x: eh_abort: Command was waiting
dc395x: eh_bus_reset: (pid#37555) target=<06-0> cmd=c5c16b40
dc395x: doing_srb_done: pids G:37555(06-0)
dc395x: Target 05:  Sync: 100ns Offset 15 (10.0 MB/s)
st0: Error with sense data: <6>st0: Current: sense key=0x6
    ASC=0x29 ASCQ=0x0

Separately accessing the zip and the tape works on TRM-S1040 too. The 
problem appears also if I just access the zip and the tape simultaneously 
from 2 processes not transferring the data between them.

On loading the driver it reports:

dc395x: Tekram DC395(U/UW/F), DC315(U) - ASIC TRM-S1040 v2.05, 2004/03/08
dc395x: Used settings: AdapterID=07, Speed=0(20.0MHz), dev_mode=0x77
dc395x:                AdaptMode=0x0f, Tags=4(16), DelayReset=1s
dc395x: Connectors: int50  Termination: Auto Low High
dc395x: Performing initial SCSI bus reset
scsi3 : Tekram DC395(U/UW/F), DC315(U) - ASIC TRM-S1040 v2.05, 2004/03/08
dc395x: Target 05:  Sync: 100ns Offset 15 (10.0 MB/s)
  Vendor: HP        Model: C1533A            Rev: A708
  Type:   Sequential-Access                  ANSI SCSI revision: 02
Attached scsi tape st0 at scsi3, channel 0, id 5, lun 0
st0: try direct i/o: yes (alignment 512 B), max page reachable by HBA 
1048575
Attached scsi generic sg2 at scsi3, channel 0, id 5, lun 0,  type 1
  Vendor: IOMEGA    Model: ZIP 100           Rev: D.13
  Type:   Direct-Access                      ANSI SCSI revision: 02
SCSI device sdc: 196608 512-byte hdwr sectors (101 MB)
sdc: Write Protect is off
sdc: Mode Sense: 25 00 00 08
sdc: cache data unavailable
sdc: assuming drive cache: write through
SCSI device sdc: 196608 512-byte hdwr sectors (101 MB)
sdc: Write Protect is off
sdc: Mode Sense: 25 00 00 08
sdc: cache data unavailable
sdc: assuming drive cache: write through
 sdc: sdc4
Attached scsi removable disk sdc at scsi3, channel 0, id 6, lun 0
Attached scsi generic sg3 at scsi3, channel 0, id 6, lun 0,  type 0

Termination turned on on the zip, at the tape end there's a passive 
terminator. The cable to the tape is pretty bad, I had to replace it in 
another computer, but the tape IS SLOW. And it works on dc390.

Just wanted to make sure it's not a software bug?

Thanks
Guennadi
---
Guennadi Liakhovetski
