From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC-v3 02/12] iscsi-target: Add primary iSCSI
	request/response state machine logic
Date: Fri, 18 Mar 2011 15:40:48 +0100
Message-ID: <20110318144047.GA29478@lst.de>
References: <1300398797-24536-1-git-send-email-nab@linux-iscsi.org> <1300398797-24536-3-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1300398797-24536-3-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Andrew Morton <akpm@linux-foundation.org>, Douglas Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Mar 17, 2011 at 02:53:07PM -0700, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch adds iscsi_target.[c,h] containing the main iSCSI Request and
> Response PDU state machines and accompanying infrastructure code and
> base iscsi_target_core.h include for iscsi_target_mod.  This includes
> support for all defined iSCSI operation codes from RFC-3720 Section
> 10.2.1.2 and primary state machines for per struct iscsi_conn RX/TX
> threads.
> 
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/target/iscsi/iscsi_target.c      | 5371 ++++++++++++++++++++++++++++++
>  drivers/target/iscsi/iscsi_target.h      |   45 +
>  drivers/target/iscsi/iscsi_target_core.h |  888 +++++
>  3 files changed, 6304 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/target/iscsi/iscsi_target.c
>  create mode 100644 drivers/target/iscsi/iscsi_target.h
>  create mode 100644 drivers/target/iscsi/iscsi_target_core.h

> +static struct iscsi_np *iscsit_get_np(
> +	unsigned char *ipv6,
> +	u32 ipv4,
> +	u16 port,
> +	int network_transport)

> +		if (ipv6 != NULL) {
> +			p = (void *)&np->np_ipv6[0];
> +			ip = (void *)ipv6;
> +			net_size = IPV6_ADDRESS_SPACE;
> +		} else {
> +			p = (void *)&np->np_ipv4;
> +			ip = (void *)&ipv4;
> +			net_size = IPV4_ADDRESS_SPACE;
> +		}
> +
> +		if (!memcmp(p, ip, net_size) && (np->np_port == port) &&

All this opencoded handling of IPV4 vs IPV6 address is still quite a mess.

What's the problem with always passing around a struct sockaddr, and then
have helpers that treat it like a sockaddr_in or sockaddr_in6 depending
on the ->ss_family field?  That's what at least the iSCSI initiator and
NFS client and server do.

> +int iscsit_del_np_thread(struct iscsi_np *np)
> +{
> +	spin_lock_bh(&np->np_thread_lock);
> +	np->np_thread_state = ISCSI_NP_THREAD_SHUTDOWN;
> +	atomic_set(&np->np_shutdown, 1);
> +	spin_unlock_bh(&np->np_thread_lock);
> +
> +	if (np->np_thread) {
> +		/*
> +		 * We need to send the signal to wakeup Linux/Net
> +		 * sock_accept()..
> +		 */
> +		send_sig(SIGINT, np->np_thread, 1);
> +		kthread_stop(np->np_thread);
> +	}

What's the point of np_shutdown and the thread_state?

kthread_should_stop() returns true if the thread should stop, so
it can replace the shutdown check.  You'll still need some indicator
for the pure reset case, but except for that the kthread API alone
should do it.

> +u32 lio_sess_get_initiator_sid(

> +int iscsi_add_nopin(

> +int iscsi_add_reject(

Why are all these fabric ops method implementations in a different file
from the code assigning them to the ops vector?  Having all these static
and just an ops vector or helper to assign it exposed gives much better
visibility control.

> +/* #define iscsi_calculate_map_segment_DEBUG */
> +#ifdef iscsi_calculate_map_segment_DEBUG
> +#define DEBUG_MAP_SEGMENTS(buf...) PYXPRINT(buf)
> +#else
> +#define DEBUG_MAP_SEGMENTS(buf...)
> +#endif

Do we need to keep all this ad-hoc debugging code?

> +/*	iscsi_logout_closesession():
> + *
> + *
> + */

As mentioned in a previous round please try to remove all comment which
like this one don't provide any documentation value by just repeating
the function name.

> +
> +		add_timer(&async_msg_timer);
> +		wait_for_completion(&conn->sess->async_msg_comp);
> +		del_timer_sync(&async_msg_timer);

Just use wait_for_completion_timeout here.

> +static void iscsi_tx_thread_TCP_timeout(unsigned long data)
> +{
> +	complete((struct completion *)data);
> +}
> +
> +static void iscsi_tx_thread_wait_for_tcp(struct iscsi_conn *conn)
> +{
> +	struct timer_list tx_TCP_timer;
> +	int ret;
> +
> +	if ((conn->sock->sk->sk_shutdown & SEND_SHUTDOWN) ||
> +	    (conn->sock->sk->sk_shutdown & RCV_SHUTDOWN)) {
> +		init_timer(&tx_TCP_timer);
> +		tx_TCP_timer.expires =
> +			(get_jiffies_64() + ISCSI_TX_THREAD_TCP_TIMEOUT * HZ);
> +		tx_TCP_timer.data = (unsigned long)&conn->tx_half_close_comp;
> +		tx_TCP_timer.function = iscsi_tx_thread_TCP_timeout;
> +
> +		add_timer(&tx_TCP_timer);
> +		ret = wait_for_completion_interruptible(&conn->tx_half_close_comp);
> +		del_timer_sync(&tx_TCP_timer);

and wait_for_completion_interruptible_timeout here, please.

> +	set_user_nice(current, -20);

Messing with the nice level at least needs an explanation.

> +	allow_signal(SIGINT);
> +
> +restart:
> +	conn = iscsi_tx_thread_pre_handler(ts);
> +	if (!conn)
> +		goto out;
> +
> +	eodr = map_sg = ret = sent_status = use_misc = 0;
> +
> +	while (!kthread_should_stop()) {
> +		/*
> +		 * Ensure that both TX and RX per connection kthreads
> +		 * are scheduled to run on the same CPU.
> +		 */
> +		iscsi_thread_check_cpumask(conn, current, 1);

Would kthread_bind help with binding the threads to CPUs?

> +		ret = wait_for_completion_interruptible(&conn->tx_comp);

This looks like the functions to queue up work should just do a
wake_up_process on the tast structure, and the thread itself should
just do a schedule_timeout().

> +static void iscsi_rx_thread_TCP_timeout(unsigned long data)
> +{
> +	complete((struct completion *)data);
> +}
> +
> +static void iscsi_rx_thread_wait_for_tcp(struct iscsi_conn *conn)
> +{
> +	struct timer_list rx_TCP_timer;
> +	int ret;
> +
> +	if ((conn->sock->sk->sk_shutdown & SEND_SHUTDOWN) ||
> +	    (conn->sock->sk->sk_shutdown & RCV_SHUTDOWN)) {
> +		init_timer(&rx_TCP_timer);
> +		rx_TCP_timer.expires =
> +			(get_jiffies_64() + ISCSI_RX_THREAD_TCP_TIMEOUT * HZ);
> +		rx_TCP_timer.data = (unsigned long)&conn->rx_half_close_comp;
> +		rx_TCP_timer.function = iscsi_rx_thread_TCP_timeout;
> +
> +		add_timer(&rx_TCP_timer);
> +		ret = wait_for_completion_interruptible(&conn->rx_half_close_comp);
> +		del_timer_sync(&rx_TCP_timer);

wait_for_completion_interruptible_timeout again, please.


> +	set_user_nice(current, -20);

explanation, please.

> +	spin_lock_bh(&conn->cmd_lock);
> +	list_for_each_entry_safe(cmd, cmd_tmp, &conn->conn_cmd_list, i_list) {
> +		if (!(SE_CMD(cmd)) ||
> +		    !(SE_CMD(cmd)->se_cmd_flags & SCF_SE_LUN_CMD)) {
> +
> +			list_del(&cmd->i_list);
> +			spin_unlock_bh(&conn->cmd_lock);

What gurantees the list hasn't been modified after the lock was released?

> +	/*
> +	 * If connection reinstatement is being performed on this connection
> +	 * by receiving a REMOVECONNFORRECOVERY logout request, up the
> +	 * connection wait rcfr semaphore that is being blocked on
> +	 * an iscsi_connection_reinstatement_rcfr().
> +	 */
> +	if (atomic_read(&conn->connection_wait_rcfr)) {
> +		spin_unlock_bh(&conn->state_lock);
> +		complete(&conn->conn_wait_rcfr_comp);
> +		wait_for_completion(&conn->conn_post_wait_comp);

I'm trying to understand what this (and the similar block next to it)
is doing.  You wake up another process in the ERL code, which does
nothing but waking this code up again.  Why do we have to wait here
until the ERL code did it's run?


> +int iscsi_close_session(struct iscsi_session *sess)

The code still seems to be undecided on iscsi_ vs iscsit_ as a prefix.

> +	spin_lock_bh(&sess->conn_lock);
> +	if (session_sleep)
> +		atomic_set(&sess->sleep_on_sess_wait_comp, 1);
> +
> +	if (connection_sleep) {
> +		list_for_each_entry_safe(conn, conn_tmp, &sess->sess_conn_list,
> +				conn_list) {
> +			if (conn_count == 0)
> +				break;
> +
> +			iscsi_inc_conn_usage_count(conn);
> +			spin_unlock_bh(&sess->conn_lock);

What protects the next entry from going away after dropping the lock?
