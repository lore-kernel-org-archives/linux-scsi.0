Return-Path: <SRS0=nml+=3C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81BD6C33CA9
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jan 2020 22:36:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57637206DA
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jan 2020 22:36:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728746AbgAMWgh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jan 2020 17:36:37 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:52716 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728714AbgAMWgh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jan 2020 17:36:37 -0500
Received: from localhost (unknown [IPv6:2610:98:8005::27])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: krisman)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 3F6852912D6;
        Mon, 13 Jan 2020 22:36:34 +0000 (GMT)
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     lduncan@suse.com
Cc:     cleech@redhat.com, martin.petersen@oracle.com,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        kernel@collabora.com
Subject: Re: [PATCH RESEND] iscsi: Don't destroy session if there are outstanding connections
In-Reply-To: <20191226203148.2172200-1-krisman@collabora.com> (Gabriel Krisman
        Bertazi's message of "Thu, 26 Dec 2019 15:31:48 -0500")
Organization: Collabora
References: <20191226203148.2172200-1-krisman@collabora.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Date:   Mon, 13 Jan 2020 17:36:31 -0500
Message-ID: <85ftgjt24w.fsf@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Gabriel Krisman Bertazi <krisman@collabora.com> writes:

> From: Nick Black <nlb@google.com>
>
> Hi,
>
> I thought this was already committed for some reason, until it bit me
> again today.  Any opposition to this one?

Hi,

Pinging this patch.  Any oposion?

>>8
>
> A faulty userspace that calls destroy_session() before destroying the
> connections can trigger the failure.  This patch prevents the
> issue by refusing to destroy the session if there are outstanding
> connections.
>
> ------------[ cut here ]------------
> kernel BUG at mm/slub.c:306!
> invalid opcode: 0000 [#1] SMP PTI
> CPU: 1 PID: 1224 Comm: iscsid Not tainted 5.4.0-rc2.iscsi+ #7
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
> RIP: 0010:__slab_free+0x181/0x350
> [...]
> [ 1209.686056] RSP: 0018:ffffa93d4074fae0 EFLAGS: 00010246
> [ 1209.686694] RAX: ffff934efa5ad800 RBX: 000000008010000a RCX: ffff934efa5ad800
> [ 1209.687651] RDX: ffff934efa5ad800 RSI: ffffeb4041e96b00 RDI: ffff934efd402c40
> [ 1209.688582] RBP: ffffa93d4074fb80 R08: 0000000000000001 R09: ffffffffbb5dfa26
> [ 1209.689425] R10: ffff934efa5ad800 R11: 0000000000000001 R12: ffffeb4041e96b00
> [ 1209.690285] R13: ffff934efa5ad800 R14: ffff934efd402c40 R15: 0000000000000000
> [ 1209.691213] FS:  00007f7945dfb540(0000) GS:ffff934efda80000(0000) knlGS:0000000000000000
> [ 1209.692316] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1209.693013] CR2: 000055877fd3da80 CR3: 0000000077384000 CR4: 00000000000006e0
> [ 1209.693897] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 1209.694773] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [ 1209.695631] Call Trace:
> [ 1209.695957]  ? __wake_up_common_lock+0x8a/0xc0
> [ 1209.696712]  iscsi_pool_free+0x26/0x40
> [ 1209.697263]  iscsi_session_teardown+0x2f/0xf0
> [ 1209.698117]  iscsi_sw_tcp_session_destroy+0x45/0x60
> [ 1209.698831]  iscsi_if_rx+0xd88/0x14e0
> [ 1209.699370]  netlink_unicast+0x16f/0x200
> [ 1209.699932]  netlink_sendmsg+0x21a/0x3e0
> [ 1209.700446]  sock_sendmsg+0x4f/0x60
> [ 1209.700902]  ___sys_sendmsg+0x2ae/0x320
> [ 1209.701451]  ? cp_new_stat+0x150/0x180
> [ 1209.701922]  __sys_sendmsg+0x59/0xa0
> [ 1209.702357]  do_syscall_64+0x52/0x160
> [ 1209.702812]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [ 1209.703419] RIP: 0033:0x7f7946433914
> [...]
> [ 1209.706084] RSP: 002b:00007fffb99f2378 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> [ 1209.706994] RAX: ffffffffffffffda RBX: 000055bc869eac20 RCX: 00007f7946433914
> [ 1209.708082] RDX: 0000000000000000 RSI: 00007fffb99f2390 RDI: 0000000000000005
> [ 1209.709120] RBP: 00007fffb99f2390 R08: 000055bc84fe9320 R09: 00007fffb99f1f07
> [ 1209.710110] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000038
> [ 1209.711085] R13: 000055bc8502306e R14: 0000000000000000 R15: 0000000000000000
>  Modules linked in:
>  ---[ end trace a2d933ede7f730d8 ]---
>
> Co-developed-by: Salman Qazi <sqazi@google.com>
> Signed-off-by: Salman Qazi <sqazi@google.com>
> Co-developed-by: Junho Ryu <jayr@google.com>
> Signed-off-by: Junho Ryu <jayr@google.com>
> Co-developed-by: Khazhismel Kumykov <khazhy@google.com>
> Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
> Signed-off-by: Nick Black <nlb@google.com>
> Co-developed-by: Gabriel Krisman Bertazi <krisman@collabora.com>
> Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
> ---
>  drivers/scsi/iscsi_tcp.c            |  4 ++++
>  drivers/scsi/scsi_transport_iscsi.c | 26 +++++++++++++++++++++++---
>  2 files changed, 27 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
> index 0bc63a7ab41c..b5dd1caae5e9 100644
> --- a/drivers/scsi/iscsi_tcp.c
> +++ b/drivers/scsi/iscsi_tcp.c
> @@ -887,6 +887,10 @@ iscsi_sw_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
>  static void iscsi_sw_tcp_session_destroy(struct iscsi_cls_session *cls_session)
>  {
>  	struct Scsi_Host *shost = iscsi_session_to_shost(cls_session);
> +	struct iscsi_session *session = cls_session->dd_data;
> +
> +	if (WARN_ON_ONCE(session->leadconn))
> +		return;
>  
>  	iscsi_tcp_r2tpool_free(cls_session->dd_data);
>  	iscsi_session_teardown(cls_session);
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index ed8d9709b9b9..271afea654e2 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -2947,6 +2947,24 @@ iscsi_set_path(struct iscsi_transport *transport, struct iscsi_uevent *ev)
>  	return err;
>  }
>  
> +static int iscsi_session_has_conns(int sid)
> +{
> +	struct iscsi_cls_conn *conn;
> +	unsigned long flags;
> +	int found = 0;
> +
> +	spin_lock_irqsave(&connlock, flags);
> +	list_for_each_entry(conn, &connlist, conn_list) {
> +		if (iscsi_conn_get_sid(conn) == sid) {
> +			found = 1;
> +			break;
> +		}
> +	}
> +	spin_unlock_irqrestore(&connlock, flags);
> +
> +	return found;
> +}
> +
>  static int
>  iscsi_set_iface_params(struct iscsi_transport *transport,
>  		       struct iscsi_uevent *ev, uint32_t len)
> @@ -3524,10 +3542,12 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
>  		break;
>  	case ISCSI_UEVENT_DESTROY_SESSION:
>  		session = iscsi_session_lookup(ev->u.d_session.sid);
> -		if (session)
> -			transport->destroy_session(session);
> -		else
> +		if (!session)
>  			err = -EINVAL;
> +		else if (iscsi_session_has_conns(ev->u.d_session.sid))
> +			err = -EBUSY;
> +		else
> +			transport->destroy_session(session);
>  		break;
>  	case ISCSI_UEVENT_UNBIND_SESSION:
>  		session = iscsi_session_lookup(ev->u.d_session.sid);
> -- 
> 2.24.1

-- 
Gabriel Krisman Bertazi
