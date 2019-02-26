From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: Re: [PATCH v1] mpt3sas: Use driver scsi lookup to track outstanding IOs
Date: Tue, 26 Feb 2019 21:35:10 +0530
Message-ID: <CAHsXFKGbNfJ32EE_Gyz9yC0k+yNB=rgMQZc+jAQr2nFPDC+oFg@mail.gmail.com>
References: <1550751105-46065-1-git-send-email-sreekanth.reddy@broadcom.com>
 <d0672a75-2900-5f6b-368f-5808914322a8@suse.de> <CAK=zhgpuB9Y+Z1e64D1Dm4fJtJ2rjZPf5g_TLNwnKbauRpqrJQ@mail.gmail.com>
 <61a8f703-3f20-b777-08b9-54ae34dffa59@suse.de> <CAK=zhgrWWtCf+N7EmbhK69PEc2L0hfc8ybOyFddUed8yufhvJQ@mail.gmail.com>
 <0dfb09ca-8723-3a3c-a6a8-c643856c57e3@suse.de> <20190226143313.GA23865@infradead.org>
 <6f94a905-45c9-4a77-bbb6-9669197e8d8f@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <6f94a905-45c9-4a77-bbb6-9669197e8d8f@suse.de>
Sender: stable-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, linux-scsi <linux-scsi@vger.kernel.org>, Sathya Prakash <Sathya.Prakash@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Feb 26, 2019 at 8:23 PM Hannes Reinecke <hare@suse.de> wrote:
>
> On 2/26/19 3:33 PM, Christoph Hellwig wrote:
> > On Tue, Feb 26, 2019 at 02:49:30PM +0100, Hannes Reinecke wrote:
> >> Attached is a patch to demonstrate my approach.
> >> I am aware that it'll only be useful for latest upstream where the legacy
> >> I/O path has been dropped completely, so we wouldn't need to worry about it.
> >> For older releases indeed you would need to with something like your
> >> proposed patch, but for upstream I really would like to switch to
> >> blk_mq_tagset_busy() iter.
> >
> > While this is better than the driver private tracking we really should
> > not have to iterate all outstanding command, because if we have any
> > there is a bug we need to fix in the higher layers instead of working
> > around it in the drivers.

Hi Chris, Looking at other driver's code, I think similar issue is
impacted to many scsi hbas (like fnic, qla4xxx, snic etc..). They also
need similar logic to traverse outstanding scsi commands.
One of the example is - At the time of HBA reset driver would like to
release scsi command back to SML to retry and for that driver requires
to loop all possible smid to figure out outstanding scsi command
@Firmware/SML level.

> >
> Ah-ha.
>
> But what else should we be doing here?
> The driver needs to abort all outstanding commands; I somewhat fail to
> see how we could be doing it otherwise ...

Hannes, Primary drawback of using "blk_mq_tagset_busy_iter" is API is
only for blk-mq and it is not available for all the kernel with blk-mq
support. We have seen multiple failures from customer and those
kernels does not support blk_mq_tagset_busy_iter. In fact, blk-mq and
non-mq stack is alive in many Linux distribution and customer is using
those. If we just scope to fix current kernel 5.x (which does not have
non-mq support), we can opt blk_mq_tagset_busy_iter(). Earlier I
requested upstream to accept driver changes without
blk_mq_tagset_busy_iter() because it is hitting many customers so we
are looking for generic fix which can server both blk-mq as well as
non-mq.

We will certainly enhance and optimize working this area (driver
trying to find outstanding scsi command) with scsi mailing list as
incremental approach.

Kashyap

>
> Cheers,
>
> Hannes
>
