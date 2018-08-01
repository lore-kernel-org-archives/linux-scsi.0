From: "jianchao.wang" <jianchao.w.wang@oracle.com>
Subject: Re: [next-20180727][qla2xxx][BUG] WARNING: CPU: 12 PID: 511 at
 drivers/scsi/scsi_lib.c:691 scsi_end_request+0x250/0x280
Date: Wed, 1 Aug 2018 15:19:58 +0800
Message-ID: <ea4ba28e-0b03-e0d0-a1f2-4e8cf06326b8@oracle.com>
References: <1533105183.23332.15.camel@abdul>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1533105183.23332.15.camel@abdul>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Abdul Haleem <abdhalee@linux.vnet.ibm.com>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, "Madhani, Himanshu" <himanshu.madhani@cavium.com>
Cc: linux-block <linux-block@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-next <linux-next@vger.kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel <linux-kernel@vger.kernel.org>, jejb@linux.vnet.ibm.com, Jens Axboe <axboe@kernel.dk>, dgilbert@interlog.com, "bart.vanassche" <bart.vanassche@wdc.com>, rosattig@br.ibm.com, kyle.mahlkuch@ibm.com
List-Id: linux-scsi@vger.kernel.org

Hi Abdul

On 08/01/2018 02:33 PM, Abdul Haleem wrote:
> # mkfs -t ext4 /dev/mapper/mpatha
> mke2fs 1.43.1 (08-Jun-2016)
> Found a dos partition table in /dev/mapper/mpatha
> Proceed anyway? (y,n) y
> Discarding device blocks: 
> qla2xxx [0106:a0:00.1]-801c:2: Abort command issued nexus=2:1:0 --  1 2002.
> qla2xxx [0106:a0:00.0]-801c:0: Abort command issued nexus=0:1:0 --  1 2002.
> qla2xxx [0106:a0:00.1]-801c:2: Abort command issued nexus=2:1:0 --  1 2002.
> qla2xxx [0106:a0:00.0]-801c:0: Abort command issued nexus=0:1:0 --  1 2002.
> WARNING: CPU: 12 PID: 511 at drivers/scsi/scsi_lib.c:691 scsi_end_request+0x250/0x280
...
> NIP [c000000000690080] scsi_end_request+0x250/0x280
> LR [c00000000068fe80] scsi_end_request+0x50/0x280
> Call Trace:
> [c00000027d39b600] [c00000000068fe80] scsi_end_request+0x50/0x280 (unreliable)
> [c00000027d39b660] [c0000000006904ac] scsi_io_completion+0x29c/0x7d0
> [c00000027d39b710] [c0000000006848e4] scsi_finish_command+0x104/0x1c0
> [c00000027d39b790] [c00000000068f148] scsi_softirq_done+0x198/0x1f0
> [c00000027d39b820] [c0000000004f2b80] blk_mq_complete_request+0x130/0x1d0
> [c00000027d39b860] [c00000000068d27c] scsi_mq_done+0x2c/0xe0
> [c00000027d39b890] [d000000004291080] qla2xxx_qpair_sp_compl+0xa8/0x140 [qla2xxx]
> [c00000027d39b900] [d0000000042cc9d0] qla2x00_process_completed_request+0x68/0x140 [qla2xxx]
> ------------[ cut here ]------------
> kernel BUG at block/blk-core.c:3196!

blk_finish_request

BUG_ON(blk_queued_rq(req))

We are also suffering a similar issue on qla2xxx,
the BUG_ON in blk_finish_request is triggered while there are lots of command aborted.
The root cause should be qla2xxx driver still invoke scsi_done for an aborted command
and cause race between requeue path and normal complete path.

Add Himanshu Madhani from qlogic team.
It seems that they are working on this.

Thanks
Jianchao
