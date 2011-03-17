From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC-v3 03/12] iscsi-target: Add TCM v4 compatiable ConfigFS
	control plane
Date: Thu, 17 Mar 2011 16:57:47 -0700
Message-ID: <1300406267.28255.607.camel@haakon2.linux-iscsi.org>
References: <1300398797-24536-1-git-send-email-nab@linux-iscsi.org>
	 <1300398797-24536-4-git-send-email-nab@linux-iscsi.org>
	 <alpine.LNX.2.00.1103172307510.1980@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:51312 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755499Ab1CRAEw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Mar 2011 20:04:52 -0400
In-Reply-To: <alpine.LNX.2.00.1103172307510.1980@swampdragon.chaosbits.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Andrew Morton <akpm@linux-foundation.org>, Douglas Gilbert <dgilbert@interlog.com>

On Thu, 2011-03-17 at 23:22 +0100, Jesper Juhl wrote:
> On Thu, 17 Mar 2011, Nicholas A. Bellinger wrote:
>=20
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> >=20
> > This patch adds support for /sys/kernel/config/target/iscsi using
> > TCM v4.0 compatiable calls following target_core_fabric_configfs.c
> >=20
> > This includes a number of iSCSI fabric dependent attributes upon
> > target_core_fabric_configfs.c provided struct config_item_types fro=
m
> > include/target/target_core_configfs.hstruct target_fabric_configfs_=
template
> >=20
> > It also includes iscsi_target_nodeattrib.[c,h] for handling the
> > lio_target_nacl_attrib_attrs[] store/show for iSCSI fabric dependen=
t
> > attributes.
> >=20
> > Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> > ---
> >  drivers/target/iscsi/iscsi_target_configfs.c   | 1593 ++++++++++++=
++++++++++++
> >  drivers/target/iscsi/iscsi_target_configfs.h   |    7 +
> >  drivers/target/iscsi/iscsi_target_nodeattrib.c |  264 ++++
> >  drivers/target/iscsi/iscsi_target_nodeattrib.h |   14 +
> >  4 files changed, 1878 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/target/iscsi/iscsi_target_configfs.c
> >  create mode 100644 drivers/target/iscsi/iscsi_target_configfs.h
> >  create mode 100644 drivers/target/iscsi/iscsi_target_nodeattrib.c
> >  create mode 100644 drivers/target/iscsi/iscsi_target_nodeattrib.h
> >=20
> > diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers=
/target/iscsi/iscsi_target_configfs.c
> > new file mode 100644
> > index 0000000..ae88092
> > --- /dev/null
> > +++ b/drivers/target/iscsi/iscsi_target_configfs.c
> > @@ -0,0 +1,1593 @@
> > +/*****************************************************************=
**************
> > + * This file contains the configfs implementation for iSCSI Target=
 mode
> > + * from the LIO-Target Project.
> > + *
> > + * ?? Copyright 2007-2011 RisingTide Systems LLC.
>=20
> "??" ?
> You have this in other files as well - what's the point of those two=20
> question marks?
>=20
>=20

Mmm, this looks like an email encoding issue.  The actual code is using
the copyright symbol (c) -> =C2=A9=20

> > +struct se_tpg_np *lio_target_call_addnptotpg(
> > +	struct se_portal_group *se_tpg,
> > +	struct config_group *group,
> > +	const char *name)
> > +{
> > +	struct iscsi_portal_group *tpg;
> > +	struct iscsi_tpg_np *tpg_np;
> > +	char *str, *str2, *end_ptr, *ip_str, *port_str;
> > +	struct iscsi_np_addr np_addr;
> > +	u32 ipv4 =3D 0;
> > +	int ret;
> > +	char buf[MAX_PORTAL_LEN + 1];
> > +
> > +	if (strlen(name) > MAX_PORTAL_LEN) {
> > +		printk(KERN_ERR "strlen(name): %d exceeds MAX_PORTAL_LEN: %d\n",
> > +			(int)strlen(name), MAX_PORTAL_LEN);
> > +		return ERR_PTR(-EOVERFLOW);
> > +	}
> > +	memset(buf, 0, MAX_PORTAL_LEN);
>=20
> memset(buf, 0, MAX_PORTAL_LEN + 1);
>=20
>=20

=46ixed

> > +#define DEF_NACL_ATTRIB(name)						\
> > +static ssize_t iscsi_nacl_attrib_show_##name(				\
> > +	struct se_node_acl *se_nacl,					\
> > +	char *page)							\
> > +{									\
> > +	struct iscsi_node_acl *nacl =3D container_of(se_nacl, struct iscs=
i_node_acl, \
> > +					se_node_acl);			\
> > +	ssize_t rb;							\
> > +									\
> > +	rb =3D sprintf(page, "%u\n", ISCSI_NODE_ATTRIB(nacl)->name);	\
> > +	return rb;							\
>=20
> Why the 'rb' variable? Why not just
>=20
> return sprintf(page, "%u\n", ISCSI_NODE_ATTRIB(nacl)->name);
>=20
> ?
>=20
>=20

=46ixed

> > +#define __DEF_NACL_AUTH_STR(prefix, name, flags)			\
> > +static ssize_t __iscsi_##prefix##_show_##name(				\
> > +	struct iscsi_node_acl *nacl,					\
> > +	char *page)							\
> > +{									\
> > +	struct iscsi_node_auth *auth =3D &nacl->node_auth;		\
> > +	ssize_t rb;							\
> > +									\
> > +	if (!capable(CAP_SYS_ADMIN))					\
> > +		return -EPERM;						\
> > +	rb =3D snprintf(page, PAGE_SIZE, "%s\n", auth->name);		\
> > +	return rb;							\
>=20
> Kill 'rb' and just=20
>=20
>   return snprintf(page, PAGE_SIZE, "%s\n", auth->name);
>=20
> I'd say.
>=20

=46ixed

>=20
> > +#define __DEF_NACL_AUTH_INT(prefix, name)				\
> > +static ssize_t __iscsi_##prefix##_show_##name(				\
> > +	struct iscsi_node_acl *nacl,					\
> > +	char *page)							\
> > +{									\
> > +	struct iscsi_node_auth *auth =3D &nacl->node_auth;		\
> > +	ssize_t rb;							\
> > +									\
> > +	if (!capable(CAP_SYS_ADMIN))					\
> > +		return -EPERM;						\
> > +									\
> > +	rb =3D snprintf(page, PAGE_SIZE, "%d\n", auth->name);		\
> > +	return rb;							\
>=20
> Just kill that pointless 'rb' variable..
>=20
>=20

=46ixed

> > +static ssize_t lio_target_nacl_show_info(
> > +	struct se_node_acl *se_nacl,
> > +	char *page)
> > +{
> > +	struct iscsi_session *sess;
> > +	struct iscsi_conn *conn;
> > +	struct se_session *se_sess;
> > +	unsigned char *ip, buf_ipv4[IPV4_BUF_SIZE];
> > +	ssize_t rb =3D 0;
> > +
> > +	spin_lock_bh(&se_nacl->nacl_sess_lock);
> > +	se_sess =3D se_nacl->nacl_sess;
> > +	if (!se_sess) {
> > +		rb +=3D sprintf(page+rb, "No active iSCSI Session for Initiator"
> > +			" Endpoint: %s\n", se_nacl->initiatorname);
> > +	} else {
> > +		sess =3D (struct iscsi_session *)se_sess->fabric_sess_ptr;
> > +
>=20
> Is this cast needed?
>=20
>=20

Removed

> > +static ssize_t iscsi_tpg_param_store_##name(				\
> > +	struct se_portal_group *se_tpg,				\
> > +	const char *page,						\
> > +	size_t count)							\
> > +{									\
> > +	struct iscsi_portal_group *tpg =3D container_of(se_tpg,		\
> > +			struct iscsi_portal_group, tpg_se_tpg);		\
> > +	char *buf;							\
> > +	int ret;							\
> > +									\
> > +	buf =3D kzalloc(PAGE_SIZE, GFP_KERNEL);				\
> > +	if (!buf)							\
> > +		return -ENOMEM;						\
> > +	snprintf(buf, PAGE_SIZE, "%s=3D%s", __stringify(name), page);	\
> > +	buf[strlen(buf)-1] =3D '\0'; /* Kill newline */			\
> > +									\
> > +	if (iscsi_get_tpg(tpg) < 0)					\
> > +		return -EINVAL;						\
>=20
> You just leaked "buf".
>=20
>=20

=46ixed.  Thanks for your review Jesper!

--nab


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
