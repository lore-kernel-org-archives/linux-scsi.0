From: Martin Peschke <mpeschke@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/4] scsi_debug: fix endianness bug in
 sdebug_build_parts()
Date: Mon, 29 Jul 2013 12:53:36 +0200
Message-ID: <1375095216.27146.3.camel@br9vgx5g.de.ibm.com>
References: <1373889127-17083-1-git-send-email-akinobu.mita@gmail.com>
	 <1373889127-17083-2-git-send-email-akinobu.mita@gmail.com>
	 <1374772228.15813.3.camel@br9vgx5g.de.ibm.com>
	 <CAC5umyi8LkZ1kETSpbDNSu2YaAJRXf6Ag0VYCPdFs4zD2hqeKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:44060 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab3G2Kxm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jul 2013 06:53:42 -0400
Received: from /spool/local
	by e06smtp18.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mpeschke@linux.vnet.ibm.com>;
	Mon, 29 Jul 2013 11:47:26 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
	by d06dlp01.portsmouth.uk.ibm.com (Postfix) with ESMTP id 3317917D8058
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jul 2013 11:55:22 +0100 (BST)
Received: from d06av03.portsmouth.uk.ibm.com (d06av03.portsmouth.uk.ibm.com [9.149.37.213])
	by b06cxnps3074.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r6TArRxS62652512
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jul 2013 10:53:27 GMT
Received: from d06av03.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av03.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id r6TArbcP022160
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jul 2013 04:53:38 -0600
In-Reply-To: <CAC5umyi8LkZ1kETSpbDNSu2YaAJRXf6Ag0VYCPdFs4zD2hqeKQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>

On Sat, 2013-07-27 at 02:07 +0900, Akinobu Mita wrote:
> 2013/7/26 Martin Peschke <mpeschke@linux.vnet.ibm.com>:
> > On Mon, 2013-07-15 at 20:52 +0900, Akinobu Mita wrote:
> >> With module parameter num_parts > 0, partition table is built on t=
he
> >> ramdisk storage when loading the driver.  Unfortunately, there is =
an
> >> endianness bug in sdebug_build_parts().  So the partition table is=
 not
> >> correctly initialized on big-endian systems.
> >>
> >> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> >> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> >> Cc: Douglas Gilbert <dgilbert@interlog.com>
> >> Cc: linux-scsi@vger.kernel.org
> >> ---
> >>  drivers/scsi/scsi_debug.c | 4 ++--
> >>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> >> index cb4fefa..2f39b13 100644
> >> --- a/drivers/scsi/scsi_debug.c
> >> +++ b/drivers/scsi/scsi_debug.c
> >> @@ -2659,8 +2659,8 @@ static void __init sdebug_build_parts(unsign=
ed char *ramp,
> >>                              / sdebug_sectors_per;
> >>               pp->end_sector =3D (end_sec % sdebug_sectors_per) + =
1;
> >>
> >> -             pp->start_sect =3D start_sec;
> >> -             pp->nr_sects =3D end_sec - start_sec + 1;
> >> +             pp->start_sect =3D cpu_to_le32(start_sec);
> >> +             pp->nr_sects =3D cpu_to_le32(end_sec - start_sec + 1=
);
> >>               pp->sys_ind =3D 0x83;     /* plain Linux partition *=
/
> >>       }
> >>  }
> >
> >
> > I have posted the same fix several times, e.g.
> > http://marc.info/?l=3Dlinux-scsi&m=3D137051617907423&w=3D2
> > Good luck!
> >
> > Acked-by: Martin Peschke <mpeschke@linux.vnet.ibm.com>
>=20
> Thanks.  I found this problem from sparse warning noticed by 0-DAY ke=
rnel
> build testing.

It surfaced as a real problem on System z (big endian).
That is why I can confirm that the above patch works.

Thanks,
Martin


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
