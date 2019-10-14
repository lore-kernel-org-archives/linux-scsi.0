Return-Path: <SRS0=CnLx=YH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 183F4C4CECE
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Oct 2019 18:02:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7AF021928
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Oct 2019 18:02:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731780AbfJNSCM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Oct 2019 14:02:12 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:34034 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728941AbfJNSCM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 14 Oct 2019 14:02:12 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 1230B838F8ED154640C9;
        Tue, 15 Oct 2019 02:02:08 +0800 (CST)
Received: from [127.0.0.1] (10.202.227.179) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Tue, 15 Oct 2019
 02:02:06 +0800
To:     <linux-ide@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
From:   John Garry <john.garry@huawei.com>
Subject: ahci KASAN warning in experimental arm64 allmodconfig boot
Message-ID: <758acedf-4007-9937-e777-bd1371c84e21@huawei.com>
Date:   Mon, 14 Oct 2019 19:02:02 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.3.0
MIME-Version: 1.0
Content-Type: multipart/mixed;
        boundary="------------CDBF7B7193330D052C41DACD"
X-Originating-IP: [10.202.227.179]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--------------CDBF7B7193330D052C41DACD
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit

Hi guys,

I'm experimenting by trying to boot an allmodconfig arm64 kernel, as 
mentioned here:
https://lore.kernel.org/linux-arm-kernel/507325a3-030e-2843-0f46-7e18c60257de@huawei.com/

I am getting a KASAN slab-out-of-bounds warning around the ahci code, as 
below. I am also getting a crash some time after, but the stackframe is 
mixed up in the dmesg, so hard to extract that.

The kernel is v5.4-rc3.

I'll continue to look at this as time allows.

I have cc'ed the scsi list as this may be related to the SAS host (using 
libsas), but I'm doubtful, considering the log mentions ahci_init_one().

Thanks,
John

Log snippet:

[  137.529384][  T187] 
==================================================================
[  137.529403][  T187] BUG: KASAN: slab-out-of-bounds in 
ata_link_next+0x5c/0x1b0
[  137.529411][  T187] Read of size 4 at addr ffff002320073cc8 by task 
kworker/u194:0/187
[  137.529414][  T187]
[  137.529426][  T187] CPU: 38 PID: 187 Comm: kworker/u194:0 Tainted: G 
       W         5.4.0-rc3+ #1149
[  137.529433][  T187] Hardware name: Huawei D06 /D06, BIOS Hisilicon 
D06 UEFI RC0 - V1.16.01 03/15/2019
[  137.529447][  T187] Workqueue: events_unbound async_run_entry_fn
[  137.529454][  T187] Call trace:
[  137.529462][  T187]  dump_backtrace+0x0/0x298
[  137.529469][  T187]  show_stack+0x20/0x30
[  137.529477][  T187]  dump_stack+0x190/0x21c
[  137.529488][  T187]  print_address_description.isra.6+0x80/0x3d0
[  137.529496][  T187]  __kasan_report+0x174/0x23c
[  137.529503][  T187]  kasan_report+0xc/0x18
[  137.529511][  T187]  __asan_load4+0xa4/0xb0
[  137.529517][  T187]  ata_link_next+0x5c/0x1b0
[  137.529526][  T187]  ata_scsi_scan_host+0x50/0x2d0
[  137.529533][  T187]  async_port_probe+0x7c/0xa8
[  137.529541][  T187]  async_run_entry_fn+0x118/0x340
[  137.529549][  T187]  process_one_work+0x7b8/0xdb8
[  137.529556][  T187]  worker_thread+0x414/0x6b8
[  137.529562][  T187]  kthread+0x1d4/0x1f0
[  137.529570][  T187]  ret_from_fork+0x10/0x18
[  137.529574][  T187]
[  137.529580][  T187] Allocated by task 16:
[  137.529589][  T187]  save_stack+0x28/0xb0
[  137.529597][  T187]  __kasan_kmalloc.isra.9+0xa0/0xc8
[  137.529604][  T187]  kasan_slab_alloc+0x14/0x20
[  137.529612][  T187]  kmem_cache_alloc+0x25c/0x420
[  137.529620][  T187]  __proc_create+0x430/0x458
[  137.529627][  T187]  proc_mkdir_data+0x50/0xf0
[  137.529634][  T187]  proc_mkdir+0x2c/0x38
[  137.529642][  T187]  register_irq_proc+0x104/0x278
[  137.529650][  T187]  __setup_irq+0xafc/0xe80
[  137.529657][  T187]  request_threaded_irq+0x198/0x218
[  137.529666][  T187]  devm_request_threaded_irq+0xb0/0x120
[  137.529674][  T187]  ahci_host_activate+0x1cc/0x290
[  137.529682][  T187]  ahci_init_one+0x1358/0x1570
[  137.529691][  T187]  local_pci_probe+0x78/0xf0
[  137.529698][  T187]  work_for_cpu_fn+0x30/0x50
[  137.529705][  T187]  process_one_work+0x7b8/0xdb8
[  137.529713][  T187]  worker_thread+0x4a8/0x6b8
[  137.529719][  T187]  kthread+0x1d4/0x1f0
[  137.529726][  T187]  ret_from_fork+0x10/0x18
[  137.529729][  T187]
[  137.529734][  T187] Freed by task 0:
[  137.529737][  T187] (stack is not available)
[  137.529741][  T187]
[  137.529747][  T187] The buggy address belongs to the object at 
ffff002320073b68
[  137.529747][  T187]  which belongs to the cache proc_dir_entry of 
size 256
[  137.529755][  T187] The buggy address is located 96 bytes to the right of
[  137.529755][  T187]  256-byte region [ffff002320073b68, ffff002320073c68)
[  137.529759][  T187] The buggy address belongs to the page:
[  137.529768][  T187] page:fffffe008c601c00 refcount:1 mapcount:0 
mapping:ffff0020bf1b8480 index:0xffff002320070988 compound_mapcount: 0
[  137.529779][  T187] flags: 0x1ffff00000010200(slab|head)
[  137.529791][  T187] raw: 1ffff00000010200 ffff0020bf1a3cd0 
fffffe008c612208 ffff0020bf1b8480
[  137.529801][  T187] raw: ffff002320070988 000000000035000b 
00000001ffffffff 0000000000000000
[  137.529805][  T187] page dumped because: kasan: bad access detected
[  137.529809][  T187]
[  137.529812][  T187] Memory state around the buggy address:
[  137.529820][  T187]  ffff002320073b80: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[  137.529827][  T187]  ffff002320073c00: 00 00 00 00 00 00 00 00 00 00 
00 00 00 fc fc fc
[  137.529835][  T187] >ffff002320073c80: fc fc fc fc fc fc fc fc fc fc 
fc fc fc fc fc fc
[  137.529839][  T187]                                               ^
[  137.529846][  T187]  ffff002320073d00: fc fc fc fc fc fc fc fc fc fc 
fc fc fc fc fc fc
[  137.529853][  T187]  ffff002320073d80: fc fc fc fc fc fc fc fc fc fc 
fc fc fc fc fc fc
[  137.529857][  T187] 
==================================================================
[  137.529874][  T187] Unable to handle kernel paging request at virtual 
address 000004a02a0040ba
[  137.529883][  T187] Mem abort info:
[  137.529893][  T187]   ESR = 0x96000004
[  137.529905][  T187]   EC = 0x25: DABT (current EL), IL = 32 bits
[  137.529915][  T187]   SET = 0, FnV = 0
[  137.529925][  T187]   EA = 0, S1PTW = 0
[  137.529934][  T187] Data abort info:
[  137.529940][   T16] kobject: '177' ((____ptrval____)): 
kobject_add_internal: parent: 'irq', set: '<NULL>'
[  137.529945][  T187]   ISV = 0, ISS = 0x00000004
[  137.529955][  T187]   CM = 0, WnR = 0
[  137.529966][  T187] [000004a02a0040ba] user address but active_mm is 
swapper
[  137.529979][  T187] Internal error: Oops: 96000004 [#1] PREEMPT SMP
[  137.529985][  T187] Modules linked in:
[  137.529996][  T187] CPU: 38 PID: 187 Comm: kworker/u194:0 Tainted: G 
   B   W         5.4.0-rc3+ #1149
[  137.530002][  T187] Hardware name: Huawei D06 /D06, BIOS Hisilicon 
D06 UEFI RC0 - V1.16.01 03/15/2019
[  137.530011][  T187] Workqueue: events_unbound async_run_entry_fn
[  137.530020][  T187] pstate: 40800009 (nZcv daif -PAN +UAO)
[  137.530026][  T187] pc : ata_dev_next+0xf8/0x1f8
[  137.530033][  T187] lr : ata_dev_next+0xf8/0x1f8
[  137.530037][  T187] sp : ffff0020bddafb80
[  137.530042][  T187] x29: ffff0020bddafb80 x28: 0000000000000000
[  137.530050][  T187] x27: 0000000000003cc0 x26: ffffa00015016000
[  137.530059][  T187] x25: 00000000000020c0 x24: ffffa000113102a8
[  137.530068][  T187] x23: 350004a02a0003fa x22: ffffa00011335db0
[  137.530077][  T187] x21: ffffa000113356f0 x20: 0000000000000000
[  137.530085][  T187] x19: ffffa00011336830 x18: 00000000000025a8
[  137.530094][  T187] x17: 00000000000025a0 x16: 00000000000026b0
[  137.530102][  T187] x15: 0000000000001470 x14: 3d3d3d3d3d3d3d3d
[  137.530111][  T187] x13: 3d3d3d3d3d3d3d3d x12: 1fffe00417bb5f3e
[  137.530120][  T187] x11: ffff800417bb5f3e x10: dfffa00000000000
[  137.530129][  T187] x9 : ffff800417bb5f3f x8 : 0000000000000001
[  137.530138][  T187] x7 : 0000000000003cd0 x6 : 0000000000000000
[  137.530146][  T187] x5 : ffffa00015015cc8 x4 : 0000000000000000
[  137.530155][  T187] x3 : ffffa00011301608 x2 : 0000000000000000
[  137.530163][  T187] x1 : 21f045c4027f9500 x0 : 0000000000000000
[  137.530171][  T187] Call trace:
[  137.530178][  T187]  ata_dev_next+0xf8/0x1f8
[  137.530187][  T187]  ata_scsi_scan_host+0x6c/0x2d0
[  137.530194][  T187]  async_port_probe+0x7c/0xa8
[  137.530202][  T187]  async_run_entry_fn+0x118/0x340
[  137.530209][  T187]  process_one_work+0x7b8/0xdb8
[  137.530216][  T187]  worker_thread+0x414/0x6b8
[  137.530223][  T187]  kthread+0x1d4/0x1f0
[  137.530230][  T187]  ret_from_fork+0x10/0x18
[  137.530242][  T187] Code: 97c544f6 d2879801 8b0102e0 97cd4fb5 (f95e62e0)
[  137.530472][  T187] ---[ end trace 1702441cf7c2cd89 ]---
[  137.530479][  T187] Kernel panic - not syncing: Fatal exception
[  137.530592][   T16] kobject: '178' ((____ptrval____)): 
kobject_add_internal: parent: 'irq', set: '<NULL>'
[  137.530653][  T187] SMP: stopping secondary CPUs
[  137.531078][  T187] Kernel Offset: disabled
[  137.531085][  T187] CPU features: 0x0002,23208a38
[  137.531089][  T187] Memory Limit: none
[  143.699079][  T187] ---[ end Kernel panic - not syncing: Fatal 
exception ]---






--------------CDBF7B7193330D052C41DACD
Content-Type: text/plain; charset="UTF-8"; name="ata kasan issue.log"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="ata kasan issue.log"

WyAgMTM3LjUyOTE4N11bICAgIFQ4XSBrb2JqZWN0OiAnMDowOjQ6MCcgKChfX19fcHRydmFs
X19fXykpOiBmaWxsX2tvYmpfcGF0aDogcGF0aCA9ICcvZGV2aWNlcy9wY2kwMDAwOjc0LzAw
MDA6NzQ6MDIuMC9ob3N0MC9wb3J0LTA6MC9leHBhbmRlci0wOjEvcG9ydC0wOjE6MjQvZW5k
X2RldmljZS0wOjE6MjQvdGFyZ2V0MDowOjQvMDowOjQ6MC9ic2cvMDowOjQ6MCcKWyAgMTM3
LjUyOTM3N11bICAgVDE2XSBrb2JqZWN0OiAnMTc2JyAoKF9fX19wdHJ2YWxfX19fKSk6IGtv
YmplY3RfYWRkX2ludGVybmFsOiBwYXJlbnQ6ICdpcnEnLCBzZXQ6ICc8TlVMTD4nClsgIDEz
Ny41MjkzODRdWyAgVDE4N10gPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09ClsgIDEzNy41Mjk0MDNdWyAgVDE4N10g
QlVHOiBLQVNBTjogc2xhYi1vdXQtb2YtYm91bmRzIGluIGF0YV9saW5rX25leHQrMHg1Yy8w
eDFiMApbICAxMzcuNTI5NDExXVsgIFQxODddIFJlYWQgb2Ygc2l6ZSA0IGF0IGFkZHIgZmZm
ZjAwMjMyMDA3M2NjOCBieSB0YXNrIGt3b3JrZXIvdTE5NDowLzE4NwpbICAxMzcuNTI5NDE0
XVsgIFQxODddIApbICAxMzcuNTI5NDI2XVsgIFQxODddIENQVTogMzggUElEOiAxODcgQ29t
bToga3dvcmtlci91MTk0OjAgVGFpbnRlZDogRyAgICAgICAgVyAgICAgICAgIDUuNC4wLXJj
MysgIzExNDkKWyAgMTM3LjUyOTQzM11bICBUMTg3XSBIYXJkd2FyZSBuYW1lOiBIdWF3ZWkg
RDA2IC9EMDYsIEJJT1MgSGlzaWxpY29uIEQwNiBVRUZJIFJDMCAtIFYxLjE2LjAxIDAzLzE1
LzIwMTkKWyAgMTM3LjUyOTQ0N11bICBUMTg3XSBXb3JrcXVldWU6IGV2ZW50c191bmJvdW5k
IGFzeW5jX3J1bl9lbnRyeV9mbgpbICAxMzcuNTI5NDU0XVsgIFQxODddIENhbGwgdHJhY2U6
ClsgIDEzNy41Mjk0NjJdWyAgVDE4N10gIGR1bXBfYmFja3RyYWNlKzB4MC8weDI5OApbICAx
MzcuNTI5NDY5XVsgIFQxODddICBzaG93X3N0YWNrKzB4MjAvMHgzMApbICAxMzcuNTI5NDc3
XVsgIFQxODddICBkdW1wX3N0YWNrKzB4MTkwLzB4MjFjClsgIDEzNy41Mjk0ODhdWyAgVDE4
N10gIHByaW50X2FkZHJlc3NfZGVzY3JpcHRpb24uaXNyYS42KzB4ODAvMHgzZDAKWyAgMTM3
LjUyOTQ5Nl1bICBUMTg3XSAgX19rYXNhbl9yZXBvcnQrMHgxNzQvMHgyM2MKWyAgMTM3LjUy
OTUwM11bICBUMTg3XSAga2FzYW5fcmVwb3J0KzB4Yy8weDE4ClsgIDEzNy41Mjk1MTFdWyAg
VDE4N10gIF9fYXNhbl9sb2FkNCsweGE0LzB4YjAKWyAgMTM3LjUyOTUxN11bICBUMTg3XSAg
YXRhX2xpbmtfbmV4dCsweDVjLzB4MWIwClsgIDEzNy41Mjk1MjZdWyAgVDE4N10gIGF0YV9z
Y3NpX3NjYW5faG9zdCsweDUwLzB4MmQwClsgIDEzNy41Mjk1MzNdWyAgVDE4N10gIGFzeW5j
X3BvcnRfcHJvYmUrMHg3Yy8weGE4ClsgIDEzNy41Mjk1NDFdWyAgVDE4N10gIGFzeW5jX3J1
bl9lbnRyeV9mbisweDExOC8weDM0MApbICAxMzcuNTI5NTQ5XVsgIFQxODddICBwcm9jZXNz
X29uZV93b3JrKzB4N2I4LzB4ZGI4ClsgIDEzNy41Mjk1NTZdWyAgVDE4N10gIHdvcmtlcl90
aHJlYWQrMHg0MTQvMHg2YjgKWyAgMTM3LjUyOTU2Ml1bICBUMTg3XSAga3RocmVhZCsweDFk
NC8weDFmMApbICAxMzcuNTI5NTcwXVsgIFQxODddICByZXRfZnJvbV9mb3JrKzB4MTAvMHgx
OApbICAxMzcuNTI5NTc0XVsgIFQxODddIApbICAxMzcuNTI5NTgwXVsgIFQxODddIEFsbG9j
YXRlZCBieSB0YXNrIDE2OgpbICAxMzcuNTI5NTg5XVsgIFQxODddICBzYXZlX3N0YWNrKzB4
MjgvMHhiMApbICAxMzcuNTI5NTk3XVsgIFQxODddICBfX2thc2FuX2ttYWxsb2MuaXNyYS45
KzB4YTAvMHhjOApbICAxMzcuNTI5NjA0XVsgIFQxODddICBrYXNhbl9zbGFiX2FsbG9jKzB4
MTQvMHgyMApbICAxMzcuNTI5NjEyXVsgIFQxODddICBrbWVtX2NhY2hlX2FsbG9jKzB4MjVj
LzB4NDIwClsgIDEzNy41Mjk2MjBdWyAgVDE4N10gIF9fcHJvY19jcmVhdGUrMHg0MzAvMHg0
NTgKWyAgMTM3LjUyOTYyN11bICBUMTg3XSAgcHJvY19ta2Rpcl9kYXRhKzB4NTAvMHhmMApb
ICAxMzcuNTI5NjM0XVsgIFQxODddICBwcm9jX21rZGlyKzB4MmMvMHgzOApbICAxMzcuNTI5
NjQyXVsgIFQxODddICByZWdpc3Rlcl9pcnFfcHJvYysweDEwNC8weDI3OApbICAxMzcuNTI5
NjUwXVsgIFQxODddICBfX3NldHVwX2lycSsweGFmYy8weGU4MApbICAxMzcuNTI5NjU3XVsg
IFQxODddICByZXF1ZXN0X3RocmVhZGVkX2lycSsweDE5OC8weDIxOApbICAxMzcuNTI5NjY2
XVsgIFQxODddICBkZXZtX3JlcXVlc3RfdGhyZWFkZWRfaXJxKzB4YjAvMHgxMjAKWyAgMTM3
LjUyOTY3NF1bICBUMTg3XSAgYWhjaV9ob3N0X2FjdGl2YXRlKzB4MWNjLzB4MjkwClsgIDEz
Ny41Mjk2ODJdWyAgVDE4N10gIGFoY2lfaW5pdF9vbmUrMHgxMzU4LzB4MTU3MApbICAxMzcu
NTI5NjkxXVsgIFQxODddICBsb2NhbF9wY2lfcHJvYmUrMHg3OC8weGYwClsgIDEzNy41Mjk2
OThdWyAgVDE4N10gIHdvcmtfZm9yX2NwdV9mbisweDMwLzB4NTAKWyAgMTM3LjUyOTcwNV1b
ICBUMTg3XSAgcHJvY2Vzc19vbmVfd29yaysweDdiOC8weGRiOApbICAxMzcuNTI5NzEzXVsg
IFQxODddICB3b3JrZXJfdGhyZWFkKzB4NGE4LzB4NmI4ClsgIDEzNy41Mjk3MTldWyAgVDE4
N10gIGt0aHJlYWQrMHgxZDQvMHgxZjAKWyAgMTM3LjUyOTcyNl1bICBUMTg3XSAgcmV0X2Zy
b21fZm9yaysweDEwLzB4MTgKWyAgMTM3LjUyOTcyOV1bICBUMTg3XSAKWyAgMTM3LjUyOTcz
NF1bICBUMTg3XSBGcmVlZCBieSB0YXNrIDA6ClsgIDEzNy41Mjk3MzddWyAgVDE4N10gKHN0
YWNrIGlzIG5vdCBhdmFpbGFibGUpClsgIDEzNy41Mjk3NDFdWyAgVDE4N10gClsgIDEzNy41
Mjk3NDddWyAgVDE4N10gVGhlIGJ1Z2d5IGFkZHJlc3MgYmVsb25ncyB0byB0aGUgb2JqZWN0
IGF0IGZmZmYwMDIzMjAwNzNiNjgKWyAgMTM3LjUyOTc0N11bICBUMTg3XSAgd2hpY2ggYmVs
b25ncyB0byB0aGUgY2FjaGUgcHJvY19kaXJfZW50cnkgb2Ygc2l6ZSAyNTYKWyAgMTM3LjUy
OTc1NV1bICBUMTg3XSBUaGUgYnVnZ3kgYWRkcmVzcyBpcyBsb2NhdGVkIDk2IGJ5dGVzIHRv
IHRoZSByaWdodCBvZgpbICAxMzcuNTI5NzU1XVsgIFQxODddICAyNTYtYnl0ZSByZWdpb24g
W2ZmZmYwMDIzMjAwNzNiNjgsIGZmZmYwMDIzMjAwNzNjNjgpClsgIDEzNy41Mjk3NTldWyAg
VDE4N10gVGhlIGJ1Z2d5IGFkZHJlc3MgYmVsb25ncyB0byB0aGUgcGFnZToKWyAgMTM3LjUy
OTc2OF1bICBUMTg3XSBwYWdlOmZmZmZmZTAwOGM2MDFjMDAgcmVmY291bnQ6MSBtYXBjb3Vu
dDowIG1hcHBpbmc6ZmZmZjAwMjBiZjFiODQ4MCBpbmRleDoweGZmZmYwMDIzMjAwNzA5ODgg
Y29tcG91bmRfbWFwY291bnQ6IDAKWyAgMTM3LjUyOTc3OV1bICBUMTg3XSBmbGFnczogMHgx
ZmZmZjAwMDAwMDEwMjAwKHNsYWJ8aGVhZCkKWyAgMTM3LjUyOTc5MV1bICBUMTg3XSByYXc6
IDFmZmZmMDAwMDAwMTAyMDAgZmZmZjAwMjBiZjFhM2NkMCBmZmZmZmUwMDhjNjEyMjA4IGZm
ZmYwMDIwYmYxYjg0ODAKWyAgMTM3LjUyOTgwMV1bICBUMTg3XSByYXc6IGZmZmYwMDIzMjAw
NzA5ODggMDAwMDAwMDAwMDM1MDAwYiAwMDAwMDAwMWZmZmZmZmZmIDAwMDAwMDAwMDAwMDAw
MDAKWyAgMTM3LjUyOTgwNV1bICBUMTg3XSBwYWdlIGR1bXBlZCBiZWNhdXNlOiBrYXNhbjog
YmFkIGFjY2VzcyBkZXRlY3RlZApbICAxMzcuNTI5ODA5XVsgIFQxODddIApbICAxMzcuNTI5
ODEyXVsgIFQxODddIE1lbW9yeSBzdGF0ZSBhcm91bmQgdGhlIGJ1Z2d5IGFkZHJlc3M6Clsg
IDEzNy41Mjk4MjBdWyAgVDE4N10gIGZmZmYwMDIzMjAwNzNiODA6IDAwIDAwIDAwIDAwIDAw
IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwClsgIDEzNy41Mjk4MjddWyAgVDE4
N10gIGZmZmYwMDIzMjAwNzNjMDA6IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
IDAwIDAwIGZjIGZjIGZjClsgIDEzNy41Mjk4MzVdWyAgVDE4N10gPmZmZmYwMDIzMjAwNzNj
ODA6IGZjIGZjIGZjIGZjIGZjIGZjIGZjIGZjIGZjIGZjIGZjIGZjIGZjIGZjIGZjIGZjClsg
IDEzNy41Mjk4MzldWyAgVDE4N10gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIF4KWyAgMTM3LjUyOTg0Nl1bICBUMTg3XSAgZmZmZjAwMjMyMDA3M2Qw
MDogZmMgZmMgZmMgZmMgZmMgZmMgZmMgZmMgZmMgZmMgZmMgZmMgZmMgZmMgZmMgZmMKWyAg
MTM3LjUyOTg1M11bICBUMTg3XSAgZmZmZjAwMjMyMDA3M2Q4MDogZmMgZmMgZmMgZmMgZmMg
ZmMgZmMgZmMgZmMgZmMgZmMgZmMgZmMgZmMgZmMgZmMKWyAgMTM3LjUyOTg1N11bICBUMTg3
XSA9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT0KWyAgMTM3LjUyOTg3NF1bICBUMTg3XSBVbmFibGUgdG8gaGFuZGxl
IGtlcm5lbCBwYWdpbmcgcmVxdWVzdCBhdCB2aXJ0dWFsIGFkZHJlc3MgMDAwMDA0YTAyYTAw
NDBiYQpbICAxMzcuNTI5ODgzXVsgIFQxODddIE1lbSBhYm9ydCBpbmZvOgpbICAxMzcuNTI5
ODkzXVsgIFQxODddICAgRVNSID0gMHg5NjAwMDAwNApbICAxMzcuNTI5OTA1XVsgIFQxODdd
ICAgRUMgPSAweDI1OiBEQUJUIChjdXJyZW50IEVMKSwgSUwgPSAzMiBiaXRzClsgIDEzNy41
Mjk5MTVdWyAgVDE4N10gICBTRVQgPSAwLCBGblYgPSAwClsgIDEzNy41Mjk5MjVdWyAgVDE4
N10gICBFQSA9IDAsIFMxUFRXID0gMApbICAxMzcuNTI5OTM0XVsgIFQxODddIERhdGEgYWJv
cnQgaW5mbzoKWyAgMTM3LjUyOTk0MF1bICAgVDE2XSBrb2JqZWN0OiAnMTc3JyAoKF9fX19w
dHJ2YWxfX19fKSk6IGtvYmplY3RfYWRkX2ludGVybmFsOiBwYXJlbnQ6ICdpcnEnLCBzZXQ6
ICc8TlVMTD4nClsgIDEzNy41Mjk5NDVdWyAgVDE4N10gICBJU1YgPSAwLCBJU1MgPSAweDAw
MDAwMDA0ClsgIDEzNy41Mjk5NTVdWyAgVDE4N10gICBDTSA9IDAsIFduUiA9IDAKWyAgMTM3
LjUyOTk2Nl1bICBUMTg3XSBbMDAwMDA0YTAyYTAwNDBiYV0gdXNlciBhZGRyZXNzIGJ1dCBh
Y3RpdmVfbW0gaXMgc3dhcHBlcgpbICAxMzcuNTI5OTc5XVsgIFQxODddIEludGVybmFsIGVy
cm9yOiBPb3BzOiA5NjAwMDAwNCBbIzFdIFBSRUVNUFQgU01QClsgIDEzNy41Mjk5ODVdWyAg
VDE4N10gTW9kdWxlcyBsaW5rZWQgaW46ClsgIDEzNy41Mjk5OTZdWyAgVDE4N10gQ1BVOiAz
OCBQSUQ6IDE4NyBDb21tOiBrd29ya2VyL3UxOTQ6MCBUYWludGVkOiBHICAgIEIgICBXICAg
ICAgICAgNS40LjAtcmMzKyAjMTE0OQpbICAxMzcuNTMwMDAyXVsgIFQxODddIEhhcmR3YXJl
IG5hbWU6IEh1YXdlaSBEMDYgL0QwNiwgQklPUyBIaXNpbGljb24gRDA2IFVFRkkgUkMwIC0g
VjEuMTYuMDEgMDMvMTUvMjAxOQpbICAxMzcuNTMwMDExXVsgIFQxODddIFdvcmtxdWV1ZTog
ZXZlbnRzX3VuYm91bmQgYXN5bmNfcnVuX2VudHJ5X2ZuClsgIDEzNy41MzAwMjBdWyAgVDE4
N10gcHN0YXRlOiA0MDgwMDAwOSAoblpjdiBkYWlmIC1QQU4gK1VBTykKWyAgMTM3LjUzMDAy
Nl1bICBUMTg3XSBwYyA6IGF0YV9kZXZfbmV4dCsweGY4LzB4MWY4ClsgIDEzNy41MzAwMzNd
WyAgVDE4N10gbHIgOiBhdGFfZGV2X25leHQrMHhmOC8weDFmOApbICAxMzcuNTMwMDM3XVsg
IFQxODddIHNwIDogZmZmZjAwMjBiZGRhZmI4MApbICAxMzcuNTMwMDQyXVsgIFQxODddIHgy
OTogZmZmZjAwMjBiZGRhZmI4MCB4Mjg6IDAwMDAwMDAwMDAwMDAwMDAgClsgIDEzNy41MzAw
NTBdWyAgVDE4N10geDI3OiAwMDAwMDAwMDAwMDAzY2MwIHgyNjogZmZmZmEwMDAxNTAxNjAw
MCAKWyAgMTM3LjUzMDA1OV1bICBUMTg3XSB4MjU6IDAwMDAwMDAwMDAwMDIwYzAgeDI0OiBm
ZmZmYTAwMDExMzEwMmE4IApbICAxMzcuNTMwMDY4XVsgIFQxODddIHgyMzogMzUwMDA0YTAy
YTAwMDNmYSB4MjI6IGZmZmZhMDAwMTEzMzVkYjAgClsgIDEzNy41MzAwNzddWyAgVDE4N10g
eDIxOiBmZmZmYTAwMDExMzM1NmYwIHgyMDogMDAwMDAwMDAwMDAwMDAwMCAKWyAgMTM3LjUz
MDA4NV1bICBUMTg3XSB4MTk6IGZmZmZhMDAwMTEzMzY4MzAgeDE4OiAwMDAwMDAwMDAwMDAy
NWE4IApbICAxMzcuNTMwMDk0XVsgIFQxODddIHgxNzogMDAwMDAwMDAwMDAwMjVhMCB4MTY6
IDAwMDAwMDAwMDAwMDI2YjAgClsgIDEzNy41MzAxMDJdWyAgVDE4N10geDE1OiAwMDAwMDAw
MDAwMDAxNDcwIHgxNDogM2QzZDNkM2QzZDNkM2QzZCAKWyAgMTM3LjUzMDExMV1bICBUMTg3
XSB4MTM6IDNkM2QzZDNkM2QzZDNkM2QgeDEyOiAxZmZmZTAwNDE3YmI1ZjNlIApbICAxMzcu
NTMwMTIwXVsgIFQxODddIHgxMTogZmZmZjgwMDQxN2JiNWYzZSB4MTA6IGRmZmZhMDAwMDAw
MDAwMDAgClsgIDEzNy41MzAxMjldWyAgVDE4N10geDkgOiBmZmZmODAwNDE3YmI1ZjNmIHg4
IDogMDAwMDAwMDAwMDAwMDAwMSAKWyAgMTM3LjUzMDEzOF1bICBUMTg3XSB4NyA6IDAwMDAw
MDAwMDAwMDNjZDAgeDYgOiAwMDAwMDAwMDAwMDAwMDAwIApbICAxMzcuNTMwMTQ2XVsgIFQx
ODddIHg1IDogZmZmZmEwMDAxNTAxNWNjOCB4NCA6IDAwMDAwMDAwMDAwMDAwMDAgClsgIDEz
Ny41MzAxNTVdWyAgVDE4N10geDMgOiBmZmZmYTAwMDExMzAxNjA4IHgyIDogMDAwMDAwMDAw
MDAwMDAwMCAKWyAgMTM3LjUzMDE2M11bICBUMTg3XSB4MSA6IDIxZjA0NWM0MDI3Zjk1MDAg
eDAgOiAwMDAwMDAwMDAwMDAwMDAwIApbICAxMzcuNTMwMTcxXVsgIFQxODddIENhbGwgdHJh
Y2U6ClsgIDEzNy41MzAxNzhdWyAgVDE4N10gIGF0YV9kZXZfbmV4dCsweGY4LzB4MWY4Clsg
IDEzNy41MzAxODddWyAgVDE4N10gIGF0YV9zY3NpX3NjYW5faG9zdCsweDZjLzB4MmQwClsg
IDEzNy41MzAxOTRdWyAgVDE4N10gIGFzeW5jX3BvcnRfcHJvYmUrMHg3Yy8weGE4ClsgIDEz
Ny41MzAyMDJdWyAgVDE4N10gIGFzeW5jX3J1bl9lbnRyeV9mbisweDExOC8weDM0MApbICAx
MzcuNTMwMjA5XVsgIFQxODddICBwcm9jZXNzX29uZV93b3JrKzB4N2I4LzB4ZGI4ClsgIDEz
Ny41MzAyMTZdWyAgVDE4N10gIHdvcmtlcl90aHJlYWQrMHg0MTQvMHg2YjgKWyAgMTM3LjUz
MDIyM11bICBUMTg3XSAga3RocmVhZCsweDFkNC8weDFmMApbICAxMzcuNTMwMjMwXVsgIFQx
ODddICByZXRfZnJvbV9mb3JrKzB4MTAvMHgxOApbICAxMzcuNTMwMjQyXVsgIFQxODddIENv
ZGU6IDk3YzU0NGY2IGQyODc5ODAxIDhiMDEwMmUwIDk3Y2Q0ZmI1IChmOTVlNjJlMCkgClsg
IDEzNy41MzA0NzJdWyAgVDE4N10gLS0tWyBlbmQgdHJhY2UgMTcwMjQ0MWNmN2MyY2Q4OSBd
LS0tClsgIDEzNy41MzA0NzldWyAgVDE4N10gS2VybmVsIHBhbmljIC0gbm90IHN5bmNpbmc6
IEZhdGFsIGV4Y2VwdGlvbgpbICAxMzcuNTMwNTkyXVsgICBUMTZdIGtvYmplY3Q6ICcxNzgn
ICgoX19fX3B0cnZhbF9fX18pKToga29iamVjdF9hZGRfaW50ZXJuYWw6IHBhcmVudDogJ2ly
cScsIHNldDogJzxOVUxMPicKWyAgMTM3LjUzMDY1M11bICBUMTg3XSBTTVA6IHN0b3BwaW5n
IHNlY29uZGFyeSBDUFVzClsgIDEzNy41MzEwNzhdWyAgVDE4N10gS2VybmVsIE9mZnNldDog
ZGlzYWJsZWQKWyAgMTM3LjUzMTA4NV1bICBUMTg3XSBDUFUgZmVhdHVyZXM6IDB4MDAwMiwy
MzIwOGEzOApbICAxMzcuNTMxMDg5XVsgIFQxODddIE1lbW9yeSBMaW1pdDogbm9uZQpbICAx
NDMuNjk5MDc5XVsgIFQxODddIC0tLVsgZW5kIEtlcm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5n
OiBGYXRhbCBleGNlcHRpb24gXS0tLQoKCg==
--------------CDBF7B7193330D052C41DACD--
