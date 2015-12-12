From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 1/4] scsi: storvsc: Fix a bug in the layout of the
 hv_fc_wwn_packet
Date: Sat, 12 Dec 2015 03:10:24 +0000
Message-ID: <SN1PR0301MB166291EC8F91826BAF403466A0EB0@SN1PR0301MB1662.namprd03.prod.outlook.com>
References: <1449792829-15406-1-git-send-email-kys@microsoft.com>
 <1449792860-15447-1-git-send-email-kys@microsoft.com>
 <20151211084748.GC9903@c203.arch.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20151211084748.GC9903@c203.arch.suse.de>
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
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "jasowang@redhat.com" <jasowang@redhat.com>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "apw@canonical.com" <apw@canonical.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Johannes Thumshirn [mailto:jthumshirn@suse.de]
> Sent: Friday, December 11, 2015 12:48 AM
> To: KY Srinivasan <kys@microsoft.com>
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com;
> jbottomley@parallels.com; hch@infradead.org; linux-scsi@vger.kernel.org;
> apw@canonical.com; vkuznets@redhat.com; jasowang@redhat.com;
> martin.petersen@oracle.com
> Subject: Re: [PATCH 1/4] scsi: storvsc: Fix a bug in the layout of the
> hv_fc_wwn_packet
> =

> On Thu, Dec 10, 2015 at 04:14:17PM -0800, K. Y. Srinivasan wrote:
> > The hv_fc_wwn_packet is exchanged over vmbus. Make the definition in
> Linux match
> > the Window's definition.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Reviewed-by: Long Li <longli@microsoft.com>
> > Tested-by: Alex Ng <alexng@microsoft.com>
> > ---
> >  drivers/scsi/storvsc_drv.c |    5 ++---
> >  1 files changed, 2 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> > index c41f674..00bb4bd 100644
> > --- a/drivers/scsi/storvsc_drv.c
> > +++ b/drivers/scsi/storvsc_drv.c
> > @@ -92,9 +92,8 @@ enum vstor_packet_operation {
> >   */
> >
> >  struct hv_fc_wwn_packet {
> > -	bool	primary_active;
> > -	u8	reserved1;
> > -	u8	reserved2;
> > +	u8	primary_active;
> > +	u8	reserved1[3];
> >  	u8	primary_port_wwn[8];
> >  	u8	primary_node_wwn[8];
> >  	u8	secondary_port_wwn[8];
> > --
> > 1.7.4.1
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at
> https://na01.safelinks.protection.outlook.com/?url=3Dhttp%3a%2f%2fvger.ker
> nel.org%2fmajordomo-
> info.html&data=3D01%7c01%7ckys%40microsoft.com%7cb6c3be0d1b474ac1374
> 908d30207c170%7c72f988bf86f141af91ab2d7cd011db47%7c1&sdata=3D7hfMcn
> qW32KiJgr7JkXsC4P0CnnQvAearwu7LzyWaqM%3d
> =

> Should this go through stable as well?
> If yes:
> Fixes: 8b612fa23 '[SCSI] storvsc: Update the storage protocol to win8 lev=
el'
> Cc: stable@vger.kernel.org # v3.11+
This is the first time we are using this data structure and so I don't thin=
k we need
to port it back to stable.

Regards,

K. Y

> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> =

> --
> Johannes Thumshirn                                          Storage
> jthumshirn@suse.de                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
