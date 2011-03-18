From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC-v3 02/12] iscsi-target: Add primary iSCSI
	request/response state machine logic
Date: Fri, 18 Mar 2011 16:40:58 -0700
Message-ID: <1300491658.20672.106.camel@haakon2.linux-iscsi.org>
References: <1300398797-24536-1-git-send-email-nab@linux-iscsi.org>
	 <1300398797-24536-3-git-send-email-nab@linux-iscsi.org>
	 <20110318144047.GA29478@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:39335 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755989Ab1CRXsE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Mar 2011 19:48:04 -0400
In-Reply-To: <20110318144047.GA29478@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Andrew Morton <akpm@linux-foundation.org>, Douglas Gilbert <dgilbert@interlog.com>

On Fri, 2011-03-18 at 15:40 +0100, Christoph Hellwig wrote:
> On Thu, Mar 17, 2011 at 02:53:07PM -0700, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > This patch adds iscsi_target.[c,h] containing the main iSCSI Request and
> > Response PDU state machines and accompanying infrastructure code and
> > base iscsi_target_core.h include for iscsi_target_mod.  This includes
> > support for all defined iSCSI operation codes from RFC-3720 Section
> > 10.2.1.2 and primary state machines for per struct iscsi_conn RX/TX
> > threads.
> > 
> > Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> > ---
> >  drivers/target/iscsi/iscsi_target.c      | 5371 ++++++++++++++++++++++++++++++
> >  drivers/target/iscsi/iscsi_target.h      |   45 +
> >  drivers/target/iscsi/iscsi_target_core.h |  888 +++++
> >  3 files changed, 6304 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/target/iscsi/iscsi_target.c
> >  create mode 100644 drivers/target/iscsi/iscsi_target.h
> >  create mode 100644 drivers/target/iscsi/iscsi_target_core.h
> 
> > +static struct iscsi_np *iscsit_get_np(
> > +	unsigned char *ipv6,
> > +	u32 ipv4,
> > +	u16 port,
> > +	int network_transport)
> 
> > +		if (ipv6 != NULL) {
> > +			p = (void *)&np->np_ipv6[0];
> > +			ip = (void *)ipv6;
> > +			net_size = IPV6_ADDRESS_SPACE;
> > +		} else {
> > +			p = (void *)&np->np_ipv4;
> > +			ip = (void *)&ipv4;
> > +			net_size = IPV4_ADDRESS_SPACE;
> > +		}
> > +
> > +		if (!memcmp(p, ip, net_size) && (np->np_port == port) &&
> 
> All this opencoded handling of IPV4 vs IPV6 address is still quite a mess.
> 
> What's the problem with always passing around a struct sockaddr, and then
> have helpers that treat it like a sockaddr_in or sockaddr_in6 depending
> on the ->ss_family field?  That's what at least the iSCSI initiator and
> NFS client and server do.
> 

<nod>, will get this converted over to follow existing code.

> > +int iscsit_del_np_thread(struct iscsi_np *np)
> > +{
> > +	spin_lock_bh(&np->np_thread_lock);
> > +	np->np_thread_state = ISCSI_NP_THREAD_SHUTDOWN;
> > +	atomic_set(&np->np_shutdown, 1);
> > +	spin_unlock_bh(&np->np_thread_lock);
> > +
> > +	if (np->np_thread) {
> > +		/*
> > +		 * We need to send the signal to wakeup Linux/Net
> > +		 * sock_accept()..
> > +		 */
> > +		send_sig(SIGINT, np->np_thread, 1);
> > +		kthread_stop(np->np_thread);
> > +	}
> 
> What's the point of np_shutdown and the thread_state?
> 

np_shutdown is used in a handful of places external to
iscsi_target_login_thread() context to skip processing of iscsi_np while
the shutdown is happening. 

> kthread_should_stop() returns true if the thread should stop, so
> it can replace the shutdown check.

Ok, I will drop np_shutdown and just check thread_state for these
handful of cases outside of iscsi_target_login_thread() context
currently checking for iscsi_np->np_shutdown..

> You'll still need some indicator
> for the pure reset case, but except for that the kthread API alone
> should do it.
> 

<nod>, keeping thread_state for this purpose..

> > +u32 lio_sess_get_initiator_sid(
> 
> > +int iscsi_add_nopin(
> 
> > +int iscsi_add_reject(
> 
> Why are all these fabric ops method implementations in a different file
> from the code assigning them to the ops vector?  Having all these static
> and just an ops vector or helper to assign it exposed gives much better
> visibility control.
> 

Only sess_get_initiator_sid is a fabric ops method btw, but point taken.
I will take a look at iscsi_target_util.c and make everything possible
statically defined.

> > +/* #define iscsi_calculate_map_segment_DEBUG */
> > +#ifdef iscsi_calculate_map_segment_DEBUG
> > +#define DEBUG_MAP_SEGMENTS(buf...) PYXPRINT(buf)
> > +#else
> > +#define DEBUG_MAP_SEGMENTS(buf...)
> > +#endif
> 
> Do we need to keep all this ad-hoc debugging code?
> 

Dropping all of these now..

> > +/*	iscsi_logout_closesession():
> > + *
> > + *
> > + */
> 
> As mentioned in a previous round please try to remove all comment which
> like this one don't provide any documentation value by just repeating
> the function name.
> 

Ugh, sorry, will get all of these removed

> > +
> > +		add_timer(&async_msg_timer);
> > +		wait_for_completion(&conn->sess->async_msg_comp);
> > +		del_timer_sync(&async_msg_timer);
> 
> Just use wait_for_completion_timeout here.
> 

Converted

> > +static void iscsi_tx_thread_TCP_timeout(unsigned long data)
> > +{
> > +	complete((struct completion *)data);
> > +}
> > +
> > +static void iscsi_tx_thread_wait_for_tcp(struct iscsi_conn *conn)
> > +{
> > +	struct timer_list tx_TCP_timer;
> > +	int ret;
> > +
> > +	if ((conn->sock->sk->sk_shutdown & SEND_SHUTDOWN) ||
> > +	    (conn->sock->sk->sk_shutdown & RCV_SHUTDOWN)) {
> > +		init_timer(&tx_TCP_timer);
> > +		tx_TCP_timer.expires =
> > +			(get_jiffies_64() + ISCSI_TX_THREAD_TCP_TIMEOUT * HZ);
> > +		tx_TCP_timer.data = (unsigned long)&conn->tx_half_close_comp;
> > +		tx_TCP_timer.function = iscsi_tx_thread_TCP_timeout;
> > +
> > +		add_timer(&tx_TCP_timer);
> > +		ret = wait_for_completion_interruptible(&conn->tx_half_close_comp);
> > +		del_timer_sync(&tx_TCP_timer);
> 
> and wait_for_completion_interruptible_timeout here, please.
> 

Converted

> > +	set_user_nice(current, -20);
> 
> Messing with the nice level at least needs an explanation.
> 

I think this was originally from iSCSI Initiator code and/or NDB (which
still uses it btw), and several other mainline software fabric users do
it as well; drivers/scsi/fcoe/fcoe.c:fcoe_percpu_receive_thread()

Adding a comments here..

> > +	allow_signal(SIGINT);
> > +
> > +restart:
> > +	conn = iscsi_tx_thread_pre_handler(ts);
> > +	if (!conn)
> > +		goto out;
> > +
> > +	eodr = map_sg = ret = sent_status = use_misc = 0;
> > +
> > +	while (!kthread_should_stop()) {
> > +		/*
> > +		 * Ensure that both TX and RX per connection kthreads
> > +		 * are scheduled to run on the same CPU.
> > +		 */
> > +		iscsi_thread_check_cpumask(conn, current, 1);
> 
> Would kthread_bind help with binding the threads to CPUs?
> 

Hmmm, need to have a deeper look at this.

Converting this would mean that the RX/TX thread pairs would only be
calling kthread_bind() once when the threads are created, instead of
checking per each RX/TX loop iteration w/ iscsi_thread_check_cpumask().

I think being able to re-bind these to different CPUs after the fact
would still be useful though..  If we are using kthread_bind() during
initial thread creation, how would re-binding work once the thread is
running..?

> > +		ret = wait_for_completion_interruptible(&conn->tx_comp);
> 
> This looks like the functions to queue up work should just do a
> wake_up_process on the tast structure, and the thread itself should
> just do a schedule_timeout().
> 

OK, converting iscsi_target_tx_thread() to use wake_up_process() and
schedule_timeout().

> > +static void iscsi_rx_thread_TCP_timeout(unsigned long data)
> > +{
> > +	complete((struct completion *)data);
> > +}
> > +
> > +static void iscsi_rx_thread_wait_for_tcp(struct iscsi_conn *conn)
> > +{
> > +	struct timer_list rx_TCP_timer;
> > +	int ret;
> > +
> > +	if ((conn->sock->sk->sk_shutdown & SEND_SHUTDOWN) ||
> > +	    (conn->sock->sk->sk_shutdown & RCV_SHUTDOWN)) {
> > +		init_timer(&rx_TCP_timer);
> > +		rx_TCP_timer.expires =
> > +			(get_jiffies_64() + ISCSI_RX_THREAD_TCP_TIMEOUT * HZ);
> > +		rx_TCP_timer.data = (unsigned long)&conn->rx_half_close_comp;
> > +		rx_TCP_timer.function = iscsi_rx_thread_TCP_timeout;
> > +
> > +		add_timer(&rx_TCP_timer);
> > +		ret = wait_for_completion_interruptible(&conn->rx_half_close_comp);
> > +		del_timer_sync(&rx_TCP_timer);
> 
> wait_for_completion_interruptible_timeout again, please.
> 

Converted

> 
> > +	set_user_nice(current, -20);
> 
> explanation, please.
> 
> > +	spin_lock_bh(&conn->cmd_lock);
> > +	list_for_each_entry_safe(cmd, cmd_tmp, &conn->conn_cmd_list, i_list) {
> > +		if (!(SE_CMD(cmd)) ||
> > +		    !(SE_CMD(cmd)->se_cmd_flags & SCF_SE_LUN_CMD)) {
> > +
> > +			list_del(&cmd->i_list);
> > +			spin_unlock_bh(&conn->cmd_lock);
> 
> What gurantees the list hasn't been modified after the lock was released?
> 

At this point for a RX/TX connection pair during a connection logout or
failure event, only one of the two threads can ever call:

	iscsi_take_action_for_connection_exit() -> 		
		iscsi_handle_connection_cleanup() ->
			iscsi_close_connection() -> 		
				iscsi_release_commands_from_conn()

The other will return back to sleeping in
iscsi_[r,t]x_thread_pre_handler() waiting for the iSCSI connection to be
shutdown.

> > +	/*
> > +	 * If connection reinstatement is being performed on this connection
> > +	 * by receiving a REMOVECONNFORRECOVERY logout request, up the
> > +	 * connection wait rcfr semaphore that is being blocked on
> > +	 * an iscsi_connection_reinstatement_rcfr().
> > +	 */
> > +	if (atomic_read(&conn->connection_wait_rcfr)) {
> > +		spin_unlock_bh(&conn->state_lock);
> > +		complete(&conn->conn_wait_rcfr_comp);
> > +		wait_for_completion(&conn->conn_post_wait_comp);
> 
> I'm trying to understand what this (and the similar block next to it)
> is doing.  You wake up another process in the ERL code, which does
> nothing but waking this code up again.  Why do we have to wait here
> until the ERL code did it's run?
> 

These are two special cases where iscsi_target_login_thread() context
may already be initiating recovery for an struct iscsi_conn, and then
iSCSI connection failure or logout toccurs from within the active RX/TX
thread pair context.

> 
> > +int iscsi_close_session(struct iscsi_session *sess)
> 
> The code still seems to be undecided on iscsi_ vs iscsit_ as a prefix.
> 

Yes, the first name conversion was specifically for the core_* prefix
code in iscsi_target.c.  I will go ahead and convert this specifically
for the main iscsi_target.c file, but I would prefer to avoid doing this
for stuff outside of iscsi_target.c

> > +	spin_lock_bh(&sess->conn_lock);
> > +	if (session_sleep)
> > +		atomic_set(&sess->sleep_on_sess_wait_comp, 1);
> > +
> > +	if (connection_sleep) {
> > +		list_for_each_entry_safe(conn, conn_tmp, &sess->sess_conn_list,
> > +				conn_list) {
> > +			if (conn_count == 0)
> > +				break;
> > +
> > +			iscsi_inc_conn_usage_count(conn);
> > +			spin_unlock_bh(&sess->conn_lock);
> 
> What protects the next entry from going away after dropping the lock?
> 

Good catch.  Fixing this now by adding a conn_usage reference to
conn_tmp when non NULL..

I will get these items fixed up and tested in lio-4.1 and will send out
an updated patch over the weekend.   Please let me know if you have any
other comments and I will try to get them addressed ASAP.

Thanks,

--nab

