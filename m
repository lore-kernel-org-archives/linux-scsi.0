From: Helge Deller <deller@gmx.de>
Subject: Re: kernel BUG in drivers/scsi/53c700.c:1129
Date: Fri, 10 Jun 2016 22:25:29 +0200
Message-ID: <575B2239.4020403@gmx.de>
References: <5759C524.2030009@gmx.de>
 <1465511002.2259.19.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-parisc-owner@vger.kernel.org>
In-Reply-To: <1465511002.2259.19.camel@HansenPartnership.com>
Sender: linux-parisc-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 10.06.2016 00:23, James Bottomley wrote:
> On Thu, 2016-06-09 at 21:36 +0200, Helge Deller wrote:
>> Hi James,
>>
>> I just tried Debian kernel 4.6.1-1 on my historic 715/64 machine, and it
>> ran into this  BUG() in the LASI scsi driver:
>>
>>  scsi 0:0:6:0: no saved request for untagged cmd
>>
>> Any idea?
>>
>> Helge
>>  
>> [    0.000000] Linux version 4.6.0-1-parisc (debian-kernel@lists.debian.org) (gcc version 5.4.0 20160603 (Debian 5.4.0-3) ) #1 Debian 4.6.1-1 (2016-06-06)
>> ...
>> [    0.000000] Determining PDC firmware type: Snake.
>> [    0.000000] model 000060a0 00000481 00000000 00000000 773c7d2c 00000000 00000004 00000072 00000072
>> [    0.000000] vers  0000000c
>> [    0.000000] model 9000/715
>> [    0.000000] Total Memory: 160 MB
>> ...
>> [   43.180000] SCSI subsystem initialized
>> [   45.076000] 53c700: Version 2.8 By James.Bottomley@HansenPartnership.com
>> [   45.156000] scsi0: 53c710 rev 2 
>> [   46.204000] scsi host0: LASI SCSI 53c700
>> [   58.268000] scsi 0:0:6:0: no saved request for untagged cmd
>> [   58.336000] ------------[ cut here ]------------
>> [   58.392000] kernel BUG at /build/linux-XAODSw/linux-4.6.1/drivers/scsi/53c700.c:1129!
>> [   58.484000] CPU: 0 PID: 0 Comm: swapper Not tainted 4.6.0-1-parisc #1 Debian 4.6.1-1
>> [   58.580000] task: 1083cdd8 ti: 107b1000 task.ti: 107b1000
>> [   58.644000] 
>> [   58.660000]      YZrvWESTHLNXBCVMcbcbcbcbOGFRQPDI
>> [   58.716000] PSW: 00000000000001001111111100001110 Not tainted
>> [   58.788000] r00-03  0004ff0e 0084e388 00a8ea8c 107ba400
>> [   58.848000] r04-07  00000000 00000000 15b88cc0 00000006
>> [   58.912000] r08-11  198ca400 000000ff 00000020 00000000
>> [   58.976000] r12-15  000000ff 00001003 10801020 00000001
>> [   59.036000] r16-19  107b1240 00000002 000000ff 00000001
>> [   59.100000] r20-23  00000001 0000000e 0084f388 00000000
>> [   59.164000] r24-27  107ba500 0083b540 1021a7a4 107b5020
>> [   59.224000] r28-31  00000000 00000040 107ba480 104d52bc
>> [   59.288000] sr00-03  00000000 00000000 00000000 0000000d
>> [   59.352000] sr04-07  00000000 00000000 00000000 00000000
>> [   59.416000] 
>> [   59.432000] IASQ: 00000000 00000000 IAOQ: 00a8ea8c 00a8ea90
>> [   59.500000]  IIR: 03ffe01f    ISR: 0000000d  IOR: 00a8ea90
>> [   59.564000]  CPU:        0   CR30: 107b1000 CR31: f00effff
>> [   59.632000]  ORIG_R28: 10855e80
>> [   59.668000]  IAOQ[0]: process_script_interrupt+0x13ec/0x16a4 [53c700]
>> [   59.748000]  IAOQ[1]: process_script_interrupt+0x13f0/0x16a4 [53c700]
>> [   59.824000]  RP(r2): process_script_interrupt+0x13ec/0x16a4 [53c700]
>> [   59.900000] Backtrace:
>> [   59.928000]  [<00a8ea8c>] process_script_interrupt+0x13ec/0x16a4 [53c700]
>> [   60.012000] 
>> [   60.028000] CPU: 0 PID: 0 Comm: swapper Not tainted 4.6.0-1-parisc #1 Debian 4.6.1-1
>> [   60.120000] Backtrace:
>> [   60.148000]  [<1015bffc>] show_stack+0x3c/0x50
>> [   60.204000]  [<10425d40>] dump_stack+0x28/0x38
>> [   60.256000]  [<1015c180>] die_if_kernel+0x134/0x20c
>> [   60.316000]  [<1015cd34>] handle_interruption+0x804/0x828
>> [   60.380000] 
>> [   60.400000] Kernel panic - not syncing: Fatal exception in interrupt
>> [   60.400000] ---[ end Kernel panic - not syncing: Fatal exception in interrupt
> 
> It looks like either an unsolicited reselection or possibly a spurious
> interrupt left over from something.  Can you define NCR_700_DEBUG in
> drivers/scsi/53c700.h and see what it says?

I enabled NCR_700_DEBUG and NCR_700_TAG_DEBUG.
This is from vanilla kernel 4.6:

[    8.700000] Uniform Multi-Platform E-IDE driver
[    8.760000] ide-gd driver 1.18
[    8.790000] ide-cd driver 5.00
[    8.860000]  script, patching MessageLocation at 31 to 0x09f684b0
[    8.930000]  script, patching StatusAddress at 281 to 0x09f684d0
[    9.000000]  script, patching ReceiveMsgAddress at 15 to 0x09f684c0
[    9.080000]  script, patching ReceiveMsgAddress at 19 to 0x09f684c0
[    9.150000]  script, patching ReceiveMsgAddress at 41 to 0x09f684c0
[    9.230000]  script, patching ReceiveMsgAddress at 49 to 0x09f684c0
[    9.300000]  script, patching ReceiveMsgAddress at 55 to 0x09f684c0
[    9.370000]  script, patching ReceiveMsgAddress at 71 to 0x09f684c0
[    9.450000]  script, patching ReceiveMsgAddress at 77 to 0x09f684c0
[    9.520000]  script, patching ReceiveMsgAddress at 83 to 0x09f684c0
[    9.600000]  script, patching ReceiveMsgAddress at 89 to 0x09f684c0
[    9.670000]  script, patching ReceiveMsgAddress at 95 to 0x09f684c0
[    9.750000]  script, patching ReceiveMsgAddress at 137 to 0x09f684c0
[    9.830000]  script, patching ReceiveMsgAddress at 147 to 0x09f684c0
[    9.900000]  script, patching ReceiveMsgAddress at 177 to 0x09f684c0
[    9.980000]  script, patching ReceiveMsgAddress at 215 to 0x09f684c0
[   10.050000]  script, patching ReceiveMsgAddress at 251 to 0x09f684c0
[   10.130000]  script, patching ReceiveMsgAddress at 285 to 0x09f684c0
[   10.210000] 53c700: Version 2.8 By James.Bottomley@HansenPartnership.com
[   10.290000] scsi0: 53c710 rev 2 
[   11.330000] 53c700: sync 1 async 2
[   11.370000] scsi host0: LASI SCSI 53c700
[   11.430000] 53c700: scsi0, command 
[   11.430000] scsi 0:0:0:0: tag#0 CDB: opcode=0x12 12 00 00 00 24 00
[   11.430000]  scatter block 0: move 36[09000024] from 0x9d66100
[   11.430000]  SETTING 09f684e8 to 90080000
[   11.430000]  script, patching short field MessageCount at 30 to 0xe000006
[   11.430000]  script, patching ID field Device_ID at 0 to 0x41010000
[   11.430000]  script, patching CommandAddress at 121 to 0x09c0d3c8
[   11.430000]  script, patching short field CommandCount at 120 to 0xa000006
[   11.430000]  script, patching SGScriptStartAddress at 191 to 0x09f684e0
[   11.430000]  script, patching SGScriptStartAddress at 207 to 0x09f684e0
[   32.090000] scsi 0:0:0:0: tag#0 abort command
[   32.140000] scsi 0:0:0:0: tag#0 New error handler wants BUS reset, cmd 19f72d20
[   32.140000] 
[   32.240000] scsi 0:0:0:0: tag#0 CDB: opcode=0x12 12 00 00 00 24 00
[   32.320000] scsi0: istat 02 sstat0 02 dstat 00 dsp 0002[09f68008] dsps 0x9f68020
[   32.320000] scsi0: Bus Reset detected, executing command 19f72d20, slot 000084e0, dsp 09f68008[0008]
[   32.320000]  failing command because of reset, slot 000084e0, cmnd 19f72d20
[   32.320000] 53c700: sync 1 async 2
[   42.670000] 53c700: scsi0, command 
[   42.670000] scsi 0:0:0:0: tag#0 CDB: opcode=0x0 00 00 00 00 00 00
[   42.670000]  script, patching short field MessageCount at 30 to 0xe000006
[   42.670000]  script, patching ID field Device_ID at 0 to 0x41010000
[   42.670000]  script, patching CommandAddress at 121 to 0x09fa03f4
[   42.670000]  script, patching short field CommandCount at 120 to 0xa000006
[   42.670000]  script, patching SGScriptStartAddress at 191 to 0x09f684e0
[   42.670000]  script, patching SGScriptStartAddress at 207 to 0x09f684e0
[   43.260000] scsi 0:0:0:0: tag#0 abort command
[   43.310000] scsi0: istat 02 sstat0 02 dstat 00 dsp 0004[09f68010] dsps 0x9f68460
[   43.310000] scsi0: Bus Reset detected, executing command 19f72d20, slot 000084e0, dsp 09f68010[0010]
[   43.310000]  failing command because of reset, slot 000084e0, cmnd 19f72d20
[   43.310000] 53c700: sync 1 async 2
[   43.650000] scsi 0:0:0:0: tag#0 New error handler wants BUS reset, cmd 19f72d20
[   43.650000] 
[   43.760000] scsi 0:0:0:0: tag#0 CDB: opcode=0x0 00 00 00 00 00 00
[   43.830000] scsi0: istat 02 sstat0 02 dstat 00 dsp 0004[09f68010] dsps 0x9f68460
[   43.830000] scsi0: Bus Reset detected, executing command   (null), slot   (null), dsp 09f68010[0010]
[   43.830000] 53c700: sync 1 async 2
[   54.110000] scsi 0:0:0:0: tag#0 New error handler wants HOST reset
[   54.110000] 
[   54.200000] scsi 0:0:0:0: tag#0 CDB: opcode=0x12 12 00 00 00 24 00
[   54.270000] 53c700: sync 1 async 2
[   54.270000] timer_interrupt(CPU 0): delayed! cycles 3F77F5E rem 20A2  next/now 90731E60/9072FDBE
[   65.430000] 53c700: scsi0, command 
[   65.430000] scsi 0:0:0:0: tag#0 CDB: opcode=0x0 00 00 00 00 00 00
[   65.430000]  script, patching short field MessageCount at 30 to 0xe000006
[   65.430000]  script, patching ID field Device_ID at 0 to 0x41010000
[   65.430000]  script, patching CommandAddress at 121 to 0x09fa03f4
[   65.430000]  script, patching short field CommandCount at 120 to 0xa000006
[   65.430000]  script, patching SGScriptStartAddress at 191 to 0x09f684e0
[   65.430000]  script, patching SGScriptStartAddress at 207 to 0x09f684e0
[   66.020000] scsi 0:0:0:0: tag#0 abort command
[   66.070000] scsi0: istat 02 sstat0 02 dstat 00 dsp 0004[09f68010] dsps 0x9f68460
[   66.070000] scsi0: Bus Reset detected, executing command 19f72d20, slot 000084e0, dsp 09f68010[0010]
[   66.070000]  failing command because of reset, slot 000084e0, cmnd 19f72d20
[   66.070000] 53c700: sync 1 async 2
[   66.410000] scsi 0:0:0:0: tag#0 New error handler wants BUS reset, cmd 19f72d20
[   66.410000] 
[   66.520000] scsi 0:0:0:0: tag#0 CDB: opcode=0x0 00 00 00 00 00 00
[   66.590000] scsi0: istat 02 sstat0 02 dstat 00 dsp 0004[09f68010] dsps 0x9f68460
[   66.590000] scsi0: Bus Reset detected, executing command   (null), slot   (null), dsp 09f68010[0010]
[   66.590000] 53c700: sync 1 async 2
[   76.870000] scsi 0:0:0:0: Device offlined - not ready after error recovery
[   76.950000] 53c700: scsi0, command 
[   76.950000] scsi 0:0:1:0: tag#0 CDB: opcode=0x12 12 00 00 00 24 00
[   76.950000]  scatter block 0: move 36[09000024] from 0x9d66100
[   76.950000]  SETTING 09f684e8 to 90080000
[   76.950000]  script, patching short field MessageCount at 30 to 0xe000006
[   76.950000]  script, patching ID field Device_ID at 0 to 0x41020000
[   76.950000]  script, patching CommandAddress at 121 to 0x09c0d3c8
[   76.950000]  script, patching short field CommandCount at 120 to 0xa000006
[   76.950000]  script, patching SGScriptStartAddress at 191 to 0x09f684e0
[   76.950000]  script, patching SGScriptStartAddress at 207 to 0x09f684e0
[   77.970000] scsi0: istat 02 sstat0 20 dstat 00 dsp 0004[09f68010] dsps 0x9f68460
[   77.970000] scsi0: (1:0) selection timeout
[   78.110000] 53c700: scsi0, command 
[   78.110000] scsi 0:0:2:0: tag#0 CDB: opcode=0x12 12 00 00 00 24 00
[   78.110000]  scatter block 0: move 36[09000024] from 0x9d66100
[   78.110000]  SETTING 09f684e8 to 90080000
[   78.110000]  script, patching short field MessageCount at 30 to 0xe000006
[   78.110000]  script, patching ID field Device_ID at 0 to 0x41040000
[   78.110000]  script, patching CommandAddress at 121 to 0x09c0d3c8
[   78.110000]  script, patching short field CommandCount at 120 to 0xa000006
[   78.110000]  script, patching SGScriptStartAddress at 191 to 0x09f684e0
[   78.110000]  script, patching SGScriptStartAddress at 207 to 0x09f684e0
[   79.120000] scsi0: istat 02 sstat0 20 dstat 00 dsp 0004[09f68010] dsps 0x9f68460
[   79.120000] scsi0: (2:0) selection timeout
[   79.270000] 53c700: scsi0, command 
[   79.270000] scsi 0:0:3:0: tag#0 CDB: opcode=0x12 12 00 00 00 24 00
[   79.270000]  scatter block 0: move 36[09000024] from 0x9d66100
[   79.270000]  SETTING 09f684e8 to 90080000
[   79.270000]  script, patching short field MessageCount at 30 to 0xe000006
[   79.270000]  script, patching ID field Device_ID at 0 to 0x41080000
[   79.270000]  script, patching CommandAddress at 121 to 0x09c0d3c8
[   79.270000]  script, patching short field CommandCount at 120 to 0xa000006
[   79.270000]  script, patching SGScriptStartAddress at 191 to 0x09f684e0
[   79.270000]  script, patching SGScriptStartAddress at 207 to 0x09f684e0
[   80.280000] scsi0: istat 02 sstat0 20 dstat 00 dsp 0004[09f68010] dsps 0x9f68460
[   80.280000] scsi0: (3:0) selection timeout
[   80.420000] 53c700: scsi0, command 
[   80.420000] scsi 0:0:4:0: tag#0 CDB: opcode=0x12 12 00 00 00 24 00
[   80.420000]  scatter block 0: move 36[09000024] from 0x9d66100
[   80.420000]  SETTING 09f684e8 to 90080000
[   80.420000]  script, patching short field MessageCount at 30 to 0xe000006
[   80.420000]  script, patching ID field Device_ID at 0 to 0x41100000
[   80.420000]  script, patching CommandAddress at 121 to 0x09c0d3c8
[   80.420000]  script, patching short field CommandCount at 120 to 0xa000006
[   80.420000]  script, patching SGScriptStartAddress at 191 to 0x09f684e0
[   80.420000]  script, patching SGScriptStartAddress at 207 to 0x09f684e0
[   81.440000] scsi0: istat 02 sstat0 20 dstat 00 dsp 0004[09f68010] dsps 0x9f68460
[   81.440000] scsi0: (4:0) selection timeout
[   81.580000] 53c700: scsi0, command 
[   81.580000] scsi 0:0:5:0: tag#0 CDB: opcode=0x12 12 00 00 00 24 00
[   81.580000]  scatter block 0: move 36[09000024] from 0x9d66100
[   81.580000]  SETTING 09f684e8 to 90080000
[   81.580000]  script, patching short field MessageCount at 30 to 0xe000006
[   81.580000]  script, patching ID field Device_ID at 0 to 0x41200000
[   81.580000]  script, patching CommandAddress at 121 to 0x09c0d3c8
[   81.580000]  script, patching short field CommandCount at 120 to 0xa000006
[   81.580000]  script, patching SGScriptStartAddress at 191 to 0x09f684e0
[   81.580000]  script, patching SGScriptStartAddress at 207 to 0x09f684e0
[   82.590000] scsi0: istat 02 sstat0 20 dstat 00 dsp 0004[09f68010] dsps 0x9f68460
[   82.590000] scsi0: (5:0) selection timeout
[   82.740000] 53c700: scsi0, command 
[   82.740000] scsi 0:0:6:0: tag#0 CDB: opcode=0x12 12 00 00 00 24 00
[   82.740000]  scatter block 0: move 36[09000024] from 0x9d66100
[   82.740000]  SETTING 09f684e8 to 90080000
[   82.740000]  script, patching short field MessageCount at 30 to 0xe000006
[   82.740000]  script, patching ID field Device_ID at 0 to 0x41400000
[   82.740000]  script, patching CommandAddress at 121 to 0x09c0d3c8
[   82.740000]  script, patching short field CommandCount at 120 to 0xa000006
[   82.740000]  script, patching SGScriptStartAddress at 191 to 0x09f684e0
[   82.740000]  script, patching SGScriptStartAddress at 207 to 0x09f684e0
[   83.440000] scsi0: istat 09 sstat0 00 dstat 84 dsp 00ba[09f682e8] dsps 0x250
[   83.440000] scsi0: (6:0) ====>SCRIPT INTERRUPT<====
[   83.440000] scsi0 (6:0): message before command phase: 01 03 01 00 00 
[   83.440000] Attempting to resume at 9f682e8
[   83.710000] scsi0: istat 01 sstat0 00 dstat 84 dsp 00ac[09f682b0] dsps 0x380
[   83.710000] scsi0: (6:0) ====>SCRIPT INTERRUPT<====
[   83.710000] scsi0: (6:0), DISCONNECTED (3) after command phase
[   83.920000] scsi0: istat 0a sstat0 10 dstat 00 dsp 00ac[09f682b0] dsps 0x380
[   83.920000] scsi0:  Reselected by 6
[   83.920000] Attempting to resume at 9f68038
[   84.100000] scsi0: istat 09 sstat0 00 dstat 84 dsp 0012[09f68048] dsps 0x1003
[   84.100000] scsi0: (255:255) ====>SCRIPT INTERRUPT<====
[   84.100000] scsi0: (6:0) RESELECTED!
[   84.100000] scsi 0:0:6:0: no saved request for untagged cmd
[   84.360000] ------------[ cut here ]------------
[   84.410000] kernel BUG at /home/cvs/parisc/git-kernel/linus-linux-2.6/drivers/scsi/53c700.c:1129!
[   84.520000] CPU: 0 PID: 0 Comm: swapper Not tainted 4.6.0-32bit+ #323
[   84.590000] task: 10732288 ti: 1072b000 task.ti: 1072b000
[   84.660000] 
[   84.680000]      YZrvWESTHLNXBCVMcbcbcbcbOGFRQPDI
[   84.730000] PSW: 00000000000001001111111100001110 Not tainted
[   84.800000] r00-03  0004ff0e 1077a24c 10438288 10735940
[   84.860000] r04-07  19f63d80 00000000 09f68048 00000006
[   84.930000] r08-11  19d5e000 19fa6c00 00000020 10669d30
[   84.990000] r12-15  00000084 000000ff 00000000 00200000
[   85.050000] r16-19  10735280 00000002 00000000 00000001
[   85.110000] r20-23  00000001 0000000e 1077b24c 103cfbac
[   85.180000] r24-27  00000000 0000000e 00000000 1072f030
[   85.240000] r28-31  00000000 00000119 107359c0 103d2adc
[   85.300000] sr00-03  00000000 00000000 00000000 00000000
[   85.360000] sr04-07  00000000 00000000 00000000 00000000
[   85.430000] 
[   85.450000] IASQ: 00000000 00000000 IAOQ: 10438288 1043828c
[   85.510000]  IIR: 03ffe01f    ISR: 00000000  IOR: 107359c0
[   85.580000]  CPU:        0   CR30: 1072b000 CR31: f00effff
[   85.640000]  ORIG_R28: 00000000
[   85.680000]  IAOQ[0]: process_script_interrupt+0x7ac/0xdd8
[   85.750000]  IAOQ[1]: process_script_interrupt+0x7b0/0xdd8
[   85.810000]  RP(r2): process_script_interrupt+0x7ac/0xdd8
[   85.880000] Backtrace:
[   85.900000]  [<10439f1c>] NCR_700_intr+0xcf8/0x12c0
[   85.960000]  [<101a2c00>] handle_irq_event_percpu+0x80/0x178
[   86.030000]  [<101a2d44>] handle_irq_event+0x4c/0x84
[   86.090000]  [<101a5894>] handle_simple_irq+0x88/0xa8
[   86.150000]  [<101a23f4>] generic_handle_irq+0x2c/0x44
[   86.210000]  [<10394924>] gsc_asic_intr+0x80/0xb4
[   86.270000]  [<101a2c00>] handle_irq_event_percpu+0x80/0x178
[   86.340000]  [<101a61dc>] handle_percpu_irq+0x5c/0x88
[   86.400000]  [<101a23f4>] generic_handle_irq+0x2c/0x44
[   86.460000]  [<10156688>] execute_on_irq_stack+0x40/0x70
[   86.520000]  [<10156dcc>] do_cpu_irq_mask+0x19c/0x1e4
[   86.580000]  [<1014a068>] intr_return+0x0/0xc
[   86.630000]  [<101ac1f8>] hrtimer_run_queues+0x1f4/0x240
[   86.700000] 
[   86.720000] CPU: 0 PID: 0 Comm: swapper Not tainted 4.6.0-32bit+ #323
[   86.790000] Backtrace:
[   86.820000]  [<1015571c>] show_stack+0x18/0x28
[   86.870000]  [<10351234>] dump_stack+0x28/0x38
[   86.930000]  [<101558a8>] die_if_kernel+0x160/0x1d4
[   86.990000]  [<10155e08>] handle_interruption+0x250/0x754
[   87.050000]  [<103e6c08>] dev_vprintk_emit+0x194/0x1c8
[   87.110000]  [<1043828c>] process_script_interrupt+0x7b0/0xdd8
[   87.180000]  [<10438288>] process_script_interrupt+0x7ac/0xdd8
[   87.250000]  [<10439f1c>] NCR_700_intr+0xcf8/0x12c0
[   87.310000]  [<101a2c00>] handle_irq_event_percpu+0x80/0x178
[   87.380000]  [<101a2d44>] handle_irq_event+0x4c/0x84
[   87.440000]  [<101a5894>] handle_simple_irq+0x88/0xa8
[   87.500000]  [<101a23f4>] generic_handle_irq+0x2c/0x44
[   87.560000]  [<10394924>] gsc_asic_intr+0x80/0xb4
[   87.620000]  [<101a2c00>] handle_irq_event_percpu+0x80/0x178
[   87.680000]  [<101a61dc>] handle_percpu_irq+0x5c/0x88
[   87.740000]  [<101a23f4>] generic_handle_irq+0x2c/0x44
[   87.800000] 
[   87.820000] Kernel panic - not syncing: Fatal exception in interrupt


