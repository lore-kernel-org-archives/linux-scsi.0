From: "Karen Xie" <kxie-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: RE: [PATCH v2 0/2 2.6.29] cxgb3i -- open-iscsi initiator acceleration
Date: Mon, 15 Dec 2008 17:52:54 -0800
Message-ID: <8A71B368A89016469F72CD08050AD33403FF300F@maui.asicdesigners.com>
References: <200812092215.mB9MFMZt015198@localhost.localdomain> <20081215140545.GQ15052@edu.joroinen.fi>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <grbounce-FC1hwAUAAAA0O9VQcsxVj1UPjHD9r3x_=glio-open-iscsi=m.gmane.org-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Content-class: urn:content-classes:message
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Post: <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://googlegroups.com/group/open-iscsi/subscribe>,
	<mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: =?iso-8859-1?Q?Pasi_K=E4rkk=E4inen?= <pasik-X3B1VOXEql0@public.gmane.org>, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org


Hi, Pasi,

Here are some throughput numbers we see with disktest, one tcp connection (=
iscsi session).

The setup are between a pair of chelsio 10G adapters. The target is Chelsio=
's ramdisk target with data discarded (similiar to IET's NULLIO mode). The =
Chelsio target is used because of the digest offload and payload ddp.=20

The ethernet frame is standard 1500 bytes.

The numbers are about 3 months old, but you get the idea :) For cxgb3i driv=
er, since the digest is offloaded the performance is very similar in the di=
gest off case, so only the numbers for digest on are shown.

We will re-run the tests and get the cpu stats too, will keep you posted.


Test         cxgb3i         iscsi-tcp         iscsi-tcp
             digest on      digest on         digest off
             (MB/sec)       (MB/sec)          (MB/sec)
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

512-read     36.85           34.13            36.69
1k-read      71.91           58.52            66.81
2k-read      137.24          97.75            128.46
4k-read      280.61         137.98            214.04
8k-read      531.34         201.87            325.09
16k-read     953.67         226.49            429.32
64k-read     1099.57        248.57            626.30
128k-read    1102.65        256.04            613.94
256k-read    1105.28        262.28            642.73
=20
512-write    39.54           34.18             38.36
1k-write     79.52           56.51             75.06
2k-write     158.03          84.12            140.85
4k-write     314.56         126.33            282.72
8k-write     559.83         155.49            528.24
16k-write    968.84         168.50            676.38
64k-write    1099.31        182.82            978.82
128k-write   1074.62        182.55            974.18
256k-write   1063.85        185.67            972.88


-----Original Message-----
From: Pasi K=E4rkk=E4inen [mailto:pasik-X3B1VOXEql0@public.gmane.org]=20
Sent: Monday, December 15, 2008 6:06 AM
To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org; James.Bottomley@Hanse=
nPartnership.com; Karen Xie
Subject: Re: [PATCH v2 0/2 2.6.29] cxgb3i -- open-iscsi initiator accelerat=
ion

On Tue, Dec 09, 2008 at 02:15:22PM -0800, Karen Xie wrote:
>=20
> [PATCH v2 0/2 2.6.29] cxgb3i -- open-iscsi initiator acceleration=20
>=20
> From: Karen Xie <kxie-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
>=20
> Here is the updated patchset for adding cxgb3i iscsi initiator.
>=20
> The updated version incorporates the comments from Mike and Boaz:
> - remove the cxgb3 sysfs entry for the private iscsi ip address, it can b=
e
>   accessed from iscsi.
> - in cxgb3i.txt, added error message logged for not setting MaxRecvDataSe=
gmentLength properly.
> - renamed cxgb3i Makefile to Kbuild
> - removed "select ISCSI_TCP" in Kconfig
> - consistent handling of AHS: on tx, reserve rooms for AHS; on rx, assume=
 we could receive AHS.
> - add support of bi-directional commands for ddp setup,
>=20
> The cxgb3i driver, especially the part handles the offloaded iscsi tcp co=
nnection mangement, has gone through the netdev review (http://marc.info/?l=
=3Dlinux-netdev&m=3D121944339211552, http://marc.info/?l=3Dlinux-netdev&m=
=3D121989660016124).
>=20
> The cxgb3i driver provides iscsi acceleration (PDU offload and payload da=
ta direct placement) to the open-iscsi initiator. It accesses the hardware =
through the cxgb3 module.
>=20

Hello!

Do you guys have performance comparison/numbers for normal open-iscsi over =
tcp vs. cxgb3i accelerated?

Would be nice to see throughput/iops/cpu-usage statistics..

-- Pasi
