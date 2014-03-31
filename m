From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 4/4] m68k/atari - atari_scsi: use correct virt/phys
 translation for DMA buffer
Date: Mon, 31 Mar 2014 09:48:47 +0200
Message-ID: <CAMuHMdVVyagkFQZdO6RzV2VAjC-jntHcU+7YRWisZGeKRRbjAg@mail.gmail.com>
References: <1396137686-32678-1-git-send-email-schmitz@debian.org>
	<1396137686-32678-5-git-send-email-schmitz@debian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <1396137686-32678-5-git-send-email-schmitz@debian.org>
Sender: linux-m68k-owner@vger.kernel.org
To: Jej B <James.Bottomley@hansenpartnership.com>
Cc: Linux/m68k <linux-m68k@vger.kernel.org>, Debian m68k <debian-68k@lists.debian.org>, Michael Schmitz <schmitz@debian.org>, Michael Schmitz <schmitzmic@gmail.com>, scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi James,

If you don't object, I'd like to take this one through the m68k tree, as it
depends on a new m68k platform function.

On Sun, Mar 30, 2014 at 1:01 AM, Michael Schmitz <schmitzmic@gmail.com> wrote:
> With new ST-RAM allocation to work also when the kernel is running
> from FastRAM, use dedicated virt/phys translation for this case.
>
> Signed-off-by: Michael Schmitz <schmitz@debian.org>
> ---
>  drivers/scsi/atari_scsi.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
> index 296c936..a8d721f 100644
> --- a/drivers/scsi/atari_scsi.c
> +++ b/drivers/scsi/atari_scsi.c
> @@ -639,7 +639,7 @@ static int __init atari_scsi_detect(struct scsi_host_template *host)
>                                         "double buffer\n");
>                         return 0;
>                 }
> -               atari_dma_phys_buffer = virt_to_phys(atari_dma_buffer);
> +               atari_dma_phys_buffer = atari_stram_to_phys(atari_dma_buffer);
>                 atari_dma_orig_addr = 0;
>         }
>  #endif
> --
> 1.7.0.4

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
