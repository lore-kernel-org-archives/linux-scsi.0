From: "Daniel M. Newman" <dmnewman@pobox.com>
Subject: PROBLEM: insertion of pcmcia Adaptec APA-1450A SlimSCSI causes errors
Date: Wed, 26 Nov 2003 20:35:42 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031126093542.GA2696@daedalus>
Reply-To: dmnewman@pobox.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	Format=Flowed	DelSp=Yes
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smta00.mail.ozemail.net ([203.103.165.40]:61894 "EHLO
	smta00.mail.ozemail.net") by vger.kernel.org with ESMTP
	id S264106AbTKZJfp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Nov 2003 04:35:45 -0500
Received: from daedalus.qapl.com.au ([203.61.130.130])
          by smta00.mail.ozemail.net with ESMTP
          id <20031126093454.UWHC21896.smta00.mail.ozemail.net@daedalus.qapl.com.au>
          for <linux-scsi@vger.kernel.org>; Wed, 26 Nov 2003 09:34:54 +0000
Received: from localhost ([127.0.0.1] helo=daedalus)
	by daedalus.qapl.com.au with esmtp (Exim 4.24)
	id 1AOw5H-0000jl-KV
	for linux-scsi@vger.kernel.org; Wed, 26 Nov 2003 20:35:43 +1100
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Insertion of pcmcia Adaptec APA-1450A SlimSCSI causes errors.

One normal beep occurs, nothing else visible or audible happens,  
process [scsi_eh_0] is left running and can not be killed.  The cardctl  
and cardinfo processes are unable to suspend, eject or re-initialise  
the card.  This combination of card and hardware works normally on a  
2.4.21 kernel.

syslog indicates a kernel null pointer problem (I think)

The error is consistent and repeatable (needs a reboot to get card  
services working again)

hardware
--------
Gateway Solo 9300 notebook
Pentium III Coppermine 750MHz CPU
memory 294MB
2 PC Card sockets
2 USB ports
IEEE 1394 4-pin port
Adaptec APA-1450A SlimSCSI card connected to HP Scanjet 5P


ver_linux
---------
Linux daedalus 2.6.0-test10 #1 Wed Nov 26 12:04:17 EST 2003 i686 GNU/ 
Linux

Gnu C                  3.3.2
Gnu make               3.80
util-linux             2.12
mount                  2.12
module-init-tools      0.9.15-pre3
e2fsprogs              1.35-WIP
pcmcia-cs              3.2.5
PPP                    2.4.2b3
nfs-utils              1.0.6
Linux C Library        2.3.2
Dynamic linker (ldd)   2.3.2
Procps                 3.1.14
Net-tools              1.60
Console-tools          0.2.3
Sh-utils               5.0.91
Modules Loaded         aha152x_cs ipt_state iptable_filter ip_tables  
ip_conntrack_ftp ip_conntrack ppp_deflate zlib_deflate zlib_inflate  
bsd_comp ppp_async ltserial serial_core ltmodem ppp_generic slhc  
snd_pcm_oss snd_mixer_oss snd_es1968 snd_ac97_codec snd_pcm  
snd_page_alloc snd_mpu401_uart sd_mod scsi_mod snd_rawmidi ide_cd cdrom  
nfsd exportfs lockd sunrpc parport_pc lp parport binfmt_misc uhci_hcd  
usbcore nls_iso8859_1 nls_cp437 button battery ac fan thermal processor  
unix

syslog
------
 kernel: cs: memory probe 0xa0000000-0xa0ffffff: clean.
 cardmgr[302]: socket 0: Adaptec APA-1460 SlimSCSI
 cardmgr[302]: executing: 'modprobe aha152x_cs'
 kernel: Unable to handle kernel NULL pointer dereference at virtual  
address 00000000
 kernel:  printing eip:
 kernel: d2941764
 kernel: *pde = 00000000
 kernel: Oops: 0002 [#1]
 kernel: CPU:    0
 kernel: EIP:    0060:[__crc_snd_card_new+15788/1923471]    Tainted: PF
 kernel: EFLAGS: 00010286
 kernel: EIP is at scsi_register+0x44/0x70 [scsi_mod]
 kernel: eax: d15881b8   ebx: d1588000   ecx: 00000000  edx: d29fa094
 kernel: esi: d29fa020   edi: d1013a50   ebp: 0000002b  esp: d10137d4
 kernel: ds: 007b   es: 007b   ss: 0068
 kernel: Process cardmgr (pid: 302, threadinfo=d1012000 task=d1ac3300)
 kernel: Stack: d29fa020 00000334 00000000 d1013a28 d29f0aac d29fa020  
00000334 00002000
 kernel:        00000500 035f0340 d14744e0 c4d87680 d1013a08 c4d87680  
0000002b c022a0f5
 kernel:        c4d87680 00000286 d1013888 00000000 d1013a28 d1013a50  
0000002b d29f04f1
 kernel: Call Trace:
 kernel:  [__crc_snd_card_new+733428/1923471] aha152x_probe_one 
+0x1c/0x430 [aha152x_cs]
 kernel:  [__crc_snd_card_new+733428/1923471] aha152x_probe_one 
+0x1c/0x430 [aha152x_cs]
 kernel:  [CardServices+533/862] CardServices+0x215/0x35e
 kernel:  [__crc_snd_card_new+731961/1923471] aha152x_config_cs 
+0x321/0x3d0 [aha152x_cs]
 kernel:  [yenta_set_mem_map+417/496] yenta_set_mem_map+0x1a1/0x1f0
 kernel:  [try_to_wake_up+169/352] try_to_wake_up+0xa9/0x160
 kernel:  [set_cis_map+64/288] set_cis_map+0x40/0x120
 kernel:  [read_cis_mem+300/416] read_cis_mem+0x12c/0x1a0
 kernel:  [read_cis_cache+259/400] read_cis_cache+0x103/0x190
 kernel:  [pcmcia_get_tuple_data+149/160] pcmcia_get_tuple_data 
+0x95/0xa0
 kernel:  [pcmcia_parse_tuple+264/384] pcmcia_parse_tuple+0x108/0x180
 kernel:  [read_tuple+165/176] read_tuple+0xa5/0xb0
 kernel:  [yenta_set_mem_map+417/496] yenta_set_mem_map+0x1a1/0x1f0
 kernel:  [__crc_snd_card_new+732398/1923471] aha152x_event+0x76/0x120  
[aha152x_cs]
 kernel:  [read_tuple+72/176] read_tuple+0x48/0xb0
 kernel:  [read_cis_cache+259/400] read_cis_cache+0x103/0x190
 kernel:  [pcmcia_get_next_tuple+588/688] pcmcia_get_next_tuple 
+0x24c/0x2b0
 kernel:  [pcmcia_validate_cis+307/528] pcmcia_validate_cis+0x133/0x210
 kernel:  [do_get_write_access+727/1552] do_get_write_access 
+0x2d7/0x610
 kernel:  [mempool_alloc+121/352] mempool_alloc+0x79/0x160
 kernel:  [autoremove_wake_function+0/80] autoremove_wake_function 
+0x0/0x50
 kernel:  [mempool_alloc+121/352] mempool_alloc+0x79/0x160
 kernel:  [autoremove_wake_function+0/80] autoremove_wake_function 
+0x0/0x50
 kernel:  [pcmcia_register_client+578/656] pcmcia_register_client 
+0x242/0x290
 kernel:  [mempool_alloc+121/352] mempool_alloc+0x79/0x160
 kernel:  [yenta_set_mem_map+417/496] yenta_set_mem_map+0x1a1/0x1f0
 kernel:  [autoremove_wake_function+0/80] autoremove_wake_function 
+0x0/0x50
 kernel:  [__crc_snd_card_new+732280/1923471] aha152x_event+0x0/0x120  
[aha152x_cs]
 kernel:  [CardServices+430/862] CardServices+0x1ae/0x35e
 kernel:  [__crc_snd_card_new+730946/1923471] aha152x_attach+0xfa/0x140  
[aha152x_cs]
 kernel:  [__crc_snd_card_new+732280/1923471] aha152x_event+0x0/0x120  
[aha152x_cs]
 kernel:  [get_pcmcia_driver+52/80] get_pcmcia_driver+0x34/0x50
 kernel:  [bind_request+266/560] bind_request+0x10a/0x230
 kernel:  [ds_ioctl+1238/1552] ds_ioctl+0x4d6/0x610
 kernel:  [preempt_schedule+42/80] preempt_schedule+0x2a/0x50
 kernel:  [__crc_snd_ctl_find_id+850783/1085714] unix_dgram_sendmsg 
+0x467/0x560 [unix]
 kernel:  [sock_sendmsg+152/208] sock_sendmsg+0x98/0xd0
 kernel:  [do_anonymous_page+284/512] do_anonymous_page+0x11c/0x200
 kernel:  [buffered_rmqueue+207/368] buffered_rmqueue+0xcf/0x170
 kernel:  [schedule+761/1424] schedule+0x2f9/0x590
 kernel:  [__wake_up_locked+33/48] __wake_up_locked+0x21/0x30
 kernel:  [default_wake_function+0/32] default_wake_function+0x0/0x20
 kernel:  [zap_pmd_range+75/112] zap_pmd_range+0x4b/0x70
 kernel:  [unmap_page_range+75/128] unmap_page_range+0x4b/0x80
 kernel:  [unmap_vmas+254/560] unmap_vmas+0xfe/0x230
 kernel:  [unmap_region+148/224] unmap_region+0x94/0xe0
 kernel:  [unmap_vma+72/144] unmap_vma+0x48/0x90
 kernel:  [unmap_vma_list+31/48] unmap_vma_list+0x1f/0x30
 kernel:  [do_munmap+330/400] do_munmap+0x14a/0x190
 kernel:  [sys_ioctl+256/640] sys_ioctl+0x100/0x280
 kernel:  [sys_munmap+68/112] sys_munmap+0x44/0x70
 kernel:  [syscall_call+7/11] syscall_call+0x7/0xb
 kernel:
 kernel: Code: 89 01 89 d8 8b 74 24 0c 8b 5c 24 08 83 c4 10 c3 8b 46 04  
c7

/proc/cpuinfo
-------------
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 8
model name      : Pentium III (Coppermine)
stepping        : 3
cpu MHz         : 746.281
cache size      : 256 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca  
cmov pat pse36 mmx fxsr sse
bogomips        : 1474.56

/proc/modules
-------------
aha152x_cs 42644 1 - Live 0xd29f0000
ipt_state 1760 2 - Live 0xd2987000
iptable_filter 2688 1 - Live 0xd284a000
ip_tables 17824 2 ipt_state,iptable_filter, Live 0xd29dc000
ip_conntrack_ftp 72084 0 - Live 0xd29c2000
ip_conntrack 32464 2 ipt_state,ip_conntrack_ftp, Live 0xd29b9000
ppp_deflate 6144 1 - Live 0xd29a3000
zlib_deflate 22712 1 ppp_deflate, Live 0xd29b2000
zlib_inflate 22368 1 ppp_deflate, Live 0xd29ab000
bsd_comp 5952 0 - Live 0xd293c000
ppp_async 11456 1 - Live 0xd2927000
ltserial 6596 2 - Live 0xd2924000
serial_core 23552 1 ltserial, Live 0xd2980000
ltmodem 533168 1 ltserial, Live 0xd2a1f000
ppp_generic 26096 7 ppp_deflate,bsd_comp,ppp_async, Live 0xd2978000
slhc 7136 1 ppp_generic, Live 0xd28ad000
snd_pcm_oss 53700 0 - Live 0xd2989000
snd_mixer_oss 19264 2 snd_pcm_oss, Live 0xd28fb000
snd_es1968 32036 1 - Live 0xd291b000
snd_ac97_codec 54884 1 snd_es1968, Live 0xd292d000
snd_pcm 100612 2 snd_pcm_oss,snd_es1968, Live 0xd295e000
snd_page_alloc 11812 2 snd_es1968,snd_pcm, Live 0xd289f000
snd_mpu401_uart 7712 1 snd_es1968, Live 0xd289c000
sd_mod 15232 0 - Live 0xd28ef000
scsi_mod 118712 2 aha152x_cs,sd_mod, Live 0xd2940000
snd_rawmidi 24864 1 snd_mpu401_uart, Live 0xd28a5000
ide_cd 40836 0 - Live 0xd28e4000
cdrom 35072 1 ide_cd, Live 0xd2888000
nfsd 102096 8 - Live 0xd2901000
exportfs 6464 1 nfsd, Live 0xd2885000
lockd 64560 2 nfsd, Live 0xd28b0000
sunrpc 134152 2 nfsd,lockd, Live 0xd28c2000
parport_pc 36620 1 - Live 0xd2892000
lp 10656 0 - Live 0xd284c000
parport 43624 2 parport_pc,lp, Live 0xd285b000
binfmt_misc 10504 1 - Live 0xd283a000
uhci_hcd 32624 0 - Live 0xd2852000
usbcore 111164 3 uhci_hcd, Live 0xd2868000
nls_iso8859_1 3904 1 - Live 0xd2845000
nls_cp437 5568 1 - Live 0xd2842000
button 6008 0 - Live 0xd280e000
battery 9292 0 - Live 0xd283e000
ac 4876 0 - Live 0xd2813000
fan 3916 0 - Live 0xd2811000
thermal 13040 0 - Live 0xd2835000
processor 13700 1 thermal, Live 0xd2830000
unix 28368 342 - Live 0xd2817000


/proc/ioports
-------------
0000-001f : dma1
0020-0021 : pic1
0040-005f : timer
0060-006f : keyboard
0070-0077 : rtc
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : ide1
01f0-01f7 : ide0
0368-036f : pnp 00:01
0376-0376 : ide1
0378-037a : parport0
0398-0399 : pnp 00:01
03c0-03df : vga+
03f6-03f6 : ide0
04d0-04d1 : pnp 00:01
0cf8-0cff : PCI conf1
1000-101f : 0000:00:07.2
  1000-101f : uhci_hcd
1020-102f : 0000:00:07.1
  1020-1027 : ide0
  1028-102f : ide1
1030-1037 : 0000:00:0b.0
  1030-1036 : ltserial
1040-105f : 0000:00:07.3
  1040-104f : pnp 00:01
1400-14ff : 0000:00:08.0
  1400-14ff : ESS Maestro
1800-18ff : 0000:00:0b.0
  1800-18fe : ltserial
4000-40ff : PCI CardBus #02
4400-44ff : PCI CardBus #02
4800-48ff : PCI CardBus #06
4c00-4cff : PCI CardBus #06
8000-803f : 0000:00:07.3
9000-9fff : PCI Bus #01
  9000-90ff : 0000:01:00.0


/proc/iomem
-----------
00000000-0009f7ff : System RAM
0009f800-0009ffff : reserved
000a0000-000bffff : Video RAM area
000e0000-000effff : Extension ROM
000f0000-000fffff : System ROM
00100000-11feffff : System RAM
  00100000-0029e42b : Kernel code
  0029e42c-0033deff : Kernel data
11ff0000-11fffbff : ACPI Tables
11fffc00-11ffffff : ACPI Non-volatile Storage
12000000-12000fff : 0000:00:0c.0
  12000000-12000fff : yenta_socket
12001000-12001fff : 0000:00:0c.1
  12001000-12001fff : yenta_socket
12400000-127fffff : PCI CardBus #02
12800000-12bfffff : PCI CardBus #02
12c00000-12ffffff : PCI CardBus #06
13000000-133fffff : PCI CardBus #06
a0000000-a0000fff : card services
f4000000-f4003fff : 0000:00:0c.2
f4004000-f40047ff : 0000:00:0c.2
f4004800-f40048ff : 0000:00:0b.0
  f4004800-f40048fe : ltserial
f4100000-f5ffffff : PCI Bus #01
  f4100000-f4100fff : 0000:01:00.0
  f5000000-f5ffffff : 0000:01:00.0
f8000000-fbffffff : 0000:00:00.0
fff80000-ffffffff : reserved


lspci -vvv
----------
00:00.0 Host bridge: Intel Corp. 440BX/ZX/DX - 82443BX/ZX/DX Host  
bridge (rev 03)
        Subsystem: Gateway 2000: Unknown device 9300
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-  
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort+ >SERR- <PERR-
        Latency: 64
        Region 0: Memory at f8000000 (32-bit, prefetchable) [size=64M]
        Capabilities: [a0] AGP version 1.0
                Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64-  
HTrans- 64bit- FW- AGP3- Rate=x1,x2
                Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit-  
FW- Rate=<none>

00:01.0 PCI bridge: Intel Corp. 440BX/ZX/DX - 82443BX/ZX/DX AGP bridge  
(rev 03) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV+ VGASnoop-  
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 128
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=64
        I/O behind bridge: 00009000-00009fff
        Memory behind bridge: f4100000-f5ffffff
        Prefetchable memory behind bridge: fff00000-000fffff
        BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B+

00:07.0 ISA bridge: Intel Corp. 82371AB/EB/MB PIIX4 ISA (rev 02)
        Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop-  
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0

00:07.1 IDE interface: Intel Corp. 82371AB/EB/MB PIIX4 IDE (rev 01)  
(prog-if 80 [Master])
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-  
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 64
        Region 4: I/O ports at 1020 [size=16]

00:07.2 USB Controller: Intel Corp. 82371AB/EB/MB PIIX4 USB (rev 01)  
(prog-if 00 [UHCI])
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-  
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 64
        Interrupt: pin D routed to IRQ 9
        Region 4: I/O ports at 1000 [size=32]

00:07.3 Bridge: Intel Corp. 82371AB/EB/MB PIIX4 ACPI (rev 03)
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-  
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin ? routed to IRQ 9

00:08.0 Multimedia audio controller: ESS Technology ES1978 Maestro 2E  
(rev 10)
        Subsystem: Gateway 2000: Unknown device 9300
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-  
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (500ns min, 6000ns max)
        Interrupt: pin A routed to IRQ 10
        Region 0: I/O ports at 1400 [size=256]
        Capabilities: [c0] Power Management version 2
                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0-,D1+, 
D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:0b.0 Communication controller: Lucent Microelectronics WinModem 56k  
(rev 01)
        Subsystem: Actiontec Electronics Inc: Unknown device 2000
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-  
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at f4004800 (32-bit, non-prefetchable)  
[size=256]
        Region 1: I/O ports at 1030 [size=8]
        Region 2: I/O ports at 1800 [size=256]
        Capabilities: [f8] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2+ AuxCurrent=0mA PME(D0-,D1-, 
D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:0c.0 CardBus bridge: Texas Instruments PCI4450 PC card Cardbus  
Controller
        Subsystem: Gateway 2000: Unknown device 9300
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-  
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 168, Cache Line Size: 0x08 (32 bytes)
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at 12000000 (32-bit, non-prefetchable)  
[size=4K]
        Bus: primary=00, secondary=02, subordinate=05, sec-latency=176
        Memory window 0: 12400000-127ff000 (prefetchable)
        Memory window 1: 12800000-12bff000
        I/O window 0: 00004000-000040ff
        I/O window 1: 00004400-000044ff
        BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset+ 16bInt+  
PostWrite+
        16-bit legacy interface ports at 0001

00:0c.1 CardBus bridge: Texas Instruments PCI4450 PC card Cardbus  
Controller
        Subsystem: Gateway 2000: Unknown device 9300
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-  
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 168, Cache Line Size: 0x08 (32 bytes)
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at 12001000 (32-bit, non-prefetchable)  
[size=4K]
        Bus: primary=00, secondary=06, subordinate=09, sec-latency=176
        Memory window 0: 12c00000-12fff000 (prefetchable)
        Memory window 1: 13000000-133ff000
        I/O window 0: 00004800-000048ff
        I/O window 1: 00004c00-00004cff
        BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset+ 16bInt+  
PostWrite+
        16-bit legacy interface ports at 0001

00:0c.2 FireWire (IEEE 1394): Texas Instruments: Unknown device 8011  
(prog-if 10 [OHCI])
        Subsystem: Gateway 2000: Unknown device 9300
        Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV+ VGASnoop-  
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin C routed to IRQ 10
        Region 0: Memory at f4004000 (32-bit, non-prefetchable)  
[size=2K]
        Region 1: Memory at f4000000 (32-bit, non-prefetchable)  
[size=16K]
        Capabilities: [44] Power Management version 1
                Flags: PMEClk- DSI- D1- D2+ AuxCurrent=0mA PME(D0-,D1-, 
D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

01:00.0 VGA compatible controller: ATI Technologies Inc Rage Mobility  
P/M AGP 2x (rev 64) (prog-if 00 [VGA])
        Subsystem: Gateway 2000: Unknown device 9300
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-  
ParErr- Stepping+ SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 66 (2000ns min), Cache Line Size: 0x08 (32 bytes)
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at f5000000 (32-bit, non-prefetchable)  
[size=16M]
        Region 1: I/O ports at 9000 [size=256]
        Region 2: Memory at f4100000 (32-bit, non-prefetchable)  
[size=4K]
        Expansion ROM at <unassigned> [disabled] [size=128K]
        Capabilities: [50] AGP version 1.0
                Status: RQ=256 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64-  
HTrans- 64bit- FW- AGP3- Rate=x1,x2
                Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit-  
FW- Rate=<none>
        Capabilities: [5c] Power Management version 1
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-, 
D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-


/proc/scsi/scsi
---------------
Attached devices:



