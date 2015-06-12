From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 04/20] [SCSI] mpt3sas: Remove redundancy code while
 freeing the controller resources.
Date: Fri, 12 Jun 2015 14:40:24 +0200
Message-ID: <20150612124024.GB16614@c203.arch.suse.de>
References: <1434102153-38581-1-git-send-email-Sreekanth.Reddy@avagotech.com>
 <1434102153-38581-5-git-send-email-Sreekanth.Reddy@avagotech.com>
 <20150612112826.GC2812@c203.arch.suse.de>
 <CAK=zhgoUDDgmC8iDOqCkONNm-u4B3sNWYLRXJNTgXfqWs9nbPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAK=zhgoUDDgmC8iDOqCkONNm-u4B3sNWYLRXJNTgXfqWs9nbPw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: "jejb@kernel.org" <jejb@kernel.org>, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Sathya Prakash <Sathya.Prakash@avagotech.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jun 12, 2015 at 05:48:56PM +0530, Sreekanth Reddy wrote:
> On Fri, Jun 12, 2015 at 4:58 PM, Johannes Thumshirn <jthumshirn@suse.=
de> wrote:
> > On Fri, Jun 12, 2015 at 03:12:16PM +0530, Sreekanth Reddy wrote:
> >> Removed the redundancy code while freeing the controller resources=
=2E
> >>
> >> Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
> >> ---
> >>  drivers/scsi/mpt3sas/mpt3sas_base.c | 57 +++++++++++++++++++++---=
-------------
[...]
> >> +     _base_free_irq(ioc);
> >> +     _base_disable_msix(ioc);
> >> +
> >> +     if (ioc->msix96_vector)
> >> +             kfree(ioc->replyPostRegisterIndex);
> >
> > kfree() already checks for zero or a NULL pointer.
>=20
> Sorry Johannes, I didn't get you. If I understand this correctly, you
> are suggesting to check for NULL pointer before calling kree() API as
> shown below,
>=20
> if (ioc->msix96_vector && (ioc->replyPostRegisterIndex !=3D NULL))
>         kfree(ioc->replyPostRegisterIndex);

Correct me if I'm wrong, but I thought you don't need the if
(ioc->msix96_vector) before the kfree(). ioc->replyPostRegisterIndex sh=
ould be
NULL if ioc->msix96_vector is 0, as far as I can see.

In _scsih_probe() you have:
shost =3D scsi_host_alloc(&scsih_driver_template,
            sizeof(struct MPT3SAS_ADAPTER));
if (!shost)
           return -ENODEV;

/* init local params */
ioc =3D shost_priv(shost);

and scsi_host_alloc() does a kzalloc() for shost.

so ioc->replyPortRegisterIndex is NULL.

Or am I thinking wrong here?

>=20
> Regards,
> Sreekanth

--=20
Johannes Thumshirn                                       Storage
jthumshirn@suse.de                             +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
