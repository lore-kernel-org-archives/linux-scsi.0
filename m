From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH 11/17] smartpqi: minor tweaks to update time support
Date: Tue, 30 Aug 2016 15:26:15 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D1916398EE9@avsrvexchmbx1.microsemi.net>
References: <147222977996.31214.8588187948847476082.stgit@brunhilda>
 <147222991200.31214.16478440159265351246.stgit@brunhilda>
 <20160829093338.3juwfp6xcjzib26h@c203.arch.suse.de>
 <4993A297653ECB4581FA5C3C31323D1916398BE9@avsrvexchmbx1.microsemi.net>
 <20160830071735.mobvb4v4y45tn5mt@c203.arch.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0053.outbound.protection.outlook.com ([104.47.41.53]:20518
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753595AbcH3P0n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 Aug 2016 11:26:43 -0400
In-Reply-To: <20160830071735.mobvb4v4y45tn5mt@c203.arch.suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, Viswas G <viswas.g@microsemi.com>, Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>, "hch@infradead.org" <hch@infradead.org>, Scott Teel <scott.teel@microsemi.com>, Kevin Barnett <kevin.barnett@microsemi.com>, Justin Lindley <justin.lindley@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, "elliott@hpe.com" <elliott@hpe.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> -----Original Message-----
> From: Johannes Thumshirn [mailto:jthumshirn@suse.de]
> Sent: Tuesday, August 30, 2016 2:18 AM
> To: Don Brace
> Cc: jejb@linux.vnet.ibm.com; Viswas G; Mahesh Rajashekhara;
> hch@infradead.org; Scott Teel; Kevin Barnett; Justin Lindley; Scott Benes=
h;
> elliott@hpe.com; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH 11/17] smartpqi: minor tweaks to update time support
>=20
> EXTERNAL EMAIL
>=20
>=20
> On Mon, Aug 29, 2016 at 08:29:20PM +0000, Don Brace wrote:
> > > -----Original Message-----
> > > From: Johannes Thumshirn [mailto:jthumshirn@suse.de]
>=20
> [...]
>=20
> >
> > The reason is that we want it run immediately (or close to immediately)=
.
> >
> > The code could be restructured to avoid calling this function with a 0,=
 but it
> would result in more code and no benefit.
>=20
> OK, now I'm not sure if we talked past each other. I didn't mean
> "don't call schedule_delayed_work() with a delay of 0" but "why aren't
> you using schedule_work() instead". But maybe it's just too early in
> the morning and I didn't have enough coffee yet.

Because the two functions take different work structures as arguments:

static inline bool schedule_delayed_work(struct delayed_work *dwork,
					 unsigned long delay)

static inline bool schedule_work(struct work_struct *work)


>=20
> Thanks,
>         Johannes
>=20
> --
> Johannes Thumshirn                                          Storage
> jthumshirn@suse.de                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
