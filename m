From: Jean Delvare <jdelvare@suse.de>
Subject: Re: Kernel oops on st module cycling
Date: Thu, 07 Mar 2013 13:48:04 +0100
Message-ID: <1362660484.4312.11.camel@amber.site>
References: <1361538170.24311.209.camel@amber.site>
	 <alpine.DEB.2.02.1302221017330.1736@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:32774 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625Ab3CGMsA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Mar 2013 07:48:00 -0500
In-Reply-To: <alpine.DEB.2.02.1302221017330.1736@jlaw-desktop.mno.stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <Joe.Lawrence@stratus.com>
Cc: Kai =?ISO-8859-1?Q?M=E4kisara?= <Kai.Makisara@kolumbus.fi>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

Hi Joe,

Thanks for your fast answer.

Le vendredi 22 f=C3=A9vrier 2013 =C3=A0 10:30 -0500, Joe Lawrence a =C3=
=A9crit :
> I remember finding an st module load/unload kref accounting bug a whi=
le=20
> ago: http://thread.gmane.org/gmane.linux.scsi/77539  I replied to the=
=20
> report with a hack-patch that grabbed an extra reference to avoid the=
=20
> crash.
>=20
> There was an attempt at fixing this up in the block layer [1] but tha=
t=20
> change was pulled when problems were found with that patch [2].
>=20
> [1] https://lkml.org/lkml/2012/8/27/354
> [2] https://lkml.org/lkml/2012/9/22/113
>=20
> Maybe this is the same bug?

Seems so. Meanwhile I saw you posted an update at:
http://marc.info/?l=3Dlinux-scsi&m=3D136249932603011&w=3D2

I have tested this patch successfully, and apparently others have as
well, so I would suggest to get this upstream ASAP. I think this fix is
a candidate for stable kernel series as well.

Note for backporters: the value returned by blk_get_queue() changed in
kernel 3.3, so care must be taken when backporting the fix to kernel 3.=
2
or older, otherwise success becomes failure and vice versa.

Thanks,
--=20
Jean Delvare
Suse L3

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
