From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH 10/12] Limit bio_endio recursion
Date: Thu, 7 Apr 2016 11:54:49 +0800
Message-ID: <CACVXFVNo6+F_OPyiTE882UrECz7BG_wKGj=teukibuiMdxmLHw@mail.gmail.com>
References: <1459746376-27983-1-git-send-email-shaun@tancheff.com>
	<1459746376-27983-11-git-send-email-shaun@tancheff.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:33321 "EHLO
	mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbcDGDyv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Apr 2016 23:54:51 -0400
In-Reply-To: <1459746376-27983-11-git-send-email-shaun@tancheff.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shaun Tancheff <shaun@tancheff.com>
Cc: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "open list:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>, linux-block@vger.kernel.org, Linux SCSI List <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@fb.com>, Shaun Tancheff <shaun.tancheff@seagate.com>

On Mon, Apr 4, 2016 at 1:06 PM, Shaun Tancheff <shaun@tancheff.com> wrote:
> Recursive endio calls can exceed 16k stack. Tested with
> 32k stack and observed:
>
>             Depth    Size   Location    (293 entries)
>             -----    ----   --------
>       0)    21520      16   __module_text_address+0x12/0x60
>       1)    21504       8   __module_address+0x5/0x140
>       2)    21496      24   __module_text_address+0x12/0x60
>       3)    21472      16   is_module_text_address+0xe/0x20
>       4)    21456       8   __kernel_text_address+0x50/0x80
>       5)    21448     136   print_context_stack+0x5a/0xf0
>       6)    21312     144   dump_trace+0x14c/0x300
>       7)    21168       8   save_stack_trace+0x2f/0x50
>       8)    21160      88   set_track+0x64/0x130
>       9)    21072      96   free_debug_processing+0x200/0x290
>      10)    20976     176   __slab_free+0x164/0x290
>      11)    20800      48   kmem_cache_free+0x1b0/0x1e0
>      12)    20752      16   mempool_free_slab+0x17/0x20
>      13)    20736      48   mempool_free+0x2f/0x90
>      14)    20688      16   bvec_free+0x36/0x40
>      15)    20672      32   bio_free+0x3b/0x60
>      16)    20640      16   bio_put+0x23/0x30
>      17)    20624      64   end_bio_extent_writepage+0xcf/0xe0
>      18)    20560      48   bio_endio+0x57/0x90
>      19)    20512      48   btrfs_end_bio+0xa8/0x160
>      20)    20464      48   bio_endio+0x57/0x90
>      21)    20416     112   dec_pending+0x121/0x270
>      22)    20304      64   clone_endio+0x7a/0x100
>      23)    20240      48   bio_endio+0x57/0x90
>     ...
>     277)     1264      64   clone_endio+0x7a/0x100
>     278)     1200      48   bio_endio+0x57/0x90
>     279)     1152     112   dec_pending+0x121/0x270
>     280)     1040      64   clone_endio+0x7a/0x100
>     281)      976      48   bio_endio+0x57/0x90
>     282)      928      80   blk_update_request+0x8f/0x340
>     283)      848      80   scsi_end_request+0x33/0x1c0
>     284)      768     112   scsi_io_completion+0xb5/0x620
>     285)      656      48   scsi_finish_command+0xcf/0x120
>     286)      608      48   scsi_softirq_done+0x126/0x150
>     287)      560      24   blk_done_softirq+0x78/0x90
>     288)      536     136   __do_softirq+0xfd/0x280
>     289)      400      16   run_ksoftirqd+0x28/0x50
>     290)      384      64   smpboot_thread_fn+0x105/0x160
>     291)      320     144   kthread+0xc9/0xe0
>     292)      176     176   ret_from_fork+0x3f/0x70
>
> Based on earlier patch by Mikulas Patocka <mpatocka@redhat.com>.
> https://lkml.org/lkml/2008/6/24/18

Looks a empty link, and the following had the discussion too:

http://linux-kernel.2935.n7.nabble.com/PATCH-1-2-Avoid-bio-endio-recursion-td306043.html

>
> Signed-off-by: Shaun Tancheff <shaun.tancheff@seagate.com>
> ---
>  block/bio.c | 57 ++++++++++++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 54 insertions(+), 3 deletions(-)
>
> diff --git a/block/bio.c b/block/bio.c
> index d42e69c..4ac19f6 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -1733,6 +1733,59 @@ static inline bool bio_remaining_done(struct bio *bio)
>         return false;
>  }
>
> +static DEFINE_PER_CPU(struct bio **, bio_end_queue) = { NULL };

The idea looks very nice, but this patch can't be applid to current block-next
branch.

Looks it might be simpler to implement the approach by using percpu bio_list.

> +
> +static struct bio *unwind_bio_endio(struct bio *bio)
> +{
> +       struct bio ***bio_end_queue_ptr;
> +       struct bio *bio_queue;
> +       struct bio *chain_bio = NULL;
> +       int error = bio->bi_error;
> +       unsigned long flags;
> +
> +       local_irq_save(flags);

If we may resue current->bio_list for this purpose, disabling irq should have
been avoided, but looks it is difficult to do in that way, maybe impossible.
Also not realistic to introduce a new per-task variable.

> +       bio_end_queue_ptr = this_cpu_ptr(&bio_end_queue);
> +
> +       if (*bio_end_queue_ptr) {
> +               **bio_end_queue_ptr = bio;
> +               *bio_end_queue_ptr = &bio->bi_next;
> +               bio->bi_next = NULL;
> +       } else {
> +               bio_queue = NULL;
> +               *bio_end_queue_ptr = &bio_queue;

Suggest to comment that bio_queue is the bottom-most stack variable,
otherwise looks a bit tricky to understand.

> +
> +next_bio:
> +               if (bio->bi_end_io == bio_chain_endio) {
> +                       struct bio *parent = bio->bi_private;
> +
> +                       bio_put(bio);
> +                       chain_bio = parent;
> +                       goto out;
> +               }
> +
> +               if (bio->bi_end_io) {
> +                       if (!bio->bi_error)
> +                               bio->bi_error = error;
> +                       bio->bi_end_io(bio);
> +               }
> +
> +               if (bio_queue) {
> +                       bio = bio_queue;
> +                       bio_queue = bio->bi_next;
> +                       if (!bio_queue)
> +                               *bio_end_queue_ptr = &bio_queue;
> +                       goto next_bio;
> +               }
> +               *bio_end_queue_ptr = NULL;
> +       }
> +
> +out:
> +
> +       local_irq_restore(flags);
> +
> +       return chain_bio;
> +}
> +
>  /**
>   * bio_endio - end I/O on a bio
>   * @bio:       bio
> @@ -1762,9 +1815,7 @@ void bio_endio(struct bio *bio)
>                         bio_put(bio);
>                         bio = parent;
>                 } else {
> -                       if (bio->bi_end_io)
> -                               bio->bi_end_io(bio);
> -                       bio = NULL;
> +                       bio = unwind_bio_endio(bio);
>                 }
>         }
>  }
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-block" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Ming Lei
