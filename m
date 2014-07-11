From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 6/8] Drivers: scsi: storvsc: Implement an abort handler
Date: Fri, 11 Jul 2014 14:49:17 +0000
Message-ID: <24b8bacd815e4c43add14f66c85ff61b@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-6-git-send-email-kys@microsoft.com>
 <20140709084415.GF6012@infradead.org>
 <9b76360fb30745d3941b6d56bdae268f@BY2PR03MB299.namprd03.prod.outlook.com>
 <20140710101320.GB1151@infradead.org>
 <f662b500fada4fbca75c55089d3f8ee4@BY2PR03MB299.namprd03.prod.outlook.com>
 <53BFB3F7.7010304@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <53BFB3F7.7010304@suse.de>
Content-Language: en-US
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jasowang@redhat.com" <jasowang@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "ohering@suse.com" <ohering@suse.com>, "apw@canonical.com" <apw@canonical.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Friday, July 11, 2014 2:53 AM
> To: KY Srinivasan; Christoph Hellwig
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> ohering@suse.com; jbottomley@parallels.com; jasowang@redhat.com;
> apw@canonical.com; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH 6/8] Drivers: scsi: storvsc: Implement an abort handl=
er
> =

> On 07/11/2014 12:26 AM, KY Srinivasan wrote:
> >
> >
> >> -----Original Message-----
> >> From: Christoph Hellwig [mailto:hch@infradead.org]
> >> Sent: Thursday, July 10, 2014 3:13 AM
> >> To: KY Srinivasan
> >> Cc: Christoph Hellwig; linux-kernel@vger.kernel.org;
> >> devel@linuxdriverproject.org; ohering@suse.com;
> >> jbottomley@parallels.com; jasowang@redhat.com; apw@canonical.com;
> >> linux-scsi@vger.kernel.org
> >> Subject: Re: [PATCH 6/8] Drivers: scsi: storvsc: Implement an abort
> >> handler
> >>
> >>
> >> Note that you could increase the timeout and/or implement an
> >> eh_timed_out handler that just returns BLK_EH_RESET_TIMER, but if the
> >> completion takes too long the expectation is that a command will
> >> eventually finish instead of beeing delayed by an unmound amount.
> >
> > I like this idea; I will implement a eh_timed_out_handler.
> >
> Something like this should be sufficient:
> =

> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c index
> e71a0d7..630ae81 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -1468,6 +1468,12 @@ static int storvsc_get_chs(struct scsi_device
> *sdev, stru ct block_device * bdev,
>          return 0;
>   }
> =

> +static enum blk_eh_timer_return
> +storvsc_timed_out_handler(struct scsi_cmnd *scmd) {
> +       return BLK_EH_RESET_TIMER;
> +}
> +
>   static int storvsc_host_reset_handler(struct scsi_cmnd *scmnd)
>   {
>          struct hv_host_device *host_dev =3D shost_priv(scmnd->device->ho=
st);
> @@ -1687,6 +1693,7 @@ static struct scsi_host_template scsi_driver =3D {
>          .name =3D                 "storvsc_host_t",
>          .bios_param =3D           storvsc_get_chs,
>          .queuecommand =3D         storvsc_queuecommand,
> +       .eh_timed_out =3D         storvsc_timed_out_handler,
>          .eh_host_reset_handler =3D        storvsc_host_reset_handler,
>          .slave_alloc =3D          storvsc_device_alloc,
>          .slave_destroy =3D        storvsc_device_destroy,
> =

> Cheers,

Thanks Hannes. Based on Christoph's feedback I have implemented exactly thi=
s patch. It is under test on Azure.
I will be re-spinning and posting the patches shortly.

K. Y
> =

> Hannes
> --
> Dr. Hannes Reinecke		      zSeries & Storage
> hare@suse.de			      +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
