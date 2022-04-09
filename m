Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEB9CC433EF
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Apr 2022 01:36:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235129AbiDIBiR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Apr 2022 21:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237880AbiDIBiO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2022 21:38:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8980C149255
        for <linux-scsi@vger.kernel.org>; Fri,  8 Apr 2022 18:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649468167;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T5yWU0dkajk/pTd3vH1/ot86+XHYd2EbPQdU9LG1UAM=;
        b=CBxzGo56S8sAftfM/syg0SMMknTqRpA3TnB2svJAAZacht7Rw6axI5WoPdy0wHxa9LvDhg
        fPS214aj+fg8Obe6oSY2nFbIN/JBXt44SoiwoIGUvNW4SbHEeV+YhNQoOxhBbp4Q/+nSX9
        bMTjOJKWHcr0zBR2gJjVEWSkbtAysAI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-552-TLsJQdiFNaeSlaUGE-Ixwg-1; Fri, 08 Apr 2022 21:36:03 -0400
X-MC-Unique: TLsJQdiFNaeSlaUGE-Ixwg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E8C72811E75;
        Sat,  9 Apr 2022 01:36:02 +0000 (UTC)
Received: from localhost (unknown [10.2.16.9])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 05A7640317B;
        Sat,  9 Apr 2022 01:36:01 +0000 (UTC)
Date:   Fri, 8 Apr 2022 18:36:00 -0700
From:   Chris Leech <cleech@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     skashyap@marvell.com, lduncan@suse.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Subject: Re: [PATCH 01/10] scsi: iscsi: Move iscsi_ep_disconnect
Message-ID: <YlDjAIJwTa7xBCms@localhost>
Mail-Followup-To: Mike Christie <michael.christie@oracle.com>,
        skashyap@marvell.com, lduncan@suse.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
References: <20220408001314.5014-1-michael.christie@oracle.com>
 <20220408001314.5014-2-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220408001314.5014-2-michael.christie@oracle.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Apr 07, 2022 at 07:13:05PM -0500, Mike Christie wrote:
> This patch moves iscsi_ep_disconnect so it can be called earlier in the
> next patch.

Reviewed-by: Chris Leech <cleech@redhat.com>
 
> Reviewed-by: Lee Duncan <lduncan@suse.com>
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/scsi_transport_iscsi.c | 38 ++++++++++++++---------------
>  1 file changed, 19 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index 27951ea05dd4..4e10457e3ab9 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -2217,6 +2217,25 @@ static void iscsi_stop_conn(struct iscsi_cls_conn *conn, int flag)
>  	ISCSI_DBG_TRANS_CONN(conn, "Stopping conn done.\n");
>  }
>  
> +static void iscsi_ep_disconnect(struct iscsi_cls_conn *conn, bool is_active)
> +{
> +	struct iscsi_cls_session *session = iscsi_conn_to_session(conn);
> +	struct iscsi_endpoint *ep;
> +
> +	ISCSI_DBG_TRANS_CONN(conn, "disconnect ep.\n");
> +	conn->state = ISCSI_CONN_FAILED;
> +
> +	if (!conn->ep || !session->transport->ep_disconnect)
> +		return;
> +
> +	ep = conn->ep;
> +	conn->ep = NULL;
> +
> +	session->transport->unbind_conn(conn, is_active);
> +	session->transport->ep_disconnect(ep);
> +	ISCSI_DBG_TRANS_CONN(conn, "disconnect ep done.\n");
> +}
> +
>  static int iscsi_if_stop_conn(struct iscsi_transport *transport,
>  			      struct iscsi_uevent *ev)
>  {
> @@ -2257,25 +2276,6 @@ static int iscsi_if_stop_conn(struct iscsi_transport *transport,
>  	return 0;
>  }
>  
> -static void iscsi_ep_disconnect(struct iscsi_cls_conn *conn, bool is_active)
> -{
> -	struct iscsi_cls_session *session = iscsi_conn_to_session(conn);
> -	struct iscsi_endpoint *ep;
> -
> -	ISCSI_DBG_TRANS_CONN(conn, "disconnect ep.\n");
> -	conn->state = ISCSI_CONN_FAILED;
> -
> -	if (!conn->ep || !session->transport->ep_disconnect)
> -		return;
> -
> -	ep = conn->ep;
> -	conn->ep = NULL;
> -
> -	session->transport->unbind_conn(conn, is_active);
> -	session->transport->ep_disconnect(ep);
> -	ISCSI_DBG_TRANS_CONN(conn, "disconnect ep done.\n");
> -}
> -
>  static void iscsi_cleanup_conn_work_fn(struct work_struct *work)
>  {
>  	struct iscsi_cls_conn *conn = container_of(work, struct iscsi_cls_conn,
> -- 
> 2.25.1
> 

