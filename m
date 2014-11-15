From: Meelis Roos <mroos@linux.ee>
Subject: Re: Another (ESP?) scsi blk-mq problem on sparc64
Date: Sat, 15 Nov 2014 08:48:06 +0200 (EET)
Message-ID: <alpine.LRH.2.11.1411150829190.26813@adalberg.ut.ee>
References: <alpine.LRH.2.11.1411141302270.26966@adalberg.ut.ee> <20141114165804.GA14631@infradead.org> <alpine.LRH.2.11.1411142114200.26813@adalberg.ut.ee> <54665B30.4070708@kernel.dk> <alpine.LRH.2.11.1411150033400.26813@adalberg.ut.ee>
 <54669063.6050307@kernel.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <54669063.6050307@kernel.dk>
Sender: sparclinux-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org, David Miller <davem@davemloft.net>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

> On 2014-11-14 15:59, Meelis Roos wrote:
> > > > > The second oops is in blk_mq_map_queue() which is a trivial
> > > > > two level cpu lookup.  I wonder if there's something odd about
> > > > > cpu numbers on these big old sparc systems?
> > > >
> > > > CPU numbers are sparse - they are determined by hardware slot number and
> > > > some models only fill every other mainboard slot, and first slots can be
> > > > free. I have first board offline and currently have CPUs numbered
> > > > 10,11,14,15 online.
> > > >
> > > > Here is debug with Jens's patch:
> > >
> > > > [  133.971050] CPU 11: synchronized TICK with master CPU (last diff -1
> > > > cycles, maxerr 516 cycles)
> > > > [  133.975491] CPU 14: synchronized TICK with master CPU (last diff -3
> > > > cycles, maxerr 531 cycles)
> > > > [  133.979943] CPU 15: synchronized TICK with master CPU (last diff -3
> > > > cycles, maxerr 531 cycles)
> > > > [  133.980146] Brought up 4 CPUs
> > >
> > > So this looks like this might be the issue. On a scsi-mq disabled boot,
> > > you have 4 CPUs, but how are they numbered?
> >
> > The numbers are always the same.
> 
> I would hope so, my question was really on what CPU numbers you see. But I
> guess that 10, 11, 14, and 15?

Yes, I am always seeing these CPU number, sorry if I was unclear.

> > But everything seems to be mapped to queue 0?
> 
> As it should, scsi-mq only supports a single hw queue for now.
> 
> > > We might need Christophs debug patch on top this to fully know...
> >
> > Applied it too, dmesg is below. Yes it does spam the log a lot, and over
> > 9600bps console its' somewhat slow :)
> >
> > There is another detail to note  -this server contains a faulty disk as
> > sdc that times out spinup. I left it in the server because it helped to
> > pinpoint and fix a previous error in esp scsi driver. This can be a
> > factor here too - the error handling details.
> 
> It could be. So we have tons of mappings from CPU10 to queue 0, but then we
> see this:
> 
> > [  256.236742] cpu: 10
> > [  256.236749] queue: 809119744
> 
> and it turns to crap. This is pretty weird. Try with this debug patch - get
> rid of the other ones first. It should reduce your noise level too.

Here it is. This time it booted up:

[    0.000000] PROMLIB: Sun IEEE Boot Prom 'OBP 3.2.29 2001/06/18 17:28'
[    0.000000] PROMLIB: Root node compatible: 
[    0.000000] Linux version 3.18.0-rc4-00052-g04689e7-dirty (mroos@mandel) (gcc version 4.9.2 (Debian 4.9.2-1) ) #28 SMP Sat Nov 15 08:35:23 EET 2014
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] bootconsole [earlyprom0] enabled
[    0.000000] ARCH: SUN4U
[    0.000000] Ethernet address: 00:03:ba:12:70:5c
[    0.000000] MM: PAGE_OFFSET is 0xfffff80000000000 (max_phys_bits == 40)
[    0.000000] MM: VMALLOC [0x0000000100000000 --> 0x0000060000000000]
[    0.000000] MM: VMEMMAP [0x0000060000000000 --> 0x00000c0000000000]
[    0.000000] Kernel: Using 2 locked TLB entries for main kernel image.
[    0.000000] Remapping the kernel... done.
[    0.000000] OF stdout device is: /central@1f,0/fhc@0,f8800000/zs@0,902000:a
[    0.000000] PROM: Built device tree with 92727 bytes of memory.
[    0.000000] Top of RAM: 0xffd16000, Total RAM: 0xff954000
[    0.000000] Memory hole size: 3MB
[    0.000000] Allocated 16384 bytes for kernel page tables.
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00000000-0xffd15fff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00000000-0xff84dfff]
[    0.000000]   node   0: [mem 0xffc00000-0xffceffff]
[    0.000000]   node   0: [mem 0xffd00000-0xffd15fff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0xffd15fff]
[    0.000000] On node 0 totalpages: 523434
[    0.000000]   Normal zone: 4094 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 523434 pages, LIFO batch:15
[    0.000000] Booting Linux...
[    0.000000] CPU CAPS: [flush,stbar,swap,muldiv,v9,mul32,div32,v8plus]
[    0.000000] CPU CAPS: [vis]
[    0.000000] PERCPU: Embedded 7 pages/cpu @fffff800ff400000 s13248 r8192 d35904 u1048576
[    0.000000] pcpu-alloc: s13248 r8192 d35904 u1048576 alloc=1*4194304
[    0.000000] pcpu-alloc: [0] 10 11 14 15 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 519340
[    0.000000] Kernel command line: root=/dev/sda2 ro ignore_loglevel
[    0.000000] PID hash table entries: 4096 (order: 2, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 9, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 8, 2097152 bytes)
[    0.000000] Sorting __ex_table...
[    0.000000] Memory: 4142488K/4187472K available (3653K kernel code, 246K rwdata, 800K rodata, 184K init, 413K bss, 44984K reserved)
[    0.000000] SLUB: HWalign=32, Order=0-3, MinObjects=0, CPUs=16, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	Additional per-CPU info printed with stalls.
[    0.000000] NR_IRQS:2048 nr_irqs:2048 1
[  128.657527] clocksource: mult[2042108] shift[23]
[  128.712138] clockevent: mult[3f7ced91] shift[32]
[  128.767637] Console: colour dummy device 80x25
[  128.820567] console [tty0] enabled
[  128.861144] bootconsole [earlyprom0] disabled
[  129.063420] Calibrating delay using timer specific routine.. 497.45 BogoMIPS (lpj=2487295)
[  129.063492] pid_max: default: 32768 minimum: 301
[  129.063932] Mount-cache hash table entries: 8192 (order: 3, 65536 bytes)
[  129.063992] Mountpoint-cache hash table entries: 8192 (order: 3, 65536 bytes)
[  129.074872] CPU 11: synchronized TICK with master CPU (last diff -3 cycles, maxerr 521 cycles)
[  129.079309] CPU 14: synchronized TICK with master CPU (last diff -4 cycles, maxerr 533 cycles)
[  129.083754] CPU 15: synchronized TICK with master CPU (last diff -3 cycles, maxerr 537 cycles)
[  129.083960] Brought up 4 CPUs
[  129.086069] devtmpfs: initialized
[  129.169189] device-tree: Duplicate name in base, renamed to "fhc#1"
[  129.171764] device-tree: Duplicate name in base, renamed to "fhc#2"
[  129.174141] device-tree: Duplicate name in base, renamed to "counter-timer#1"
[  129.175629] NET: Registered protocol family 16
[  129.192224] SYSIO: UPA portID ffffffff, at 000001c400000000
[  129.202872] SYSIO: UPA portID ffffffff, at 000001c600000000
[  129.258073] SCSI subsystem initialized
[  129.261020] /central/fhc@0,f8800000/eeprom@0,908000: Mostek regs at 0x1fff8908000
[  129.262034] fhc: Board #1, Version[1] PartID[fa0] Manuf[3e] (Central)
[  129.262402] fhc: Board #5, Version[1] PartID[fa0] Manuf[3e] (JTAG Master)
[  129.262739] fhc: Board #7, Version[1] PartID[fa0] Manuf[3e] 
[  129.263089] fhc: Board #1, Version[1] PartID[fa0] Manuf[3e] 
[  129.263573] clock_board: Detected 4 slot Enterprise system.
[  129.264275] Switched to clocksource tick
[  129.287105] NET: Registered protocol family 2
[  129.289511] TCP established hash table entries: 32768 (order: 5, 262144 bytes)
[  129.291157] TCP bind hash table entries: 32768 (order: 6, 524288 bytes)
[  129.294361] TCP: Hash tables configured (established 32768 bind 32768)
[  129.295126] TCP: reno registered
[  129.295217] UDP hash table entries: 2048 (order: 3, 65536 bytes)
[  129.295752] UDP-Lite hash table entries: 2048 (order: 3, 65536 bytes)
[  129.297087] NET: Registered protocol family 1
[  129.301408] futex hash table entries: 1024 (order: 3, 65536 bytes)
[  129.301979] audit: initializing netlink subsys (disabled)
[  129.302250] audit: type=2000 audit(0.399:1): initialized
[  129.303580] HugeTLB registered 8 MB page size, pre-allocated 0 pages
[  129.340672] msgmni has been set to 8090
[  129.343819] io scheduler noop registered
[  129.345018] io scheduler cfq registered (default)
[  129.554283] zs f005ddbc: ttyS0 at MMIO 0x1fff8902000 (irq = 2, base_baud = 307200) is a zs (ESCC)
[  129.554389] Console: ttyS0 (SunZilog zs0)
[  135.582986] console [ttyS0] enabled
[  135.625569] zs f005ddbc: ttyS1 at MMIO 0x1fff8902004 (irq = 2, base_baud = 307200) is a zs (ESCC)
[  135.939954] f005de94: Keyboard at MMIO 0x1fff8904000 (irq = 2) is a zs
[  136.016155] f005de94: Mouse at MMIO 0x1fff8904004 (irq = 2) is a zs
[  136.093730] esp: esp0, regs[1c738810000:1c738800000] irq[19]
[  136.159506] esp: esp0 is a FASHME, 40 MHz (ccf=0), SCSI ID 7
[  139.234226] scsi host0: esp
[  139.267162] cpumap 0 -> 0
[  139.269849] rtc-m48t59 rtc-m48t59.0: rtc core: registered m48t59 as rtc0
[  139.271492] TCP: cubic registered
[  139.273657] NET: Registered protocol family 10
[  139.277211] NET: Registered protocol family 17
[  139.296894] rtc-m48t59 rtc-m48t59.0: setting system clock to 2014-11-15 06:40:41 UTC (1416033641)
[  139.629273] cpumap 1 -> 0
[  139.629280] cpumap 2 -> 0
[  139.629285] cpumap 3 -> 0
[  139.691925] scsi 0:0:0:0: Direct-Access     HP 36.4G ST336706LC       HP03 PQ: 0 ANSI: 2
[  139.692013] scsi target0:0:0: Beginning Domain Validation
[  139.894927] scsi target0:0:0: FAST-10 WIDE SCSI 20.0 MB/s ST (100 ns, offset 15)
[  139.987643] scsi target0:0:0: Domain Validation skipping write tests
[  140.061731] scsi target0:0:0: Ending Domain Validation
[  140.123189] cpumap 0 -> 0
[  140.154380] cpumap 1 -> 0
[  140.185630] cpumap 2 -> 0
[  140.216888] cpumap 3 -> 0
[  140.252831] cpumap 0 -> 0
[  140.282156] cpumap 1 -> 0
[  140.313371] cpumap 2 -> 0
[  140.344651] cpumap 3 -> 0
[  140.380252] scsi 0:0:1:0: Direct-Access     HP 36.4G ST336706LC       HP03 PQ: 0 ANSI: 2
[  140.475273] scsi target0:0:1: Beginning Domain Validation
[  140.555781] scsi target0:0:1: FAST-10 WIDE SCSI 20.0 MB/s ST (100 ns, offset 15)
[  140.648453] scsi target0:0:1: Domain Validation skipping write tests
[  140.722588] scsi target0:0:1: Ending Domain Validation
[  140.784042] cpumap 0 -> 0
[  140.815239] cpumap 1 -> 0
[  140.846492] cpumap 2 -> 0
[  140.877744] cpumap 3 -> 0
[  140.913616] cpumap 0 -> 0
[  140.942897] cpumap 1 -> 0
[  140.974151] cpumap 2 -> 0
[  141.005415] cpumap 3 -> 0
[  141.038765] scsi 0:0:2:0: Direct-Access     IBM      DDYS-T18350M     S96H PQ: 0 ANSI: 3
[  141.133748] scsi target0:0:2: Beginning Domain Validation
[  141.202518] scsi target0:0:2: FAST-10 WIDE SCSI 20.0 MB/s ST (100 ns, offset 15)
[  141.290542] scsi target0:0:2: Domain Validation skipping write tests
[  141.365189] scsi target0:0:2: Ending Domain Validation
[  141.429842] cpumap 0 -> 0
[  141.459112] cpumap 1 -> 0
[  141.490347] cpumap 2 -> 0
[  141.521603] cpumap 3 -> 0
[  141.787155] cpumap 0 -> 0
[  141.816515] cpumap 1 -> 0
[  141.847715] cpumap 2 -> 0
[  141.878961] cpumap 3 -> 0
[  142.144466] cpumap 0 -> 0
[  142.173748] cpumap 1 -> 0
[  142.204998] cpumap 2 -> 0
[  142.236213] cpumap 3 -> 0
[  142.501721] cpumap 0 -> 0
[  142.530996] cpumap 1 -> 0
[  142.562246] cpumap 2 -> 0
[  142.593469] cpumap 3 -> 0
[  142.858971] cpumap 0 -> 0
[  142.888245] cpumap 1 -> 0
[  142.919497] cpumap 2 -> 0
[  142.950719] cpumap 3 -> 0
[  143.216214] cpumap 0 -> 0
[  143.245507] cpumap 1 -> 0
[  143.276747] cpumap 2 -> 0
[  143.307975] cpumap 3 -> 0
[  143.573467] cpumap 0 -> 0
[  143.602752] cpumap 1 -> 0
[  143.634006] cpumap 2 -> 0
[  143.665238] cpumap 3 -> 0
[  143.930731] cpumap 0 -> 0
[  143.960006] cpumap 1 -> 0
[  143.991252] cpumap 2 -> 0
[  144.022474] cpumap 3 -> 0
[  144.287973] cpumap 0 -> 0
[  144.317255] cpumap 1 -> 0
[  144.348506] cpumap 2 -> 0
[  144.379727] cpumap 3 -> 0
[  144.645219] cpumap 0 -> 0
[  144.674501] cpumap 1 -> 0
[  144.705729] cpumap 2 -> 0
[  144.736980] cpumap 3 -> 0
[  145.002478] cpumap 0 -> 0
[  145.031763] cpumap 1 -> 0
[  145.063010] cpumap 2 -> 0
[  145.094250] cpumap 3 -> 0
[  145.359734] cpumap 0 -> 0
[  145.389010] cpumap 1 -> 0
[  145.420264] cpumap 2 -> 0
[  145.451484] cpumap 3 -> 0
[  145.720408] sd 0:0:0:0: [sda] 71132960 512-byte logical blocks: (36.4 GB/33.9 GiB)
[  145.810617] sd 0:0:0:0: [sda] Write Protect is off
[  145.866366] sd 0:0:0:0: [sda] Mode Sense: 9f 00 10 08
[  145.926924] sd 0:0:1:0: [sdb] 71132960 512-byte logical blocks: (36.4 GB/33.9 GiB)
[  146.018918] sd 0:0:2:0: [sdc] Spinning up disk...
[  146.019072] sd 0:0:1:0: [sdb] Write Protect is off
[  146.019096] sd 0:0:1:0: [sdb] Mode Sense: 9f 00 10 08
[  146.073854] sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
[  146.131174] sd 0:0:1:0: [sdb] Write cache: disabled, read cache: enabled, supports DPO and FUA
[  146.404148]  sda: sda1 sda2 sda3 sda4
[  146.447900]  sdb: unknown partition table
[  146.501349] sd 0:0:0:0: [sda] Attached SCSI disk
[  146.555295] sd 0:0:1:0: [sdb] Attached SCSI disk
[  147.404159] ....................................................................................................not responding...
[  247.424529] sd 0:0:2:0: [sdc] READ CAPACITY failed
[  247.479803] sd 0:0:2:0: [sdc]  
[  247.517288] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[  247.583978] sd 0:0:2:0: [sdc]  
[  247.621487] Sense Key : Not Ready [current] 
[  247.672493] sd 0:0:2:0: [sdc]  
[  247.710046] Add. Sense: Logical unit not ready, cause not reportable
[  247.788409] sd 0:0:2:0: [sdc] Test WP failed, assume Write Enabled
[  247.861176] sd 0:0:2:0: [sdc] Asking for cache data failed
[  247.926063] sd 0:0:2:0: [sdc] Assuming drive cache: write through
[  248.001337] blk-mq: cpu 14 got queue 1828716544
[  248.053686]   cpu10 -> queue index 809119744
[  248.104595]   cpu11 -> queue index 0
[  248.147313]   cpu14 -> queue index 1828716544
[  248.199394]   cpu15 -> queue index 0
[  248.244954] sd 0:0:2:0: [sdc] Spinning up disk...
[  249.303368] ...................
[  267.493441] random: nonblocking pool is initialized
[  268.563220] ................................................................................not responding...
[  348.383773] sd 0:0:2:0: [sdc] READ CAPACITY failed
[  348.439076] sd 0:0:2:0: [sdc]  
[  348.476555] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[  348.543248] sd 0:0:2:0: [sdc]  
[  348.580741] Sense Key : Not Ready [current] 
[  348.631756] sd 0:0:2:0: [sdc]  
[  348.669310] Add. Sense: Logical unit not ready, cause not reportable
[  348.748978] sd 0:0:2:0: [sdc] Attached SCSI disk
[  348.810914] EXT4-fs (sda2): couldn't mount as ext3 due to feature incompatibilities
[  348.906307] EXT4-fs (sda2): couldn't mount as ext2 due to feature incompatibilities
[  349.041728] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
[  349.131526] VFS: Mounted root (ext4 filesystem) readonly on device 259:786432.
[  349.242025] devtmpfs: mounted
[  349.927938] systemd[1]: systemd 215 running in system mode. (+PAM +AUDIT +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ -SECCOMP -APPARMOR)
[  350.086045] systemd[1]: Detected architecture 'sparc64'.
[  350.385323] systemd[1]: Failed to insert module 'autofs4'
[  350.460814] systemd[1]: Set hostname to <mandel>.
[  352.204460] systemd[1]: Cannot add dependency job for unit display-manager.service, ignoring: Unit display-manager.service failed to load: No such file or directory.
[  352.387177] systemd[1]: Expecting device dev-ttyS0.device...
[  352.512831] systemd[1]: Starting Forward Password Requests to Wall Directory Watch.
[  352.603400] systemd[1]: Started Forward Password Requests to Wall Directory Watch.
[  352.693400] systemd[1]: Starting Remote File Systems (Pre).
[  352.842767] systemd[1]: Reached target Remote File Systems (Pre).
[  352.914025] systemd[1]: Starting Dispatch Password Requests to Console Directory Watch.
[  353.010183] systemd[1]: Started Dispatch Password Requests to Console Directory Watch.
[  353.104676] systemd[1]: Starting Paths.
[  353.212753] systemd[1]: Reached target Paths.
[  353.263212] systemd[1]: Starting Arbitrary Executable File Formats File System Automount Point.
[  353.367306] systemd[1]: Failed to open /dev/autofs: No such file or directory
[  353.452596] systemd[1]: Failed to initialize automounter: No such file or directory
[  353.742762] systemd[1]: Failed to set up automount Arbitrary Executable File Formats File System Automount Point.
[  353.863849] systemd[1]: Unit proc-sys-fs-binfmt_misc.automount entered failed state.
[  353.956648] systemd[1]: Starting Encrypted Volumes.
[  354.082748] systemd[1]: Reached target Encrypted Volumes.
[  354.145547] systemd[1]: Expecting device dev-disk-by\x2duuid-bea3cb0e\x2d50b4\x2d4f9a\x2db255\x2db30866bdf689.device...
[  354.372795] systemd[1]: Expecting device dev-disk-by\x2duuid-0cf86009\x2dcf54\x2d4c05\x2d8a82\x2d3d82b1abaea4.device...
[  354.602978] systemd[1]: Starting Root Slice.
[  354.712740] systemd[1]: Created slice Root Slice.
[  354.767279] systemd[1]: Starting User and Session Slice.
[  354.902743] systemd[1]: Created slice User and Session Slice.
[  354.969809] systemd[1]: Starting /dev/initctl Compatibility Named Pipe.
[  355.142749] systemd[1]: Listening on /dev/initctl Compatibility Named Pipe.
[  355.224333] systemd[1]: Starting Delayed Shutdown Socket.
[  355.362742] systemd[1]: Listening on Delayed Shutdown Socket.
[  355.429792] systemd[1]: Starting Journal Socket (/dev/log).
[  355.572741] systemd[1]: Listening on Journal Socket (/dev/log).
[  355.641888] systemd[1]: Starting Syslog Socket.
[  355.762735] systemd[1]: Listening on Syslog Socket.
[  355.819422] systemd[1]: Starting udev Control Socket.
[  355.952735] systemd[1]: Listening on udev Control Socket.
[  356.015596] systemd[1]: Starting udev Kernel Socket.
[  356.142731] systemd[1]: Listening on udev Kernel Socket.
[  356.204633] systemd[1]: Starting Journal Socket.
[  356.322732] systemd[1]: Listening on Journal Socket.
[  356.380521] systemd[1]: Starting System Slice.
[  356.502739] systemd[1]: Created slice System Slice.
[  356.559420] systemd[1]: Starting File System Check on Root Device...
[  356.716999] systemd[1]: Starting system-systemd\x2dfsck.slice.
[  356.862733] systemd[1]: Created slice system-systemd\x2dfsck.slice.
[  356.936192] systemd[1]: Starting system-getty.slice.
[  356.997330] systemd[1]: Created slice system-getty.slice.
[  357.061723] systemd[1]: Starting system-serial\x2dgetty.slice.
[  357.132826] systemd[1]: Created slice system-serial\x2dgetty.slice.
[  357.208874] systemd[1]: Mounted Debug File System.
[  357.266022] systemd[1]: Mounting POSIX Message Queue File System...
[  357.441212] systemd[1]: Starting Load Kernel Modules...
[  357.541833] systemd[1]: Started Set Up Additional Binary Formats.
[  357.615056] systemd[1]: Mounting Huge Pages File System...
[  357.688167] systemd[1]: Starting Create list of required static device nodes for the current kernel...
[  357.804251] systemd[1]: Starting udev Coldplug all Devices...
[  357.878208] systemd[1]: Starting Journal Service...
[  357.941793] systemd[1]: Started Journal Service.
[  358.186398] loop: module loaded
[  358.384285] sunhme.c:v3.10 August 26, 2008 David S. Miller (davem@davemloft.net)
[  358.474949] eth0: HAPPY MEAL (SBUS) 10/100baseT Ethernet 00:03:ba:12:70:5c
[  358.559366] eth1: Quattro HME slot 0 (SBUS) 10/100baseT Ethernet 08:00:20:9d:77:08
[  358.651993] eth2: Quattro HME slot 1 (SBUS) 10/100baseT Ethernet 08:00:20:9d:77:09
[  358.744833] eth3: Quattro HME slot 2 (SBUS) 10/100baseT Ethernet 08:00:20:9d:77:0a
[  358.838570] eth4: Quattro HME slot 3 (SBUS) 10/100baseT Ethernet 08:00:20:9d:77:0b
[  359.524274] systemd-udevd[85]: starting version 215
[  360.528599] sd 0:0:0:0: Attached scsi generic sg0 type 0
[  360.593588] sd 0:0:1:0: Attached scsi generic sg1 type 0
[  360.655824] sd 0:0:2:0: Attached scsi generic sg2 type 0
[  361.898324] Adding 1566328k swap on /dev/sda4.  Priority:-1 extents:1 across:1566328k 
[  362.420151] EXT4-fs (sda2): re-mounted. Opts: errors=remount-ro
[  362.812832] EXT4-fs (sda1): mounting ext2 file system using the ext4 subsystem
[  362.915592] EXT4-fs (sda1): mounted filesystem without journal. Opts: (null)
[  363.853445] systemd-journald[71]: Received request to flush runtime journal from PID 1
[  368.852414] eth0: Link is up using internal transceiver at 100Mb/s, Full Duplex.

-- 
Meelis Roos (mroos@linux.ee)
