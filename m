From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: [PATCH v2 0/2 2.6.29] cxgb3i -- open-iscsi initiator acceleration
Date: Tue, 16 Dec 2008 13:22:29 +0200
Message-ID: <20081216112229.GT15052@edu.joroinen.fi>
References: <200812092215.mB9MFMZt015198@localhost.localdomain> <20081215140545.GQ15052@edu.joroinen.fi> <8A71B368A89016469F72CD08050AD33403FF300F@maui.asicdesigners.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from edu.joroinen.fi ([194.89.68.130]:58702 "EHLO edu.joroinen.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765AbYLPLWb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Dec 2008 06:22:31 -0500
Content-Disposition: inline
In-Reply-To: <8A71B368A89016469F72CD08050AD33403FF300F@maui.asicdesigners.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com
Cc: linux-scsi@vger.kernel.org

On Mon, Dec 15, 2008 at 05:52:54PM -0800, Karen Xie wrote:
>=20
> Hi, Pasi,
>=20
> Here are some throughput numbers we see with disktest, one tcp connec=
tion (iscsi session).
>=20
> The setup are between a pair of chelsio 10G adapters. The target is C=
helsio's ramdisk target with data discarded (similiar to IET's NULLIO m=
ode). The Chelsio target is used because of the digest offload and payl=
oad ddp.=20
>=20
> The ethernet frame is standard 1500 bytes.
>=20
> The numbers are about 3 months old, but you get the idea :) For cxgb3=
i driver, since the digest is offloaded the performance is very similar=
 in the digest off case, so only the numbers for digest on are shown.
>

Thanks! cxgb3i acceleration seems to have a nice performance boost comp=
ared
to plain iscsi-tcp.. especially if having digest on!=20

> We will re-run the tests and get the cpu stats too, will keep you pos=
ted.
>=20

Yep, cpu stats would be really nice to have too.

-- Pasi

>=20
> Test         cxgb3i         iscsi-tcp         iscsi-tcp
>              digest on      digest on         digest off
>              (MB/sec)       (MB/sec)          (MB/sec)
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> 512-read     36.85           34.13            36.69
> 1k-read      71.91           58.52            66.81
> 2k-read      137.24          97.75            128.46
> 4k-read      280.61         137.98            214.04
> 8k-read      531.34         201.87            325.09
> 16k-read     953.67         226.49            429.32
> 64k-read     1099.57        248.57            626.30
> 128k-read    1102.65        256.04            613.94
> 256k-read    1105.28        262.28            642.73
> =20
> 512-write    39.54           34.18             38.36
> 1k-write     79.52           56.51             75.06
> 2k-write     158.03          84.12            140.85
> 4k-write     314.56         126.33            282.72
> 8k-write     559.83         155.49            528.24
> 16k-write    968.84         168.50            676.38
> 64k-write    1099.31        182.82            978.82
> 128k-write   1074.62        182.55            974.18
> 256k-write   1063.85        185.67            972.88
>=20
>=20
> -----Original Message-----
> From: Pasi K=E4rkk=E4inen [mailto:pasik@iki.fi]=20
> Sent: Monday, December 15, 2008 6:06 AM
> To: open-iscsi@googlegroups.com
> Cc: linux-scsi@vger.kernel.org; michaelc@cs.wisc.edu; James.Bottomley=
@HansenPartnership.com; Karen Xie
> Subject: Re: [PATCH v2 0/2 2.6.29] cxgb3i -- open-iscsi initiator acc=
eleration
>=20
> On Tue, Dec 09, 2008 at 02:15:22PM -0800, Karen Xie wrote:
> >=20
> > [PATCH v2 0/2 2.6.29] cxgb3i -- open-iscsi initiator acceleration=20
> >=20
> > From: Karen Xie <kxie@chelsio.com>
> >=20
> > Here is the updated patchset for adding cxgb3i iscsi initiator.
> >=20
> > The updated version incorporates the comments from Mike and Boaz:
> > - remove the cxgb3 sysfs entry for the private iscsi ip address, it=
 can be
> >   accessed from iscsi.
> > - in cxgb3i.txt, added error message logged for not setting MaxRecv=
DataSegmentLength properly.
> > - renamed cxgb3i Makefile to Kbuild
> > - removed "select ISCSI_TCP" in Kconfig
> > - consistent handling of AHS: on tx, reserve rooms for AHS; on rx, =
assume we could receive AHS.
> > - add support of bi-directional commands for ddp setup,
> >=20
> > The cxgb3i driver, especially the part handles the offloaded iscsi =
tcp connection mangement, has gone through the netdev review (http://ma=
rc.info/?l=3Dlinux-netdev&m=3D121944339211552, http://marc.info/?l=3Dli=
nux-netdev&m=3D121989660016124).
> >=20
> > The cxgb3i driver provides iscsi acceleration (PDU offload and payl=
oad data direct placement) to the open-iscsi initiator. It accesses the=
 hardware through the cxgb3 module.
> >=20
>=20
> Hello!
>=20
> Do you guys have performance comparison/numbers for normal open-iscsi=
 over tcp vs. cxgb3i accelerated?
>=20
> Would be nice to see throughput/iops/cpu-usage statistics..
>=20
> -- Pasi
>=20
> --~--~---------~--~----~------------~-------~--~----~
> You received this message because you are subscribed to the Google Gr=
oups "open-iscsi" group.
> To post to this group, send email to open-iscsi@googlegroups.com
> To unsubscribe from this group, send email to open-iscsi+unsubscribe@=
googlegroups.com
> For more options, visit this group at http://groups.google.com/group/=
open-iscsi
> -~----------~----~----~----~------~----~------~--~---
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
