From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH 10/12] Limit bio_endio recursion
Date: Thu, 7 Apr 2016 14:03:23 +0800
Message-ID: <CACVXFVNVo-ya9T3rzSiiWtO1r87D-yW1DmZBt2Ryv1U4TPOi8g@mail.gmail.com>
References: <1459746376-27983-1-git-send-email-shaun@tancheff.com>
	<1459746376-27983-11-git-send-email-shaun@tancheff.com>
	<CACVXFVNo6+F_OPyiTE882UrECz7BG_wKGj=teukibuiMdxmLHw@mail.gmail.com>
	<20160407134443.552c2556@tom-T450>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20160407134443.552c2556@tom-T450>
Sender: linux-ide-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Shaun Tancheff <shaun@tancheff.com>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "open list:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>, linux-block@vger.kernel.org, Linux SCSI List <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@fb.com>, Shaun Tancheff <shaun.tancheff@seagate.com>, Christoph Hellwig <hch@infradead.org>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Apr 7, 2016 at 1:44 PM, Ming Lei <tom.leiming@gmail.com> wrote:
> On Thu, 7 Apr 2016 11:54:49 +0800
> Ming Lei <tom.leiming@gmail.com> wrote:
>

> @@ -1737,6 +1739,46 @@ static inline bool bio_remaining_done(struct bio *bio)
>         return false;
>  }
>
> +/* disable local irq when manipulating the percpu bio_list */
> +static void unwind_bio_endio(struct bio *bio)
> +{
> +       struct bio_list bl_in_stack;
> +       struct bio_list *bl;
> +       unsigned long flags;
> +       bool clear_list = false;
> +
> +       local_irq_save(flags);
> +
> +       bl = this_cpu_read(bio_end_list);
> +       if (!bl) {
> +               bl = &bl_in_stack;
> +               bio_list_init(bl);
> +               clear_list = true;

oops, forget to write the pointer into the percpu bio_list pointer.
But it is still working after I fix that by the following line:

             this_cpu_write(bio_end_list, bl);

thanks,
