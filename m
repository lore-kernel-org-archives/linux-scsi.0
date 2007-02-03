From: Wakko Warner <wakko@animx.eu.org>
Subject: Re: AIC7xxx on 2.6.18
Date: Fri, 2 Feb 2007 19:42:01 -0500
Message-ID: <20070203004201.GB25027@animx.eu.org>
References: <20070128194620.GA6358@animx.eu.org> <20070128162408.9fffb6de.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from animx.eu.org ([216.98.75.249]:36969 "EHLO animx.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933406AbXBCAmy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Feb 2007 19:42:54 -0500
Content-Disposition: inline
In-Reply-To: <20070128162408.9fffb6de.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org

Andrew Morton wrote:
> Yes, getting the oops traces will help, thanks.  And confirmation on a more
> recent kernel would be good.

Here's what I get.  I used netconsole so whatever was logged prior to it
starting was lost.

The PC is a suprtmicro x5da8 with an onboard dual channel AHA-39320 u320
controller.  I have a dual channel AHA-39160 u160 and a dual channel
AHA-2940U/UW (ch0/internal is wide/narrow, ch1/externel is narrow).

I thought it was because I had option roms turned off, but when I turned
them on, it still has problems.  What's odd is the fact that if I boot with
init=/bin/sh, modprobe aic7xxx, it works fine and I can exec init and it
works fine.

I have the logs when it failes and when it works, see below.

The console log when it fails:
------------------------------------------------------------------------------
[   22.802262]         <Adaptec 3960D Ultra160 SCSI adapter>
[   22.802264]         aic7899: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs
[   22.802265] 
[   25.040283] scsi 2:0:0:0: Direct-Access     SEAGATE  SX150176LC       BA12 PQ: 0 ANSI: 2
[   25.040359] scsi2:A:0:0: Tagged Queuing enabled.  Depth 32
[   25.040449]  target2:0:0: Beginning Domain Validation
[   25.045753]  target2:0:0: wide asynchronous
[   25.049768]  target2:0:0: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset 15)
[   25.053043]  target2:0:0: Domain Validation skipping write tests
[   25.053089]  target2:0:0: Ending Domain Validation
[   25.057249] SCSI device sdd: 97693755 512-byte hdwr sectors (50019 MB)
[   25.059872] sdd: Write Protect is off
[   25.062420] SCSI device sdd: drive cache: write through w/ FUA
[   25.063275] SCSI device sdd: 97693755 512-byte hdwr sectors (50019 MB)
[   25.065868] sdd: Write Protect is off
[   25.068853] SCSI device sdd: drive cache: write through w/ FUA
[   25.068915]  sdd: unknown partition table
[   25.084327] sd 2:0:0:0: Attached scsi disk sdd
[   25.094681] scsi 2:0:1:0: Direct-Access     SEAGATE  SX150176LC       BA08 PQ: 0 ANSI: 2
[   25.094768] scsi2:A:1:0: Tagged Queuing enabled.  Depth 32
[   25.094867]  target2:0:1: Beginning Domain Validation
[   25.100679]  target2:0:1: wide asynchronous
[   25.105894]  target2:0:1: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset 15)
[   25.110233]  target2:0:1: Domain Validation skipping write tests
[   25.110312]  target2:0:1: Ending Domain Validation
[   25.125724] SCSI device sde: 97693755 512-byte hdwr sectors (50019 MB)
[   25.133748] sde: Write Protect is off
[   25.136491] SCSI device sde: drive cache: write through w/ FUA
[   25.137521] SCSI device sde: 97693755 512-byte hdwr sectors (50019 MB)
[   25.140189] sde: Write Protect is off
[   25.142882] SCSI device sde: drive cache: write through w/ FUA
[   25.142960]  sde: unknown partition table
[   25.165486] sd 2:0:1:0: Attached scsi disk sde
[   25.172022] scsi 2:0:2:0: Direct-Access     SEAGATE  SX150176LC       BA08 PQ: 0 ANSI: 2
[   25.172116] scsi2:A:2:0: Tagged Queuing enabled.  Depth 32
[   25.172222]  target2:0:2: Beginning Domain Validation
[   25.178504]  target2:0:2: wide asynchronous
[   25.189460]  target2:0:2: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset 15)
[   25.193309]  target2:0:2: Domain Validation skipping write tests
[   25.193407]  target2:0:2: Ending Domain Validation
[   25.203341] SCSI device sdf: 97693755 512-byte hdwr sectors (50019 MB)
[   25.205673] sdf: Write Protect is off
[   25.208401] SCSI device sdf: drive cache: write through w/ FUA
[   25.209368] SCSI device sdf: 97693755 512-byte hdwr sectors (50019 MB)
[   25.212067] sdf: Write Protect is off
[   25.214866] SCSI device sdf: drive cache: write through w/ FUA
[   25.214965]  sdf: unknown partition table
[   25.233725] sd 2:0:2:0: Attached scsi disk sdf
[   25.243892] scsi 2:0:3:0: Direct-Access     SEAGATE  SX150176LC       BA12 PQ: 0 ANSI: 2
[   25.243991] scsi2:A:3:0: Tagged Queuing enabled.  Depth 32
[   25.244106]  target2:0:3: Beginning Domain Validation
[   25.249550]  target2:0:3: wide asynchronous
[   25.253758]  target2:0:3: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset 15)
[   25.257254]  target2:0:3: Domain Validation skipping write tests
[   25.257342]  target2:0:3: Ending Domain Validation
[   25.264705] SCSI device sdg: 97693755 512-byte hdwr sectors (50019 MB)
[   25.269670] sdg: Write Protect is off
[   25.272365] SCSI device sdg: drive cache: write through w/ FUA
[   25.273277] SCSI device sdg: 97693755 512-byte hdwr sectors (50019 MB)
[   25.275906] sdg: Write Protect is off
[   25.278531] SCSI device sdg: drive cache: write through w/ FUA
[   25.278614]  sdg: unknown partition table
[   25.297553] sd 2:0:3:0: Attached scsi disk sdg
[   25.306920] scsi 2:0:4:0: Direct-Access     SEAGATE  SX150176LC       BA12 PQ: 0 ANSI: 2
[   25.307062] scsi2:A:4:0: Tagged Queuing enabled.  Depth 32
[   25.307176]  target2:0:4: Beginning Domain Validation
[   25.312696]  target2:0:4: wide asynchronous
[   25.316827]  target2:0:4: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset 15)
[   25.320227]  target2:0:4: Domain Validation skipping write tests
[   25.320297]  target2:0:4: Ending Domain Validation
[   25.324299] SCSI device sdh: 97693755 512-byte hdwr sectors (50019 MB)
[   25.329720] sdh: Write Protect is off
[   25.332454] SCSI device sdh: drive cache: write through w/ FUA
[   25.333429] SCSI device sdh: 97693755 512-byte hdwr sectors (50019 MB)
[   25.336077] sdh: Write Protect is off
[   25.338771] SCSI device sdh: drive cache: write through w/ FUA
[   25.338869]  sdh: unknown partition table
[   25.359104] sd 2:0:4:0: Attached scsi disk sdh
[   27.442022] scsi 2:0:14:0: Processor         SYMBIOS  SYM2000          2    PQ: 0 ANSI: 2
[   27.442146]  target2:0:14: Beginning Domain Validation
[   27.442620]  target2:0:14: Ending Domain Validation
[   27.715907] ACPI: PCI Interrupt 0000:03:01.1[B] -> GSI 49 (level, low) -> IRQ 20
[   28.932735] scsi3 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
[   28.932738]         <Adaptec 3960D Ultra160 SCSI adapter>
[   28.932739]         aic7899: Ultra160 Wide Channel B, SCSI Id=7, 32/253 SCBs
[   28.932741] 
[   31.144275] scsi 3:0:0:0: Direct-Access     SEAGATE  SX150176LC       BA08 PQ: 0 ANSI: 2
[   31.144349] scsi3:A:0:0: Tagged Queuing enabled.  Depth 32
[   31.144435]  target3:0:0: Beginning Domain Validation
[   31.149771]  target3:0:0: wide asynchronous
[   31.153811]  target3:0:0: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset 15)
[   31.157108]  target3:0:0: Domain Validation skipping write tests
[   31.157155]  target3:0:0: Ending Domain Validation
[   31.165001] SCSI device sdi: 97693755 512-byte hdwr sectors (50019 MB)
[   31.167386] sdi: Write Protect is off
[   31.170053] SCSI device sdi: drive cache: write through w/ FUA
[   31.171047] SCSI device sdi: 97693755 512-byte hdwr sectors (50019 MB)
[   31.173749] sdi: Write Protect is off
[   31.177502] SCSI device sdi: drive cache: write through w/ FUA
[   31.177578]  sdi: unknown partition table
[   31.195213] sd 3:0:0:0: Attached scsi disk sdi
[   31.206853] scsi 3:0:1:0: Direct-Access     SEAGATE  SX150176LC       BA08 PQ: 0 ANSI: 2
[   31.206931] scsi3:A:1:0: Tagged Queuing enabled.  Depth 32
[   31.207036]  target3:0:1: Beginning Domain Validation
[   31.223265]  target3:0:1: wide asynchronous
[   31.227425]  target3:0:1: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset 15)
[   31.230835]  target3:0:1: Domain Validation skipping write tests
[   31.230904]  target3:0:1: Ending Domain Validation
[   31.234601] SCSI device sdj: 97693755 512-byte hdwr sectors (50019 MB)
[   31.236894] sdj: Write Protect is off
[   31.239667] SCSI device sdj: drive cache: write through w/ FUA
[   31.240835] SCSI device sdj: 97693755 512-byte hdwr sectors (50019 MB)
[   31.243557] sdj: Write Protect is off
[   31.249531] SCSI device sdj: drive cache: write through w/ FUA
[   31.249610]  sdj: unknown partition table
[   31.270734] sd 3:0:1:0: Attached scsi disk sdj
[   31.283528] scsi 3:0:2:0: Direct-Access     SEAGATE  SX150176LC       BA08 PQ: 0 ANSI: 2
[   31.284432] scsi3:A:2:0: Tagged Queuing enabled.  Depth 32
[   31.284547]  target3:0:2: Beginning Domain Validation
[   31.298487]  target3:0:2: wide asynchronous
[   31.305033]  target3:0:2: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset 15)
[   31.308464]  target3:0:2: Domain Validation skipping write tests
[   31.308533]  target3:0:2: Ending Domain Validation
[   31.316184] SCSI device sdk: 97693755 512-byte hdwr sectors (50019 MB)
[   31.319338] sdk: Write Protect is off
[   31.322105] SCSI device sdk: drive cache: write through w/ FUA
[   31.323146] SCSI device sdk: 97693755 512-byte hdwr sectors (50019 MB)
[   31.325842] sdk: Write Protect is off
[   31.329005] SCSI device sdk: drive cache: write through w/ FUA
[   31.329102]  sdk: unknown partition table
[   31.349209] sd 3:0:2:0: Attached scsi disk sdk
[   31.359122] scsi 3:0:3:0: Direct-Access     SEAGATE  SX150176LC       BA08 PQ: 0 ANSI: 2
[   31.359242] scsi3:A:3:0: Tagged Queuing enabled.  Depth 32
[   31.359417]  target3:0:3: Beginning Domain Validation
[   31.365700]  target3:0:3: wide asynchronous
[   31.370023]  target3:0:3: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset 15)
[   31.373668]  target3:0:3: Domain Validation skipping write tests
[   31.373734]  target3:0:3: Ending Domain Validation
[   31.385119] SCSI device sdl: 97693755 512-byte hdwr sectors (50019 MB)
[   31.387365] sdl: Write Protect is off
[   31.390054] SCSI device sdl: drive cache: write through w/ FUA
[   31.392132] SCSI device sdl: 97693755 512-byte hdwr sectors (50019 MB)
[   31.394836] sdl: Write Protect is off
[   31.398006] SCSI device sdl: drive cache: write through w/ FUA
[   31.398108]  sdl: unknown partition table
[   31.420194] sd 3:0:3:0: Attached scsi disk sdl
[   31.434188] scsi 3:0:4:0: Direct-Access     SEAGATE  SX150176LC       BA08 PQ: 0 ANSI: 2
[   31.434308] scsi3:A:4:0: Tagged Queuing enabled.  Depth 32
[   31.434469]  target3:0:4: Beginning Domain Validation
[   31.439914]  target3:0:4: wide asynchronous
[   31.444090]  target3:0:4: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset 15)
[   31.447536]  target3:0:4: Domain Validation skipping write tests
[   31.447606]  target3:0:4: Ending Domain Validation
[   31.450531] SCSI device sdm: 97693755 512-byte hdwr sectors (50019 MB)
[   31.452756] sdm: Write Protect is off
[   31.455505] SCSI device sdm: drive cache: write through w/ FUA
[   31.456542] SCSI device sdm: 97693755 512-byte hdwr sectors (50019 MB)
[   31.459668] sdm: Write Protect is off
[   31.462448] SCSI device sdm: drive cache: write through w/ FUA
[   31.462545]  sdm: unknown partition table
[   31.478519] sd 3:0:4:0: Attached scsi disk sdm
[   33.542811] scsi 3:0:14:0: Processor         SYMBIOS  SYM2000          2    PQ: 0 ANSI: 2
[   33.542942]  target3:0:14: Beginning Domain Validation
[   33.543501]  target3:0:14: Ending Domain Validation
[   33.831621] ACPI: PCI Interrupt 0000:05:01.0[A] -> GSI 16 (level, low) -> IRQ 21
[   34.847248] scsi4 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
[   34.847251]         <Adaptec 2940/DUAL Ultra SCSI adapter>
[   34.847252]         aic7895: Ultra Wide Channel A, SCSI Id=7, 32/253 SCBs
[   34.847253] 
[   35.396894] scsi 4:0:2:0: CD-ROM            PLEXTOR  CD-ROM PX-40TS   1.11 PQ: 0 ANSI: 2
[   35.397007]  target4:0:2: Beginning Domain Validation
[   35.403496]  target4:0:2: FAST-20 SCSI 20.0 MB/s ST (50 ns, offset 15)
[   35.408906]  target4:0:2: Domain Validation skipping write tests
[   35.408972]  target4:0:2: Ending Domain Validation
[   35.427265] scsi 4:0:3:0: CD-ROM            PLEXTOR  CD-R   PX-W4012S 1.01 PQ: 0 ANSI: 2
[   35.427407]  target4:0:3: Beginning Domain Validation
[   35.429785]  target4:0:3: FAST-20 SCSI 20.0 MB/s ST (50 ns, offset 15)
[   35.434272]  target4:0:3: Domain Validation skipping write tests
[   35.434336]  target4:0:3: Ending Domain Validation
[   35.457701] scsi 4:0:4:0: CD-ROM            NAKAMICH MJ-5.16S         1.07 PQ: 0 ANSI: 2
[   35.457864]  target4:0:4: Beginning Domain Validation
[   35.474212]  target4:0:4: FAST-10 SCSI 10.0 MB/s ST (100 ns, offset 15)
[   35.483112]  target4:0:4: Domain Validation skipping write tests
[   35.483187]  target4:0:4: Ending Domain Validation
[   35.489845] scsi 4:0:4:1: CD-ROM            NAKAMICH MJ-5.16S         1.07 PQ: 0 ANSI: 2
[   35.489970]  target4:0:4: FAST-10 SCSI 10.0 MB/s ST (100 ns, offset 15)
[   35.504490] scsi 4:0:4:2: CD-ROM            NAKAMICH MJ-5.16S         1.07 PQ: 0 ANSI: 2
[   35.504630]  target4:0:4: FAST-10 SCSI 10.0 MB/s ST (100 ns, offset 15)
[   35.531322] scsi 4:0:4:3: CD-ROM            NAKAMICH MJ-5.16S         1.07 PQ: 0 ANSI: 2
[   35.531457]  target4:0:4: FAST-10 SCSI 10.0 MB/s ST (100 ns, offset 15)
[   35.543143] scsi 4:0:4:4: CD-ROM            NAKAMICH MJ-5.16S         1.07 PQ: 0 ANSI: 2
[   35.543272]  target4:0:4: FAST-10 SCSI 10.0 MB/s ST (100 ns, offset 15)
[   35.645497] sr0: scsi3-mmc drive: 40x/40x writer dvd-ram cd/rw xa/form2 cdda tray
[   35.645566] Uniform CD-ROM driver Revision: 3.20
[   37.736693] scsi 4:0:5:0: CD-ROM            YAMAHA   CRW8424S         1.0d PQ: 0 ANSI: 2
[   37.736778]  target4:0:5: Beginning Domain Validation
[   37.755233]  target4:0:5: FAST-20 SCSI 20.0 MB/s ST (50 ns, offset 15)
[   37.764863]  target4:0:5: Domain Validation skipping write tests
[   37.764910]  target4:0:5: Ending Domain Validation
[   40.154122] ACPI: PCI Interrupt 0000:05:01.1[B] -> GSI 17 (level, low) -> IRQ 22
[   40.158190] scsi4: PCI error Interrupt at seqaddr = 0x1bb
[   40.158261] scsi4: Signaled a Target Abort
[   40.158777] sr1: scsi-1 drive
[   40.159611] scsi4:A:3:0: ahc_intr - referenced scb not valid during seqint 0x71 scb(255)
[   40.159719] >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
[   40.159720] scsi4: Dumping Card State in Message-in phase, at SEQADDR 0x1bb
[   40.159838] Card was paused
[   40.159888] ACCUM = 0x0, SINDEX = 0x71, DINDEX = 0xe4, ARG_2 = 0x0
[   40.159940] HCNT = 0x8 SCBPTR = 0x0
[   40.159993] SCSISIGI[0xe6]:(REQI|BSYI|MSGI|IOI|CDI) 
[   40.160298] ERROR[0x40]:(PCIERRSTAT) SCSIBUSL[0x0] 
[   40.160534] LASTPHASE[0xe0]:(MSGI|IOI|CDI) SCSISEQ[0x12]:(ENAUTOATNP|ENRSELI) 
[   40.160914] SBLKCTL[0x2]:(SELWIDE) SCSIRATE[0xf]:(SXFR_ULTRA2) 
[   40.161187] SEQCTL[0x10]:(FASTMODE) SEQ_FLAGS[0x0] 
[   40.161420] SSTAT0[0x6]:(SPIORDY|SDONE) SSTAT1[0x3]:(REQINIT|PHASECHG) 
[   40.161742] SSTAT2[0x0] SSTAT3[0x0] SIMODE0[0x0] 
[   40.162003] SIMODE1[0xac]:(ENSCSIPERR|ENBUSFREE|ENSCSIRST|ENSELTIMO) 
[   40.162271] SXFRCTL0[0xa8]:(SPIOEN|FAST20|DFON) 
[   40.162504] DFCNTRL[0x4]:(DIRECTION) DFSTATUS[0x65]:(FIFOEMP|DFTHRESH|FIFOQWDEMP|DFCACHETH) 
[   40.162870] STACK: 0x114 0x0 0x179 0x18f
[   40.163058] SCB count = 4
[   40.163142] Kernel NEXTQSCB = 3
[   40.163188] Card NEXTQSCB = 3
[   40.163233] QINFIFO entries: 
[   40.163322] Waiting Queue entries: 
[   40.163408] Disconnected Queue entries: 
[   40.163491] QOUTFIFO entries: 
[   40.163582] Sequencer Free SCB List: 1 
[   40.163712] Sequencer SCB Info: 
[   40.163761]   0 SCB_CONTROL[0xff]:(DISCONNECTED|ULTRAENB|MK_MESSAGE|TAG_ENB|DISCENB|TARGET_SCB|SCB_TAG_TYPE) 
[   40.164330] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[   40.164623] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[   40.164911]   1 SCB_CONTROL[0xff]:(DISCONNECTED|ULTRAENB|MK_MESSAGE|TAG_ENB|DISCENB|TARGET_SCB|SCB_TAG_TYPE) 
[   40.165430] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[   40.165698] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[   40.165971]   2 SCB_CONTROL[0xff]:(DISCONNECTED|ULTRAENB|MK_MESSAGE|TAG_ENB|DISCENB|TARGET_SCB|SCB_TAG_TYPE) 
[   40.166476] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[   40.166724] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[   40.166949]   3 SCB_CONTROL[0xff]:(DISCONNECTED|ULTRAENB|MK_MESSAGE|TAG_ENB|DISCENB|TARGET_SCB|SCB_TAG_TYPE) 
[   40.167435] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[   40.167683] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[   40.167927]   4 SCB_CONTROL[0xff]:(DISCONNECTED|ULTRAENB|MK_MESSAGE|TAG_ENB|DISCENB|TARGET_SCB|SCB_TAG_TYPE) 
[   40.168435] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[   40.168708] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[   40.168971]   5 SCB_CONTROL[0xff]:(DISCONNECTED|ULTRAENB|MK_MESSAGE|TAG_ENB|DISCENB|TARGET_SCB|SCB_TAG_TYPE) 
[   40.169556] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[   40.170055] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[   40.170290]   6 SCB_CONTROL[0xff]:(DISCONNECTED|ULTRAENB|MK_MESSAGE|TAG_ENB|DISCENB|TARGET_SCB|SCB_TAG_TYPE) 
[   40.170775] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[   40.171011] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[   40.171236]   7 SCB_CONTROL[0xff]:(DISCONNECTED|ULTRAENB|MK_MESSAGE|TAG_ENB|DISCENB|TARGET_SCB|SCB_TAG_TYPE) 
[   40.171695] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[   40.171921] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[   40.172139]   8 SCB_CONTROL[0xff]:(DISCONNECTED|ULTRAENB|MK_MESSAGE|TAG_ENB|DISCENB|TARGET_SCB|SCB_TAG_TYPE) 
[   40.172592] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[   40.172815] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[   40.173034]   9 SCB_CONTROL[0xff]:(DISCONNECTED|ULTRAENB|MK_MESSAGE|TAG_ENB|DISCENB|TARGET_SCB|SCB_TAG_TYPE) 
[   40.173487] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[   40.173711] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[   40.173946]  10 SCB_CONTROL[0xff]:(DISCONNECTED|ULTRAENB|MK_MESSAGE|TAG_ENB|DISCENB|TARGET_SCB|SCB_TAG_TYPE) 
[   40.174403] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[   40.174626] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[   40.174847]  11 SCB_CONTROL[0xff]:(DISCONNECTED|ULTRAENB|MK_MESSAGE|TAG_ENB|DISCENB|TARGET_SCB|SCB_TAG_TYPE) 
[   40.175299] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[   40.175524] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[   40.175747]  12 SCB_CONTROL[0xff]:(DISCONNECTED|ULTRAENB|MK_MESSAGE|TAG_ENB|DISCENB|TARGET_SCB|SCB_TAG_TYPE) 
[   40.177129] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[   40.177392] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[   40.177622]  13 SCB_CONTROL[0xff]:(DISCONNECTED|ULTRAENB|MK_MESSAGE|TAG_ENB|DISCENB|TARGET_SCB|SCB_TAG_TYPE) 
[   40.178111] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[   40.178337] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[   40.178551]  14 SCB_CONTROL[0xff]:(DISCONNECTED|ULTRAENB|MK_MESSAGE|TAG_ENB|DISCENB|TARGET_SCB|SCB_TAG_TYPE) 
[   40.179026] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[   40.179268] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[   40.179491]  15 SCB_CONTROL[0xff]:(DISCONNECTED|ULTRAENB|MK_MESSAGE|TAG_ENB|DISCENB|TARGET_SCB|SCB_TAG_TYPE) 
[   40.180118] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[   40.180329] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[   40.180536]  16 SCB_CONTROL[0xff]:(DISCONNECTED|ULTRAENB|MK_MESSAGE|TAG_ENB|DISCENB|TARGET_SCB|SCB_TAG_TYPE) 
[   40.180963] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[   40.181174] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[   40.181381]  17 SCB_CONTROL[0xff]:(DISCONNECTED|ULTRAENB|MK_MESSAGE|TAG_ENB|DISCENB|TARGET_SCB|SCB_TAG_TYPE) 
[   40.181808] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[   40.182023] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[   40.182229]  18 SCB_CONTROL[0xff]:(DISCONNECTED|ULTRAENB|MK_MESSAGE|TAG_ENB|DISCENB|TARGET_SCB|SCB_TAG_TYPE) 
[   40.182657] SCB_SCSIID[0xff][   40.195507]  [<c011b69d>] [   40.195587]  [<f8859af4>] ahc_handle_seqint+0x16af/0x2bea [aic7xxx]
[   40.195679]  [<f883323e>] e1000_unmap_and_free_tx_resource+0x14/0x22 [e1000]
[   40.195768]  [<f88348fe>] e1000_clean_tx_irq+0x68/0x259 [e1000]
[   40.195855]  [<f8866d28>] ahc_linux_isr+0x22c/0x247 [aic7xxx]
[   40.195943]  [<c013a18d>] handle_IRQ_event+0x31/0x5a
[   40.196025]  [<c013b5c2>] handle_fasteoi_irq+0x73/0xbd
[   40.196105]  [<c013b54f>] handle_fasteoi_irq+0x0/0xbd
[   40.196185]  [<c01059ff>] do_IRQ+0x83/0xe4
[   40.196267]  [<c010397a>] common_interrupt+0x1a/0x20
[   40.196348]  [<f885da4f>] ahc_read_seeprom+0x23c/0x36e [aic7xxx]
[   40.196435]  [<f885fe51>] ahc_pci_config+0x4ce/0x17c3 [aic7xxx]
[   40.196521]  [<c010e400>] mp_register_gsi+0xe8/0x1ca
[   40.196600]  [<c0256f51>] pci_conf1_read+0x85/0xc4
[   40.196682]  [<c025847d>] pci_read+0x3d/0x41
[   40.196763]  [<c01c74a1>] pci_bus_read_config_byte+0x5d/0x65
[   40.196845]  [<f886829c>] ahc_linux_pci_dev_probe+0xec/0x1e1 [aic7xxx]
[   40.196934]  [<c0190960>] sysfs_dirent_exist+0x47/0x72
[   40.197015]  [<c019178d>] sysfs_create_link+0x75/0x180
[   40.197225]  [<c01cbd32>] pci_match_device+0x1e/0xd2
[   40.197305]  [<c0209199>] get_device+0x1b/0x24
[   40.197385]  [<c01cbe60>] pci_device_probe+0x51/0x6d
[   40.197465]  [<c020b795>] really_probe+0x33/0xe2
[   40.197545]  [<c020b96e>] __driver_attach+0x0/0x8f
[   40.197626]  [<c020b9fb>] __driver_attach+0x8d/0x8f
[   40.197705]  [<c020acbc>] bus_for_each_dev+0x58/0x77
[   40.197785]  [<c020b695>] driver_attach+0x26/0x2a
[   40.197866]  [<c020b96e>] __driver_attach+0x0/0x8f
[   40.197947]  [<c020b086>] bus_add_driver+0x6c/0x1ab
[   40.198026]  [<c020bba4>] driver_register+0x5e/0x95
[   40.198106]  [<c01cc018>] __pci_register_driver+0x8a/0xb2
[   40.198187]  [<f88681ac>] ahc_linux_pci_init+0x17/0x1b [aic7xxx]
[   40.198274]  [<f881618e>] ahc_linux_init+0x18e/0x3b7 [aic7xxx]
[   40.198359]  [<c0139a63>] __stop_machine_run+0x87/0xaf
[   40.198439]  [<c02bc3da>] wait_for_completion+0x93/0x9a
[   40.198522]  [<c0136f56>] sys_init_module+0x14c/0x1c56
[   40.198606]  [<c0102ff3>] syscall_call+0x7/0xb
[   40.198686]  =======================

When it works (Full dmesg):
------------------------------------------------------------------------------
[    0.000000] Linux version 2.6.19 (root@(none)) (gcc version 4.1.2
20061115 (prerelease) (Debian 4.1.1-21)) #2 SMP PREEMPT Fri Feb 2 13:58:34
EST 2007
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009b400 (usable)
[    0.000000]  BIOS-e820: 000000000009b400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003ff70000 (usable)
[    0.000000]  BIOS-e820: 000000003ff70000 - 000000003ff78000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003ff78000 - 000000003ff80000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003ff80000 - 0000000040000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff800000 - 00000000ffc00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000] 127MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] found SMP MP-table at 000f61f0
[    0.000000] Entering add_active_range(0, 0, 262000) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->   262000
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   262000
[    0.000000] On node 0 totalpages: 262000
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 1760 pages used for memmap
[    0.000000]   Normal zone: 223520 pages, LIFO batch:31
[    0.000000]   HighMem zone: 254 pages used for memmap
[    0.000000]   HighMem zone: 32370 pages, LIFO batch:7
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP (v000 PTLTD                                 ) @
0x000f6180
[    0.000000] ACPI: RSDT (v001 PTLTD    RSDT   0x06040000  LTP 0x00000000)
@ 0x3ff73fb9
[    0.000000] ACPI: FADT (v001 INTEL  PLACER   0x06040000 PTL  0x00000008)
@ 0x3ff77e78
[    0.000000] ACPI: MADT (v001 PTLTD    APIC   0x06040000  LTP 0x00000000)
@ 0x3ff77eec
[    0.000000] ACPI: BOOT (v001 PTLTD  $SBFTBL$ 0x06040000  LTP 0x00000001)
@ 0x3ff77f88
[    0.000000] ACPI: SPCR (v001 PTLTD  $UCRTBL$ 0x06040000 PTL  0x00000001)
@ 0x3ff77fb0
[    0.000000] ACPI: DSDT (v001  INTEL   PLACER 0x06040000 MSFT 0x0100000e)
@ 0x00000000
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] Processor #0 15:2 APIC version 20
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x06] enabled)
[    0.000000] Processor #6 15:2 APIC version 20
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1 15:2 APIC version 20
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x07] enabled)
[    0.000000] Processor #7 15:2 APIC version 20
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI
0-23
[    0.000000] ACPI: IOAPIC (id[0x03] address[0xfec80000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 3, version 32, address 0xfec80000, GSI
24-47
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec80100] gsi_base[48])
[    0.000000] IOAPIC[2]: apic_id 4, version 32, address 0xfec80100, GSI
48-71
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 3 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 50000000 (gap:
40000000:bec00000)
[    0.000000] Detected 2666.062 MHz processor.
[   55.250445] Built 1 zonelists.  Total pages: 259954
[   55.250448] Kernel command line: root=/dev/sda1 init=/bin/sh
[   55.250621] mapped APIC to ffffd000 (fee00000)
[   55.250624] mapped IOAPIC to ffffc000 (fec00000)
[   55.250626] mapped IOAPIC to ffffb000 (fec80000)
[   55.250629] mapped IOAPIC to ffffa000 (fec80100)
[   55.250632] Enabling fast FPU save and restore... done.
[   55.250635] Enabling unmasked SIMD FPU exception support... done.
[   55.250639] Initializing CPU#0
[   55.250736] CPU 0 irqstacks, hard=c03af000 soft=c03ab000
[   55.250739] PID hash table entries: 4096 (order: 12, 16384 bytes)
[   55.251850] Console: colour VGA+ 80x25
[   55.254826] Dentry cache hash table entries: 131072 (order: 7, 524288
bytes)
[   55.255566] Inode-cache hash table entries: 65536 (order: 6, 262144
bytes)
[   55.280544] Memory: 1035056k/1048000k available (1787k kernel code,
12304k reserved, 697k data, 208k init, 130496k highmem)
[   55.280613] virtual kernel memory layout:
[   55.280614]     fixmap  : 0xfff83000 - 0xfffff000   ( 496 kB)
[   55.280615]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[   55.280616]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[   55.280617]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[   55.280618]       .init : 0xc0372000 - 0xc03a6000   ( 208 kB)
[   55.280619]       .data : 0xc02bed2f - 0xc036d434   ( 697 kB)
[   55.280620]       .text : 0xc0100000 - 0xc02bed2f   (1787 kB)
[   55.280963] Checking if this processor honours the WP bit even in
supervisor mode... Ok.
[   55.358716] Calibrating delay using timer specific routine.. 5336.07
BogoMIPS (lpj=10672156)
[   55.358857] Mount-cache hash table entries: 512
[   55.359038] CPU: After generic identify, caps: bfebfbff 00000000 00000000
00000000 00004400 00000000 00000000
[   55.359050] CPU: Trace cache: 12K uops, L1 D cache: 8K
[   55.359128] CPU: L2 cache: 512K
[   55.359171] CPU: Physical Processor ID: 0
[   55.359215] CPU: After all inits, caps: bfebfbff 00000000 00000000
00000080 00004400 00000000 00000000
[   55.359223] Intel machine check architecture supported.
[   55.359270] Intel machine check reporting enabled on CPU#0.
[   55.359316] CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
[   55.359362] CPU0: Thermal monitoring enabled
[   55.359425] Checking 'hlt' instruction... OK.
[   55.374998] Freeing SMP alternatives: 12k freed
[   55.375043] ACPI: Core revision 20060707
[   55.379527] CPU0: Intel(R) Xeon(TM) CPU 2.66GHz stepping 05
[   55.379658] Booting processor 1/1 eip 2000
[   55.379703] CPU 1 irqstacks, hard=c03b0000 soft=c03ac000
[   55.390041] Initializing CPU#1
[   55.470689] Calibrating delay using timer specific routine.. 5332.22
BogoMIPS (lpj=10664440)
[   55.470698] CPU: After generic identify, caps: bfebfbff 00000000 00000000
00000000 00004400 00000000 00000000
[   55.470709] CPU: Trace cache: 12K uops, L1 D cache: 8K
[   55.470712] CPU: L2 cache: 512K
[   55.470714] CPU: Physical Processor ID: 0
[   55.470716] CPU: After all inits, caps: bfebfbff 00000000 00000000
00000080 00004400 00000000 00000000
[   55.470724] Intel machine check architecture supported.
[   55.470730] Intel machine check reporting enabled on CPU#1.
[   55.470733] CPU1: Intel P4/Xeon Extended MCE MSRs (12) available
[   55.470736] CPU1: Thermal monitoring enabled
[   55.470907] CPU1: Intel(R) Xeon(TM) CPU 2.66GHz stepping 05
[   55.471437] Booting processor 2/6 eip 2000
[   55.471483] CPU 2 irqstacks, hard=c03b1000 soft=c03ad000
[   55.482063] Initializing CPU#2
[   55.562668] Calibrating delay using timer specific routine.. 5332.23
BogoMIPS (lpj=10664471)
[   55.562676] CPU: After generic identify, caps: bfebfbff 00000000 00000000
00000000 00004400 00000000 00000000
[   55.562684] CPU: Trace cache: 12K uops, L1 D cache: 8K
[   55.562687] CPU: L2 cache: 512K
[   55.562688] CPU: Physical Processor ID: 3
[   55.562690] CPU: After all inits, caps: bfebfbff 00000000 00000000
00000080 00004400 00000000 00000000
[   55.562696] Intel machine check architecture supported.
[   55.562701] Intel machine check reporting enabled on CPU#2.
[   55.562703] CPU2: Intel P4/Xeon Extended MCE MSRs (12) available
[   55.562706] CPU2: Thermal monitoring enabled
[   55.562917] CPU2: Intel(R) Xeon(TM) CPU 2.66GHz stepping 05
[   55.563430] Booting processor 3/7 eip 2000
[   55.563475] CPU 3 irqstacks, hard=c03b2000 soft=c03ae000
[   55.573716] Initializing CPU#3
[   55.654647] Calibrating delay using timer specific routine.. 5332.30
BogoMIPS (lpj=10664613)
[   55.654656] CPU: After generic identify, caps: bfebfbff 00000000 00000000
00000000 00004400 00000000 00000000
[   55.654667] CPU: Trace cache: 12K uops, L1 D cache: 8K
[   55.654670] CPU: L2 cache: 512K
[   55.654672] CPU: Physical Processor ID: 3
[   55.654674] CPU: After all inits, caps: bfebfbff 00000000 00000000
00000080 00004400 00000000 00000000
[   55.654681] Intel machine check architecture supported.
[   55.654687] Intel machine check reporting enabled on CPU#3.
[   55.654690] CPU3: Intel P4/Xeon Extended MCE MSRs (12) available
[   55.654694] CPU3: Thermal monitoring enabled
[   55.654822] CPU3: Intel(R) Xeon(TM) CPU 2.66GHz stepping 05
[   55.655331] Total of 4 processors activated (21332.84 BogoMIPS).
[   55.655667] ENABLING IO-APIC IRQs
[   55.655888] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[   55.802622] checking TSC synchronization across 4 CPUs: passed.
[    0.011955] Brought up 4 CPUs
[    0.111712] migration_cost=81
[    0.112311] NET: Registered protocol family 16
[    0.112440] ACPI: bus type pci registered
[    0.116387] PCI: PCI BIOS revision 2.10 entry at 0xfd8e5, last bus=5
[    0.116433] PCI: Using configuration type 1
[    0.116477] Setting up standard PCI resources
[    0.138385] ACPI: Interpreter enabled
[    0.138432] ACPI: Using IOAPIC for interrupt routing
[    0.138963] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.139012] PCI: Probing PCI hardware (bus 00)
[    0.142048] PCI quirk: region 1000-107f claimed by ICH4 ACPI/GPIO/TCO
[    0.142097] PCI quirk: region 1180-11bf claimed by ICH4 GPIO
[    0.142190] PCI: Ignoring BAR0-3 of IDE controller 0000:00:1f.1
[    0.142427] Boot video device is 0000:01:00.0
[    0.143401] PCI: Transparent bridge - 0000:00:1e.0
[    0.143475] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.148826] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 10 *11 14 15)
[    0.149298] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 10 *11 14 15)
[    0.149762] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 10 11 14 15) *5
[    0.150259] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 *10 11 14 15)
[    0.150729] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 10 *11 14 15)
[    0.151201] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 10 *11 14 15)
[    0.151672] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 10 11 14 15) *0,
disabled.
[    0.152260] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 10 *11 14 15)
[    0.154636] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.ICH4._PRT]
[    0.155489] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HLB_.P64A._PRT]
[    0.155843] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HLB_.P64B._PRT]
[    0.156625] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
[    0.156982] SCSI subsystem initialized
[    0.157066] PCI: Using ACPI for IRQ routing
[    0.157111] PCI: If a device doesn't work, try "pci=routeirq".  If it
helps, post a report
[    0.208710] PCI: Bridge: 0000:00:01.0
[    0.208756]   IO window: 3000-3fff
[    0.208800]   MEM window: d0100000-d01fffff
[    0.208845]   PREFETCH window: e8000000-f7ffffff
[    0.208895] PCI: Bridge: 0000:02:1d.0
[    0.208939]   IO window: 4000-4fff
[    0.208985]   MEM window: d0300000-d03fffff
[    0.209031]   PREFETCH window: 50000000-500fffff
[    0.209079] PCI: Bridge: 0000:02:1f.0
[    0.209122]   IO window: 5000-5fff
[    0.209168]   MEM window: d0400000-d04fffff
[    0.209213]   PREFETCH window: 50100000-501fffff
[    0.209260] PCI: Bridge: 0000:00:02.0
[    0.209303]   IO window: 4000-5fff
[    0.209347]   MEM window: d0200000-d04fffff
[    0.209392]   PREFETCH window: 50000000-501fffff
[    0.209438] PCI: Bridge: 0000:00:1e.0
[    0.209482]   IO window: 6000-6fff
[    0.209528]   MEM window: d0500000-d05fffff
[    0.209574]   PREFETCH window: 50200000-502fffff
[    0.209652] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[    0.209693] NET: Registered protocol family 2
[    0.247969] IP route cache hash table entries: 32768 (order: 5, 131072
bytes)
[    0.248250] TCP established hash table entries: 131072 (order: 8, 1572864
bytes)
[    0.250005] TCP bind hash table entries: 65536 (order: 7, 786432 bytes)
[    0.251093] TCP: Hash tables configured (established 131072 bind 65536)
[    0.251144] TCP reno registered
[    0.251391] Simple Boot Flag at 0x36 set to 0x1
[    0.251493] Machine check exception polling timer started.
[    0.251858] highmem bounce pool size: 64 pages
[    0.252182] io scheduler noop registered
[    0.252259] io scheduler deadline registered (default)
[    0.252605] ACPI: Power Button (FF) [PWRF]
[    0.252680] ACPI: Power Button (CM) [PWRB]
[    0.255428] ACPI: PCI Interrupt 0000:04:03.0[A] -> GSI 32 (level, low) ->
IRQ 16
[    1.375658] scsi0 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 3.0
[    1.375660]         <Adaptec AIC7902 Ultra320 SCSI adapter>
[    1.375661]         aic7902: Ultra320 Wide Channel A, SCSI Id=7, PCI-X
101-133Mhz, 512 SCBs
[    1.375662] 
[    1.388245] scsi 0:0:0:0: Direct-Access     SEAGATE  ST34572W
0876 PQ: 0 ANSI: 2
[    1.388304]  target0:0:0: asynchronous
[    1.388347] scsi0:A:0:0: Tagged Queuing enabled.  Depth 32
[    1.388432]  target0:0:0: Beginning Domain Validation
[    1.402919]  target0:0:0: wide asynchronous
[    1.413551]  target0:0:0: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset
15)
[    1.423495]  target0:0:0: Domain Validation skipping write tests
[    1.423541]  target0:0:0: Ending Domain Validation
[    1.436046] scsi 0:0:1:0: Direct-Access     QUANTUM  QM39100TD-SW
N491 PQ: 0 ANSI: 2
[    1.436102]  target0:0:1: asynchronous
[    1.436145] scsi0:A:1:0: Tagged Queuing enabled.  Depth 32
[    1.436226]  target0:0:1: Beginning Domain Validation
[    1.440886]  target0:0:1: wide asynchronous
[    1.444053]  target0:0:1: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset
31)
[    1.446464]  target0:0:1: Domain Validation skipping write tests
[    1.446509]  target0:0:1: Ending Domain Validation
[    2.996166] scsi 0:0:9:0: Direct-Access     QUANTUM  QM39100TD-SW
N491 PQ: 0 ANSI: 2
[    2.996224]  target0:0:9: asynchronous
[    2.996267] scsi0:A:9:0: Tagged Queuing enabled.  Depth 32
[    2.996347]  target0:0:9: Beginning Domain Validation
[    3.000824]  target0:0:9: wide asynchronous
[    3.004197]  target0:0:9: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset
31)
[    3.006565]  target0:0:9: Domain Validation skipping write tests
[    3.006610]  target0:0:9: Ending Domain Validation
[    4.550696] ACPI: PCI Interrupt 0000:04:03.1[B] -> GSI 33 (level, low) ->
IRQ 17
[    5.670712] scsi1 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 3.0
[    5.670714]         <Adaptec AIC7902 Ultra320 SCSI adapter>
[    5.670715]         aic7902: Ultra320 Wide Channel B, SCSI Id=7, PCI-X
101-133Mhz, 512 SCBs
[    5.670717] 
[   11.839403] scsi 1:0:13:0: CD-ROM            HL-DT-ST DVDRAM GSA-4160B
A300 PQ: 0 ANSI: 2
[   11.839462]  target1:0:13: asynchronous
[   11.839513]  target1:0:13: Beginning Domain Validation
[   11.855350]  target1:0:13: wide asynchronous
[   11.866981]  target1:0:13: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset
14)
[   11.878231]  target1:0:13: Domain Validation skipping write tests
[   11.878277]  target1:0:13: Ending Domain Validation
[   12.404878] SCSI device sda: 8888924 512-byte hdwr sectors (4551 MB)
[   12.408854] sda: Write Protect is off
[   12.408898] sda: Mode Sense: 9f 00 10 08
[   12.413080] SCSI device sda: drive cache: write back w/ FUA
[   12.415659] SCSI device sda: 8888924 512-byte hdwr sectors (4551 MB)
[   12.419610] sda: Write Protect is off
[   12.419653] sda: Mode Sense: 9f 00 10 08
[   12.423836] SCSI device sda: drive cache: write back w/ FUA
[   12.423881]  sda: sda1 sda2
[   12.440659] sd 0:0:0:0: Attached scsi disk sda
[   12.443705] SCSI device sdb: 17783250 512-byte hdwr sectors (9105 MB)
[   12.445824] sdb: Write Protect is off
[   12.445867] sdb: Mode Sense: e1 00 10 08
[   12.447628] SCSI device sdb: drive cache: write back w/ FUA
[   12.448400] SCSI device sdb: 17783250 512-byte hdwr sectors (9105 MB)
[   12.450768] sdb: Write Protect is off
[   12.450812] sdb: Mode Sense: e1 00 10 08
[   12.452574] SCSI device sdb: drive cache: write back w/ FUA
[   12.452619]  sdb: unknown partition table
[   12.453154] sd 0:0:1:0: Attached scsi disk sdb
[   12.456197] SCSI device sdc: 17783250 512-byte hdwr sectors (9105 MB)
[   12.458370] sdc: Write Protect is off
[   12.458413] sdc: Mode Sense: e1 00 10 08
[   12.460217] SCSI device sdc: drive cache: write back w/ FUA
[   12.460980] SCSI device sdc: 17783250 512-byte hdwr sectors (9105 MB)
[   12.463098] sdc: Write Protect is off
[   12.463141] sdc: Mode Sense: e1 00 10 08
[   12.464899] SCSI device sdc: drive cache: write back w/ FUA
[   12.464944]  sdc: unknown partition table
[   12.465467] sd 0:0:9:0: Attached scsi disk sdc
[   12.467860] serio: i8042 KBD port at 0x60,0x64 irq 1
[   12.467908] serio: i8042 AUX port at 0x60,0x64 irq 12
[   12.468036] mice: PS/2 mouse device common for all mice
[   12.468223] input: PC Speaker as /class/input/input0
[   12.488053] input: AT Translated Set 2 keyboard as /class/input/input1
[   12.653197] TCP cubic registered
[   12.653248] NET: Registered protocol family 1
[   12.653350] Starting balanced_irq
[   12.653408] Using IPI Shortcut mode
[   12.657074] Time: tsc clocksource has been installed.
[   12.759066] EXT3-fs: INFO: recovery required on readonly filesystem.
[   12.759114] EXT3-fs: write access will be enabled during recovery.
[   13.300716] kjournald starting.  Commit interval 5 seconds
[   13.300732] EXT3-fs: recovery complete.
[   13.322667] EXT3-fs: mounted filesystem with ordered data mode.
[   13.322769] VFS: Mounted root (ext3 filesystem) readonly.
[   13.323025] Freeing unused kernel memory: 208k freed
[   18.236341] ACPI: PCI Interrupt 0000:03:01.0[A] -> GSI 48 (level, low) ->
IRQ 18
[   19.447683] scsi2 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
[   19.447686]         <Adaptec 3960D Ultra160 SCSI adapter>
[   19.447688]         aic7899: Ultra160 Wide Channel A, SCSI Id=7, 32/253
SCBs
[   19.447689] 
[   21.687533] scsi 2:0:0:0: Direct-Access     SEAGATE  SX150176LC
BA12 PQ: 0 ANSI: 2
[   21.687601] scsi2:A:0:0: Tagged Queuing enabled.  Depth 32
[   21.687690]  target2:0:0: Beginning Domain Validation
[   21.692983]  target2:0:0: wide asynchronous
[   21.696996]  target2:0:0: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset
15)
[   21.700265]  target2:0:0: Domain Validation skipping write tests
[   21.700311]  target2:0:0: Ending Domain Validation
[   21.707201] SCSI device sdd: 97693755 512-byte hdwr sectors (50019 MB)
[   21.709832] sdd: Write Protect is off
[   21.709889] sdd: Mode Sense: cb 00 10 08
[   21.712379] SCSI device sdd: drive cache: write through w/ FUA
[   21.713240] SCSI device sdd: 97693755 512-byte hdwr sectors (50019 MB)
[   21.715834] sdd: Write Protect is off
[   21.715880] sdd: Mode Sense: cb 00 10 08
[   21.718353] SCSI device sdd: drive cache: write through w/ FUA
[   21.718401]  sdd: unknown partition table
[   21.742790] sd 2:0:0:0: Attached scsi disk sdd
[   21.752477] scsi 2:0:1:0: Direct-Access     SEAGATE  SX150176LC
BA08 PQ: 0 ANSI: 2
[   21.752548] scsi2:A:1:0: Tagged Queuing enabled.  Depth 32
[   21.752653]  target2:0:1: Beginning Domain Validation
[   21.762443]  target2:0:1: wide asynchronous
[   21.767231]  target2:0:1: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset
15)
[   21.771093]  target2:0:1: Domain Validation skipping write tests
[   21.771143]  target2:0:1: Ending Domain Validation
[   21.775329] SCSI device sde: 97693755 512-byte hdwr sectors (50019 MB)
[   21.777516] sde: Write Protect is off
[   21.777564] sde: Mode Sense: cb 00 10 08
[   21.780113] SCSI device sde: drive cache: write through w/ FUA
[   21.781010] SCSI device sde: 97693755 512-byte hdwr sectors (50019 MB)
[   21.783747] sde: Write Protect is off
[   21.783809] sde: Mode Sense: cb 00 10 08
[   21.786377] SCSI device sde: drive cache: write through w/ FUA
[   21.786428]  sde: unknown partition table
[   21.805915] sd 2:0:1:0: Attached scsi disk sde
[   21.817669] scsi 2:0:2:0: Direct-Access     SEAGATE  SX150176LC
BA08 PQ: 0 ANSI: 2
[   21.817758] scsi2:A:2:0: Tagged Queuing enabled.  Depth 32
[   21.817857]  target2:0:2: Beginning Domain Validation
[   21.823531]  target2:0:2: wide asynchronous
[   21.829319]  target2:0:2: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset
15)
[   21.832716]  target2:0:2: Domain Validation skipping write tests
[   21.832768]  target2:0:2: Ending Domain Validation
[   21.838742] SCSI device sdf: 97693755 512-byte hdwr sectors (50019 MB)
[   21.844503] sdf: Write Protect is off
[   21.844562] sdf: Mode Sense: cb 00 10 08
[   21.848184] SCSI device sdf: drive cache: write through w/ FUA
[   21.849129] SCSI device sdf: 97693755 512-byte hdwr sectors (50019 MB)
[   21.851754] sdf: Write Protect is off
[   21.851798] sdf: Mode Sense: cb 00 10 08
[   21.854339] SCSI device sdf: drive cache: write through w/ FUA
[   21.854388]  sdf: unknown partition table
[   21.871229] sd 2:0:2:0: Attached scsi disk sdf
[   21.883201] scsi 2:0:3:0: Direct-Access     SEAGATE  SX150176LC
BA12 PQ: 0 ANSI: 2
[   21.883286] scsi2:A:3:0: Tagged Queuing enabled.  Depth 32
[   21.883401]  target2:0:3: Beginning Domain Validation
[   21.888902]  target2:0:3: wide asynchronous
[   21.893187]  target2:0:3: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset
15)
[   21.896573]  target2:0:3: Domain Validation skipping write tests
[   21.896623]  target2:0:3: Ending Domain Validation
[   21.907010] SCSI device sdg: 97693755 512-byte hdwr sectors (50019 MB)
[   21.909659] sdg: Write Protect is off
[   21.909716] sdg: Mode Sense: cb 00 10 08
[   21.912238] SCSI device sdg: drive cache: write through w/ FUA
[   21.913085] SCSI device sdg: 97693755 512-byte hdwr sectors (50019 MB)
[   21.915738] sdg: Write Protect is off
[   21.915827] sdg: Mode Sense: cb 00 10 08
[   21.918391] SCSI device sdg: drive cache: write through w/ FUA
[   21.918444]  sdg: unknown partition table
[   21.936874] sd 2:0:3:0: Attached scsi disk sdg
[   21.942181] scsi 2:0:4:0: Direct-Access     SEAGATE  SX150176LC
BA12 PQ: 0 ANSI: 2
[   21.942279] scsi2:A:4:0: Tagged Queuing enabled.  Depth 32
[   21.942398]  target2:0:4: Beginning Domain Validation
[   21.948010]  target2:0:4: wide asynchronous
[   21.952283]  target2:0:4: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset
15)
[   21.955659]  target2:0:4: Domain Validation skipping write tests
[   21.955724]  target2:0:4: Ending Domain Validation
[   21.961746] SCSI device sdh: 97693755 512-byte hdwr sectors (50019 MB)
[   21.964417] sdh: Write Protect is off
[   21.964490] sdh: Mode Sense: cb 00 10 08
[   21.967099] SCSI device sdh: drive cache: write through w/ FUA
[   21.968045] SCSI device sdh: 97693755 512-byte hdwr sectors (50019 MB)
[   21.970696] sdh: Write Protect is off
[   21.970765] sdh: Mode Sense: cb 00 10 08
[   21.973339] SCSI device sdh: drive cache: write through w/ FUA
[   21.973412]  sdh: unknown partition table
[   21.991326] sd 2:0:4:0: Attached scsi disk sdh
[   24.078966] scsi 2:0:14:0: Processor         SYMBIOS  SYM2000          2
PQ: 0 ANSI: 2
[   24.079058]  target2:0:14: Beginning Domain Validation
[   24.079519]  target2:0:14: Ending Domain Validation
[   24.354730] ACPI: PCI Interrupt 0000:03:01.1[B] -> GSI 49 (level, low) ->
IRQ 19
[   25.566346] scsi3 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
[   25.566349]         <Adaptec 3960D Ultra160 SCSI adapter>
[   25.566350]         aic7899: Ultra160 Wide Channel B, SCSI Id=7, 32/253
SCBs
[   25.566352] 
[   27.781555] scsi 3:0:0:0: Direct-Access     SEAGATE  SX150176LC
BA08 PQ: 0 ANSI: 2
[   27.781623] scsi3:A:0:0: Tagged Queuing enabled.  Depth 32
[   27.781711]  target3:0:0: Beginning Domain Validation
[   27.787035]  target3:0:0: wide asynchronous
[   27.791300]  target3:0:0: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset
15)
[   27.794607]  target3:0:0: Domain Validation skipping write tests
[   27.794653]  target3:0:0: Ending Domain Validation
[   27.804053] SCSI device sdi: 97693755 512-byte hdwr sectors (50019 MB)
[   27.806283] sdi: Write Protect is off
[   27.806344] sdi: Mode Sense: cb 00 10 08
[   27.808916] SCSI device sdi: drive cache: write through w/ FUA
[   27.809872] SCSI device sdi: 97693755 512-byte hdwr sectors (50019 MB)
[   27.816625] sdi: Write Protect is off
[   27.816689] sdi: Mode Sense: cb 00 10 08
[   27.819272] SCSI device sdi: drive cache: write through w/ FUA
[   27.819325]  sdi: unknown partition table
[   27.841870] sd 3:0:0:0: Attached scsi disk sdi
[   27.852720] scsi 3:0:1:0: Direct-Access     SEAGATE  SX150176LC
BA08 PQ: 0 ANSI: 2
[   27.852809] scsi3:A:1:0: Tagged Queuing enabled.  Depth 32
[   27.852916]  target3:0:1: Beginning Domain Validation
[   27.866711]  target3:0:1: wide asynchronous
[   27.871821]  target3:0:1: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset
15)
[   27.875135]  target3:0:1: Domain Validation skipping write tests
[   27.875181]  target3:0:1: Ending Domain Validation
[   27.890022] SCSI device sdj: 97693755 512-byte hdwr sectors (50019 MB)
[   27.892268] sdj: Write Protect is off
[   27.892323] sdj: Mode Sense: cb 00 10 08
[   27.895199] SCSI device sdj: drive cache: write through w/ FUA
[   27.896112] SCSI device sdj: 97693755 512-byte hdwr sectors (50019 MB)
[   27.898787] sdj: Write Protect is off
[   27.898850] sdj: Mode Sense: cb 00 10 08
[   27.901454] SCSI device sdj: drive cache: write through w/ FUA
[   27.901506]  sdj: unknown partition table
[   27.921451] sd 3:0:1:0: Attached scsi disk sdj
[   27.931099] scsi 3:0:2:0: Direct-Access     SEAGATE  SX150176LC
BA08 PQ: 0 ANSI: 2
[   27.931193] scsi3:A:2:0: Tagged Queuing enabled.  Depth 32
[   27.931326]  target3:0:2: Beginning Domain Validation
[   27.937886]  target3:0:2: wide asynchronous
[   27.942743]  target3:0:2: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset
15)
[   27.946112]  target3:0:2: Domain Validation skipping write tests
[   27.946165]  target3:0:2: Ending Domain Validation
[   27.954710] SCSI device sdk: 97693755 512-byte hdwr sectors (50019 MB)
[   27.956961] sdk: Write Protect is off
[   27.957016] sdk: Mode Sense: cb 00 10 08
[   27.959621] SCSI device sdk: drive cache: write through w/ FUA
[   27.960671] SCSI device sdk: 97693755 512-byte hdwr sectors (50019 MB)
[   27.963366] sdk: Write Protect is off
[   27.963421] sdk: Mode Sense: cb 00 10 08
[   27.965999] SCSI device sdk: drive cache: write through w/ FUA
[   27.966055]  sdk: unknown partition table
[   27.989870] sd 3:0:2:0: Attached scsi disk sdk
[   27.998923] scsi 3:0:3:0: Direct-Access     SEAGATE  SX150176LC
BA08 PQ: 0 ANSI: 2
[   27.999020] scsi3:A:3:0: Tagged Queuing enabled.  Depth 32
[   27.999141]  target3:0:3: Beginning Domain Validation
[   28.008953]  target3:0:3: wide asynchronous
[   28.013204]  target3:0:3: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset
15)
[   28.016557]  target3:0:3: Domain Validation skipping write tests
[   28.016608]  target3:0:3: Ending Domain Validation
[   28.019765] SCSI device sdl: 97693755 512-byte hdwr sectors (50019 MB)
[   28.021960] sdl: Write Protect is off
[   28.022020] sdl: Mode Sense: cb 00 10 08
[   28.027129] SCSI device sdl: drive cache: write through w/ FUA
[   28.028045] SCSI device sdl: 97693755 512-byte hdwr sectors (50019 MB)
[   28.030768] sdl: Write Protect is off
[   28.030832] sdl: Mode Sense: cb 00 10 08
[   28.033415] SCSI device sdl: drive cache: write through w/ FUA
[   28.033475]  sdl: unknown partition table
[   28.049196] sd 3:0:3:0: Attached scsi disk sdl
[   28.054520] scsi 3:0:4:0: Direct-Access     SEAGATE  SX150176LC
BA08 PQ: 0 ANSI: 2
[   28.054619] scsi3:A:4:0: Tagged Queuing enabled.  Depth 32
[   28.054740]  target3:0:4: Beginning Domain Validation
[   28.060309]  target3:0:4: wide asynchronous
[   28.064449]  target3:0:4: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset
15)
[   28.067829]  target3:0:4: Domain Validation skipping write tests
[   28.067881]  target3:0:4: Ending Domain Validation
[   28.072728] SCSI device sdm: 97693755 512-byte hdwr sectors (50019 MB)
[   28.074966] sdm: Write Protect is off
[   28.075031] sdm: Mode Sense: cb 00 10 08
[   28.077684] SCSI device sdm: drive cache: write through w/ FUA
[   28.078732] SCSI device sdm: 97693755 512-byte hdwr sectors (50019 MB)
[   28.081455] sdm: Write Protect is off
[   28.081523] sdm: Mode Sense: cb 00 10 08
[   28.084151] SCSI device sdm: drive cache: write through w/ FUA
[   28.084213]  sdm: unknown partition table
[   28.100025] sd 3:0:4:0: Attached scsi disk sdm
[   30.158852] scsi 3:0:14:0: Processor         SYMBIOS  SYM2000          2
PQ: 0 ANSI: 2
[   30.158933]  target3:0:14: Beginning Domain Validation
[   30.159346]  target3:0:14: Ending Domain Validation
[   30.450736] ACPI: PCI Interrupt 0000:05:01.0[A] -> GSI 16 (level, low) ->
IRQ 20
[   31.461045] scsi4 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
[   31.461048]         <Adaptec 2940/DUAL Ultra SCSI adapter>
[   31.461050]         aic7895: Ultra Wide Channel A, SCSI Id=7, 32/253 SCBs
[   31.461051] 
[   32.009752] scsi 4:0:2:0: CD-ROM            PLEXTOR  CD-ROM PX-40TS
1.11 PQ: 0 ANSI: 2
[   32.009882]  target4:0:2: Beginning Domain Validation
[   32.014686]  target4:0:2: FAST-20 SCSI 20.0 MB/s ST (50 ns, offset 15)
[   32.017640]  target4:0:2: Domain Validation skipping write tests
[   32.017695]  target4:0:2: Ending Domain Validation
[   32.040376] scsi 4:0:3:0: CD-ROM            PLEXTOR  CD-R   PX-W4012S
1.01 PQ: 0 ANSI: 2
[   32.040472]  target4:0:3: Beginning Domain Validation
[   32.042879]  target4:0:3: FAST-20 SCSI 20.0 MB/s ST (50 ns, offset 15)
[   32.044431]  target4:0:3: Domain Validation skipping write tests
[   32.044490]  target4:0:3: Ending Domain Validation
[   32.062090] scsi 4:0:4:0: CD-ROM            NAKAMICH MJ-5.16S
1.07 PQ: 0 ANSI: 2
[   32.062204]  target4:0:4: Beginning Domain Validation
[   32.067703]  target4:0:4: FAST-10 SCSI 10.0 MB/s ST (100 ns, offset 15)
[   32.070777]  target4:0:4: Domain Validation skipping write tests
[   32.070829]  target4:0:4: Ending Domain Validation
[   32.080961] scsi 4:0:4:1: CD-ROM            NAKAMICH MJ-5.16S
1.07 PQ: 0 ANSI: 2
[   32.081055]  target4:0:4: FAST-10 SCSI 10.0 MB/s ST (100 ns, offset 15)
[   32.094088] scsi 4:0:4:2: CD-ROM            NAKAMICH MJ-5.16S
1.07 PQ: 0 ANSI: 2
[   32.094181]  target4:0:4: FAST-10 SCSI 10.0 MB/s ST (100 ns, offset 15)
[   32.106980] scsi 4:0:4:3: CD-ROM            NAKAMICH MJ-5.16S
1.07 PQ: 0 ANSI: 2
[   32.107102]  target4:0:4: FAST-10 SCSI 10.0 MB/s ST (100 ns, offset 15)
[   32.118312] scsi 4:0:4:4: CD-ROM            NAKAMICH MJ-5.16S
1.07 PQ: 0 ANSI: 2
[   32.118423]  target4:0:4: FAST-10 SCSI 10.0 MB/s ST (100 ns, offset 15)
[   32.139326] scsi 4:0:5:0: CD-ROM            YAMAHA   CRW8424S
1.0d PQ: 0 ANSI: 2
[   32.139474]  target4:0:5: Beginning Domain Validation
[   32.155331]  target4:0:5: FAST-20 SCSI 20.0 MB/s ST (50 ns, offset 15)
[   32.165552]  target4:0:5: Domain Validation skipping write tests
[   32.165619]  target4:0:5: Ending Domain Validation
[   34.542463] ACPI: PCI Interrupt 0000:05:01.1[B] -> GSI 17 (level, low) ->
IRQ 21
[   35.552159] scsi5 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
[   35.552162]         <Adaptec 2940/DUAL Ultra SCSI adapter>
[   35.552164]         aic7895: Ultra Single Channel B, SCSI Id=7, 32/253
SCBs
[   35.552165] 
[   50.252880] EXT3 FS on sda1, internal journal
[   53.188367] Intel(R) PRO/1000 Network Driver - version 7.2.9-k4
[   53.188445] Copyright (c) 1999-2006 Intel Corporation.
[   53.192470] ACPI: PCI Interrupt 0000:03:03.0[A] -> GSI 54 (level, low) ->
IRQ 22
[   53.466611] e1000: 0000:03:03.0: e1000_probe: (PCI:66MHz:64-bit)
00:30:48:73:b9:cb
[   53.501760] e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network
Connection
[   53.598803] netconsole: local port 4321
[   53.598866] netconsole: local IP 192.168.2.7
[   53.598914] netconsole: interface eth0
[   53.598960] netconsole: remote port 1234
[   53.599006] netconsole: remote IP 192.168.2.15
[   53.599056] netconsole: remote ethernet address 00:10:5a:21:9b:be
[   53.599109] netconsole: device eth0 not up yet, forcing it
[   56.591864] e1000: eth0: e1000_watchdog: NIC Link is Up 1000 Mbps Full
Duplex
[   56.626868] netconsole: network logging started
[   56.681017] ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 17 (level, low) ->
IRQ 21
[   57.359779] md: raid1 personality registered for level 1
[   57.417471] raid5: automatically using best checksumming function:
pIII_sse
[   57.434914]    pIII_sse  :  3305.000 MB/sec
[   57.434984] raid5: using function: pIII_sse (3305.000 MB/sec)
[   57.546953] raid6: int32x1    618 MB/s
[   57.614927] raid6: int32x2    719 MB/s
[   57.682892] raid6: int32x4    668 MB/s
[   57.750965] raid6: int32x8    473 MB/s
[   57.818833] raid6: mmxx1     2047 MB/s
[   57.886818] raid6: mmxx2     2630 MB/s
[   57.954817] raid6: sse1x1    1136 MB/s
[   58.022806] raid6: sse1x2    1062 MB/s
[   58.090768] raid6: sse2x1    2041 MB/s
[   58.158748] raid6: sse2x2    2911 MB/s
[   58.158793] raid6: using algorithm sse2x2 (2911 MB/s)
[   58.158842] md: raid6 personality registered for level 6
[   58.158888] md: raid5 personality registered for level 5
[   58.158934] md: raid4 personality registered for level 4
[   59.173609] device-mapper: ioctl: 4.10.0-ioctl (2006-09-14) initialised:
dm-devel@redhat.com
[   61.357392] md: bind<sdd>
[   61.373439] md: bind<sde>
[   61.387336] md: bind<sdf>
[   61.402219] md: bind<sdg>
[   61.407919] md: bind<sdh>
[   61.423371] md: bind<sdi>
[   61.441688] md: bind<sdj>
[   61.461825] md: bind<sdk>
[   61.465305] md: bind<sdl>
[   61.482296] md: bind<sdm>
[   61.492627] raid5: device sdm operational as raid disk 9
[   61.492684] raid5: device sdl operational as raid disk 8
[   61.492730] raid5: device sdk operational as raid disk 7
[   61.492776] raid5: device sdj operational as raid disk 6
[   61.492822] raid5: device sdi operational as raid disk 5
[   61.492878] raid5: device sdh operational as raid disk 4
[   61.492924] raid5: device sdg operational as raid disk 3
[   61.492973] raid5: device sdf operational as raid disk 2
[   61.493019] raid5: device sde operational as raid disk 1
[   61.493064] raid5: device sdd operational as raid disk 0
[   61.493919] raid5: allocated 10438kB for md0
[   61.493970] raid5: raid level 5 set md0 active with 10 out of 10 devices,
algorithm 0
[   61.494024] RAID5 conf printout:
[   61.494067]  --- rd:10 wd:10
[   61.494115]  disk 0, o:1, dev:sdd
[   61.494159]  disk 1, o:1, dev:sde
[   61.494202]  disk 2, o:1, dev:sdf
[   61.494248]  disk 3, o:1, dev:sdg
[   61.494291]  disk 4, o:1, dev:sdh
[   61.494338]  disk 5, o:1, dev:sdi
[   61.494381]  disk 6, o:1, dev:sdj
[   61.494437]  disk 7, o:1, dev:sdk
[   61.494484]  disk 8, o:1, dev:sdl
[   61.494528]  disk 9, o:1, dev:sdm
[   61.638169] md: bind<sdb>
[   61.650445] md: bind<sdc>
[   61.668979] raid1: raid set md1 active with 2 out of 2 mirrors
[   86.733733] ReiserFS: dm-5: found reiserfs format "3.6" with standard
journal
[   86.733801] ReiserFS: dm-5: using ordered data mode
[   86.739097] ReiserFS: dm-5: journal params: device dm-5, size 8192,
journal first block 18, max trans len 1024, max batch 900, max commit age
30, max trans age 30
[   86.740289] ReiserFS: dm-5: checking transaction log (dm-5)
[   86.864654] ReiserFS: dm-5: Using r5 hash to sort names
[   86.917196] ReiserFS: dm-6: found reiserfs format "3.6" with standard
journal
[   86.917264] ReiserFS: dm-6: using ordered data mode
[   86.922419] ReiserFS: dm-6: journal params: device dm-6, size 8192,
journal first block 18, max trans len 1024, max batch 900, max commit age
30, max trans age 30
[   86.923635] ReiserFS: dm-6: checking transaction log (dm-6)
[   86.989879] ReiserFS: dm-6: Using r5 hash to sort names
[   87.026297] ReiserFS: dm-3: found reiserfs format "3.6" with standard
journal
[   87.026366] ReiserFS: dm-3: using ordered data mode
[   87.031477] ReiserFS: dm-3: journal params: device dm-3, size 8192,
journal first block 18, max trans len 1024, max batch 900, max commit age
30, max trans age 30
[   87.032729] ReiserFS: dm-3: checking transaction log (dm-3)
[   87.072320] ReiserFS: dm-3: Using r5 hash to sort names
[   87.130105] ReiserFS: sda2: found reiserfs format "3.6" with standard
journal
[   87.130177] ReiserFS: sda2: using ordered data mode
[   87.140192] ReiserFS: sda2: journal params: device sda2, size 8192,
journal first block 18, max trans len 1024, max batch 900, max commit age
30, max trans age 30
[   87.141394] ReiserFS: sda2: checking transaction log (sda2)
[   87.217624] ReiserFS: sda2: Using r5 hash to sort names
[   87.338255] ReiserFS: md1: found reiserfs format "3.6" with standard
journal
[   87.338326] ReiserFS: md1: using ordered data mode
[   87.345881] ReiserFS: md1: journal params: device md1, size 8192, journal
first block 18, max trans len 1024, max batch 900, max commit age 30, max
trans age 30
[   87.347063] ReiserFS: md1: checking transaction log (md1)
[   87.437662] ReiserFS: md1: Using r5 hash to sort names
[   87.498509] ReiserFS: dm-4: found reiserfs format "3.6" with standard
journal
[   87.498585] ReiserFS: dm-4: using ordered data mode
[   87.506235] ReiserFS: dm-4: journal params: device dm-4, size 8192,
journal first block 18, max trans len 1024, max batch 900, max commit age
30, max trans age 30
[   87.507448] ReiserFS: dm-4: checking transaction log (dm-4)
[   87.635480] ReiserFS: dm-4: Using r5 hash to sort names
[   87.712688] ReiserFS: dm-0: warning: read_super_block: found reiserfs
format "3.6" with non-standard journal
[   87.712783] ReiserFS: dm-0: using ordered data mode
[   87.722188] ReiserFS: dm-0: journal params: device dm-0, size 1023,
journal first block 18, max trans len 511, max batch 449, max commit age 30,
max trans age 30
[   87.722415] ReiserFS: dm-0: checking transaction log (dm-0)
[   87.753145] ReiserFS: dm-0: Using r5 hash to sort names
[   87.800729] kjournald starting.  Commit interval 5 seconds
[   87.821032] EXT3 FS on dm-1, internal journal
[   87.821128] EXT3-fs: mounted filesystem with ordered data mode.
[   87.821625] ReiserFS: dm-2: found reiserfs format "3.6" with standard
journal
[   87.821699] ReiserFS: dm-2: using ordered data mode
[   87.821878] ReiserFS: dm-2: journal params: device dm-2, size 8192,
journal first block 18, max trans len 1024, max batch 900, max commit age
30, max trans age 30
[   87.823111] ReiserFS: dm-2: checking transaction log (dm-2)
[   87.865241] ReiserFS: dm-2: Using r5 hash to sort names
[   88.296742] ip_tables: (C) 2000-2006 Netfilter Core Team
[   88.608163] ip_conntrack version 2.4 (8187 buckets, 65496 max) - 212
bytes per conntrack
[   91.812047] Linux agpgart interface v0.101 (c) Dave Jones
[   91.835035] agpgart: Detected an Intel E7505 Chipset.
[   91.849782] agpgart: AGP aperture is 128M @ 0xd8000000
[   92.569925] usbcore: registered new interface driver usbfs
[   92.571634] usbcore: registered new interface driver hub
[   92.583991] usbcore: registered new device driver usb
[   92.611747] USB Universal Host Controller Interface driver v3.0
[   92.626303] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) ->
IRQ 20
[   92.626438] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[   92.626445] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   92.626952] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus
number 1
[   92.627067] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00002440
[   92.646968] usb usb1: configuration #1 chosen from 1 choice
[   92.664368] hub 1-0:1.0: USB hub found
[   92.664467] hub 1-0:1.0: 2 ports detected
[   92.780087] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) ->
IRQ 23
[   92.780965] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[   92.780978] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   92.781372] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus
number 2
[   92.781524] uhci_hcd 0000:00:1d.1: irq 23, io base 0x00002460
[   92.807622] usb usb2: configuration #1 chosen from 1 choice
[   92.845292] hub 2-0:1.0: USB hub found
[   92.852374] hub 2-0:1.0: 2 ports detected
[   92.971624] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) ->
IRQ 24
[   92.971750] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[   92.971757] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   92.996425] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus
number 3
[   92.996540] uhci_hcd 0000:00:1d.2: irq 24, io base 0x00002480
[   93.039622] usb usb3: configuration #1 chosen from 1 choice
[   93.082249] hub 3-0:1.0: USB hub found
[   93.082351] hub 3-0:1.0: 2 ports detected
[   93.211473] usb 2-1: new full speed USB device using uhci_hcd and address
2
[   93.387512] usb 2-1: configuration #1 chosen from 1 choice
[   93.393563] hub 2-1:1.0: USB hub found
[   93.395391] hub 2-1:1.0: 3 ports detected
[   93.747344] usb 3-1: new full speed USB device using uhci_hcd and address
2
[   93.920565] usb 3-1: configuration #1 chosen from 1 choice
[   93.927450] hub 3-1:1.0: USB hub found
[   93.930254] hub 3-1:1.0: 4 ports detected
[   94.244996] usb 2-1.1: new full speed USB device using uhci_hcd and
address 3
[   94.385306] usb 2-1.1: configuration #1 chosen from 1 choice
[   94.636817] usb 2-1.3: new low speed USB device using uhci_hcd and
address 4
[   94.774151] usb 2-1.3: configuration #1 chosen from 1 choice
[   97.878771] usbcore: registered new interface driver hiddev
[   97.897740] input: Dell Dell USB Keyboard as /class/input/input2
[   97.897876] input: USB HID v1.10 Keyboard [Dell Dell USB Keyboard] on
usb-0000:00:1d.1-1.1
[   97.921761] input: Dell Dell USB Keyboard as /class/input/input3
[   97.921874] input: USB HID v1.10 Device [Dell Dell USB Keyboard] on
usb-0000:00:1d.1-1.1
[   97.934827] input: Logitech USB-PS/2 Optical Mouse as /class/input/input4
[   97.935057] input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse]
on usb-0000:00:1d.1-1.3
[   97.935223] usbcore: registered new interface driver usbhid
[   97.935288] drivers/usb/input/hid-core.c: v2.6:USB HID core driver
[   99.026249] ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 23 (level, low) ->
IRQ 25
[   99.026415] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[   99.026422] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   99.026765] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus
number 4
[   99.026927] ehci_hcd 0000:00:1d.7: debug port 1
[   99.027003] PCI: cache line size of 128 is not supported by device
0000:00:1d.7
[   99.027021] ehci_hcd 0000:00:1d.7: irq 25, io mem 0xd0000000
[   99.030963] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10
Dec 2004
[   99.044762] usb usb4: configuration #1 chosen from 1 choice
[   99.046373] hub 4-0:1.0: USB hub found
[   99.046478] hub 4-0:1.0: 6 ports detected
[   99.586052] usb 4-5: new high speed USB device using ehci_hcd and address
3
[   99.720108] usb 4-5: configuration #1 chosen from 1 choice
[   99.720634] hub 4-5:1.0: USB hub found
[   99.721074] hub 4-5:1.0: 4 ports detected
[   99.830222] usb 3-1: USB disconnect, address 2
[   99.974030] usb 2-1: USB disconnect, address 2
[   99.974123] usb 2-1.1: USB disconnect, address 3
[  100.012259] usb 2-1.3: USB disconnect, address 4
[  100.325914] usb 2-1: new full speed USB device using uhci_hcd and address
5
[  100.511410] usb 2-1: configuration #1 chosen from 1 choice
[  100.517411] hub 2-1:1.0: USB hub found
[  100.519192] hub 2-1:1.0: 3 ports detected
[  100.831023] usb 2-1.1: new full speed USB device using uhci_hcd and
address 6
[  100.967424] usb 2-1.1: configuration #1 chosen from 1 choice
[  100.992955] input: Dell Dell USB Keyboard as /class/input/input5
[  100.993059] input: USB HID v1.10 Keyboard [Dell Dell USB Keyboard] on
usb-0000:00:1d.1-1.1
[  101.021903] input: Dell Dell USB Keyboard as /class/input/input6
[  101.022035] input: USB HID v1.10 Device [Dell Dell USB Keyboard] on
usb-0000:00:1d.1-1.1
[  101.250845] usb 2-1.3: new low speed USB device using uhci_hcd and
address 7
[  101.400074] usb 2-1.3: configuration #1 chosen from 1 choice
[  101.416128] input: Logitech USB-PS/2 Optical Mouse as /class/input/input7
[  101.416404] input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse]
on usb-0000:00:1d.1-1.3
[  103.502556] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[  103.502644] ide: Assuming 33MHz system bus speed for PIO modes; override
with idebus=xx
[  103.547432] ICH4: IDE controller at PCI slot 0000:00:1f.1
[  103.547530] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) ->
IRQ 24
[  103.547658] ICH4: chipset revision 2
[  103.547715] ICH4: not 100% native mode: will probe irqs later
[  103.547789]     ide0: BM-DMA at 0x24a0-0x24a7, BIOS settings: hda:DMA,
hdb:pio
[  103.547979]     ide1: BM-DMA at 0x24a8-0x24af, BIOS settings: hdc:pio,
hdd:pio
[  103.548131] Probing IDE interface ide0...
[  104.569105] hda: ATAPI CDROM, ATAPI CD/DVD-ROM drive
[  104.905096] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[  104.905358] Probing IDE interface ide1...
[  106.117242] ACPI: PCI Interrupt 0000:00:1f.5[B] -> GSI 17 (level, low) ->
IRQ 21
[  106.117373] PCI: Setting latency timer of device 0000:00:1f.5 to 64
[  106.432539] intel8x0_measure_ac97_clock: measured 52769 usecs
[  106.432595] intel8x0: clocking to 48000
[  115.215184] ide-scsi is deprecated for cd burning! Use ide-cd and give
dev=/dev/hdX as device
[  115.215310] scsi6 : SCSI host adapter emulation for IDE ATAPI devices
[  115.215964] scsi 6:0:0:0: CD-ROM                     ATAPI CDROM. 
100A PQ: 0 ANSI: 0 CCS
[  115.380052] sr0: scsi3-mmc drive: 40x/40x writer dvd-ram cd/rw xa/form2
cdda tray
[  115.380152] Uniform CD-ROM driver Revision: 3.20
[  115.380718] sr 1:0:13:0: Attached scsi CD-ROM sr0
[  115.386182] sr1: scsi-1 drive
[  115.390675] sr 4:0:2:0: Attached scsi CD-ROM sr1
[  115.393588] sr2: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
[  115.394624] sr 4:0:3:0: Attached scsi CD-ROM sr2
[  115.399817] sr3: scsi3-mmc drive: 16x/16x xa/form2 cdda changer
[  115.426129] sr 4:0:4:0: Attached scsi CD-ROM sr3
[  115.436188] sr4: scsi3-mmc drive: 16x/16x xa/form2 cdda changer
[  115.454056] sr 4:0:4:1: Attached scsi CD-ROM sr4
[  115.459314] sr5: scsi3-mmc drive: 16x/16x xa/form2 cdda changer
[  115.478654] sr 4:0:4:2: Attached scsi CD-ROM sr5
[  115.484218] sr6: scsi3-mmc drive: 16x/16x xa/form2 cdda changer
[  115.506702] sr 4:0:4:3: Attached scsi CD-ROM sr6
[  115.511989] sr7: scsi3-mmc drive: 16x/16x xa/form2 cdda changer
[  115.528195] sr 4:0:4:4: Attached scsi CD-ROM sr7
[  115.551908] sr8: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[  115.568819] sr 4:0:5:0: Attached scsi CD-ROM sr8
[  115.570326] sr9: scsi-1 drive
[  115.597729] sr 6:0:0:0: Attached scsi CD-ROM sr9
[  115.744116] sd 0:0:0:0: Attached scsi generic sg0 type 0
[  115.754534] sd 0:0:1:0: Attached scsi generic sg1 type 0
[  115.762560] sd 0:0:9:0: Attached scsi generic sg2 type 0
[  115.795865] sr 1:0:13:0: Attached scsi generic sg3 type 5
[  115.808705] sd 2:0:0:0: Attached scsi generic sg4 type 0
[  115.812880] sd 2:0:1:0: Attached scsi generic sg5 type 0
[  115.826400] sd 2:0:2:0: Attached scsi generic sg6 type 0
[  115.843572] sd 2:0:3:0: Attached scsi generic sg7 type 0
[  115.858501] sd 2:0:4:0: Attached scsi generic sg8 type 0
[  115.861462] scsi 2:0:14:0: Attached scsi generic sg9 type 3
[  115.863652] sd 3:0:0:0: Attached scsi generic sg10 type 0
[  115.875876] sd 3:0:1:0: Attached scsi generic sg11 type 0
[  115.884915] sd 3:0:2:0: Attached scsi generic sg12 type 0
[  115.891015] sd 3:0:3:0: Attached scsi generic sg13 type 0
[  115.919991] sd 3:0:4:0: Attached scsi generic sg14 type 0
[  115.933426] scsi 3:0:14:0: Attached scsi generic sg15 type 3
[  115.950479] sr 4:0:2:0: Attached scsi generic sg16 type 5
[  115.952236] sr 4:0:3:0: Attached scsi generic sg17 type 5
[  115.987777] sr 4:0:4:0: Attached scsi generic sg18 type 5
[  116.004495] sr 4:0:4:1: Attached scsi generic sg19 type 5
[  116.005215] sr 4:0:4:2: Attached scsi generic sg20 type 5
[  116.024151] sr 4:0:4:3: Attached scsi generic sg21 type 5
[  116.034343] sr 4:0:4:4: Attached scsi generic sg22 type 5
[  116.078676] sr 4:0:5:0: Attached scsi generic sg23 type 5
[  116.102233] sr 6:0:0:0: Attached scsi generic sg24 type 5
[  122.126324] tun: Universal TUN/TAP device driver, 1.6
[  122.126406] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[  123.088556] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[  130.247037] [drm] Initialized drm 1.0.1 20051102
[  130.284254] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 21 (level, low) ->
IRQ 26
[  130.284924] [drm] Initialized radeon 1.25.0 20060524 on minor 0
[  131.670528] agpgart: Found an AGP 3.0 compliant device at 0000:00:00.0.
[  131.670555] agpgart: Putting AGP V3 device at 0000:00:00.0 into 8x mode
[  131.670593] agpgart: Putting AGP V3 device at 0000:01:00.0 into 8x mode
[  131.979309] [drm] Setting GART location based on new memory map
[  131.979328] [drm] Loading R200 Microcode
[  131.979372] [drm] writeback test succeeded in 1 usecs

-- 
 Lab tests show that use of micro$oft causes cancer in lab animals
 Got Gas???
