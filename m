From: Josef =?iso-8859-1?Q?M=F6llers?=
	<josef.moellers@fujitsu-siemens.com>
Subject: Re: Problems with higher SCSI LUN's with SLES8
Date: Wed, 17 Sep 2003 09:15:28 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F680A10.D2658EF4@fujitsu-siemens.com>
References: <A00BBCF927F25E4A9D5F6EE1380CDEF2CC88@hedwig.ysl.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from plam.fujitsu-siemens.com ([217.115.66.9]:3625 "EHLO
	plam.fujitsu-siemens.com") by vger.kernel.org with ESMTP
	id S262694AbTIQHO6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Sep 2003 03:14:58 -0400
List-Id: linux-scsi@vger.kernel.org
To: "Zuylen, G. van" <GvZuylen@ysl.nl>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

"Zuylen, G. van" wrote:
>=20
> Hi you all,
>=20
> We are using a HP DL380 server with a Qlogic 2300 HBA adapter. This a=
dapter
> is connected to a HP EMA12000 SAN (with HSG80 controllers). Behind th=
e HBA
> (qlogic 2300) we see only the devices up to LUN 7, higher LUN are not
> detected. We have tried several things like modifying /etc/modules.co=
nf with
> "options scsi_mod max_scsi_luns=3D128" and modifying /boot/grub/menu.=
lst. But
> nothing seems to be working.
> We are using SLES8 with kernel version k_smp-2.4.19-304 and the qlogi=
c
> driver version 6.05.60. Also tested with a newer kernel k_smp-2.4.19-=
340,
> but this makes no difference.
>=20
> Does anybody know how we can solve this problem or is there somebody =
who has
> experience with this ?

What does /proc/scsi/scsi say about the ANSI SCSI revision? If it says
"02", then you'll need to change the scsi mid-layer: the current code
(and even future code B-{( will not scan beyond ID 7 on SCSI-2 devices.

--=20
Josef M=F6llers (Pinguinpfleger bei FSC)
	If failure had no penalty success would not be a prize
						-- T.  Pratchett
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
