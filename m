From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2 1/2] mpt3sas: Free memory pools before retrying to
 allocate with different value.
Date: Thu, 18 Feb 2016 14:10:17 +0100
Message-ID: <20160218131017.GX18134@c203.arch.suse.de>
References: <1455784786-19086-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <56C5BEEA.7030004@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56C5BEEA.7030004@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, krishnaraddi.mankani@broadcom.com, linux-kernel@vger.kernel.org, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com, Suganath prabu Subramani <suganath-prabu.subramani@avagotech.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Feb 18, 2016 at 01:54:02PM +0100, Tomas Henzl wrote:
> On 18.2.2016 09:39, Suganath Prabu Subramani wrote:
> > From: Suganath prabu Subramani <suganath-prabu.subramani@avagotech.=
com>
> >
> > Deallocate resources before reallocating of the same in retry_alloc=
ation
> > path of _base_allocate_memory_pools()
> >
> > Signed-off-by: Suganath prabu Subramani <suganath-prabu.subramani@a=
vagotech.com>
> > Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
> > ---
> >  drivers/scsi/mpt3sas/mpt3sas_base.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt=
3sas/mpt3sas_base.c
> > index afdb13a..5bbbbf2 100644
> > --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> > +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> > @@ -3414,6 +3414,7 @@ _base_allocate_memory_pools(struct MPT3SAS_AD=
APTER *ioc,  int sleep_flag)
> >  			goto out;
> >  		retry_sz =3D 64;
> >  		ioc->hba_queue_depth -=3D retry_sz;
> > +		_base_release_memory_pools(ioc);
> >  		goto retry_allocation;
> >  	}
> > =20
>=20
> Reviewed-by: Tomas Henzl <thenzl@redhat.com>
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
