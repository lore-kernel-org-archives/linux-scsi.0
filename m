From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 2/3] libiscsi, iser: Adjust data_length to include
 protection information
Date: Mon, 23 Jun 2014 13:59:48 -0700
Message-ID: <20140623205948.GA15165@infradead.org>
References: <1402477799-24610-1-git-send-email-sagig@mellanox.com>
 <1402477799-24610-3-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1402477799-24610-3-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: michaelc@cs.wisc.edu, martin.petersen@oracle.com, nab@linux-iscsi.org, roland@kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch causes a regression when using the iscsi initiator over
TCP for me. When mounting a newly created ext4 filesystem I get the
following BUG: 

[   31.611803] BUG: unable to handle kernel NULL pointer dereference at 000000000000000c
[   31.613563] IP: [<ffffffff8197b38d>] iscsi_tcp_segment_done+0x2bd/0x380
[   31.613563] PGD 7a3e4067 PUD 7a45f067 PMD 0 
[   31.613563] Oops: 0000 [#1] SMP 
[   31.613563] Modules linked in:
[   31.613563] CPU: 3 PID: 3739 Comm: kworker/u8:5 Not tainted 3.16.0-rc2 #187
[   31.613563] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[   31.613563] Workqueue: iscsi_q_2 iscsi_xmitworker
[   31.613563] task: ffff88007b33cf10 ti: ffff88007ad94000 task.ti: ffff88007ad94000
[   31.613563] RIP: 0010:[<ffffffff8197b38d>]  [<ffffffff8197b38d>] iscsi_tcp_segment_done+0x2bd/0x380
[   31.613563] RSP: 0018:ffff88007ad97b38  EFLAGS: 00010246
[   31.613563] RAX: 0000000000000000 RBX: ffff88007cd67910 RCX: 0000000000000200
[   31.613563] RDX: 0000000000002000 RSI: 0000000000000000 RDI: ffff88007cd67910
[   31.613563] RBP: ffff88007ad97b98 R08: 0000000000000200 R09: 0000000000000000
[   31.613563] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
[   31.613563] R13: ffff88007cd67780 R14: 0000000000000000 R15: 0000000000000000
[   31.613563] FS:  0000000000000000(0000) GS:ffff88007fd80000(0000) knlGS:0000000000000000
[   31.613563] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   31.613563] CR2: 000000000000000c CR3: 000000007afd9000 CR4: 00000000000006e0
[   31.613563] Stack:
[   31.613563]  ffff88007ad97b98 ffffffff81c68fd6 ffffffff81c68f20 ffff88007c8e37c8
[   31.613563]  000000007b33d728 ffff88007dc805b0 ffff88007ad97c58 0000000000000200
[   31.613563]  ffff88007cd67780 ffff880000c00040 ffff88007ad97c00 ffff88007cd67910
[   31.613563] Call Trace:
[   31.613563]  [<ffffffff81c68fd6>] ? inet_sendpage+0xb6/0x130
[   31.613563]  [<ffffffff81c68f20>] ? inet_dgram_connect+0x80/0x80
[   31.613563]  [<ffffffff8197bd95>] iscsi_sw_tcp_pdu_xmit+0xe5/0x2e0
[   31.613563]  [<ffffffff8197badf>] ? iscsi_sw_tcp_pdu_init+0x1bf/0x390
[   31.613563]  [<ffffffff81979b82>] iscsi_tcp_task_xmit+0xa2/0x2b0
[   31.613563]  [<ffffffff81974815>] ? iscsi_xmit_task+0x45/0xd0
[   31.613563]  [<ffffffff810fbb8d>] ? trace_hardirqs_on+0xd/0x10
[   31.613563]  [<ffffffff810b54a0>] ? __local_bh_enable_ip+0x70/0xd0
[   31.613563]  [<ffffffff81974829>] iscsi_xmit_task+0x59/0xd0
[   31.613563]  [<ffffffff81978468>] iscsi_xmitworker+0x288/0x330
[   31.613563]  [<ffffffff810cc847>] process_one_work+0x1c7/0x490
[   31.613563]  [<ffffffff810cc7dd>] ? process_one_work+0x15d/0x490
[   31.613563]  [<ffffffff810cd539>] worker_thread+0x119/0x4f0
[   31.613563]  [<ffffffff810fbb8d>] ? trace_hardirqs_on+0xd/0x10
[   31.613563]  [<ffffffff810cd420>] ? init_pwq+0x190/0x190
[   31.613563]  [<ffffffff810d3c3f>] kthread+0xdf/0x100
[   31.613563]  [<ffffffff810d3b60>] ? __init_kthread_worker+0x70/0x70
[   31.613563]  [<ffffffff81d904bc>] ret_from_fork+0x7c/0xb0
[   31.613563]  [<ffffffff810d3b60>] ? __init_kthread_worker+0x70/0x70
[   31.613563] Code: 89 03 31 c0 e9 cc fe ff ff 0f 1f 44 00 00 48 8b 7b
30 e8 17 74 de ff 8b 53 10 c7 43 40 00 00 00 00 48 89 43 30 44 89 f6 48
89 df <8b> 40 0c 48 c7 03 00 00 00 00 2b 53 14 39 c2 0f 47 d0 89 53 08 


(gdb) l *(iscsi_tcp_segment_done+0x2bd)
0xffffffff8197b38d is in iscsi_tcp_segment_done
(../drivers/scsi/libiscsi_tcp.c:102).
97	iscsi_tcp_segment_init_sg(struct iscsi_segment *segment,
98				  struct scatterlist *sg, unsigned int offset)
99	{
100		segment->sg = sg;
101		segment->sg_offset = offset;
102		segment->size = min(sg->length - offset,
103				    segment->total_size - segment->total_copied);
104		segment->data = NULL;
105	}
106	
