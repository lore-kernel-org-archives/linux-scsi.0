From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 18652] New: mptscsih: ioc0: attempting task abort when heavy
 disk operations on MPT SAS
Date: Thu, 16 Sep 2010 08:14:48 GMT
Message-ID: <bug-18652-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [140.211.167.42] ([140.211.167.42]:44975 "EHLO
	demeter2.kernel.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab0IPIOs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Sep 2010 04:14:48 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id o8G8EmiR001930
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 16 Sep 2010 08:14:48 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=18652

           Summary: mptscsih: ioc0: attempting task abort when heavy disk
                    operations on MPT SAS
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 2.6.35.4
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: ksb@inbox.lv
        Regression: No


Happens when heavy disk write operations ongoing:
[ 4499.860030] mptscsih: ioc0: attempting task abort! (sc=ffff88007a588200)
[ 4499.860036] sd 4:0:0:0: [sda] CDB: Write(10): 2a 00 0f dc f8 9f 00 04 00 00
[ 4499.894551] mptbase: ioc0: LogInfo(0x31120403): Originator={PL},
Code={Abort}, SubCode(0x0403) cb_idx mptbase_reply
[ 4501.256258] mptbase: ioc0: LogInfo(0x31140000): Originator={PL}, Code={IO
Executed}, SubCode(0x0000) cb_idx mptscsih_io_do
[ 4501.268298] mptscsih: ioc0: task abort: SUCCESS (sc=ffff88007a588200)
[ 4503.256426] mptbase: ioc0: LogInfo(0x31120403): Originator={PL},
Code={Abort}, SubCode(0x0403) cb_idx mptscsih_io_done
[ 4503.256439] mptscsih: ioc0: attempting task abort! (sc=ffff88007ab5cc00)
[ 4503.256443] sd 4:0:0:0: [sda] CDB: Write(10): 2a 00 0f dc fc 9f 00 04 00 00
[ 4503.256455] mptscsih: ioc0: task abort: SUCCESS (sc=ffff88007ab5cc00)
[ 4503.506394] mptscsih: ioc0: attempting task abort! (sc=ffff88007a588000)
[ 4503.506399] sd 4:0:0:0: [sda] CDB: Write(10): 2a 00 0f dd 00 9f 00 04 00 00
[ 4503.506412] mptscsih: ioc0: task abort: SUCCESS (sc=ffff88007a588000)
[ 4503.506698] mptscsih: ioc0: attempting task abort! (sc=ffff88007ab5c700)
[ 4503.506702] sd 4:0:0:0: [sda] CDB: Write(10): 2a 00 0f dd 04 9f 00 02 50 00
[ 4503.506715] mptscsih: ioc0: task abort: SUCCESS (sc=ffff88007ab5c700)
[ 4503.506999] mptscsih: ioc0: attempting task abort! (sc=ffff88007a589600)
[ 4503.507002] sd 4:0:0:0: [sda] CDB: Write(10): 2a 00 0f dd 06 f7 00 01 80 00
[ 4503.507014] mptscsih: ioc0: task abort: SUCCESS (sc=ffff88007a589600)

[.. a lot of them, and ends with..]

[ 4503.525540] mptscsih: ioc0: attempting task abort! (sc=ffff88007becbe00)
[ 4503.525543] sd 4:0:0:0: [sda] CDB: Write(10): 2a 00 10 4c 78 ff 00 01 50 00
[ 4503.525555] mptscsih: ioc0: task abort: SUCCESS (sc=ffff88007becbe00)
[ 4503.525858] mptscsih: ioc0: attempting target reset! (sc=ffff88007a588200)
[ 4503.525861] sd 4:0:0:0: [sda] CDB: Write(10): 2a 00 0f dc f8 9f 00 04 00 00
[ 4505.006219] mptscsih: ioc0: target reset: SUCCESS (sc=ffff88007a588200)
Happens when heavy disk write operations ongoing.
Identically on ubuntu's stock 2.6.32-24 and also on custom built 2.6.35.4 and
2.6.36-rc3 kernels.

following on 2.6.35.4 kernel:
# cat /proc/mpt/version
mptlinux-3.04.15
  Fusion MPT base driver
  Fusion MPT SAS host driver

# cat /proc/mpt/summary
ioc0: LSISAS1064E B2, FwRev=01140000h, Ports=1, MaxQ=511, IRQ=17 

# cat /proc/mpt/ioc0/info
ioc0:
  ProductID = 0x2204 (LSISAS1064E B2)
  FWVersion = 0x01140000
  MsgVersion = 0x0105
  FirstWhoInit = 0x00
  EventState = 0x00
  CurrentHostMfaHighAddr = 0x00000000
  CurrentSenseBufferHighAddr = 0x00000000
  MaxChainDepth = 0x60 frames
  MinBlockSize = 0x20 bytes
  RequestFrames @ 0xffff88007a402800 (Dma @ 0x000000007a402800)
    {CurReqSz=128} x {CurReqDepth=511} = 65408 bytes ^= 0x10000
    {MaxReqSz=128}   {MaxReqDepth=511}
  Frames   @ 0xffff88007a400000 (Dma @ 0x000000007a400000)
    {CurRepSz=80} x {CurRepDepth=128} = 10240 bytes ^= 0x2880
    {MaxRepSz=0}   {MaxRepDepth=511}
  MaxDevices = 173
  MaxBuses = 1
  PortNumber = 1 (of 1)

# cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: TSSTcorp Model: DVD-ROM SH-D162D Rev: SB00
  Type:   CD-ROM                           ANSI  SCSI revision: 05
Host: scsi4 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: WDC WD2500AAKS-0 Rev: 1B01
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi4 Channel: 00 Id: 01 Lun: 00
  Vendor: ATA      Model: WDC WD2500AAKS-0 Rev: 1B01
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi4 Channel: 00 Id: 02 Lun: 00
  Vendor: FUJITSU  Model: MAX3147RC        Rev: 0104
  Type:   Direct-Access                    ANSI  SCSI revision: 03
Host: scsi4 Channel: 00 Id: 03 Lun: 00
  Vendor: FUJITSU  Model: MAX3147RC        Rev: 0104
  Type:   Direct-Access                    ANSI  SCSI revision: 03
Host: scsi4 Channel: 00 Id: 04 Lun: 00
  Vendor: ESG-SHV. Model: SCA HSBP M1..... Rev: 2.15
  Type:   Enclosure                        ANSI  SCSI revision: 03

Happens at least on WDC's (SATA).

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
