From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC-v4 11/12] iscsi-target: Add misc utility and debug logic
Date: Tue, 22 Mar 2011 14:35:02 -0700
Message-ID: <1300829702.21880.338.camel@haakon2.linux-iscsi.org>
References: <1300613497-2091-1-git-send-email-nab@linux-iscsi.org>
	 <1300613497-2091-12-git-send-email-nab@linux-iscsi.org>
	 <4D881FC0.5080100@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:52014 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932216Ab1CVVmQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Mar 2011 17:42:16 -0400
In-Reply-To: <4D881FC0.5080100@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Andrew Morton <akpm@linux-foundation.org>, Douglas Gilbert <dgilbert@interlog.com>, Jesper Juhl <jj@chaosbits.net>

On Mon, 2011-03-21 at 23:04 -0500, Mike Christie wrote:
> On 03/20/2011 04:31 AM, Nicholas A. Bellinger wrote
> 
> > +
> > +/*
> > + *	Called with cmd->r2t_lock held.
> > + */
> > +void iscsit_free_r2t(struct iscsi_r2t *r2t, struct iscsi_cmd *cmd)
> > +{
> > +	list_del(&r2t->r2t_list);
> > +	kmem_cache_free(lio_r2t_cache, r2t);
> > +}
> > +
> > +void iscsit_free_r2ts_from_list(struct iscsi_cmd *cmd)
> > +{
> > +	struct iscsi_r2t *r2t, *r2t_tmp;
> > +
> > +	spin_lock_bh(&cmd->r2t_lock);
> > +	list_for_each_entry_safe(r2t, r2t_tmp,&cmd->cmd_r2t_list, r2t_list) {
> > +		list_del(&r2t->r2t_list);
> > +		kmem_cache_free(lio_r2t_cache, r2t);
> 
> I think that is iscsit_free_r2t()
> 

Fixed

> > +	}
> > +	spin_unlock_bh(&cmd->r2t_lock);
> > +}
> > +
> > +/*
> > + *	May be called from interrupt context.
> 
> 
> How does this get called from interrupt context? Is it a real interrupt 
> or a soft irq? I could not find the code path.
> 
> 
> 

This is actually software interrupt context usage from the NopIN timer
to queue up iscsi_cmd from iscsit_add_nopin()

Adding a comment here..

> 
> 
> > +
> > +struct iscsi_r2t *iscsit_get_holder_for_r2tsn(
> > +	struct iscsi_cmd *cmd,
> > +	u32 r2t_sn)
> > +{
> > +	struct iscsi_r2t *r2t;
> > +
> > +	spin_lock_bh(&cmd->r2t_lock);
> > +	list_for_each_entry(r2t,&cmd->cmd_r2t_list, r2t_list) {
> > +		if (r2t->r2t_sn == r2t_sn)
> > +			break;
> > +	}
> > +	spin_unlock_bh(&cmd->r2t_lock);
> > +
> > +	return (r2t) ? r2t : NULL;
> 
> Don't need "( ")".
> 

<nod>, fixing this to unlock and return on matching r2t or return NULL
otherwise

> 
> > +}
> > +
> > +#define SERIAL_BITS	31
> > +#define MAX_BOUND	(u32)2147483647UL
> > +
> > +static inline int serial_lt(u32 x, u32 y)
> > +{
> > +	return (x != y)&&  (((x<  y)&&  ((y - x)<  MAX_BOUND)) ||
> > +		((x>  y)&&  ((x - y)>  MAX_BOUND)));
> > +}
> > +
> > +static inline int serial_lte(u32 x, u32 y)
> > +{
> > +	return (x == y) ? 1 : serial_lt(x, y);
> > +}
> > +
> > +static inline int serial_gt(u32 x, u32 y)
> > +{
> > +	return (x != y)&&  (((x<  y)&&  ((y - x)>  MAX_BOUND)) ||
> > +		((x>  y)&&  ((x - y)<  MAX_BOUND)));
> > +}
> > +
> > +static inline int serial_gte(u32 x, u32 y)
> > +{
> > +	return (x == y) ? 1 : serial_gt(x, y);
> > +}
> 
> 
> You should merged these with libiscsi.c's iscsi_sna_* and put in 
> iscsi_proto.h.
> 
> I think this is not iscsi specific is it? It seems like it could go 
> someone more generic.
> 
> 

I think this makes sense.

Moveing libiscsi.c LT* and iscsi_target_util.c GT* usage into static
inlines in iscsi_proto.h, and dropped the internal usage here.

Will include these as a seperate iscsi patch for review.

> 
> > +void iscsit_release_cmd_direct(struct iscsi_cmd *cmd)
> > +{
> > +	iscsit_free_r2ts_from_list(cmd);
> > +	iscsit_free_all_datain_reqs(cmd);
> > +
> > +	kfree(cmd->buf_ptr);
> > +	kfree(cmd->pdu_list);
> > +	kfree(cmd->seq_list);
> > +	kfree(cmd->tmr_req);
> > +	kfree(cmd->iov_data);
> > +
> > +	kmem_cache_free(lio_cmd_cache, cmd);
> > +}
> > +
> > +void __iscsit_release_cmd_to_pool(struct iscsi_cmd *cmd, struct iscsi_session *sess)
> > +{
> > +	struct iscsi_conn *conn = cmd->conn;
> > +
> > +	iscsit_free_r2ts_from_list(cmd);
> > +	iscsit_free_all_datain_reqs(cmd);
> > +
> > +	kfree(cmd->buf_ptr);
> > +	kfree(cmd->pdu_list);
> > +	kfree(cmd->seq_list);
> > +	kfree(cmd->tmr_req);
> > +	kfree(cmd->iov_data);
> > +
> > +	if (conn) {
> > +		iscsit_remove_cmd_from_immediate_queue(cmd, conn);
> > +		iscsit_remove_cmd_from_response_queue(cmd, conn);
> > +	}
> > +
> > +	kmem_cache_free(lio_cmd_cache, cmd);
> > +}
> 
> sess is not used and I could not figure the _to_pool part of the name.
> 

The '_to_pool' is some left over cruft that still exists in
include/target/target_core_fabric_ops.h that needs to be fixed up in
target core as a seperate item and merged into a single
TFO->release_cmd().

> This is not some sort of mistake, right? iscsit_release_cmd_direct and 
> __iscsit_release_cmd_to_pool look alike except for the conn check 
> related code. Did you mean to merge those functions?
> 
> 

<nod>, now dropping iscsit_release_cmd_direct() and
iscsit_release_cmd_to_pool() usage for single iscsit_release_cmd() call.

> 
> > +
> > +void iscsit_release_cmd_to_pool(struct iscsi_cmd *cmd)
> > +{
> > +	if (!cmd->conn&&  !cmd->sess) {
> > +		iscsit_release_cmd_direct(cmd);
> > +	} else {
> > +		__iscsit_release_cmd_to_pool(cmd, (cmd->conn) ?
> > +			cmd->conn->sess : cmd->sess);
> > +	}
> > +}
> > +
> > +/*
> > + *	Routine to pack an ordinary (LINUX) LUN 32-bit number
> > + *		into an 8-byte LUN structure
> > + *	(see SAM-2, Section 4.12.3 page 39)
> > + *	Thanks to UNH for help with this :-).
> > + */
> > +inline u64 iscsit_pack_lun(unsigned int lun)
> > +{
> > +	u64	result;
> > +
> > +	result = ((lun&  0xff)<<  8);	/* LSB of lun into byte 1 big-endian */
> > +
> > +	if (0) {
> > +		/* use flat space addressing method, SAM-2 Section 4.12.4
> > +			-	high-order 2 bits of byte 0 are 01
> > +			-	low-order 6 bits of byte 0 are MSB of the lun
> > +			-	all 8 bits of byte 1 are LSB of the lun
> > +			-	all other bytes (2 thru 7) are 0
> > +		 */
> > +		result |= 0x40 | ((lun>>  8)&  0x3f);
> > +	}
> > +	/* else use peripheral device addressing method, Sam-2 Section 4.12.5
> > +			-	high-order 2 bits of byte 0 are 00
> > +			-	low-order 6 bits of byte 0 are all 0
> > +			-	all 8 bits of byte 1 are the lun
> > +			-	all other bytes (2 thru 7) are 0
> > +	*/
> > +
> > +	return cpu_to_le64(result);
> > +}
> 
> Is this int_to_scsilun?
> 
> 

Hmmm, this is actually still by target_core_fabric_ops->pack_lun()
for target_core_device.c:transport_core_report_lun_response().
Converted this in iscsi_target_mod and will provide a seperate patch for
target core to use int_to_scsilun() for REPORT_LUNs, and will remove the
the ->pack_lun() vector for mainline target in a seperate follow-up
patch.

> > +
> > +/*
> > + *	Routine to pack an 8-byte LUN structure into a ordinary (LINUX) 32-bit
> > + *	LUN number (see SAM-2, Section 4.12.3 page 39)
> > + *	Thanks to UNH for help with this :-).
> > + */
> > +inline u32 iscsit_unpack_lun(unsigned char *lun_ptr)
> > +{
> > +	u32	result, temp;
> > +
> > +	result = *(lun_ptr+1);  /* LSB of lun from byte 1 big-endian */
> > +
> > +	switch (temp = ((*lun_ptr)>>6)) { /* high 2 bits of byte 0 big-endian */
> > +	case 0: /* peripheral device addressing method, Sam-2 Section 4.12.5
> > +		-	high-order 2 bits of byte 0 are 00
> > +		-	low-order 6 bits of byte 0 are all 0
> > +		-	all 8 bits of byte 1 are the lun
> > +		-	all other bytes (2 thru 7) are 0
> > +		 */
> > +		if (*lun_ptr != 0) {
> > +			printk(KERN_ERR "Illegal Byte 0 in LUN peripheral"
> > +				" device addressing method %u, expected 0\n",
> > +				*lun_ptr);
> > +		}
> > +		break;
> > +	case 1: /* flat space addressing method, SAM-2 Section 4.12.4
> > +		-	high-order 2 bits of byte 0 are 01
> > +		-	low-order 6 bits of byte 0 are MSB of the lun
> > +		-	all 8 bits of byte 1 are LSB of the lun
> > +		-	all other bytes (2 thru 7) are 0
> > +		 */
> > +		result += ((*lun_ptr)&  0x3f)<<  8;
> > +		break;
> > +	default: /* (extended) logical unit addressing */
> > +		printk(KERN_ERR "Unimplemented LUN addressing method %u, "
> > +			"PDA method used instead\n", temp);
> > +		break;
> > +	}
> > +
> > +	return result;
> > +}
> 
> 
> scsilun_to_int?
> 
> 
> 

Converted all iscsi_unpack_lun() usage to scsilun_to_int().

> 
> 
> > +
> > +int iscsit_check_session_usage_count(struct iscsi_session *sess)
> > +{
> > +	spin_lock_bh(&sess->session_usage_lock);
> > +	if (atomic_read(&sess->session_usage_count)) {
> > +		atomic_set(&sess->session_waiting_on_uc, 1);
> > +		spin_unlock_bh(&sess->session_usage_lock);
> > +		if (in_interrupt())
> > +			return 2;
> > +
> > +		wait_for_completion(&sess->session_waiting_on_uc_comp);
> > +		return 1;
> > +	}
> > +	spin_unlock_bh(&sess->session_usage_lock);
> > +
> > +	return 0;
> > +}
> > +
> > +void iscsit_dec_session_usage_count(struct iscsi_session *sess)
> > +{
> > +	spin_lock_bh(&sess->session_usage_lock);
> > +	atomic_dec(&sess->session_usage_count);
> > +
> > +	if (!atomic_read(&sess->session_usage_count)&&
> > +	     atomic_read(&sess->session_waiting_on_uc))
> > +		complete(&sess->session_waiting_on_uc_comp);
> > +
> > +	spin_unlock_bh(&sess->session_usage_lock);
> > +}
> > +
> > +void iscsit_inc_session_usage_count(struct iscsi_session *sess)
> > +{
> > +	spin_lock_bh(&sess->session_usage_lock);
> > +	atomic_inc(&sess->session_usage_count);
> > +	spin_unlock_bh(&sess->session_usage_lock);
> > +}
> 
> 
> 
> It seems strange for the session_usage_count and waiting_on_uc to be 
> atomic and accessed under the spin lock. I think you normally do one or 
> the other.
> 
> 

OK, converted sess->session_usage_count to use int instead of atomic_t.

> 
> > +
> > +unsigned char *iscsit_ntoa(u32 ip)
> > +{
> > +	static unsigned char buf[18];
> > +
> > +	memset(buf, 0, 18);
> > +	sprintf(buf, "%u.%u.%u.%u", ((ip>>  24)&  0xff), ((ip>>  16)&  0xff),
> > +			((ip>>  8)&  0xff), (ip&  0xff));
> > +
> > +	return buf;
> > +}
> 
> Nothing is using this. Remove.
> 
> 

Removed

> > +
> > +void iscsit_ntoa2(unsigned char *buf, u32 ip)
> > +{
> > +	memset(buf, 0, 18);
> > +	sprintf(buf, "%u.%u.%u.%u", ((ip>>  24)&  0xff), ((ip>>  16)&  0xff),
> > +			((ip>>  8)&  0xff), (ip&  0xff));
> > +}
> 
> I think we have a function like this already.
> 
>
> If not, I think this should be:
> 
> sprintf(buf, "%pI4",
> 
> What s up with ipv6 btw? That uses %pI6.
> 

Mmm, looking at include/linux/inet.h, I don't see a equivilent for the
iscsit_ntoa2() above AFAICT..

> 
> > +
> > +#define NS_INT16SZ	 2
> > +#define NS_INADDRSZ	 4
> > +#define NS_IN6ADDRSZ	16
> > +
> > +/* const char *
> > + * inet_ntop4(src, dst, size)
> > + *	format an IPv4 address
> > + * return:
> > + *	`dst' (as a const)
> > + * notes:
> > + *	(1) uses no statics
> > + *	(2) takes a unsigned char* not an in_addr as input
> > + * author:
> > + *	Paul Vixie, 1996.
> > + */
> > +static const char *iscsit_ntop4(
> 
> 
> Only used by iscsit_ntop6
> 

Dropped

> 
> > +/* const char *
> > + * isc_inet_ntop6(src, dst, size)
> > + * convert IPv6 binary address into presentation (printable) format
> > + * author:
> > + *	Paul Vixie, 1996.
> > + */
> > +const char *iscsit_ntop6(const unsigned char *src, char *dst, size_t size)
> > +{
> 
> 
> Not used.
> 
> 

Dropped

> > +
> > +/* int
> > + * inet_pton4(src, dst)
> > + *	like inet_aton() but without all the hexadecimal and shorthand.
> > + * return:
> > + *	1 if `src' is a valid dotted quad, else 0.
> > + * notice:
> > + *	does not touch `dst' unless it's returning 1.
> > + * author:
> > + *	Paul Vixie, 1996.
> > + */
> > +static int iscsit_pton4(const char *src, unsigned char *dst)
> > +{
> 
> 
> 
> Only used by inet_pton6
> 

Dropped

> > +
> > +/* int
> > + * inet_pton6(src, dst)
> > + *	convert presentation level address to network order binary form.
> > + * return:
> > + *	1 if `src' is a valid [RFC1884 2.2] address, else 0.
> > + * notice:
> > + *	(1) does not touch `dst' unless it's returning 1.
> > + *	(2) :: in a full address is silently ignored.
> > + * credit:
> > + *	inspired by Mark Andrews.
> > + * author:
> > + *	Paul Vixie, 1996.
> > + */
> > +int iscsit_pton6(const char *src, unsigned char *dst)
> > +{
> > +	static const char xdigits_l[] = "0123456789abcdef",
> 
> 
> 
> Not used.
> 

Dropped.

> I think if you needed these functions then they should go into some 
> network code. There were not specific to a iscsi target were they.
> 
> 

Ok, the only one that I cannot find an externally accessable equivilent
is iscsit_ntoa2(), which I will go ahead and drop..

> 
> > +
> > +	return NULL;
> > +}
> > +
> > +void iscsit_check_conn_usage_count(struct iscsi_conn *conn)
> > +{
> > +	spin_lock_bh(&conn->conn_usage_lock);
> > +	if (atomic_read(&conn->conn_usage_count)) {
> > +		atomic_set(&conn->conn_waiting_on_uc, 1);
> > +		spin_unlock_bh(&conn->conn_usage_lock);
> > +
> > +		wait_for_completion(&conn->conn_waiting_on_uc_comp);
> > +		return;
> > +	}
> > +	spin_unlock_bh(&conn->conn_usage_lock);
> > +}
> > +
> > +void iscsit_dec_conn_usage_count(struct iscsi_conn *conn)
> > +{
> > +	spin_lock_bh(&conn->conn_usage_lock);
> > +	atomic_dec(&conn->conn_usage_count);
> > +
> > +	if (!atomic_read(&conn->conn_usage_count)&&
> > +	     atomic_read(&conn->conn_waiting_on_uc))
> > +		complete(&conn->conn_waiting_on_uc_comp);
> > +
> > +	spin_unlock_bh(&conn->conn_usage_lock);
> > +}
> > +
> > +void iscsit_inc_conn_usage_count(struct iscsi_conn *conn)
> > +{
> > +	spin_lock_bh(&conn->conn_usage_lock);
> > +	atomic_inc(&conn->conn_usage_count);
> > +	spin_unlock_bh(&conn->conn_usage_lock);
> > +}
> 
> Something about atomics and always being accessed under a lock. I think 
> this happens in other places too.
> 
> Could this also be done with krefs?

Converted these as well to int for current code.  Btw, I am happy to
take a patch converting these to krefs.  :)

> 
> > +
> > +int iscsit_check_for_active_network_device(struct iscsi_conn *conn)
> > +{
> > +	struct net_device *net_dev;
> > +
> > +	if (!conn->net_if) {
> > +		printk(KERN_ERR "struct iscsi_conn->net_if is NULL for CID:"
> > +			" %hu\n", conn->cid);
> > +		return 0;
> > +	}
> > +	net_dev = conn->net_if;
> > +
> > +	return netif_carrier_ok(net_dev);
> > +}
> > +
> > +static void iscsit_handle_netif_timeout(unsigned long data)
> > +{
> > +	struct iscsi_conn *conn = (struct iscsi_conn *) data;
> > +
> > +	iscsit_inc_conn_usage_count(conn);
> > +
> > +	spin_lock_bh(&conn->netif_lock);
> > +	if (conn->netif_timer_flags&  ISCSI_TF_STOP) {
> > +		spin_unlock_bh(&conn->netif_lock);
> > +		iscsit_dec_conn_usage_count(conn);
> > +		return;
> > +	}
> > +	conn->netif_timer_flags&= ~ISCSI_TF_RUNNING;
> > +
> > +	if (iscsit_check_for_active_network_device((void *)conn)) {
> > +		iscsit_start_netif_timer(conn);
> > +		spin_unlock_bh(&conn->netif_lock);
> > +		iscsit_dec_conn_usage_count(conn);
> > +		return;
> > +	}
> > +
> > +	printk(KERN_ERR "Detected PHY loss on Network Interface: %s for iSCSI"
> > +		" CID: %hu on SID: %u\n", conn->net_dev, conn->cid,
> > +			conn->sess->sid);
> > +
> > +	spin_unlock_bh(&conn->netif_lock);
> > +
> > +	iscsit_cause_connection_reinstatement(conn, 0);
> > +	iscsit_dec_conn_usage_count(conn);
> > +}
> 
> 
> I think instead of polling the device you can use 
> register_netdevice_notifier. See fcoe.c for an example.
> 
> 

Hmmm, this netif struct net_device timeout code to trigger connection
reinstatement that is disabled in iscsi_target_login.c:
iscsi_post_login_start_timers() because of not having an (easy) mainline
method of locating the underlying struct net_device (or at least AFAICT)
from a kernel-level struct socket.  So with the original code this was
intended to be set by a userspace provided ethX string.

That said, I will go ahead and drop this code for the initial merge.
Once we figure out a proper way to obtain struct net_device from
a struct socket I will re-add this via a register_netdevice_notifier()
callback for the case to trigger an iSCSI connection failure from a
struct net_device state failure for something like a physical link layer
loss.

> 
> > +
> > +static inline int iscsit_do_rx_data(
> > +	struct iscsi_conn *conn,
> > +	struct iscsi_data_count *count)
> > +{
> 
> 
> 
> > +
> > +	while (total_rx<  data) {
> > +		oldfs = get_fs();
> > +		set_fs(get_ds());
> > +
> > +		conn->sock->sk->sk_allocation = GFP_ATOMIC;
> 
> 
> I do not think you need GFP_ATOMIC. If you cannot sleep then I think you 
> are in trouble below, because you pass in MSG_WAITALL.
> 
> I think since this is the target side you can use GFP_KERNEL. Target 
> mode should not have the same allocation swinging around on you 
> dependency problem like a initiator does, does it?
> 
> If it does at least use GFP_NOIO (I think iscsi_tcp.c should be using 
> GFP_NOIO and not GFP_ATOMIC).
> 

Ok, removing sk_allocation = GFP_ATOMIC for both cases..

> And I think we are supposed to be using kernel_recvmsg. It does the 
> get/set_ds stuff for you.
> 
> 

Converted to use kernel_recvmsg() here, and also converted all struct
iovec usage in iscsi_target_mod to struct kvec.

> > +		rx_loop = sock_recvmsg(conn->sock,&msg,
> > +				(data - total_rx), MSG_WAITALL);
> > +
> 
> 
> 
> 
> > +static inline int iscsit_do_tx_data(
> > +	struct iscsi_conn *conn,
> > +	struct iscsi_data_count *count)
> > +{
> 
> 
> 
> > +
> > +	while (total_tx<  data) {
> > +		oldfs = get_fs();
> > +		set_fs(get_ds());
> > +
> > +		conn->sock->sk->sk_allocation = GFP_ATOMIC;
> 
> Same comment as the recv side. I think you can also move this and set it 
> in one place.
> 
> And I think we are supposed to be using kernel_sendmsg. That will also 
> do the get/set_fs stuff for you.
> 
> 

Dropped GFP_ATOMIC and converted to kernel_sendmsg()..

> > +		tx_loop = sock_sendmsg(conn->sock,&msg, (data - total_tx));
> > +
> > +		set_fs(oldfs);
> > +
> 
>
> 
> > +extern int iscsit_build_sendtargets_response(struct iscsi_cmd *cmd)
> > +{
> > +	char *ip, *payload = NULL;
> > +	struct iscsi_conn *conn = cmd->conn;
> > +	struct iscsi_portal_group *tpg;
> > +	struct iscsi_tiqn *tiqn;
> > +	struct iscsi_tpg_np *tpg_np;
> > +	int buffer_len, end_of_buf = 0, len = 0, payload_len = 0;
> > +	unsigned char buf[256];
> > +	unsigned char buf_ipv4[IPV4_BUF_SIZE];
> > +
> > +	buffer_len = (conn->conn_ops->MaxRecvDataSegmentLength>  32768) ?
> > +			32768 : conn->conn_ops->MaxRecvDataSegmentLength;
> > +
> > +	payload = kzalloc(buffer_len, GFP_KERNEL);
> > +	if (!payload) {
> > +		printk(KERN_ERR "Unable to allocate memory for sendtargets"
> > +			" response.\n");
> > +		return -1;
> > +	}
> > +
> > +	spin_lock(&tiqn_lock);
> > +	list_for_each_entry(tiqn,&g_tiqn_list, tiqn_list) {
> > +		memset(buf, 0, 256);
> > +
> > +		len = sprintf(buf, "TargetName=%s", tiqn->tiqn);
> > +		len += 1;
> > +
> > +		if ((len + payload_len)>  buffer_len) {
> > +			spin_unlock(&tiqn->tiqn_tpg_lock);
> > +			end_of_buf = 1;
> > +			goto eob;
> > +		}
> > +		memcpy((void *)payload + payload_len, buf, len);
> > +		payload_len += len;
> > +
> > +		spin_lock(&tiqn->tiqn_tpg_lock);
> > +		list_for_each_entry(tpg,&tiqn->tiqn_tpg_list, tpg_list) {
> > +
> > +			spin_lock(&tpg->tpg_state_lock);
> > +			if ((tpg->tpg_state == TPG_STATE_FREE) ||
> > +			    (tpg->tpg_state == TPG_STATE_INACTIVE)) {
> > +				spin_unlock(&tpg->tpg_state_lock);
> > +				continue;
> > +			}
> > +			spin_unlock(&tpg->tpg_state_lock);
> > +
> > +			spin_lock(&tpg->tpg_np_lock);
> > +			list_for_each_entry(tpg_np,&tpg->tpg_gnp_list,
> > +					tpg_np_list) {
> > +				memset(buf, 0, 256);
> > +
> > +				if (tpg_np->tpg_np->np_sockaddr.ss_family == AF_INET6) {
> > +					ip =&tpg_np->tpg_np->np_ipv6[0];
> 
> 
> Is ip supposed to be a string with the ip address in it? If so is that 
> right? Is np_ipv6 a string with the ip address in human readable format, 
> but below np_ipv4 is the integer representation then you convert it.
> 
> 

Mmm, I see your point here.  Getting this converted to use a single
np->np_ip[] string, and will do the aton conversition and drop
iscsit_ntoa2() instead.

> > +				} else {
> > +					memset(buf_ipv4, 0, IPV4_BUF_SIZE);
> > +					iscsit_ntoa2(buf_ipv4,
> > +						tpg_np->tpg_np->np_ipv4);
> > +					ip =&buf_ipv4[0];
> > +				}
> > +
> > +				len = sprintf(buf, "TargetAddress="
> > +					"%s%s%s:%hu,%hu",
> > +					(tpg_np->tpg_np->np_sockaddr.ss_family == AF_INET6) ?
> > +					"[" : "", ip,
> > +					(tpg_np->tpg_np->np_sockaddr.ss_family == AF_INET6) ?
> > +					"]" : "", tpg_np->tpg_np->np_port,
> > +					tpg->tpgt);
> > +				len += 1;
> > +
> > +				if ((len + payload_len)>  buffer_len) {
> > +					spin_unlock(&tpg->tpg_np_lock);
> > +					spin_unlock(&tiqn->tiqn_tpg_lock);
> > +					end_of_buf = 1;
> > +					goto eob;
> > +				}
> > +
> > +				memcpy((void *)payload + payload_len, buf, len);
> > +				payload_len += len;
> > +			}
> > +			spin_unlock(&tpg->tpg_np_lock);
> > +		}
> > +		spin_unlock(&tiqn->tiqn_tpg_lock);
> > +eob:
> > +		if (end_of_buf)
> > +			break;
> > +	}
> > +	spin_unlock(&tiqn_lock);
> > +
> > +	cmd->buf_ptr = payload;
> --

I finishing up the last items now, and will create a PATCH-v2 containing
the above changes and seperate patchs for generic iscsi_sna() functions
in iscsi_proto.h, and the conversion of target_core_mod to use
int_to_scsilun() instead of a TFO->pack_lun() vector.

Thank you for your review Mike!

--nab

