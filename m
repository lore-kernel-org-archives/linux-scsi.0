From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC-v2 02/12] iscsi-target: Add primary iSCSI
	request/response state machine logic
Date: Mon, 14 Mar 2011 17:17:12 -0700
Message-ID: <1300148232.28255.238.camel@haakon2.linux-iscsi.org>
References: <1300103829-10337-1-git-send-email-nab@linux-iscsi.org>
	 <1300103829-10337-3-git-send-email-nab@linux-iscsi.org>
	 <20110314153300.GC28480@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110314153300.GC28480@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Douglas Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2011-03-14 at 16:33 +0100, Christoph Hellwig wrote:
> > +#include <linux/moduleparam.h>
> 
> There's no module paramater in this file, and most others.
> 

Removed.

> > +#include <linux/version.h>
> > +#include <generated/utsrelease.h>
> > +#include <linux/utsname.h>
> 
> You keep including these headers a lot, and I still don't understand why.  Even
> if we need to expose data from it it should be done once in the core and not
> all over the code.
> 

OK, moved into a single iscsi_target_core.h include.

> > +#include <linux/kmod.h>
> 
> I can't find any calls to request_module* or call_usermodehelper* in
> the whole patch.
> 

Removed

> It seems like there's a lot of boilerplate includes cut&pasted all over,
> which need a review.
> 

Indeed.  Removing a bunch of unnecessary boilerplate includes..  My
apologies for missing this obvious cruft.. 

> > +struct kmem_cache *lio_sess_cache;
> > +struct kmem_cache *lio_conn_cache;
> > +struct kmem_cache *lio_qr_cache;
> > +struct kmem_cache *lio_dr_cache;
> > +struct kmem_cache *lio_ooo_cache;
> > +struct kmem_cache *lio_r2t_cache;
> > +struct kmem_cache *lio_tpg_cache;
> 
> Please don't bother with slan caches for long living objects.
> 

Ok, keeping qr_cache, dr_cache, ooo_cache and r2t_cache because these
are in I/O path code.  Dropping sess_cache, conn_cache and tpg_cache.

> > +static void iscsi_rx_thread_wait_for_TCP(struct iscsi_conn *);
> 
> s/TCP/tcp/ please.
> 

Fixed

> > +void core_put_tiqn_for_login(struct iscsi_tiqn *tiqn)
> > +{
> > +	spin_lock(&tiqn->tiqn_state_lock);
> > +	atomic_dec(&tiqn->tiqn_access_count);
> > +	spin_unlock(&tiqn->tiqn_state_lock);
> > +	return;
> 
> no need for the return here.  Also what's the point of making tiqn_access_count
> if you take a spinlock around all it's modifications?
> 

Removed the unnecessary return here..  I was behind paranoid here..

> > +		if (!(strcmp(tiqn->tiqn, buf))) {
> 
> Please remove all pointless braces around a statement that's beeing negated.
> 

Ok, fixed this in more than a handful places..

> > +int __core_del_tiqn(struct iscsi_tiqn *tiqn)
> > +{
> > +	iscsi_disable_tpgs(tiqn);
> > +	iscsi_remove_tpgs(tiqn);
> > +
> > +	spin_lock(&iscsi_global->tiqn_lock);
> > +	list_del(&tiqn->tiqn_list);
> > +	spin_unlock(&iscsi_global->tiqn_lock);
> > +
> > +	printk(KERN_INFO "CORE[0] - Deleted iSCSI Target IQN: %s\n",
> > +			tiqn->tiqn);
> > +	kfree(tiqn);
> > +
> > +	return 0;
> 
> Why bother with a return value here?
> 

Ok, making *core_del_tiqn() return void.

> > +void *core_get_np_ip(struct iscsi_np *np)
> > +{
> > +	return (np->np_flags & NPF_NET_IPV6) ?
> > +	       (void *)&np->np_ipv6[0] :
> > +	       (void *)&np->np_ipv4;
> > +}
> 
> I'd rather abstract this into a proper helper together with the memcmp
> in it's caller than returning the type-unsafe void and requiring the caller to
> use the right size for the comparism.
> 

Mmmmm yes, I will get this fixed up..

> > +void *core_get_np_ex_ip(struct iscsi_np_ex *np_ex)
> > +{
> > +	return (np_ex->np_ex_net_size == IPV6_ADDRESS_SPACE) ?
> > +	       (void *)&np_ex->np_ex_ipv6 :
> > +	       (void *)&np_ex->np_ex_ipv4;
> > +}
> 
> Same here.
> 

Ditto..

> > +int core_reset_np_thread(
> 
> core_ is not a very good name for a non-static symbol.
> 
> IMHO the whole iscsi target should have a unique prefix for all symbols like
> iscsit_
> 

Indeed..  Ok, I am going to go ahead an rename everything using core_ to
iscsi_

> > +	if (np->np_thread_state == ISCSI_NP_THREAD_INACTIVE) {
> > +		spin_unlock_bh(&np->np_thread_lock);
> > +		return 0;
> > +	}
> > +
> > +	np->np_thread_state = ISCSI_NP_THREAD_RESET;
> > +	if (shutdown)
> > +		atomic_set(&np->np_shutdown, 1);
> > +
> > +	if (np->np_thread) {
> > +		spin_unlock_bh(&np->np_thread_lock);
> > +		send_sig(SIGKILL, np->np_thread, 1);
> > +		down(&np->np_restart_sem);
> > +		spin_lock_bh(&np->np_thread_lock);
> > +	}
> > +	spin_unlock_bh(&np->np_thread_lock);
> 
> Please replace this and all the grotty state related code in
> iscsi_target_login_thread with proper use of the kthread API.
> 
> That is:
> 
>  - kill off iscsi_daemon and the whole mess around it, kthread_create/run do
>    properly set up a thread
>  - kill np_start_sem, kthread_run guarantees that the thread had a chance to
>    run before we return to the caller
>  - remove the pointless flush_signals
>  - kill the whole np_thread_state state machine.  Just store a pointer
>    to the thread in the np structure, protected by a sleeping lock that
>    prevents multiple callers from racing to start/stop the thread.
>  - maybe restructure iscsi_target_login_thread into helpers doing the actual
>    work, and the thread glue around it to actually make it readable.
> 

Ok, I need to take a deeper look but this all sounds fine..  

> > +int core_del_np_comm(struct iscsi_np *np)
> > +{
> > +	if (!np->np_socket)
> > +		return 0;
> > +
> > +	/*
> > +	 * Some network transports set their own FILEIO, see
> > +	 * if we need to free any additional allocated resources.
> > +	 */
> 
> What is this comment supposed to mean?
> 

Fixed to read:  "Some network transports allocate their own struct
sock->file, ..."

> > + * Allocate a new row index for the entry type specified
> > + */
> > +u32 iscsi_get_new_index(iscsi_index_t type)
> > +{
> > +	u32 new_index;
> > +
> > +	if ((type < 0) || (type >= INDEX_TYPE_MAX)) {
> > +		printk(KERN_ERR "Invalid index type %d\n", type);
> > +		return -1;
> > +	}
> > +
> > +	spin_lock(&iscsi_index_table.lock);
> > +	new_index = ++iscsi_index_table.iscsi_mib_index[type];
> > +	if (new_index == 0)
> > +		new_index = ++iscsi_index_table.iscsi_mib_index[type];
> > +	spin_unlock(&iscsi_index_table.lock);
> > +
> > +	return new_index;
> > +}
> 
> Can't you just use the core idr code for generating indices?
> 

Mmmm, not sure what you mean here..

> > +static int init_iscsi_global(struct iscsi_global *global)
> > +{
> > +	memset(global, 0, sizeof(struct iscsi_global));
> 
> No need to memset a global structure.
> 

memset removed.

> > +	sema_init(&global->auth_sem, 1);
> > +	sema_init(&global->auth_id_sem, 1);
> 
> Please avoid new semaphores if possible at all. auth_sem seems to be unused so
> could just be removed, and auth_id_sem could be replaced with a mutex,
> or even better a spinlock or an atomic type for the auth_id field.
> 

Ok, there are a quite a few struct semaphores that need to be converted
into a struct mutex or struct completion..  I will get all of these
converted over..

> > +	spin_lock_init(&global->check_thread_lock);
> 
> unused.
> 
> > +	spin_lock_init(&global->discovery_lock);
> 
> unused.
> 
> > +	spin_lock_init(&global->login_thread_lock);
> 
> unused.
> 

All three removed.

> > +	spin_lock_init(&global->g_tpg_lock);
> > +	INIT_LIST_HEAD(&global->g_tiqn_list);
> > +	INIT_LIST_HEAD(&global->g_tpg_list);
> > +	INIT_LIST_HEAD(&global->g_np_list);
> > +	INIT_LIST_HEAD(&global->active_ts_list);
> > +	INIT_LIST_HEAD(&global->inactive_ts_list);
> 
> Please just make these things normal global-scope variables.  That'll allow to
> initialize them at compile time, too.
> 

<nod>, converting these to global scope variables.  Also dropping
g_tpg_* as well which is left-over cruft from iscsi_target_mib.c and can
be safetly removed now..

> > + *	0) Allocates and initializes the struct iscsi_global structure.
> > + *	1) Registers the character device for the IOCTL.
> > + *	2) Registers /proc filesystem entries.
> > + *	3) Creates a lookaside cache entry for the struct iscsi_cmd and
> > + *	   struct iscsi_conn structures.
> > + *	4) Allocates threads to handle login requests.
> > + *	5) Allocates thread_sets for the thread_set queue.
> > + *	6) Creates the default list of iSCSI parameters.
> > + *	7) Create server socket and spawn iscsi_target_server_thread to
> > + *	   accept connections.
> > + *
> > + *	Parameters:	Nothing.
> > + *	Returns:	0 on success, -1 on error.
> 
> Don't bother describe what a function does unless it's totally non-obvious,
> which it certainly isn't here.
> 

<nod>, removed.

> > +	lio_cmd_cache = NULL;
> > +	lio_sess_cache = NULL;
> > +	lio_conn_cache = NULL;
> > +	lio_qr_cache = NULL;
> > +	lio_dr_cache = NULL;
> > +	lio_ooo_cache = NULL;
> > +	lio_r2t_cache = NULL;
> > +	lio_tpg_cache = NULL;
> 
> The compiler zeroes out all these.
> 

Removed

> > +	iscsi_target_register_configfs();
> > +	iscsi_thread_set_init();
> 
> These looks like they could return errors?
> 

Mmmm yes.  Fixed to handle failures from iscsi_target_register_configfs
and iscsi_thread_set_init.

> > +out:
> > +	if (lio_cmd_cache)
> > +		kmem_cache_destroy(lio_cmd_cache);
> > +	if (lio_sess_cache)
> > +		kmem_cache_destroy(lio_sess_cache);
> > +	if (lio_conn_cache)
> > +		kmem_cache_destroy(lio_conn_cache);
> > +	if (lio_qr_cache)
> > +		kmem_cache_destroy(lio_qr_cache);
> > +	if (lio_dr_cache)
> > +		kmem_cache_destroy(lio_dr_cache);
> > +	if (lio_ooo_cache)
> > +		kmem_cache_destroy(lio_ooo_cache);
> 
> please use proper unwinding with one goto label per ressource that needs
> unwinding.
> 

Fixed

> > +static int iscsi_target_release(void)
> > +{
> > +	int ret = 0;
> > +
> > +	if (!iscsi_global)
> > +		return ret;
> 
> How could this happen?
> 

Removed

> > +/*	iscsi_add_reject_from_cmd():
> > + *
> > + *
> > + */
> 
> comments wit just the function name in them are utterly useless.
> 

Yep, removed a whole bunch of these

> > +	memset((void *)&map_sg, 0, sizeof(struct se_map_sg));
> > +	memset((void *)&unmap_sg, 0, sizeof(struct se_unmap_sg));
> 
> There is no need to cast the first argument to memset.
> 

Fixed in a number of locations

> > +	{
> > +	struct iscsi_tiqn *tiqn = iscsi_snmp_get_tiqn(conn);
> > +
> > +	if (tiqn) {
> > +		spin_lock(&tiqn->logout_stats.lock);
> > +		if (reason_code == ISCSI_LOGOUT_REASON_CLOSE_SESSION)
> > +			tiqn->logout_stats.normal_logouts++;
> > +		else
> > +			tiqn->logout_stats.abnormal_logouts++;
> > +		spin_unlock(&tiqn->logout_stats.lock);
> > +		}
> > +	}
> 
> something bad happened to the indentation here.
> 

Fixed up this ugliness..

> > +	{
> > +	    char name[20];
> > +
> > +	    memset(name, 0, 20);
> > +	    sprintf(name, "%s/%u", ISCSI_TX_THREAD_NAME, ts->thread_id);
> > +	    iscsi_daemon(ts->tx_thread, name, SHUTDOWN_SIGS);
> > +	}
> 
> The thread handling comment for the login thread applies here as well.
> 
> > +	    char name[20];
> > +
> > +	    memset(name, 0, 20);
> > +	    sprintf(name, "%s/%u", ISCSI_RX_THREAD_NAME, ts->thread_id);
> > +	    iscsi_daemon(ts->rx_thread, name, SHUTDOWN_SIGS);
> 
> And here.
> 

Ok, this is where I have previously run into some issues after doing a
kthread conversion for the RX/TX pairs using sock_recvmsg() some time a
while back.  That said, I will go ahead will get the ulgiest pieces for
the NP thread converted first and then have another look where the RX
path code was (I think) having an issue to successfully perform iSCSI
Logout Request -> Response processing..

> > +static int __init iscsi_target_init_module(void)
> > +{
> > +	if (!(iscsi_target_detect()))
> > +		return 0;
> > +
> > +	return -1;
> > +}
> > +
> > +static void __exit iscsi_target_cleanup_module(void)
> > +{
> > +	iscsi_target_release();
> > +}
> 
> Please merge iscsi_target_detect into iscsi_target_init_module
> and iscsi_target_release into iscsi_target_cleanup_module.
> 

Done

> > +#ifdef MODULE
> > +MODULE_DESCRIPTION("LIO Target Driver Core 4.x.x Release");
> > +MODULE_LICENSE("GPL");
> > +module_init(iscsi_target_init_module);
> > +module_exit(iscsi_target_cleanup_module);
> > +#endif /* MODULE */
> 
> No need for the #idef MODULE here.
> Also a MODULE_AUTHOR line would be useful.
> 

Removed the unnecessary stub and added MODULE_AUTHOR().

> > --- /dev/null
> > +++ b/drivers/target/iscsi/iscsi_target.h
> 
> > --- /dev/null
> > +++ b/drivers/target/iscsi/iscsi_target_core.h
> 
> What is the logical split between iscsi_target.h and iscsi_target_core.h?
> 

iscsi_target.h is supposed to contain the function prototypes for the
main I/O statemachine and I_T nexus related code.  iscsi_target_core.h
is for the definitions.

The TIQN and network portal handling code should probably be moved out
of iscsi_target.c btw..

> > +#define MOD_TIMER(t, exp) mod_timer(t, (get_jiffies_64() + exp * HZ))
> > +#define SETUP_TIMER(timer, t, d, func)			\
> > +	timer.expires	= (get_jiffies_64() + t * HZ);	\
> > +	timer.data	= (unsigned long) d;		\
> > +	timer.function	= func;
> 
> Please remove these.
> 

<nod>

> > +#define CONN(cmd)		((struct iscsi_conn *)(cmd)->conn)
> > +#define CONN_OPS(conn)		((struct iscsi_conn_ops *)(conn)->conn_ops)
> 
> There really shouldn't be any need for these macros.
> 
> 
> > +#define SESS(conn)		((struct iscsi_session *)(conn)->sess)
> > +#define SESS_OPS(sess)		((struct iscsi_sess_ops *)(sess)->sess_ops)
> > +#define SESS_OPS_C(conn)	((struct iscsi_sess_ops *)(conn)->sess->sess_ops)
> > +#define SESS_NODE_ACL(sess)	((struct se_node_acl *)(sess)->se_sess->se_node_acl)
> 
> Same here.
> 

Ok, I will drop the unnecessary casts here, and I will look at thinning
-> removing these out these handful of macros.

The first series of changes will be pushed out to lio-4.1 shortly and I
will have a look iataddressing the other major items mentioned above.

As usual thanks for the very detailed comments Christoph!

--nab
