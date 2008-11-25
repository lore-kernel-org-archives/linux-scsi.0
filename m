From: Gal Rosen <galr@storwize.com>
Subject: kobject_add_internal failed for 105:0:0:0 with -EEXIST, don't try
	to register things with the same name in the same directory
Date: Tue, 25 Nov 2008 16:00:56 +0200
Message-ID: <1227621656.14942.98.camel@galr-linux.storwiz.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.storwize.com ([62.90.10.208]:37770 "EHLO swdc2.storwiz.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752207AbYKYOA7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Nov 2008 09:00:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Gal Rosen <galr@storwize.com>

Hi,

Does anyone encounter such a problem ?

I am using QLogic driver, and created virtual port, then I disable the
vport and after couple of minutes enable it, and the problem occurs.


[162680.502438] qla2xxx 0000:06:00.0: LIP reset occured (f7e8).
[162680.559439] qla2xxx 0000:06:00.0: LIP reset occured (f7e8).
[162680.617120] qla2xxx 0000:06:00.0: LIP occured (f7e8).
[162680.673733] qla2xxx 0000:06:00.0: LIP occured (f7e8).
[162680.740514] scsi 105:0:0:0: Direct-Access     DGC      RAID 0
0219 PQ: 0 ANSI: 4
[162680.837674] sd 105:0:0:0: [sdb] 104857600 512-byte hardware sectors
(53687 MB)
[162680.916389] sd 105:0:0:0: [sdb] Write Protect is off
[162680.971659] sd 105:0:0:0: [sdb] Write cache: disabled, read cache:
enabled, doesn't support DPO or FUA
[162681.062343] sd 105:0:0:0: [sdb] 104857600 512-byte hardware sectors
(53687 MB)
[162681.149600] sd 105:0:0:0: [sdb] Write Protect is off
[162681.209825] sd 105:0:0:0: [sdb] Write cache: disabled, read cache:
enabled, doesn't support DPO or FUA
[162681.312385]  sdb: unknown partition table
[162681.364817] sd 105:0:0:0: [sdb] Attached SCSI disk
[162681.415509] sd 105:0:0:0: Attached scsi generic sg1 type 0
[162730.503473]  rport-105:0-0: blocked FC remote port time out:
removing target and saving binding
[162741.546042] qla2xxx 0000:06:00.0: LIP reset occured (f7e8).
[162741.586043] qla2xxx 0000:06:00.0: LIP reset occured (f7e8).
[162741.647440] qla2xxx 0000:06:00.0: LIP occured (f7e8).
[162741.647440] qla2xxx 0000:06:00.0: LIP occured (f7e8).
[162741.786047] scsi 105:0:0:0: Direct-Access     DGC      RAID 0
0219 PQ: 0 ANSI: 4
[162741.968429] sd 105:0:0:0: [sdb] 104857600 512-byte hardware sectors
(53687 MB)
[162742.103783] sd 105:0:0:0: [sdb] Write Protect is off
[162742.162283] sd 105:0:0:0: [sdb] Write cache: disabled, read cache:
enabled, doesn't support DPO or FUA
[162742.260735] sd 105:0:0:0: [sdb] 104857600 512-byte hardware sectors
(53687 MB)
[162742.344431] sd 105:0:0:0: [sdb] Write Protect is off
[162742.402063] sd 105:0:0:0: [sdb] Write cache: disabled, read cache:
enabled, doesn't support DPO or FUA
[162742.501536]  sdb: unknown partition table
[162742.546295] sd 105:0:0:0: [sdb] Attached SCSI disk
[162742.609118] sd 105:0:0:0: Attached scsi generic sg1 type 0
[162742.679687] scsi 105:0:0:0: Direct-Access     DGC      RAID 0
0219 PQ: 0 ANSI: 4
[162742.774281] kobject_add_internal failed for 105:0:0:0 with -EEXIST,
don't try to register things with the same name in the same directory.
[162742.911192] Pid: 13282, comm: scsi_wq_105 Not tainted
2.6.26.2-64bit-stw-nfs #18
[162743.046691] 
[162743.046692] Call Trace:
[162743.092000]  [<ffffffff803d7af3>] kobject_add_internal+0x173/0x1c0
[162743.179138]  [<ffffffff803d8054>] kobject_add+0x54/0x80
[162743.243894]  [<ffffffff80231b6e>] printk+0x4e/0x60
[162743.296139]  [<ffffffff805adac7>] klist_next+0x47/0xc0
[162743.371432]  [<ffffffff803d7902>] kobject_get+0x12/0x20
[162743.426598]  [<ffffffff80430a17>] get_device+0x17/0x30
[162743.493113]  [<ffffffff8043116f>] device_add+0xbf/0x5a0
[162743.548374]  [<ffffffff80474d25>] scsi_sysfs_add_sdev+0x65/0x290
[162743.630399]  [<ffffffff804729e8>] scsi_probe_and_add_lun+0xa98/0xbb0
[162743.702527]  [<ffffffff8047043b>] scsi_execute_req+0xab/0x100
[162743.772525]  [<ffffffff804732f6>] __scsi_scan_target+0x626/0x6d0
[162743.855816]  [<ffffffff80473a35>] scsi_scan_target+0x105/0x110
[162743.921864]
[<ffffffffa0000e7a>] :scsi_transport_fc:fc_scsi_scan_rport+0x8a/0xa0
[162744.009466]
[<ffffffffa0000df0>] :scsi_transport_fc:fc_scsi_scan_rport+0x0/0xa0
[162744.092397]  [<ffffffff8024194a>] run_workqueue+0x7a/0x100
[162744.168955]  [<ffffffff802422f0>] worker_thread+0x0/0x120
[162744.218978]  [<ffffffff802423af>] worker_thread+0xbf/0x120
[162744.289554]  [<ffffffff802454d0>] autoremove_wake_function+0x0/0x30
[162744.384142]  [<ffffffff802422f0>] worker_thread+0x0/0x120
[162744.438454]  [<ffffffff802450bb>] kthread+0x4b/0x80
[162744.501454]  [<ffffffff8020c2b8>] child_rip+0xa/0x12
[162744.544922]  [<ffffffff8057a2f0>] unix_dgram_poll+0x0/0x1c0
[162744.625061]  [<ffffffff80245070>] kthread+0x0/0x80
[162744.689818]  [<ffffffff8020c2ae>] child_rip+0x0/0x12
[162744.778228] 
[162744.788244] error 1
[162744.812583] scsi 105:0:0:0: Unexpected response from lun 0 while
scanning, scan aborted


ps -ef output shows:
root     13123     2  0 05:56 ?        00:00:00 [scsi_eh_99]
root     13128     2  0 05:56 ?        00:00:00 [qla2xxx_99_dpc]
root     13129     2  0 05:56 ?        00:00:00 [scsi_wq_99]
root     13131     2  0 05:56 ?        00:00:00 [fc_wq_99]
root     13132     2  0 05:56 ?        00:00:00 [fc_dl_99]
root     13136     2  0 05:56 ?        00:00:00 [scsi_eh_100]
root     13141     2  0 05:56 ?        00:00:00 [qla2xxx_100_dpc]
root     13142     2  0 05:56 ?        00:00:00 [scsi_wq_100]
root     13143     2  0 05:56 ?        00:00:00 [fc_wq_100]
root     13144     2  0 05:56 ?        00:00:00 [fc_dl_100]
root     13146     2  0 05:56 ?        00:00:00 [scsi_eh_101]
root     13149     2  0 05:56 ?        00:00:00 [qla2xxx_101_dpc]
root     13150     2  0 05:56 ?        00:00:00 [scsi_wq_101]
root     13152     2  0 05:56 ?        00:00:00 [fc_wq_101]
root     13153     2  0 05:56 ?        00:00:00 [fc_dl_101]
root     13157     2  0 05:56 ?        00:00:00 [scsi_eh_102]
root     13158     2  0 05:56 ?        00:00:00 [qla2xxx_102_dpc]
root     13160     2  0 05:56 ?        00:00:00 [scsi_wq_102]
root     13161     2  0 05:56 ?        00:00:00 [fc_wq_102]
root     13162     2  0 05:56 ?        00:00:00 [fc_dl_102]
root     13281     2  0 06:04 ?        00:00:00 [scsi_eh_105]
root     13282     2  0 06:04 ?        00:00:08 [scsi_wq_105]
root     13859  3218  0 08:14 pts/0    00:00:00 ps -ef

scsi_eh_105 and scsi_wq_105 threads stays open even after I delete this
vport, and now I cannot rmmod the module because it's module use count
is 1.

Gal.


