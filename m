From: Long Li <longli@microsoft.com>
Subject: RE: [PATCH 1/3] storvsc: use tagged SRB requests if supported by the
 device
Date: Wed, 7 Sep 2016 17:19:29 +0000
Message-ID: <BN3PR03MB22274649D4E68744BA2E54FCCEF80@BN3PR03MB2227.namprd03.prod.outlook.com>
References: <1473197143-16760-1-git-send-email-longli@exchange.microsoft.com>
 <1473197143-16760-2-git-send-email-longli@exchange.microsoft.com>
 <20160907074645.6ecwmq7pmf6mb4pg@c203.arch.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20160907074645.6ecwmq7pmf6mb4pg@c203.arch.suse.de>
Content-Language: en-US
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Johannes Thumshirn <jthumshirn@suse.de>, Long Li <longli@exchange.microsoft.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Haiyang Zhang <haiyangz@microsoft.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Johannes Thumshirn [mailto:jthumshirn@suse.de]
> Sent: Wednesday, September 7, 2016 12:47 AM
> To: Long Li <longli@exchange.microsoft.com>
> Cc: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; James E.J. Bottomley
> <jejb@linux.vnet.ibm.com>; Martin K. Petersen
> <martin.petersen@oracle.com>; devel@linuxdriverproject.org; linux-
> scsi@vger.kernel.org; linux-kernel@vger.kernel.org; Long Li
> <longli@microsoft.com>
> Subject: Re: [PATCH 1/3] storvsc: use tagged SRB requests if supported by
> the device
> =

> On Tue, Sep 06, 2016 at 02:25:41PM -0700, Long Li wrote:
> > From: Long Li <longli@microsoft.com>
> >
> > Properly set SRB flags when hosting device supports tagged queuing. This
> patch improves the performance on Fiber Channel disks.
> =

> ENOSIGNEDOFF and please use checkpatch.pl on the patch.

Thanks for pointing that out. I'll re-send the patches.
> =

> >
> > ---
> >  drivers/scsi/storvsc_drv.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> > index 8ccfc9e..a8f3e4c 100644
> > --- a/drivers/scsi/storvsc_drv.c
> > +++ b/drivers/scsi/storvsc_drv.c
> > @@ -136,6 +136,8 @@ struct hv_fc_wwn_packet {
> >  #define SRB_FLAGS_PORT_DRIVER_RESERVED		0x0F000000
> >  #define SRB_FLAGS_CLASS_DRIVER_RESERVED		0xF0000000
> >
> > +#define SP_UNTAGGED			((unsigned char) ~0)
> > +#define SRB_SIMPLE_TAG_REQUEST		0x20
> >
> >  /*
> >   * Platform neutral description of a scsi request - @@ -1451,6
> > +1453,12 @@ static int storvsc_queuecommand(struct Scsi_Host *host,
> struct scsi_cmnd *scmnd)
> >  	vm_srb->win8_extension.srb_flags |=3D
> >  		SRB_FLAGS_DISABLE_SYNCH_TRANSFER;
> >
> > +	if(scmnd->device->tagged_supported) {
> > +		vm_srb->win8_extension.srb_flags |=3D
> (SRB_FLAGS_QUEUE_ACTION_ENABLE | SRB_FLAGS_NO_QUEUE_FREEZE);
> > +		vm_srb->win8_extension.queue_tag =3D SP_UNTAGGED;
> > +		vm_srb->win8_extension.queue_action =3D
> SRB_SIMPLE_TAG_REQUEST;
> > +	}
> > +
> >  	/* Build the SRB */
> >  	switch (scmnd->sc_data_direction) {
> >  	case DMA_TO_DEVICE:
> > --
> > 1.8.5.6
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> > in the body of a message to majordomo@vger.kernel.org More
> majordomo
> > info at
> > https://na01.safelinks.protection.outlook.com/?url=3Dhttp%3a%2f%2fvger.k
> > ernel.org%2fmajordomo-
> info.html&data=3D02%7c01%7clongli%40microsoft.com%
> >
> 7cdedd4c7ad4cf4955224d08d3d6f31f3d%7c72f988bf86f141af91ab2d7cd011db
> 47%
> >
> 7c1%7c0%7c636088312112339554&sdata=3DQvrOLvFjisQ4Nfz%2bkz1uyt7G7wh
> R7Uz7D
> > DlYMuc5VUM%3d
> =

> --
> Johannes Thumshirn                                          Storage
> jthumshirn@suse.de                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton HRB 21284 (AG
> N=FCrnberg) Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2=
D76
> 0850
