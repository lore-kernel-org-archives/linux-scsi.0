From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: scsi: Implement per-cpu logging buffer
Date: Thu, 12 Feb 2015 13:36:32 +0100
Message-ID: <CAMuHMdUKH1yuLZ9zLAK2STekLFXBufR9PM2_S11xExCtEc9dWg@mail.gmail.com>
References: <20150211191614.349AF660DDA@gitolite.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150211191614.349AF660DDA@gitolite.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: Josh Triplett <josh@joshtriplett.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Feb 11, 2015 at 8:16 PM, Linux Kernel Mailing List
<linux-kernel@vger.kernel.org> wrote:
> Gitweb:     http://git.kernel.org/linus/;a=commit;h=ded85c193a391a84076d5c6a7a5668fe164a490e
> Commit:     ded85c193a391a84076d5c6a7a5668fe164a490e
> Parent:     b0a93d96b2814c725161f91a4e35d0c29ec0f95b
> Refname:    refs/heads/master
> Author:     Hannes Reinecke <hare@suse.de>
> AuthorDate: Thu Jan 8 07:43:42 2015 +0100
> Committer:  Christoph Hellwig <hch@lst.de>
> CommitDate: Fri Jan 9 15:44:28 2015 +0100
>
>     scsi: Implement per-cpu logging buffer
>
>     Implement a per-cpu buffer for formatting messages to avoid line breaks
>     up under high load.  This patch implements scmd_printk() and
>     sdev_prefix_printk() using the per-cpu buffer and makes sdev_printk() a
>     wrapper for sdev_prefix_printk().
>
>     Tested-by: Robert Elliott <elliott@hp.com>
>     Reviewed-by: Robert Elliott <elliott@hp.com>
>     Signed-off-by: Hannes Reinecke <hare@suse.de>
>     Signed-off-by: Christoph Hellwig <hch@lst.de>

> --- /dev/null
> +++ b/drivers/scsi/scsi_logging.c

> +#define SCSI_LOG_SPOOLSIZE 4096
> +#define SCSI_LOG_BUFSIZE 128
> +
> +#if (SCSI_LOG_SPOOLSIZE / SCSI_LOG_BUFSIZE) > BITS_PER_LONG
> +#warning SCSI logging bitmask too large
> +#endif
> +
> +struct scsi_log_buf {
> +       char buffer[SCSI_LOG_SPOOLSIZE];
> +       unsigned long map;
> +};
> +
> +static DEFINE_PER_CPU(struct scsi_log_buf, scsi_format_log);

Do we really need a static 4 KiB per-CPU buffer?

bloat-o-meter:

add/remove: 183/94 grow/shrink: 314/211 up/down: 33467/-21291 (12176)
function                                     old     new   delta
scsi_format_log                                -    4100   +4100
handle_mm_fault                             1794    2750    +956
scsi_log_print_sense_hdr                       -     774    +774
proc_keys_show                                 -     770    +770

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
