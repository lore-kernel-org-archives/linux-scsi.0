From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH] scsi, fcoe, libfc: drop scsi host_lock use from  fc_queuecommand
Date: Sun, 26 Sep 2010 12:19:37 +0900
Message-ID: <4C9EBBC9.9070709@fusionio.com>
References: <20100903222715.6237.75737.stgit@localhost.localdomain> <AANLkTinVTSboQB=kxyOCQ-eF6hYWqsn9YYJn7bnLeTtW@mail.gmail.com> <4C9C47FC.5080304@fusionio.com> <AANLkTi=Y3WnG8rRf4PAaTev+ZS0SifeZLSoKekNMg2L6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([64.244.102.31]:53416 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755980Ab0IZDTm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Sep 2010 23:19:42 -0400
In-Reply-To: <AANLkTi=Y3WnG8rRf4PAaTev+ZS0SifeZLSoKekNMg2L6@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Vasu Dev <vasu.dev@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 2010-09-26 01:55, Bart Van Assche wrote:
> On Fri, Sep 24, 2010 at 8:41 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
>>
>> [ ... ]
>>
>> Bart, can you try with this patchset added:
>>
>> git://git.kernel.dk/linux-2.6-block.git blk-alloc-optimize
>>
>> It's a work in progress and not suitable for general consumption yet,
>> but it's tested working at least. There will be more built on top of
>> this, but at least even this simple stuff is making a big difference
>> for IOPS testing for me.
> 
> Hello Jens,
> 
> Thanks for the feedback. I see a nice 10% speedup after having applied
> the four block layer optimization patches from the blk-alloc-optimize
> branch on an already patched 2.6.35.5 SRP initiator.

Great! Not too bad for something that's will a WIP.

> Note: according to the output of perf record -g, most spinlock calls
> still originate from the block layer. This is what the perf tool
> reported for a fio run using libaio with small blocks (512 bytes):
> 
> Event: cycles
> -      7.06%    fio  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave
>    - _raw_spin_lock_irqsave
>       + 19.51% blk_run_queue
>       + 13.71% blk_end_bidi_request
>       + 10.04% mlx4_ib_poll_cq
>       + 4.68% lock_timer_base
>       + 4.22% aio_complete
>       + 3.97% srp_send_completion
>       + 3.71% srp_queuecommand
>       + 3.55% dio_bio_end_aio
>       + 3.37% __srp_get_tx_iu
>       + 3.14% srp_recv_completion
>       + 3.00% scsi_device_unbusy
>       + 2.87% __scsi_put_command
>       + 2.82% __blockdev_direct_IO_newtrunc
>       + 2.76% scsi_put_command
>       + 2.69% scsi_run_queue
>       + 2.65% dio_bio_submit
>       + 2.54% srp_remove_req
>       + 2.46% mlx4_ib_post_send
>       + 2.33% scsi_get_command
>       + 1.95% mlx4_ib_post_recv

One piece of low hanging fruit is reducing the number of queue runs.
SCSI does this for every completed command to keep the device queue
full. I bet if you try an experiement where you only run the queue when
a certain number of requests have completed, you would greatly reduce
scsi_run_queue and blk_run_queue in the above profile.

-- 
Jens Axboe

