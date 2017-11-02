From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] block: fix CDROM dependency on BLK_DEV
Date: Thu, 2 Nov 2017 16:07:00 +0100
Message-ID: <CAK8P3a0twNHzQct-GNCO0HMn+cSPGPUO=gcVmKXbtbnvU4j0Og@mail.gmail.com>
References: <20171102111952.4021454-1-arnd@arndb.de> <1509634781.2484.3.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1509634781.2484.3.camel@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "davem@davemloft.net" <davem@davemloft.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Nov 2, 2017 at 3:59 PM, Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
> On Thu, 2017-11-02 at 12:19 +0100, Arnd Bergmann wrote:
>> After the cdrom cleanup, I get randconfig warnings for some configurations:
>>
>> warning: (BLK_DEV_IDECD && BLK_DEV_SR) selects CDROM which has unmet direct dependencies (BLK_DEV)
>
> Hello Arnd,
>
> Since Jens has already queued your patch it's too late to consider alternatives.
> Anyway, since the cdrom driver calls block layer functions directly, have you
> considered the following alternative?
>
> diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
> index 0dad1d2536f7..e7044c893817 100644
> --- a/drivers/block/Kconfig
> +++ b/drivers/block/Kconfig
> @@ -69,6 +69,7 @@ config AMIGA_Z2RAM
>
>  config CDROM
>         tristate "CD-ROM driver"
> +       depends on BLK_DEV
>         help
>           A CD-ROM is a pre-pressed optical compact disc which contains
>           data. The name is an acronym which stands for "Compact Disc

This doesn't work, the problem is the existing dependency on 'BLK_DEV'
that is implied by
listing CONFIG_CDROM inside of the "if BLK_DEV" section. It would
probably be possible
to move CONFIG_CDROM' outside of this 'if' section and use 'select
BLK_DEV' inside it,
but that in turn would make the Kconfig logic even less intuitive than
it already is.

      Arnd
