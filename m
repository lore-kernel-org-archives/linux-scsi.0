From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] aic7xxx: fix coccicheck warnings
Date: Tue, 12 Mar 2013 09:24:56 +0000
Message-ID: <1363080296.2401.23.camel@dabdike.int.hansenpartnership.com>
References: <1362945896-18475-1-git-send-email-silviupopescu1990@gmail.com>
	 <CAPWTe+JAmhnaxbfW2LW1=YGM4PKDyfW7WGgMHEwiPmw3yKtbTw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAPWTe+JAmhnaxbfW2LW1=YGM4PKDyfW7WGgMHEwiPmw3yKtbTw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Silviu Popescu <silviupopescu1990@gmail.com>
Cc: linux-scsi@vger.kernel.org, hare@suse.de, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2013-03-12 at 08:48 +0200, Silviu Popescu wrote:
> On Sun, Mar 10, 2013 at 10:04 PM, Silviu-Mihai Popescu
> <silviupopescu1990@gmail.com> wrote:
> > This replaces a call to kmalloc() followed by memset() with just one
> > call to kzalloc().
> >
> > Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
> > ---
> >  drivers/scsi/aic7xxx/aic79xx_osm.c |    3 +--
> >  drivers/scsi/aic7xxx/aic7xxx_osm.c |    3 +--
> >  2 files changed, 2 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
> > index 9328121..f6fdb65 100644
> > --- a/drivers/scsi/aic7xxx/aic79xx_osm.c
> > +++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
> > @@ -1324,10 +1324,9 @@ int
> >  ahd_platform_alloc(struct ahd_softc *ahd, void *platform_arg)
> >  {
> >         ahd->platform_data =
> > -           kmalloc(sizeof(struct ahd_platform_data), GFP_ATOMIC);
> > +           kzalloc(sizeof(struct ahd_platform_data), GFP_ATOMIC);
> >         if (ahd->platform_data == NULL)
> >                 return (ENOMEM);
> > -       memset(ahd->platform_data, 0, sizeof(struct ahd_platform_data));
> >         ahd->platform_data->irq = AHD_LINUX_NOIRQ;
> >         ahd_lockinit(ahd);
> >         ahd->seltime = (aic79xx_seltime & 0x3) << 4;
> > diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
> > index 5a477cd..54bb1de 100644
> > --- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
> > +++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
> > @@ -1222,10 +1222,9 @@ ahc_platform_alloc(struct ahc_softc *ahc, void *platform_arg)
> >  {
> >
> >         ahc->platform_data =
> > -           kmalloc(sizeof(struct ahc_platform_data), GFP_ATOMIC);
> > +           kzalloc(sizeof(struct ahc_platform_data), GFP_ATOMIC);
> >         if (ahc->platform_data == NULL)
> >                 return (ENOMEM);
> > -       memset(ahc->platform_data, 0, sizeof(struct ahc_platform_data));
> >         ahc->platform_data->irq = AHC_LINUX_NOIRQ;
> >         ahc_lockinit(ahc);
> >         ahc->seltime = (aic7xxx_seltime & 0x3) << 4;
> > --
> > 1.7.9.5
> >
> 
> Hello,
> 
> Would anyone be so kind as to review this?

For the ancient drivers, like aic7xxx, we keep them in deep freeze
maintenance, which means no cosmetic changes like this, I'm afraid.

Thanks,

James
