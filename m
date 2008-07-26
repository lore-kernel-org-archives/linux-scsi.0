From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [SCSI] can't plug Nokia 5300 anymore (bisected)
Date: Fri, 25 Jul 2008 23:43:59 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0807252342570.7216-100000@netrider.rowland.org>
References: <488A3A8A.7000603@belbone.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:4967 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751499AbYGZDoB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Jul 2008 23:44:01 -0400
In-Reply-To: <488A3A8A.7000603@belbone.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q?C=E9dric_Godin?= <cedric@belbone.be>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Kernel <linux-scsi@vger.kernel.org>

On Fri, 25 Jul 2008, C=E9dric Godin wrote:

> resending because wrong address of lkml and cc scsi list
>=20
> Hello,
>=20
> since 2 or 3 -git kernels (Linus tree)  I have a problem with my lapt=
op=20
> and its connection through USB to a nokia 5300 gsm.
>=20
> The logs show me a endless loop (until i unplug my USB cable) of=20
> following messages :
>=20
> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current]
> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current]
> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current]
> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current]
> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current]
>=20
> I bisected the kernel and found the following commit as result :
>=20
> 427e59f09fdba387547106de7bab980b7fff77be is first bad commit
> commit 427e59f09fdba387547106de7bab980b7fff77be
> Author: James Bottomley <James.Bottomley@HansenPartnership.com>
> Date:   Sat Mar 8 18:24:17 2008 -0600
>=20
>    [SCSI] make use of the residue value
>=20
>    USB sometimes doesn't return an error but instead returns a residu=
e
>    value indicating part (or all) of the command wasn't completed.  S=
o if
>    the driver _done() error processing indicates the command was full=
y
>    processed, subtract off the residue so that this USB error gets
>    propagated.
>=20
>    Cc: Alan Stern <stern@rowland.harvard.edu>
>    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.=
com>
>=20
> :040000 040000 d3bad84ebe1bc231e8e7d6267907ca62fd4d0dcd=20
> c85f8cb8bd4910724f0101e41054555980727e16 M      drivers
>=20
>=20
> When reverting it with 2.6.26-06077-gc010b2f , everything is back to =
normal.

Can you post the corresponding dmesg log from a system built with=20
CONFIG_USB_STORAGE_DEBUG enabled?

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
