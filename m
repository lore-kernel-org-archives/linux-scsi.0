From: Martin Peschke <mpeschke@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/4] scsi_debug: fix endianness bug in
 sdebug_build_parts()
Date: Thu, 25 Jul 2013 19:10:28 +0200
Message-ID: <1374772228.15813.3.camel@br9vgx5g.de.ibm.com>
References: <1373889127-17083-1-git-send-email-akinobu.mita@gmail.com>
	 <1373889127-17083-2-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:38561 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983Ab3GYRKf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Jul 2013 13:10:35 -0400
Received: from /spool/local
	by e06smtp17.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mpeschke@linux.vnet.ibm.com>;
	Thu, 25 Jul 2013 18:06:03 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
	by d06dlp02.portsmouth.uk.ibm.com (Postfix) with ESMTP id 22EF82190069
	for <linux-scsi@vger.kernel.org>; Thu, 25 Jul 2013 18:14:40 +0100 (BST)
Received: from d06av03.portsmouth.uk.ibm.com (d06av03.portsmouth.uk.ibm.com [9.149.37.213])
	by b06cxnps3075.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r6PHAImC38076534
	for <linux-scsi@vger.kernel.org>; Thu, 25 Jul 2013 17:10:18 GMT
Received: from d06av03.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av03.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id r6PHASr0004628
	for <linux-scsi@vger.kernel.org>; Thu, 25 Jul 2013 11:10:29 -0600
In-Reply-To: <1373889127-17083-2-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>

On Mon, 2013-07-15 at 20:52 +0900, Akinobu Mita wrote:
> With module parameter num_parts > 0, partition table is built on the
> ramdisk storage when loading the driver.  Unfortunately, there is an
> endianness bug in sdebug_build_parts().  So the partition table is no=
t
> correctly initialized on big-endian systems.
>=20
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: Douglas Gilbert <dgilbert@interlog.com>
> Cc: linux-scsi@vger.kernel.org
> ---
>  drivers/scsi/scsi_debug.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index cb4fefa..2f39b13 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -2659,8 +2659,8 @@ static void __init sdebug_build_parts(unsigned =
char *ramp,
>  			       / sdebug_sectors_per;
>  		pp->end_sector =3D (end_sec % sdebug_sectors_per) + 1;
>=20
> -		pp->start_sect =3D start_sec;
> -		pp->nr_sects =3D end_sec - start_sec + 1;
> +		pp->start_sect =3D cpu_to_le32(start_sec);
> +		pp->nr_sects =3D cpu_to_le32(end_sec - start_sec + 1);
>  		pp->sys_ind =3D 0x83;	/* plain Linux partition */
>  	}
>  }


I have posted the same fix several times, e.g.
http://marc.info/?l=3Dlinux-scsi&m=3D137051617907423&w=3D2
Good luck!

Acked-by: Martin Peschke <mpeschke@linux.vnet.ibm.com>


--=20
Linux on System z Development

IBM Deutschland Research & Development GmbH
Vorsitzende des Aufsichtsrats: Martina Koederitz
Gesch=C3=A4ftsf=C3=BChrung: Dirk Wittkopp
Sitz der Gesellschaft: B=C3=B6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
