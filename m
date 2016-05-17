From: Meelis Roos <mroos@linux.ee>
Subject: Another UBSAN warning from aic7xxx
Date: Tue, 17 May 2016 18:59:54 +0300 (EEST)
Message-ID: <alpine.LRH.2.20.1605171856430.9286@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, Linux Kernel list <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Despite the first one being a false positive, her I am reporting another 
one, from a older dual P2 server with Adaptec aic7896/97 Ultra2 SCSI 
adapter and QUANTUM  VIKING II 4.5WSE HDD-s.

[    1.730498] ================================================================================
[    1.730693] UBSAN: Undefined behaviour in drivers/scsi/aic7xxx/aic7xxx_core.c:5325:31
[    1.730872] shift exponent -1 is negative
[    1.730993] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 4.6.0 #14
[    1.731110] Hardware name: To be Filled To be Filled/Intel 440BX/GX, BIOS 063101 07/15/99
[    1.731287]  00000000 c135ccec 00000046 f6461c50 00000001 c13974db f6461c44 ffffffff
[    1.731757]  c1397a66 c1775bd0 f6461c54 c10f28c1 f7269638 00000202 0000312d f72695f8
[    1.732026]  00000004 f7269618 00000058 f7269638 00000056 00ff473c 80000500 00000000
[    1.732026] Call Trace:
[    1.732026]  [<c135ccec>] ? dump_stack+0x45/0x69
[    1.732026]  [<c13974db>] ? ubsan_epilogue+0xb/0x40
[    1.732026]  [<c1397a66>] ? __ubsan_handle_shift_out_of_bounds+0xd6/0x120
[    1.732026]  [<c10f28c1>] ? hrtimer_interrupt+0x101/0x390
[    1.732026]  [<c1540031>] ? scrdown+0x30/0x1bb
[    1.732026]  [<c15422b0>] ? pci_conf1_read+0x90/0x150
[    1.732026]  [<c148ef5b>] ? ahc_init+0xb2b/0xd90
[    1.732026]  [<c1545c27>] ? pci_read+0x37/0x70
[    1.732026]  [<c1398948>] ? pci_bus_read_config_byte+0x68/0xb0
[    1.732026]  [<c14a0c30>] ? ahc_pci_read_config+0x40/0xd0
[    1.732026]  [<c14998e4>] ? ahc_pci_config+0x4a4/0x10f0
[    1.732026]  [<c1540000>] ? rgb_foreground+0xdc/0xdd
[    1.732026]  [<c14a09bd>] ? ahc_linux_pci_dev_probe+0xed/0x320
[    1.732026]  [<c124c617>] ? kernfs_add_one+0x147/0x1b0
[    1.732026]  [<c124c2b6>] ? kernfs_new_node+0x36/0x80
[    1.732026]  [<c145448c>] ? __pm_runtime_resume+0x3c/0x60
[    1.732026]  [<c13a93d1>] ? pci_device_probe+0x91/0x130
[    1.732026]  [<c1446068>] ? driver_probe_device+0xc8/0x330
[    1.732026]  [<c14462d0>] ? driver_probe_device+0x330/0x330
[    1.732026]  [<c14462d0>] ? driver_probe_device+0x330/0x330
[    1.732026]  [<c1446369>] ? __driver_attach+0x99/0xd0
[    1.732026]  [<c1443c5c>] ? bus_for_each_dev+0x4c/0x90
[    1.732026]  [<c144582a>] ? driver_attach+0x1a/0x40
[    1.732026]  [<c14462d0>] ? driver_probe_device+0x330/0x330
[    1.732026]  [<c1445227>] ? bus_add_driver+0x127/0x290
[    1.732026]  [<c1b1d245>] ? spi_transport_init+0x1aa/0x1aa
[    1.732026]  [<c1446d87>] ? driver_register+0x67/0x120
[    1.732026]  [<c1b1d2c7>] ? ahc_linux_init+0x82/0x8f
[    1.732026]  [<c100041a>] ? do_one_initcall+0x8a/0x260
[    1.732026]  [<c1b1d245>] ? spi_transport_init+0x1aa/0x1aa
[    1.732026]  [<c109543f>] ? parameq+0xf/0xb0
[    1.732026]  [<c10956e5>] ? parse_args+0x205/0x510
[    1.732026]  [<c1aebe6f>] ? kernel_init_freeable+0x153/0x25c
[    1.732026]  [<c1aebeec>] ? kernel_init_freeable+0x1d0/0x25c
[    1.732026]  [<c16af8b9>] ? kernel_init+0x9/0x120
[    1.732026]  [<c10a225b>] ? schedule_tail+0xb/0xa0
[    1.732026]  [<c16b8889>] ? ret_from_kernel_thread+0x21/0x38
[    1.732026]  [<c16af8b0>] ? rest_init+0x60/0x60
[    1.732026] ================================================================================

-- 
Meelis Roos (mroos@linux.ee)
