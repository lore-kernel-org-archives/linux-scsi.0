Return-Path: <SRS0=Oq5V=65=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 940B3C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 00:11:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51C942065C
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 00:11:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GZDDtwyx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbgEOALf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 May 2020 20:11:35 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:57666 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgEOALe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 May 2020 20:11:34 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04ENuhMD051955;
        Fri, 15 May 2020 00:11:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=NI8fQGli4+Y4Pbhzmo1KCpUPjmCu39SpKskFOmRd1uQ=;
 b=GZDDtwyxoEklHI9U+KvPRq1UHReh/P5EicjyXTjv6WqvlGgTXJETVCoe1C6Ome2NZ+SC
 enwwRmLT3yyVeIoNxFPv2WGAqLJ2pmTrSFQ3dQesaEkzj7001uk4fUsfmr0J/CFCtOuw
 vsCXuZDbrHyq+qbYuXWZ2AIcy5G562q+TaOKHsQyWKciAO0ur/ZiWmZPhM8+DENpgD8n
 cRDDK1a9GgBE3OIw0DxBjrUDykyGrvQqU+ex9pLWMdW70ip+GM9CNCNXYYbtLqIW7sV9
 waNV73V63YDb73EWgMSJ9GW8Ym5MSdO8MYRnSewvuIoqtx9wINfr1NM/1m3PnIkIyixI kg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3100yg5t4y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 15 May 2020 00:11:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04ENwirE021632;
        Fri, 15 May 2020 00:11:22 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 310vjuahpp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 May 2020 00:11:21 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04F0BJW0026235;
        Fri, 15 May 2020 00:11:20 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 May 2020 17:11:19 -0700
To:     lduncan@suse.com, cleech@redhat.com
Cc:     Gabriel Krisman Bertazi <krisman@collabora.com>,
        martin.petersen@oracle.com, open-iscsi@googlegroups.com,
        linux-scsi@vger.kernel.org, kernel@collabora.com,
        Khazhismel Kumykov <khazhy@google.com>
Subject: Re: [PATCH] iscsi: Fix deadlock on recovery path during GFP_IO reclaim
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200508055954.843165-1-krisman@collabora.com>
Date:   Thu, 14 May 2020 20:11:16 -0400
In-Reply-To: <20200508055954.843165-1-krisman@collabora.com> (Gabriel Krisman
        Bertazi's message of "Fri, 8 May 2020 01:59:54 -0400")
Message-ID: <yq13682t5uj.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 spamscore=0 mlxlogscore=999 malwarescore=0 suspectscore=2 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005140204
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 cotscore=-2147483648 mlxscore=0 suspectscore=2 spamscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 clxscore=1011 phishscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005140204
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Lee/Chris: Please review!

> iscsi suffers from a deadlock in case a management command submitted via
> the netlink socket sleeps on an allocation while holding the
> rx_queue_mutex, if that allocation causes a memory reclaim that
> writebacks to a failed iscsi device.  Then, the recovery procedure can
> never make progress to recover the failed disk or abort outstanding IO
> operations to complete the reclaim (since rx_queue_mutex is locked),
> thus locking the system.
>
> Nevertheless, just marking all allocations under rx_queue_mutex as
> GFP_NOIO (or locking the userspace process with something like
> PF_MEMALLOC_NOIO) is not enough, since the iscsi command code relies on
> other subsystems that try to grab locked mutexes, whose threads are
> GFP_IO, leading to the same deadlock. One instance where this situation
> can be observed is in the backtraces below, stitched from multiple bugs
> reports, involving the kobj uevent sent when a session is created.
>
> The root of the problem is not the fact that iscsi does GFP_IO
> allocations, that is acceptable. The actual problem is that
> rx_queue_mutex has a very large granularity, covering every unrelated
> netlink command execution at the same time as the error recovery path.
>
> The proposed fix leverages the recently added mechanism to stop failed
> connections from the kernel, by enabling it to execute even though a
> management command from the netlink socket is being run (rx_queue_mutex
> is held), provided that the command is known to be safe.  It splits the
> rx_queue_mutex in two mutexes, one protecting from concurrent command
> execution from the netlink socket, and one protecting stop_conn from
> racing with other connection management operations that might conflict
> with it.
>
> It is not very pretty, but it is the simplest way to resolve the
> deadlock.  I considered making it a lock per connection, but some
> external mutex would still be needed to deal with iscsi_if_destroy_conn.
>
> The patch was tested by forcing a memory shrinker (unrelated, but used
> bufio/dm-verity) to reclaim ISCSI pages every time
> ISCSI_UEVENT_CREATE_SESSION happens, which is reasonable to simulate
> reclaims that might happen with GFP_KERNEL on that path.  Then, a faulty
> hung target causes a connection to fail during intensive IO, at the same
> time a new session is added by iscsid.
>
> The following stacktraces are stiches from several bug reports, showing
> a case where the deadlock can happen.
>
>  iSCSI-write
>          holding: rx_queue_mutex
>          waiting: uevent_sock_mutex
>
>          kobject_uevent_env+0x1bd/0x419
>          kobject_uevent+0xb/0xd
>          device_add+0x48a/0x678
>          scsi_add_host_with_dma+0xc5/0x22d
>          iscsi_host_add+0x53/0x55
>          iscsi_sw_tcp_session_create+0xa6/0x129
>          iscsi_if_rx+0x100/0x1247
>          netlink_unicast+0x213/0x4f0
>          netlink_sendmsg+0x230/0x3c0
>
>  iscsi_fail iscsi_conn_failure
>          waiting: rx_queue_mutex
>
>          schedule_preempt_disabled+0x325/0x734
>          __mutex_lock_slowpath+0x18b/0x230
>          mutex_lock+0x22/0x40
>          iscsi_conn_failure+0x42/0x149
>          worker_thread+0x24a/0xbc0
>
>  EventManager_
>          holding: uevent_sock_mutex
>          waiting: dm_bufio_client->lock
>
>          dm_bufio_lock+0xe/0x10
>          shrink+0x34/0xf7
>          shrink_slab+0x177/0x5d0
>          do_try_to_free_pages+0x129/0x470
>          try_to_free_mem_cgroup_pages+0x14f/0x210
>          memcg_kmem_newpage_charge+0xa6d/0x13b0
>          __alloc_pages_nodemask+0x4a3/0x1a70
>          fallback_alloc+0x1b2/0x36c
>          __kmalloc_node_track_caller+0xb9/0x10d0
>          __alloc_skb+0x83/0x2f0
>          kobject_uevent_env+0x26b/0x419
>          dm_kobject_uevent+0x70/0x79
>          dev_suspend+0x1a9/0x1e7
>          ctl_ioctl+0x3e9/0x411
>          dm_ctl_ioctl+0x13/0x17
>          do_vfs_ioctl+0xb3/0x460
>          SyS_ioctl+0x5e/0x90
>
>  MemcgReclaimerD"
>          holding: dm_bufio_client->lock
>          waiting: stuck io to finish (needs iscsi_fail thread to progress)
>
>          schedule at ffffffffbd603618
>          io_schedule at ffffffffbd603ba4
>          do_io_schedule at ffffffffbdaf0d94
>          __wait_on_bit at ffffffffbd6008a6
>          out_of_line_wait_on_bit at ffffffffbd600960
>          wait_on_bit.constprop.10 at ffffffffbdaf0f17
>          __make_buffer_clean at ffffffffbdaf18ba
>          __cleanup_old_buffer at ffffffffbdaf192f
>          shrink at ffffffffbdaf19fd
>          do_shrink_slab at ffffffffbd6ec000
>          shrink_slab at ffffffffbd6ec24a
>          do_try_to_free_pages at ffffffffbd6eda09
>          try_to_free_mem_cgroup_pages at ffffffffbd6ede7e
>          mem_cgroup_resize_limit at ffffffffbd7024c0
>          mem_cgroup_write at ffffffffbd703149
>          cgroup_file_write at ffffffffbd6d9c6e
>          sys_write at ffffffffbd6662ea
>          system_call_fastpath at ffffffffbdbc34a2
>
> Reported-by: Khazhismel Kumykov <khazhy@google.com>
> Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
> ---
>  drivers/scsi/scsi_transport_iscsi.c | 67 +++++++++++++++++++++--------
>  1 file changed, 49 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index 17a45716a0fe..d99c17306dff 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -1616,6 +1616,12 @@ static DECLARE_TRANSPORT_CLASS(iscsi_connection_class,
>  static struct sock *nls;
>  static DEFINE_MUTEX(rx_queue_mutex);
>  
> +/*
> + * conn_mutex protects the {start,bind,stop,destroy}_conn from racing
> + * against the kernel stop_connection recovery mechanism
> + */
> +static DEFINE_MUTEX(conn_mutex);
> +
>  static LIST_HEAD(sesslist);
>  static LIST_HEAD(sessdestroylist);
>  static DEFINE_SPINLOCK(sesslock);
> @@ -2442,6 +2448,32 @@ int iscsi_offload_mesg(struct Scsi_Host *shost,
>  }
>  EXPORT_SYMBOL_GPL(iscsi_offload_mesg);
>  
> +/*
> + * This can be called without the rx_queue_mutex, if invoked by the kernel
> + * stop work. But, in that case, it is guaranteed not to race with
> + * iscsi_destroy by conn_mutex.
> + */
> +static void iscsi_if_stop_conn(struct iscsi_cls_conn *conn, int flag)
> +{
> +	/*
> +	 * It is important that this path doesn't rely on
> +	 * rx_queue_mutex, otherwise, a thread doing allocation on a
> +	 * start_session/start_connection could sleep waiting on a
> +	 * writeback to a failed iscsi device, that cannot be recovered
> +	 * because the lock is held.  If we don't hold it here, the
> +	 * kernel stop_conn_work_fn has a chance to stop the broken
> +	 * session and resolve the allocation.
> +	 *
> +	 * Still, the user invoked .stop_conn() needs to be serialized
> +	 * with stop_conn_work_fn by a private mutex.  Not pretty, but
> +	 * it works.
> +	 */
> +	mutex_lock(&conn_mutex);
> +	conn->transport->stop_conn(conn, flag);
> +	mutex_unlock(&conn_mutex);
> +
> +}
> +
>  static void stop_conn_work_fn(struct work_struct *work)
>  {
>  	struct iscsi_cls_conn *conn, *tmp;
> @@ -2460,30 +2492,17 @@ static void stop_conn_work_fn(struct work_struct *work)
>  		uint32_t sid = iscsi_conn_get_sid(conn);
>  		struct iscsi_cls_session *session;
>  
> -		mutex_lock(&rx_queue_mutex);
> -
>  		session = iscsi_session_lookup(sid);
>  		if (session) {
>  			if (system_state != SYSTEM_RUNNING) {
>  				session->recovery_tmo = 0;
> -				conn->transport->stop_conn(conn,
> -							   STOP_CONN_TERM);
> +				iscsi_if_stop_conn(conn, STOP_CONN_TERM);
>  			} else {
> -				conn->transport->stop_conn(conn,
> -							   STOP_CONN_RECOVER);
> +				iscsi_if_stop_conn(conn, STOP_CONN_RECOVER);
>  			}
>  		}
>  
>  		list_del_init(&conn->conn_list_err);
> -
> -		mutex_unlock(&rx_queue_mutex);
> -
> -		/* we don't want to hold rx_queue_mutex for too long,
> -		 * for instance if many conns failed at the same time,
> -		 * since this stall other iscsi maintenance operations.
> -		 * Give other users a chance to proceed.
> -		 */
> -		cond_resched();
>  	}
>  }
>  
> @@ -2843,8 +2862,11 @@ iscsi_if_destroy_conn(struct iscsi_transport *transport, struct iscsi_uevent *ev
>  	spin_unlock_irqrestore(&connlock, flags);
>  
>  	ISCSI_DBG_TRANS_CONN(conn, "Destroying transport conn\n");
> +
> +	mutex_lock(&conn_mutex);
>  	if (transport->destroy_conn)
>  		transport->destroy_conn(conn);
> +	mutex_unlock(&conn_mutex);
>  
>  	return 0;
>  }
> @@ -3686,9 +3708,12 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
>  			break;
>  		}
>  
> +		mutex_lock(&conn_mutex);
>  		ev->r.retcode =	transport->bind_conn(session, conn,
>  						ev->u.b_conn.transport_eph,
>  						ev->u.b_conn.is_leading);
> +		mutex_unlock(&conn_mutex);
> +
>  		if (ev->r.retcode || !transport->ep_connect)
>  			break;
>  
> @@ -3709,25 +3734,31 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
>  		break;
>  	case ISCSI_UEVENT_START_CONN:
>  		conn = iscsi_conn_lookup(ev->u.start_conn.sid, ev->u.start_conn.cid);
> -		if (conn)
> +		if (conn) {
> +			mutex_lock(&conn_mutex);
>  			ev->r.retcode = transport->start_conn(conn);
> +			mutex_unlock(&conn_mutex);
> +		}
>  		else
>  			err = -EINVAL;
>  		break;
>  	case ISCSI_UEVENT_STOP_CONN:
>  		conn = iscsi_conn_lookup(ev->u.stop_conn.sid, ev->u.stop_conn.cid);
>  		if (conn)
> -			transport->stop_conn(conn, ev->u.stop_conn.flag);
> +			iscsi_if_stop_conn(conn, ev->u.stop_conn.flag);
>  		else
>  			err = -EINVAL;
>  		break;
>  	case ISCSI_UEVENT_SEND_PDU:
>  		conn = iscsi_conn_lookup(ev->u.send_pdu.sid, ev->u.send_pdu.cid);
> -		if (conn)
> +		if (conn) {
> +			mutex_lock(&conn_mutex);
>  			ev->r.retcode =	transport->send_pdu(conn,
>  				(struct iscsi_hdr*)((char*)ev + sizeof(*ev)),
>  				(char*)ev + sizeof(*ev) + ev->u.send_pdu.hdr_size,
>  				ev->u.send_pdu.data_size);
> +			mutex_unlock(&conn_mutex);
> +		}
>  		else
>  			err = -EINVAL;
>  		break;

-- 
Martin K. Petersen	Oracle Linux Engineering
