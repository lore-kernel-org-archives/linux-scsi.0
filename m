From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH scsi-misc-2.6] allow REPORT LUN scanning even for LUN
 0 PQ of 3
Date: Thu, 08 Sep 2005 08:26:04 +0200
Message-ID: <431FD97C.7010600@suse.de>
References: <20050830224316.GA11210@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:25504 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S932672AbVIHG0V convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Sep 2005 02:26:21 -0400
In-Reply-To: <20050830224316.GA11210@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
> James -
>=20
> Can you ack or comment?
>=20
> Allow REPORT LUN scanning even if LUN 0 reports a peripheral qualifie=
r of
> 3 (effectively no storage is available on LUN 0).
>=20
> Similar patch I previously posted:
>=20
> http://marc.theaimsgroup.com/?l=3Dlinux-scsi&m=3D110297733824960&w=3D=
2
>=20
> There is also Hannes patch, it leaves LUN 0 available for use via use=
r
> space, for compatibility it likely requires that it stay visible in t=
he
> future:
>=20
> http://marc.theaimsgroup.com/?l=3Dlinux-scsi&m=3D111692497200507&w=3D=
2
>=20
> Hannes' patch also causes a lot of extra vSCSI devices to show up on =
some
> platforms :)
>=20
We definitely need something like this. The current scan algorithms is
just plain broken for targets where LUN 0 has no device attached.
It is perfectly valid for storage servers to have a LUN 0 with no devic=
e
attached (say, for control purposes) and let the client figure out the
current configuration via REPORT LUN.
Without this patch Linux simply cannot handle such setups.

James, do consider to include this patch into scsi-misc.


> Signed-off-by: Patrick Mansfield <patmans@us.ibm.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
