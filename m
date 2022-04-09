Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 835A6C433EF
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Apr 2022 01:55:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240453AbiDIB5K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Apr 2022 21:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiDIB5I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2022 21:57:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 01689237028
        for <linux-scsi@vger.kernel.org>; Fri,  8 Apr 2022 18:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649469301;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=H1YWdn6chpzz5p7itwXKYg12/dcvQxM5ehXr8CHjn7E=;
        b=exHwCG1ZbaA963WznvdqUEnYQfNHNKOCfYM4fuGmAdcIRC2rTbkiLE899Q/fjCy56sa6hg
        bqbgzAE8AS5pV6yOkh6VhT7pcfZ3K323f4/tTBVLryWUcgjXKtZM+H1k39UI+hGFhWvowM
        nUsfOgZq6zT1E7MWHCiDZDZgh+tn/pQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-637-3JA4w3hlMMesl5yfF67TgQ-1; Fri, 08 Apr 2022 21:54:57 -0400
X-MC-Unique: 3JA4w3hlMMesl5yfF67TgQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 32755299E749;
        Sat,  9 Apr 2022 01:54:57 +0000 (UTC)
Received: from localhost (unknown [10.2.16.9])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2FD1BC50941;
        Sat,  9 Apr 2022 01:54:56 +0000 (UTC)
Date:   Fri, 8 Apr 2022 18:54:54 -0700
From:   Chris Leech <cleech@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     skashyap@marvell.com, lduncan@suse.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Subject: Re: [PATCH 06/10] scsi: iscsi: Fix unbound endpoint error handling
Message-ID: <YlDnbumPbfZPZ3/v@localhost>
Mail-Followup-To: Mike Christie <michael.christie@oracle.com>,
        skashyap@marvell.com, lduncan@suse.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
References: <20220408001314.5014-1-michael.christie@oracle.com>
 <20220408001314.5014-7-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220408001314.5014-7-michael.christie@oracle.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Apr 07, 2022 at 07:13:10PM -0500, Mike Christie wrote:
> If a driver raises a connection error before the connection is bound, we
> can leave a cleanup_work queued that can later run and disconnect/stop a
> connection that is logged in. The problem is that drivers can call
> iscsi_conn_error_event for endpoints that are connected but not yet bound
> when something like the network port they are using is brought down.
> iscsi_cleanup_conn_work_fn will check for this and exit early, but if the
> cleanup_work is stuck behind other works, it might not get run until after
> userspace has done ep_disconnect. Because the endpoint is not yet bound
> there was no way for ep_disconnect to flush the work.
> 
> The bug of leaving stop_conns queued was added in:
> 
> Commit 23d6fefbb3f6 ("scsi: iscsi: Fix in-kernel conn failure handling")
> 
> and:
> 
> Commit 0ab710458da1 ("scsi: iscsi: Perform connection failure entirely in
> kernel space")
> 
> was supposed to fix it, but left this case.
> 
> This patch moves the conn state check to before we even queue the work
> so we can avoid queueing.
> 
> Fixes: 0ab710458da1 ("scsi: iscsi: Perform connection failure entirely in
> kernel space")
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/scsi_transport_iscsi.c | 65 ++++++++++++++++-------------
>  1 file changed, 36 insertions(+), 29 deletions(-)
 
Reviewed-by: Chris Leech <cleech@redhat.com>

> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index 63a4f0c022fd..2c0dd64159b0 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -2201,10 +2201,10 @@ static void iscsi_stop_conn(struct iscsi_cls_conn *conn, int flag)
>  
>  	switch (flag) {
>  	case STOP_CONN_RECOVER:
> -		conn->state = ISCSI_CONN_FAILED;
> +		WRITE_ONCE(conn->state, ISCSI_CONN_FAILED);
>  		break;
>  	case STOP_CONN_TERM:
> -		conn->state = ISCSI_CONN_DOWN;
> +		WRITE_ONCE(conn->state, ISCSI_CONN_DOWN);
>  		break;
>  	default:
>  		iscsi_cls_conn_printk(KERN_ERR, conn, "invalid stop flag %d\n",
> @@ -2222,7 +2222,7 @@ static void iscsi_ep_disconnect(struct iscsi_cls_conn *conn, bool is_active)
>  	struct iscsi_endpoint *ep;
>  
>  	ISCSI_DBG_TRANS_CONN(conn, "disconnect ep.\n");
> -	conn->state = ISCSI_CONN_FAILED;
> +	WRITE_ONCE(conn->state, ISCSI_CONN_FAILED);
>  
>  	if (!conn->ep || !session->transport->ep_disconnect)
>  		return;
> @@ -2321,21 +2321,6 @@ static void iscsi_cleanup_conn_work_fn(struct work_struct *work)
>  	struct iscsi_cls_session *session = iscsi_conn_to_session(conn);
>  
>  	mutex_lock(&conn->ep_mutex);
> -	/*
> -	 * If we are not at least bound there is nothing for us to do. Userspace
> -	 * will do a ep_disconnect call if offload is used, but will not be
> -	 * doing a stop since there is nothing to clean up, so we have to clear
> -	 * the cleanup bit here.
> -	 */
> -	if (conn->state != ISCSI_CONN_BOUND && conn->state != ISCSI_CONN_UP) {
> -		ISCSI_DBG_TRANS_CONN(conn, "Got error while conn is already failed. Ignoring.\n");
> -		spin_lock_irq(&conn->lock);
> -		clear_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags);
> -		spin_unlock_irq(&conn->lock);
> -		mutex_unlock(&conn->ep_mutex);
> -		return;
> -	}
> -
>  	/*
>  	 * Get a ref to the ep, so we don't release its ID until after
>  	 * userspace is done referencing it in iscsi_if_disconnect_bound_ep.
> @@ -2391,7 +2376,7 @@ iscsi_alloc_conn(struct iscsi_cls_session *session, int dd_size, uint32_t cid)
>  	INIT_WORK(&conn->cleanup_work, iscsi_cleanup_conn_work_fn);
>  	conn->transport = transport;
>  	conn->cid = cid;
> -	conn->state = ISCSI_CONN_DOWN;
> +	WRITE_ONCE(conn->state, ISCSI_CONN_DOWN);
>  
>  	/* this is released in the dev's release function */
>  	if (!get_device(&session->dev))
> @@ -2590,10 +2575,30 @@ void iscsi_conn_error_event(struct iscsi_cls_conn *conn, enum iscsi_err error)
>  	struct iscsi_internal *priv;
>  	int len = nlmsg_total_size(sizeof(*ev));
>  	unsigned long flags;
> +	int state;
>  
>  	spin_lock_irqsave(&conn->lock, flags);
> -	if (!test_and_set_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags))
> -		queue_work(iscsi_conn_cleanup_workq, &conn->cleanup_work);
> +	/*
> +	 * Userspace will only do a stop call if we are at least bound. And, we
> +	 * only need to do the in kernel cleanup if in the UP state so cmds can
> +	 * be released to upper layers. If in other states just wait for
> +	 * userspace to avoid races that can leave the cleanup_work queued.
> +	 */
> +	state = READ_ONCE(conn->state);
> +	switch (state) {
> +	case ISCSI_CONN_BOUND:
> +	case ISCSI_CONN_UP:
> +		if (!test_and_set_bit(ISCSI_CLS_CONN_BIT_CLEANUP,
> +				      &conn->flags)) {
> +			queue_work(iscsi_conn_cleanup_workq,
> +				   &conn->cleanup_work);
> +		}
> +		break;
> +	default:
> +		ISCSI_DBG_TRANS_CONN(conn, "Got conn error in state %d\n",
> +				     state);
> +		break;
> +	}
>  	spin_unlock_irqrestore(&conn->lock, flags);
>  
>  	priv = iscsi_if_transport_lookup(conn->transport);
> @@ -2944,7 +2949,7 @@ iscsi_set_param(struct iscsi_transport *transport, struct iscsi_uevent *ev)
>  	char *data = (char*)ev + sizeof(*ev);
>  	struct iscsi_cls_conn *conn;
>  	struct iscsi_cls_session *session;
> -	int err = 0, value = 0;
> +	int err = 0, value = 0, state;
>  
>  	if (ev->u.set_param.len > PAGE_SIZE)
>  		return -EINVAL;
> @@ -2961,8 +2966,8 @@ iscsi_set_param(struct iscsi_transport *transport, struct iscsi_uevent *ev)
>  			session->recovery_tmo = value;
>  		break;
>  	default:
> -		if ((conn->state == ISCSI_CONN_BOUND) ||
> -			(conn->state == ISCSI_CONN_UP)) {
> +		state = READ_ONCE(conn->state);
> +		if (state == ISCSI_CONN_BOUND || state == ISCSI_CONN_UP) {
>  			err = transport->set_param(conn, ev->u.set_param.param,
>  					data, ev->u.set_param.len);
>  		} else {
> @@ -3758,7 +3763,7 @@ static int iscsi_if_transport_conn(struct iscsi_transport *transport,
>  						ev->u.b_conn.transport_eph,
>  						ev->u.b_conn.is_leading);
>  		if (!ev->r.retcode)
> -			conn->state = ISCSI_CONN_BOUND;
> +			WRITE_ONCE(conn->state, ISCSI_CONN_BOUND);
>  
>  		if (ev->r.retcode || !transport->ep_connect)
>  			break;
> @@ -3777,7 +3782,8 @@ static int iscsi_if_transport_conn(struct iscsi_transport *transport,
>  	case ISCSI_UEVENT_START_CONN:
>  		ev->r.retcode = transport->start_conn(conn);
>  		if (!ev->r.retcode)
> -			conn->state = ISCSI_CONN_UP;
> +			WRITE_ONCE(conn->state, ISCSI_CONN_UP);
> +
>  		break;
>  	case ISCSI_UEVENT_SEND_PDU:
>  		pdu_len = nlh->nlmsg_len - sizeof(*nlh) - sizeof(*ev);
> @@ -4084,10 +4090,11 @@ static ssize_t show_conn_state(struct device *dev,
>  {
>  	struct iscsi_cls_conn *conn = iscsi_dev_to_conn(dev->parent);
>  	const char *state = "unknown";
> +	int conn_state = READ_ONCE(conn->state);
>  
> -	if (conn->state >= 0 &&
> -	    conn->state < ARRAY_SIZE(connection_state_names))
> -		state = connection_state_names[conn->state];
> +	if (conn_state >= 0 &&
> +	    conn_state < ARRAY_SIZE(connection_state_names))
> +		state = connection_state_names[conn_state];
>  
>  	return sysfs_emit(buf, "%s\n", state);
>  }
> -- 
> 2.25.1
> 

