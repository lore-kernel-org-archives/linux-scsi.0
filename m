From: rwhron@earthlink.net
Subject: Re: 2.5.31 qlogic error "this should not happen"
Date: Tue, 27 Aug 2002 17:36:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020827213505.GA16394@rushmore>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: patmans@us.ibm.com
Cc: linux-scsi@vger.kernel.org

> Can you show cat /proc/scsi/scsi of the machine
> (as well as the lspci etc)?

Luns 0-31 look like this:

Host: scsi3 Channel: 00 Id: 01 Lun: 00
  Vendor: IBM      Model: 3542             Rev: 0401
  Type:   Direct-Access                    ANSI SCSI revision: 03

Luns 32-127 look like this:

Host: scsi3 Channel: 00 Id: 01 Lun: 32
  Vendor: m  m  m  Model: m  m  m m  m  m  Rev:
  Type:   Direct-Access                    ANSI SCSI revision: ffffffff

Luns 32-127 shouldn't be accessible from this machine.
I believe it's part of a SAN at OSDL.

All of cat /proc/scsi/scsi at:
http://home.earthlink.net/~rwhron/kernel/scsi.txt

Qlogic entries in lspci -vvv:

09:04.0 SCSI storage controller: QLogic Corp. QLA2200 (rev 05)
        Subsystem: QLogic Corp.: Unknown device 0002
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (16000ns min), cache line size 08
        Interrupt: pin A routed to IRQ 19
        Region 0: I/O ports at 9000 [size=256]
        Region 1: Memory at f6800000 (32-bit, non-prefetchable) [size=4K]
        Expansion ROM at <unassigned> [disabled] [size=128K]
        Capabilities: [44] Power Management version 1
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

09:05.0 SCSI storage controller: QLogic Corp. QLA2200 (rev 05)
        same as above except for:
        Interrupt: pin A routed to IRQ 18
        Region 0: I/O ports at 9400 [size=256]
        Region 1: Memory at f6801000 (32-bit, non-prefetchable) [size=4K]

All of lspci -vvv at:
http://home.earthlink.net/~rwhron/kernel/lspci.txt

> Does RAID-5 mean you have a storage array attached? 

Yes, hardware raid5.  It appears to the OS as /dev/sdc.

> It looks like the latest qlogic qla driver includes 2.5.x support
> http://download.qlogic.com/drivers/5639/qla2x00-v6.1b5-dist.tgz

Thanks.  The new driver appears to have 2.5 bits similar to
Lincoln Dale's patch for v6.1b2.

-- 
Randy Hron
http://home.earthlink.net/~rwhron/kernel/bigbox.html

