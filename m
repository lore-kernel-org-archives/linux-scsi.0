From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] be2iscsi: Fix memory leak in beiscsi_alloc_mem()
Date: Wed, 10 Feb 2016 12:07:41 +0100
Message-ID: <20160210110741.GS27969@c203.arch.suse.de>
References: <1443689785-13712-1-git-send-email-mlombard@redhat.com>
 <56BB0D53.9010103@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56746 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781AbcBJLHs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Feb 2016 06:07:48 -0500
Content-Disposition: inline
In-Reply-To: <56BB0D53.9010103@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: linux-scsi@vger.kernel.org, jayamohan.kallickal@avagotech.com, minh.tran@avagotech.com, sony.john-n@avagotech.com, James.Bottomley@HansenPartnership.com

On Wed, Feb 10, 2016 at 11:13:39AM +0100, Maurizio Lombardi wrote:
> ping.
>=20
> On 10/01/2015 10:56 AM, Maurizio Lombardi wrote:
> > In case of error, the memory allocated for phwi_ctrlr was not freed=
=2E
> >=20
> > Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> > ---
> >  drivers/scsi/be2iscsi/be_main.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscs=
i/be_main.c
> > index 7a6dbfb..360aa88 100644
> > --- a/drivers/scsi/be2iscsi/be_main.c
> > +++ b/drivers/scsi/be2iscsi/be_main.c
> > @@ -2706,8 +2706,10 @@ static int beiscsi_alloc_mem(struct beiscsi_=
hba *phba)
> >  	phwi_ctrlr->wrb_context =3D kzalloc(sizeof(struct hwi_wrb_context=
) *
> >  					  phba->params.cxns_per_ctrl,
> >  					  GFP_KERNEL);
> > -	if (!phwi_ctrlr->wrb_context)
> > +	if (!phwi_ctrlr->wrb_context) {
> > +		kfree(phba->phwi_ctrlr);
> >  		return -ENOMEM;
> > +	}
> > =20
> >  	phba->init_mem =3D kcalloc(SE_MEM_MAX, sizeof(*mem_descr),
> >  				 GFP_KERNEL);
> >=20
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
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
