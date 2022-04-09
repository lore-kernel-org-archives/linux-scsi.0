Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF380C433F5
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Apr 2022 01:56:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232446AbiDIB6z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Apr 2022 21:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiDIB6z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2022 21:58:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EF9CD15D14A
        for <linux-scsi@vger.kernel.org>; Fri,  8 Apr 2022 18:56:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649469409;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vOuptGEydZN39ughSZCEpS1Jazf2PllONzVwyRRnEPI=;
        b=Rll+9MgDhJ/tp3lnPpw9AjqPSZVfKKOWwB60FGX/URcBFvIVWfQr4HHpNeks3TstckHS/2
        R4Qfe94wUaGZsl0jdEa5HRekd9wue9gTy4u0g3veh6CdWKK/YEw/Yp1puVs1PKjDT9c/X0
        pW/yOIdtMoCttDxkM5jaWRLWj/lqt/0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-663-DQhlBX6CMoyefg5NOx5DsQ-1; Fri, 08 Apr 2022 21:56:44 -0400
X-MC-Unique: DQhlBX6CMoyefg5NOx5DsQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 67F2D101A52C;
        Sat,  9 Apr 2022 01:56:44 +0000 (UTC)
Received: from localhost (unknown [10.2.16.9])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 63B96141512A;
        Sat,  9 Apr 2022 01:56:43 +0000 (UTC)
Date:   Fri, 8 Apr 2022 18:56:41 -0700
From:   Chris Leech <cleech@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     skashyap@marvell.com, lduncan@suse.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Subject: Re: [PATCH 07/10] scsi: iscsi: Merge suspend fields
Message-ID: <YlDn2dGFua2/XUXl@localhost>
Mail-Followup-To: Mike Christie <michael.christie@oracle.com>,
        skashyap@marvell.com, lduncan@suse.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
References: <20220408001314.5014-1-michael.christie@oracle.com>
 <20220408001314.5014-8-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220408001314.5014-8-michael.christie@oracle.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Apr 07, 2022 at 07:13:11PM -0500, Mike Christie wrote:
> Move the tx and rx suspend fields into one flags field.
> 
> Reviewed-by: Lee Duncan <lduncan@suse.com>
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/bnx2i/bnx2i_hwi.c   |  2 +-
>  drivers/scsi/bnx2i/bnx2i_iscsi.c |  2 +-
>  drivers/scsi/cxgbi/libcxgbi.c    |  6 +++---
>  drivers/scsi/libiscsi.c          | 20 ++++++++++----------
>  drivers/scsi/libiscsi_tcp.c      |  2 +-
>  include/scsi/libiscsi.h          |  9 +++++----
>  6 files changed, 21 insertions(+), 20 deletions(-)

Reviewed-by: Chris Leech <cleech@redhat.com>
 
> diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
> index 5521469ce678..e16327a4b4c9 100644
> --- a/drivers/scsi/bnx2i/bnx2i_hwi.c
> +++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
> @@ -1977,7 +1977,7 @@ static int bnx2i_process_new_cqes(struct bnx2i_conn *bnx2i_conn)
>  		if (nopin->cq_req_sn != qp->cqe_exp_seq_sn)
>  			break;
>  
> -		if (unlikely(test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx))) {
> +		if (unlikely(test_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags))) {
>  			if (nopin->op_code == ISCSI_OP_NOOP_IN &&
>  			    nopin->itt == (u16) RESERVED_ITT) {
>  				printk(KERN_ALERT "bnx2i: Unsolicited "
> diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
> index fe86fd61a995..15fbd09baa94 100644
> --- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
> +++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
> @@ -1721,7 +1721,7 @@ static int bnx2i_tear_down_conn(struct bnx2i_hba *hba,
>  			struct iscsi_conn *conn = ep->conn->cls_conn->dd_data;
>  
>  			/* Must suspend all rx queue activity for this ep */
> -			set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx);
> +			set_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags);
>  		}
>  		/* CONN_DISCONNECT timeout may or may not be an issue depending
>  		 * on what transcribed in TCP layer, different targets behave
> diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
> index 8c7d4dda4cf2..4365d52c6430 100644
> --- a/drivers/scsi/cxgbi/libcxgbi.c
> +++ b/drivers/scsi/cxgbi/libcxgbi.c
> @@ -1634,11 +1634,11 @@ void cxgbi_conn_pdu_ready(struct cxgbi_sock *csk)
>  	log_debug(1 << CXGBI_DBG_PDU_RX,
>  		"csk 0x%p, conn 0x%p.\n", csk, conn);
>  
> -	if (unlikely(!conn || conn->suspend_rx)) {
> +	if (unlikely(!conn || test_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags))) {
>  		log_debug(1 << CXGBI_DBG_PDU_RX,
> -			"csk 0x%p, conn 0x%p, id %d, suspend_rx %lu!\n",
> +			"csk 0x%p, conn 0x%p, id %d, conn flags 0x%lx!\n",
>  			csk, conn, conn ? conn->id : 0xFF,
> -			conn ? conn->suspend_rx : 0xFF);
> +			conn ? conn->flags : 0xFF);
>  		return;
>  	}
>  
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index d09926e6c8a8..5e7bd5a3b430 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -1392,8 +1392,8 @@ static bool iscsi_set_conn_failed(struct iscsi_conn *conn)
>  	if (conn->stop_stage == 0)
>  		session->state = ISCSI_STATE_FAILED;
>  
> -	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
> -	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx);
> +	set_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags);
> +	set_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags);
>  	return true;
>  }
>  
> @@ -1454,7 +1454,7 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
>  	 * Do this after dropping the extra ref because if this was a requeue
>  	 * it's removed from that list and cleanup_queued_task would miss it.
>  	 */
> -	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx)) {
> +	if (test_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags)) {
>  		/*
>  		 * Save the task and ref in case we weren't cleaning up this
>  		 * task and get woken up again.
> @@ -1532,7 +1532,7 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
>  	int rc = 0;
>  
>  	spin_lock_bh(&conn->session->frwd_lock);
> -	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx)) {
> +	if (test_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags)) {
>  		ISCSI_DBG_SESSION(conn->session, "Tx suspended!\n");
>  		spin_unlock_bh(&conn->session->frwd_lock);
>  		return -ENODATA;
> @@ -1746,7 +1746,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
>  		goto fault;
>  	}
>  
> -	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx)) {
> +	if (test_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags)) {
>  		reason = FAILURE_SESSION_IN_RECOVERY;
>  		sc->result = DID_REQUEUE << 16;
>  		goto fault;
> @@ -1935,7 +1935,7 @@ static void fail_scsi_tasks(struct iscsi_conn *conn, u64 lun, int error)
>  void iscsi_suspend_queue(struct iscsi_conn *conn)
>  {
>  	spin_lock_bh(&conn->session->frwd_lock);
> -	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
> +	set_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags);
>  	spin_unlock_bh(&conn->session->frwd_lock);
>  }
>  EXPORT_SYMBOL_GPL(iscsi_suspend_queue);
> @@ -1953,7 +1953,7 @@ void iscsi_suspend_tx(struct iscsi_conn *conn)
>  	struct Scsi_Host *shost = conn->session->host;
>  	struct iscsi_host *ihost = shost_priv(shost);
>  
> -	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
> +	set_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags);
>  	if (ihost->workq)
>  		flush_workqueue(ihost->workq);
>  }
> @@ -1961,7 +1961,7 @@ EXPORT_SYMBOL_GPL(iscsi_suspend_tx);
>  
>  static void iscsi_start_tx(struct iscsi_conn *conn)
>  {
> -	clear_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
> +	clear_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags);
>  	iscsi_conn_queue_work(conn);
>  }
>  
> @@ -3330,8 +3330,8 @@ int iscsi_conn_bind(struct iscsi_cls_session *cls_session,
>  	/*
>  	 * Unblock xmitworker(), Login Phase will pass through.
>  	 */
> -	clear_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx);
> -	clear_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
> +	clear_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags);
> +	clear_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags);
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(iscsi_conn_bind);
> diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
> index 2e9ffe3d1a55..883005757ddb 100644
> --- a/drivers/scsi/libiscsi_tcp.c
> +++ b/drivers/scsi/libiscsi_tcp.c
> @@ -927,7 +927,7 @@ int iscsi_tcp_recv_skb(struct iscsi_conn *conn, struct sk_buff *skb,
>  	 */
>  	conn->last_recv = jiffies;
>  
> -	if (unlikely(conn->suspend_rx)) {
> +	if (unlikely(test_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags))) {
>  		ISCSI_DBG_TCP(conn, "Rx suspended!\n");
>  		*status = ISCSI_TCP_SUSPENDED;
>  		return 0;
> diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
> index e76c94697c1b..84086c240228 100644
> --- a/include/scsi/libiscsi.h
> +++ b/include/scsi/libiscsi.h
> @@ -53,8 +53,10 @@ enum {
>  
>  #define ISID_SIZE			6
>  
> -/* Connection suspend "bit" */
> -#define ISCSI_SUSPEND_BIT		1
> +/* Connection flags */
> +#define ISCSI_CONN_FLAG_SUSPEND_TX	BIT(0)
> +#define ISCSI_CONN_FLAG_SUSPEND_RX	BIT(1)
> +
>  
>  #define ISCSI_ITT_MASK			0x1fff
>  #define ISCSI_TOTAL_CMDS_MAX		4096
> @@ -211,8 +213,7 @@ struct iscsi_conn {
>  	struct list_head	cmdqueue;	/* data-path cmd queue */
>  	struct list_head	requeue;	/* tasks needing another run */
>  	struct work_struct	xmitwork;	/* per-conn. xmit workqueue */
> -	unsigned long		suspend_tx;	/* suspend Tx */
> -	unsigned long		suspend_rx;	/* suspend Rx */
> +	unsigned long		flags;		/* ISCSI_CONN_FLAGs */
>  
>  	/* negotiated params */
>  	unsigned		max_recv_dlength; /* initiator_max_recv_dsl*/
> -- 
> 2.25.1
> 

