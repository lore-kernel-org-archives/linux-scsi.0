From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Stack overflow when lldd returns SCSI_MLQUEUE_DEVICE_BUSY
Date: 18 May 2004 16:47:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1084916831.2101.56.camel@mulgrave>
References: <200405171523.27952.heiko.carstens@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:1180 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263633AbUERVrN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 May 2004 17:47:13 -0400
In-Reply-To: <200405171523.27952.heiko.carstens@de.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2004-05-17 at 08:23, Heiko Carstens wrote:
> Hi all,
> 
> I just experienced a stack overflow (see below for part of the call trace)
> when an lldd returns SCSI_MLQUEUE_DEVICE_BUSY. Problem seems to be that
> scsi_dispatch_cmd calls scsi_queue_insert if the LLDD queuecommand function
> failed.
> 
>  [<00000000001b0a6a>] zfcp_scsi_queuecommand+0x32/0x44 
>  [<0000000000138892>] scsi_dispatch_cmd+0x2ca/0x334 
>  [<000000000013f7c8>] scsi_request_fn+0x26c/0x548 
>  [<000000000012b2f6>] blk_insert_request+0x126/0x140 
>  [<000000000013e1e6>] scsi_queue_insert+0xa6/0xd8 
>  [<0000000000138856>] scsi_dispatch_cmd+0x28e/0x334 
>  [<000000000013f7c8>] scsi_request_fn+0x26c/0x548 
>  [<000000000012b2f6>] blk_insert_request+0x126/0x140 
>  [<000000000013e1e6>] scsi_queue_insert+0xa6/0xd8 
>  [<0000000000138856>] scsi_dispatch_cmd+0x28e/0x334 
>  [<000000000013f7c8>] scsi_request_fn+0x26c/0x548 
>  [<000000000012b2f6>] blk_insert_request+0x126/0x140 
>  [<000000000013e1e6>] scsi_queue_insert+0xa6/0xd8 
>  [<0000000000138856>] scsi_dispatch_cmd+0x28e/0x334 
>  [<000000000013f7c8>] scsi_request_fn+0x26c/0x548 
>  [<000000000012b2f6>] blk_insert_request+0x126/0x140 
>  [<000000000013e12e>] scsi_insert_special_req+0x4e/0x60 
>  [<000000000013e2a0>] scsi_do_req+0x88/0x98 
>  [<000000000013e3e6>] scsi_wait_req+0x7a/0xdc 
>  [<00000000001408ae>] scsi_probe_lun+0x92/0x2f8 
>  [<000000000014110a>] scsi_probe_and_add_lun+0xaa/0x290 
>  [<00000000001414c2>] scsi_add_device+0x6e/0xc4 
>  [<00000000001b529e>] zfcp_erp_scsi_add_device+0x46/0xc4
>  [<000000000003c614>] worker_thread+0x1fc/0x2ac 
>  [<0000000000041854>] kthread+0xe4/0xec 
>  [<0000000000019c00>] kernel_thread_starter+0x14/0x1c 

Could you do some more debugging...there's something wierd going on
here.  a SCSI_MLQUEUE_DEVICE_BUSY return sets device_blocked.  As long
as sdev->max_device_blocked is two or more, this should cause an exit
from the next scsi_request_fn() (at the if(!req ||
!scsi_dev_queue_ready(q, sdev))

James


