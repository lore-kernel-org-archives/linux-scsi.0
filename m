From: Mike Christie <MChristie@fusionio.com>
Subject: Re: [PATCH 1/3] SCSI/libiscsi: Restructure iscsi_tcp r2t response
 logic
Date: Wed, 30 Oct 2013 01:46:06 +0000
Message-ID: <14304D0E-704A-4FDA-9275-32A1D265DA24@fusionio.com>
References: <1382880206-2789-1-git-send-email-ogerlitz@mellanox.com>,<1382880206-2789-2-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:55077 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab3J3BqK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Oct 2013 21:46:10 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id F0C049A06BD
	for <linux-scsi@vger.kernel.org>; Tue, 29 Oct 2013 19:46:09 -0600 (MDT)
In-Reply-To: <1382880206-2789-2-git-send-email-ogerlitz@mellanox.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: "JBottomley@parallels.com" <JBottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "shlomop@mellanox.com" <shlomop@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>

Patches 1-3 look ok to me.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>



> On Oct 27, 2013, at 9:23 AM, "Or Gerlitz" <ogerlitz@mellanox.com> wrote:
> 
> From: Shlomo Pongratz <shlomop@mellanox.com>
> 
> Restructure the iscsi_tcp_r2t_rsp routine in order to avoid allocating
> r2t from r2tpool.queue and returning it back in case the parameters
> rhdr->data_length and or rhdr->data_offset prohibit the requing.
> 
> Since the values of these parameters are known prior to the allocation,
> we can pre-check and thus avoid futile allocations.
> 
> Signed-off-by: Shlomo Pongratz <shlomop@mellanox.com>
> Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
> ---
> drivers/scsi/libiscsi_tcp.c |   43 ++++++++++++++++++++++---------------------
> 1 files changed, 22 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
> index 1d58d53..7f59073 100644
> --- a/drivers/scsi/libiscsi_tcp.c
> +++ b/drivers/scsi/libiscsi_tcp.c
> @@ -529,6 +529,8 @@ static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_task *task)
>    struct iscsi_r2t_rsp *rhdr = (struct iscsi_r2t_rsp *)tcp_conn->in.hdr;
>    struct iscsi_r2t_info *r2t;
>    int r2tsn = be32_to_cpu(rhdr->r2tsn);
> +    u32 data_length;
> +    u32 data_offset;
>    int rc;
> 
>    if (tcp_conn->in.datalen) {
> @@ -554,40 +556,39 @@ static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_task *task)
>        return 0;
>    }
> 
> -    rc = kfifo_out(&tcp_task->r2tpool.queue, (void*)&r2t, sizeof(void*));
> -    if (!rc) {
> -        iscsi_conn_printk(KERN_ERR, conn, "Could not allocate R2T. "
> -                  "Target has sent more R2Ts than it "
> -                  "negotiated for or driver has leaked.\n");
> -        return ISCSI_ERR_PROTO;
> -    }
> -
> -    r2t->exp_statsn = rhdr->statsn;
> -    r2t->data_length = be32_to_cpu(rhdr->data_length);
> -    if (r2t->data_length == 0) {
> +    data_length = be32_to_cpu(rhdr->data_length);
> +    if (data_length == 0) {
>        iscsi_conn_printk(KERN_ERR, conn,
>                  "invalid R2T with zero data len\n");
> -        kfifo_in(&tcp_task->r2tpool.queue, (void*)&r2t,
> -                sizeof(void*));
>        return ISCSI_ERR_DATALEN;
>    }
> 
> -    if (r2t->data_length > session->max_burst)
> +    if (data_length > session->max_burst)
>        ISCSI_DBG_TCP(conn, "invalid R2T with data len %u and max "
>                  "burst %u. Attempting to execute request.\n",
> -                  r2t->data_length, session->max_burst);
> +                  data_length, session->max_burst);
> 
> -    r2t->data_offset = be32_to_cpu(rhdr->data_offset);
> -    if (r2t->data_offset + r2t->data_length > scsi_out(task->sc)->length) {
> +    data_offset = be32_to_cpu(rhdr->data_offset);
> +    if (data_offset + data_length > scsi_out(task->sc)->length) {
>        iscsi_conn_printk(KERN_ERR, conn,
>                  "invalid R2T with data len %u at offset %u "
> -                  "and total length %d\n", r2t->data_length,
> -                  r2t->data_offset, scsi_out(task->sc)->length);
> -        kfifo_in(&tcp_task->r2tpool.queue, (void*)&r2t,
> -                sizeof(void*));
> +                  "and total length %d\n", data_length,
> +                  data_offset, scsi_out(task->sc)->length);
>        return ISCSI_ERR_DATALEN;
>    }
> 
> +    rc = kfifo_out(&tcp_task->r2tpool.queue, (void*)&r2t, sizeof(void*));
> +    if (!rc) {
> +        iscsi_conn_printk(KERN_ERR, conn, "Could not allocate R2T. "
> +                  "Target has sent more R2Ts than it "
> +                  "negotiated for or driver has leaked.\n");
> +        return ISCSI_ERR_PROTO;
> +    }
> +
> +    r2t->exp_statsn = rhdr->statsn;
> +    r2t->data_length = data_length;
> +    r2t->data_offset = data_offset;
> +
>    r2t->ttt = rhdr->ttt; /* no flip */
>    r2t->datasn = 0;
>    r2t->sent = 0;
> -- 
> 1.7.1
> 
