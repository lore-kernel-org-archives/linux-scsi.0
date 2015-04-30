From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 04/12] IB/srp: Fix connection state tracking
Date: Thu, 30 Apr 2015 12:51:59 +0300
Message-ID: <5541FB3F.70902@dev.mellanox.co.il>
References: <5541EE21.3050809@sandisk.com> <5541EE9F.8090605@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:35738 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbbD3JwD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Apr 2015 05:52:03 -0400
Received: by wgyo15 with SMTP id o15so56155856wgy.2
        for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2015 02:52:02 -0700 (PDT)
In-Reply-To: <5541EE9F.8090605@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, Doug Ledford <dledford@redhat.com>
Cc: James Bottomley <jbottomley@odin.com>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, linux-rdma <linux-rdma@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 4/30/2015 11:58 AM, Bart Van Assche wrote:
> Reception of a DREQ message only causes the state of a single
> channel to change. Modify the SRP initiator such that channel
> and target connection state are tracked separately. This patch
> avoids that following false positive warning can be reported
> by srp_destroy_qp():
>
> WARNING: at drivers/infiniband/ulp/srp/ib_srp.c:617 srp_destroy_qp+0xa6/0x120 [ib_srp]()
> Call Trace:
> [<ffffffff8106e10f>] warn_slowpath_common+0x7f/0xc0
> [<ffffffff8106e16a>] warn_slowpath_null+0x1a/0x20
> [<ffffffffa0440226>] srp_destroy_qp+0xa6/0x120 [ib_srp]
> [<ffffffffa0440322>] srp_free_ch_ib+0x82/0x1e0 [ib_srp]
> [<ffffffffa044408b>] srp_create_target+0x7ab/0x998 [ib_srp]
> [<ffffffff81346f60>] dev_attr_store+0x20/0x30
> [<ffffffff811dd90f>] sysfs_write_file+0xef/0x170
> [<ffffffff8116d248>] vfs_write+0xc8/0x190
> [<ffffffff8116d411>] sys_write+0x51/0x90
>
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Sagi Grimberg <sagig@mellanox.com>
> Cc: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
> Cc: <stable@vger.kernel.org> #v3.19
> ---
>   drivers/infiniband/ulp/srp/ib_srp.c | 7 ++++---
>   drivers/infiniband/ulp/srp/ib_srp.h | 1 +
>   2 files changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index 5ce6cfd..0eb07d3 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -465,14 +465,13 @@ static struct srp_fr_pool *srp_alloc_fr_pool(struct srp_target_port *target)
>    */
>   static void srp_destroy_qp(struct srp_rdma_ch *ch)
>   {
> -	struct srp_target_port *target = ch->target;
>   	static struct ib_qp_attr attr = { .qp_state = IB_QPS_ERR };
>   	static struct ib_recv_wr wr = { .wr_id = SRP_LAST_WR_ID };
>   	struct ib_recv_wr *bad_wr;
>   	int ret;
>
>   	/* Destroying a QP and reusing ch->done is only safe if not connected */
> -	WARN_ON_ONCE(target->connected);
> +	WARN_ON_ONCE(ch->connected);
>
>   	ret = ib_modify_qp(ch->qp, &attr, IB_QP_STATE);
>   	WARN_ONCE(ret, "ib_cm_init_qp_attr() returned %d\n", ret);
> @@ -836,6 +835,7 @@ static void srp_disconnect_target(struct srp_target_port *target)
>
>   		for (i = 0; i < target->ch_count; i++) {
>   			ch = &target->ch[i];
> +			ch->connected = false;
>   			if (ch->cm_id && ib_send_cm_dreq(ch->cm_id, NULL, 0)) {
>   				shost_printk(KERN_DEBUG, target->scsi_host,
>   					     PFX "Sending CM DREQ failed\n");
> @@ -1017,6 +1017,7 @@ static int srp_connect_ch(struct srp_rdma_ch *ch, bool multich)
>   		switch (ch->status) {
>   		case 0:
>   			srp_change_conn_state(target, true);
> +			ch->connected = true;
>   			return 0;
>
>   		case SRP_PORT_REDIRECT:
> @@ -2367,7 +2368,7 @@ static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
>   	case IB_CM_DREQ_RECEIVED:
>   		shost_printk(KERN_WARNING, target->scsi_host,
>   			     PFX "DREQ received - connection closed\n");
> -		srp_change_conn_state(target, false);
> +		ch->connected = false;

Shouldn't this be protected by the channel lock (like the target)?

>   		if (ib_send_cm_drep(cm_id, NULL, 0))
>   			shost_printk(KERN_ERR, target->scsi_host,
>   				     PFX "Sending CM DREP failed\n");
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
> index a611556..95a4471 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.h
> +++ b/drivers/infiniband/ulp/srp/ib_srp.h
> @@ -170,6 +170,7 @@ struct srp_rdma_ch {
>
>   	struct completion	tsk_mgmt_done;
>   	u8			tsk_mgmt_status;
> +	bool			connected;

I generally agree with this flag, but I'm a bit confused about the
semantics of two connected flags? Also, we check the target connected
flag on TMFs, although we are executing it on a channel (should we
check both?)

I'd say keep only the channel connected flag, the target logic needs to
be mandated by the state.

Sagi.

I think we need to keep only



