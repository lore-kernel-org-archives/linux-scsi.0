From: "Bean Huo (beanhuo)" <beanhuo@micron.com>
Subject: UFS maximum access unit is 8KB
Date: Wed, 9 Aug 2017 07:28:23 +0000
Message-ID: <8c02dc5ce8244920b9fb34fae3b87ffc@SIWEX5A.sing.micron.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.micron.com ([137.201.242.129]:57940 "EHLO
        mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750879AbdHIHpQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Aug 2017 03:45:16 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>

Hi,
I am now using one hikey960, and Linux kernel version is 4.4.77.
And found that for UFS driver version, the maximum transformation is 8KB.
Means that if I using 128KB chuck size to program in the user space, but, from ftrace/blktrace, 
It shows that it always programs by 8KB in kernel. please see below log, who knows where is wrong with it?

24992.855327 |   7)               |  vfs_read() {
24992.855340 |   7) + 89.584 us   |    submit_bio();
24992.855432 |   7)               |  /* block_rq_insert: 8,48 R 0 () 40676352 + 16 [fio] */
24992.855434 |   7)               |  /* block_rq_insert: 8,48 R 0 () 40676368 + 16 [fio] */
24992.855435 |   7)               |  /* block_rq_insert: 8,48 R 0 () 40676384 + 16 [fio] */
24992.855437 |   7)               |  /* block_rq_insert: 8,48 R 0 () 40676400 + 16 [fio] */
24992.855438 |   7)               |  /* block_rq_insert: 8,48 R 0 () 40676416 + 16 [fio] */
24992.855439 |   7)               |  /* block_rq_insert: 8,48 R 0 () 40676432 + 16 [fio] */
24992.855440 |   7)               |  /* block_rq_insert: 8,48 R 0 () 40676448 + 16 [fio] */
24992.855441 |   7)               |  /* block_rq_insert: 8,48 R 0 () 40676464 + 16 [fio] */
24992.855443 |   7)               |  /* block_rq_insert: 8,48 R 0 () 40676480 + 16 [fio] */
24992.855443 |   7)               |  /* block_rq_insert: 8,48 R 0 () 40676496 + 16 [fio] */
24992.855444 |   7)               |  /* block_rq_insert: 8,48 R 0 () 40676512 + 16 [fio] */
24992.855445 |   7)               |  /* block_rq_insert: 8,48 R 0 () 40676528 + 16 [fio] */
24992.855446 |   7)               |  /* block_rq_insert: 8,48 R 0 () 40676544 + 16 [fio] */
24992.855447 |   7)               |  /* block_rq_insert: 8,48 R 0 () 40676560 + 16 [fio] */
24992.855448 |   7)               |  /* block_rq_insert: 8,48 R 0 () 40676576 + 16 [fio] */
24992.855449 |   7)               |  /* block_rq_insert: 8,48 R 0 () 40676592 + 16 [fio] */
24992.855451 |   7)               |    __blk_run_queue() {
24992.855451 |   7)               |      scsi_request_fn() {
24992.855453 |   7)               |        /* block_rq_issue: 8,48 R 0 () 40676352 + 16 [fio] */
24992.855456 |   7)               |        scsi_dispatch_cmd() {
24992.855457 |   7)               |          /* scsi_dispatch_cmd_start: host_no=0 channel=0 id=0 lun=3 data_sgl=2 prot_sgl=0 prot_op=SCSI_PROT_NORMAL cmnd=(READ_10 lba=5084544 txlen=2 protect=0 raw=28 00 00 4d 95 80 00 00 02 00) */
24992.855459 |   7) + 15.104 us   |          scsi_dma_map();
24992.855476 |   7) + 19.271 us   |        }
24992.855478 |   7)               |        /* block_rq_issue: 8,48 R 0 () 40676368 + 16 [fio] */
24992.855481 |   7)               |        scsi_dispatch_cmd() {
24992.855481 |   7)               |          /* scsi_dispatch_cmd_start: host_no=0 channel=0 id=0 lun=3 data_sgl=2 prot_sgl=0 prot_op=SCSI_PROT_NORMAL cmnd=(READ_10 lba=5084546 txlen=2 protect=0 raw=28 00 00 4d 95 82 00 00 02 00) */
24992.855483 |   7)   2.083 us    |          scsi_dma_map();
24992.855486 |   7)   5.730 us    |        }
24992.855488 |   7)               |        /* block_rq_issue: 8,48 R 0 () 40676384 + 16 [fio] */
24992.855489 |   7)               |        scsi_dispatch_cmd() {
24992.855490 |   7)               |          /* scsi_dispatch_cmd_start: host_no=0 channel=0 id=0 lun=3 data_sgl=2 prot_sgl=0 prot_op=SCSI_PROT_NORMAL cmnd=(READ_10 lba=5084548 txlen=2 protect=0 raw=28 00 00 4d 95 84 00 00 02 00) */
24992.855491 |   7)   2.083 us    |          scsi_dma_map();
24992.855495 |   7)   5.209 us    |        }
24992.855497 |   7)               |        /* block_rq_issue: 8,48 R 0 () 40676400 + 16 [fio] */
24992.855498 |   7)               |        scsi_dispatch_cmd() {
24992.855499 |   7)               |          /* scsi_dispatch_cmd_start: host_no=0 channel=0 id=0 lun=3 data_sgl=2 prot_sgl=0 prot_op=SCSI_PROT_NORMAL cmnd=(READ_10 lba=5084550 txlen=2 protect=0 raw=28 00 00 4d 95 86 00 00 02 00) */
24992.855500 |   7)   2.083 us    |          scsi_dma_map();
24992.855503 |   7)   5.208 us    |        }
24992.855505 |   7)               |        /* block_rq_issue: 8,48 R 0 () 40676416 + 16 [fio] */
24992.855507 |   7)               |        scsi_dispatch_cmd() {
24992.855508 |   7)               |          /* scsi_dispatch_cmd_start: host_no=0 channel=0 id=0 lun=3 data_sgl=2 prot_sgl=0 prot_op=SCSI_PROT_NORMAL cmnd=(READ_10 lba=5084552 txlen=2 protect=0 raw=28 00 00 4d 95 88 00 00 02 00) */
24992.855509 |   7)   2.084 us    |          scsi_dma_map();
24992.855513 |   7)   5.208 us    |        }
24992.855514 |   7)               |        /* block_rq_issue: 8,48 R 0 () 40676432 + 16 [fio] */
24992.855516 |   7)               |        scsi_dispatch_cmd() {
24992.855516 |   7)               |          /* scsi_dispatch_cmd_start: host_no=0 channel=0 id=0 lun=3 data_sgl=2 prot_sgl=0 prot_op=SCSI_PROT_NORMAL cmnd=(READ_10 lba=5084554 txlen=2 protect=0 raw=28 00 00 4d 95 8a 00 00 02 00) */
24992.855518 |   7)   2.083 us    |          scsi_dma_map();
24992.855521 |   7)   5.208 us    |        }
24992.855524 |   7)               |        /* block_rq_issue: 8,48 R 0 () 40676448 + 16 [fio] */
24992.855526 |   7)               |        scsi_dispatch_cmd() {
24992.855526 |   7)               |          /* scsi_dispatch_cmd_start: host_no=0 channel=0 id=0 lun=3 data_sgl=2 prot_sgl=0 prot_op=SCSI_PROT_NORMAL cmnd=(READ_10 lba=5084556 txlen=2 protect=0 raw=28 00 00 4d 95 8c 00 00 02 00) */
24992.855528 |   7)   1.563 us    |          scsi_dma_map();
24992.855532 |   7)   5.208 us    |        }
24992.855533 |   7)               |        /* block_rq_issue: 8,48 R 0 () 40676464 + 16 [fio] */
24992.855535 |   7)               |        scsi_dispatch_cmd() {
24992.855536 |   7)               |          /* scsi_dispatch_cmd_start: host_no=0 channel=0 id=0 lun=3 data_sgl=2 prot_sgl=0 prot_op=SCSI_PROT_NORMAL cmnd=(READ_10 lba=5084558 txlen=2 protect=0 raw=28 00 00 4d 95 8e 00 00 02 00) */
24992.855537 |   7)   2.083 us    |          scsi_dma_map();
24992.855541 |   7)   4.687 us    |        }
24992.855543 |   7)               |        /* block_rq_issue: 8,48 R 0 () 40676480 + 16 [fio] */
24992.855545 |   7)               |        scsi_dispatch_cmd() {
24992.855545 |   7)               |          /* scsi_dispatch_cmd_start: host_no=0 channel=0 id=0 lun=3 data_sgl=2 prot_sgl=0 prot_op=SCSI_PROT_NORMAL cmnd=(READ_10 lba=5084560 txlen=2 protect=0 raw=28 00 00 4d 95 90 00 00 02 00) */
24992.855546 |   7)   2.084 us    |          scsi_dma_map();
24992.855550 |   7)   4.687 us    |        }
24992.855551 |   7)               |        /* block_rq_issue: 8,48 R 0 () 40676496 + 16 [fio] */
24992.855553 |   7)               |        scsi_dispatch_cmd() {
24992.855553 |   7)               |          /* scsi_dispatch_cmd_start: host_no=0 channel=0 id=0 lun=3 data_sgl=2 prot_sgl=0 prot_op=SCSI_PROT_NORMAL cmnd=(READ_10 lba=5084562 txlen=2 protect=0 raw=28 00 00 4d 95 92 00 00 02 00) */
24992.855555 |   7)   2.083 us    |          scsi_dma_map();
24992.855559 |   7)   5.208 us    |        }
24992.855560 |   7)               |        /* block_rq_issue: 8,48 R 0 () 40676512 + 16 [fio] */
24992.855562 |   7)               |        scsi_dispatch_cmd() {
24992.855562 |   7)               |          /* scsi_dispatch_cmd_start: host_no=0 channel=0 id=0 lun=3 data_sgl=2 prot_sgl=0 prot_op=SCSI_PROT_NORMAL cmnd=(READ_10 lba=5084564 txlen=2 protect=0 raw=28 00 00 4d 95 94 00 00 02 00) */
24992.855563 |   7)   2.083 us    |          scsi_dma_map();
24992.855568 |   7)   4.688 us    |        }
24992.855569 |   7)               |        /* block_rq_issue: 8,48 R 0 () 40676528 + 16 [fio] */
24992.855571 |   7)               |        scsi_dispatch_cmd() {
24992.855571 |   7)               |          /* scsi_dispatch_cmd_start: host_no=0 channel=0 id=0 lun=3 data_sgl=2 prot_sgl=0 prot_op=SCSI_PROT_NORMAL cmnd=(READ_10 lba=5084566 txlen=2 protect=0 raw=28 00 00 4d 95 96 00 00 02 00) */
24992.855572 |   7)   2.083 us    |          scsi_dma_map();
24992.855576 |   7)   5.208 us    |        }
24992.855577 |   7)               |        /* block_rq_issue: 8,48 R 0 () 40676544 + 16 [fio] */
24992.855578 |   0)               |  ufshcd_intr() {
24992.855580 |   7)               |        scsi_dispatch_cmd() {
24992.855580 |   7)               |          /* scsi_dispatch_cmd_start: host_no=0 channel=0 id=0 lun=3 data_sgl=2 prot_sgl=0 prot_op=SCSI_PROT_NORMAL cmnd=(READ_10 lba=5084568 txlen=2 protect=0 raw=28 00 00 4d 95 98 00 00 02 00) */
24992.855585 |   0)   4.166 us    |    scsi_dma_unmap();
24992.855595 |   0)               |  /* scsi_dispatch_cmd_done: host_no=0 channel=0 id=0 lun=3 data_sgl=2 prot_sgl=0 prot_op=SCSI_PROT_NORMAL cmnd=(READ_10 lba=5084544 txlen=2 protect=0 raw=28 00 00 4d 95 80 00 00 02 00) result=(driver=DRIVER_OK host=DID_OK message=COMMAND_COMPLETE status=SAM_STAT_GOOD) */
24992.855602 |   0) + 21.875 us   |  } 
