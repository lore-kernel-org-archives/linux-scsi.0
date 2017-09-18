From: Meelis Roos <mroos@linux.ee>
Subject: Re: Another UBSAN warning from aic7xxx
Date: Mon, 18 Sep 2017 22:23:07 +0300 (EEST)
Message-ID: <alpine.LRH.2.21.1709182218590.15407@math.ut.ee>
References: <alpine.LRH.2.20.1605171856430.9286@math.ut.ee> <alpine.LRH.2.21.1709181553400.628@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.21.1709181553400.628@math.ut.ee>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, Linux Kernel list <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

> Fixing this reveals another UBSAN warning from the same driver, will fix 
> that too.

This is the warning - devinfo->target_offset is unsigned but 
ahc_reset_channel() calls it with signed -1 for the parameter.

The patch below silences it but is it a good way? 

[    0.394215] ================================================================================
[    0.394405] UBSAN: Undefined behaviour in drivers/scsi/aic7xxx/aic7xxx_core.c:2833:32
[    0.394593] shift exponent -1 is negative
[    0.394712] CPU: 0 PID: 1 Comm: swapper Not tainted 4.14.0-rc1-00009-g0666f560b71b-dirty #80
[    0.394900] Hardware name: IBM -[867313X]-/-[M51SL]-, BIOS -[PLE168AUS-1.68]- 06/25/04
[    0.395086] Call Trace:
[    0.395214]  dump_stack+0x16/0x18
[    0.395335]  ubsan_epilogue+0xe/0x2f
[    0.395455]  __ubsan_handle_shift_out_of_bounds+0xef/0x131
[    0.395577]  ? vprintk_emit+0x251/0x39c
[    0.395694]  ? vprintk_default+0x32/0x34
[    0.395815]  ahc_compile_devinfo+0x92/0xb8
[    0.395933]  ahc_reset_channel+0x5a/0x2c3
[    0.396005]  ? __alloc_workqueue_key+0x222/0x537
[    0.396005]  ahc_linux_initialize_scsi_bus+0x44/0x298
[    0.396005]  ? vsnprintf+0x3a0/0x629
[    0.396005]  ahc_linux_register_host+0x1a3/0x2b3
[    0.396005]  ahc_linux_pci_dev_probe+0x179/0x36e
[    0.396005]  ? kernfs_add_one+0x10c/0x1d5
[    0.396005]  pci_device_probe+0xaa/0x163
[    0.396005]  driver_probe_device+0x1c9/0x34c
[    0.396005]  __driver_attach+0x87/0xba
[    0.396005]  ? driver_probe_device+0x34c/0x34c
[    0.396005]  bus_for_each_dev+0x48/0x89
[    0.396005]  driver_attach+0x1d/0x33
[    0.396005]  ? driver_probe_device+0x34c/0x34c
[    0.396005]  bus_add_driver+0x184/0x275
[    0.396005]  driver_register+0x66/0x115
[    0.396005]  __pci_register_driver+0x44/0x6e
[    0.396005]  ahc_linux_pci_init+0x14/0x16
[    0.396005]  ahc_linux_init+0x87/0x95
[    0.396005]  ? spi_transport_init+0x1a4/0x1a4
[    0.396005]  do_one_initcall+0x4f/0x1da
[    0.396005]  ? next_arg+0xee/0x1e2
[    0.396005]  ? parameq+0x12/0xab
[    0.396005]  ? parse_args+0x177/0x390
[    0.396005]  kernel_init_freeable+0x1c4/0x247
[    0.396005]  ? rest_init+0x70/0x70
[    0.396005]  kernel_init+0xc/0x107
[    0.396005]  ? schedule_tail_wrapper+0x9/0xc
[    0.396005]  ? rest_init+0x70/0x70
[    0.396005]  ret_from_fork+0x19/0x24
[    0.396005] ================================================================================


diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index 381846164003..7c692336c18d 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -2828,7 +2828,11 @@ ahc_compile_devinfo(struct ahc_devinfo *devinfo, u_int our_id, u_int target,
 	devinfo->role = role;
 	if (channel == 'B')
 		devinfo->target_offset += 8;
-	devinfo->target_mask = (0x01 << devinfo->target_offset);
+	if (target < AHC_NUM_TARGETS + 8) {
+		devinfo->target_mask = (0x01 << devinfo->target_offset);
+	} else {
+		devinfo->target_mask = 0;
+	}
 }
 
 void

-- 
Meelis Roos (mroos@linux.ee)
