From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH 00/71] More fixes, cleanup and modernization for NCR5380 drivers
Date: Sat, 21 Nov 2015 14:01:39 +0100
Message-ID: <201511211401.39957.linux@rainbow-software.org>
References: <20151118083455.331768508@telegraphics.com.au> <201511201929.17000.linux@rainbow-software.org> <alpine.LNX.2.00.1511211144460.23065@nippy.intranet>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1511211144460.23065@nippy.intranet>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Sam Creasey <sammy@sammy.net>, Michael Schmitz <schmitzmic@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Saturday 21 November 2015 02:58:57 Finn Thain wrote:
> 
> Hi Ondrej,
> 
> On Fri, 20 Nov 2015, Ondrej Zary wrote:
> 
> > On Friday 20 November 2015 02:41:19 Finn Thain wrote:
> > > 
> > > 
> > > My tests involved 3 different scsi targets (two disks and a CD-ROM) 
> > > but none of these send a SDTR. Your log says the driver correctly 
> > > rejected the SDTR message but that doesn't mean the target actually 
> > > went to MSG IN phase and got the message. Do you have any older 
> > > targets you can test?
> > 
> > Another disk, without patches:
> > 
> > [   84.481582] pnp 01:01.00: activated
> > [   84.489650] scsi host2: Generic NCR5380/NCR53C400 SCSI, io_port 0x240, n_io_port 16, base 0x0, irq 0, can_queue 16, cmd_per_lun 2, sg_tablesize 128, this_id 7, flags { DTC3181E NO_PSEUDO_DMA }, USLEEP_POLL 3, USLEEP_WAITLONG 1250, options { AUTOPROBE_IRQ PSEUDO_DMA NCR53C400 }
> > [   84.953332] scsi 2:0:1:0: Direct-Access     QUANTUM  LP240S GM240S01X 4.6  PQ: 0 ANSI: 2 CCS
> > [   86.786475] sd 2:0:1:0: Attached scsi generic sg1 type 0
> > [   86.793753] sd 2:0:1:0: [sdb] 479350 512-byte logical blocks: (245 MB/234 MiB)
> > [   86.998555] sd 2:0:1:0: [sdb] Write Protect is off
> > [   87.406068] sd 2:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> > [  118.888271] sd 2:0:1:0: [sdb] aborting command
> > [  118.888738] sd 2:0:1:0: [sdb] aborting command
> > 
> > With patches:
> > 
> > [  258.473748] pnp 01:01.00: activated
> > [  258.483592] scsi host2: Generic NCR5380/NCR53C400 SCSI, io_port 0x240, n_io_port 16, base 0x0, irq 0, can_queue 16, cmd_per_lun 2, sg_tablesize 128, this_id 7, flags { DTC3181E NO_PSEUDO_DMA }, options { AUTOPROBE_IRQ PSEUDO_DMA }
> > [  261.347632] scsi 2:0:1:0: Direct-Access     QUANTUM  LP240S GM240S01X 4.6  PQ: 0 ANSI: 2 CCS
> > [  275.560451] sd 2:0:1:0: Attached scsi generic sg1 type 0
> > [  275.632519] sd 2:0:1:0: [sdb] 479350 512-byte logical blocks: (245 MB/234 MiB)
> > [  275.635533] sd 2:0:1:0: [sdb] Write Protect is off
> > [  275.642315] sd 2:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> > [  469.076347] sd 2:0:1:0: [sdb] FAILED Result: hostbyte=DID_TIME_OUT driverbyte=DRIVER_SENSE
> > [  469.076613] sd 2:0:1:0: [sdb] Sense Key : Aborted Command [current]
> > [  469.076851] sd 2:0:1:0: [sdb] Add. Sense: No additional sense information
> > [  469.077086] sd 2:0:1:0: [sdb] CDB: Read(10) 28 00 00 00 00 02 00 00 02 00
> > [  469.077306] blk_update_request: I/O error, dev sdb, sector 2
> > [  469.077522] Buffer I/O error on dev sdb, logical block 1, async page read
> > [  480.108255] INFO: task kworker/u2:2:60 blocked for more than 120 seconds.
> > [  480.109773]       Not tainted 4.3.0-rc1+ #74
> > [  480.109973] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > [  480.110179] kworker/u2:2    D 00000040     0    60      2 0x00000000
> > [  480.110671] Workqueue: events_unbound async_run_entry_fn
> > [  480.110999]  cf9e8780 00000046 2eff25f7 00000040 c117f111 2ee82733 00000040 0016fec4
> > [  480.112390]  00000000 cfaa6000 00000000 7fffffff c139c7d2 c139c504 7fffffff c139d9d3
> > [  480.113661]  00000040 cfaa5cfc c106f460 00161108 00000000 0000c648 2106dcce 00000040
> > [  480.114893] Call Trace:
> > [  480.115124]  [<c117f111>] ? blk_queue_bio+0x1e8/0x1fb
> > [  480.115344]  [<c139c7d2>] ? bit_wait_io_timeout+0x3d/0x3d
> > [  480.115564]  [<c139c504>] ? schedule+0x5b/0x67
> > [  480.115794]  [<c139d9d3>] ? schedule_timeout+0x13/0xc5
> > [  480.116007]  [<c106f460>] ? timekeeping_get_ns+0x10/0x69
> > [  480.116406]  [<c139c7d2>] ? bit_wait_io_timeout+0x3d/0x3d
> > [  480.116636]  [<c106fae7>] ? ktime_get+0x38/0x48
> > [  480.116843]  [<c139bf83>] ? io_schedule_timeout+0x83/0xd7
> > [  480.117062]  [<c139c7f3>] ? bit_wait_io+0x21/0x26
> > [  480.117256]  [<c139c697>] ? __wait_on_bit+0x2f/0x5a
> > [  480.117486]  [<c10ff1eb>] ? blkdev_readpages+0x15/0x15
> > [  480.117704]  [<c10ad361>] ? wait_on_page_bit+0x57/0x5e
> > [  480.117942]  [<c1054a98>] ? wake_atomic_t_function+0x2a/0x2a
> > [  480.118151]  [<c10ad386>] ? wait_on_page_read+0xf/0x2a
> > [  480.118373]  [<c10ae0e1>] ? do_read_cache_page+0x8e/0x116
> > [  480.118587]  [<c10ff1eb>] ? blkdev_readpages+0x15/0x15
> > [  480.118809]  [<c10ae192>] ? read_cache_page+0x14/0x18
> > [  480.119008]  [<c1189b0e>] ? read_dev_sector+0x25/0x57
> > [  480.119222]  [<c118a8a8>] ? adfspart_check_ICS+0x30/0x1ac
> > [  480.119438]  [<c119a3f1>] ? vsnprintf+0x78/0x25d
> > [  480.119671]  [<c119a614>] ? snprintf+0x16/0x18
> > [  480.119874]  [<c118a7ea>] ? check_partition+0xd7/0x165
> > [  480.120253]  [<c118a067>] ? rescan_partitions+0x95/0x283
> > [  480.120443]  [<c1254b50>] ? scsi_block_when_processing_errors+0x13/0xae
> > [  480.120693]  [<c139cbc6>] ? mutex_lock+0x9/0x21
> > [  480.120915]  [<c1100046>] ? __blkdev_get+0x155/0x2f6
> > [  480.121133]  [<c110032f>] ? blkdev_get+0x148/0x258
> > [  480.121350]  [<c10ec747>] ? unlock_new_inode+0x36/0x3c
> > [  480.121570]  [<c10ff106>] ? bdget+0xdc/0xe6
> > [  480.121761]  [<c118854f>] ? add_disk+0x221/0x368
> > [  480.121996]  [<c126321a>] ? sd_probe_async+0xed/0x157
> > [  480.122214]  [<c10443a0>] ? async_run_entry_fn+0x2c/0xad
> > [  480.122437]  [<c103f060>] ? process_one_work+0x130/0x21f
> > [  480.122639]  [<c103f2f6>] ? worker_thread+0x18a/0x247
> > [  480.122854]  [<c103f16c>] ? process_scheduled_works+0x1d/0x1d
> > [  480.123069]  [<c1042c46>] ? kthread+0x7c/0x81
> > [  480.123288]  [<c139e201>] ? ret_from_kernel_thread+0x21/0x30
> > [  480.123493]  [<c1042bca>] ? kthread_parkme+0x11/0x11
> > [  480.123733] INFO: task modprobe:1977 blocked for more than 120 seconds.
> > [  480.123919]       Not tainted 4.3.0-rc1+ #74
> > [  480.124239] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > [  480.124410] modprobe        D 00000040     0  1977   1969 0x00000000
> > [  480.124864]  cfb20000 00000086 29042653 00000040 c1525f88 28a83a17 00000040 005bec3c
> > [  480.126123]  00000000 ccdd0000 ffffffff ffffffff d2057280 c139c504 00000000 c104416d
> > [  480.127354]  00000000 cfb20000 c1054a45 c151fd8c c151fd8c d2057280 00000000 ccd621f0
> > [  480.128746] Call Trace:
> > [  480.128961]  [<c139c504>] ? schedule+0x5b/0x67
> > [  480.129202]  [<c104416d>] ? async_synchronize_cookie_domain+0x73/0x9f
> > [  480.129449]  [<c1054a45>] ? abort_exclusive_wait+0x6e/0x6e
> > [  480.129667]  [<c10ac9bc>] ? do_init_module+0xa4/0x1a3
> > [  480.129899]  [<c107ddb5>] ? load_module+0x14de/0x18ca
> > [  480.130119]  [<c107e2a0>] ? SyS_finit_module+0x47/0x56
> > [  480.130346]  [<c139e2c0>] ? sysenter_do_call+0x12/0x12
> > [  502.100317] sd 2:0:1:0: [sdb] FAILED Result: hostbyte=DID_TIME_OUT driverbyte=DRIVER_SENSE
> > [  502.100578] sd 2:0:1:0: [sdb] Sense Key : Aborted Command [current]
> > [  502.100818] sd 2:0:1:0: [sdb] Add. Sense: No additional sense information
> > [  502.101057] sd 2:0:1:0: [sdb] CDB: Read(10) 28 00 00 00 00 04 00 00 02 00
> > [  502.101279] blk_update_request: I/O error, dev sdb, sector 4
> > [  502.101495] Buffer I/O error on dev sdb, logical block 2, async page read
> > [  600.128255] INFO: task kworker/u2:2:60 blocked for more than 120 seconds.
> > [  600.128486]       Not tainted 4.3.0-rc1+ #74
> > [  600.128687] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > [  600.128891] kworker/u2:2    D 00000040     0    60      2 0x00000000
> > [  600.129381] Workqueue: events_unbound async_run_entry_fn
> > [  600.129709]  cf9e8780 00000046 2eff25f7 00000040 c117f111 2ee82733 00000040 0016fec4
> > [  600.130941]  00000000 cfaa6000 00000000 7fffffff c139c7d2 c139c504 7fffffff c139d9d3
> > [  600.132342]  00000040 cfaa5cfc c106f460 00161108 00000000 0000c648 2106dcce 00000040
> > [  600.133613] Call Trace:
> > [  600.133821]  [<c117f111>] ? blk_queue_bio+0x1e8/0x1fb
> > [  600.134065]  [<c139c7d2>] ? bit_wait_io_timeout+0x3d/0x3d
> > [  600.134283]  [<c139c504>] ? schedule+0x5b/0x67
> > [  600.134509]  [<c139d9d3>] ? schedule_timeout+0x13/0xc5
> > [  600.134723]  [<c106f460>] ? timekeeping_get_ns+0x10/0x69
> > [  600.134948]  [<c139c7d2>] ? bit_wait_io_timeout+0x3d/0x3d
> > [  600.135154]  [<c106fae7>] ? ktime_get+0x38/0x48
> > [  600.135377]  [<c139bf83>] ? io_schedule_timeout+0x83/0xd7
> > [  600.135576]  [<c139c7f3>] ? bit_wait_io+0x21/0x26
> > [  600.135788]  [<c139c697>] ? __wait_on_bit+0x2f/0x5a
> > [  600.136000]  [<c10ff1eb>] ? blkdev_readpages+0x15/0x15
> > [  600.136399]  [<c10ad361>] ? wait_on_page_bit+0x57/0x5e
> > [  600.136607]  [<c1054a98>] ? wake_atomic_t_function+0x2a/0x2a
> > [  600.136838]  [<c10ad386>] ? wait_on_page_read+0xf/0x2a
> > [  600.137044]  [<c10ae0e1>] ? do_read_cache_page+0x8e/0x116
> > [  600.137276]  [<c10ff1eb>] ? blkdev_readpages+0x15/0x15
> > [  600.137481]  [<c10ae192>] ? read_cache_page+0x14/0x18
> > [  600.137699]  [<c1189b0e>] ? read_dev_sector+0x25/0x57
> > [  600.137901]  [<c118a8a8>] ? adfspart_check_ICS+0x30/0x1ac
> > [  600.138131]  [<c119a3f1>] ? vsnprintf+0x78/0x25d
> > [  600.138329]  [<c119a614>] ? snprintf+0x16/0x18
> > [  600.138544]  [<c118a7ea>] ? check_partition+0xd7/0x165
> > [  600.138738]  [<c118a067>] ? rescan_partitions+0x95/0x283
> > [  600.138962]  [<c1254b50>] ? scsi_block_when_processing_errors+0x13/0xae
> > [  600.139189]  [<c139cbc6>] ? mutex_lock+0x9/0x21
> > [  600.139427]  [<c1100046>] ? __blkdev_get+0x155/0x2f6
> > [  600.139632]  [<c110032f>] ? blkdev_get+0x148/0x258
> > [  600.139865]  [<c10ec747>] ? unlock_new_inode+0x36/0x3c
> > [  600.140263]  [<c10ff106>] ? bdget+0xdc/0xe6
> > [  600.140448]  [<c118854f>] ? add_disk+0x221/0x368
> > [  600.140689]  [<c126321a>] ? sd_probe_async+0xed/0x157
> > [  600.140908]  [<c10443a0>] ? async_run_entry_fn+0x2c/0xad
> > [  600.141133]  [<c103f060>] ? process_one_work+0x130/0x21f
> > [  600.141336]  [<c103f2f6>] ? worker_thread+0x18a/0x247
> > [  600.141552]  [<c103f16c>] ? process_scheduled_works+0x1d/0x1d
> > [  600.141764]  [<c1042c46>] ? kthread+0x7c/0x81
> > [  600.141982]  [<c139e201>] ? ret_from_kernel_thread+0x21/0x30
> > [  600.142186]  [<c1042bca>] ? kthread_parkme+0x11/0x11
> > [  600.142426] INFO: task modprobe:1977 blocked for more than 120 seconds.
> > [  600.142612]       Not tainted 4.3.0-rc1+ #74
> > [  600.142787] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > [  600.142991] modprobe        D 00000040     0  1977   1969 0x00000000
> > [  600.143444]  cfb20000 00000086 29042653 00000040 c1525f88 28a83a17 00000040 005bec3c
> > [  600.144819]  00000000 ccdd0000 ffffffff ffffffff d2057280 c139c504 00000000 c104416d
> > [  600.146052]  00000000 cfb20000 c1054a45 c151fd8c c151fd8c d2057280 00000000 ccd621f0
> > [  600.147279] Call Trace:
> > [  600.147489]  [<c139c504>] ? schedule+0x5b/0x67
> > [  600.147729]  [<c104416d>] ? async_synchronize_cookie_domain+0x73/0x9f
> > [  600.147992]  [<c1054a45>] ? abort_exclusive_wait+0x6e/0x6e
> > [  600.148390]  [<c10ac9bc>] ? do_init_module+0xa4/0x1a3
> > [  600.148627]  [<c107ddb5>] ? load_module+0x14de/0x18ca
> > [  600.148846]  [<c107e2a0>] ? SyS_finit_module+0x47/0x56
> > [  600.149073]  [<c139e2c0>] ? sysenter_do_call+0x12/0x12
> > [  662.100333] sd 2:0:1:0: [sdb] FAILED Result: hostbyte=DID_TIME_OUT driverbyte=DRIVER_SENSE
> > [  662.100598] sd 2:0:1:0: [sdb] Sense Key : Aborted Command [current]
> > [  662.100838] sd 2:0:1:0: [sdb] Add. Sense: No additional sense information
> > [  662.101076] sd 2:0:1:0: [sdb] CDB: Read(10) 28 00 00 00 00 06 00 00 02 00
> > [  662.101297] blk_update_request: I/O error, dev sdb, sector 6
> > [  662.101512] Buffer I/O error on dev sdb, logical block 3, async page read
> > [  720.148270] INFO: task modprobe:1977 blocked for more than 120 seconds.
> > [  720.148499]       Not tainted 4.3.0-rc1+ #74
> > [  720.148699] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > [  720.148903] modprobe        D 00000040     0  1977   1969 0x00000000
> > [  720.149360]  cfb20000 00000086 29042653 00000040 c1525f88 28a83a17 00000040 005bec3c
> > [  720.150615]  00000000 ccdd0000 ffffffff ffffffff d2057280 c139c504 00000000 c104416d
> > [  720.151836]  00000000 cfb20000 c1054a45 c151fd8c c151fd8c d2057280 00000000 ccd621f0
> > [  720.153221] Call Trace:
> > [  720.153465]  [<c139c504>] ? schedule+0x5b/0x67
> > [  720.153689]  [<c104416d>] ? async_synchronize_cookie_domain+0x73/0x9f
> > [  720.153931]  [<c1054a45>] ? abort_exclusive_wait+0x6e/0x6e
> > [  720.154149]  [<c10ac9bc>] ? do_init_module+0xa4/0x1a3
> > [  720.154379]  [<c107ddb5>] ? load_module+0x14de/0x18ca
> > [  720.154593]  [<c107e2a0>] ? SyS_finit_module+0x47/0x56
> > [  720.154820]  [<c139e2c0>] ? sysenter_do_call+0x12/0x12
> > [  781.025039] systemd-logind[1942]: New session c2 of user rainbow.
> > [  840.152254] INFO: task kworker/u2:2:60 blocked for more than 120 seconds.
> > [  840.152486]       Not tainted 4.3.0-rc1+ #74
> > [  840.152693] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > [  840.152903] kworker/u2:2    D 0000009a     0    60      2 0x00000000
> > [  840.153399] Workqueue: events_unbound async_run_entry_fn
> > [  840.153730]  cf9e8780 00000046 2860b1ff 0000009a c117f111 284404dd 0000009a 001cad22
> > [  840.156408]  00000000 cfaa6000 00000000 7fffffff c139c7d2 c139c504 7fffffff c139d9d3
> > [  840.157689]  0000009a cfaa5c64 c106f460 00161e18 00000000 00013d94 006b70ce 0000009a
> > [  840.158925] Call Trace:
> > [  840.159158]  [<c117f111>] ? blk_queue_bio+0x1e8/0x1fb
> > [  840.159379]  [<c139c7d2>] ? bit_wait_io_timeout+0x3d/0x3d
> > [  840.159600]  [<c139c504>] ? schedule+0x5b/0x67
> > [  840.159834]  [<c139d9d3>] ? schedule_timeout+0x13/0xc5
> > [  840.160052]  [<c106f460>] ? timekeeping_get_ns+0x10/0x69
> > [  840.160446]  [<c139c7d2>] ? bit_wait_io_timeout+0x3d/0x3d
> > [  840.160677]  [<c106fae7>] ? ktime_get+0x38/0x48
> > [  840.160884]  [<c139bf83>] ? io_schedule_timeout+0x83/0xd7
> > [  840.161105]  [<c139c7f3>] ? bit_wait_io+0x21/0x26
> > [  840.161306]  [<c139c697>] ? __wait_on_bit+0x2f/0x5a
> > [  840.161541]  [<c10ad361>] ? wait_on_page_bit+0x57/0x5e
> > [  840.161767]  [<c1054a98>] ? wake_atomic_t_function+0x2a/0x2a
> > [  840.161997]  [<c10ad386>] ? wait_on_page_read+0xf/0x2a
> > [  840.162206]  [<c10ae14f>] ? do_read_cache_page+0xfc/0x116
> > [  840.162445]  [<c10ff1eb>] ? blkdev_readpages+0x15/0x15
> > [  840.162651]  [<c10ae192>] ? read_cache_page+0x14/0x18
> > [  840.162872]  [<c1189b0e>] ? read_dev_sector+0x25/0x57
> > [  840.163073]  [<c118e22f>] ? read_lba+0x94/0x10b
> > [  840.163289]  [<c118e7eb>] ? efi_partition+0xbc/0x451
> > [  840.163506]  [<c10b5c33>] ? put_page+0x16/0x24
> > [  840.163732]  [<c10ad39d>] ? wait_on_page_read+0x26/0x2a
> > [  840.163968]  [<c10ff1eb>] ? blkdev_readpages+0x15/0x15
> > [  840.164348]  [<c10ae192>] ? read_cache_page+0x14/0x18
> > [  840.164541]  [<c118a8a8>] ? adfspart_check_ICS+0x30/0x1ac
> > [  840.164777]  [<c119a3f1>] ? vsnprintf+0x78/0x25d
> > [  840.164977]  [<c119a614>] ? snprintf+0x16/0x18
> > [  840.165187]  [<c118a7ea>] ? check_partition+0xd7/0x165
> > [  840.165382]  [<c118a067>] ? rescan_partitions+0x95/0x283
> > [  840.165603]  [<c1254b50>] ? scsi_block_when_processing_errors+0x13/0xae
> > [  840.165829]  [<c139cbc6>] ? mutex_lock+0x9/0x21
> > [  840.166066]  [<c1100046>] ? __blkdev_get+0x155/0x2f6
> > [  840.166270]  [<c110032f>] ? blkdev_get+0x148/0x258
> > [  840.166501]  [<c10ec747>] ? unlock_new_inode+0x36/0x3c
> > [  840.166707]  [<c10ff106>] ? bdget+0xdc/0xe6
> > [  840.166914]  [<c118854f>] ? add_disk+0x221/0x368
> > [  840.167134]  [<c126321a>] ? sd_probe_async+0xed/0x157
> > [  840.167372]  [<c10443a0>] ? async_run_entry_fn+0x2c/0xad
> > [  840.167582]  [<c103f060>] ? process_one_work+0x130/0x21f
> > [  840.167802]  [<c103f2f6>] ? worker_thread+0x18a/0x247
> > [  840.168006]  [<c103f16c>] ? process_scheduled_works+0x1d/0x1d
> > [  840.168416]  [<c1042c46>] ? kthread+0x7c/0x81
> > [  840.168642]  [<c139e201>] ? ret_from_kernel_thread+0x21/0x30
> > [  840.168847]  [<c1042bca>] ? kthread_parkme+0x11/0x11
> > [  840.169094] INFO: task modprobe:1977 blocked for more than 120 seconds.
> > [  840.169281]       Not tainted 4.3.0-rc1+ #74
> > [  840.169454] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > [  840.169659] modprobe        D 00000040     0  1977   1969 0x00000000
> > [  840.170114]  cfb20000 00000086 29042653 00000040 c1525f88 28a83a17 00000040 005bec3c
> > [  840.171368]  00000000 ccdd0000 ffffffff ffffffff d2057280 c139c504 00000000 c104416d
> > [  840.172741]  00000000 cfb20000 c1054a45 c151fd8c c151fd8c d2057280 00000000 ccd621f0
> > [  840.173986] Call Trace:
> > [  840.174200]  [<c139c504>] ? schedule+0x5b/0x67
> > [  840.174443]  [<c104416d>] ? async_synchronize_cookie_domain+0x73/0x9f
> > [  840.174689]  [<c1054a45>] ? abort_exclusive_wait+0x6e/0x6e
> > [  840.174910]  [<c10ac9bc>] ? do_init_module+0xa4/0x1a3
> > [  840.175141]  [<c107ddb5>] ? load_module+0x14de/0x18ca
> > [  840.175359]  [<c107e2a0>] ? SyS_finit_module+0x47/0x56
> > [  840.175607]  [<c139e2c0>] ? sysenter_do_call+0x12/0x12
> > [  856.020359] sd 2:0:1:0: [sdb] FAILED Result: hostbyte=DID_TIME_OUT driverbyte=DRIVER_SENSE
> > [  856.020623] sd 2:0:1:0: [sdb] Sense Key : Aborted Command [current]
> > [  856.020862] sd 2:0:1:0: [sdb] Add. Sense: No additional sense information
> > [  856.021101] sd 2:0:1:0: [sdb] CDB: Read(10) 28 00 00 00 00 02 00 00 02 00
> > [  856.021324] blk_update_request: I/O error, dev sdb, sector 2
> > [  856.021539] Buffer I/O error on dev sdb, logical block 1, async page read
> > [  857.025325] sd 2:0:1:0: [sdb] FAILED Result: hostbyte=DID_ABORT driverbyte=DRIVER_OK
> > [  857.025596] sd 2:0:1:0: [sdb] CDB: Read(10) 28 00 00 00 00 04 00 00 02 00
> > [  857.025830] blk_update_request: I/O error, dev sdb, sector 4
> > [  857.026043] Buffer I/O error on dev sdb, logical block 2, async page read
> >                              
> >                              
> > And a CD-ROM, first without patches:
> > [  655.929795] pnp 01:01.00: activated
> > [  655.939503] scsi host2: Generic NCR5380/NCR53C400 SCSI, io_port 0x240, n_io_port 16, base 0x0, irq 0, can_queue 16, cmd_per_lun 2, sg_tablesize 128, this_id 7, flags { DTC3181E NO_PSEUDO_DMA }, USLEEP_POLL 3, USLEEP_WAITLONG 1250, options { AUTOPROBE_IRQ PSEUDO_DMA NCR53C400 }
> > [  656.441943] scsi 2:0:2:0: CD-ROM            SONY     CD-ROM CDU-55S   1.0t PQ: 0 ANSI: 2
> > [  657.829087] scsi 2:0:2:0: Attached scsi generic sg1 type 5
> > [  658.325517] sr 2:0:2:0: [sr0] scsi-1 drive
> > [  658.325731] cdrom: Uniform CD-ROM driver Revision: 3.20
> > 
> > Modprobe succeeded but mount resulted in this & hang:
> > [  694.056266] sr 2:0:2:0: [sr0] aborting command
> > 
> > Then with patches:
> > 
> > [  109.753273] pnp 01:01.00: activated
> > [  109.763039] scsi host2: Generic NCR5380/NCR53C400 SCSI, io_port 0x240, n_io_port 16, base 0x0, irq 0, can_queue 16, cmd_per_lun 2, sg_tablesize 128, this_id 7, flags { DTC3181E NO_PSEUDO_DMA }, options { AUTOPROBE_IRQ PSEUDO_DMA }
> > [  115.456294] scsi 2:0:2:0: CD-ROM            SONY     CD-ROM CDU-55S   1.0t PQ: 0 ANSI: 2
> > [  126.823400] scsi 2:0:2:0: Attached scsi generic sg1 type 5
> > [  126.909680] sr 2:0:2:0: [sr0] scsi-1 drive
> > [  126.909888] cdrom: Uniform CD-ROM driver Revision: 3.20
> > 
> > Modprobe succeeded but mount failed after some time with this:
> > [ 1005.149546] sr 2:0:2:0: [sr0] FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> > [ 1005.149764] sr 2:0:2:0: [sr0] Sense Key : Illegal Request [current]
> > [ 1005.149992] sr 2:0:2:0: [sr0] Add. Sense: Logical block address out of range
> > [ 1005.150222] sr 2:0:2:0: [sr0] CDB: Read(10) 28 00 00 05 7a 94 00 00 02 00
> > [ 1005.150433] blk_update_request: critical target error, dev sr0, sector 1436240
> > [ 1005.154101] sr 2:0:2:0: [sr0] FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> > [ 1005.154309] sr 2:0:2:0: [sr0] Sense Key : Illegal Request [current]
> > [ 1005.154533] sr 2:0:2:0: [sr0] Add. Sense: Logical block address out of range
> > [ 1005.156209] sr 2:0:2:0: [sr0] CDB: Read(10) 28 00 00 05 7a 94 00 00 02 00
> > [ 1005.156404] blk_update_request: critical target error, dev sr0, sector 1436240
> > [ 1005.156607] Buffer I/O error on dev sr0, logical block 179530, async page read
> > 
> > mount: unknown filesystem type 'iso9660'
> > 
> > 
> 
> Thanks for these test results! It looks like READ(10) commands don't work. 
> I don't know the cause of the failures but it appears to be an old bug. 
> Did you find any regression?
> 
> I gather that your setup here is a QUANTUM LP240S target with Domex 3181 
> (DTC-436) card and g_NCR5380 module. I've been testing a similar setup: 
> QUANTUM LPS540S target with a Domex 3191D (DTC-536) card and dmx3191d 
> module. In both setups PIO is used exclusively, no IRQ is used, and 
> FLAG_DTC3181E is set. I didn't see any issues in my tests, so your results 
> are surprising.

I agree that the results are surprising. Even tried 2.4 kernels (Debian 3.1)
and even 2.2 (Debian 3.0) and nothing worked.
HW is fine - the drive is accessible in Windows 98 (with Domex driver
installed).

Now testing the Canon FG2-5202 controller - a simple 8-bit ISA card with only
two chips: NCR 53C400 and 74LS245. It's memory mapped, IRQ hardwired to 7.

# modprobe g_NCR5380_mmio ncr_irq=255 ncr_addr=0xd8000 ncr_53c400=1

[ 1245.919223] scsi2 : interrupts not enabled. for better interactive performance,
[ 1245.919326] scsi2 : please jumper the board for a free IRQ.
[ 1245.919389] scsi host2: Generic NCR5380/NCR53C400 SCSI, io_port 0x0, n_io_port 0, base 0xd8000, irq 0, can_queue 16, cmd_per_lun 2, sg_tablesize 128, this_id 7, flags { NCR53C400 }, USLEEP_POLL 3, USLEEP_WAITLONG 1250, options { AUTOPROBE_IRQ PSEUDO_DMA NCR53C400 }
[ 1246.376738] scsi 2:0:1:0: Direct-Access     QUANTUM  LP240S GM240S01X 4.6  PQ: 0 ANSI: 2 CCS
[ 1248.202198] sd 2:0:1:0: Attached scsi generic sg1 type 0
[ 1248.420856] 53C400r: no 53C80 gated irq after transfer
[ 1248.420948] 53C400r: no end dma signal
[ 1248.422459] sd 2:0:1:0: [sdb] Sector size 0 reported, assuming 512.

Seems that the PSEUDO_DMA is broken. After adding FLAG_NO_PSEUDO_DMA:

# modprobe g_NCR5380_mmio ncr_irq=255 ncr_addr=0xd8000 ncr_53c400=1

[   67.974362] scsi2 : interrupts not enabled. for better interactive performance,
[   67.974463] scsi2 : please jumper the board for a free IRQ.
[   67.974526] scsi host2: Generic NCR5380/NCR53C400 SCSI, io_port 0x0, n_io_port 0, base 0xd8000, irq 0, can_queue 16, cmd_per_lun 2, sg_tablesize 128, this_id 7, flags { NCR53C400 NO_PSEUDO_DMA }, USLEEP_POLL 3, USLEEP_WAITLONG 1250, options { AUTOPROBE_IRQ PSEUDO_DMA NCR53C400 }
[   68.432728] scsi 2:0:1:0: Direct-Access     QUANTUM  LP240S GM240S01X 4.6  PQ: 0 ANSI: 2 CCS
[   70.258258] sd 2:0:1:0: Attached scsi generic sg1 type 0
[   70.277265] sd 2:0:1:0: [sdb] 479350 512-byte logical blocks: (245 MB/234 MiB)
[   70.482252] sd 2:0:1:0: [sdb] Write Protect is off
[   70.482335] sd 2:0:1:0: [sdb] Mode Sense: 8b 00 00 08
[   70.889646] sd 2:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   73.159513]  sdb: sdb1
[   74.617099] sd 2:0:1:0: [sdb] Attached SCSI disk

Yeah, first success! I can even mount the filesystem, although it takes ages
(a minute) and these messages:
[  160.872074] sd 2:0:1:0: [sdb] aborting command
[  161.816083] sd 2:0:1:0: [sdb] aborting command

# hdparm -t --direct /dev/sdb

/dev/sdb:
[  244.840075] sd 2:0:1:0: [sdb] aborting command
[  248.824078] sd 2:0:1:0: [sdb] aborting command
[  293.864069] sd 2:0:1:0: [sdb] aborting command
[  297.824075] sd 2:0:1:0: [sdb] aborting command
[  319.765020] blk_update_request: critical target error, dev sdb, sector 0
[  319.972994] blk_update_request: critical target error, dev sdb, sector 0
 Timing O_DIRECT disk reads:   2 MB in 105.26 seconds =  19.46 kB/sec



With your patches (and adding FLAG_NO_PSEUDO_DMA), modprobe is slower but
mount faster (4 seconds) and then works better:

# modprobe g_NCR5380_mmio ncr_irq=255 ncr_addr=0xd8000 ncr_53c400=1

[  130.126185] scsi2 : interrupts not enabled. for better interactive performance,
[  130.126284] scsi2 : please jumper the board for a free IRQ.
[  130.126347] scsi host2: Generic NCR5380/NCR53C400 SCSI, io_port 0x0, n_io_port 0, base 0xd8000, irq 0, can_queue 16, cmd_per_lun 2, sg_tablesize 128, this_id 7, flags { NO_PSEUDO_DMA }, options { AUTOPROBE_IRQ PSEUDO_DMA }
[  145.221755] scsi 2:0:1:0: Direct-Access     QUANTUM  LP240S GM240S01X 4.6  PQ: 0 ANSI: 2 CCS
[  220.629912] sd 2:0:1:0: Attached scsi generic sg1 type 0
[  220.651400] sd 2:0:1:0: [sdb] 479350 512-byte logical blocks: (245 MB/234 MiB)
[  220.654061] sd 2:0:1:0: [sdb] Write Protect is off
[  220.659344] sd 2:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  220.732415]  sdb: sdb1
[  220.749760] sd 2:0:1:0: [sdb] Attached SCSI disk

# hdparm -t --direct /dev/sdb

/dev/sdb:
 Timing O_DIRECT disk reads:   2 MB in 18.25 seconds = 112.20 kB/sec



IRQ seems to work too, although driver always shows "irq 0":

# modprobe g_NCR5380_mmio ncr_irq=7 ncr_addr=0xd8000 ncr_53c400=1

[  117.263062] scsi host2: Generic NCR5380/NCR53C400 SCSI, io_port 0x0, n_io_port 0, base 0xd8000, irq 0, can_queue 16, cmd_per_lun 2, sg_tablesize 128, this_id 7, flags { NO_PSEUDO_DMA }, options { AUTOPROBE_IRQ PSEUDO_DMA }
[  132.357474] scsi 2:0:1:0: Direct-Access     QUANTUM  LP240S GM240S01X 4.6  PQ: 0 ANSI: 2 CCS
[  207.765080] sd 2:0:1:0: Attached scsi generic sg1 type 0
[  207.783415] sd 2:0:1:0: [sdb] 479350 512-byte logical blocks: (245 MB/234 MiB)
[  207.786167] sd 2:0:1:0: [sdb] Write Protect is off
[  207.790260] sd 2:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  207.859669]  sdb: sdb1
[  207.876556] sd 2:0:1:0: [sdb] Attached SCSI disk

# hdparm -t --direct /dev/sdb

/dev/sdb:
 Timing O_DIRECT disk reads:   2 MB in 18.30 seconds = 111.94 kB/sec

# mount /dev/sdb1 /mnt
# umount /mnt
# head /proc/interrupts
           CPU0
  0:      44793    XT-PIC  timer
  1:          9    XT-PIC  i8042
  2:          0    XT-PIC  cascade
  7:         86    XT-PIC  NCR5380
  8:          1    XT-PIC  rtc0
  9:          0    XT-PIC  uhci_hcd:usb1, uhci_hcd:usb2
 10:       1179    XT-PIC  eth0
 12:        136    XT-PIC  i8042
 14:       3411    XT-PIC  pata_via

-- 
Ondrej Zary
