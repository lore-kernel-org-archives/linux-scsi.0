Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 216C9C433F5
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Apr 2022 02:01:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240493AbiDICDN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Apr 2022 22:03:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240513AbiDICDM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2022 22:03:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 49C28D444B
        for <linux-scsi@vger.kernel.org>; Fri,  8 Apr 2022 19:01:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649469664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oNBQaqt+O3C511PT1R1jwxXBpdqvaMVtsDmFzJwNCWI=;
        b=d9xUWGWaryXmCHqvfu81UtuqvBFxmQCrjziPEytUgyZvHaXOx3G/whg8Gg6QHMt0SqSqpY
        ymkyjLM2hP7RZNmdOW3y/HzlRBdjaUBtrOm09yrzLtbi5GzvEFsasNpEJhbUzc4jN6TTjp
        c/NLrCLnDCKl57C/kE6JVLhpmJSJvRo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-495-e893iYyZMtum97nj0JBbwg-1; Fri, 08 Apr 2022 22:01:00 -0400
X-MC-Unique: e893iYyZMtum97nj0JBbwg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2A39C8038E3;
        Sat,  9 Apr 2022 02:01:00 +0000 (UTC)
Received: from localhost (unknown [10.2.16.9])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3736F2166B1F;
        Sat,  9 Apr 2022 02:00:59 +0000 (UTC)
Date:   Fri, 8 Apr 2022 19:00:57 -0700
From:   Chris Leech <cleech@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     skashyap@marvell.com, lduncan@suse.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Subject: Re: [PATCH 09/10] scsi: qedi: Fix failed disconnect handling.
Message-ID: <YlDo2f70SeNp2Kng@localhost>
Mail-Followup-To: Mike Christie <michael.christie@oracle.com>,
        skashyap@marvell.com, lduncan@suse.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
References: <20220408001314.5014-1-michael.christie@oracle.com>
 <20220408001314.5014-10-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220408001314.5014-10-michael.christie@oracle.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Apr 07, 2022 at 07:13:13PM -0500, Mike Christie wrote:
> We set the qedi_ep state to EP_STATE_OFLDCONN_START when the ep is
> created. Then in qedi_set_path we kick off the offload work. If userspace
> times out the connection and calls ep_disconnect, qedi will only flush the
> offload work if the qedi_ep state has transitioned away from
> EP_STATE_OFLDCONN_START. If we can't connect we will not have transitioned
> state and will leave the offload work running, and we will free the
> qedi_ep from under it.
> 
> This patch just has us init the work when we create the ep, then always
> flush it.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/qedi/qedi_iscsi.c | 69 +++++++++++++++++-----------------
>  1 file changed, 34 insertions(+), 35 deletions(-)

Reviewed-by: Chris Leech <cleech@redhat.com>
 
> diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
> index 8196f89f404e..31ec429104e2 100644
> --- a/drivers/scsi/qedi/qedi_iscsi.c
> +++ b/drivers/scsi/qedi/qedi_iscsi.c
> @@ -860,6 +860,37 @@ static int qedi_task_xmit(struct iscsi_task *task)
>  	return qedi_iscsi_send_ioreq(task);
>  }
>  
> +static void qedi_offload_work(struct work_struct *work)
> +{
> +	struct qedi_endpoint *qedi_ep =
> +		container_of(work, struct qedi_endpoint, offload_work);
> +	struct qedi_ctx *qedi;
> +	int wait_delay = 5 * HZ;
> +	int ret;
> +
> +	qedi = qedi_ep->qedi;
> +
> +	ret = qedi_iscsi_offload_conn(qedi_ep);
> +	if (ret) {
> +		QEDI_ERR(&qedi->dbg_ctx,
> +			 "offload error: iscsi_cid=%u, qedi_ep=%p, ret=%d\n",
> +			 qedi_ep->iscsi_cid, qedi_ep, ret);
> +		qedi_ep->state = EP_STATE_OFLDCONN_FAILED;
> +		return;
> +	}
> +
> +	ret = wait_event_interruptible_timeout(qedi_ep->tcp_ofld_wait,
> +					       (qedi_ep->state ==
> +					       EP_STATE_OFLDCONN_COMPL),
> +					       wait_delay);
> +	if (ret <= 0 || qedi_ep->state != EP_STATE_OFLDCONN_COMPL) {
> +		qedi_ep->state = EP_STATE_OFLDCONN_FAILED;
> +		QEDI_ERR(&qedi->dbg_ctx,
> +			 "Offload conn TIMEOUT iscsi_cid=%u, qedi_ep=%p\n",
> +			 qedi_ep->iscsi_cid, qedi_ep);
> +	}
> +}
> +
>  static struct iscsi_endpoint *
>  qedi_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
>  		int non_blocking)
> @@ -908,6 +939,7 @@ qedi_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
>  	}
>  	qedi_ep = ep->dd_data;
>  	memset(qedi_ep, 0, sizeof(struct qedi_endpoint));
> +	INIT_WORK(&qedi_ep->offload_work, qedi_offload_work);
>  	qedi_ep->state = EP_STATE_IDLE;
>  	qedi_ep->iscsi_cid = (u32)-1;
>  	qedi_ep->qedi = qedi;
> @@ -1056,12 +1088,11 @@ static void qedi_ep_disconnect(struct iscsi_endpoint *ep)
>  	qedi_ep = ep->dd_data;
>  	qedi = qedi_ep->qedi;
>  
> +	flush_work(&qedi_ep->offload_work);
> +
>  	if (qedi_ep->state == EP_STATE_OFLDCONN_START)
>  		goto ep_exit_recover;
>  
> -	if (qedi_ep->state != EP_STATE_OFLDCONN_NONE)
> -		flush_work(&qedi_ep->offload_work);
> -
>  	if (qedi_ep->conn) {
>  		qedi_conn = qedi_ep->conn;
>  		abrt_conn = qedi_conn->abrt_conn;
> @@ -1235,37 +1266,6 @@ static int qedi_data_avail(struct qedi_ctx *qedi, u16 vlanid)
>  	return rc;
>  }
>  
> -static void qedi_offload_work(struct work_struct *work)
> -{
> -	struct qedi_endpoint *qedi_ep =
> -		container_of(work, struct qedi_endpoint, offload_work);
> -	struct qedi_ctx *qedi;
> -	int wait_delay = 5 * HZ;
> -	int ret;
> -
> -	qedi = qedi_ep->qedi;
> -
> -	ret = qedi_iscsi_offload_conn(qedi_ep);
> -	if (ret) {
> -		QEDI_ERR(&qedi->dbg_ctx,
> -			 "offload error: iscsi_cid=%u, qedi_ep=%p, ret=%d\n",
> -			 qedi_ep->iscsi_cid, qedi_ep, ret);
> -		qedi_ep->state = EP_STATE_OFLDCONN_FAILED;
> -		return;
> -	}
> -
> -	ret = wait_event_interruptible_timeout(qedi_ep->tcp_ofld_wait,
> -					       (qedi_ep->state ==
> -					       EP_STATE_OFLDCONN_COMPL),
> -					       wait_delay);
> -	if ((ret <= 0) || (qedi_ep->state != EP_STATE_OFLDCONN_COMPL)) {
> -		qedi_ep->state = EP_STATE_OFLDCONN_FAILED;
> -		QEDI_ERR(&qedi->dbg_ctx,
> -			 "Offload conn TIMEOUT iscsi_cid=%u, qedi_ep=%p\n",
> -			 qedi_ep->iscsi_cid, qedi_ep);
> -	}
> -}
> -
>  static int qedi_set_path(struct Scsi_Host *shost, struct iscsi_path *path_data)
>  {
>  	struct qedi_ctx *qedi;
> @@ -1381,7 +1381,6 @@ static int qedi_set_path(struct Scsi_Host *shost, struct iscsi_path *path_data)
>  			  qedi_ep->dst_addr, qedi_ep->dst_port);
>  	}
>  
> -	INIT_WORK(&qedi_ep->offload_work, qedi_offload_work);
>  	queue_work(qedi->offload_thread, &qedi_ep->offload_work);
>  
>  	ret = 0;
> -- 
> 2.25.1
> 

