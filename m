From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [LSF/MM TOPIC NOTES] x86 ZONE_DMA love
Date: Thu, 3 May 2018 10:20:54 +0200
Message-ID: <CAMuHMdV1D8zYUWzVX3wmayTobX1FPwU7QMXvaimWewuxi7FoNw@mail.gmail.com>
References: <20180426215406.GB27853@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180426215406.GB27853@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Linux MM <linux-mm@kvack.org>, Michal Hocko <mhocko@kernel.org>, Christoph Lameter <cl@linux.com>, Jan Kara <jack@suse.cz>, Matthew Wilcox <matthew@wil.cx>, the arch/x86 maintainers <x86@kernel.org>, Andy Lutomirski <luto@amacapital.net>, "Martin K. Petersen" <martin.petersen@oracle.com>, jthumshirn@suse.de, Mark Brown <broonie@kernel.org>, linux-spi <linux-spi@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

Hi Luis,

On Thu, Apr 26, 2018 at 11:54 PM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> x86 implicit and explicit ZONE_DMA users
> -----------------------------------------
>
> We list below all x86 implicit and explicit ZONE_DMA users.
>
> # Explicit x86 users of GFP_DMA or __GFP_DMA
>
>   * drivers/iio/common/ssp_sensors - wonder if enabling this on x86 was a mistake.
>     Note that this needs SPI and SPI needs HAS_IOMEM. I only see HAS_IOMEM on
>     s390 ? But I do think the Intel Minnowboard has SPI, but doubt it has
>    the ssp sensor stuff.
>
>  * drivers/input/rmi4/rmi_spi.c - same SPI question
>  * drivers/media/common/siano/ - make allyesconfig yields it enabled, but
>    not sure if this should ever be on x86
>  * drivers/media/platform/sti/bdisp/ - likewise
>   * drivers/media/platform/sti/hva/ - likewise
>   * drivers/media/usb/gspca/ - likewise
>   * drivers/mmc/host/wbsd.c - likewise
>   * drivers/mtd/nand/gpmi-nand/ - likewise
>   * drivers/net/can/spi/hi311x.c - likewise
>   * drivers/net/can/spi/mcp251x.c - likewise
>   * drivers/net/ethernet/agere/ - likewise
>   * drivers/net/ethernet/neterion/vxge/ - likewise
>   * drivers/net/ethernet/rocker/ - likewise
>   * drivers/net/usb/kalmia.c - likewise
>   * drivers/net/ethernet/neterion/vxge/ - likewise
>   * drivers/spi/spi-pic32-sqi.c - likewise
>   * drivers/spi/spi-sh-msiof.c - likewise

depends on ARCH_SHMOBILE || ARCH_RENESAS || COMPILE_TEST

>   * drivers/spi/spi-ti-qspi.c - likewise

I haven't checked the others, but probably you want to disable COMPILE_TEST
to make more educated guesses about driver usage on x86.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
