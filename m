From: Long Li <longli@microsoft.com>
Subject: RE: [Possible Phish Fraud][PATCH] storvsc: use default I/O timeout
 handler for FC devices
Date: Tue, 13 Jun 2017 19:16:13 +0000
Message-ID: <MWHPR03MB313605606CD50FADB0D9AFBBCEC20@MWHPR03MB3136.namprd03.prod.outlook.com>
References: <1497313417-14815-1-git-send-email-longli@exchange.microsoft.com>
 <1497368284.2804.5.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1497368284.2804.5.camel@wdc.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, KY Srinivasan <kys@microsoft.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Stephen Hemminger <sthemmin@microsoft.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, Haiyang Zhang <haiyangz@microsoft.com>
Cc: "jthumshirn@suse.de" <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Bart Van Assche [mailto:Bart.VanAssche@sandisk.com]
> Sent: Tuesday, June 13, 2017 8:38 AM
> To: linux-kernel@vger.kernel.org; KY Srinivasan <kys@microsoft.com>;
> martin.petersen@oracle.com; linux-scsi@vger.kernel.org; Stephen Hemminger
> <sthemmin@microsoft.com>; Long Li <longli@microsoft.com>;
> jejb@linux.vnet.ibm.com; Haiyang Zhang <haiyangz@microsoft.com>
> Cc: jthumshirn@suse.de; Long Li <longli@microsoft.com>
> Subject: Re: [Possible Phish Fraud][PATCH] storvsc: use default I/O timeo=
ut
> handler for FC devices
>=20
> On Mon, 2017-06-12 at 17:23 -0700, Long Li wrote:
> > From: Long Li <longli@microsoft.com>
> >
> > FC disks are usually setup in a multipath system, and they don't want
> > to unconditionaly reset I/O on timeout. I/O timeout is detected by
> > multipath as a good time to failover and recover.
> >
> > Signed-off-by: Long Li <longli@microsoft.com>
> > ---
> >  drivers/scsi/storvsc_drv.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> > index 8d955db..d60b5ea 100644
> > --- a/drivers/scsi/storvsc_drv.c
> > +++ b/drivers/scsi/storvsc_drv.c
> > @@ -486,6 +486,7 @@ struct hv_host_device {
> >  	unsigned int port;
> >  	unsigned char path;
> >  	unsigned char target;
> > +	bool is_fc;
> >  };
> >
> >  struct storvsc_scan_work {
> > @@ -1495,6 +1496,11 @@ static int storvsc_host_reset_handler(struct
> scsi_cmnd *scmnd)
> >   */
> >  static enum blk_eh_timer_return storvsc_eh_timed_out(struct scsi_cmnd
> > *scmnd)  {
> > +	struct hv_host_device *host_dev =3D shost_priv(scmnd->device->host);
> > +
> > +	if (host_dev->is_fc)
> > +		return BLK_EH_NOT_HANDLED;
> > +
> >  	return BLK_EH_RESET_TIMER;
> >  }
> >
> > @@ -1738,6 +1744,7 @@ static int storvsc_probe(struct hv_device
> > *device,
> >
> >  	host_dev->port =3D host->host_no;
> >  	host_dev->dev =3D device;
> > +	host_dev->is_fc =3D is_fc;
> >
> >
> >  	stor_device =3D kzalloc(sizeof(struct storvsc_device), GFP_KERNEL);
>=20
> Hello Long,
>=20
> As far as I know there is no other SCSI driver nor block driver in the Li=
nux kernel
> tree that returns BLK_EH_RESET_TIMER unconditionally. Would a valid
> alternative fix be to remove storvsc_eh_timed_out() entirely? If not, wha=
t
> would break if that function would be removed entirely?

Storvsc handles virtualized devices for Hyper-V and Azure. The host decides=
 on how to handle I/O timeout, and makes decision based on how long I/O has=
 been in flight. This is why we use BLK_EH_RESET_TIMER and leave the I/O ti=
meout handling to the host for most cases.

>=20
> Additionally, for FC, shouldn't that timeout handler handle the "port blo=
cked"
> state? Shouldn't fc_eh_timed_out() be used for FC instead of just returni=
ng
> BLK_EH_NOT_HANDLED?

I agree with you. Storvsc didn't expose rport state. But this has changed w=
ith a recent commit daf0cd445a218314f9461d67d4f2b9c24cdd534b. I'll send a V=
2 to address this.

Thank you

Long

>=20
> Thanks,
>=20
> Bart.
