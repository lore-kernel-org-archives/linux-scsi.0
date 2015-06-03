From: Meelis Roos <mroos@linux.ee>
Subject: qla2xxx crash on sparc64 (bus error)
Date: Wed, 3 Jun 2015 11:40:29 +0300 (EEST)
Message-ID: <alpine.LRH.2.11.1506030939120.16353@math.ut.ee>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <sparclinux-owner@vger.kernel.org>
Sender: sparclinux-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org, qla2xxx-upstream@qlogic.com
List-Id: linux-scsi@vger.kernel.org

Debian packaged 4.0.4 hangs on qla2xxx init so I decided to try latest 
git (4.1.0-rc6-00040-gc46a024). Got the following error:

[   71.232300] ERROR(1): Cheetah error trap taken afsr[0010080000000000] afar[000007fd00100040] TL1(0)
[   71.350495] ERROR(1): TPC[6f4a4c] TNPC[6f4a50] O7[6f4a40] TSTATE[9980001602]
[   71.442359] ERROR(1): TPC<qla2x00_mailbox_command+0xd0c/0xde0>

qla2x00_mailbox_command+0xd0c is after mbox_done, between first and 
second ql_dbg call, likely at start of preparing the arguments to the 
second ql_dbg call. However, I can not see the output of first ql_dbg in 
dmesg, so debug is probably not very active.

  6f49dc:       40 00 66 f9     call  70e5c0 <ql_dbg>
  6f49e0:       96 12 e0 d0     or  %o3, 0xd0, %o3
  6f49e4:       10 68 00 0a     b  %xcc, 6f4a0c <qla2x00_mailbox_command+0xccc>
  6f49e8:       d8 16 60 08     lduh  [ %i1 + 8 ], %o4
  6f49ec:       7f f6 69 cd     call  48f120 <complete>
  6f49f0:       d0 5f a7 f7     ldx  [ %fp + 0x7f7 ], %o0
  6f49f4:       80 a6 a0 00     cmp  %i2, 0
  6f49f8:       02 48 00 3e     be  %icc, 6f4af0 <qla2x00_mailbox_command+0xdb0>
  6f49fc:       15 00 10 21     sethi  %hi(0x408400), %o2
  6f4a00:       c4 17 a7 cd     lduh  [ %fp + 0x7cd ], %g2
  6f4a04:       ab 28 a0 10     sll  %g2, 0x10, %l5
  6f4a08:       d8 16 60 08     lduh  [ %i1 + 8 ], %o4
  6f4a0c:       94 10 20 81     mov  0x81, %o2
  6f4a10:       17 00 26 4f     sethi  %hi(0x993c00), %o3
  6f4a14:       da 16 60 0a     lduh  [ %i1 + 0xa ], %o5
  6f4a18:       11 04 00 00     sethi  %hi(0x10000000), %o0
  6f4a1c:       92 10 00 1b     mov  %i3, %o1
  6f4a20:       c4 16 60 0c     lduh  [ %i1 + 0xc ], %g2
  6f4a24:       95 2a b0 05     sllx  %o2, 5, %o2
  6f4a28:       96 12 e0 e8     or  %o3, 0xe8, %o3
  6f4a2c:       c2 16 60 0e     lduh  [ %i1 + 0xe ], %g1
  6f4a30:       ab 35 60 10     srl  %l5, 0x10, %l5
  6f4a34:       ab 3d 60 00     sra  %l5, 0, %l5
  6f4a38:       ea 73 a8 bf     stx  %l5, [ %sp + 0x8bf ]
  6f4a3c:       c4 73 a8 af     stx  %g2, [ %sp + 0x8af ]
  6f4a40:       40 00 66 e0     call  70e5c0 <ql_dbg>
  6f4a44:       c2 73 a8 b7     stx  %g1, [ %sp + 0x8b7 ]
  6f4a48:       98 04 e0 44     add  %l3, 0x44, %o4
  6f4a4c:       d8 83 03 a0     lda  [ %o4 ] #ASI_PHYS_BYPASS_EC_E_L, %o4
  6f4a50:       da 5f 64 80     ldx  [ %i5 + 0x480 ], %o5
  6f4a54:       84 04 e0 0c     add  %l3, 0xc, %g2
  6f4a58:       c4 80 83 a0     lda  [ %g2 ] #ASI_PHYS_BYPASS_EC_E_L, %g2
  6f4a5c:       82 04 e0 10     add  %l3, 0x10, %g1
  6f4a60:       c2 80 43 a0     lda  [ %g1 ] #ASI_PHYS_BYPASS_EC_E_L, %g1
  6f4a64:       15 00 11 15     sethi  %hi(0x445400), %o2
  6f4a68:       17 00 26 4f     sethi  %hi(0x993c00), %o3
  6f4a6c:       85 30 a0 00     srl  %g2, 0, %g2
  6f4a70:       83 30 60 00     srl  %g1, 0, %g1
  6f4a74:       c4 73 a8 af     stx  %g2, [ %sp + 0x8af ]
  6f4a78:       11 04 00 00     sethi  %hi(0x10000000), %o0
  6f4a7c:       92 10 00 18     mov  %i0, %o1
  6f4a80:       c2 73 a8 b7     stx  %g1, [ %sp + 0x8b7 ]
  6f4a84:       95 32 b0 0a     srlx  %o2, 0xa, %o2
  6f4a88:       96 12 e1 30     or  %o3, 0x130, %o3
  6f4a8c:       99 33 20 00     srl  %o4, 0, %o4
  6f4a90:       40 00 66 cc     call  70e5c0 <ql_dbg>

Probably one of the RD_REG_DWORD() invocations. This defined like
#define RD_REG_DWORD(addr)            readl(addr)

I instrumented the code to print the addresses and they seem to be 
normal:
reg=000007fd00100000, &reg->isp24.host_status=000007fd00100044

Additional test confirms that the crash comes from
RD_REG_DWORD(&reg->isp24.host_status)


[   58.078540] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 8.07.00.18-k.
[   58.185410] PCI: Enabling device: (0000:00:01.0), cmd 3
[   58.253300] qla2xxx [0000:00:01.0]-001d: : Found an ISP2312 irq 16 iobase 0x000007fe0012c000.
[   58.716237] scsi host0: qla2xxx
[   58.761020] qla2xxx [0000:00:01.0]-00fb:0: QLogic QLA2340-SUN - Sun 133MHz PCI-X to 2Gb FC, Single Channel.
[   58.888413] qla2xxx [0000:00:01.0]-00fc:0: ISP2312: PCI (33 MHz) @ 0000:00:01.0 hdma- host#=0 fw=3.03.28 IPX.
[   59.018098] PCI: Enabling device: (0000:00:03.0), cmd 3
[   59.085899] qla2xxx [0000:00:03.0]-001d: : Found an ISP2312 irq 17 iobase 0x000007fe0012e000.
[   59.548230] scsi host1: qla2xxx
[   59.592692] qla2xxx [0000:00:03.0]-00fb:1: QLogic QLA2340 - Sun 133MHz PCI-X to 2Gb FC, Single Channel.
[   59.715490] qla2xxx [0000:00:03.0]-00fc:1: ISP2312: PCI (33 MHz) @ 0000:00:03.0 hdma- host#=1 fw=3.03.28 IPX.
[   59.845200] PCI: Enabling device: (0001:00:04.0), cmd 3
[   59.912984] qla2xxx [0001:00:04.0]-001d: : Found an ISP2200 irq 19 iobase 0x000007fd00100000.
[   60.025094] qla2xxx [0001:00:04.0]-0050:2: No matching ROM signature.
[   60.203162] qla2xxx [0001:00:04.0]-0064:2: Inconsistent NVRAM detected: checksum=0x0 id= version=0x0.
[   60.324848] qla2xxx [0001:00:04.0]-0065:2: Falling back to functioning (yet invalid -- WWPN) defaults.
[   60.446514] qla2xxx [0001:00:04.0]-0069:2: NVRAM configuration failed.
[   71.232300] ERROR(1): Cheetah error trap taken afsr[0010080000000000] afar[000007fd00100040] TL1(0)
[   71.350495] ERROR(1): TPC[6f4a4c] TNPC[6f4a50] O7[6f4a40] TSTATE[9980001602]
[   71.442359] ERROR(1): TPC<qla2x00_mailbox_command+0xd0c/0xde0>
[   71.517260] ERROR(1): M_SYND(0),  E_SYND(0), Privileged
[   71.585067] ERROR(1): Highest priority error (0000080000000000) "Bus error response from system bus"
[   71.704447] ERROR(1): D-cache idx[0] tag[0000000000000000] utag[0000000000000000] stag[0000000000000000]
[   71.828406] ERROR(1): D-cache data0[0000000000000000] data1[0000000000000000] data2[0000000000000000] data3[0000000000000000]
[   71.976429] ERROR(1): I-cache idx[0] tag[0000000000000000] utag[0000000000000000] stag[0000000000000000] u[0000000000000000] l[0000000000000000]
[   72.146219] ERROR(1): I-cache INSN0[0000000000000000] INSN1[0000000000000000] INSN2[0000000000000000] INSN3[0000000000000000]
[   72.294248] ERROR(1): I-cache INSN4[0000000000000000] INSN5[0000000000000000] INSN6[0000000000000000] INSN7[0000000000000000]
[   72.442265] ERROR(1): E-cache idx[100040] tag[00000003f8000004]
[   72.519244] ERROR(1): E-cache data0[0000000000000000] data1[0000000000000000] data2[0000000000000000] data3[0000000000000000]
[   72.667269] Kernel panic - not syncing: Irrecoverable deferred error trap.
[   72.667269]
[   72.776344] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 4.1.0-rc6-00040-gc46a024 #2
[   72.873941] Call Trace:
[   72.905102]  [0000000000830e6c] panic+0xac/0x238
[   72.964889]  [0000000000429bfc] cheetah_deferred_handler+0x3dc/0x440
[   73.047591]  [0000000000405ed0] c_deferred+0x18/0x24
[   73.111963]  [00000000006f4a4c] qla2x00_mailbox_command+0xd0c/0xde0
[   73.193530]  [00000000006f659c] qla2x00_init_firmware+0x13c/0x1c0
[   73.272799]  [00000000006ed34c] qla2x00_init_rings+0x30c/0x380
[   73.348636]  [00000000006f1670] qla2x00_initialize_adapter+0x2b0/0x400
[   73.433649]  [00000000006e5da4] qla2x00_probe_one+0x1424/0x1b80
[   73.510625]  [000000000067605c] pci_device_probe+0x5c/0xc0
[   73.581877]  [00000000006b19cc] really_probe+0xcc/0x240
[   73.649682]  [00000000006b1c64] driver_probe_device+0x24/0x60
[   73.724367]  [00000000006b1cf4] __driver_attach+0x54/0x80
[   73.794478]  [00000000006b027c] bus_for_each_dev+0x3c/0x80
[   73.865725]  [00000000006b1204] bus_add_driver+0xa4/0x1e0
[   73.935836]  [00000000006b21a8] driver_register+0xa8/0x100
[   74.007079]  [0000000000a3fbdc] qla2x00_module_init+0x204/0x268
[   74.084068] Press Stop-A (L1-A) to return to the boot prom
[   74.155305] ---[ end Kernel panic - not syncing: Irrecoverable deferred error trap.


-- 
Meelis Roos (mroos@linux.ee)
