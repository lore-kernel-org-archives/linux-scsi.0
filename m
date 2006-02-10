From: Olaf Hering <olh@suse.de>
Subject: Re: 2.6.16-rc1 crash in scsi_target_reap_work
Date: Sat, 11 Feb 2006 00:29:35 +0100
Message-ID: <20060210232935.GA27760@suse.de>
References: <20060130104613.GA26551@suse.de> <20060130164954.GA4711@suse.de> <20060206220434.GA11732@suse.de> <1139265890.3022.63.camel@mulgrave.il.steeleye.com> <20060209200529.GA8968@suse.de> <20060210101124.GA6253@suse.de> <1139580295.3084.3.camel@mulgrave.il.steeleye.com> <20060210141012.GA12147@suse.de> <20060210230140.GA26423@suse.de> <43ED1FE0.1000805@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="17pEHd4RhPHOinZp"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:41131 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S932244AbWBJX3i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Feb 2006 18:29:38 -0500
Content-Disposition: inline
In-Reply-To: <43ED1FE0.1000805@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

 On Fri, Feb 10, Brian King wrote:

> >    release = 0xd0000000002190c0}, reap_ref = 0, channel = 255, id = 100, 
> >    create = 0, scsi_level = 0 '\0', hostdata = 0x0, starget_data = 
> >    0x1ffffffec60}
>                                                    ^^^^^^^^^^^^^
> 
> This is interesting.. This means that it is on ipr's logical scsi bus 
> (255). Assuming this is
> happening at boot time and not due to a user initiated scan through sysfs, 
> this
> means we are going through the scsi_add_device path, rather than the 
> scsi_scan_host
> path...

I forgot to attach my notes from the crash, it contains parts of the bootlog.

-- 
short story of a lazy sysadmin:
 alias appserv=wotan

--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="2.6.16-rc2-git7-notes.txt"

1:mon> ?
Commands:
  b     show breakpoints
  bd    set data breakpoint
  bi    set instruction breakpoint
  bc    clear breakpoint
  c     print cpus stopped in xmon
  c#    try to switch to cpu number h (in hex)
  C     checksum
  d     dump bytes
  di    dump instructions
  df    dump float values
  dd    dump double values
  e     print exception information
  f     flush cache
  la    lookup symbol+offset of specified address
  ls    lookup address of specified symbol
  m     examine/change memory
  mm    move a block of memory
  ms    set a block of memory
  md    compare two blocks of memory
  ml    locate a block of memory
  mz    zero a block of memory
  mi    show information about memory allocation
  p     call a procedure
  r     print registers
  s     single step
  S     print special registers
  t     print backtrace
  x     exit monitor and recover
  X     exit monitor and dont recover
  u     dump segment table or SLB
  ?     help
  zr    reboot
  zh    halt

Good boot:

Freeing unused kernel memory: 252k freed
Starting udevd
Creating devices
Loading sd_mod
SCSI subsystem initialized
Loading loop
loop: loaded (max 255 devices)
Loading ipr
ipr: IBM Power RAID SCSI Device Driver version: 2.1.1 (November 15, 2005)
ipr 0000:c0:01.0: Found IOA with IRQ: 99
ipr 0000:c0:01.0: Starting IOA initialization sequence.
ipr 0000:c0:01.0: Adapter firmware version: 020A004E
ipr 0000:c0:01.0: IOA initialized.
scsi0 : IBM 570B Storage Adapter
  Vendor: IBM       Model: ST373453LC        Rev: C51A
  Type:   Direct-Access                      ANSI SCSI revision: 03
SCSI device sda: 143374000 512-byte hdwr sectors (73407 MB)
sda: Write Protect is off
SCSI device sda: drive cache: write through w/ FUA
SCSI device sda: 143374000 512-byte hdwr sectors (73407 MB)
sda: Write Protect is off
SCSI device sda: drive cache: write through w/ FUA
 sda: sda1 sda2 sda3 sda4
sd 0:0:3:0: Attached scsi disk sda
  Vendor: IBM       Model: VSBPD3E   U4SCSI  Rev: 4812
  Type:   Enclosure                          ANSI SCSI revision: 02
sd 0:0:3:0: Attached scsi generic sg0 type 0
 0:0:15:0: Attached scsi generic sg1 type 13
scsi: unknown device type 31
  Vendor: IBM       Model: 570B001           Rev: 0150
  Type:   Unknown                            ANSI SCSI revision: 00
 0:255:255:255: Attached scsi generic sg2 type 31
ipr 0002:c8:01.0: Found IOA with IRQ: 133
ipr 0002:c8:01.0: Initializing IOA.
ipr 0002:c8:01.0: Starting IOA initialization sequence.
ipr 0002:c8:01.0: Adapter firmware version: 020A004E
ipr 0002:c8:01.0: IOA initialized.
scsi1 : IBM 570B Storage Adapter
  Vendor: IBM       Model: VSBPD3E   U4SCSI  Rev: 4812
  Type:   Enclosure                          ANSI SCSI revision: 02
 1:0:15:0: Attached scsi generic sg3 type 13
scsi: unknown device type 31
  Vendor: IBM       Model: 570B001           Rev: 0150
  Type:   Unknown                            ANSI SCSI revision: 00
 1:255:255:255: Attached scsi generic sg4 type 31



Bad boot:
Freeing unused kernel memory: 252k freed
Starting udevd
Creating devices
Loading sd_mod
SCSI subsystem initialized
Loading loop
loop: loaded (max 255 devices)
Loading ipr
ipr: IBM Power RAID SCSI Device Driver version: 2.1.1 (November 15, 2005)
ipr 0000:c0:01.0: Found IOA with IRQ: 99
ipr 0000:c0:01.0: Starting IOA initialization sequence.
ipr 0000:c0:01.0: Adapter firmware version: 020A004E
ipr 0000:c0:01.0: IOA initialized.
scsi0 : IBM 570B Storage Adapter
  Vendor: IBM       Model: ST373453LC        Rev: C51A
  Type:   Direct-Access                      ANSI SCSI revision: 03
SCSI device sda: 143374000 512-byte hdwr sectors (73407 MB)
sda: Write Protect is off
SCSI device sda: drive cache: write through w/ FUA
SCSI device sda: 143374000 512-byte hdwr sectors (73407 MB)
sda: Write Protect is off
SCSI device sda: drive cache: write through w/ FUA
 sda: sda1 sda2 sda3 sda4
sd 0:0:3:0: Attached scsi disk sda
  Vendor: IBM       Model: VSBPD3E   U4SCSI  Rev: 4812
  Type:   Enclosure                          ANSI SCSI revision: 02
sd 0:0:3:0: Attached scsi generic sg0 type 0
 0:0:15:0: Attached scsi generic sg1 type 13
Unable to handle kernel paging request for data at address 0x00000004
Faulting instruction address: 0xc0000000001dd0dc
cpu 0x1: Vector: 300 (Data Access) at [c0000000036937e0]
    pc: c0000000001dd0dc: ._raw_spin_lock+0x2c/0x18c
    lr: c0000000003821f0: ._spin_lock+0x10/0x24
    sp: c000000003693a60
   msr: 8000000000009032
   dar: 4
 dsisr: 40000000
  current = 0xc0000000eb9777f0
  paca    = 0xc00000000049f000
    pid   = 27, comm = events/1
enter ? for help
1:mon> t
[c000000003693af0] c0000000003821f0 ._spin_lock+0x10/0x24
[c000000003693b70] c00000000037ea44 .klist_del+0x28/0x58
[c000000003693c00] c000000000262d98 .device_del+0x50/0x120
[c000000003693ca0] d0000000001eec64 .scsi_target_reap_work+0xe0/0x12c [scsi_mod]
[c000000003693d30] c000000000076e70 .run_workqueue+0x108/0x19c
[c000000003693dd0] c000000000077054 .worker_thread+0x150/0x1c0
[c000000003693ed0] c00000000007c9f8 .kthread+0x140/0x190
[c000000003693f90] c000000000025764 .kernel_thread+0x4c/0x68
1:mon> r
R00 = ffffffffdead0000   R16 = 0000000000000000
R01 = c000000003693a60   R17 = 0000000000000000
R02 = c000000000630a38   R18 = 0000000000000000
R03 = 0000000000000000   R19 = 0000000000000000
R04 = 000000000000003e   R20 = 0000000000c00000
R05 = 000000000000003e   R21 = 0000000000000008
R06 = c000000003d4b2e8   R22 = 0000000000000000
R07 = 0000000000000000   R23 = 4000000000400000
R08 = c0000000006ff018   R24 = c00000000049ee00
R09 = c0000000006e4338   R25 = c00000007257fc40
R10 = c0000000024f2d28   R26 = c000000002364b88
R11 = c000000000262d48   R27 = c000000003d4b268
R12 = 0000000024000084   R28 = 0000000000000000
R13 = c00000000049f000   R29 = c0000000024cad00
R14 = 0000000000000000   R30 = c0000000004fadc8
R15 = 0000000000000000   R31 = 0000000000000000
pc  = c0000000001dd0dc ._raw_spin_lock+0x2c/0x18c
lr  = c0000000003821f0 ._spin_lock+0x10/0x24
msr = 8000000000009032   cr  = 24008084
ctr = c000000000262d48   xer = 0000000000000000   trap =  300
dar = 0000000000000004   dsisr = 40000000
1:mon> 
1:mon> 

echo $(( 0xc000000003693d30 - 0xc000000003693a60 ))
720

1:mon> d c000000003693a60 720
c000000003693a60 c000000003693af0 c000000003880ec8  |.....i:.........|
c000000003693a70 c000000000500d60 0000000000000000  |.....P.`........|
c000000003693a80 c000000003693b20 0000000000000000  |.....i; ........|
c000000003693a90 c0000000004fabd0 c000000000630a38  |.....O.......c.8|
c000000003693aa0 c000000003693b20 c000000000630a38  |.....i; .....c.8|
c000000003693ab0 c000000003693b50 c000000003880ff8  |.....i;P........|
c000000003693ac0 c000000003693b50 c000000007520808  |.....i;P.....R..|
c000000003693ad0 0000000000000000 c0000000024cad00  |.............L..|
c000000003693ae0 c000000000518718 c0000000024cacc8  |.....Q.......L..|
_spin_lock
c000000003693af0 c000000003693b70 c000000003dc8430  |.....i;p.......0|
c000000003693b00 c0000000003821f0 c000000003880ec8  |.....8!.........|
c000000003693b10 c0000000004facb0 c000000003880ea0  |.....O..........|
c000000003693b20 d0000000001eebec c000000003d4b000  |................|
c000000003693b30 c00000006fffc600 0000000000000000  |....o...........|
c000000003693b40 c0000000004dfe88 c000000003d4b260  |.....M.........`|
c000000003693b50 c000000003693bf0 c0000000006160f0  |.....i;......a`.|
c000000003693b60 c000000000518aa0 c000000000501548  |.....Q.......P.H|
klist_del
c000000003693b70 c000000003693c00 c000000003693d30  |.....i<......i=0|
c000000003693b80 c00000000037ea44 c000000002316740  |.....7.D.....1g@|
c000000003693b90 c000000003693c10 c0000000eb9777f0  |.....i<.......w.|
c000000003693ba0 c000000003693c20 0000000000000008  |.....i< ........|
c000000003693bb0 c0000000001d6908 4000000000400000  |......i.@....@..|
c000000003693bc0 8000000000009032 c000000003d4b268  |.......2.......h|
c000000003693bd0 d0000000001eebec c0000000ebf19ad0  |................|
c000000003693be0 c00000000303a1a8 c0000000024cadf8  |.............L..|
c000000003693bf0 c000000003d4b268 8000000000009032  |.......h.......2|
device_del
c000000003693c00 c000000003693ca0 c0000000024cacc8  |.....i<......L..|
c000000003693c10 c000000000262d98 c0000000024caca0  |.....&-......L..|
c000000003693c20 c000000003693ca0 c0000000eb608000  |.....i<......`..|
c000000003693c30 c00000000026acdc 0000000000000000  |.....&..........|
c000000003693c40 c00000000038209c 0000000000000000  |.....8 .........|
c000000003693c50 8000000000001032 c000000002364bc0  |.......2.....6K.|
c000000003693c60 c000000003d4b260 0000000000000003  |.......`........|
c000000003693c70 c000000002364b88 c000000003d4b268  |.....6K........h|
c000000003693c80 c000000003d4b268 c0000000024cacc8  |.......h.....L..|
c000000003693c90 c00000000303a000 c0000000024caca0  |.............L..|
scsi_target_reap_work
c000000003693ca0 c000000003693d30 2400008402364b60  |.....i=0$....6K`|
c000000003693cb0 d0000000001eec64 4400002803b677f0  |.......dD..(..w.|
c000000003693cc0 c0000000003820d4 d000000000221930  |.....8 ......".0|
c000000003693cd0 0000000000000000 0000000000000000  |................|
c000000003693ce0 0000000000000003 0000000000000000  |................|
c000000003693cf0 0000000022000022 c00000007257fc40  |....".."....rW.@|
c000000003693d00 c000000002364b88 c000000003d4b300  |.....6K.........|
c000000003693d10 d000000000219228 c000000003d4b268  |.....!.(.......h|
c000000003693d20 c0000000004dc890 c000000002364b60  |.....M.......6K`|
run_workqueue
c000000003693d30 c000000003693dd0 0000000000000000  |.....i=.........|
c000000003693d40 c000000000076e70 000000000000021c  |......np........|
c000000003693d50 c00000000007ce98 c000000000630a38  |.............c.8|
c000000003693d60 0000000000000000 0000000000000000  |................|
c000000003693d70 0000000000c00000 0000000000000008  |................|
c000000003693d80 0000000000000000 4000000000400000  |........@....@..|
c000000003693d90 c00000000049ee00 c00000007257fc40  |.....I......rW.@|
c000000003693da0 c000000002364b60 c00000007257fbd0  |.....6K`....rW..|
c000000003693db0 c000000002364b88 c000000002364b98  |.....6K......6K.|
c000000003693dc0 c0000000004dc890 c000000002364b60  |.....M.......6K`|
worker_thread
c000000003693dd0 c000000003693ed0 2400002200000000  |.....i>.$.."....|
c000000003693de0 c000000000077054 0000000000000000  |......pT........|
c000000003693df0 0000000000000000 c00000007257fc40  |............rW.@|
c000000003693e00 c000000002364b60 8000000000009032  |.....6K`.......2|
c000000003693e10 c00000007257fbd8 c00000007257fbd0  |....rW......rW..|
c000000003693e20 00000000004dcba0 fffffffffffffffc  |.....M..........|
c000000003693e30 0000000000000001 0000000000000000  |................|
c000000003693e40 0000000000000000 c0000000eb9777f0  |..............w.|
c000000003693e50 c0000000005f0608 0000000000100100  |....._..........|
c000000003693e60 0000000000200200 0000000000000000  |..... ..........|
c000000003693e70 0000000000000001 0000000000000000  |................|
c000000003693e80 c0000000005f0608 0000000000010000  |....._..........|
c000000003693e90 0000000000000000 c00000007257fc40  |............rW.@|
c000000003693ea0 ffffffffffffffff c00000007257fbd0  |............rW..|
c000000003693eb0 c0000000005f31a0 c000000002364b60  |....._1......6K`|
c000000003693ec0 c0000000004dcba0 fffffffffffffffc  |.....M..........|
kthread
c000000003693ed0 c000000003693f90 00000000ffffffff  |.....i?.........|
c000000003693ee0 c00000000007c9f8 0000000000000000  |................|
c000000003693ef0 0000000000000000 c000000000630a38  |.............c.8|
c000000003693f00 0000000000000000 ffffffffffffffff  |................|
c000000003693f10 ffffffffffffffff 0000000000000000  |................|
c000000003693f20 0000000000000000 0000000000000000  |................|
c000000003693f30 0000000000000000 0000000000000000  |................|
c000000003693f40 ffffffffffffffff ffffffffffffffff  |................|
c000000003693f50 ffffffffffffffff 4000000000400000  |........@....@..|
c000000003693f60 c00000000049ee00 c0000000005f31a0  |.....I......._1.|
c000000003693f70 c0000000003a0630 c00000000007c8b8  |.....:.0........|
c000000003693f80 c00000007257fbc0 c0000000003c3350  |....rW.......<3P|
kernel_thread
c000000003693f90 0000000000000000 c0000000003c3350  |.............<3P|
c000000003693fa0 c000000000025764 8000000000009032  |......Wd.......2|
c000000003693fb0 0000000000800711 c00000000007c824  |...............$|
c000000003693fc0 c00000000007c854 0000000020000000  |.......T.... ...|
c000000003693fd0 0000000024000022 00000001ffffffff  |....$.."........|
c000000003693fe0 0000000000000c00 0000000000000000  |................|
c000000003693ff0 0000000000000000 0000000000000000  |................|



c0000000001dd0b0 <._raw_spin_lock>:
c0000000001dd0b0:       7c 08 02 a6     mflr    r0
c0000000001dd0b4:       fb c1 ff f0     std     r30,-16(r1)
c0000000001dd0b8:       fb e1 ff f8     std     r31,-8(r1)				(sp)c000000003693a60 + 144 - 8 == c000000003693ae8
c0000000001dd0bc:       fb 81 ff e0     std     r28,-32(r1)
c0000000001dd0c0:       fb a1 ff e8     std     r29,-24(r1)
c0000000001dd0c4:       eb c2 c8 d8     ld      r30,-14120(r2)
c0000000001dd0c8:       7c 7f 1b 78     mr      r31,r3					lock == NULL
c0000000001dd0cc:       f8 01 00 10     std     r0,16(r1)
c0000000001dd0d0:       f8 21 ff 71     stdu    r1,-144(r1)
c0000000001dd0d4:       3c 00 de ad     lis     r0,-8531
c0000000001dd0d8:       60 00 00 00     nop
c0000000001dd0dc:       81 23 00 04     lwz     r9,4(r3)
c0000000001dd0e0:       60 00 4e ad     ori     r0,r0,20141
c0000000001dd0e4:       7f 89 00 00     cmpw    cr7,r9,r0
c0000000001dd0e8:       41 9e 00 0c     beq-    cr7,c0000000001dd0f4 <._raw_spin_lock+0x44>
c0000000001dd0ec:       e8 9e 80 18     ld      r4,-32744(r30)
c0000000001dd0f0:       4b ff fb 4d     bl      c0000000001dcc3c <.spin_bug>
...

c0000000003821e0 <._spin_lock>:
c0000000003821e0:       7c 08 02 a6     mflr    r0
c0000000003821e4:       f8 01 00 10     std     r0,16(r1)
c0000000003821e8:       f8 21 ff 81     stdu    r1,-128(r1)
c0000000003821ec:       4b e5 ae c5     bl      c0000000001dd0b0 <._raw_spin_lock>
c0000000003821f0:       60 00 00 00     nop
c0000000003821f4:       38 21 00 80     addi    r1,r1,128
c0000000003821f8:       e8 01 00 10     ld      r0,16(r1)
c0000000003821fc:       7c 08 03 a6     mtlr    r0
c000000000382200:       4e 80 00 20     blr

c00000000037ea1c <.klist_del>:
c00000000037ea1c:       7c 08 02 a6     mflr    r0
c00000000037ea20:       fb a1 ff e8     std     r29,-24(r1)
c00000000037ea24:       fb 81 ff e0     std     r28,-32(r1)
c00000000037ea28:       7c 7d 1b 78     mr      r29,r3					n == c0000000024cad00
c00000000037ea2c:       f8 01 00 10     std     r0,16(r1)
c00000000037ea30:       f8 21 ff 71     stdu    r1,-144(r1)
c00000000037ea34:       60 00 00 00     nop
c00000000037ea38:       eb 83 00 00     ld      r28,0(r3)
c00000000037ea3c:       7f 83 e3 78     mr      r3,r28					lock == NULL
c00000000037ea40:       48 00 37 a1     bl      c0000000003821e0 <._spin_lock>
c00000000037ea44:       60 00 00 00     nop
c00000000037ea48:       7f a3 eb 78     mr      r3,r29
c00000000037ea4c:       4b ff fe f5     bl      c00000000037e940 <.klist_dec_and_del>
c00000000037ea50:       7f 83 e3 78     mr      r3,r28
c00000000037ea54:       48 00 36 9d     bl      c0000000003820f0 <._spin_unlock>
c00000000037ea58:       60 00 00 00     nop
c00000000037ea5c:       38 21 00 90     addi    r1,r1,144
c00000000037ea60:       e8 01 00 10     ld      r0,16(r1)
c00000000037ea64:       eb 81 ff e0     ld      r28,-32(r1)
c00000000037ea68:       eb a1 ff e8     ld      r29,-24(r1)
c00000000037ea6c:       7c 08 03 a6     mtlr    r0
c00000000037ea70:       4e 80 00 20     blr

c000000000262d48 <.device_del>:
c000000000262d48:       7d 80 00 26     mfcr    r12
c000000000262d4c:       7c 08 02 a6     mflr    r0
c000000000262d50:       fb a1 ff e8     std     r29,-24(r1)
c000000000262d54:       fb c1 ff f0     std     r30,-16(r1)
c000000000262d58:       fb e1 ff f8     std     r31,-8(r1)
c000000000262d5c:       fb 61 ff d8     std     r27,-40(r1)
c000000000262d60:       7c 7f 1b 78     mr      r31,r3					dev == c0000000024cacc8
c000000000262d64:       3b a3 01 30     addi    r29,r3,304
c000000000262d68:       fb 81 ff e0     std     r28,-32(r1)				(sp)c000000003693ca0 + 160 - 32 == c000000003693c80
c000000000262d6c:       eb c2 cb 90     ld      r30,-13424(r2)
c000000000262d70:       f8 01 00 10     std     r0,16(r1)
c000000000262d74:       91 81 00 08     stw     r12,8(r1)
c000000000262d78:       f8 21 ff 61     stdu    r1,-160(r1)
c000000000262d7c:       60 00 00 00     nop
c000000000262d80:       60 00 00 00     nop
c000000000262d84:       eb 83 01 28     ld      r28,296(r3)
c000000000262d88:       38 63 00 38     addi    r3,r3,56
c000000000262d8c:       2e 3c 00 00     cmpdi   cr4,r28,0
c000000000262d90:       41 92 00 0c     beq-    cr4,c000000000262d9c <.device_del+0x54>
c000000000262d94:       48 11 bc 89     bl      c00000000037ea1c <.klist_del>
c000000000262d98:       60 00 00 00     nop
c000000000262d9c:       7f e3 fb 78     mr      r3,r31
c000000000262da0:       38 9f 01 98     addi    r4,r31,408
c000000000262da4:       4b ff ff 29     bl      c000000000262ccc <.device_remove_file>
c000000000262da8:       e9 3e 80 40     ld      r9,-32704(r30)
c000000000262dac:       7f e3 fb 78     mr      r3,r31
c000000000262db0:       e9 29 00 00     ld      r9,0(r9)
c000000000262db4:       2f a9 00 00     cmpdi   cr7,r9,0
c000000000262db8:       41 9e 00 28     beq-    cr7,c000000000262de0 <.device_del+0x98>
c000000000262dbc:       e8 09 00 00     ld      r0,0(r9)
c000000000262dc0:       f8 41 00 28     std     r2,40(r1)
c000000000262dc4:       60 00 00 00     nop
c000000000262dc8:       60 00 00 00     nop
c000000000262dcc:       e9 69 00 10     ld      r11,16(r9)
c000000000262dd0:       e8 49 00 08     ld      r2,8(r9)
c000000000262dd4:       7c 09 03 a6     mtctr   r0
c000000000262dd8:       4e 80 04 21     bctrl
c000000000262ddc:       e8 41 00 28     ld      r2,40(r1)
c000000000262de0:       7f e3 fb 78     mr      r3,r31
c000000000262de4:       48 00 19 bd     bl      c0000000002647a0 <.bus_remove_device>
c000000000262de8:       60 00 00 00     nop
c000000000262dec:       38 80 00 02     li      r4,2
c000000000262df0:       7f a3 eb 78     mr      r3,r29
c000000000262df4:       4b f7 47 e5     bl      c0000000001d75d8 <.kobject_uevent>
c000000000262df8:       60 00 00 00     nop
c000000000262dfc:       7f a3 eb 78     mr      r3,r29
c000000000262e00:       4b f7 3f 01     bl      c0000000001d6d00 <.kobject_del>
c000000000262e04:       60 00 00 00     nop
c000000000262e08:       7f 83 e3 78     mr      r3,r28
c000000000262e0c:       41 92 00 30     beq-    cr4,c000000000262e3c <.device_del+0xf4>
c000000000262e10:       38 21 00 a0     addi    r1,r1,160
c000000000262e14:       e8 01 00 10     ld      r0,16(r1)
c000000000262e18:       81 81 00 08     lwz     r12,8(r1)
c000000000262e1c:       eb e1 ff f8     ld      r31,-8(r1)
c000000000262e20:       eb 61 ff d8     ld      r27,-40(r1)
c000000000262e24:       eb 81 ff e0     ld      r28,-32(r1)
c000000000262e28:       eb a1 ff e8     ld      r29,-24(r1)
c000000000262e2c:       eb c1 ff f0     ld      r30,-16(r1)
c000000000262e30:       7c 08 03 a6     mtlr    r0
c000000000262e34:       7d 80 81 20     mtcrf   8,r12
c000000000262e38:       4b ff fd 50     b       c000000000262b88 <.put_device>
c000000000262e3c:       38 21 00 a0     addi    r1,r1,160
c000000000262e40:       e8 01 00 10     ld      r0,16(r1)
c000000000262e44:       81 81 00 08     lwz     r12,8(r1)
c000000000262e48:       eb 61 ff d8     ld      r27,-40(r1)
c000000000262e4c:       eb 81 ff e0     ld      r28,-32(r1)
c000000000262e50:       eb a1 ff e8     ld      r29,-24(r1)
c000000000262e54:       eb c1 ff f0     ld      r30,-16(r1)
c000000000262e58:       eb e1 ff f8     ld      r31,-8(r1)
c000000000262e5c:       7c 08 03 a6     mtlr    r0
c000000000262e60:       7d 80 81 20     mtcrf   8,r12
c000000000262e64:       4e 80 00 20     blr

1:mon> di d0000000001eeb84 35
d0000000001eeb84  7c0802a6      mflr    r0
d0000000001eeb88  fb81ffe0      std     r28,-32(r1)
d0000000001eeb8c  fba1ffe8      std     r29,-24(r1)
d0000000001eeb90  fbc1fff0      std     r30,-16(r1)
d0000000001eeb94  fbe1fff8      std     r31,-8(r1)
d0000000001eeb98  7c7c1b78      mr      r28,r3					wq == c000000003d4b268
d0000000001eeb9c  f8010010      std     r0,16(r1)
d0000000001eeba0  f821ff71      stdu    r1,-144(r1)
d0000000001eeba4  60000000      nop
 ...
d0000000001eebac  ebe30060      ld      r31,96(r3)				starget = c0000000024caca0
d0000000001eebb0  ebbf0150      ld      r29,336(r31)
d0000000001eebb4  48000014      b       d0000000001eebc8        # .scsi_target_reap_work+0x44/0x12c [scsi_mod]
d0000000001eebb8  e81d0128      ld      r0,296(r29)
d0000000001eebbc  2fa00000      cmpdi   cr7,r0,0
d0000000001eebc0  7c1d0378      mr      r29,r0
d0000000001eebc4  419e0020      beq     cr7,d0000000001eebe4    # .scsi_target_reap_work+0x60/0x12c [scsi_mod]
d0000000001eebc8  7fa3eb78      mr      r3,r29
d0000000001eebcc  3bc00000      li      r30,0
d0000000001eebd0  4bff5e35      bl      d0000000001e4a04        # .scsi_is_host_device+0x0/0x2c [scsi_mod]
d0000000001eebd4  60000000      nop
d0000000001eebd8  2f830000      cmpwi   cr7,r3,0
d0000000001eebdc  419effdc      beq     cr7,d0000000001eebb8    # .scsi_target_reap_work+0x34/0x12c [scsi_mod]
d0000000001eebe0  3bddfe58      addi    r30,r29,-424
d0000000001eebe4  7f83e378      mr      r3,r28
d0000000001eebe8  48003871      bl      d0000000001f2458        # .scsi_init_procfs+0x4d0/0x3140 [scsi_mod]		kfree()
d0000000001eebec  e8410028      ld      r2,40(r1)
d0000000001eebf0  e87e0078      ld      r3,120(r30)
d0000000001eebf4  48003505      bl      d0000000001f20f8        # .scsi_init_procfs+0x170/0x3140 [scsi_mod]		spin_lock_irqsave()
d0000000001eebf8  e8410028      ld      r2,40(r1)
d0000000001eebfc  813f0278      lwz     r9,632(r31)
d0000000001eec00  7c641b78      mr      r4,r3
d0000000001eec04  3929ffff      addi    r9,r9,-1
d0000000001eec08  2f890000      cmpwi   cr7,r9,0
d0000000001eec0c  913f0278      stw     r9,632(r31)
d0000000001eec10  409e0074      bne     cr7,d0000000001eec84    # .scsi_target_reap_work+0x100/0x12c [scsi_mod]
d0000000001eec14  e81f0018      ld      r0,24(r31)
d0000000001eec18  393f0018      addi    r9,r31,24
d0000000001eec1c  7fa90000      cmpd    cr7,r9,r0
d0000000001eec20  409e0064      bne     cr7,d0000000001eec84    # .scsi_target_reap_work+0x100/0x12c [scsi_mod]
d0000000001eec24  393f0008      addi    r9,r31,8
d0000000001eec28  e95f0008      ld      r10,8(r31)
d0000000001eec2c  3bbf0028      addi    r29,r31,40
d0000000001eec30  e9690008      ld      r11,8(r9)
d0000000001eec34  f94b0000      std     r10,0(r11)
d0000000001eec38  f96a0008      std     r11,8(r10)
d0000000001eec3c  f93f0008      std     r9,8(r31)
d0000000001eec40  f9290008      std     r9,8(r9)
d0000000001eec44  e87e0078      ld      r3,120(r30)
d0000000001eec48  480034e1      bl      d0000000001f2128        # .scsi_init_procfs+0x1a0/0x3140 [scsi_mod]		spin_unlock_irqrestore()
d0000000001eec4c  e8410028      ld      r2,40(r1)
d0000000001eec50  7fa3eb78      mr      r3,r29
d0000000001eec54  48003c55      bl      d0000000001f28a8        # .scsi_init_procfs+0x920/0x3140 [scsi_mod]		transport_remove_device()
d0000000001eec58  e8410028      ld      r2,40(r1)
d0000000001eec5c  7fa3eb78      mr      r3,r29
d0000000001eec60  48003c19      bl      d0000000001f2878        # .scsi_init_procfs+0x8f0/0x3140 [scsi_mod]		device_del()
d0000000001eec64  e8410028      ld      r2,40(r1)
d0000000001eec68  7fa3eb78      mr      r3,r29
d0000000001eec6c  48003c6d      bl      d0000000001f28d8        # .scsi_init_procfs+0x950/0x3140 [scsi_mod]		transport_destroy_device()
d0000000001eec70  e8410028      ld      r2,40(r1)
d0000000001eec74  7fa3eb78      mr      r3,r29
d0000000001eec78  48003421      bl      d0000000001f2098        # .scsi_init_procfs+0x110/0x3140 [scsi_mod]		put_device()
d0000000001eec7c  e8410028      ld      r2,40(r1)
d0000000001eec80  48000010      b       d0000000001eec90        # .scsi_target_reap_work+0x10c/0x12c [scsi_mod]
d0000000001eec84  e87e0078      ld      r3,120(r30)
d0000000001eec88  480034a1      bl      d0000000001f2128        # .scsi_init_procfs+0x1a0/0x3140 [scsi_mod]		spin_unlock_irqrestore()
d0000000001eec8c  e8410028      ld      r2,40(r1)
d0000000001eec90  38210090      addi    r1,r1,144
d0000000001eec94  e8010010      ld      r0,16(r1)
d0000000001eec98  eb81ffe0      ld      r28,-32(r1)
d0000000001eec9c  eba1ffe8      ld      r29,-24(r1)
d0000000001eeca0  ebc1fff0      ld      r30,-16(r1)
d0000000001eeca4  ebe1fff8      ld      r31,-8(r1)
d0000000001eeca8  7c0803a6      mtlr    r0
d0000000001eecac  4e800020      blr


1:mon> d c0000000024cacc8
c0000000024cacc8 00000000dead4ead ffffffff00000000  |......N.........|
c0000000024cacd8 ffffffffffffffff c0000000024cace0  |.............L..|
c0000000024cace8 c0000000024cace0 c000000000614f68  |.....L.......aOh|
c0000000024cacf8 c000000000614f38 0000000000000000  |.....aO8........|
c0000000024cad08 0000000000000000 0000000000000000  |................|
c0000000024cad18 0000000000000000 0000000000000000  |................|
c0000000024cad28 0000000000000000 0000000000000000  |................|
c0000000024cad38 0000000000000000 0000000000000000  |................|
c0000000024cad48 0000000000000000 0000000000000000  |................|
c0000000024cad58 0000000000000000 0000000000000000  |................|
c0000000024cad68 0000000000000000 0000000000000000  |................|
c0000000024cad78 0000000000000000 0000000000000000  |................|
c0000000024cad88 0000000000000000 0000000000000000  |................|
c0000000024cad98 0000000000000000 0000000000000000  |................|
c0000000024cada8 0000000000000000 0000000000000000  |................|
c0000000024cadb8 0000000000000000 0000000000000000  |................|
c0000000024cadc8 0000000000000000 0000000000000000  |................|
c0000000024cadd8 0000000000000000 0000000000000000  |................|
c0000000024cade8 0000000000000000 c00000000303a1a8  |................|
c0000000024cadf8 c0000000024cae00 746172676574303a  |.....L..target0:|
c0000000024cae08 3235353a31303000 0000000000000006  |255:100.........|
c0000000024cae18 c0000000024cae18 c0000000024cae18  |.....L.......L..|
c0000000024cae28 c00000000303a2d8 c000000000500c88  |.............P..|
c0000000024cae38 0000000000000000 0000000000000000  |................|
c0000000024cae48 746172676574303a 3235353a31303000  |target0:255:100.|
c0000000024cae58 0000000000000000 0000000000000000  |................|
c0000000024cae68 0000000000000000 0000000000000000  |................|
c0000000024cae78 0000000000000000 0000000000000000  |................|
c0000000024cae88 0000000100000000 00000000dead4ead  |..............N.|
c0000000024cae98 ffffffff00000000 ffffffffffffffff  |................|
c0000000024caea8 c0000000024caea8 c0000000024caea8  |.....L.......L..|
c0000000024caeb8 0000000000000000 0000000000000000  |................|
c0000000024caec8 0000000000000000 0000000000000000  |................|
c0000000024caed8 0000000000000000 0000000000000000  |................|
c0000000024caee8 0000000000000000 0000000000000000  |................|
c0000000024caef8 c0000000024caef8 c0000000024caef8  |.....L.......L..|
c0000000024caf08 0000000000000000 d0000000002190c0  |.............!..|
c0000000024caf18 00000000000000ff 0000006400000000  |...........d....|
c0000000024caf28 0000000000000000 5a5a5a5a5a5a5a5a  |........ZZZZZZZZ|
c0000000024caf38 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
c0000000024caf48 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
c0000000024caf58 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
c0000000024caf68 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
c0000000024caf78 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
c0000000024caf88 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
c0000000024caf98 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
c0000000024cafa8 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
c0000000024cafb8 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
c0000000024cafc8 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
c0000000024cafd8 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
c0000000024cafe8 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
c0000000024caff8 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
c0000000024cb008 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
c0000000024cb018 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
c0000000024cb028 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
c0000000024cb038 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
c0000000024cb048 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
c0000000024cb058 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
c0000000024cb068 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
c0000000024cb078 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
c0000000024cb088 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
c0000000024cb098 5a5a5a5a5a5a5aa5 00000000170fc2a5  |ZZZZZZZ.........|
c0000000024cb0a8 d0000000001eea84 00000000170fc2a5  |................|
c0000000024cb0b8 0000000100000000 c0000000024d0e98  |.............M..|
c0000000024cb0c8 c0000000024cb0c8 c0000000024cb0c8  |.....L.......L..|
c0000000024cb0d8 c0000000024cb0d8 c0000000024cb0d8  |.....L.......L..|
c0000000024cb0e8 c0000000024cb0e8 c0000000024cb0e8  |.....L.......L..|
c0000000024cb0f8 c0000000024cb0f8 c0000000024cb0f8  |.....L.......L..|
c0000000024cb108 c0000000024cb108 c0000000024cb108  |.....L.......L..|
c0000000024cb118 c0000000024cb118 c0000000024cb118  |.....L.......L..|
c0000000024cb128 c0000000024cb128 c0000000024cb128  |.....L.(.....L.(|
c0000000024cb138 c0000000024cb138 c0000000024cb138  |.....L.8.....L.8|
c0000000024cb148 c0000000024cb148 c0000000024cb148  |.....L.H.....L.H|
c0000000024cb158 c0000000024cb158 c0000000024cb158  |.....L.X.....L.X|
c0000000024cb168 c0000000024cb168 c0000000024cb168  |.....L.h.....L.h|
c0000000024cb178 0000000000000000 c0000000024cb180  |.............L..|
c0000000024cb188 c0000000024cb180 c000000003dcbb50  |.....L.........P|
c0000000024cb198 c000000003dcbd68 0000002000000000  |.......h... ....|
c0000000024cb1a8 c000000003dc8560 0000000000000000  |.......`........|
c0000000024cb1b8 0000000000000000 0000000000000000  |................|
c0000000024cb1c8 0000000000000000 c00000000060c1c0  |.............`..|
c0000000024cb1d8 c0000000024cb0b8 c00000000231fc00  |.....L.......1..|
c0000000024cb1e8 0000000000000000 c0000000024cb1f0  |.............L..|
c0000000024cb1f8 c0000000024cb1f0 c00000000060c178  |.....L.......`.x|
c0000000024cb208 c0000000024d0e98 0000000000000000  |.....M..........|
c0000000024cb218 0000000000000000 0000000000000000  |................|
c0000000024cb228 0000000000000000 0000000000000000  |................|
c0000000024cb238 0000000000000000 c00000000231fc00  |.............1..|
c0000000024cb248 0000000000000000 0000000000000000  |................|
c0000000024cb258 0000000000000000 0000000000000000  |................|
c0000000024cb268 0000000000000000 0000000000000000  |................|
c0000000024cb278 0000000000000000 c00000000060c190  |.............`..|
c0000000024cb288 c0000000024cb0b8 c00000000231fc00  |.....L.......1..|
c0000000024cb298 0000000000000000 0000000000000000  |................|
c0000000024cb2a8 0000000000000004 0000000800000019  |................|
c0000000024cb2b8 0000000c00000002 0000400000000004  |..........@.....|
c0000000024cb2c8 0000000a00000002 0000000100000002  |................|
c0000000024cb2d8 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
c0000000024cb2e8 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
c0000000024cb2f8 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
c0000000024cb308 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
c0000000024cb318 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
c0000000024cb328 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
c0000000024cb338 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
c0000000024cb348 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
c0000000024cb358 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
c0000000024cb368 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
c0000000024cb378 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
c0000000024cb388 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
c0000000024cb398 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
c0000000024cb3a8 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
c0000000024cb3b8 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
c0000000024cb3c8 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
c0000000024cb3d8 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|


wq:
1:mon> d c000000003d4b268 104
c000000003d4b268 6b6b6b6b6b6b6b6b 6b6b6b6b6b6b6b6b  |kkkkkkkkkkkkkkkk|
c000000003d4b278 6b6b6b6b6b6b6b6b 6b6b6b6b6b6b6b6b  |kkkkkkkkkkkkkkkk|
c000000003d4b288 6b6b6b6b6b6b6b6b 6b6b6b6b6b6b6b6b  |kkkkkkkkkkkkkkkk|
c000000003d4b298 6b6b6b6b6b6b6b6b 6b6b6b6b6b6b6b6b  |kkkkkkkkkkkkkkkk|
c000000003d4b2a8 6b6b6b6b6b6b6b6b 6b6b6b6b6b6b6b6b  |kkkkkkkkkkkkkkkk|
c000000003d4b2b8 6b6b6b6b6b6b6b6b 6b6b6b6b6b6b6b6b  |kkkkkkkkkkkkkkkk|
c000000003d4b2c8 6b6b6b6b6b6b6b6b 6b6b6b6b6b6b6b6b  |kkkkkkkkkkkkkkkk|
c000000003d4b2d8 6b6b6b6b6b6b6b6b 6b6b6b6b6b6b6ba5  |kkkkkkkkkkkkkkk.|
c000000003d4b2e8 000000005a2cf071 d0000000001eebec  |....Z,.q........|
c000000003d4b2f8 000000005a2cf071 6b6b6b6b6b6b6b6b  |....Z,.qkkkkkkkk|
c000000003d4b308 6b6b6b6b6b6b6b6b 6b6b6b6b6b6b6b6b  |kkkkkkkkkkkkkkkk|
c000000003d4b318 6b6b6b6b6b6b6b6b 6b6b6b6b6b6b6b6b  |kkkkkkkkkkkkkkkk|
c000000003d4b328 6b6b6b6b6b6b6b6b 6b6b6b6b6b6b6b6b  |kkkkkkkkkkkkkkkk|
c000000003d4b338 6b6b6b6b6b6b6b6b 6b6b6b6b6b6b6b6b  |kkkkkkkkkkkkkkkk|
c000000003d4b348 6b6b6b6b6b6b6b6b 6b6b6b6b6b6b6b6b  |kkkkkkkkkkkkkkkk|
c000000003d4b358 6b6b6b6b6b6b6b6b 6b6b6b6b6b6b6b6b  |kkkkkkkkkkkkkkkk|
c000000003d4b368 6b6b6b6b                           |kkkk            |


--17pEHd4RhPHOinZp--
