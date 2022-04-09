Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBE20C433F5
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Apr 2022 01:46:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234425AbiDIBsh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Apr 2022 21:48:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiDIBsg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2022 21:48:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3625F38DB3
        for <linux-scsi@vger.kernel.org>; Fri,  8 Apr 2022 18:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649468790;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XsRrcL2wLNW8MzF9HFYqrOHuGFn096oURtiT4MsBbXo=;
        b=ZcHOsIxNChzK2/w8kRFxy9hHxt3HyjZ9/DyDV+DxlcSF10s5EkqLzrQiI1YDUaMTMbwrW2
        fMfyrSVHLYmIWbquYcJ9D6B1ruxAjX0GqUq/PmTqhQWHKw+Ikedm6ArHTmiq4rhsiAOJd7
        nU1znHra7PVF9zglSNvw73S6MyZoC2E=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-496-bbrGX4dRPbGhB2sX5ES-kA-1; Fri, 08 Apr 2022 21:46:19 -0400
X-MC-Unique: bbrGX4dRPbGhB2sX5ES-kA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ABED91C0DFE4;
        Sat,  9 Apr 2022 01:46:18 +0000 (UTC)
Received: from localhost (unknown [10.2.16.9])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BE8BF40317F;
        Sat,  9 Apr 2022 01:46:17 +0000 (UTC)
Date:   Fri, 8 Apr 2022 18:46:15 -0700
From:   Chris Leech <cleech@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     skashyap@marvell.com, lduncan@suse.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Subject: Re: [PATCH 05/10] scsi: iscsi: Fix conn cleanup and stop race during
 iscsid restart
Message-ID: <YlDlZ+nSlC2+Sh9Q@localhost>
Mail-Followup-To: Mike Christie <michael.christie@oracle.com>,
        skashyap@marvell.com, lduncan@suse.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
References: <20220408001314.5014-1-michael.christie@oracle.com>
 <20220408001314.5014-6-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220408001314.5014-6-michael.christie@oracle.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Apr 07, 2022 at 07:13:09PM -0500, Mike Christie wrote:
> If iscsid is doing a stop_conn at the same time the kernel is starting
> error recovery we can hit a race that allows the cleanup work to run on
> a valid connection. In the race, iscsi_if_stop_conn sees the cleanup bit
> set, but it calls flush_work on the clean_work before
> iscsi_conn_error_event has queued it. The flush then returns before the
> queueing and so the cleanup_work can run later and disconnect/stop a conn
> while it's in a connected state.
> 
> The patch:
> 
> Commit 0ab710458da1 ("scsi: iscsi: Perform connection failure entirely in
> kernel space")
> 
> added the late stop_conn call bug originally, and the patch:
> 
> Commit 23d6fefbb3f6 ("scsi: iscsi: Fix in-kernel conn failure handling")
> 
> attempted to fix it but only fixed the normal EH case and left the above
> race for the iscsid restart case. For the normal EH case we don't hit the
> race because we only signal userspace to start recovery after we have done
> the queueing, so the flush will always catch the queued work or see it
> completed.
> 
> For iscsid restart cases like boot, we can hit the race because iscsid
> will call down to the kernel before the kernel has signaled any error, so
> both code paths can be running at the same time. This adds a lock around
> the setting of the cleanup bit and queueing so they happen together.
> 
> Fixes: 0ab710458da1 ("scsi: iscsi: Perform connection failure entirely in
> kernel space")
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/scsi_transport_iscsi.c | 17 +++++++++++++++++
>  include/scsi/scsi_transport_iscsi.h |  2 ++
>  2 files changed, 19 insertions(+)
 
Reviewed-by: Chris Leech <cleech@redhat.com>

> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index f200da049f3b..63a4f0c022fd 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -2240,9 +2240,12 @@ static void iscsi_if_disconnect_bound_ep(struct iscsi_cls_conn *conn,
>  					 bool is_active)
>  {
>  	/* Check if this was a conn error and the kernel took ownership */
> +	spin_lock_irq(&conn->lock);
>  	if (!test_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags)) {
> +		spin_unlock_irq(&conn->lock);
>  		iscsi_ep_disconnect(conn, is_active);
>  	} else {
> +		spin_unlock_irq(&conn->lock);
>  		ISCSI_DBG_TRANS_CONN(conn, "flush kernel conn cleanup.\n");
>  		mutex_unlock(&conn->ep_mutex);
>  
> @@ -2289,9 +2292,12 @@ static int iscsi_if_stop_conn(struct iscsi_transport *transport,
>  		/*
>  		 * Figure out if it was the kernel or userspace initiating this.
>  		 */
> +		spin_lock_irq(&conn->lock);
>  		if (!test_and_set_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags)) {
> +			spin_unlock_irq(&conn->lock);
>  			iscsi_stop_conn(conn, flag);
>  		} else {
> +			spin_unlock_irq(&conn->lock);
>  			ISCSI_DBG_TRANS_CONN(conn,
>  					     "flush kernel conn cleanup.\n");
>  			flush_work(&conn->cleanup_work);
> @@ -2300,7 +2306,9 @@ static int iscsi_if_stop_conn(struct iscsi_transport *transport,
>  		 * Only clear for recovery to avoid extra cleanup runs during
>  		 * termination.
>  		 */
> +		spin_lock_irq(&conn->lock);
>  		clear_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags);
> +		spin_unlock_irq(&conn->lock);
>  	}
>  	ISCSI_DBG_TRANS_CONN(conn, "iscsi if conn stop done.\n");
>  	return 0;
> @@ -2321,7 +2329,9 @@ static void iscsi_cleanup_conn_work_fn(struct work_struct *work)
>  	 */
>  	if (conn->state != ISCSI_CONN_BOUND && conn->state != ISCSI_CONN_UP) {
>  		ISCSI_DBG_TRANS_CONN(conn, "Got error while conn is already failed. Ignoring.\n");
> +		spin_lock_irq(&conn->lock);
>  		clear_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags);
> +		spin_unlock_irq(&conn->lock);
>  		mutex_unlock(&conn->ep_mutex);
>  		return;
>  	}
> @@ -2376,6 +2386,7 @@ iscsi_alloc_conn(struct iscsi_cls_session *session, int dd_size, uint32_t cid)
>  		conn->dd_data = &conn[1];
>  
>  	mutex_init(&conn->ep_mutex);
> +	spin_lock_init(&conn->lock);
>  	INIT_LIST_HEAD(&conn->conn_list);
>  	INIT_WORK(&conn->cleanup_work, iscsi_cleanup_conn_work_fn);
>  	conn->transport = transport;
> @@ -2578,9 +2589,12 @@ void iscsi_conn_error_event(struct iscsi_cls_conn *conn, enum iscsi_err error)
>  	struct iscsi_uevent *ev;
>  	struct iscsi_internal *priv;
>  	int len = nlmsg_total_size(sizeof(*ev));
> +	unsigned long flags;
>  
> +	spin_lock_irqsave(&conn->lock, flags);
>  	if (!test_and_set_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags))
>  		queue_work(iscsi_conn_cleanup_workq, &conn->cleanup_work);
> +	spin_unlock_irqrestore(&conn->lock, flags);
>  
>  	priv = iscsi_if_transport_lookup(conn->transport);
>  	if (!priv)
> @@ -3723,11 +3737,14 @@ static int iscsi_if_transport_conn(struct iscsi_transport *transport,
>  		return -EINVAL;
>  
>  	mutex_lock(&conn->ep_mutex);
> +	spin_lock_irq(&conn->lock);
>  	if (test_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags)) {
> +		spin_unlock_irq(&conn->lock);
>  		mutex_unlock(&conn->ep_mutex);
>  		ev->r.retcode = -ENOTCONN;
>  		return 0;
>  	}
> +	spin_unlock_irq(&conn->lock);
>  
>  	switch (nlh->nlmsg_type) {
>  	case ISCSI_UEVENT_BIND_CONN:
> diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
> index fdd486047404..9acb8422f680 100644
> --- a/include/scsi/scsi_transport_iscsi.h
> +++ b/include/scsi/scsi_transport_iscsi.h
> @@ -211,6 +211,8 @@ struct iscsi_cls_conn {
>  	struct mutex ep_mutex;
>  	struct iscsi_endpoint *ep;
>  
> +	/* Used when accessing flags and queueing work. */
> +	spinlock_t lock;
>  	unsigned long flags;
>  	struct work_struct cleanup_work;
>  
> -- 
> 2.25.1
> 

