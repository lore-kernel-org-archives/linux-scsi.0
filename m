From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: Regression introduced by 6f381fa344911d5a234b13574433cf23036f9467
 [[SCSI] scsi_lib: use correct DMA device in __scsi_alloc_queue]
Date: Mon, 7 May 2012 20:36:26 +0200
Message-ID: <CAMuHMdWJAkS2_DuLdfZQA6ZQGAycrr5w5egfaeaQsMJsTVEWRQ@mail.gmail.com>
References: <20120507135238.GC361@phenom.dumpdata.com>
	<CAF1ivSZNH3R-U=d=yBW4m9PO8TQSbSP=dHR3okdsO7EkOm2RMQ@mail.gmail.com>
	<20120507175039.GA6423@phenom.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120507175039.GA6423@phenom.dumpdata.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Lin Ming <ming.m.lin@intel.com>, JBottomley@parallels.com, joerg@alea.gnuu.de, linux-kernel@vger.kernel.org, scsi <linux-scsi@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org

On Mon, May 7, 2012 at 7:50 PM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
>> > reverting above mentioned git commit fixes the issue.
>>
>> Does Jame's below patch help?
>>
>> http://www.spinics.net/lists/linux-scsi/msg59106.html
>
> Yes. =C2=A0please add Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@o=
racle.com>
> on the latter part of that patch:

Same issue here with Atari NCR5380 SCSI on ARAnyM.
After the fix below, v3.4-rc6 boots, so

Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>

BTW, any git tree that has the original patch, so I don't have to commi=
t the
HTML-mangled version from spinics to the m68k tree?

> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 351dc0b..a3a056a 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -218,6 +218,9 @@ int scsi_add_host_with_dma(struct Scsi_Host *shos=
t, struct device *dev,
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!shost->shost_gendev.parent)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0shost->shost_g=
endev.parent =3D dev ? dev : &platform_bus;
> + =C2=A0 =C2=A0 =C2=A0 if (!dma_dev)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dma_dev =3D shost-=
>shost_gendev.parent;
> +
> =C2=A0 =C2=A0 =C2=A0 =C2=A0shost->dma_dev =3D dma_dev;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0error =3D device_add(&shost->shost_gendev)=
;

Gr{oetje,eeting}s,

=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-=
m68k.org

In personal conversations with technical people, I call myself a hacker=
=2E But
when I'm talking to journalists I just say "programmer" or something li=
ke that.
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 =C2=A0=C2=A0 -- Linus Torvalds
