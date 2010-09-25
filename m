From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] scsi, fcoe, libfc: drop scsi host_lock use from fc_queuecommand
Date: Sat, 25 Sep 2010 18:55:15 +0200
Message-ID: <AANLkTi=Y3WnG8rRf4PAaTev+ZS0SifeZLSoKekNMg2L6@mail.gmail.com>
References: <20100903222715.6237.75737.stgit@localhost.localdomain>
 <AANLkTinVTSboQB=kxyOCQ-eF6hYWqsn9YYJn7bnLeTtW@mail.gmail.com> <4C9C47FC.5080304@fusionio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47443 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab0IYQzh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 25 Sep 2010 12:55:37 -0400
Received: by iwn5 with SMTP id 5so3332971iwn.19
        for <linux-scsi@vger.kernel.org>; Sat, 25 Sep 2010 09:55:37 -0700 (PDT)
In-Reply-To: <4C9C47FC.5080304@fusionio.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Vasu Dev <vasu.dev@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, Sep 24, 2010 at 8:41 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
>
> [ ... ]
>
> Bart, can you try with this patchset added:
>
> git://git.kernel.dk/linux-2.6-block.git blk-alloc-optimize
>
> It's a work in progress and not suitable for general consumption yet,
> but it's tested working at least. There will be more built on top of
> this, but at least even this simple stuff is making a big difference
> for IOPS testing for me.

Hello Jens,

Thanks for the feedback. I see a nice 10% speedup after having applied
the four block layer optimization patches from the blk-alloc-optimize
branch on an already patched 2.6.35.5 SRP initiator.

Note: according to the output of perf record -g, most spinlock calls
still originate from the block layer. This is what the perf tool
reported for a fio run using libaio with small blocks (512 bytes):

Event: cycles
-      7.06%    fio  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave
   - _raw_spin_lock_irqsave
      + 19.51% blk_run_queue
      + 13.71% blk_end_bidi_request
      + 10.04% mlx4_ib_poll_cq
      + 4.68% lock_timer_base
      + 4.22% aio_complete
      + 3.97% srp_send_completion
      + 3.71% srp_queuecommand
      + 3.55% dio_bio_end_aio
      + 3.37% __srp_get_tx_iu
      + 3.14% srp_recv_completion
      + 3.00% scsi_device_unbusy
      + 2.87% __scsi_put_command
      + 2.82% __blockdev_direct_IO_newtrunc
      + 2.76% scsi_put_command
      + 2.69% scsi_run_queue
      + 2.65% dio_bio_submit
      + 2.54% srp_remove_req
      + 2.46% mlx4_ib_post_send
      + 2.33% scsi_get_command
      + 1.95% mlx4_ib_post_recv
[ ... ]

The script I used to generate a patched kernel can be found here
(r2271): https://scst.svn.sourceforge.net/svnroot/scst/trunk/scripts/generate-kernel-with-srp-patches.

Bart.
