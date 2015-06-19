From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH resend] mpt2sas: setpci reset kernel panic fix
Date: Fri, 19 Jun 2015 13:39:11 +0200
Message-ID: <20150619113911.GD10784@c203.arch.suse.de>
References: <20150619111644.GA25830@nagalsi.ban.indi.seagate.com>
 <20150619111512.GA12992@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43561 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707AbbFSLjO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Jun 2015 07:39:14 -0400
Content-Disposition: inline
In-Reply-To: <20150619111512.GA12992@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Nagarajkumar Narayanan <nagarajkumar.narayanan@seagate.com>, linux-scsi@vger.kernel.org

On Fri, Jun 19, 2015 at 04:15:12AM -0700, Christoph Hellwig wrote:
> > @@ -79,7 +79,8 @@ static int _scsih_scan_finished(struct Scsi_Host =
*shost, unsigned long time);
> > =20
> >  /* global parameters */
> >  LIST_HEAD(mpt2sas_ioc_list);
> > -
> > +/* global ioc lock for list operations */
> > +spinlock_t gioc_lock;
> >  /* local parameters */
> >  static u8 scsi_io_cb_idx =3D -1;
> >  static u8 tm_cb_idx =3D -1;
> > @@ -279,6 +280,20 @@ static struct pci_device_id scsih_pci_table[] =
=3D {
> >  MODULE_DEVICE_TABLE(pci, scsih_pci_table);
> > =20
> >  /**
> > + * mpt2sas_initialize_gioc_lock - initialize the gobal ioc lock
> > + */
> > +void
> > +mpt2sas_initialize_gioc_lock(void)
> > +{
> > +	static int gioc_lock_initialize;
> > +
> > +	if (!gioc_lock_initialize) {
> > +		spin_lock_init(&gioc_lock);
> > +		gioc_lock_initialize =3D 1;
> > +	}
> > +}
>=20
> Just use DEFINE_SPINLOCK() to initialize the lock at compile time.

Or yes, even better.

--=20
Johannes Thumshirn                                       Storage
jthumshirn@suse.de                             +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
