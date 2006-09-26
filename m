From: <crazyrushstar@yahoo.com.tw>
Subject: Re: scsi_scan_host will hang up my system!
Date: Tue, 26 Sep 2006 11:40:01 +0800 (CST)
Message-ID: <20060926034001.28539.qmail@web18309.mail.tpe.yahoo.com>
References: <4513C4C8.2070606@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=big5
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web18309.mail.tpe.yahoo.com ([203.84.194.91]:33688 "HELO
	web18309.mail.tpe.yahoo.com") by vger.kernel.org with SMTP
	id S1750801AbWIZDkE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Sep 2006 23:40:04 -0400
In-Reply-To: <4513C4C8.2070606@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

--- Stefan Richter <stefanr@s5r6.in-berlin.de> =BB=A1=A1G

> crazyrushstar@yahoo.com.tw wrote:
> > --- Karen Shaeffer <shaeffer@neuralscape.com> =BB=A1=A1G
> >> On Tue, Sep 19, 2006 at 09:48:46PM -0600, Matthew
> >> Wilcox wrote:
> >>> Documentation/scsi/scsi_mid_low_api.txt was of
> >>> immense help to me.
>=20
> This document is indeed essential for low-level
> driver development.
> However it doesn't (can't) tell you how to avoid
> some types of deadlocks.
>=20
> Crazyrushstar, I can't give specific advise about
> scsi_scan_host() since
> the code I'm maintaining (sbp2) doesn't use it.
> However I have some
> basic suggestions:
>=20
>  - Consider your driver a layer between Linux' SCSI
> core (higher level)
> and the interconnect software/firmware/hardware,
> e.g. PCI layer (lower
> level). Make sure that you first bring up the lower
> level, then the
> higher level. Vice versa, bring down the higher
> level before the lower
> level on driver shutdown.
>=20
>  - AFAIU your driver and everything below it has to
> be fully able to
> transfer commands, data and status before it calls
> scsi_scan_host().
>=20
>  - Also keep the layer paradigm in mind when you
> design the locking in
> your driver. Watch out for the host lock which the
> SCSI core will use on
> several occasions and which your driver may have to
> use on some
> occasions. (The low-level driver I'm maintaining
> doesn't touch the host
> lock.) A clearly layered design helps to avoid
> deadlocks.
>=20
>  - Don't use the scsi_block_requests()/
> scsi_unblock_requests() API.
> (The code I'm maintaining is using these, and it is
> a nightmare because
> it easily leads into deadlocks. I will rework that
> driver to not use
> these calls anymore.) The scsi_block_requests()/
> scsi_unblock_requests()
> API manipulates host state on a low level,
> subverting the SCSI core's
> assumptions about host/ target/ LU states. This and
> similar
> manipulations of host/ target/ LU state are better
> _not_ done in a SCSI
> low-level driver.
>=20
> ...
> >> I also would purchase the applicable scsi
> standards.
> >>=20
> >> http://www.t10.org/
>=20
> The drafts at http://www.t10.org/ftp/t10/drafts/ may
> suffice too, at
> least to get started.
>=20
> ...
> > I have google out a link=20
> >
>
"http://www.mjmwired.net/kernel/Documentation/scsi/scsi_mid_low_api.txt=
"
> ...
>=20
> "Documentation/" is a subdirectory of the Linux
> kernel source distribution.
>=20
> Another essential resource are of course the sources
> themselves. Good
> tools to browse the code are Cscope or KScope or
> LXR:
> http://free-electrons.com/community/kernel/lxr
>=20
> You certainly already read the sources in
> include/scsi/.
> --=20
> Stefan Richter
> -=3D=3D=3D=3D=3D-=3D-=3D=3D- =3D--=3D =3D--=3D=3D
> http://arcgraph.de/sr/
>=20
Now I have make my driver work well under a
environment without a lun(This is a RAID card). After
insmod , inquery(12H) , report lun(A0H) received 8
times. Syetem   is alive.

If I insmod after make a lun, system will hangup
within 2 secends. All message printed by printk wont
show so that I dont know where is wrong.

I Use  "tail -f /var/log/messages &" to observe kernel
log.

I have debug two days, but no more ideas for this
situation.

___________________________________________________=20
 =B1z=AA=BA=A5=CD=AC=A1=A7Y=AE=C9=B3q =A1=D0 =B7=BE=B3q=A1B=AET=BC=D6=A1=
B=A5=CD=AC=A1=A1B=A4u=A7@=A4@=A6=B8=B7d=A9w=A1I=20
 http://messenger.yahoo.com.tw/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
