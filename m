From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v2 04/14] iscsi-target: Add iSCSI fabric support for
	target v4
Date: Mon, 09 May 2011 09:22:38 -0700
Message-ID: <1304958158.31161.184.camel@haakon2.linux-iscsi.org>
References: <1300849605-12651-1-git-send-email-nab@linux-iscsi.org>
	 <1300849605-12651-5-git-send-email-nab@linux-iscsi.org>
	 <4D9D68E8.4080102@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:53369 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab1EIQal (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 May 2011 12:30:41 -0400
In-Reply-To: <4D9D68E8.4080102@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>

On Thu, 2011-04-07 at 02:34 -0500, Mike Christie wrote:
> On 03/22/2011 10:06 PM, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger<nab@linux-iscsi.org>
> >
> > The RisingTide Systems iSCSI target module is a full featured in-ke=
rnel
> > software implementation of iSCSI target mode (RFC-3720) for the mai=
nline
> > target v4 infrastructure code.  More information can be found here:
> >

<SNIP>

> > Significant feedback for mainline code cleanups by Christoph Hellwi=
g and
> > Mike Christie.
> >

Hey Mike and Co,

Sorry for the delayed response on your last review.  My comments are
inline below along with a diffstat at the very bottom for the changes
based on your feedback pushed into lio-core-2.6.git/lio-4.1.

These changes will be included in PATCH-v3 series for iscsi-target goin=
g
out this week.


> > Signed-off-by: Nicholas A. Bellinger<nab@linux-iscsi.org>
> > ---
> >   drivers/target/iscsi/iscsi_target.c      | 5017 +++++++++++++++++=
+++++++++++++
> >   drivers/target/iscsi/iscsi_target.h      |   32 +
> >   drivers/target/iscsi/iscsi_target_core.h |  881 ++++++
> >   3 files changed, 5930 insertions(+), 0 deletions(-)
> >   create mode 100644 drivers/target/iscsi/iscsi_target.c
> >   create mode 100644 drivers/target/iscsi/iscsi_target.h
> >   create mode 100644 drivers/target/iscsi/iscsi_target_core.h
> >
> > diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/i=
scsi/iscsi_target.c
> > new file mode 100644
> > index 0000000..c81f5cc
> > --- /dev/null
> > +++ b/drivers/target/iscsi/iscsi_target.c
> > @@ -0,0 +1,5017 @@
> > +/*****************************************************************=
**************
> > + * This file contains main functions related to the iSCSI Target C=
ore Driver.
> > + *
> > + * =C3=82=C2=A9 Copyright 2007-2011 RisingTide Systems LLC.
> > + *
> > + * Licensed to the Linux Foundation under the General Public Licen=
se (GPL) version 2.
> > + *
> > + * Author: Nicholas A. Bellinger<nab@linux-iscsi.org>
> > + *
> > + * This program is free software; you can redistribute it and/or m=
odify
> > + * it under the terms of the GNU General Public License as publish=
ed by
> > + * the Free Software Foundation; either version 2 of the License, =
or
> > + * (at your option) any later version.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *****************************************************************=
*************/
> > +
> > +#include<linux/kthread.h>
> > +#include<linux/crypto.h>
> > +#include<linux/completion.h>
> > +#include<asm/unaligned.h>
> > +#include<scsi/scsi_device.h>
> > +#include<scsi/iscsi_proto.h>
> > +#include<target/target_core_base.h>
> > +#include<target/target_core_tmr.h>
> > +#include<target/target_core_transport.h>
> > +
> > +#include "iscsi_target_debug.h"
> > +#include "iscsi_target_core.h"
> > +#include "iscsi_target_parameters.h"
> > +#include "iscsi_target_seq_pdu_list.h"
> > +#include "iscsi_target_tq.h"
> > +#include "iscsi_target_configfs.h"
> > +#include "iscsi_target_datain_values.h"
> > +#include "iscsi_target_erl0.h"
> > +#include "iscsi_target_erl1.h"
> > +#include "iscsi_target_erl2.h"
> > +#include "iscsi_target_login.h"
> > +#include "iscsi_target_tmr.h"
> > +#include "iscsi_target_tpg.h"
> > +#include "iscsi_target_util.h"
> > +#include "iscsi_target.h"
> > +#include "iscsi_target_device.h"
> > +#include "iscsi_target_stat.h"
> > +
> > +LIST_HEAD(g_tiqn_list);
> > +LIST_HEAD(g_np_list);
>=20
> static
>=20

Done

> > +DEFINE_SPINLOCK(tiqn_lock);
> > +DEFINE_SPINLOCK(np_lock);
>=20
> static
>=20
>=20

Done

> > +
> > +static struct idr tiqn_idr;
> > +struct idr sess_idr;
> > +struct mutex auth_id_lock;
> > +spinlock_t sess_idr_lock;
> > +
> > +struct iscsi_global *iscsi_global;
>=20
>=20
> I think that should be iscsit_global, because in other places you use=
=20
> iscsit as a prefix.
>=20

=46air enough.  Renamed all usage of *iscsi_global to *iscsit_global.

> Also you do not need to extern that in every header.
>=20
>=20

<nod> Added a single set of prototypes of these in iscsi_target.h, and
dropped the extern usage in the other headers.

>=20
> > +
> > +struct kmem_cache *lio_cmd_cache;
> > +struct kmem_cache *lio_qr_cache;
> > +struct kmem_cache *lio_dr_cache;
> > +struct kmem_cache *lio_ooo_cache;
> > +struct kmem_cache *lio_r2t_cache;
> > +
> > +static void iscsit_rx_thread_wait_for_tcp(struct iscsi_conn *);
> > +
> > +static int iscsit_handle_immediate_data(struct iscsi_cmd *,
> > +			unsigned char *buf, u32);
> > +static inline int iscsit_send_data_in(struct iscsi_cmd *, struct i=
scsi_conn *,
> > +			struct se_unmap_sg *, int *);
> > +static inline int iscsit_send_logout_response(struct iscsi_cmd *, =
struct iscsi_conn *);
> > +static inline int iscsit_send_nopin_response(struct iscsi_cmd *, s=
truct iscsi_conn *);
> > +static inline int iscsit_send_status(struct iscsi_cmd *, struct is=
csi_conn *);
> > +static int iscsit_send_task_mgt_rsp(struct iscsi_cmd *, struct isc=
si_conn *);
> > +static int iscsit_send_text_rsp(struct iscsi_cmd *, struct iscsi_c=
onn *);
> > +static int iscsit_send_reject(struct iscsi_cmd *, struct iscsi_con=
n *);
> > +static int iscsit_logout_post_handler(struct iscsi_cmd *, struct i=
scsi_conn *);
> > +
>=20
>=20
> You do not need some of these to be forward declared, because they ar=
e=20
> used after they are implemented.
>=20
> Some of them could be trivially moved around so you do not have to=20
> forward declare them.
>=20
> Some are needed though,
>=20
>=20

<nod>, dropped the unnecessary + trivally moved forward declarations
here.

>=20
>=20
>=20
> > +/*
> > + * Note that IQN formatting is expected to be done in userspace, a=
nd
> > + * no explict IQN format checks are done here.
> > + */
> > +struct iscsi_tiqn *iscsit_add_tiqn(unsigned char *buf, int *ret)
> > +{
>=20
>=20
>=20
> > +
> > +	spin_lock(&tiqn_lock);
> > +	idr_get_new(&tiqn_idr, NULL,&tiqn->tiqn_index);
>=20
>=20
> Need to check the return value.
>=20
>=20

=46ixed

>=20
> > +	list_add_tail(&tiqn->tiqn_list,&g_tiqn_list);
> > +	spin_unlock(&tiqn_lock);
> > +
> > +	printk(KERN_INFO "CORE[0] - Added iSCSI Target IQN: %s\n", tiqn->=
tiqn);
> > +
> > +	return tiqn;
> > +
> > +}
> > +
> > +void __iscsit_del_tiqn(struct iscsi_tiqn *tiqn)
>=20
> Should be static or rolled up into iscsit_del_tiqn.
>=20
>=20

Rolled into iscsit_del_tiqn.

>=20
> > +{
> > +	spin_lock(&tiqn_lock);
> > +	list_del(&tiqn->tiqn_list);
> > +	idr_remove(&tiqn_idr, tiqn->tiqn_index);
> > +	spin_unlock(&tiqn_lock);
> > +
> > +	printk(KERN_INFO "CORE[0] - Deleted iSCSI Target IQN: %s\n",
> > +			tiqn->tiqn);
> > +	kfree(tiqn);
> > +}
> > +
> > +static void iscsit_wait_for_tiqn(struct iscsi_tiqn *tiqn)
> > +{
> > +	/*
> > +	 * Wait for accesses to said struct iscsi_tiqn to end.
> > +	 */
> > +	spin_lock(&tiqn->tiqn_state_lock);
> > +	while (tiqn->tiqn_access_count !=3D 0) {
> > +		spin_unlock(&tiqn->tiqn_state_lock);
> > +		msleep(10);
> > +		spin_lock(&tiqn->tiqn_state_lock);
> > +	}
> > +	spin_unlock(&tiqn->tiqn_state_lock);
> > +}
> > +
> > +void iscsit_del_tiqn(struct iscsi_tiqn *tiqn)
> > +{
> > +	/*
> > +	 * iscsit_set_tiqn_shutdown sets tiqn->tiqn_state =3D TIQN_STATE_=
SHUTDOWN
> > +	 * while holding tiqn->tiqn_state_lock.  This means that all subs=
equent
> > +	 * attempts to access this struct iscsi_tiqn will fail from both =
transport
> > +	 * fabric and control code paths.
> > +	 */
> > +	if (iscsit_set_tiqn_shutdown(tiqn)<  0) {
> > +		printk(KERN_ERR "iscsit_set_tiqn_shutdown() failed\n");
> > +		return;
> > +	}
> > +
> > +	iscsit_wait_for_tiqn(tiqn);
> > +	__iscsit_del_tiqn(tiqn);
> > +}
> > +
> > +int iscsit_access_np(struct iscsi_np *np, struct iscsi_portal_grou=
p *tpg)
> > +{
> > +	int ret;
> > +	/*
> > +	 * Determine if the network portal is accepting storage traffic.
> > +	 */
> > +	spin_lock_bh(&np->np_thread_lock);
> > +	if (np->np_thread_state !=3D ISCSI_NP_THREAD_ACTIVE) {
> > +		spin_unlock_bh(&np->np_thread_lock);
> > +		return -1;
> > +	}
> > +	if (np->np_login_tpg) {
> > +		printk(KERN_ERR "np->np_login_tpg() is not NULL!\n");
> > +		spin_unlock_bh(&np->np_thread_lock);
> > +		return -1;
> > +	}
> > +	spin_unlock_bh(&np->np_thread_lock);
> > +	/*
> > +	 * Determine if the portal group is accepting storage traffic.
> > +	 */
> > +	spin_lock_bh(&tpg->tpg_state_lock);
> > +	if (tpg->tpg_state !=3D TPG_STATE_ACTIVE) {
> > +		spin_unlock_bh(&tpg->tpg_state_lock);
> > +		return -1;
> > +	}
> > +	spin_unlock_bh(&tpg->tpg_state_lock);
> > +
>=20
>=20
> Do you mean to duplicate this check below? Does not seem like a very=20
> useful optimization.
>=20
>=20

AFAICT the duplicate check is unnecessary.  Dropped

>=20
> > +	/*
> > +	 * Here we serialize access across the TIQN+TPG Tuple.
> > +	 */
> > +	ret =3D mutex_lock_interruptible(&tpg->np_login_lock);
> > +	if ((ret !=3D 0) || signal_pending(current))
> > +		return -1;
> > +
> > +	spin_lock_bh(&tpg->tpg_state_lock);
> > +	if (tpg->tpg_state !=3D TPG_STATE_ACTIVE) {
> > +		spin_unlock_bh(&tpg->tpg_state_lock);
> > +		return -1;
> > +	}
> > +	spin_unlock_bh(&tpg->tpg_state_lock);
> > +
> > +	spin_lock_bh(&np->np_thread_lock);
> > +	np->np_login_tpg =3D tpg;
> > +	spin_unlock_bh(&np->np_thread_lock);
> > +
> > +	return 0;
> > +}
>=20
>=20
> > +}
> > +
> > +static struct iscsi_np *iscsit_get_np(
> > +	unsigned char *ipv6,
> > +	u32 ipv4,
> > +	u16 port,
> > +	int af_inet,
> > +	int network_transport)
> > +{
> > +	struct iscsi_np *np;
> > +	int ip_match =3D 0;
> > +
> > +	spin_lock_bh(&np_lock);
> > +	list_for_each_entry(np,&g_np_list, np_list) {
> > +		spin_lock(&np->np_thread_lock);
> > +		if (np->np_thread_state !=3D ISCSI_NP_THREAD_ACTIVE) {
> > +			spin_unlock(&np->np_thread_lock);
> > +			continue;
> > +		}
> > +
> > +		if (af_inet =3D=3D AF_INET6) {
> > +			if (!strcmp(&np->np_ip[0],&ipv6[0]))
> > +				ip_match =3D 1;
> > +		} else {
> > +			if (np->np_ipv4 =3D=3D ipv4)
> > +				ip_match =3D 1;
> > +		}
> > +
> > +		if ((ip_match =3D=3D 1)&&  (np->np_port =3D=3D port)&&
> > +		    (np->np_network_transport =3D=3D network_transport)) {
> > +			/*
> > +			 * Increment the np_exports reference count now to
> > +			 * prevent iscsit_del_np() below from being called
> > +			 * while iscsi_tpg_add_network_portal() is called.
> > +			 */
> > +			np->np_exports++;
> > +			spin_unlock(&np->np_thread_lock);
> > +			spin_unlock_bh(&np_lock);
> > +			return np;
> > +		}
> > +		spin_unlock(&np->np_thread_lock);
> > +	}
> > +	spin_unlock_bh(&np_lock);
> > +
> > +	return NULL;
> > +}
> > +
> > +struct iscsi_np *iscsit_add_np(
> > +	struct iscsi_np_addr *np_addr,
> > +	int network_transport,
> > +	int af_inet)
> > +{
> > +	struct iscsi_np *np;
> > +	int ret;
> > +	/*
> > +	 * Locate the existing struct iscsi_np if already active..
> > +	 */
> > +	np =3D iscsit_get_np(np_addr->np_ipv6, np_addr->np_ipv4,
> > +			   np_addr->np_port, af_inet, network_transport);
>=20
>=20
> I thought you were going to sync up naming and types? np_addr->np_ipv=
6=20
> is a text representation but np_addr->np_ipv4 is a binary one.
>=20
> Why don't you put the address in a sockaddr when you get it from=20
> configfs and then use that internally? Can keep np_ip for the text=20
> representation buffer though to make it easier to print and use for=20
> sendtargets.
>=20
>=20

Done.

Removed all struct iscsi_np_addr usage, and made iscsit_get_np(),
iscsit_add_np(), iscsi_target_setup_login_socket() accept a sockaddr
from iscsi_target_configfs.c:lio_target_call_addnptotpg().

>=20
>=20
> > +	if (np)
> > +		return np;
> > +
> > +	np =3D kzalloc(sizeof(struct iscsi_np), GFP_KERNEL);
> > +	if (!np) {
> > +		printk(KERN_ERR "Unable to allocate memory for struct iscsi_np\n=
");
> > +		return ERR_PTR(-ENOMEM);
> > +	}
> > +
> > +	np->np_flags |=3D NPF_IP_NETWORK;
> > +	if (af_inet =3D=3D AF_INET6) {
> > +		snprintf(np->np_ip, IPV6_ADDRESS_SPACE, "%s", np_addr->np_ipv6);
> > +	} else {
> > +		sprintf(np->np_ip, "%u.%u.%u.%u",
>=20
>=20
>=20
> %pI4
>=20

=46ixed

>=20
> > +			((np_addr->np_ipv4>>  24)&  0xff),
> > +			((np_addr->np_ipv4>>  16)&  0xff),
> > +			((np_addr->np_ipv4>>  8)&  0xff),
> > +			  np_addr->np_ipv4&  0xff);
> > +		np->np_ipv4 =3D np_addr->np_ipv4;
> > +	}
> > +
> > +	np->np_port		=3D np_addr->np_port;
> > +	np->np_network_transport =3D network_transport;
> > +	spin_lock_init(&np->np_thread_lock);
> > +	init_completion(&np->np_restart_comp);
> > +	INIT_LIST_HEAD(&np->np_list);
> > +
> > +	ret =3D iscsi_target_setup_login_socket(np, af_inet);
> > +	if (ret !=3D 0) {
> > +		kfree(np);
> > +		return ERR_PTR(ret);
> > +	}
> > +
> > +	np->np_thread =3D kthread_run(iscsi_target_login_thread, np, "isc=
si_np");
>=20
> Did someone give some sort of comment about workqueues already?
>=20
>=20

I don't think it has been mentioned wrt iscsi_target_login_thread()
context, but the main reason this is not happened yet is the dependancy
on signals.

I think converting this to a workqueue would be possible with some more
effort.


> > +	if (IS_ERR(np->np_thread)) {
> > +		printk(KERN_ERR "Unable to create kthread: iscsi_np\n");
> > +		ret =3D PTR_ERR(np->np_thread);
> > +		kfree(np);
> > +		return ERR_PTR(ret);
> > +	}
> > +	/*
> > +	 * Increment the np_exports reference count now to prevent
> > +	 * iscsit_del_np() below from being run while a new call to
> > +	 * iscsi_tpg_add_network_portal() for a matching iscsi_np is
> > +	 * active.  We don't need to hold np->np_thread_lock at this
> > +	 * point because iscsi_np has not been added to g_np_list yet.
> > +	 */
> > +	np->np_exports =3D 1;
> > +
> > +	spin_lock_bh(&np_lock);
> > +	list_add_tail(&np->np_list,&g_np_list);
> > +	spin_unlock_bh(&np_lock);
> > +
> > +	printk(KERN_INFO "CORE[0] - Added Network Portal: %s:%hu on %s on=
"
> > +		" network device: %s\n", np->np_ip, np->np_port,
> > +		(np->np_network_transport =3D=3D ISCSI_TCP) ?
> > +		"TCP" : "SCTP", (strlen(np->np_net_dev)) ?
> > +		(char *)np->np_net_dev : "None");
> > +
> > +	return np;
> > +}
>=20
>=20
>=20
> > +
> > +int iscsit_del_np(struct iscsi_np *np)
> > +{
> > +	spin_lock_bh(&np->np_thread_lock);
> > +	if (!(--np->np_exports =3D=3D 0)) {
> > +		spin_unlock_bh(&np->np_thread_lock);
> > +		return 0;
> > +	}
> > +	np->np_thread_state =3D ISCSI_NP_THREAD_SHUTDOWN;
> > +	spin_unlock_bh(&np->np_thread_lock);
> > +
> > +	if (np->np_thread) {
> > +		/*
> > +		 * We need to send the signal to wakeup Linux/Net
> > +		 * which may be sleeping in sock_accept()..
> > +		 */
> > +		send_sig(SIGINT, np->np_thread, 1);
> > +		kthread_stop(np->np_thread);
> > +	}
> > +	iscsit_del_np_comm(np);
> > +
> > +	spin_lock_bh(&np_lock);
> > +	list_del(&np->np_list);
> > +	spin_unlock_bh(&np_lock);
> > +
> > +	printk(KERN_INFO "CORE[0] - Removed Network Portal: %s:%hu on %s =
on"
> > +		" network device: %s\n", np->np_ip, np->np_port,
> > +		(np->np_network_transport =3D=3D ISCSI_TCP) ?
> > +		"TCP" : "SCTP",  (strlen(np->np_net_dev)) ?
> > +		(char *)np->np_net_dev : "None");
>=20
>=20
> Not now, but in the future you should add some nicer logging macros. =
It=20
> seems you duplicate stuff, and sometimes there is logging without a=20
> connection or session identifier so you do not know where it came fro=
m.
>=20
>=20

<nod>, I would like to eventually convert this all over to dprink().

>=20
> > +
> > +	kfree(np);
> > +	return 0;
> > +}
> > +
> > +static int __init iscsi_target_init_module(void)
> > +{
> > +	int ret =3D 0;
> > +
> > +	printk(KERN_INFO "RisingTide Systems iSCSI-Target "ISCSI_VERSION"=
\n");
>=20
> In general code like this we do not normally add company names. There=
 is=20
> not even a open-iscsi initiator string in the kernel (except for mail=
ing=20
> list, maintianer/auther and copyright stuff). Just "iSCSI Initiator o=
ver=20
> TCP/IP". Or for fcoe we do not have open-fcoe or intel's fcoe, we jus=
t=20
> have "FCoE Driver".
>=20
>=20

<nod>, dropped

> > +
> > +	iscsi_global =3D kzalloc(sizeof(struct iscsi_global), GFP_KERNEL)=
;
> > +	if (!iscsi_global) {
> > +		printk(KERN_ERR "Unable to allocate memory for iscsi_global\n");
> > +		return -1;
> > +	}
> > +	mutex_init(&auth_id_lock);
> > +	spin_lock_init(&sess_idr_lock);
> > +	idr_init(&tiqn_idr);
> > +	idr_init(&sess_idr);
> > +
> > +	ret =3D iscsi_target_register_configfs();
> > +	if (ret<  0)
> > +		goto out;
> > +
> > +	ret =3D iscsi_thread_set_init();
> > +	if (ret<  0)
> > +		goto configfs_out;
> > +
> > +	if (iscsi_allocate_thread_sets(TARGET_THREAD_SET_COUNT) !=3D
> > +			TARGET_THREAD_SET_COUNT) {
> > +		printk(KERN_ERR "iscsi_allocate_thread_sets() returned"
> > +			" unexpected value!\n");
> > +		goto ts_out1;
> > +	}
> > +
> > +	lio_cmd_cache =3D kmem_cache_create("lio_cmd_cache",
> > +			sizeof(struct iscsi_cmd), __alignof__(struct iscsi_cmd),
> > +			0, NULL);
> > +	if (!lio_cmd_cache) {
> > +		printk(KERN_ERR "Unable to kmem_cache_create() for"
> > +				" lio_cmd_cache\n");
> > +		goto ts_out2;
> > +	}
> > +
> > +	lio_qr_cache =3D kmem_cache_create("lio_qr_cache",
> > +			sizeof(struct iscsi_queue_req),
> > +			__alignof__(struct iscsi_queue_req), 0, NULL);
> > +	if (!lio_qr_cache) {
> > +		printk(KERN_ERR "nable to kmem_cache_create() for"
> > +				" lio_qr_cache\n");
> > +		goto cmd_out;
> > +	}
> > +
> > +	lio_dr_cache =3D kmem_cache_create("lio_dr_cache",
> > +			sizeof(struct iscsi_datain_req),
> > +			__alignof__(struct iscsi_datain_req), 0, NULL);
> > +	if (!lio_dr_cache) {
> > +		printk(KERN_ERR "Unable to kmem_cache_create() for"
> > +				" lio_dr_cache\n");
> > +		goto qr_out;
> > +	}
> > +
> > +	lio_ooo_cache =3D kmem_cache_create("lio_ooo_cache",
> > +			sizeof(struct iscsi_ooo_cmdsn),
> > +			__alignof__(struct iscsi_ooo_cmdsn), 0, NULL);
> > +	if (!lio_ooo_cache) {
> > +		printk(KERN_ERR "Unable to kmem_cache_create() for"
> > +				" lio_ooo_cache\n");
> > +		goto dr_out;
> > +	}
> > +
> > +	lio_r2t_cache =3D kmem_cache_create("lio_r2t_cache",
> > +			sizeof(struct iscsi_r2t), __alignof__(struct iscsi_r2t),
> > +			0, NULL);
> > +	if (!lio_r2t_cache) {
> > +		printk(KERN_ERR "Unable to kmem_cache_create() for"
> > +				" lio_r2t_cache\n");
> > +		goto ooo_out;
> > +	}
> > +
> > +	if (iscsit_load_discovery_tpg()<  0)
> > +		goto r2t_out;
> > +
> > +	printk("Loading Complete.\n");
>=20
> Is this a debug printk?
>=20
>=20

Removed this useless noise..

> > +
> > +	return ret;
> > +r2t_out:
> > +	kmem_cache_destroy(lio_r2t_cache);
> > +ooo_out:
> > +	kmem_cache_destroy(lio_ooo_cache);
> > +dr_out:
> > +	kmem_cache_destroy(lio_dr_cache);
> > +qr_out:
> > +	kmem_cache_destroy(lio_qr_cache);
> > +cmd_out:
> > +	kmem_cache_destroy(lio_cmd_cache);
> > +ts_out2:
> > +	iscsi_deallocate_thread_sets();
> > +ts_out1:
> > +	iscsi_thread_set_free();
> > +configfs_out:
> > +	iscsi_target_deregister_configfs();
> > +out:
> > +	kfree(iscsi_global);
> > +	iscsi_global =3D NULL;
>=20
>=20
> No need to set to NULL. You are pretty screwed if you need it.
>=20

Dropped

> > +
> > +	return -1;
>=20
>=20
> I think we normally return a errno.h type of value from module_init.
>=20

Changed to -ENOMEM

> > +}
> > +
> > +static void __exit iscsi_target_cleanup_module(void)
> > +{
> > +	iscsi_deallocate_thread_sets();
> > +	iscsi_thread_set_free();
> > +	iscsit_release_discovery_tpg();
> > +	kmem_cache_destroy(lio_cmd_cache);
> > +	kmem_cache_destroy(lio_qr_cache);
> > +	kmem_cache_destroy(lio_dr_cache);
> > +	kmem_cache_destroy(lio_ooo_cache);
> > +	kmem_cache_destroy(lio_r2t_cache);
> > +
> > +	iscsi_target_deregister_configfs();
> > +
> > +	kfree(iscsi_global);
> > +	printk(KERN_INFO "Unloading Complete.\n");
> > +}
> > +
> > +int iscsit_add_reject(
> > +	u8 reason,
> > +	int fail_conn,
> > +	unsigned char *buf,
> > +	struct iscsi_conn *conn)
> > +{
> > +	struct iscsi_cmd *cmd;
> > +	struct iscsi_reject *hdr;
> > +	int ret;
> > +
> > +	cmd =3D iscsit_allocate_cmd(conn);
> > +	if (!cmd)
> > +		return -1;
> > +
> > +	cmd->iscsi_opcode =3D ISCSI_OP_REJECT;
> > +	if (fail_conn)
> > +		cmd->cmd_flags |=3D ICF_REJECT_FAIL_CONN;
> > +
> > +	hdr	=3D (struct iscsi_reject *) cmd->pdu;
> > +	hdr->reason =3D reason;
> > +
> > +	cmd->buf_ptr =3D kzalloc(ISCSI_HDR_LEN, GFP_ATOMIC);
>=20
>=20
> Use GFP_KERNEL. If you can't sleep the wait below is wrong.
>=20
>=20

Converted to GFP_KERNEL


>=20
>=20
> > +	if (!cmd->buf_ptr) {
> > +		printk(KERN_ERR "Unable to allocate memory for cmd->buf_ptr\n");
> > +		iscsit_release_cmd(cmd);
> > +		return -1;
> > +	}
> > +	memcpy(cmd->buf_ptr, buf, ISCSI_HDR_LEN);
> > +
> > +	spin_lock_bh(&conn->cmd_lock);
> > +	list_add_tail(&cmd->i_list,&conn->conn_cmd_list);
> > +	spin_unlock_bh(&conn->cmd_lock);
> > +
> > +	cmd->i_state =3D ISTATE_SEND_REJECT;
> > +	iscsit_add_cmd_to_response_queue(cmd, conn, cmd->i_state);
> > +
> > +	ret =3D wait_for_completion_interruptible(&cmd->reject_comp);
> > +	if (ret !=3D 0)
> > +		return -1;
> > +
> > +	return (!fail_conn) ? 0 : -1;
> > +}
> > +
> > +int iscsit_add_reject_from_cmd(
> > +	u8 reason,
> > +	int fail_conn,
> > +	int add_to_conn,
> > +	unsigned char *buf,
> > +	struct iscsi_cmd *cmd)
> > +{
> > +	struct iscsi_conn *conn;
> > +	struct iscsi_reject *hdr;
> > +	int ret;
> > +
> > +	if (!cmd->conn) {
> > +		printk(KERN_ERR "cmd->conn is NULL for ITT: 0x%08x\n",
> > +				cmd->init_task_tag);
> > +		return -1;
> > +	}
> > +	conn =3D cmd->conn;
> > +
> > +	cmd->iscsi_opcode =3D ISCSI_OP_REJECT;
> > +	if (fail_conn)
> > +		cmd->cmd_flags |=3D ICF_REJECT_FAIL_CONN;
> > +
> > +	hdr	=3D (struct iscsi_reject *) cmd->pdu;
> > +	hdr->reason =3D reason;
> > +
> > +	cmd->buf_ptr =3D kzalloc(ISCSI_HDR_LEN, GFP_ATOMIC);
>=20
>=20
> Same as above. You do not want to use GFP_ATOMIC when you do not have=
=20
> to. It can fail more easily than GFP_NOIO and GFP_KERNEL.
>=20
>=20

Also converted to GFP_KERNEL

> Could you check your other IO allocations. I think you can make=20
> functions like iscsit_allocate_cmd take a gfp_t.
>=20
>=20

Done.

Note that iscsit_add_nopin() is the only caller of iscsit_allocate_cmd(=
)
w/ GFP_ATOMIC called from softirq context for
conn->nopin_response_timer.

>=20
> > +	if (!cmd->buf_ptr) {
> > +		printk(KERN_ERR "Unable to allocate memory for cmd->buf_ptr\n");
> > +		iscsit_release_cmd(cmd);
> > +		return -1;
> > +	}
> > +	memcpy(cmd->buf_ptr, buf, ISCSI_HDR_LEN);
> > +
> > +	if (add_to_conn) {
> > +		spin_lock_bh(&conn->cmd_lock);
> > +		list_add_tail(&cmd->i_list,&conn->conn_cmd_list);
> > +		spin_unlock_bh(&conn->cmd_lock);
> > +	}
> > +
> > +	cmd->i_state =3D ISTATE_SEND_REJECT;
> > +	iscsit_add_cmd_to_response_queue(cmd, conn, cmd->i_state);
> > +
> > +	ret =3D wait_for_completion_interruptible(&cmd->reject_comp);
> > +	if (ret !=3D 0)
> > +		return -1;
> > +
> > +	return (!fail_conn) ? 0 : -1;
> > +}
>=20
>=20
>=20
>=20
>=20
> > +
> > +static inline int iscsit_handle_scsi_cmd(
>=20
>=20
>=20
> I thought the kernel coding style rules had something about not using=
=20
> inline when functions are static and only used once. Compilers do the=
=20
> right thing for you already? Could you check your other inline uses.
>=20
>=20
>=20

<nod>, removed the unnecessary inlines here in iscsi_target.c and
aduited the other source files..


>=20
>=20
> > +	struct iscsi_conn *conn,
> > +	unsigned char *buf)
> > +{
>=20
>=20
>=20
> > +#if 0
> > +	if (!(hdr->flags&  ISCSI_FLAG_CMD_FINAL)&&
> > +	     (hdr->flags&  ISCSI_FLAG_CMD_WRITE)&&  conn->sess->sess_ops-=
>InitialR2T) {
> > +		printk(KERN_ERR "ISCSI_FLAG_CMD_FINAL is not Set and"
> > +			" ISCSI_FLAG_CMD_WRITE Bit and InitialR2T=3DYes,"
> > +			" protocol error\n");
> > +		return iscsit_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
> > +				buf, conn);
> > +	}
> > +#endif
>=20
>=20
> ??
>=20
>=20

This was an old overzealous check.  Dropped


> > +		if (ret =3D=3D PYX_TRANSPORT_OUT_OF_MEMORY_RESOURCES)
>=20
>=20
> Is PYX the target this is based on or something else?
>=20
>=20
>=20

This is actually from include/target/target_core_transport.h and Andy
has already added a bugzilla entry about this bit..

I am going to go ahead and change this in LIO v4.1 upstream code, and
will post a patch to remove this prefix seperately for the mainline
target and modules.

>=20
>=20
>=20
>=20
>=20
> > +
> > +static inline int iscsit_handle_snack(
>=20
> snacks om nom nom nom nom
>=20
>=20
>=20
> > +
> > +static int iscsit_handle_immediate_data(
>=20
>=20
>=20
> > +
> > +		crypto_hash_init(&conn->conn_rx_hash);
> > +
> > +		while (counter>  0) {
> > +			sg_init_one(&sg, iov_ptr->iov_base,
> > +					iov_ptr->iov_len);
> > +			crypto_hash_update(&conn->conn_rx_hash,&sg,
> > +					iov_ptr->iov_len);
> > +
> > +			TRACE(TRACE_DIGEST, "Computed CRC32C DataDigest %zu"
> > +			" bytes, CRC 0x%08x\n", iov_ptr->iov_len, data_crc);
> > +			counter -=3D iov_ptr->iov_len;
> > +			iov_ptr++;
> > +		}
> > +
> > +		if (padding) {
> > +			sg_init_one(&sg, (u8 *)&pad_bytes, padding);
> > +			crypto_hash_update(&conn->conn_rx_hash,&sg,
> > +					padding);
> > +			TRACE(TRACE_DIGEST, "Computed CRC32C DataDigest %d"
> > +			" bytes of padding, CRC 0x%08x\n", padding, data_crc);
> > +		}
> > +		crypto_hash_final(&conn->conn_rx_hash, (u8 *)&data_crc);
>=20
>=20
> It seems you can could make this a function. I keep seeing the hash a=
nd=20
> padding code over and over.
>=20
>=20

Done.

Added iscsit_do_crypto_hash_iovec() handler, and converted
iscsit_handle_immediate_data() to use this code.

Also converted all other conn->conn_rx_hash uses to the the appropriate
new iscsit_do_crypto_hash_*() calls.

> > +
> > +		if (checksum !=3D data_crc) {
> > +			printk(KERN_ERR "ImmediateData CRC32C DataDigest 0x%08x"
> > +				" does not match computed 0x%08x\n", checksum,
> > +				data_crc);
> > +
> > +			if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
> > +				printk(KERN_ERR "Unable to recover from"
> > +					" Immediate Data digest failure while"
> > +					" in ERL=3D0.\n");
> > +				iscsit_add_reject_from_cmd(
> > +						ISCSI_REASON_DATA_DIGEST_ERROR,
> > +						1, 0, buf, cmd);
> > +				return IMMEDIDATE_DATA_CANNOT_RECOVER;
> > +			} else {
> > +				iscsit_add_reject_from_cmd(
> > +						ISCSI_REASON_DATA_DIGEST_ERROR,
> > +						0, 0, buf, cmd);
> > +				return IMMEDIDATE_DATA_ERL1_CRC_FAILURE;
> > +			}
> > +		} else {
> > +			TRACE(TRACE_DIGEST, "Got CRC32C DataDigest 0x%08x for"
> > +				" %u bytes of Immediate Data\n", checksum,
> > +				length);
> > +		}
> > +	}
> > +
> > +	cmd->write_data_done +=3D length;
> > +
> > +	if (cmd->write_data_done =3D=3D cmd->data_length) {
> > +		spin_lock_bh(&cmd->istate_lock);
> > +		cmd->cmd_flags |=3D ICF_GOT_LAST_DATAOUT;
> > +		cmd->i_state =3D ISTATE_RECEIVED_LAST_DATAOUT;
> > +		spin_unlock_bh(&cmd->istate_lock);
> > +	}
> > +
> > +	return IMMEDIDATE_DATA_NORMAL_OPERATION;
> > +}
> > +
> > +int iscsit_send_async_msg(
> > +	struct iscsi_conn *conn,
> > +	u16 cid,
> > +	u8 async_event,
> > +	u8 async_vcode)
> > +{
> > +	u8 iscsi_hdr[ISCSI_HDR_LEN+CRC_LEN];
> > +	u32 tx_send =3D ISCSI_HDR_LEN, tx_sent =3D 0;
> > +	struct iscsi_async *hdr;
> > +	struct kvec iov;
> > +	struct scatterlist sg;
> > +
> > +	memset(&iov, 0, sizeof(struct kvec));
> > +	memset(&iscsi_hdr, 0, ISCSI_HDR_LEN+CRC_LEN);
> > +
> > +	hdr		=3D (struct iscsi_async *)&iscsi_hdr;
> > +	hdr->opcode	=3D ISCSI_OP_ASYNC_EVENT;
> > +	hdr->flags	|=3D ISCSI_FLAG_CMD_FINAL;
> > +	hton24(hdr->dlength, 0);
> > +	put_unaligned_le64(0,&hdr->lun[0]);
> > +	put_unaligned_be64(0xffffffffffffffff,&hdr->rsvd4[0]);
> > +	hdr->statsn	=3D cpu_to_be32(conn->stat_sn++);
> > +	spin_lock(&conn->sess->cmdsn_lock);
> > +	hdr->exp_cmdsn	=3D cpu_to_be32(conn->sess->exp_cmd_sn);
> > +	hdr->max_cmdsn	=3D cpu_to_be32(conn->sess->max_cmd_sn);
> > +	spin_unlock(&conn->sess->cmdsn_lock);
> > +	hdr->async_event =3D async_event;
> > +	hdr->async_vcode =3D async_vcode;
> > +
> > +	switch (async_event) {
> > +	case ISCSI_ASYNC_MSG_SCSI_EVENT:
> > +		printk(KERN_ERR "ISCSI_ASYNC_MSG_SCSI_EVENT: not supported yet.\=
n");
> > +		return -1;
> > +	case ISCSI_ASYNC_MSG_REQUEST_LOGOUT:
> > +		TRACE(TRACE_STATE, "Moving to"
> > +				" TARG_CONN_STATE_LOGOUT_REQUESTED.\n");
> > +		conn->conn_state =3D TARG_CONN_STATE_LOGOUT_REQUESTED;
> > +		hdr->param1 =3D 0;
> > +		hdr->param2 =3D 0;
> > +		hdr->param3 =3D cpu_to_be16(SECONDS_FOR_ASYNC_LOGOUT);
> > +		break;
> > +	case ISCSI_ASYNC_MSG_DROPPING_CONNECTION:
> > +		hdr->param1 =3D cpu_to_be16(cid);
> > +		hdr->param2 =3D cpu_to_be16(conn->sess->sess_ops->DefaultTime2Wa=
it);
> > +		hdr->param3 =3D cpu_to_be16(conn->sess->sess_ops->DefaultTime2Re=
tain);
> > +		break;
> > +	case ISCSI_ASYNC_MSG_DROPPING_ALL_CONNECTIONS:
> > +		hdr->param1 =3D 0;
> > +		hdr->param2 =3D cpu_to_be16(conn->sess->sess_ops->DefaultTime2Wa=
it);
> > +		hdr->param3 =3D cpu_to_be16(conn->sess->sess_ops->DefaultTime2Re=
tain);
> > +		break;
> > +	case ISCSI_ASYNC_MSG_PARAM_NEGOTIATION:
> > +		hdr->param1 =3D 0;
> > +		hdr->param2 =3D 0;
> > +		hdr->param3 =3D cpu_to_be16(SECONDS_FOR_ASYNC_TEXT);
> > +		break;
> > +	case ISCSI_ASYNC_MSG_VENDOR_SPECIFIC:
> > +		printk(KERN_ERR "ISCSI_ASYNC_MSG_VENDOR_SPECIFIC not"
> > +			" supported yet.\n");
> > +		return -1;
> > +	default:
> > +		printk(KERN_ERR "Unknown AsycnEvent 0x%02x, protocol"
> > +			" error.\n", async_event);
> > +		return -1;
> > +	}
> > +
> > +	iov.iov_base	=3D&iscsi_hdr;
> > +	iov.iov_len	=3D ISCSI_HDR_LEN;
> > +
> > +	if (conn->conn_ops->HeaderDigest) {
> > +		u32 *header_digest =3D (u32 *)&iscsi_hdr[ISCSI_HDR_LEN];
> > +
> > +		crypto_hash_init(&conn->conn_tx_hash);
> > +
> > +		sg_init_one(&sg, (u8 *)&iscsi_hdr, ISCSI_HDR_LEN);
> > +		crypto_hash_update(&conn->conn_tx_hash,&sg, ISCSI_HDR_LEN);
> > +
> > +		crypto_hash_final(&conn->conn_tx_hash, (u8 *)header_digest);
> > +
>=20
> I think you could make this a function too.
>=20

Done.

Added iscsit_do_crypto_hash_buf() and converted iscsit_send_async_msg()
to use this code as well.

Also converted all other conn->conn_tx_hash uses to the the appropriate
new iscsit_do_crypto_hash_*() calls.

>=20
> > +		iov.iov_len +=3D CRC_LEN;
> > +		tx_send +=3D CRC_LEN;
> > +		TRACE(TRACE_DIGEST, "Attaching CRC32 HeaderDigest for Async"
> > +			" Msg PDU 0x%08x\n", *header_digest);
> > +	}
> > +
> > +	TRACE(TRACE_ISCSI, "Built Async Message StatSN: 0x%08x, AsyncEven=
t:"
> > +		" 0x%02x, P1: 0x%04x, P2: 0x%04x, P3: 0x%04x\n",
> > +		ntohl(hdr->statsn), hdr->async_event, ntohs(hdr->param1),
> > +		ntohs(hdr->param2), ntohs(hdr->param3));
> > +
> > +	tx_sent =3D tx_data(conn,&iov, 1, tx_send);
> > +	if (tx_sent !=3D tx_send) {
> > +		printk(KERN_ERR "tx_data returned %d expecting %d\n",
> > +				tx_sent, tx_send);
> > +		return -1;
> > +	}
> > +
> > +	if (async_event =3D=3D ISCSI_ASYNC_MSG_REQUEST_LOGOUT) {
> > +		wait_for_completion_timeout(&conn->sess->async_msg_comp,
> > +					SECONDS_FOR_ASYNC_LOGOUT * HZ);
> > +
> > +		if (conn->conn_state =3D=3D TARG_CONN_STATE_LOGOUT_REQUESTED) {
> > +			printk(KERN_ERR "Asynchronous message timer expired"
> > +				" without receiving a logout request,  dropping"
> > +				" iSCSI session.\n");
> > +			iscsit_send_async_msg(conn, 0,
> > +				ISCSI_ASYNC_MSG_DROPPING_ALL_CONNECTIONS, 0);
> > +			iscsit_free_session(conn->sess);
> > +		}
> > +	}
> > +	return 0;
> > +}
> > +
> > +/*
> > + *	Called with sess->conn_lock held.
> > + */
> > +/* #warning iscsi_build_conn_drop_async_message() only sends out o=
n connections
> > +	with active network interface */
> > +static void iscsit_build_conn_drop_async_message(struct iscsi_conn=
 *conn)
> > +{
> > +	struct iscsi_cmd *cmd;
> > +	struct iscsi_conn *conn_p;
>=20
>=20
> Why do you switch between conn_p and conn? Do you use conn_p when you=
=20
> use it for lists? Kind of strange. If it makes it easier I guess ok. =
If=20
> it was just due to code rework fix it up.
>=20

Yes.  Fixed a bug here for conn->cmd_lock access which should be
conn_p->cmd_lock.

> > +
> > +#ifdef CONFIG_SMP
> > +
> > +void iscsit_thread_get_cpumask(struct iscsi_conn *conn)
>=20
>=20
>=20
> Did Christoph or someone already say something about using workqueues=
 or=20
> per cpu threads with nonblocking IO and running from the softirq on t=
he=20
> recv path? I am assuming so, and skipping this threading code.
>=20
>=20
>=20

Christoph had mentioned getting rid of iscsit_thread_get_cpumask() at
one point, but converting to workqueues for iscsi_target_tx_thread() an=
d
iscsi_target_rx_thread() context is still quite difficult with the
current SIGINT usage for handling iSCSI connection failure cases.

I am still open to considering this as a post-merge improvement, or
something else more exotic like non blocking IO in rx side softirq
context..

>=20
>=20
> > +
> > +int iscsi_target_tx_thread(void *arg)
> > +{
>=20
>=20
> > +	 * Bump up the task_struct priority for RX/TX thread set pairs,
> > +	 * and allow ourselves to be interrupted by SIGINT so that a
> > +	 * connection recovery / failure event can be triggered externall=
y.
> > +	 */
> > +	set_user_nice(current, -20);
>=20
>=20
> What is the reason for using -20 on the target side? On the initiator=
=20
> side I thought people did it to avoid some sort of starvation bug/iss=
ue=20
> but I do not think we have that problem on the target do we?
>=20
> Did you do it for performance reasons? Does it help in current kernel=
s=20
> and by how much?
>=20

I was following the original initiator code here as well.   I am OK wit=
h
dropping this for now..

>=20
> > +
> > +MODULE_DESCRIPTION("RisingTide Systems iSCSI-Target Driver 4.x.x R=
elease");
>=20
> I don't think we put names like RisingTide in module descriptions=20
> either. Put it in MODULE_AUTHOR info.
>=20
> Version info would go in MODULE_VERSION.
>=20
>=20

=46ixed

>=20
>=20
>=20
> > diff --git a/drivers/target/iscsi/iscsi_target_core.h b/drivers/tar=
get/iscsi/iscsi_target_core.h
> > new file mode 100644
> > index 0000000..20d094e
> > --- /dev/null
> > +++ b/drivers/target/iscsi/iscsi_target_core.h
> > @@ -0,0 +1,881 @@
> > +#ifndef ISCSI_TARGET_CORE_H
> > +#define ISCSI_TARGET_CORE_H
> > +
> > +#include<linux/in.h>
> > +#include<linux/configfs.h>
> > +#include<net/sock.h>
> > +#include<net/tcp.h>
> > +#include<scsi/scsi_cmnd.h>
> > +#include<target/target_core_base.h>
> > +
> > +#define ISCSI_VERSION			"v4.1.0-rc1"
>=20
> Should probably be ISCSIT_VERSION.
>=20

Done

> > +#define ISCSI_MAX_DATASN_MISSING_COUNT	16
> > +#define ISCSI_TX_THREAD_TCP_TIMEOUT	2
> > +#define ISCSI_RX_THREAD_TCP_TIMEOUT	2
> > +#define SECONDS_FOR_ASYNC_LOGOUT	10
> > +#define SECONDS_FOR_ASYNC_TEXT		10
> > +#define IPV4_ADDRESS_SPACE		4
> > +#define IPV4_BUF_SIZE			18
>=20
>=20
> IPV4 ones not used.
>=20

Dropped

> > +#define ISCSI_HDR_LEN			48
>=20
>=20
> Should go in iscsi_proto.h?
>=20
>=20

I think so.  Moved into iscsi_proto.h

> > +#define CRC_LEN				4
> > +#define MAX_KEY_NAME_LENGTH		63
> > +#define MAX_KEY_VALUE_LENGTH		255
>=20
>=20
> Where did these come from? Were they iscsi rfc values?
>=20

Correct.  Moving CRC_LEN to iscsi_proto.h:ISCSI_CRC_LEN..

Also, the value for MAX_KEY_NAME_LENGTH=3D63 is mentioned in RFC-3720
Section 5.1. Text Format:

    standard-label: A string of one or more characters that consist of
       letters, digits, dot, minus, plus, commercial at, or underscore.
       A standard-label MUST begin with a capital letter and must not
       exceed 63 characters.

     key-name: A standard-label.

and the value for MAX_KEY_VALUE_LENGTH=3D255 is also mentioned in the
same section:

   If not otherwise specified, the maximum length of a simple-value (no=
t
   its encoded representation) is 255 bytes, not including the delimite=
r
   (comma or zero byte).

Btw, Both of these already exist via KEY_MAXLEN and VALUE_MAXLEN in
iscsi_proto.h.  Converted iscsi-target to use instead..

>=20
> > +#define WHITE_SPACE			" \t\v\f\n\r"
> > +
> > +/* struct iscsi_node_attrib sanity values */
> > +#define NA_DATAOUT_TIMEOUT		3
> > +#define NA_DATAOUT_TIMEOUT_MAX		60
> > +#define NA_DATAOUT_TIMEOUT_MIX		2
> > +#define NA_DATAOUT_TIMEOUT_RETRIES	5
> > +#define NA_DATAOUT_TIMEOUT_RETRIES_MAX	15
> > +#define NA_DATAOUT_TIMEOUT_RETRIES_MIN	1
> > +#define NA_NOPIN_TIMEOUT		5
> > +#define NA_NOPIN_TIMEOUT_MAX		60
> > +#define NA_NOPIN_TIMEOUT_MIN		3
> > +#define NA_NOPIN_RESPONSE_TIMEOUT	5
> > +#define NA_NOPIN_RESPONSE_TIMEOUT_MAX	60
> > +#define NA_NOPIN_RESPONSE_TIMEOUT_MIN	3
> > +#define NA_RANDOM_DATAIN_PDU_OFFSETS	0
> > +#define NA_RANDOM_DATAIN_SEQ_OFFSETS	0
> > +#define NA_RANDOM_R2T_OFFSETS		0
> > +#define NA_DEFAULT_ERL			0
> > +#define NA_DEFAULT_ERL_MAX		2
> > +#define NA_DEFAULT_ERL_MIN		0
> > +
> > +/* struct iscsi_tpg_attrib sanity values */
> > +#define TA_AUTHENTICATION		1
> > +#define TA_LOGIN_TIMEOUT		15
> > +#define TA_LOGIN_TIMEOUT_MAX		30
> > +#define TA_LOGIN_TIMEOUT_MIN		5
> > +#define TA_NETIF_TIMEOUT		2
> > +#define TA_NETIF_TIMEOUT_MAX		15
> > +#define TA_NETIF_TIMEOUT_MIN		2
> > +#define TA_GENERATE_NODE_ACLS		0
> > +#define TA_DEFAULT_CMDSN_DEPTH		16
> > +#define TA_DEFAULT_CMDSN_DEPTH_MAX	512
> > +#define TA_DEFAULT_CMDSN_DEPTH_MIN	1
> > +#define TA_CACHE_DYNAMIC_ACLS		0
> > +/* Enabled by default in demo mode (generic_node_acls=3D1) */
> > +#define TA_DEMO_MODE_WRITE_PROTECT	1
> > +/* Disabled by default in production mode w/ explict ACLs */
> > +#define TA_PROD_MODE_WRITE_PROTECT	0
> > +#define TA_CACHE_CORE_NPS		0
> > +
> > +enum tpg_np_network_transport_table {
> > +	ISCSI_TCP				=3D 0,
> > +	ISCSI_SCTP_TCP				=3D 1,
> > +	ISCSI_SCTP_UDP				=3D 2,
> > +	ISCSI_IWARP_TCP				=3D 3,
> > +	ISCSI_IWARP_SCTP			=3D 4,
> > +	ISCSI_INFINIBAND			=3D 5,
> > +};
> > +
> > +/* RFC-3720 7.1.4  Standard Connection State Diagram for a Target =
*/
> > +enum target_conn_state_table {
> > +	TARG_CONN_STATE_FREE			=3D 0x1,
> > +	TARG_CONN_STATE_XPT_UP			=3D 0x3,
> > +	TARG_CONN_STATE_IN_LOGIN		=3D 0x4,
> > +	TARG_CONN_STATE_LOGGED_IN		=3D 0x5,
> > +	TARG_CONN_STATE_IN_LOGOUT		=3D 0x6,
> > +	TARG_CONN_STATE_LOGOUT_REQUESTED	=3D 0x7,
> > +	TARG_CONN_STATE_CLEANUP_WAIT		=3D 0x8,
> > +};
> > +
> > +/* RFC-3720 7.3.2  Session State Diagram for a Target */
> > +enum target_sess_state_table {
> > +	TARG_SESS_STATE_FREE			=3D 0x1,
> > +	TARG_SESS_STATE_ACTIVE			=3D 0x2,
> > +	TARG_SESS_STATE_LOGGED_IN		=3D 0x3,
> > +	TARG_SESS_STATE_FAILED			=3D 0x4,
> > +	TARG_SESS_STATE_IN_CONTINUE		=3D 0x5,
> > +};
>=20
>=20
> Should the two above be in iscsi_proto.h?
>=20
>=20

Since these are specific to target mode, I think it makes sense to leav=
e
them in iscsi_target_core.h for now..

>=20
>=20
>=20
> > +
> > +struct iscsi_conn {
> > +#define ISCSI_NETDEV_NAME_SIZE				12
> > +	char			net_dev[ISCSI_NETDEV_NAME_SIZE];
>=20
>=20
> Were you going to remove this?

Dropped, along with iscsi_conn->net_if and iscsi_np->np_net_dev.

So with the above changes the diffstat pushed into lio-4.1 looks like:

 drivers/target/iscsi/iscsi_target.c               |  776 ++++++++++---=
--------
 drivers/target/iscsi/iscsi_target.h               |   14 +-
 drivers/target/iscsi/iscsi_target_configfs.c      |   97 ++--
 drivers/target/iscsi/iscsi_target_core.h          |   31 +-
 drivers/target/iscsi/iscsi_target_datain_values.c |    9 +-
 drivers/target/iscsi/iscsi_target_datain_values.h |    4 -
 drivers/target/iscsi/iscsi_target_erl0.c          |   18 +-
 drivers/target/iscsi/iscsi_target_erl0.h          |    2 -
 drivers/target/iscsi/iscsi_target_erl1.c          |   12 +-
 drivers/target/iscsi/iscsi_target_erl1.h          |    2 -
 drivers/target/iscsi/iscsi_target_login.c         |   53 +-
 drivers/target/iscsi/iscsi_target_login.h         |    5 +-
 drivers/target/iscsi/iscsi_target_nego.c          |    4 +-
 drivers/target/iscsi/iscsi_target_nego.h          |    2 -
 drivers/target/iscsi/iscsi_target_parameters.c    |   16 +-
 drivers/target/iscsi/iscsi_target_parameters.h    |    2 -
 drivers/target/iscsi/iscsi_target_seq_pdu_list.c  |   14 +-
 drivers/target/iscsi/iscsi_target_seq_pdu_list.h  |    2 -
 drivers/target/iscsi/iscsi_target_stat.c          |    2 +-
 drivers/target/iscsi/iscsi_target_tpg.c           |   34 +-
 drivers/target/iscsi/iscsi_target_tpg.h           |    6 +-
 drivers/target/iscsi/iscsi_target_tq.c            |   47 +-
 drivers/target/iscsi/iscsi_target_tq.h            |    1 -
 drivers/target/iscsi/iscsi_target_util.c          |  108 +---
 drivers/target/iscsi/iscsi_target_util.h          |   10 +-
 include/scsi/iscsi_proto.h                        |    6 +
 26 files changed, 549 insertions(+), 728 deletions(-)

Thanks for your comments Mike!

--nab

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
