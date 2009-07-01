From: Joe Jin <joe.jin@oracle.com>
Subject: kexec kernel failed to restart aacraid device
Date: Wed, 1 Jul 2009 08:54:04 +0800
Message-ID: <20090701005404.GA29923@joejin-pc.cn.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:61523 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764324AbZGAAyK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jun 2009 20:54:10 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: aacraid@adaptec.com, mark_salyzyn@adaptec.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, joe.jin@oracle.com

Hi,

When try to kdump via sysrq-trigger, found kernel hung when 
try to restart aacraid device, kernel print below messages:

  Loading aacraid.ko
  AAC0:  adapter kernel faile to start, init status = 0.

Normally startup, got following message what related the devices:

  Adaptec aacraid driver 1.1-5[2461]
  AAC0: kernel 4.2-0[8208] Jul  6 2006
  AAC0: monitor 4.2-0[8208]
  AAC0: bios 4.2-0[8208]
  AAC0: serial C36FA5
  AAC0: Non-DASD support enabled.


Device info from lspci:
     
02:03.0 0104: 9005:0285 (rev 01)                                                            
        Subsystem: 9005:0286
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- 
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR- 
        Latency: 64 (250ns min, 250ns max), Cache Line Size: 64 bytes                       
        Interrupt: pin A routed to IRQ 177                                                  
        Region 0: Memory at f8000000 (32-bit, prefetchable) [size=64M]
        Expansion ROM at fc9f0000 [disabled] [size=32K]                                     
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)  
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-


Readed driver's codes found if ignore restart device at _aac_rx_init():

Changed
	if ((((status & 0x0c) != 0x0c) || aac_reset_devices || reset_devices) && 
		!aac_rx_restart_adapter(dev, 0))

to 
	if ((aac_reset_devices || reset_devices) && 
		!aac_rx_restart_adapter(dev, 0))

and get rid of reset_devices from kdump command line, kexec kernel could
bootup kernel normally, kdump would dump vmcore, looked like it caused by 
aac_rx_restart_adapter() could not restart devices, it made kdump kernel 
could not go on.

Any idea will appreciate~

Thanks,
Joe


