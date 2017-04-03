From: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH] libiscsi: use vzalloc for large allocations in
 iscsi_pool_init
Date: Mon, 3 Apr 2017 15:41:40 +0200
Message-ID: <20170403134139.GE4558@linux-x5ow.site>
References: <1491226221-24621-1-git-send-email-kyle.fortin@oracle.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <open-iscsi+bncBDVNRMMDUUIBBFVCRHDQKGQE3BS2YKA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Content-Disposition: inline
In-Reply-To: <1491226221-24621-1-git-send-email-kyle.fortin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: Kyle Fortin <kyle.fortin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: lduncan-IBi9RG/b67k@public.gmane.org, cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Apr 03, 2017 at 06:30:21AM -0700, Kyle Fortin wrote:
> iscsiadm session login can fail with the following error:
>=20
> iscsiadm: Could not login to [iface: default, target: iqn.1986-03.com...
> iscsiadm: initiator reported error (9 - internal error)
>=20
> When /etc/iscsi/iscsid.conf sets node.session.cmds_max =3D 4096, it resul=
ts
> in 64K-sized kmallocs per session.  A system under fragmented slab
> pressure may not have any 64K objects available and fail iscsiadm session
> login. Even though memory objects of a smaller size are available, the
> large order allocation ends up failing.
>=20
> The kernel will print a warning and dump_stack, like below:

There is a series of patches in Andrew's mmotm tree, which introduces
a kvmalloc() function, that does exactly what you're looking for.

Maybe you want to base your patch on top of it.

--=20
Johannes Thumshirn                                          Storage
jthumshirn-l3A5Bk7waGM@public.gmane.org                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=C3=BCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850

--=20
You received this message because you are subscribed to the Google Groups "=
open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
