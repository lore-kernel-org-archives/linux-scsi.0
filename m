From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: Re: [PATCH 1/9] aha152x: rename the PCMCIA define
Date: Thu, 1 Nov 2018 00:22:21 +0900
Message-ID: <CAK7LNASCtHqB8DiA8NSNYY4823NwcOMV-3sS4RLFc8pfgEQD4w@mail.gmail.com>
References: <20181019120952.32763-1-hch@lst.de> <20181019120952.32763-2-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181019120952.32763-2-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: mporter@kernel.crashing.org, Alex Bounine <alex.bou9@gmail.com>, Dominik Brodowski <linux@dominikbrodowski.net>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, linux-pci@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Oct 19, 2018 at 9:10 PM Christoph Hellwig <hch@lst.de> wrote:
>
> We plan to enable building the PCMCIA core and drivers, and the
> non-prefixed PCMCIA name clashes with some arch headers.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Thomas Gleixner <tglx@linutronix.de>
> ---


Applied to linux-kbuild.




>  drivers/scsi/aha152x.c             | 14 +++++++-------
>  drivers/scsi/pcmcia/aha152x_core.c |  2 +-
>  2 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
> index 4d7b0e0adbf7..301b3cad15f8 100644
> --- a/drivers/scsi/aha152x.c
> +++ b/drivers/scsi/aha152x.c
> @@ -269,7 +269,7 @@ static LIST_HEAD(aha152x_host_list);
>  /* DEFINES */
>
>  /* For PCMCIA cards, always use AUTOCONF */
> -#if defined(PCMCIA) || defined(MODULE)
> +#if defined(AHA152X_PCMCIA) || defined(MODULE)
>  #if !defined(AUTOCONF)
>  #define AUTOCONF
>  #endif
> @@ -297,7 +297,7 @@ CMD_INC_RESID(struct scsi_cmnd *cmd, int inc)
>
>  #define DELAY_DEFAULT 1000
>
> -#if defined(PCMCIA)
> +#if defined(AHA152X_PCMCIA)
>  #define IRQ_MIN 0
>  #define IRQ_MAX 16
>  #else
> @@ -328,7 +328,7 @@ MODULE_AUTHOR("J=C3=BCrgen Fischer");
>  MODULE_DESCRIPTION(AHA152X_REVID);
>  MODULE_LICENSE("GPL");
>
> -#if !defined(PCMCIA)
> +#if !defined(AHA152X_PCMCIA)
>  #if defined(MODULE)
>  static int io[] =3D {0, 0};
>  module_param_hw_array(io, int, ioport, NULL, 0);
> @@ -391,7 +391,7 @@ static struct isapnp_device_id id_table[] =3D {
>  MODULE_DEVICE_TABLE(isapnp, id_table);
>  #endif /* ISAPNP */
>
> -#endif /* !PCMCIA */
> +#endif /* !AHA152X_PCMCIA */
>
>  static struct scsi_host_template aha152x_driver_template;
>
> @@ -863,7 +863,7 @@ void aha152x_release(struct Scsi_Host *shpnt)
>         if (shpnt->irq)
>                 free_irq(shpnt->irq, shpnt);
>
> -#if !defined(PCMCIA)
> +#if !defined(AHA152X_PCMCIA)
>         if (shpnt->io_port)
>                 release_region(shpnt->io_port, IO_RANGE);
>  #endif
> @@ -2924,7 +2924,7 @@ static struct scsi_host_template aha152x_driver_tem=
plate =3D {
>         .slave_alloc                    =3D aha152x_adjust_queue,
>  };
>
> -#if !defined(PCMCIA)
> +#if !defined(AHA152X_PCMCIA)
>  static int setup_count;
>  static struct aha152x_setup setup[2];
>
> @@ -3392,4 +3392,4 @@ static int __init aha152x_setup(char *str)
>  __setup("aha152x=3D", aha152x_setup);
>  #endif
>
> -#endif /* !PCMCIA */
> +#endif /* !AHA152X_PCMCIA */
> diff --git a/drivers/scsi/pcmcia/aha152x_core.c b/drivers/scsi/pcmcia/aha=
152x_core.c
> index dba3716511c5..24b89228b241 100644
> --- a/drivers/scsi/pcmcia/aha152x_core.c
> +++ b/drivers/scsi/pcmcia/aha152x_core.c
> @@ -1,3 +1,3 @@
> -#define PCMCIA 1
> +#define AHA152X_PCMCIA 1
>  #define AHA152X_STAT 1
>  #include "aha152x.c"
> --
> 2.19.1
>


--=20
Best Regards
Masahiro Yamada
