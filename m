From: Jim Faulkner <jfaulkne@ccs.neu.edu>
Subject: AIC-7892P has not worked properly since 2.6.11
Date: Thu, 17 Nov 2005 10:15:49 -0500 (EST)
Message-ID: <Pine.GSO.4.58.0511170958110.8131@denali.ccs.neu.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from amber.ccs.neu.edu ([129.10.116.51]:63660 "EHLO
	amber.ccs.neu.edu") by vger.kernel.org with ESMTP id S1751007AbVKQPPv
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Nov 2005 10:15:51 -0500
Received: from denali.ccs.neu.edu ([129.10.116.200])
	by amber.ccs.neu.edu with esmtps (TLSv1:DHE-RSA-AES256-SHA:256)
	(Exim 4.50)
	id 1EclUL-0005UR-GY
	for linux-scsi@vger.kernel.org; Thu, 17 Nov 2005 10:15:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hello,

I have a Dell Precision Workstation 530, which has an onboard Adaptec
AIC-7892P U160/m SCSI controller.  I have two 17 GB drives connected to
it, a SEAGATE ST318203LW and a WDIGTL  WDE18310 ULTRA2.  I use the new
aic7xxx driver.

Since Linux 2.6.12, the WDE18310 has many messages like this at boot time:
target0:0:2: Domain Validation detected failure, dropping back

and it usually drops back to this speed, reducing performance:
target0:0:2: FAST-10 WIDE SCSI 16.2 MB/s ST (124 ns, offset 31)

I have absolutely no problems using the drive at 80 MB/s transfer rates on
the 2.6.11 kernel.  I've tried using the old aic7xxx driver, however when
I use that driver, the SEAGATE drive is not detected at all.  Using that
driver the WDE18310 is detected and works at full speed.

Included below is some information that will hopefully help debug this
problem.  Let me know if there is any other information that I should
provide.  Please CC my e-mail address in any replies, as I am not
subscribed to this list.

Relevant part of dmesg from 2.6.12.3:
Nov 17 05:37:08 michelangelo scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA
DRIVER, Rev 6.2.36
Nov 17 05:37:08 michelangelo <Adaptec aic7892 Ultra160 SCSI adapter>
Nov 17 05:37:08 michelangelo aic7892: Ultra160 Wide Channel A, SCSI Id=7,
32/253 SCBs
Nov 17 05:37:08 michelangelo
Nov 17 05:37:08 michelangelo Vendor: SEAGATE   Model: ST318203LW
Rev: 0001
Nov 17 05:37:08 michelangelo Type:   Direct-Access
ANSI SCSI revision: 02
Nov 17 05:37:08 michelangelo scsi0:A:0:0: Tagged Queuing enabled.  Depth
253
Nov 17 05:37:08 michelangelo target0:0:0: Beginning Domain Validation
Nov 17 05:37:08 michelangelo WIDTH IS 1
Nov 17 05:37:08 michelangelo (scsi0:A:0): 6.600MB/s transfers (16bit)
Nov 17 05:37:08 michelangelo target0:0:0: Domain Validation skipping write
tests
Nov 17 05:37:08 michelangelo (scsi0:A:0): 80.000MB/s transfers (40.000MHz,
offset 15, 16bit)
Nov 17 05:37:08 michelangelo target0:0:0: Ending Domain Validation
Nov 17 05:37:08 michelangelo Vendor: WDIGTL    Model: WDE18310 ULTRA2
Rev: 1.30
Nov 17 05:37:08 michelangelo Type:   Direct-Access
ANSI SCSI revision: 02
Nov 17 05:37:08 michelangelo scsi0:A:2:0: Tagged Queuing enabled.  Depth
253
Nov 17 05:37:08 michelangelo target0:0:2: Beginning Domain Validation
Nov 17 05:37:08 michelangelo WIDTH IS 1
Nov 17 05:37:08 michelangelo (scsi0:A:2): 6.600MB/s transfers (16bit)
Nov 17 05:37:08 michelangelo target0:0:2: Domain Validation skipping write
tests
Nov 17 05:37:08 michelangelo target0:0:2: Domain Validation detected
failure, dropping back
Nov 17 05:37:08 michelangelo target0:0:2: Domain Validation detected
failure, dropping back
Nov 17 05:37:08 michelangelo target0:0:2: Domain Validation detected
failure, dropping back
Nov 17 05:37:08 michelangelo target0:0:2: Domain Validation detected
failure, dropping back
Nov 17 05:37:08 michelangelo target0:0:2: Domain Validation detected
failure, dropping back
Nov 17 05:37:08 michelangelo target0:0:2: Domain Validation detected
failure, dropping back
Nov 17 05:37:08 michelangelo target0:0:2: Domain Validation detected
failure, dropping back
Nov 17 05:37:08 michelangelo target0:0:2: Domain Validation detected
failure, dropping back
Nov 17 05:37:08 michelangelo target0:0:2: Domain Validation detected
failure, dropping back
Nov 17 05:37:08 michelangelo target0:0:2: Domain Validation detected
failure, dropping back
Nov 17 05:37:08 michelangelo (scsi0:A:2): 80.000MB/s transfers (40.000MHz,
offset 31, 16bit)
Nov 17 05:37:08 michelangelo target0:0:2: Ending Domain Validation

Relevant part of dmesg from 2.6.14.2:
Nov 15 17:08:44 michelangelo scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA
DRIVER, Rev 7.0
Nov 15 17:08:44 michelangelo <Adaptec aic7892 Ultra160 SCSI adapter>
Nov 15 17:08:44 michelangelo aic7892: Ultra160 Wide Channel A, SCSI Id=7,
32/253 SCBs
Nov 15 17:08:44 michelangelo
Nov 15 17:08:44 michelangelo Vendor: SEAGATE   Model: ST318203LW
Rev: 0001
Nov 15 17:08:44 michelangelo Type:   Direct-Access
ANSI SCSI revision: 02
Nov 15 17:08:44 michelangelo scsi0:A:0:0: Tagged Queuing enabled.  Depth
253
Nov 15 17:08:44 michelangelo target0:0:0: Beginning Domain Validation
Nov 15 17:08:44 michelangelo target0:0:0: wide asynchronous.
Nov 15 17:08:44 michelangelo target0:0:0: Domain Validation skipping write
tests
Nov 15 17:08:44 michelangelo target0:0:0: FAST-40 WIDE SCSI 80.0 MB/s ST
(25 ns, offset 15)
Nov 15 17:08:44 michelangelo target0:0:0: Ending Domain Validation
Nov 15 17:08:44 michelangelo Vendor: WDIGTL    Model: WDE18310 ULTRA2
Rev: 1.30
Nov 15 17:08:44 michelangelo Type:   Direct-Access
ANSI SCSI revision: 02
Nov 15 17:08:44 michelangelo scsi0:A:2:0: Tagged Queuing enabled.  Depth
253
Nov 15 17:08:44 michelangelo target0:0:2: Beginning Domain Validation
Nov 15 17:08:44 michelangelo target0:0:2: wide asynchronous.
Nov 15 17:08:44 michelangelo target0:0:2: Domain Validation skipping write
tests
Nov 15 17:08:44 michelangelo target0:0:2: Domain Validation detected
failure, dropping back
Nov 15 17:08:44 michelangelo target0:0:2: Domain Validation detected
failure, dropping back
Nov 15 17:08:44 michelangelo target0:0:2: Domain Validation detected
failure, dropping back
Nov 15 17:08:44 michelangelo target0:0:2: Domain Validation detected
failure, dropping back
Nov 15 17:08:44 michelangelo target0:0:2: Domain Validation detected
failure, dropping back
Nov 15 17:08:44 michelangelo target0:0:2: Domain Validation detected
failure, dropping back
Nov 15 17:08:44 michelangelo target0:0:2: Domain Validation detected
failure, dropping back
Nov 15 17:08:44 michelangelo target0:0:2: Domain Validation detected
failure, dropping back
Nov 15 17:08:44 michelangelo target0:0:2: Domain Validation detected
failure, dropping back
Nov 15 17:08:44 michelangelo target0:0:2: Domain Validation detected
failure, dropping back
Nov 15 17:08:44 michelangelo target0:0:2: Domain Validation detected
failure, dropping back
Nov 15 17:08:44 michelangelo target0:0:2: Domain Validation detected
failure, dropping back
Nov 15 17:08:44 michelangelo target0:0:2: Domain Validation detected
failure, dropping back
Nov 15 17:08:44 michelangelo target0:0:2: Domain Validation detected
failure, dropping back
Nov 15 17:08:44 michelangelo target0:0:2: Domain Validation detected
failure, dropping back
Nov 15 17:08:44 michelangelo target0:0:2: FAST-10 WIDE SCSI 16.2 MB/s ST
(124 ns, offset 31)
Nov 15 17:08:44 michelangelo target0:0:2: Ending Domain Validation
Nov 15 17:08:44 michelangelo target0:0:0: FAST-40 WIDE SCSI 80.0 MB/s ST
(25 ns, offset 15)

Relevant part of dmesg from 2.6.15-rc1-mm1:
Nov 17 05:33:43 michelangelo scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA
DRIVER, Rev 7.0
Nov 17 05:33:43 michelangelo <Adaptec aic7892 Ultra160 SCSI adapter>
Nov 17 05:33:43 michelangelo aic7892: Ultra160 Wide Channel A, SCSI Id=7,
32/253 SCBs
Nov 17 05:33:43 michelangelo
Nov 17 05:33:43 michelangelo Vendor: SEAGATE   Model: ST318203LW
Rev: 0001
Nov 17 05:33:43 michelangelo Type:   Direct-Access
ANSI SCSI revision: 02
Nov 17 05:33:43 michelangelo scsi0:A:0:0: Tagged Queuing enabled.  Depth
253
Nov 17 05:33:43 michelangelo target0:0:0: Beginning Domain Validation
Nov 17 05:33:43 michelangelo target0:0:0: wide asynchronous.
Nov 17 05:33:43 michelangelo target0:0:0: Domain Validation skipping write
tests
Nov 17 05:33:43 michelangelo target0:0:0: FAST-40 WIDE SCSI 80.0 MB/s ST
(25 ns, offset 15)
Nov 17 05:33:43 michelangelo target0:0:0: Ending Domain Validation
Nov 17 05:33:43 michelangelo Vendor: WDIGTL    Model: WDE18310 ULTRA2
Rev: 1.30
Nov 17 05:33:43 michelangelo Type:   Direct-Access
ANSI SCSI revision: 02
Nov 17 05:33:43 michelangelo scsi0:A:2:0: Tagged Queuing enabled.  Depth
253
Nov 17 05:33:43 michelangelo target0:0:2: Beginning Domain Validation
Nov 17 05:33:43 michelangelo target0:0:2: wide asynchronous.
Nov 17 05:33:43 michelangelo target0:0:2: Domain Validation skipping write
tests
Nov 17 05:33:43 michelangelo target0:0:2: Domain Validation detected
failure, dropping back
Nov 17 05:33:43 michelangelo target0:0:2: Domain Validation detected
failure, dropping back
Nov 17 05:33:43 michelangelo target0:0:2: Domain Validation detected
failure, dropping back
Nov 17 05:33:43 michelangelo target0:0:2: Domain Validation detected
failure, dropping back
Nov 17 05:33:43 michelangelo target0:0:2: Domain Validation detected
failure, dropping back
Nov 17 05:33:43 michelangelo target0:0:2: Domain Validation detected
failure, dropping back
Nov 17 05:33:43 michelangelo target0:0:2: Domain Validation detected
failure, dropping back
Nov 17 05:33:43 michelangelo target0:0:2: Domain Validation detected
failure, dropping back
Nov 17 05:33:43 michelangelo target0:0:2: Domain Validation detected
failure, dropping back
Nov 17 05:33:43 michelangelo target0:0:2: Domain Validation detected
failure, dropping back
Nov 17 05:33:43 michelangelo target0:0:2: Domain Validation detected
failure, dropping back
Nov 17 05:33:43 michelangelo target0:0:2: Domain Validation detected
failure, dropping back
Nov 17 05:33:43 michelangelo target0:0:2: Domain Validation detected
failure, dropping back
Nov 17 05:33:43 michelangelo target0:0:2: Domain Validation detected
failure, dropping back
Nov 17 05:33:43 michelangelo target0:0:2: Domain Validation detected
failure, dropping back
Nov 17 05:33:43 michelangelo target0:0:2: FAST-10 WIDE SCSI 16.2 MB/s ST
(124 ns, offset 31)
Nov 17 05:33:43 michelangelo target0:0:2: Ending Domain Validation
Nov 17 05:33:43 michelangelo target0:0:0: FAST-40 WIDE SCSI 80.0 MB/s ST
(25 ns, offset 15)

Relevant part of dmesg from 2.6.11.11 (this kernel works):
scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.36
        <Adaptec aic7892 Ultra160 SCSI adapter>
        aic7892: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs

(scsi0:A:0): 80.000MB/s transfers (40.000MHz, offset 15, 16bit)
(scsi0:A:2): 80.000MB/s transfers (40.000MHz, offset 31, 16bit)
  Vendor: SEAGATE   Model: ST318203LW        Rev: 0001
  Type:   Direct-Access                      ANSI SCSI revision: 02
scsi0:A:0:0: Tagged Queuing enabled.  Depth 253
  Vendor: WDIGTL    Model: WDE18310 ULTRA2   Rev: 1.30
  Type:   Direct-Access                      ANSI SCSI revision: 02
scsi0:A:2:0: Tagged Queuing enabled.  Depth 253
SCSI device sda: 35566480 512-byte hdwr sectors (18210 MB)
SCSI device sda: drive cache: write back
SCSI device sda: 35566480 512-byte hdwr sectors (18210 MB)
SCSI device sda: drive cache: write back
 sda: sda1 sda2
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
SCSI device sdb: 35761710 512-byte hdwr sectors (18310 MB)
SCSI device sdb: drive cache: write back
SCSI device sdb: 35761710 512-byte hdwr sectors (18310 MB)
SCSI device sdb: drive cache: write back
 sdb: sdb1 sdb2 sdb3

Relevant part of lspvi -vvv:
0000:03:0e.0 SCSI storage controller: Adaptec AIC-7892P U160/m (rev 02)
        Subsystem: Dell: Unknown device 00d8
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (10000ns min, 6250ns max), cache line size 10
        Interrupt: pin A routed to IRQ 177
        BIST result: 00
        Region 0: I/O ports at ec00 [disabled] [size=256]
        Region 1: Memory at fe4fe000 (64-bit, non-prefetchable) [size=4K]
        Expansion ROM at fe500000 [disabled] [size=128K]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

thanks,
Jim Faulkner

