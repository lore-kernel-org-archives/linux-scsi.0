From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] scsi: Allow activation of scsi-mq per-driver
Date: Mon, 25 Jan 2016 11:16:14 +0100
Message-ID: <20160125101614.GD29561@c203.arch.suse.de>
References: <1453470088-43959-1-git-send-email-jthumshirn@suse.de>
 <20160125100525.GA24369@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59581 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755796AbcAYKQR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Jan 2016 05:16:17 -0500
Content-Disposition: inline
In-Reply-To: <20160125100525.GA24369@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hiral Patel <hiralpat@cisco.com>, Suma Ramars <sramars@cisco.com>, Brian Uchino <buchino@cisco.com>, James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org

On Mon, Jan 25, 2016 at 02:05:25AM -0800, Christoph Hellwig wrote:
> On Fri, Jan 22, 2016 at 02:41:28PM +0100, Johannes Thumshirn wrote:
> > Allow the activation of the scsi-mq feature on a per-driver bassis =
as opposed
> > to the current stack global (de)activation.
> >=20
> > This allows us to have setups which can combine "slow" rotational m=
edia and
> > fast media on two different HBA types.
>=20
> It's still the wrong thing to do.  One of your co-workers has been
> working on slicing for blk-mq to better support slower adapters.

I know but there are no results yet.

>=20
> Anything that prolongs the misery of keeping the old request code aro=
und
> is a bad idea.

Agreed, but this patch is a "quick fix" for the problem until the nice =
solution
is in place. The way it currently works is unacceptable from a distribu=
tion
point of view.

>=20
> > The following is from a host with rotational disks behind a HP SAS =
Adapter and
> > a fibre channel array behind a Emulex FC Adapter. The hpsa driver d=
oes not
> > support scsi-mq yet (and has rotational disks attached to it), but =
the lpfc
> > does. This patch allows an optimal combination of the scsi-mq enabl=
ed lpfc
> > driver and the hpsa driver which still uses a single queue scsi lay=
er and thus
> > can make use of IO schedulers.
>=20
> And this is another reason why this is bad.  There are very slow dumb
> FC array arounds as well as really fast ones.  And there are really s=
low
> SATA disks behind SAS controllers as well as really fast SSDs.
>=20
> The host is simply the wrong place to decide these things.


Yes, but this way the admin can _decide_ on which driver's he/she is go=
ing to
activate scsi-mq and on which not. Of casue this only solves the issue =
if
multiple drivers are involved, but still better than a global on/off sw=
itch.

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
