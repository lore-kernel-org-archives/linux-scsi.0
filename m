From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] driver: fix lockdep with sysfs
Date: Sat, 20 Mar 2010 12:07:03 -0700
Message-ID: <4BA51CD7.1070108@kernel.org>
References: <a4423d671003081547v5c955d58t248db945c06d2a7f@mail.gmail.com>	 <86802c441003081612r2f44efd6n9664b4b7c98a636a@mail.gmail.com>	 <m1d3zel4b4.fsf@fess.ebiederm.org> <4B95F37E.6060309@kernel.org>	 <m14okqnczd.fsf@fess.ebiederm.org> <4B99A6F0.4080203@kernel.org>	 <4BA47692.7040401@kernel.org> <1269099710.4353.106.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:33010 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346Ab0CTTIK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 Mar 2010 15:08:10 -0400
In-Reply-To: <1269099710.4353.106.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, Greg KH <gregkh@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux-Scsi <linux-scsi@vger.kernel.org>



[  135.305026] QLogic Fibre Channel HBA Driver: 8.03.02-k1
[  135.310509] qla2xxx 0000:cc:00.0: PCI INT A -> GSI 99 (level, low) -> IRQ 99
[  135.326453] qla2xxx 0000:cc:00.0: MSI-X vector count: 31
[  135.341911] qla2xxx 0000:cc:00.0: Found an ISP2532, irq 99, iobase 0xffffc9007285c000
[  135.352495]   alloc irq_desc for 146 on node 6
[  135.356272]   alloc kstat_irqs on node 6
[  135.367624] qla2xxx 0000:cc:00.0: irq 146 for MSI/MSI-X
[  135.372172]   alloc irq_desc for 147 on node 6
[  135.376164]   alloc kstat_irqs on node 6
[  135.391973] qla2xxx 0000:cc:00.0: irq 147 for MSI/MSI-X
[  135.403591] qla2xxx 0000:cc:00.0: Configuring PCI space...
[  135.413614] qla2xxx 0000:cc:00.0: setting latency timer to 64
[  135.422740] qla2xxx 0000:cc:00.0: enabling Mem-Wr-Inval
[  135.445429] qla2xxx 0000:cc:00.0: Configure NVRAM parameters...
[  135.462077] qla2xxx 0000:cc:00.0: Verifying loaded RISC code...
[  135.469113] qla2xxx 0000:cc:00.0: firmware: using built-in firmware ql2500_fw.bin
[  135.482852] qla2xxx 0000:cc:00.0: FW: Loading via request-firmware...
[  135.519818] qla2xxx 0000:cc:00.0: Allocated (64 KB) for FCE...
[  135.525475] qla2xxx 0000:cc:00.0: Allocated (64 KB) for EFT...
[  135.533345] qla2xxx 0000:cc:00.0: Allocated (1350 KB) for firmware dump...
[  135.539819] scsi0 : qla2xxx
[  135.554163] BUG: key ffff8840723fe310 not in .data!
[  135.558600] ------------[ cut here ]------------
[  135.562666] WARNING: at kernel/lockdep.c:2706 lockdep_init_map+0xf1/0x53c()
[  135.574592] Hardware name: Sun Fire x4800
[  135.576871] Modules linked in:
[  135.592605] Pid: 14368, comm: work_for_cpu Not tainted 2.6.34-rc2-tip-yh-03489-gae232d1-dirty #687
[  135.599585] Call Trace:
[  135.612279]  [<ffffffff81079c04>] warn_slowpath_common+0x7c/0x94
[  135.618090]  [<ffffffff81079c30>] warn_slowpath_null+0x14/0x16
[  135.633496]  [<ffffffff810a4715>] lockdep_init_map+0xf1/0x53c
[  135.638220]  [<ffffffff811869d0>] ? sysfs_new_dirent+0x8f/0x104
[  135.654379]  [<ffffffff81185ffc>] sysfs_add_file_mode+0x66/0xae
[  135.659672]  [<ffffffff813c7587>] ? kobject_put+0x47/0x4b
[  135.674975]  [<ffffffff81498b0f>] ? transport_add_class_device+0x0/0x39
[  135.681399]  [<ffffffff81186055>] sysfs_add_file+0x11/0x13
[  135.695045]  [<ffffffff81186114>] sysfs_create_file+0x2a/0x2c
[  135.698206]  [<ffffffff81493308>] device_create_file+0x19/0x1b
[  135.714671]  [<ffffffff81498501>] attribute_container_add_attrs+0x56/0x74
[  135.731897]  [<ffffffff81498541>] attribute_container_add_class_device+0x22/0x27
[  135.738647]  [<ffffffff81498b29>] transport_add_class_device+0x1a/0x39
[  135.754319]  [<ffffffff81498644>] attribute_container_device_trigger+0x7c/0xbc
[  135.759012]  [<ffffffff81498ab4>] transport_add_device+0x15/0x17
[  135.777621]  [<ffffffff814b169e>] scsi_sysfs_add_host+0x8c/0x9e
[  135.791587]  [<ffffffff814a79df>] scsi_add_host_with_dma+0x1c2/0x217
[  135.798047]  [<ffffffff81bb4599>] qla2x00_probe_one+0xbeb/0xe17
[  135.813384]  [<ffffffff810a5f6b>] ? trace_hardirqs_on+0xd/0xf
[  135.819473]  [<ffffffff81bfb004>] ? _raw_spin_unlock_irq+0x30/0x36
[  135.834964]  [<ffffffff81072699>] ? finish_task_switch+0x70/0xe4
[  135.839030]  [<ffffffff81bf82a4>] ? schedule+0x65f/0x72b
[  135.854065]  [<ffffffff81090c9e>] ? do_work_for_cpu+0x0/0x2a
[  135.858979]  [<ffffffff813ebaad>] local_pci_probe+0x17/0x1b
[  135.874627]  [<ffffffff81090cb6>] do_work_for_cpu+0x18/0x2a
[  135.879828]  [<ffffffff810947fc>] kthread+0x9a/0xa2
[  135.893473]  [<ffffffff810a5f33>] ? trace_hardirqs_on_caller+0x120/0x14b
[  135.897853]  [<ffffffff810349d4>] kernel_thread_helper+0x4/0x10
[  135.915221]  [<ffffffff81bfb33c>] ? restore_args+0x0/0x30
[  135.920415]  [<ffffffff81094762>] ? kthread+0x0/0xa2
[  135.934108]  [<ffffffff810349d0>] ? kernel_thread_helper+0x0/0x10
[  135.938754] ---[ end trace 0f8a5c5b26192860 ]---
[  135.955325] BUG: key ffff8840723fe348 not in .data!
[  135.957618] BUG: key ffff8840723fe380 not in .data!
[  135.972538] BUG: key ffff8840723fe3b8 not in .data!
[  135.976839] BUG: key ffff8840723fe3f0 not in .data!
[  135.992169] BUG: key ffff8840723fe428 not in .data!
[  135.995598] BUG: key ffff8840723fe460 not in .data!
[  136.001329] BUG: key ffff8840723fe498 not in .data!
[  136.015597] BUG: key ffff8840723fe4d0 not in .data!
[  136.019889] BUG: key ffff8840723fe508 not in .data!
[  136.034086] BUG: key ffff8840723fe540 not in .data!
[  136.036915] BUG: key ffff8840723fe578 not in .data!
[  136.053066] BUG: key ffff8840723fe5b0 not in .data!
[  136.058530] BUG: key ffff8840723fe5e8 not in .data!
[  136.071615] BUG: key ffff8840723fe620 not in .data!
[  136.076256] BUG: key ffff8840723fe658 not in .data!
[  136.081129] BUG: key ffff8840723fe690 not in .data!

and 

[  132.409474] Emulex LightPulse Fibre Channel SCSI driver 8.3.10
[  132.424746] Copyright(c) 2004-2009 Emulex.  All rights reserved.
[  132.430422] lpfc 0000:cd:00.0: PCI INT A -> GSI 101 (level, low) -> IRQ 101
[  132.445731] lpfc 0000:cd:00.0: setting latency timer to 64
[  132.450672] lpfc 0000:cd:00.0: enabling Mem-Wr-Inval
[  132.469272] scsi0 :  on PCI bus cd device 00 irq 101
[  132.476490] BUG: key ffff881c7b86c310 not in .data!
[  132.484102] ------------[ cut here ]------------
[  132.486701] WARNING: at kernel/lockdep.c:2706 lockdep_init_map+0xf1/0x53c()
[  132.504379] Hardware name: Sun Fire x4800
[  132.507564] Modules linked in:
[  132.509834] Pid: 7071, comm: work_for_cpu Not tainted 2.6.34-rc2-tip-yh-03489-gae232d1-dirty #687
[  132.527149] Call Trace:
[  132.541391]  [<ffffffff81079c04>] warn_slowpath_common+0x7c/0x94
[  132.544345]  [<ffffffff81079c30>] warn_slowpath_null+0x14/0x16
[  132.562047]  [<ffffffff810a4715>] lockdep_init_map+0xf1/0x53c
[  132.566212]  [<ffffffff811869d0>] ? sysfs_new_dirent+0x8f/0x104
[  132.581672]  [<ffffffff81185ffc>] sysfs_add_file_mode+0x66/0xae
[  132.585236]  [<ffffffff813c7587>] ? kobject_put+0x47/0x4b
[  132.603426]  [<ffffffff81498b0f>] ? transport_add_class_device+0x0/0x39
[  132.607886]  [<ffffffff81186055>] sysfs_add_file+0x11/0x13
[  132.623460]  [<ffffffff81186114>] sysfs_create_file+0x2a/0x2c
[  132.628466]  [<ffffffff81493308>] device_create_file+0x19/0x1b
[  132.643430]  [<ffffffff81498501>] attribute_container_add_attrs+0x56/0x74
[  132.648177]  [<ffffffff81498541>] attribute_container_add_class_device+0x22/0x27
[  132.665296]  [<ffffffff81498b29>] transport_add_class_device+0x1a/0x39
[  132.681485]  [<ffffffff81498644>] attribute_container_device_trigger+0x7c/0xbc
[  132.686590]  [<ffffffff81498ab4>] transport_add_device+0x15/0x17
[  132.702516]  [<ffffffff814b169e>] scsi_sysfs_add_host+0x8c/0x9e
[  132.708766]  [<ffffffff814a79df>] scsi_add_host_with_dma+0x1c2/0x217
[  132.724171]  [<ffffffff8158b3f0>] lpfc_create_port+0x247/0x295
[  132.740978]  [<ffffffff8158b48e>] lpfc_create_shost+0x50/0x8e
[  132.745700]  [<ffffffff81bb4fe7>] lpfc_pci_probe_one_s3+0x21f/0x48b
[  132.762194]  [<ffffffff81090c9e>] ? do_work_for_cpu+0x0/0x2a
[  132.768137]  [<ffffffff81bb5797>] lpfc_pci_probe_one+0x66/0x6d
[  132.781613]  [<ffffffff813ebaad>] local_pci_probe+0x17/0x1b
[  132.786593]  [<ffffffff81090cb6>] do_work_for_cpu+0x18/0x2a
[  132.801537]  [<ffffffff810947fc>] kthread+0x9a/0xa2
[  132.805921]  [<ffffffff810a5f33>] ? trace_hardirqs_on_caller+0x120/0x14b
[  132.822948]  [<ffffffff810349d4>] kernel_thread_helper+0x4/0x10
[  132.827937]  [<ffffffff81bfb33c>] ? restore_args+0x0/0x30
[  132.843328]  [<ffffffff81094762>] ? kthread+0x0/0xa2
[  132.845962]  [<ffffffff810349d0>] ? kernel_thread_helper+0x0/0x10
[  132.862076] ---[ end trace b22595c04061dc94 ]---
[  132.863756] BUG: key ffff881c7b86c348 not in .data!
[  132.881037] BUG: key ffff881c7b86c380 not in .data!
[  132.884181] BUG: key ffff881c7b86c3b8 not in .data!
[  132.888249] BUG: key ffff881c7b86c3f0 not in .data!
[  132.905692] BUG: key ffff881c7b86c428 not in .data!
[  132.908299] BUG: key ffff881c7b86c460 not in .data!
[  132.922920] BUG: key ffff881c7b86c498 not in .data!
[  132.928176] BUG: key ffff881c7b86c4d0 not in .data!
[  132.942182] BUG: key ffff881c7b86c508 not in .data!
[  132.946896] BUG: key ffff881c7b86c540 not in .data!
[  132.960576] BUG: key ffff881c7b86c578 not in .data!
[  132.964449] BUG: key ffff881c7b86c5b0 not in .data!
[  132.967376] BUG: key ffff881c7b86c5e8 not in .data!
[  132.983418] BUG: key ffff881c7b86c620 not in .data!

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/base/attribute_container.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/drivers/base/attribute_container.c
===================================================================
--- linux-2.6.orig/drivers/base/attribute_container.c
+++ linux-2.6/drivers/base/attribute_container.c
@@ -328,6 +328,7 @@ attribute_container_add_attrs(struct dev
 		return sysfs_create_group(&classdev->kobj, cont->grp);
 
 	for (i = 0; attrs[i]; i++) {
+		sysfs_attr_init(&attrs[i]->attr);
 		error = device_create_file(classdev, attrs[i]);
 		if (error)
 			return error;
