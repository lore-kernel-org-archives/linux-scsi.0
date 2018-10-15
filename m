From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: Re: [PATCH 2/8] powerpc: simplify CONFIG_PCI_QSPAN Kconfig magic
Date: Mon, 15 Oct 2018 15:35:41 +0900
Message-ID: <CAK7LNAQxZcBNadLJhfrmxJGj-XJFVaya3Z1eexZp20vRPwrN7A@mail.gmail.com>
References: <20181013151016.31674-1-hch@lst.de> <20181013151016.31674-3-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181013151016.31674-3-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: mporter@kernel.crashing.org, alex.bou9@gmail.com, Dominik Brodowski <linux@dominikbrodowski.net>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, linux-pci@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, Oct 14, 2018 at 12:11 AM Christoph Hellwig <hch@lst.de> wrote:
>
> The way how CONFIG_PCI_QSPAN selects the CONFIG_PCI default is highly
> unusual and gets in the way of moving CONFIG_PCI into
> drivers/pci/Kconfig.  Simplify it by just having it depend on
> CONFIG_PCI.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  arch/powerpc/Kconfig | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index a80669209155..6fa6f92edb7f 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -955,7 +955,6 @@ config PCI
>         bool "PCI support" if PPC_PCI_CHOICE
>         default y if !40x && !CPM2 && !PPC_8xx && !PPC_83xx \
>                 && !PPC_85xx && !PPC_86xx && !GAMECUBE_COMMON
> -       default PCI_QSPAN if PPC_8xx
>         select GENERIC_PCI_IOMAP
>         help
>           Find out whether your system includes a PCI bus. PCI is the name of
> @@ -971,7 +970,7 @@ config PCI_SYSCALL
>
>  config PCI_QSPAN
>         bool "QSpan PCI"
> -       depends on PPC_8xx
> +       depends on PPC_8xx && PCI
>         select PPC_I8259
>         help
>           Say Y here if you have a system based on a Motorola 8xx-series
> --
> 2.19.1
>



'git grep' did not get any other hit.

masahiro@pug:~/ref/linux$ git grep PCI_QSPAN
arch/powerpc/Kconfig:   default PCI_QSPAN if PPC_8xx
arch/powerpc/Kconfig:config PCI_QSPAN

With your patch, PCI_QSPAN will become
a dead config option.

How about removing it entirely?



--
Best Regards
Masahiro Yamada
