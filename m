From: Gal Rosen <galr@storwize.com>
Subject: rmmod qlogic driver stuck
Date: Mon, 08 Dec 2008 13:33:34 +0200
Message-ID: <1228736014.6291.221.camel@galr-linux.storwiz.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.storwize.com ([62.90.10.208]:40414 "EHLO swdc2.storwiz.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753137AbYLHLeK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Dec 2008 06:34:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, andrew.vasquez@qlogic.com
Cc: Gal Rosen <galr@storwize.com>

Hi,

I am working against IBM Total Storage DS4000 with LSI INF-01-00 Rev:
0534 controller. First I don't understand why this controller present 32
access LUNs instead of one.

But my main issue is when I create virtual port and then try to rmmod
the qlogic driver, it stuck. I must say that I made changes to the
qlogic driver which add possibility to create virtual port in FC-AL
topology. The base driver is from kernel 2.6.26.2.

Here is a part of the messages file:

[ 1814.053285] scsi(7): DPC handler exiting
[ 1814.095309] ACPI: PCI interrupt for device 0000:0b:00.1 disabled
[ 1814.217213] scsi(6): DPC handler exiting
[ 1814.290665] ACPI: PCI interrupt for device 0000:0b:00.0 disabled
[ 1814.360667] qla24xx_control_vp(5): done.
[ 1814.442526] sd 8:0:0:1: [sdah] Synchronizing SCSI cache
[ 1815.277526] scsi(5): fcport-1 - port retry count: 29 remaining
[ 1816.392100] scsi(5): fcport-1 - port retry count: 28 remaining
[ 1817.507786] scsi(5): fcport-1 - port retry count: 27 remaining
[ 1818.612993] scsi(5): fcport-1 - port retry count: 26 remaining
[ 1819.717991] scsi(5): fcport-1 - port retry count: 25 remaining
[ 1820.822403] scsi(5): fcport-1 - port retry count: 24 remaining
[ 1821.926798] scsi(5): fcport-1 - port retry count: 23 remaining
[ 1822.991607] scsi(5): fcport-1 - port retry count: 22 remaining
[ 1824.107598] scsi(5): fcport-1 - port retry count: 21 remaining
[ 1825.189561] scsi(5): fcport-1 - port retry count: 20 remaining
[ 1826.271443] scsi(5): fcport-1 - port retry count: 19 remaining
[ 1827.350677] scsi(5): fcport-1 - port retry count: 18 remaining
[ 1828.432559] scsi(5): fcport-1 - port retry count: 17 remaining
[ 1829.524842] scsi(5): fcport-1 - port retry count: 16 remaining
[ 1830.604243] scsi(5): fcport-1 - port retry count: 15 remaining
[ 1831.691945] scsi(5): fcport-1 - port retry count: 14 remaining
[ 1832.758045] scsi(5): fcport-1 - port retry count: 13 remaining
[ 1833.839928] scsi(5): fcport-1 - port retry count: 12 remaining
[ 1834.933894] scsi(5): fcport-1 - port retry count: 11 remaining
[ 1836.050068] scsi(5): fcport-1 - port retry count: 10 remaining
[ 1837.156206] scsi(5): fcport-1 - port retry count: 9 remaining
[ 1838.261242] scsi(5): fcport-1 - port retry count: 8 remaining
[ 1839.365204] scsi(5): fcport-1 - port retry count: 7 remaining
[ 1840.470085] scsi(5): fcport-1 - port retry count: 6 remaining
[ 1841.571993] scsi(5): fcport-1 - port retry count: 5 remaining
[ 1842.683584] scsi(5): fcport-1 - port retry count: 4 remaining
[ 1843.790643] scsi(5): fcport-1 - port retry count: 3 remaining
[ 1844.894815] scsi(5): fcport-1 - port retry count: 2 remaining
[ 1845.997724] scsi(5): fcport-1 - port retry count: 1 remaining
[ 1847.079606] scsi(5): fcport-1 - port retry count: 0 remaining
scst_susp_wait:456:wait_event[ 1977.833121] INFO: task fc_wq_5:4394
blocked for more than 120 seconds.
[ 1977.972280] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 1978.122974] fc_wq_5       D 7fffffffffffffff     0  4394      2
[ 1978.190692]  ffff81022dd31c90 0000000000000046 ffff81022dd31c38
ffffffff802254c4
[ 1978.276546]  ffff81022ea1c2d0 ffff81022e623180 ffff81022ea1c510
ffff81022e55ee68
[ 1978.378542]  ffff81022dd31c80 ffffffff8022903d 000000002dcf7a10
ffff81022e55ee30
[ 1978.464458] Call Trace:
[ 1978.491875]  [<ffffffff802254c4>] target_load+0x34/0x70
[ 1978.575042]  [<ffffffff8022903d>] enqueue_task_fair+0xfd/0x100
[ 1978.681847]  [<ffffffff805c53b5>] schedule_timeout+0x95/0xd0
[ 1978.786522]  [<ffffffff80225280>] activate_task+0x30/0x50
[ 1978.877423]  [<ffffffff80227b19>] try_to_wake_up+0x99/0x150
[ 1978.971134]  [<ffffffff805c4978>] wait_for_common+0xb8/0x170
[ 1979.074132]  [<ffffffff80227bd0>] default_wake_function+0x0/0x10
[ 1979.182967]  [<ffffffff80241b7f>] flush_cpu_workqueue+0x5f/0x80
[ 1979.291875]  [<ffffffff80241bd0>] wq_barrier_func+0x0/0x10
[ 1979.394407]  [<ffffffff80241bb0>] cleanup_workqueue_thread+0x10/0x30
[ 1979.483664]  [<ffffffff80241cab>] destroy_workqueue+0x6b/0xa0
[ 1979.589783]  [<ffffffffa00017ad>] :scsi_transport_fc:fc_remove_host
+0x18d/0x1c0
[ 1979.733718]  [<ffffffffa0028fe7>] :qla2xxx:qla24xx_vport_delete
+0x97/0xd0
[ 1979.859603]
[<ffffffffa0000735>] :scsi_transport_fc:fc_vport_terminate+0x95/0x1f0
[ 1979.984072]
[<ffffffffa000104f>] :scsi_transport_fc:fc_vport_sched_delete+0x2f/0xb0
[ 1980.110411]
[<ffffffffa0001020>] :scsi_transport_fc:fc_vport_sched_delete+0x0/0xb0
[ 1980.257699]  [<ffffffff8024194a>] run_workqueue+0x7a/0x100
[ 1980.350508]  [<ffffffff802422f0>] worker_thread+0x0/0x120
[ 1980.452376]  [<ffffffff802423af>] worker_thread+0xbf/0x120
[ 1980.552810]  [<ffffffff802454d0>] autoremove_wake_function+0x0/0x30
[ 1980.664542]  [<ffffffff802422f0>] worker_thread+0x0/0x120
[ 1980.755871]  [<ffffffff802450bb>] kthread+0x4b/0x80
[ 1980.840354]  [<ffffffff8020c2b8>] child_rip+0xa/0x12
[ 1980.928672]  [<ffffffff80245070>] kthread+0x0/0x80
[ 1981.013135]  [<ffffffff8020c2ae>] child_rip+0x0/0x12
[ 1981.077354] 
[ 1981.097355] INFO: task fc_wq_8:5114 blocked for more than 120
seconds.
[ 1981.222282] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 1981.370544] fc_wq_8       D 7fffffffffffffff     0  5114      2
[ 1981.438077]  ffff81022d6bba40 0000000000000046 ffff81022d6bb9e8
ffffffff802254c4
[ 1981.511317]  ffff81022e55ee30 ffff81022f337340 ffff81022e55f070
ffff81022e6231b8
[ 1981.593143]  ffff81022d6bba30 ffffffff8022903d 000000002d6bbb70
ffff81022e623180
[ 1981.686876] Call Trace:
[ 1981.719854]  [<ffffffff802254c4>] target_load+0x34/0x70
[ 1981.809125]  [<ffffffff8022903d>] enqueue_task_fair+0xfd/0x100
[ 1981.915550]  [<ffffffff805c53b5>] schedule_timeout+0x95/0xd0
[ 1982.020103]  [<ffffffff80260d23>] mempool_alloc+0x43/0x120
[ 1982.121462]  [<ffffffff80227b19>] try_to_wake_up+0x99/0x150
[ 1982.224216]  [<ffffffff805c4978>] wait_for_common+0xb8/0x170
[ 1982.330846]  [<ffffffff80227bd0>] default_wake_function+0x0/0x10
[ 1982.438226]  [<ffffffff803cb74e>] blk_execute_rq+0x9e/0x110
[ 1982.509124]  [<ffffffff803c8951>] get_request_wait+0x21/0x1a0
[ 1982.595318]  [<ffffffff80470333>] scsi_execute+0xf3/0x150
[ 1982.678670]  [<ffffffff80470421>] scsi_execute_req+0x91/0x100
[ 1982.771109]  [<ffffffff80484e04>] sd_sync_cache+0x84/0xe0
[ 1982.860773]  [<ffffffff803d0000>] as_get_io_context+0xb0/0xd0
[ 1982.965030]  [<ffffffff803d7902>] kobject_get+0x12/0x20
[ 1983.051255]  [<ffffffff804867e1>] sd_shutdown+0x71/0x150
[ 1983.141541]  [<ffffffff8048692c>] sd_remove+0x3c/0x80
[ 1983.228126]  [<ffffffff804748be>] scsi_bus_remove+0x3e/0x50
[ 1983.332016]  [<ffffffff8043330f>] __device_release_driver+0x6f/0xb0
[ 1983.452356]  [<ffffffff80433378>] device_release_driver+0x28/0x40
[ 1983.561829]  [<ffffffff804325d5>] bus_remove_device+0x85/0xb0
[ 1983.666241]  [<ffffffff80430fb5>] device_del+0xf5/0x170
[ 1983.754593]  [<ffffffff80474ac3>] __scsi_remove_device+0x53/0xa0
[ 1983.863014]  [<ffffffff80474b38>] scsi_remove_device+0x28/0x40
[ 1983.970849]  [<ffffffff80474be8>] __scsi_remove_target+0x98/0xd0
[ 1984.079396]  [<ffffffff80474c90>] __remove_child+0x0/0x20
[ 1984.168331]  [<ffffffff80474ca6>] __remove_child+0x16/0x20
[ 1984.259837]  [<ffffffff8043077d>] device_for_each_child+0x2d/0x60
[ 1984.368907]  [<ffffffff80474c6d>] scsi_remove_target+0x4d/0x70
[ 1984.475233]
[<ffffffffa0003510>] :scsi_transport_fc:fc_rport_final_delete+0xa0/0x180
[ 1984.624277]
[<ffffffffa0003470>] :scsi_transport_fc:fc_rport_final_delete+0x0/0x180
[ 1984.772568]  [<ffffffff8024194a>] run_workqueue+0x7a/0x100
[ 1984.864894]  [<ffffffff802422f0>] worker_thread+0x0/0x120
[ 1984.966088]  [<ffffffff802423af>] worker_thread+0xbf/0x120
[ 1985.057210]  [<ffffffff802454d0>] autoremove_wake_function+0x0/0x30
[ 1985.168655]  [<ffffffff802422f0>] worker_thread+0x0/0x120
[ 1985.259919]  [<ffffffff802450bb>] kthread+0x4b/0x80
[ 1985.345251]  [<ffffffff8020c2b8>] child_rip+0xa/0x12
[ 1985.431736]  [<ffffffff80245070>] kthread+0x0/0x80
[ 1985.517472]  [<ffffffff8020c2ae>] child_rip+0x0/0x12
[ 1985.603736] 
[ 1985.620637] INFO: task rmmod:5281 blocked for more than 120 seconds.
[ 1985.752947] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 1985.901707] rmmod         D 7fffffffffffffff     0  5281   5280
[ 1985.968887]  ffff81022c9d3ca8 0000000000000082 ffff81022c9d3c50
ffffffff802254c4
[ 1986.055682]  ffff81022e88ee30 ffff81022ea1c2d0 ffff81022e88f070
ffff81022ea1c308
[ 1986.151684]  ffff81022c9d3c98 ffffffff8022903d 000000002e00205d
ffff81022ea1c2d0
[ 1986.240985] Call Trace:
[ 1986.274053]  [<ffffffff802254c4>] target_load+0x34/0x70
[ 1986.362395]  [<ffffffff8022903d>] enqueue_task_fair+0xfd/0x100
[ 1986.468489]  [<ffffffff805c53b5>] schedule_timeout+0x95/0xd0
[ 1986.573175]  [<ffffffff80227b19>] try_to_wake_up+0x99/0x150
[ 1986.676371]  [<ffffffff805c4978>] wait_for_common+0xb8/0x170
[ 1986.769748]  [<ffffffff80227bd0>] default_wake_function+0x0/0x10
[ 1986.877813]  [<ffffffff80241b7f>] flush_cpu_workqueue+0x5f/0x80
[ 1986.986917]  [<ffffffff80241bd0>] wq_barrier_func+0x0/0x10
[ 1987.055389]  [<ffffffff80241bb0>] cleanup_workqueue_thread+0x10/0x30
[ 1987.168262]  [<ffffffff80241cab>] destroy_workqueue+0x6b/0xa0
[ 1987.272915]  [<ffffffffa00017ad>] :scsi_transport_fc:fc_remove_host
+0x18d/0x1c0
[ 1987.405129]  [<ffffffffa000ec6e>] :qla2xxx:qla2x00_remove_one
+0x4e/0x90
[ 1987.507683]  [<ffffffff803ee10c>] pci_device_remove+0x2c/0x60
[ 1987.612003]  [<ffffffff8043330f>] __device_release_driver+0x6f/0xb0
[ 1987.701794]  [<ffffffff804338a4>] driver_detach+0xb4/0xc0
[ 1987.793286]  [<ffffffff804324c4>] bus_remove_driver+0x84/0xb0
[ 1987.898612]  [<ffffffff803ee399>] pci_unregister_driver+0x29/0x90
[ 1988.006424]  [<ffffffffa002d29f>] :qla2xxx:qla2x00_module_exit
+0xf/0x70
[ 1988.131469]  [<ffffffff80254bbd>] sys_delete_module+0x14d/0x240
[ 1988.238945]  [<ffffffff803dacd1>] __up_write+0x21/0x130
[ 1988.328272]  [<ffffffff8020b49b>] system_call_after_swapgs+0x7b/0x80
[ 1988.439487] 

host5 is the physical port, and host8 is the virtual port that created
on host5.
This issue does not occur against CLARiiON for instanse.

Please help !!!

Thanks,
Gal Rosen.


