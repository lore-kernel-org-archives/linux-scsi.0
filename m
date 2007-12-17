From: Bernd Schubert <bs@q-leap.de>
Subject: [PATCH 0/1] limit recovery retries
Date: Mon, 17 Dec 2007 14:10:27 +0100
Message-ID: <200712171410.28139.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.q-leap.de ([153.94.51.193]:56841 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754377AbXLQNKa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Dec 2007 08:10:30 -0500
Received: from lanczos (lanczos [192.168.55.86])
	by mail.q-leap.de (Postfix) with ESMTP id 8A2F9642D
	for <linux-scsi@vger.kernel.org>; Mon, 17 Dec 2007 14:10:28 +0100 (CET)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

the next mail has a patch to offline a device when eh is activated 
again and again.

Presently I have a system stopping to boot because one of the scsi-devices 
is in something like a zombie state. 
Without the patch, the eh is called in an endless loop, with the patch, 
it now deactivates the device, but still doesn't proceed to boot. Probably 
since the last scsi command never returns?


[  216.469912] Sending BRST chan: 0
[  216.473241] sd 4:0:2:0: trying bus reset
[  216.477283] mptscsih: ioc2: attempting bus reset! (sc=ffff810127db1500)
[  216.484041] sd 4:0:2:0: [sdg] CDB: Read(10): 28 00 00 00 00 00 00 00 08 00
[  216.865628] mptscsih: ioc2: bus reset: SUCCESS (sc=ffff810127db1500)
[  256.835540] sd 4:0:2:0: Activating scsi error recovery
[  256.840812] Starting device recovery 2
[  256.844676] sd 4:0:2:0: trying to abort command
[  256.849337] mptscsih: ioc2: attempting task abort! (sc=ffff810127db1500)
[  256.856195] sd 4:0:2:0: [sdg] CDB: Read(10): 28 00 00 00 00 00 00 00 08 00
[  259.029233] mptbase: Initiating ioc2 recovery
[  272.175398] mptscsih: ioc2: Issue of TaskMgmt failed!
[  272.180587] mptscsih: ioc2: task abort: FAILED (sc=ffff810127db1500)
[  272.187093] sd 4:0:2:0: Sending BDR 0xffff810129d9b960
[  272.192351] sd 4:0:2:0: trying device reset
[  272.196757] mptscsih: ioc2: attempting target reset! (sc=ffff810127db1500)
[  272.203790] sd 4:0:2:0: [sdg] CDB: Read(10): 28 00 00 00 00 00 00 00 08 00
[  274.377074] mptbase: Initiating ioc2 recovery
[  287.523243] mptscsih: ioc2: Issue of TaskMgmt failed!
[  287.528430] mptscsih: ioc2: target reset: FAILED (sc=ffff810127db1500)
[  287.535103] Sending BRST chan: 0
[  287.538438] sd 4:0:2:0: trying bus reset
[  287.542473] mptscsih: ioc2: attempting bus reset! (sc=ffff810127db1500)
[  287.549239] sd 4:0:2:0: [sdg] CDB: Read(10): 28 00 00 00 00 00 00 00 08 00
[  287.930806] mptscsih: ioc2: bus reset: SUCCESS (sc=ffff810127db1500)
                                                                         [ OK ]
 * Setting the system clock
 * Loading kernel modules...                                                    [  291.296696] ACPI: Processor [CPU0] (supports 8 throttling states)
[  291.303304] ACPI: Processor [CPU1] (supports 8 throttling states)
[  291.309852] ACPI: Processor [CPU2] (supports 8 throttling states)
[  291.316407] ACPI: Processor [CPU3] (supports 8 throttling states)
[  291.322969] ACPI: Processor [CPU4] (supports 8 throttling states)
[  291.329522] ACPI: Processor [CPU5] (supports 8 throttling states)
[  291.336086] ACPI: Processor [CPU6] (supports 8 throttling states)
[  291.342644] ACPI: Processor [CPU7] (supports 8 throttling states)
[  327.896734] sd 4:0:2:0: Activating scsi error recovery
[  327.902005] Too many errors for this scsi host, deactivating its devices
[  327.908859] sd 4:0:2:0: scsi: Device offlined - not ready after error recovery
[generate break]
[ 2349.520917] SysRq : Show Blocked State
[ 2349.524763]
[ 2349.524764]                                  free                        sibling
[ 2349.533816]   task                 PC        stack   pid father child younger older
[ 2349.541612] modprobe      D 0000001bdcb18803     0  2331      1 (NOTLB)
[ 2349.548396]  ffff810127015218 0000000000000086 0000000000000000 ffff810128c70000
[ 2349.555997]  0000000000000000 ffff81012b5f8810 ffff810127d04100 00000005880e7bf8
[ 2349.563606]  00000000fffeff19 0000000000000000 ffff810001053400 0000000500000000
[ 2349.570994] Call Trace:
[ 2349.573720]  [<ffffffff804f070b>] io_schedule+0x28/0x36
[ 2349.579040]  [<ffffffff80263565>] sync_page+0x4c/0x58
[ 2349.584181]  [<ffffffff804f09f5>] __wait_on_bit_lock+0x3c/0x6b
[ 2349.590112]  [<ffffffff80263e9d>] __lock_page+0xa7/0xad
[ 2349.595427]  [<ffffffff8026522d>] read_cache_page_async+0x114/0x17c
[ 2349.601792]  [<ffffffff8026529b>] read_cache_page+0x6/0x3e
[ 2349.607358]  [<ffffffff802d3d33>] read_dev_sector+0x2d/0x86
[ 2349.613020]  [<ffffffff802d4688>] read_lba+0x76/0xd1
[ 2349.618074]  [<ffffffff802d477f>] is_gpt_valid+0x9c/0x244
[ 2349.623572]  [<ffffffff802d4a69>] efi_partition+0x142/0x709
[ 2349.629252]  [<ffffffff802d3bdc>] rescan_partitions+0x161/0x28b
[ 2349.635279]  [<ffffffff802b49c6>] do_open+0x10e/0x2e1
[ 2349.640420]  [<ffffffff802b4c35>] __blkdev_get+0x9c/0xd4
[ 2349.645823]  [<ffffffff802b4c7b>] blkdev_get+0xe/0x13
[ 2349.650955]  [<ffffffff802d39ff>] register_disk+0x1cb/0x247
[ 2349.656628]  [<ffffffff80371de8>] add_disk+0x37/0x41
[ 2349.661684]  [<ffffffff8043e4dd>] sd_probe+0x35c/0x442
[ 2349.666905]  [<ffffffff803dab38>] driver_probe_device+0xfa/0x18d
[ 2349.673010]  [<ffffffff803dabd4>] __device_attach+0x9/0xe
[ 2349.678505]  [<ffffffff803d9d03>] bus_for_each_drv+0x46/0x82
[ 2349.684271]  [<ffffffff803dac4f>] device_attach+0x76/0x9a
[ 2349.689751]  [<ffffffff803da083>] bus_attach_device+0x3c/0xa1
[ 2349.695588]  [<ffffffff803d8183>] device_add+0x408/0x643
[ 2349.700990]  [<ffffffff80435660>] scsi_sysfs_add_sdev+0x40/0x2bf
[ 2349.707095]  [<ffffffff8043354a>] scsi_probe_and_add_lun+0x946/0xa96
[ 2349.713553]  [<ffffffff80433996>] __scsi_scan_target+0xcc/0x746
[ 2349.719578]  [<ffffffff80434133>] scsi_scan_channel+0x67/0x9c
[ 2349.725421]  [<ffffffff8043424b>] scsi_scan_host_selected+0xe3/0x12e
[ 2349.731872]  [<ffffffff80434309>] do_scsi_scan_host+0x73/0x7a
[ 2349.737715]  [<ffffffff804345ed>] scsi_scan_host+0x15e/0x1aa
[ 2349.743467]  [<ffffffff880e8c2e>] :mptspi:mptspi_probe+0x36c/0x39e
[ 2349.749756]  [<ffffffff8038798c>] pci_device_probe+0x10a/0x18e
[ 2349.755690]  [<ffffffff803dab18>] driver_probe_device+0xda/0x18d
[ 2349.761801]  [<ffffffff803dacf4>] __driver_attach+0x81/0xda
[ 2349.767463]  [<ffffffff803d99d2>] bus_for_each_dev+0x49/0x6f
[ 2349.773211]  [<ffffffff803dad6c>] driver_attach+0x1f/0x24
[ 2349.778699]  [<ffffffff803da249>] bus_add_driver+0x98/0x1ff
[ 2349.784371]  [<ffffffff803db1e0>] driver_register+0x7b/0x7d
[ 2349.790033]  [<ffffffff80387704>] __pci_register_driver+0x57/0x91
[ 2349.796226]  [<ffffffff880590cc>] :mptspi:mptspi_init+0xcc/0xd1
[ 2349.802235]  [<ffffffff8025605f>] sys_init_module+0x1c8f/0x1da4
[ 2349.808251]  [<ffffffff80209d0e>] system_call+0x7e/0x83
[ 2349.813573]  [<00002b25be0952aa>]
[ 2349.816943]
[ 2349.818484] modprobe      D 00000043d958503c     0  3053   3013 (NOTLB)
[ 2349.825268]  ffff810127fedc18 0000000000000086 0000000000000000 ffffffff8037ca04
[ 2349.832869]  ffff810100000000 ffff81012b5f8810 ffff810129c400c0 0000000500000286
[ 2349.840469]  00000000ffffa711 0000000000000000 ffff810001053400 000000052a050180
[ 2349.847856] Call Trace:
[ 2349.850571]  [<ffffffff804f1b37>] __down+0x97/0x108
[ 2349.855527]  [<ffffffff804f1933>] __down_failed+0x35/0x3a
[ 2349.861025]  [<ffffffff803dacdf>] __driver_attach+0x6c/0xda
[ 2349.866687]  [<ffffffff803d99d2>] bus_for_each_dev+0x49/0x6f
[ 2349.872446]  [<ffffffff803dad6c>] driver_attach+0x1f/0x24
[ 2349.877933]  [<ffffffff803da249>] bus_add_driver+0x98/0x1ff
[ 2349.883604]  [<ffffffff803db1e0>] driver_register+0x7b/0x7d
[ 2349.889276]  [<ffffffff80387704>] __pci_register_driver+0x57/0x91
[ 2349.895468]  [<ffffffff8806101e>] :i2c_nforce2:nforce2_init+0x1e/0x23
[ 2349.902005]  [<ffffffff8025605f>] sys_init_module+0x1c8f/0x1da4
[ 2349.908019]  [<ffffffff80209d0e>] system_call+0x7e/0x83
[ 2349.913326]  [<00002b351a9c92aa>]
[ 2349.916713]
 

Thanks,
Bernd

-- 
Bernd Schubert
Q-Leap Networks GmbH
