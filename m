From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 04/20] [SCSI] mpt3sas: Remove redundancy code while
 freeing the controller resources.
Date: Mon, 15 Jun 2015 12:48:05 +0200
Message-ID: <20150615104805.GA10429@c203.arch.suse.de>
References: <1434102153-38581-1-git-send-email-Sreekanth.Reddy@avagotech.com>
 <1434102153-38581-5-git-send-email-Sreekanth.Reddy@avagotech.com>
 <20150612112826.GC2812@c203.arch.suse.de>
 <CAK=zhgoUDDgmC8iDOqCkONNm-u4B3sNWYLRXJNTgXfqWs9nbPw@mail.gmail.com>
 <20150612124024.GB16614@c203.arch.suse.de>
 <CAK=zhgqsSWUOGU+cjrwPtagu5tCCtM4jeD67+Xm5r1kTKx5T6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40930 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754046AbbFOKsN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Jun 2015 06:48:13 -0400
Content-Disposition: inline
In-Reply-To: <CAK=zhgqsSWUOGU+cjrwPtagu5tCCtM4jeD67+Xm5r1kTKx5T6A@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: "jejb@kernel.org" <jejb@kernel.org>, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Sathya Prakash <Sathya.Prakash@avagotech.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Mon, Jun 15, 2015 at 03:56:56PM +0530, Sreekanth Reddy wrote:
> On Fri, Jun 12, 2015 at 6:10 PM, Johannes Thumshirn <jthumshirn@suse.=
de> wrote:
> > On Fri, Jun 12, 2015 at 05:48:56PM +0530, Sreekanth Reddy wrote:
> >> On Fri, Jun 12, 2015 at 4:58 PM, Johannes Thumshirn <jthumshirn@su=
se.de> wrote:
> >> > On Fri, Jun 12, 2015 at 03:12:16PM +0530, Sreekanth Reddy wrote:
> >> >> Removed the redundancy code while freeing the controller resour=
ces.
> >> >>
> >> >> Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
> >> >> ---
> >> >>  drivers/scsi/mpt3sas/mpt3sas_base.c | 57 +++++++++++++++++++++=
----------------
> > [...]
> >> >> +     _base_free_irq(ioc);
> >> >> +     _base_disable_msix(ioc);
> >> >> +
> >> >> +     if (ioc->msix96_vector)
> >> >> +             kfree(ioc->replyPostRegisterIndex);
> >> >
> >> > kfree() already checks for zero or a NULL pointer.
> >>
> >> Sorry Johannes, I didn't get you. If I understand this correctly, =
you
> >> are suggesting to check for NULL pointer before calling kree() API=
 as
> >> shown below,
> >>
> >> if (ioc->msix96_vector && (ioc->replyPostRegisterIndex !=3D NULL))
> >>         kfree(ioc->replyPostRegisterIndex);
> >
> > Correct me if I'm wrong, but I thought you don't need the if
> > (ioc->msix96_vector) before the kfree(). ioc->replyPostRegisterInde=
x should be
> > NULL if ioc->msix96_vector is 0, as far as I can see.
> >
> > In _scsih_probe() you have:
> > shost =3D scsi_host_alloc(&scsih_driver_template,
> >             sizeof(struct MPT3SAS_ADAPTER));
> > if (!shost)
> >            return -ENODEV;
> >
> > /* init local params */
> > ioc =3D shost_priv(shost);
> >
> > and scsi_host_alloc() does a kzalloc() for shost.
> >
> > so ioc->replyPortRegisterIndex is NULL.
> >
> > Or am I thinking wrong here?
>=20
> Yes, ioc->replyPostRegisterIndex will be NULL if ioc->msix96_vector i=
s 0,
> We have added this checks as a precautionary. since calling this
> function (i.e kfree()) on memory not previously allocated with
> kmalloc(), or on memory which has already been freed, may results in
> very bad things, such as freeing memory belonging to another part of
> the kernel.
>

OK, then please leave it in.

> >
> >>
> >> Regards,
> >> Sreekanth
> >
> > --
> > Johannes Thumshirn                                       Storage
> > jthumshirn@suse.de                             +49 911 74053 689
> > SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> > GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
> > HRB 21284 (AG N=FCrnberg)
>=20
>=20
>=20
> --=20
>=20
> Regards,
> Sreekanth

--=20
Johannes Thumshirn                                       Storage
jthumshirn@suse.de                             +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
