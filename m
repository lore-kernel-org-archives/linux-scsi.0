Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67205C433EF
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Apr 2022 01:42:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235129AbiDIBoK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Apr 2022 21:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232954AbiDIBoJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2022 21:44:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DCB25BF7A
        for <linux-scsi@vger.kernel.org>; Fri,  8 Apr 2022 18:42:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649468523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=p4hLRJTnPZc1+qWe7WhVv0WGx88GIA986brieFfwHys=;
        b=HJSoaK32MvTszM6V4sy9olNsbW56wkYfFdwfBzDSnNzOqol5c2P6umWwv3iB381DLMTQa2
        2movIqCxAW4UcZn9Q00SegZ06y7Gzv8nXrQ7FdicgAKZPJ4fYKBLSDOcD4B3K3bo2S/DW0
        ZhZpzDQpczplNljdhNivBmwnisHjWOg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-252-TkT_RgbQNGa3oLmZ_Z4Znw-1; Fri, 08 Apr 2022 21:41:59 -0400
X-MC-Unique: TkT_RgbQNGa3oLmZ_Z4Znw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 207B2801585;
        Sat,  9 Apr 2022 01:41:59 +0000 (UTC)
Received: from localhost (unknown [10.2.16.9])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2E26E40BB37;
        Sat,  9 Apr 2022 01:41:58 +0000 (UTC)
Date:   Fri, 8 Apr 2022 18:41:56 -0700
From:   Chris Leech <cleech@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     skashyap@marvell.com, lduncan@suse.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Subject: Re: [PATCH 04/10] scsi: iscsi: Fix endpoint reuse regression
Message-ID: <YlDkZLEQQXXHynux@localhost>
Mail-Followup-To: Mike Christie <michael.christie@oracle.com>,
        skashyap@marvell.com, lduncan@suse.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
References: <20220408001314.5014-1-michael.christie@oracle.com>
 <20220408001314.5014-5-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220408001314.5014-5-michael.christie@oracle.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Apr 07, 2022 at 07:13:08PM -0500, Mike Christie wrote:
> This patch fixes a bug where when using iscsi offload we can free a
> endpoint while userspace still thinks it's active. That then causes the
> endpoint ID to be reused for a new connection's endpoint while userspace
> still thinks the ID is for the original connection. Userspace will then
> end up disconnecting a running connection's endpoint or trying to bind
> to another connection's endpoint.
> 
> This bug is a regression added in:
> 
> Commit 23d6fefbb3f6 ("scsi: iscsi: Fix in-kernel conn failure handling")
> 
> where we added a in kernel ep_disconnect call to fix a bug in:
> 
> Commit 0ab710458da1 ("scsi: iscsi: Perform connection failure entirely in
> kernel space")
> 
> where we would call stop_conn without having done ep_disconnect. This
> early ep_disconnect call will then free the endpoint and it's ID while
> userspace still thinks the ID is valid.
> 
> This patch fixes the early release of the ID by having the in kernel
> recovery code keep a reference to the endpoint until userspace has called
> into the kernel to finish cleaning up the endpoint/connection. It requires
> the previous patch "scsi: iscsi: Release endpoint ID when its freed."
> which moved the freeing of the ID until when the endpoint is released.
> 
> Fixes: 23d6fefbb3f6 ("scsi: iscsi: Fix in-kernel conn failure handling")
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/scsi_transport_iscsi.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
 
Reviewed-by: Chris Leech <cleech@redhat.com>

> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index 1fc7c6bfbd67..f200da049f3b 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -2247,7 +2247,11 @@ static void iscsi_if_disconnect_bound_ep(struct iscsi_cls_conn *conn,
>  		mutex_unlock(&conn->ep_mutex);
>  
>  		flush_work(&conn->cleanup_work);
> -
> +		/*
> +		 * Userspace is now done with the EP so we can release the ref
> +		 * iscsi_cleanup_conn_work_fn took.
> +		 */
> +		iscsi_put_endpoint(ep);
>  		mutex_lock(&conn->ep_mutex);
>  	}
>  }
> @@ -2322,6 +2326,12 @@ static void iscsi_cleanup_conn_work_fn(struct work_struct *work)
>  		return;
>  	}
>  
> +	/*
> +	 * Get a ref to the ep, so we don't release its ID until after
> +	 * userspace is done referencing it in iscsi_if_disconnect_bound_ep.
> +	 */
> +	if (conn->ep)
> +		get_device(&conn->ep->dev);
>  	iscsi_ep_disconnect(conn, false);
>  
>  	if (system_state != SYSTEM_RUNNING) {
> -- 
> 2.25.1
> 

