From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 16/23] scsi: Add scsi_vpd_lun_id()
Date: Mon, 28 Sep 2015 09:18:32 +0200
Message-ID: <5608E9C8.8060904@suse.de>
References: <1440679281-13234-1-git-send-email-hare@suse.de>	 <1440679281-13234-17-git-send-email-hare@suse.de> <1442949475.4132.43.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37033 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756489AbbI1HSe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Sep 2015 03:18:34 -0400
In-Reply-To: <1442949475.4132.43.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On 09/22/2015 09:17 PM, Ewan Milne wrote:
[ .. ]
>=20
> scsi_vpd_lun_id() is an exported function, but does not check if sdev=
->vpd_pg83 !=3D NULL
> (i.e. no VPD 83 info), and we will crash if it is NULL.  Also, why re=
turn -EAGAIN?
> What will be different next time?  Maybe a different errno would be b=
etter, like
> -ENOENT or -ENODATA, I'm not sure.
>=20
> In the SCSI name string case, if the name has to be truncated to fit =
the supplied buffer,
> scsi_vpd_lun_id() does not ensure that the last byte is zero, it reli=
es on the caller to
> have done this, (which alua_check_vpd() does not do).  I'm not sure i=
f we should truncate
> the SCSI name string here or return an error here, as a truncated nam=
e will likely not
> be unique.
>=20
I've now updated the description, and decreased the priority if the
SCSI name descriptor is truncated. With that any other descriptor
will have preference if the SCSI name descriptor is truncated.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
