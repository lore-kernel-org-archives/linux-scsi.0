From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mptscsi timeout error
Date: Sat, 28 Apr 2007 05:11:23 -0700
Message-ID: <20070428051123.7af9c8df.akpm@linux-foundation.org>
References: <46321C44.mail83T1EA62M@euklid.aip.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37427 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030565AbXD1MLl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 Apr 2007 08:11:41 -0400
In-Reply-To: <46321C44.mail83T1EA62M@euklid.aip.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To:  Manfred Schultz  <mschultz@aip.de>
Cc: linux-kernel@vger.kernel.org, "Moore, Eric Dean" <Eric.Moore@lsil.com>, linux-scsi@vger.kernel.org


(cc's added, remainder retained)

On Fri, 27 Apr 2007 17:52:36 +0200 mschultz@aip.de ( Manfred Schultz ) wrote:

> 1. mptscsi timeout error
> ========================
> 
> 
> 2. problem/report
> =================
> 
> I want to configure a parallel file system. I checked 'lustre', 'GFS' and
> 'PVFS2'  on different systems and found always the same or a similary errors.
> Wenn I try to write 50 files on the filesystem parallel (this should be possible
> on our cluster), it stopps with an timeout-error. This example is for PVFS2.
> 
> It is installed PVFS2 for a single host (for a first test). Only one 2TB filesystem 
> (/dev/sdb1) is used. PVFS2 seems to work.  50 files of about 10GB will be written.
> Two scripts will be started with commands "df; ls -l /mnt/pvfs2/test; sleep 1"
> in a loop (one by user 'root'). Test failed after about 3 hours.
> 
> The raids are connected via  LSI fiber-cannel-adapter and and QLogic FC switch.
> In a former test I connected the machine and the raid directly and got the same error.
> 
> I checked also 'lustre' and 'GFS' in a similary configuration and found the same
> situation: stop of running processes, reboot required. The system log starts always
> with the timeout error message. It seems to be that error recovery goes in a loop.
> The combination 'lustre' and SCSI-raid produced the same error.
> The same test but using an ext3-filesystem was successfull.
> 
> 
> 3. Keywords
> ===========
> 
> mptscsi, timeout, fusion
> 
> 4. Kernel:
> ==========
> 
> Linux version 2.6.21 (root@luise17.cluster) (gcc version 4.1.1 20070105 (Red Hat 4.1.1-52)) #1 SMP Fri Apr 27 10:08:35 CEST 2007
> .. and older versions, 2.6.20.7
> 
> 5. /var/log/messages:
> =====================
> 
> First scsi/error message:
> Apr 27 14:04:34 luise17 kernel: mptscsih: ioc0: attempting task abort! (sc=ffff8101f36b2500)
> Apr 27 14:04:34 luise17 kernel: sd 4:0:4:0: 
> Apr 27 14:04:34 luise17 kernel:         command: Write(10): 2a 00 18 d5 7f df 00 00 88 00
> Apr 27 14:04:44 luise17 kernel: mptbase: ioc0: ERROR - Doorbell INT timeout (count=4999), IntStatus=80000000!
> Apr 27 14:04:44 luise17 kernel: mptscsih: ioc0: Issue of TaskMgmt failed!
> Apr 27 14:04:44 luise17 kernel: mptscsih: ioc0: task abort: FAILED (sc=ffff8101f36b2500)
> Apr 27 14:04:44 luise17 kernel: mptscsih: ioc0: attempting task abort! (sc=ffff810220ec4280)
> Apr 27 14:04:44 luise17 kernel: sd 4:0:4:0: 
> Apr 27 14:04:44 luise17 kernel:         command: Write(10): 2a 00 18 d7 91 7f 00 01 40 00
> Apr 27 14:04:54 luise17 kernel: mptbase: ioc0: ERROR - Doorbell INT timeout (count=4999), IntStatus=80000000!
> Apr 27 14:04:54 luise17 kernel: mptscsih: ioc0: Issue of TaskMgmt failed!
> Apr 27 14:04:54 luise17 kernel: mptscsih: ioc0: task abort: FAILED (sc=ffff810220ec4280)
> Apr 27 14:04:54 luise17 kernel: mptscsih: ioc0: attempting task abort! (sc=ffff8102296b30c0)
> Apr 27 14:04:54 luise17 kernel: sd 4:0:4:0: 
> Apr 27 14:04:54 luise17 kernel:         command: Write(10): 2a 00 18 d7 92 bf 00 01 40 00
> ... infinite loop
> 
> 
> 6. Program: called in a loop, 50 times, parallel.
> =================================================
> 
> program mkf5
> implicit none
> integer :: l,n,m
> integer :: i,j,k,ll,l2,kk,s
> real (kind=8), allocatable :: a(:)
> character (len=22) :: filename
> 10 format ('Satzlaenge = ',i12)
> 20 format (A,'  ',2i8)
> 30 format ("/mnt/pvfs2/test/P.",i4.4)
> 40 format ('Open Status =',i5)
> read (*,*) k,l,m
> n=l/8
> write (*,10) n*8
> allocate(a(n))
> write (filename,30) k
> write (*,20) filename,l,m
> open (1,file=filename,status='unknown',form='unformatted',iostat=s)
> if (s/=0) write (8,40) s
> do j=1, m
>     do i=1,n   
>        a(i)=float(j)+float(i)*1.0e-5 
>     end do
>     write (1) a
> end do
> close(1)
> end program mkf5
> 
> Input line:  number-of-process 100000 100000
> 
> 
> 7.1 Environment
> ===============
> 
> System: CentOS 5, kernel 2.6.21, pvfs-2.6.3
> 
> ver_linux:
> If some fields are empty or look unusual you may have an old version.
> Compare to the current minimal requirements in Documentation/Changes.
>  
> Linux luise17.cluster 2.6.21 #1 SMP Fri Apr 27 10:08:35 CEST 2007 x86_64 x86_64 x86_64 GNU/Linux
>  
> Gnu C                  4.1.1
> Gnu make               3.81
> binutils               2.17.50.0.6-2.el5
> util-linux             2.13-pre7
> mount                  2.13-pre7
> module-init-tools      3.3-pre2
> e2fsprogs              1.39
> pcmciautils            014
> quota-tools            3.13.
> PPP                    2.4.4
> Linux C Library        > libc.2.5
> Dynamic linker (ldd)   2.5
> Procps                 3.2.7
> Net-tools              1.60
> Kbd                    1.12
> oprofile               0.9.2
> Sh-utils               5.97
> udev                   095
> wireless-tools         28
> Modules Loaded         pvfs2 autofs4 hidp rfcomm l2cap bluetooth sunrpc iptable_filter ip_tables ip6t_REJECT xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 video sbs i2c_ec button battery asus_acpi ac lp floppy sg i2c_nforce2 ib_mthca ib_mad k8temp pcspkr ib_core hwmon i2c_core e100 tg3 mii parport_pc parport serio_raw dm_snapshot dm_zero dm_mirror dm_mod mptfc mptscsih scsi_transport_fc mptbase ext3 jbd ehci_hcd ohci_hcd uhci_hcd sata_nv libata sd_mod scsi_mod
> 
> 
> 7.2 Processor
> =============
> 
> processor	: 0
> vendor_id	: AuthenticAMD
> cpu family	: 15
> model		: 37
> model name	: AMD Opteron(tm) Processor 250
> stepping	: 1
> cpu MHz		: 2411.155
> cache size	: 1024 KB
> fpu		: yes
> fpu_exception	: yes
> cpuid level	: 1
> wp		: yes
> flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 syscall nx mmxext fxsr_opt lm 3dnowext 3dnow pni lahf_lm
> bogomips	: 4823.60
> TLB size	: 1024 4K pages
> clflush size	: 64
> cache_alignment	: 64
> address sizes	: 40 bits physical, 48 bits virtual
> power management: ts fid vid ttp
> 
> processor	: 1
> vendor_id	: AuthenticAMD
> cpu family	: 15
> model		: 37
> model name	: AMD Opteron(tm) Processor 250
> stepping	: 1
> cpu MHz		: 2411.155
> cache size	: 1024 KB
> fpu		: yes
> fpu_exception	: yes
> cpuid level	: 1
> wp		: yes
> flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 syscall nx mmxext fxsr_opt lm 3dnowext 3dnow pni lahf_lm
> bogomips	: 4821.52
> TLB size	: 1024 4K pages
> clflush size	: 64
> cache_alignment	: 64
> address sizes	: 40 bits physical, 48 bits virtual
> power management: ts fid vid ttp
> 
> 
> 7.3. Module information
> =======================
> 
> 
> pvfs2 117808 2 - Live 0xffffffff88377000
> autofs4 41160 2 - Live 0xffffffff8836b000
> hidp 54592 2 - Live 0xffffffff8835c000
> rfcomm 73192 0 - Live 0xffffffff88349000
> l2cap 57280 10 hidp,rfcomm, Live 0xffffffff8833a000
> bluetooth 88836 5 hidp,rfcomm,l2cap, Live 0xffffffff88323000
> sunrpc 196648 1 - Live 0xffffffff882f1000
> iptable_filter 19968 0 - Live 0xffffffff882eb000
> ip_tables 38624 1 iptable_filter, Live 0xffffffff882e0000
> ip6t_REJECT 22592 1 - Live 0xffffffff882d9000
> xt_tcpudp 20352 6 - Live 0xffffffff882d3000
> ip6table_filter 19776 1 - Live 0xffffffff882cd000
> ip6_tables 33216 1 ip6table_filter, Live 0xffffffff882c3000
> x_tables 37576 4 ip_tables,ip6t_REJECT,xt_tcpudp,ip6_tables, Live 0xffffffff882b8000
> ipv6 364192 27 ip6t_REJECT, Live 0xffffffff8825e000
> video 36240 0 - Live 0xffffffff88254000
> sbs 33728 0 - Live 0xffffffff8824a000
> i2c_ec 22656 1 sbs, Live 0xffffffff88243000
> button 25888 0 - Live 0xffffffff8823b000
> battery 28040 0 - Live 0xffffffff88233000
> asus_acpi 35628 0 - Live 0xffffffff88229000
> ac 22856 0 - Live 0xffffffff88222000
> lp 30928 0 - Live 0xffffffff88219000
> floppy 79848 0 - Live 0xffffffff88204000
> sg 53992 0 - Live 0xffffffff881f5000
> i2c_nforce2 22976 0 - Live 0xffffffff881ee000
> ib_mthca 141700 0 - Live 0xffffffff881ca000
> ib_mad 54500 1 ib_mthca, Live 0xffffffff881bb000
> k8temp 23040 0 - Live 0xffffffff881b4000
> pcspkr 20160 0 - Live 0xffffffff881ae000
> ib_core 71040 2 ib_mthca,ib_mad, Live 0xffffffff8819b000
> hwmon 20360 1 k8temp, Live 0xffffffff88195000
> i2c_core 40704 2 i2c_ec,i2c_nforce2, Live 0xffffffff88188000
> e100 53648 0 - Live 0xffffffff88177000
> tg3 125060 0 - Live 0xffffffff88155000
> mii 22656 1 e100, Live 0xffffffff8814e000
> parport_pc 46376 0 - Live 0xffffffff88141000
> parport 57100 2 lp,parport_pc, Live 0xffffffff88132000
> serio_raw 24388 0 - Live 0xffffffff8812b000
> dm_snapshot 33544 0 - Live 0xffffffff88121000
> dm_zero 18816 0 - Live 0xffffffff8811b000
> dm_mirror 38080 0 - Live 0xffffffff88110000
> dm_mod 77136 5 dm_snapshot,dm_zero,dm_mirror, Live 0xffffffff880fc000
> mptfc 34056 3 - Live 0xffffffff880f2000
> mptscsih 40128 1 mptfc, Live 0xffffffff880e7000
> scsi_transport_fc 56516 1 mptfc, Live 0xffffffff880d8000
> mptbase 73504 2 mptfc,mptscsih, Live 0xffffffff880c5000
> ext3 140560 7 - Live 0xffffffff880a1000
> jbd 80496 1 ext3, Live 0xffffffff8808c000
> ehci_hcd 50700 0 - Live 0xffffffff8807e000
> ohci_hcd 38148 0 - Live 0xffffffff88073000
> uhci_hcd 42016 0 - Live 0xffffffff88067000
> sata_nv 38788 7 - Live 0xffffffff8805c000
> libata 138208 1 sata_nv, Live 0xffffffff88039000
> sd_mod 38272 12 - Live 0xffffffff8802e000
> scsi_mod 173240 6 sg,mptfc,mptscsih,scsi_transport_fc,libata,sd_mod, Live 0xffffffff88002000
> 
> 
> 7.4. Loaded driver and hardware information
> ===========================================
> 
> /proc/ioports:
> 
> 0000-001f : dma1
> 0020-0021 : pic1
> 0040-0043 : timer0
> 0050-0053 : timer1
> 0060-006f : keyboard
> 0070-0077 : rtc
> 0080-008f : dma page reg
> 00a0-00a1 : pic2
> 00c0-00df : dma2
> 00f0-00ff : fpu
> 0170-0177 : 0000:00:06.0
> 01f0-01f7 : 0000:00:06.0
> 02f8-02ff : serial
> 0376-0376 : 0000:00:06.0
> 03c0-03df : vga+
> 03f2-03f5 : floppy
> 03f6-03f6 : 0000:00:06.0
> 03f7-03f7 : floppy DIR
> 03f8-03ff : serial
> 0cf8-0cff : PCI conf1
> 1000-101f : 0000:00:01.1
> 1400-140f : 0000:00:06.0
>   1400-1407 : ide0
>   1408-140f : ide1
> 1410-141f : 0000:00:07.0
>   1410-141f : sata_nv
> 1420-142f : 0000:00:08.0
>   1420-142f : sata_nv
> 1430-1433 : 0000:00:07.0
>   1430-1433 : sata_nv
> 1434-1437 : 0000:00:07.0
>   1434-1437 : sata_nv
> 1438-143f : 0000:00:07.0
>   1438-143f : sata_nv
> 1440-1447 : 0000:00:07.0
>   1440-1447 : sata_nv
> 1448-144b : 0000:00:08.0
>   1448-144b : sata_nv
> 144c-144f : 0000:00:08.0
>   144c-144f : sata_nv
> 1450-1457 : 0000:00:08.0
>   1450-1457 : sata_nv
> 1458-145f : 0000:00:08.0
>   1458-145f : sata_nv
> 2000-2fff : PCI Bus #01
>   2000-20ff : 0000:01:06.0
>   2400-243f : 0000:01:08.0
>     2400-243f : e100
> 3000-3fff : PCI Bus #19
>   3000-30ff : 0000:19:03.0
> 5000-503f : 0000:00:01.1
>   5000-503f : pnp 00:02
>     5000-503f : nForce2_smbus
> 5040-507f : 0000:00:01.1
>   5040-507f : pnp 00:02
>     5040-507f : nForce2_smbus
> 8000-807f : pnp 00:02
>   8000-8003 : ACPI PM1a_EVT_BLK
>   8004-8005 : ACPI PM1a_CNT_BLK
>   8008-800b : ACPI PM_TMR
>   8010-8015 : ACPI CPU throttle
>   801c-801c : ACPI PM2_CNT_BLK
>   8020-8027 : ACPI GPE0_BLK
> 8080-80ff : pnp 00:02
> 8400-847f : pnp 00:02
> 8480-84ff : pnp 00:02
> 8800-887f : pnp 00:02
> 8880-88ff : pnp 00:02
> 
> 
> /proc/iomem:
> 00000000-000987ff : System RAM
>   00000000-00000000 : Crash kernel
> 00098800-0009ffff : reserved
> 000c2000-000fffff : reserved
> 00100000-bff1ffff : System RAM
>   01000000-0122fb27 : Kernel code
>   0122fb28-0134777f : Kernel data
>   08000000-0bffffff : GART
> bff20000-bff25fff : ACPI Tables
> bff26000-bff7ffff : ACPI Non-volatile Storage
> bff80000-bfffffff : reserved
> c2000000-c20fffff : PCI Bus #01
>   c2000000-c201ffff : 0000:01:06.0
> c2100000-c21fffff : PCI Bus #19
>   c2100000-c21fffff : 0000:19:03.0
> c2200000-c22fffff : PCI Bus #1a
>   c2200000-c220ffff : 0000:1a:09.0
>   c2210000-c221ffff : 0000:1a:09.1
> dc000000-dc000fff : 0000:00:02.0
>   dc000000-dc000fff : ohci_hcd
> dc001000-dc0010ff : 0000:00:02.1
>   dc001000-dc0010ff : ehci_hcd
> dc002000-dc002fff : 0000:00:07.0
>   dc002000-dc002fff : sata_nv
> dc003000-dc003fff : 0000:00:08.0
>   dc003000-dc003fff : sata_nv
> dc100000-ddffffff : PCI Bus #01
>   dc100000-dc100fff : 0000:01:06.0
>   dc101000-dc101fff : 0000:01:08.0
>     dc101000-dc101fff : e100
>   dc120000-dc13ffff : 0000:01:08.0
>     dc120000-dc13ffff : e100
>   dd000000-ddffffff : 0000:01:06.0
> de000000-de0fffff : PCI Bus #02
>   de000000-de0fffff : 0000:02:00.0
>     de06174c-de06174f : ib_mthca
>     de072000-de0720ff : ib_mthca
>     de080680-de08069b : ib_mthca
>     de082a50-de082a8f : ib_mthca
>     de0f00d8-de0f00df : ib_mthca
> de800000-deffffff : PCI Bus #02
>   de800000-deffffff : 0000:02:00.0
>     de800000-deffffff : ib_mthca
> df000000-df000fff : IOAPIC 1
>   df000000-df000fff : 0000:18:0a.1
> df001000-df001fff : IOAPIC 2
>   df001000-df001fff : 0000:18:0b.1
> df100000-df1fffff : PCI Bus #19
>   df100000-df10ffff : 0000:19:03.0
>   df110000-df113fff : 0000:19:03.0
> df200000-df2fffff : PCI Bus #1a
>   df200000-df20ffff : 0000:1a:09.0
>     df200000-df20ffff : tg3
>   df210000-df21ffff : 0000:1a:09.1
>     df210000-df21ffff : tg3
> e0000000-efffffff : reserved
> fec00000-fec00fff : IOAPIC 0
>   fec00000-fec003ff : reserved
> fee00000-fee00fff : Local APIC
> fefff000-feffffff : pnp 00:00
> fff80000-ffffffff : reserved
> 100000000-23fffffff : System RAM
> 
> 
> 7.5. PCI information
> ====================
> 
> 
> 00:00.0 Memory controller: nVidia Corporation CK804 Memory Controller (rev a3)
> 	Subsystem: Tyan Computer Unknown device 2892
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 0
> 	Capabilities: [44] HyperTransport: Slave or Primary Interface
> 		Command: BaseUnitID=0 UnitCnt=15 MastHost- DefDir- DUL-
> 		Link Control 0: CFlE+ CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
> 		Link Config 0: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit DwFcInEn- LWO=16bit DwFcOutEn-
> 		Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
> 		Link Config 1: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut- LWI=8bit DwFcInEn- LWO=8bit DwFcOutEn-
> 		Revision ID: 1.03
> 		Link Frequency 0: 1.0GHz
> 		Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
> 		Link Frequency Capability 0: 200MHz+ 300MHz+ 400MHz+ 500MHz+ 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
> 		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD-
> 		Link Frequency 1: 200MHz
> 		Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
> 		Link Frequency Capability 1: 200MHz- 300MHz- 400MHz- 500MHz- 600MHz- 800MHz- 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
> 		Error Handling: PFlE+ OFlE+ PFE- OFE- EOCFE- RFE- CRCFE- SERRFE- CF- RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
> 		Prefetchable memory behind bridge Upper: 00-00
> 		Bus Number: 00
> 	Capabilities: [e0] HyperTransport: MSI Mapping
> 
> 00:01.0 ISA bridge: nVidia Corporation CK804 ISA Bridge (rev a3)
> 	Subsystem: Tyan Computer Unknown device 2892
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 0
> 	Region 0: I/O ports at <ignored>
> 
> 00:01.1 SMBus: nVidia Corporation CK804 SMBus (rev a2)
> 	Subsystem: Tyan Computer Unknown device 2892
> 	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Interrupt: pin A routed to IRQ 0
> 	Region 0: I/O ports at 1000 [size=32]
> 	Region 4: I/O ports at 5000 [size=64]
> 	Region 5: I/O ports at 5040 [size=64]
> 	Capabilities: [44] Power Management version 2
> 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> 00:02.0 USB Controller: nVidia Corporation CK804 USB Controller (rev a2) (prog-if 10 [OHCI])
> 	Subsystem: Tyan Computer Unknown device 2892
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 0 (750ns min, 250ns max)
> 	Interrupt: pin A routed to IRQ 21
> 	Region 0: Memory at dc000000 (32-bit, non-prefetchable) [size=4K]
> 	Capabilities: [44] Power Management version 2
> 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> 00:02.1 USB Controller: nVidia Corporation CK804 USB Controller (rev a3) (prog-if 20 [EHCI])
> 	Subsystem: Tyan Computer Unknown device 2892
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 0 (750ns min, 250ns max)
> 	Interrupt: pin B routed to IRQ 20
> 	Region 0: Memory at dc001000 (32-bit, non-prefetchable) [size=256]
> 	Capabilities: [44] Debug port
> 	Capabilities: [80] Power Management version 2
> 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> 00:06.0 IDE interface: nVidia Corporation CK804 IDE (rev f2) (prog-if 8a [Master SecP PriP])
> 	Subsystem: Tyan Computer Unknown device 2892
> 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 0 (750ns min, 250ns max)
> 	Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled] [size=8]
> 	Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled] [size=1]
> 	Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled] [size=8]
> 	Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled] [size=1]
> 	Region 4: I/O ports at 1400 [size=16]
> 	Capabilities: [44] Power Management version 2
> 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> 00:07.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller (rev f3) (prog-if 85 [Master SecO PriO])
> 	Subsystem: Tyan Computer Unknown device 2892
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 0 (750ns min, 250ns max)
> 	Interrupt: pin A routed to IRQ 23
> 	Region 0: I/O ports at 1440 [size=8]
> 	Region 1: I/O ports at 1434 [size=4]
> 	Region 2: I/O ports at 1438 [size=8]
> 	Region 3: I/O ports at 1430 [size=4]
> 	Region 4: I/O ports at 1410 [size=16]
> 	Region 5: Memory at dc002000 (32-bit, non-prefetchable) [size=4K]
> 	Capabilities: [44] Power Management version 2
> 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> 00:08.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller (rev f3) (prog-if 85 [Master SecO PriO])
> 	Subsystem: Tyan Computer Unknown device 2892
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 0 (750ns min, 250ns max)
> 	Interrupt: pin A routed to IRQ 22
> 	Region 0: I/O ports at 1458 [size=8]
> 	Region 1: I/O ports at 144c [size=4]
> 	Region 2: I/O ports at 1450 [size=8]
> 	Region 3: I/O ports at 1448 [size=4]
> 	Region 4: I/O ports at 1420 [size=16]
> 	Region 5: Memory at dc003000 (32-bit, non-prefetchable) [size=4K]
> 	Capabilities: [44] Power Management version 2
> 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> 00:09.0 PCI bridge: nVidia Corporation CK804 PCI Bridge (rev a2) (prog-if 01 [Subtractive decode])
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
> 	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 0
> 	Bus: primary=00, secondary=01, subordinate=01, sec-latency=64
> 	I/O behind bridge: 00002000-00002fff
> 	Memory behind bridge: dc100000-ddffffff
> 	Prefetchable memory behind bridge: c2000000-c20fffff
> 	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR+
> 	BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-
> 
> 00:0d.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3) (prog-if 00 [Normal decode])
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 0, Cache Line Size: 64 bytes
> 	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
> 	I/O behind bridge: 0000f000-00000fff
> 	Memory behind bridge: de000000-de0fffff
> 	Prefetchable memory behind bridge: 00000000de800000-00000000def00000
> 	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
> 	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
> 	Capabilities: [40] Power Management version 2
> 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 	Capabilities: [48] Message Signalled Interrupts: 64bit+ Queue=0/1 Enable+
> 		Address: 00000000fee00000  Data: 4049
> 	Capabilities: [58] HyperTransport: MSI Mapping
> 	Capabilities: [80] Express Root Port (Slot+) IRQ 0
> 		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
> 		Device: Latency L0s <512ns, L1 <4us
> 		Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
> 		Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
> 		Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
> 		Link: Supported Speed 2.5Gb/s, Width x4, ASPM L0s, Port 1
> 		Link: Latency L0s <512ns, L1 <4us
> 		Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
> 		Link: Speed 2.5Gb/s, Width x4
> 		Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug- Surpise-
> 		Slot: Number 2, PowerLimit 25.000000
> 		Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
> 		Slot: AttnInd Off, PwrInd On, Power-
> 		Root: Correctable- Non-Fatal- Fatal- PME-
> 
> 00:0e.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3) (prog-if 00 [Normal decode])
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 0, Cache Line Size: 64 bytes
> 	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
> 	I/O behind bridge: 0000f000-00000fff
> 	Memory behind bridge: fff00000-000fffff
> 	Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
> 	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
> 	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
> 	Capabilities: [40] Power Management version 2
> 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 	Capabilities: [48] Message Signalled Interrupts: 64bit+ Queue=0/1 Enable+
> 		Address: 00000000fee00000  Data: 4051
> 	Capabilities: [58] HyperTransport: MSI Mapping
> 	Capabilities: [80] Express Root Port (Slot+) IRQ 0
> 		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
> 		Device: Latency L0s <512ns, L1 <4us
> 		Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
> 		Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
> 		Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
> 		Link: Supported Speed 2.5Gb/s, Width x16, ASPM L0s, Port 0
> 		Link: Latency L0s <512ns, L1 <4us
> 		Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
> 		Link: Speed 2.5Gb/s, Width x16
> 		Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug- Surpise-
> 		Slot: Number 1, PowerLimit 75.000000
> 		Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
> 		Slot: AttnInd Off, PwrInd On, Power-
> 		Root: Correctable- Non-Fatal- Fatal- PME-
> 
> 00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
> 	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Capabilities: [80] HyperTransport: Host or Secondary Interface
> 		!!! Possibly incomplete decoding
> 		Command: WarmRst+ DblEnd-
> 		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
> 		Link Config: MLWI=16bit MLWO=16bit LWI=16bit LWO=16bit
> 		Revision ID: 1.02
> 	Capabilities: [a0] HyperTransport: Host or Secondary Interface
> 		!!! Possibly incomplete decoding
> 		Command: WarmRst+ DblEnd-
> 		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
> 		Link Config: MLWI=16bit MLWO=16bit LWI=16bit LWO=16bit
> 		Revision ID: 1.02
> 	Capabilities: [c0] HyperTransport: Host or Secondary Interface
> 		!!! Possibly incomplete decoding
> 		Command: WarmRst+ DblEnd-
> 		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
> 		Link Config: MLWI=16bit MLWO=16bit LWI=16bit LWO=16bit
> 		Revision ID: 1.02
> 
> 00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
> 	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 
> 00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
> 	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 
> 00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
> 	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 
> 00:19.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
> 	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Capabilities: [80] HyperTransport: Host or Secondary Interface
> 		!!! Possibly incomplete decoding
> 		Command: WarmRst+ DblEnd-
> 		Link Control: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=0
> 		Link Config: MLWI=16bit MLWO=16bit LWI=N/C LWO=N/C
> 		Revision ID: 1.02
> 	Capabilities: [a0] HyperTransport: Host or Secondary Interface
> 		!!! Possibly incomplete decoding
> 		Command: WarmRst+ DblEnd-
> 		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
> 		Link Config: MLWI=16bit MLWO=16bit LWI=16bit LWO=16bit
> 		Revision ID: 1.02
> 	Capabilities: [c0] HyperTransport: Host or Secondary Interface
> 		!!! Possibly incomplete decoding
> 		Command: WarmRst+ DblEnd-
> 		Link Control: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=0
> 		Link Config: MLWI=16bit MLWO=16bit LWI=N/C LWO=N/C
> 		Revision ID: 1.02
> 
> 00:19.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
> 	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 
> 00:19.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
> 	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 
> 00:19.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
> 	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 
> 01:06.0 VGA compatible controller: ATI Technologies Inc Rage XL (rev 27) (prog-if 00 [VGA])
> 	Subsystem: ATI Technologies Inc Rage XL
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping+ SERR- FastB2B-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 66 (2000ns min), Cache Line Size: 64 bytes
> 	Interrupt: pin A routed to IRQ 7
> 	Region 0: Memory at dd000000 (32-bit, non-prefetchable) [size=16M]
> 	Region 1: I/O ports at 2000 [size=256]
> 	Region 2: Memory at dc100000 (32-bit, non-prefetchable) [size=4K]
> 	[virtual] Expansion ROM at c2000000 [disabled] [size=128K]
> 	Capabilities: [5c] Power Management version 2
> 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> 01:08.0 Ethernet controller: Intel Corporation 82557/8/9 [Ethernet Pro 100] (rev 10)
> 	Subsystem: Intel Corporation EtherExpress PRO/100 S Server Adapter
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 66 (2000ns min, 14000ns max), Cache Line Size: 64 bytes
> 	Interrupt: pin A routed to IRQ 19
> 	Region 0: Memory at dc101000 (32-bit, non-prefetchable) [size=4K]
> 	Region 1: I/O ports at 2400 [size=64]
> 	Region 2: Memory at dc120000 (32-bit, non-prefetchable) [size=128K]
> 	Capabilities: [dc] Power Management version 2
> 		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
> 		Status: D0 PME-Enable- DSel=0 DScale=2 PME-
> 
> 02:00.0 InfiniBand: Mellanox Technologies MT25204 [InfiniHost III Lx HCA] (rev 20)
> 	Subsystem: Mellanox Technologies MT25204 [InfiniHost III Lx HCA]
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 0, Cache Line Size: 64 bytes
> 	Interrupt: pin A routed to IRQ 18
> 	Region 0: Memory at de000000 (64-bit, non-prefetchable) [size=1M]
> 	Region 2: Memory at de800000 (64-bit, prefetchable) [size=8M]
> 	Capabilities: [40] Power Management version 2
> 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 	Capabilities: [48] Vital Product Data
> 	Capabilities: [90] Message Signalled Interrupts: 64bit+ Queue=0/5 Enable-
> 		Address: 0000000000000000  Data: 0000
> 	Capabilities: [84] MSI-X: Enable- Mask- TabSize=32
> 		Vector table: BAR=0 offset=00082000
> 		PBA: BAR=0 offset=00082200
> 	Capabilities: [60] Express Endpoint IRQ 0
> 		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag+
> 		Device: Latency L0s <64ns, L1 unlimited
> 		Device: AtnBtn- AtnInd- PwrInd-
> 		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
> 		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
> 		Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
> 		Link: Supported Speed 2.5Gb/s, Width x8, ASPM L0s, Port 8
> 		Link: Latency L0s unlimited, L1 unlimited
> 		Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
> 		Link: Speed 2.5Gb/s, Width x4
> 
> 18:0a.0 PCI bridge: Advanced Micro Devices [AMD] AMD-8131 PCI-X Bridge (rev 13) (prog-if 00 [Normal decode])
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B-
> 	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 64
> 	Bus: primary=18, secondary=19, subordinate=19, sec-latency=64
> 	I/O behind bridge: 00003000-00003fff
> 	Memory behind bridge: df100000-df1fffff
> 	Prefetchable memory behind bridge: 00000000c2100000-00000000c2100000
> 	Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- <SERR- <PERR-
> 	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
> 	Capabilities: [a0] PCI-X bridge device
> 		Secondary Status: 64bit+ 133MHz+ SCD- USC- SCO- SRD- Freq=133MHz
> 		Status: Dev=18:0a.0 64bit+ 133MHz+ SCD- USC- SCO- SRD-
> 		Upstream: Capacity=14 CommitmentLimit=65535
> 		Downstream: Capacity=2 CommitmentLimit=65535
> 	Capabilities: [b8] HyperTransport: Interrupt Discovery and Configuration
> 	Capabilities: [c0] HyperTransport: Slave or Primary Interface
> 		!!! Possibly incomplete decoding
> 		Command: BaseUnitID=10 UnitCnt=2 MastHost- DefDir-
> 		Link Control 0: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
> 		Link Config 0: MLWI=16bit MLWO=16bit LWI=16bit LWO=16bit
> 		Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=0
> 		Link Config 1: MLWI=8bit MLWO=8bit LWI=N/C LWO=N/C
> 		Revision ID: 1.02
> 
> 18:0a.1 PIC: Advanced Micro Devices [AMD] AMD-8131 PCI-X IOAPIC (rev 01) (prog-if 10 [IO-APIC])
> 	Subsystem: Advanced Micro Devices [AMD] AMD-8131 PCI-X IOAPIC
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 0
> 	Region 0: Memory at df000000 (64-bit, non-prefetchable) [size=4K]
> 
> 18:0b.0 PCI bridge: Advanced Micro Devices [AMD] AMD-8131 PCI-X Bridge (rev 13) (prog-if 00 [Normal decode])
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B-
> 	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 64
> 	Bus: primary=18, secondary=1a, subordinate=1a, sec-latency=64
> 	I/O behind bridge: 0000f000-00000fff
> 	Memory behind bridge: df200000-df2fffff
> 	Prefetchable memory behind bridge: 00000000c2200000-00000000c2200000
> 	Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
> 	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
> 	Capabilities: [a0] PCI-X bridge device
> 		Secondary Status: 64bit+ 133MHz+ SCD- USC- SCO- SRD- Freq=100MHz
> 		Status: Dev=18:0b.0 64bit+ 133MHz+ SCD- USC- SCO- SRD-
> 		Upstream: Capacity=14 CommitmentLimit=65535
> 		Downstream: Capacity=2 CommitmentLimit=65535
> 	Capabilities: [b8] HyperTransport: Interrupt Discovery and Configuration
> 
> 18:0b.1 PIC: Advanced Micro Devices [AMD] AMD-8131 PCI-X IOAPIC (rev 01) (prog-if 10 [IO-APIC])
> 	Subsystem: Advanced Micro Devices [AMD] AMD-8131 PCI-X IOAPIC
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 0
> 	Region 0: Memory at df001000 (64-bit, non-prefetchable) [size=4K]
> 
> 19:03.0 Fibre Channel: LSI Logic / Symbios Logic FC949X Fibre Channel Adapter (rev 01)
> 	Subsystem: LSI Logic / Symbios Logic Unknown device 50f0
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B-
> 	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 72 (16000ns min, 2500ns max), Cache Line Size: 64 bytes
> 	Interrupt: pin A routed to IRQ 27
> 	Region 0: I/O ports at 3000 [disabled] [size=256]
> 	Region 1: Memory at df110000 (64-bit, non-prefetchable) [size=16K]
> 	Region 3: Memory at df100000 (64-bit, non-prefetchable) [size=64K]
> 	[virtual] Expansion ROM at c2100000 [disabled] [size=1M]
> 	Capabilities: [50] Power Management version 2
> 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 	Capabilities: [98] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable-
> 		Address: 0000000000000000  Data: 0000
> 	Capabilities: [68] PCI-X non-bridge device
> 		Command: DPERE- ERO- RBC=2048 OST=16
> 		Status: Dev=19:03.0 64bit+ 133MHz+ SCD- USC- DC=simple DMMRBC=2048 DMOST=16 DMCRS=64 RSCEM- 266MHz- 533MHz-
> 	Capabilities: [b0] MSI-X: Enable- Mask- TabSize=1
> 		Vector table: BAR=1 offset=00002000
> 		PBA: BAR=1 offset=00003000
> 
> 1a:09.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5704 Gigabit Ethernet (rev 10)
> 	Subsystem: Broadcom Corporation Unknown device 1644
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
> 	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 64 (16000ns min), Cache Line Size: 64 bytes
> 	Interrupt: pin A routed to IRQ 28
> 	Region 0: Memory at df200000 (64-bit, non-prefetchable) [size=64K]
> 	[virtual] Expansion ROM at c2200000 [disabled] [size=64K]
> 	Capabilities: [40] PCI-X non-bridge device
> 		Command: DPERE- ERO- RBC=2048 OST=1
> 		Status: Dev=1a:09.0 64bit+ 133MHz+ SCD- USC- DC=simple DMMRBC=2048 DMOST=1 DMCRS=16 RSCEM- 266MHz- 533MHz-
> 	Capabilities: [48] Power Management version 2
> 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
> 		Status: D0 PME-Enable+ DSel=0 DScale=1 PME-
> 	Capabilities: [50] Vital Product Data
> 	Capabilities: [58] Message Signalled Interrupts: 64bit+ Queue=0/3 Enable-
> 		Address: 9d623b641100491c  Data: 3600
> 
> 1a:09.1 Ethernet controller: Broadcom Corporation NetXtreme BCM5704 Gigabit Ethernet (rev 10)
> 	Subsystem: Broadcom Corporation Unknown device 1644
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
> 	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 64 (16000ns min), Cache Line Size: 64 bytes
> 	Interrupt: pin B routed to IRQ 29
> 	Region 0: Memory at df210000 (64-bit, non-prefetchable) [size=64K]
> 	[virtual] Expansion ROM at c2210000 [disabled] [size=64K]
> 	Capabilities: [40] PCI-X non-bridge device
> 		Command: DPERE- ERO- RBC=2048 OST=1
> 		Status: Dev=1a:09.1 64bit+ 133MHz+ SCD- USC- DC=simple DMMRBC=2048 DMOST=1 DMCRS=16 RSCEM- 266MHz- 533MHz-
> 	Capabilities: [48] Power Management version 2
> 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
> 		Status: D0 PME-Enable+ DSel=0 DScale=1 PME-
> 	Capabilities: [50] Vital Product Data
> 	Capabilities: [58] Message Signalled Interrupts: 64bit+ Queue=0/3 Enable-
> 		Address: f880bbe1412468c4  Data: 000a
> 
> 
> 
> 7.6. SCSI information
> =====================
> 
> Attached devices:
> Host: scsi2 Channel: 00 Id: 00 Lun: 00
>   Vendor: ATA      Model: HDS725050KLA360  Rev: K2AO
>   Type:   Direct-Access                    ANSI  SCSI revision: 05
> Host: scsi4 Channel: 00 Id: 04 Lun: 01
>   Vendor: IFT      Model: A16F-G2430       Rev: 348B
>   Type:   Direct-Access                    ANSI  SCSI revision: 04
> Host: scsi4 Channel: 00 Id: 04 Lun: 02
>   Vendor: IFT      Model: A16F-G2430       Rev: 348B
>   Type:   Direct-Access                    ANSI  SCSI revision: 04
> Host: scsi4 Channel: 00 Id: 04 Lun: 03
>   Vendor: IFT      Model: A16F-G2430       Rev: 348B
>   Type:   Direct-Access                    ANSI  SCSI revision: 04
> Host: scsi4 Channel: 00 Id: 04 Lun: 04
>   Vendor: IFT      Model: A16F-G2430       Rev: 348B
>   Type:   Direct-Access                    ANSI  SCSI revision: 04
> Host: scsi4 Channel: 00 Id: 05 Lun: 00
>   Vendor: IFT      Model: A16F-G2430       Rev: 348B
>   Type:   Direct-Access                    ANSI  SCSI revision: 04
> Host: scsi4 Channel: 00 Id: 05 Lun: 01
>   Vendor: IFT      Model: A16F-G2430       Rev: 348B
>   Type:   Direct-Access                    ANSI  SCSI revision: 04
> Host: scsi4 Channel: 00 Id: 05 Lun: 02
>   Vendor: IFT      Model: A16F-G2430       Rev: 348B
>   Type:   Direct-Access                    ANSI  SCSI revision: 04
> Host: scsi4 Channel: 00 Id: 05 Lun: 03
>   Vendor: IFT      Model: A16F-G2430       Rev: 348B
>   Type:   Direct-Access                    ANSI  SCSI revision: 04
> Host: scsi4 Channel: 00 Id: 05 Lun: 04
>   Vendor: IFT      Model: A16F-G2430       Rev: 348B
>   Type:   Direct-Access                    ANSI  SCSI revision: 04
> Host: scsi4 Channel: 00 Id: 05 Lun: 05
>   Vendor: IFT      Model: A16F-G2430       Rev: 348B
>   Type:   Direct-Access                    ANSI  SCSI revision: 04
> Host: scsi4 Channel: 00 Id: 06 Lun: 00
>   Vendor: IFT      Model: A16F-G2430       Rev: 348B
>   Type:   Direct-Access                    ANSI  SCSI revision: 04
> Host: scsi4 Channel: 00 Id: 06 Lun: 01
>   Vendor: IFT      Model: A16F-G2430       Rev: 348B
>   Type:   Direct-Access                    ANSI  SCSI revision: 04
> Host: scsi4 Channel: 00 Id: 06 Lun: 02
>   Vendor: IFT      Model: A16F-G2430       Rev: 348B
>   Type:   Direct-Access                    ANSI  SCSI revision: 04
> Host: scsi4 Channel: 00 Id: 06 Lun: 03
>   Vendor: IFT      Model: A16F-G2430       Rev: 348B
>   Type:   Direct-Access                    ANSI  SCSI revision: 04
> Host: scsi4 Channel: 00 Id: 06 Lun: 04
>   Vendor: IFT      Model: A16F-G2430       Rev: 348B
>   Type:   Direct-Access                    ANSI  SCSI revision: 04
> Host: scsi4 Channel: 00 Id: 07 Lun: 00
>   Vendor: IFT      Model: A16F-G2430       Rev: 348B
>   Type:   Direct-Access                    ANSI  SCSI revision: 04
> Host: scsi4 Channel: 00 Id: 07 Lun: 01
>   Vendor: IFT      Model: A16F-G2430       Rev: 348B
>   Type:   Direct-Access                    ANSI  SCSI revision: 04
> Host: scsi4 Channel: 00 Id: 07 Lun: 02
>   Vendor: IFT      Model: A16F-G2430       Rev: 348B
>   Type:   Direct-Access                    ANSI  SCSI revision: 04
> Host: scsi4 Channel: 00 Id: 07 Lun: 03
>   Vendor: IFT      Model: A16F-G2430       Rev: 348B
>   Type:   Direct-Access                    ANSI  SCSI revision: 04
> Host: scsi4 Channel: 00 Id: 07 Lun: 04
>   Vendor: IFT      Model: A16F-G2430       Rev: 348B
>   Type:   Direct-Access                    ANSI  SCSI revision: 04
> Host: scsi4 Channel: 00 Id: 08 Lun: 00
>   Vendor: IFT      Model: A16F-G2430       Rev: 348B
>   Type:   Direct-Access                    ANSI  SCSI revision: 04
> Host: scsi4 Channel: 00 Id: 08 Lun: 01
>   Vendor: IFT      Model: A16F-G2430       Rev: 348B
>   Type:   Direct-Access                    ANSI  SCSI revision: 04
> Host: scsi4 Channel: 00 Id: 08 Lun: 02
>   Vendor: IFT      Model: A16F-G2430       Rev: 348B
>   Type:   Direct-Access                    ANSI  SCSI revision: 04
> Host: scsi4 Channel: 00 Id: 08 Lun: 03
>   Vendor: IFT      Model: A16F-G2430       Rev: 348B
>   Type:   Direct-Access                    ANSI  SCSI revision: 04
> Host: scsi4 Channel: 00 Id: 08 Lun: 04
>   Vendor: IFT      Model: A16F-G2430       Rev: 348B
>   Type:   Direct-Access                    ANSI  SCSI revision: 04
> 
> ----
> 
> I am able to make further test or to give further informations.
> 
> 
> Regards
> 
> 
> M. Schultz
> 
> 
> _______________
> Manfred Schultz, Astrophysikalisches Institut Potsdam, An der Sternwarte 16
> MSchultz@aip.de, Tel. +49 331 7499 528, Fax. +49 331 7499 526
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
