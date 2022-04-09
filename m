Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD1E4C433EF
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Apr 2022 01:36:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237897AbiDIBik (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Apr 2022 21:38:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237880AbiDIBij (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2022 21:38:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 78B19BBE2D
        for <linux-scsi@vger.kernel.org>; Fri,  8 Apr 2022 18:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649468193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7MuI7neByZKjyQnaVVkV6WHgD3eD9gk9EHFvhSvTPXs=;
        b=N+j4pa8EQAMeLY8lV9cpPiydJKZZnAO2uS7yVLES/t8cSwMIH17cz1Hllh42y5Uf2ga2Kp
        g9l2G61UBB3/eco/VSO5uG8X1k9/h3Th81hi7ZHjSNQmw/NhKFvu/LFafj8zyJYGgxph4s
        I/4tYRsBCRCnOn4xyDJ7kBaTuZ8x1ys=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-262-LjYcGC7eNKWqcZHmhar4bA-1; Fri, 08 Apr 2022 21:36:27 -0400
X-MC-Unique: LjYcGC7eNKWqcZHmhar4bA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C677D85A5A8;
        Sat,  9 Apr 2022 01:36:26 +0000 (UTC)
Received: from localhost (unknown [10.2.16.9])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D6A73C2812B;
        Sat,  9 Apr 2022 01:36:25 +0000 (UTC)
Date:   Fri, 8 Apr 2022 18:36:24 -0700
From:   Chris Leech <cleech@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     skashyap@marvell.com, lduncan@suse.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Subject: Re: [PATCH 02/10] scsi: iscsi: Fix offload conn cleanup when iscsid
 restarts
Message-ID: <YlDjGLh2wTFCCzLb@localhost>
Mail-Followup-To: Mike Christie <michael.christie@oracle.com>,
        skashyap@marvell.com, lduncan@suse.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
References: <20220408001314.5014-1-michael.christie@oracle.com>
 <20220408001314.5014-3-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220408001314.5014-3-michael.christie@oracle.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Apr 07, 2022 at 07:13:06PM -0500, Mike Christie wrote:
> When userspace restarts during boot or upgrades it won't know about the
> offload driver's endpoint and connection mappings. iscsid will start by
> cleaning up the old session by doing a stop_conn call. Later if we are
> able to create a new connection, we cleanup the old endpoint during the
> binding stage. The problem is that if we do stop_conn before doing the
> ep_disconnect call offload drivers can still be executing IO. We then
> might free tasks from the under the card/driver.
> 
> This moves the ep_disconnect call to before we do the stop_conn call for
> this case. It will then work and look like a normal recovery/cleanup
> procedure from the driver's point of view.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/scsi_transport_iscsi.c | 48 +++++++++++++++++------------
>  1 file changed, 28 insertions(+), 20 deletions(-)

Reviewed-by: Chris Leech <cleech@redhat.com>
 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index 4e10457e3ab9..bf39fb5569b6 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -2236,6 +2236,23 @@ static void iscsi_ep_disconnect(struct iscsi_cls_conn *conn, bool is_active)
>  	ISCSI_DBG_TRANS_CONN(conn, "disconnect ep done.\n");
>  }
>  
> +static void iscsi_if_disconnect_bound_ep(struct iscsi_cls_conn *conn,
> +					 struct iscsi_endpoint *ep,
> +					 bool is_active)
> +{
> +	/* Check if this was a conn error and the kernel took ownership */
> +	if (!test_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags)) {
> +		iscsi_ep_disconnect(conn, is_active);
> +	} else {
> +		ISCSI_DBG_TRANS_CONN(conn, "flush kernel conn cleanup.\n");
> +		mutex_unlock(&conn->ep_mutex);
> +
> +		flush_work(&conn->cleanup_work);
> +
> +		mutex_lock(&conn->ep_mutex);
> +	}
> +}
> +
>  static int iscsi_if_stop_conn(struct iscsi_transport *transport,
>  			      struct iscsi_uevent *ev)
>  {
> @@ -2256,6 +2273,16 @@ static int iscsi_if_stop_conn(struct iscsi_transport *transport,
>  		cancel_work_sync(&conn->cleanup_work);
>  		iscsi_stop_conn(conn, flag);
>  	} else {
> +		/*
> +		 * For offload, when iscsid is restarted it won't know about
> +		 * existing endpoints so it can't do a ep_disconnect. We clean
> +		 * it up here for userspace.
> +		 */
> +		mutex_lock(&conn->ep_mutex);
> +		if (conn->ep)
> +			iscsi_if_disconnect_bound_ep(conn, conn->ep, true);
> +		mutex_unlock(&conn->ep_mutex);
> +
>  		/*
>  		 * Figure out if it was the kernel or userspace initiating this.
>  		 */
> @@ -2984,16 +3011,7 @@ static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
>  	}
>  
>  	mutex_lock(&conn->ep_mutex);
> -	/* Check if this was a conn error and the kernel took ownership */
> -	if (test_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags)) {
> -		ISCSI_DBG_TRANS_CONN(conn, "flush kernel conn cleanup.\n");
> -		mutex_unlock(&conn->ep_mutex);
> -
> -		flush_work(&conn->cleanup_work);
> -		goto put_ep;
> -	}
> -
> -	iscsi_ep_disconnect(conn, false);
> +	iscsi_if_disconnect_bound_ep(conn, ep, false);
>  	mutex_unlock(&conn->ep_mutex);
>  put_ep:
>  	iscsi_put_endpoint(ep);
> @@ -3704,16 +3722,6 @@ static int iscsi_if_transport_conn(struct iscsi_transport *transport,
>  
>  	switch (nlh->nlmsg_type) {
>  	case ISCSI_UEVENT_BIND_CONN:
> -		if (conn->ep) {
> -			/*
> -			 * For offload boot support where iscsid is restarted
> -			 * during the pivot root stage, the ep will be intact
> -			 * here when the new iscsid instance starts up and
> -			 * reconnects.
> -			 */
> -			iscsi_ep_disconnect(conn, true);
> -		}
> -
>  		session = iscsi_session_lookup(ev->u.b_conn.sid);
>  		if (!session) {
>  			err = -EINVAL;
> -- 
> 2.25.1
> 

