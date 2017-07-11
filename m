From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: Re: [PATCHv2] tcmu: Fix possbile memory leak when recalculating the
 cmd base size
Date: Tue, 11 Jul 2017 10:55:52 -0500
Message-ID: <4371be17-d3c7-5492-8cea-e983a2cbab17@linux.vnet.ibm.com>
References: <1499767183-17980-1-git-send-email-lixiubo@cmss.chinamobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1499767183-17980-1-git-send-email-lixiubo@cmss.chinamobile.com>
Content-Language: en-US
Sender: target-devel-owner@vger.kernel.org
To: lixiubo@cmss.chinamobile.com, nab@linux-iscsi.org, mchristi@redhat.com
Cc: damien.lemoal@wdc.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


> From: Xiubo Li <lixiubo@cmss.chinamobile.com>
>
> For all the entries allocated from the ring cmd area, the memory is
> something like the stack memory, which will always reserve the old
> data, so the entry->req.iov_bidi_cnt maybe none zero.
>
> On some environments, the crash could be reporduce very easy and some
> not. The following is the crash core trace:
>
> [  240.143969] CPU: 0 PID: 1285 Comm: iscsi_trx Not tainted
> 4.12.0-rc1+ #3
> [  240.150607] Hardware name: ASUS All Series/H87-PRO, BIOS 2104
> 10/28/2014
> [  240.157331] task: ffff8807de4f5800 task.stack:
> ffffc900047dc000
> [  240.163270] RIP: 0010:memcpy_erms+0x6/0x10
> [  240.167377] RSP: 0018:ffffc900047dfc68 EFLAGS: 00010202
> [  240.172621] RAX: ffffc9065db85540 RBX: ffff8807f7980000 RCX:
> 0000000000000010
> [  240.179771] RDX: 0000000000000010 RSI: ffff8807de574fe0 RDI:
> ffffc9065db85540
> [  240.186930] RBP: ffffc900047dfd30 R08: ffff8807de41b000 R09:
> 0000000000000000
> [  240.194088] R10: 0000000000000040 R11: ffff8807e9b726f0 R12:
> 00000006565726b0
> [  240.201246] R13: ffffc90007612ea0 R14: 000000065657d540 R15:
> 0000000000000000
> [  240.208397] FS:  0000000000000000(0000)
> GS:ffff88081fa00000(0000)
> knlGS:0000000000000000
> [  240.216510] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  240.222280] CR2: ffffc9065db85540 CR3: 0000000001c0f000 CR4:
> 00000000001406f0
> [  240.229430] Call Trace:
> [  240.231887]  ? tcmu_queue_cmd+0x83c/0xa80
> [  240.235916]  ? target_check_reservation+0xcd/0x6f0
> [  240.240725]  __target_execute_cmd+0x27/0xa0
> [  240.244918]  target_execute_cmd+0x232/0x2c0
> [  240.249124]  ? __local_bh_enable_ip+0x64/0xa0
> [  240.253499]  iscsit_execute_cmd+0x20d/0x270
> [  240.257693]  iscsit_sequence_cmd+0x110/0x190
> [  240.261985]  iscsit_get_rx_pdu+0x360/0xc80
> [  240.267565]  ? iscsi_target_rx_thread+0x54/0xd0
> [  240.273571]  iscsi_target_rx_thread+0x9a/0xd0
> [  240.279413]  kthread+0x113/0x150
> [  240.284120]  ? iscsi_target_tx_thread+0x1e0/0x1e0
> [  240.290297]  ? kthread_create_on_node+0x40/0x40
> [  240.296297]  ret_from_fork+0x2e/0x40
> [  240.301332] Code: 90 90 90 90 90 eb 1e 0f 1f 00 48 89 f8 48
> 89 d1 48
> c1 e9 03 83 e2 07 f3 48 a5 89 d1 f3 a4 c3 66 0f 1f 44 00 00 48
> 89 f8 48
> 89 d1 <f3> a4 c3 0f 1f 80 00 00 00 00 48 89 f8 48 83 fa 20 72 7e
> 40 38
> [  240.321751] RIP: memcpy_erms+0x6/0x10 RSP: ffffc900047dfc68
> [  240.328838] CR2: ffffc9065db85540
> [  240.333667] ---[ end trace b7e5354cfb54d08b ]---
>
> To fix this, just memset all the entry memory before using it, and
> also to be more readable we adjust the bidi code.
>
> Fixed: fe25cc34795(tcmu: Recalculate the tcmu_cmd size to save cmd area
> 		memories)
> Reported-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
> Tested-by: Damien Le Moal <damien.lemoal@wdc.com>
> Signed-off-by: Xiubo Li <lixiubo@cmss.chinamobile.com>
> ---
>   drivers/target/target_core_user.c | 12 +++++-------
>   1 file changed, 5 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index 2f1fa92..3b25ef3 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c

Nice! This has fixed our long standing issue with not being able to boot with the global data area support on power.

Tested-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>

-Bryant
