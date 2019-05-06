From: Qian Cai <cai@lca.pw>
Subject: Re: "iommu/amd: Set exclusion range correctly" causes smartpqi
 offline
Date: Sun, 5 May 2019 22:56:28 -0400
Message-ID: <ca40e139-3b0e-01db-b3c8-df0c1a04f9e6@lca.pw>
References: <1556290348.6132.6.camel@lca.pw>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1556290348.6132.6.camel@lca.pw>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: jroedel@suse.de, hch@lst.de
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, jejb@linux.ibm.com, don.brace@microsemi.com, kevin.barnett@microsemi.com, scott.teel@microsemi.com, david.carroll@microsemi.com
List-Id: linux-scsi@vger.kernel.org

On 4/26/19 10:52 AM, Qian Cai wrote:
> Applying some memory pressure would causes smartpqi offline even in today's
> linux-next. This can always be reproduced by a LTP test cases [1] or sometimes
> just compiling kernels.
> 
> Reverting the commit "iommu/amd: Set exclusion range correctly" fixed the issue.
> 
> [  213.437112] smartpqi 0000:23:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT
> domain=0x0000 address=0x1000 flags=0x0000]
> [  213.447659] smartpqi 0000:23:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT
> domain=0x0000 address=0x1800 flags=0x0000]
> [  233.362013] smartpqi 0000:23:00.0: controller is offline: status code 0x14803
> [  233.369359] smartpqi 0000:23:00.0: controller offline
> [  233.388915] print_req_error: I/O error, dev sdb, sector 3317352 flags 2000001
> [  233.388921] sd 0:0:0:0: [sdb] tag#95 UNKNOWN(0x2003) Result: hostbyte=0x01
> driverbyte=0x00
> [  233.388931] sd 0:0:0:0: [sdb] tag#95 CDB: opcode=0x2a 2a 00 00 55 89 00 00 01
> 08 00
> [  233.389003] Write-error on swap-device (254:1:4474640)
> [  233.389015] Write-error on swap-device (254:1:2190776)
> [  233.389023] Write-error on swap-device (254:1:8351936)
> 
> [1] /opt/ltp/testcases/bin/mtest01 -p80 -w

It turned out another linux-next commit is needed to reproduce this, i.e.,
7a5dbf3ab2f0 ("iommu/amd: Remove the leftover of bypass support"). Specifically,
the chunks for map_sg() and unmap_sg(). This has been reproduced on 3 different
HPE ProLiant DL385 Gen10 systems so far.

Either reverted the chunks (map_sg() and unmap_sg()) on the top of the latest
linux-next fixed the issue or applied them on the top of the mainline v5.1
reproduced it immediately.

Lots of time it triggered this BUG_ON(!iova) in iova_magazine_free_pfns()
instead of the smartpqi offline.

    kernel BUG at drivers/iommu/iova.c:813!
    Workqueue: kblockd blk_mq_run_work_fn
    RIP: 0010:iova_magazine_free_pfns+0x7d/0xc0
    Call Trace:
     free_cpu_cached_iovas+0xbd/0x150
     alloc_iova_fast+0x8c/0xba
     dma_ops_alloc_iova.isra.6+0x65/0xa0
     map_sg+0x8c/0x2a0
     scsi_dma_map+0xc6/0x160
     pqi_aio_submit_io+0x1f6/0x440 [smartpqi]
     pqi_scsi_queue_command+0x90c/0xdd0 [smartpqi]
     scsi_queue_rq+0x79c/0x1200
     blk_mq_dispatch_rq_list+0x4dc/0xb70
     blk_mq_sched_dispatch_requests+0x249/0x310
     __blk_mq_run_hw_queue+0x128/0x200
     blk_mq_run_work_fn+0x27/0x30
     process_one_work+0x522/0xa10
     worker_thread+0x63/0x5b0
     kthread+0x1d2/0x1f0
     ret_from_fork+0x22/0x40
