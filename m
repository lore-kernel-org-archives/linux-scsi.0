From: John Stultz <john.stultz@linaro.org>
Subject: ufshcd_queuecommand() triggering after ufshcd_suspend()?
Date: Thu, 10 Jan 2019 15:02:21 -0800
Message-ID: <CALAqxLURfQcSy2w7F7NCPtGaChka4U5LmvufLd0VZ73S=AzHkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sahitya Tummala <stummala@codeaurora.org>, Christoph Hellwig <hch@lst.de>, Wei Li <liwei213@huawei.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Evan Green <evgreen@chromium.org>, Avri Altman <avri.altman@wdc.com>, Vijay Viswanath <vviswana@codeaurora.org>, lkml <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hey all,
  Frequently, since support for the HiKey960's UFS code landed in
4.19, I've noticed the following warning on reboot:

[   23.086860] WARNING: CPU: 0 PID: 2507 at
drivers/scsi/ufs/ufshcd.c:2460 ufshcd_queuecommand+0x59c/0x5a8
[   23.096256] Modules linked in:
[   23.099313] CPU: 0 PID: 2507 Comm: kworker/0:1H Tainted: G S
        5.0.0-rc1-00068-g3f81a19 #273
[   23.108873] Hardware name: HiKey960 (DT)
[   23.112802] Workqueue: kblockd blk_mq_requeue_work
[   23.117591] pstate: 80400005 (Nzcv daif +PAN -UAO)
[   23.122378] pc : ufshcd_queuecommand+0x59c/0x5a8
[   23.126990] lr : ufshcd_queuecommand+0x58c/0x5a8
[   23.131600] sp : ffffff8015e1ba80
[   23.134907] x29: ffffff8015e1ba80 x28: ffffffc217f94048
[   23.140214] x27: 0000000000000010 x26: ffffffc217a7c8b8
[   23.145520] x25: ffffffc217a7c000 x24: ffffffc217a7ceb0
[   23.150827] x23: 0000000000000000 x22: ffffffc217a7c808
[   23.156133] x21: ffffffc217f94120 x20: 0000000000000010
[   23.161440] x19: ffffff801186d000 x18: ffffff801186db08
[   23.166746] x17: 0000000000000000 x16: 0000000000000000
[   23.172053] x15: ffffff8095e1b7c7 x14: 692064616574736e
[   23.177360] x13: 6928204e4f5f534b x12: 4c43203d21206574
[   23.182666] x11: 6174732e676e6974 x10: 61675f6b6c633e2d
[   23.187973] x9 : 61626820646e616d x8 : 6d6f636575657571
[   23.193280] x7 : 0000000000000000 x6 : ffffff801186e000
[   23.198586] x5 : ffffff801186e270 x4 : ffffff8010096dc0
[   23.203894] x3 : 0000000000010000 x2 : 47dd99afde511d00
[   23.209201] x1 : 0000000000000000 x0 : 0000000000000000
[   23.214509] Call trace:
[   23.216952]  ufshcd_queuecommand+0x59c/0x5a8
[   23.221220]  scsi_queue_rq+0x5b4/0x880
[   23.224964]  blk_mq_dispatch_rq_list+0xb0/0x510
[   23.229492]  blk_mq_sched_dispatch_requests+0xf4/0x198
[   23.234626]  __blk_mq_run_hw_queue+0xb4/0x120
[   23.238978]  __blk_mq_delay_run_hw_queue+0x110/0x200
[   23.243937]  blk_mq_run_hw_queue+0xb8/0x118
[   23.248114]  blk_mq_run_hw_queues+0x58/0x78
[   23.252291]  blk_mq_requeue_work+0x140/0x168
[   23.256560]  process_one_work+0x158/0x468
[   23.260564]  worker_thread+0x50/0x460
[   23.264222]  kthread+0x104/0x130
[   23.267447]  ret_from_fork+0x10/0x1c
[   23.271017] ---[ end trace 45f1ee04059cdf00 ]---

Since the warning is triggering from the WARN_ON(hba->clk_gating.state
!= CLKS_ON) line, I annotated the clk_gating.state changes, and am
seeing on reboot:
  vdc: Waited 0ms for vold
  sd 0:0:0:3: [sdd] Synchronizing SCSI cache
  sd 0:0:0:2: [sdc] Synchronizing SCSI cache
  sd 0:0:0:1: [sdb] Synchronizing SCSI cache
  sd 0:0:0:0: [sda] Synchronizing SCSI cache
  ufshcd_suspend: setting clk_gating.state CLKS_OFF
  ufshcd_queuecommand hba->clk_gating.state != CLKS_ON (instead its 0)
<warning splat>

So it seems like ufshcd_suspend() is has run, but then the workqueue
(occasionally) fires afterwards triggering the issue.

Maybe should something in ufshcd_queuecommand be checking the
clk_gating.is_suspended flag before proceeding?

Other ideas?  The logic all seems to be in the generic code, but I'm
not sure if maybe the ufs-hisi.c code is mis-managing something?

thanks
-john
