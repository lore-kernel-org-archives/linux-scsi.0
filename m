Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8250AC433F5
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Apr 2022 01:59:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240454AbiDICBN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Apr 2022 22:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbiDICBM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2022 22:01:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8D8CE4EDC8
        for <linux-scsi@vger.kernel.org>; Fri,  8 Apr 2022 18:59:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649469546;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=q/b/yHu4mKTEESadFMz+g60Zs5SmH6WdtS6fCTd+Cq8=;
        b=RhXtrHbc+NYgq2pTYktC5tUpDSPLOmnUv7izMwjeN3nx3j1gBRngmh8HSFep5Pd3+3AzAZ
        swuM5OJzYGJpvFD1GIjGVjxe4SlvwIT9q/CrRKyFIy302Qf0g/remRJV58wjlBNdcO40y8
        EYf+d1JYr30XZbeZt1fc8kuHY9u3rck=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-287-_OBYcE5hNH2xizSlfDlDSg-1; Fri, 08 Apr 2022 21:59:03 -0400
X-MC-Unique: _OBYcE5hNH2xizSlfDlDSg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DC518185A794;
        Sat,  9 Apr 2022 01:59:02 +0000 (UTC)
Received: from localhost (unknown [10.2.16.9])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EFF1C815B;
        Sat,  9 Apr 2022 01:59:01 +0000 (UTC)
Date:   Fri, 8 Apr 2022 18:59:00 -0700
From:   Chris Leech <cleech@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     skashyap@marvell.com, lduncan@suse.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Subject: Re: [PATCH 08/10] scsi: iscsi: Fix nop handling during conn recovery
Message-ID: <YlDoZMSvD5X+55Mh@localhost>
Mail-Followup-To: Mike Christie <michael.christie@oracle.com>,
        skashyap@marvell.com, lduncan@suse.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
References: <20220408001314.5014-1-michael.christie@oracle.com>
 <20220408001314.5014-9-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220408001314.5014-9-michael.christie@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Apr 07, 2022 at 07:13:12PM -0500, Mike Christie wrote:
> If a offload driver doesn't use the xmit workqueue, then when we are
> doing ep_disconnect libiscsi can still inject PDUs to the driver. This
> adds a check for if the connection is bound before trying to inject PDUs.
> 
> Reviewed-by: Lee Duncan <lduncan@suse.com>
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/libiscsi.c | 7 ++++++-
>  include/scsi/libiscsi.h | 2 +-
>  2 files changed, 7 insertions(+), 2 deletions(-)

Reviewed-by: Chris Leech <cleech@redhat.com>
 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 5e7bd5a3b430..0bf8cf8585bb 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -678,7 +678,8 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
>  	struct iscsi_task *task;
>  	itt_t itt;
>  
> -	if (session->state == ISCSI_STATE_TERMINATE)
> +	if (session->state == ISCSI_STATE_TERMINATE ||
> +	    !test_bit(ISCSI_CONN_FLAG_BOUND, &conn->flags))
>  		return NULL;
>  
>  	if (opcode == ISCSI_OP_LOGIN || opcode == ISCSI_OP_TEXT) {
> @@ -2214,6 +2215,8 @@ void iscsi_conn_unbind(struct iscsi_cls_conn *cls_conn, bool is_active)
>  	iscsi_suspend_tx(conn);
>  
>  	spin_lock_bh(&session->frwd_lock);
> +	clear_bit(ISCSI_CONN_FLAG_BOUND, &conn->flags);
> +
>  	if (!is_active) {
>  		/*
>  		 * if logout timed out before userspace could even send a PDU
> @@ -3318,6 +3321,8 @@ int iscsi_conn_bind(struct iscsi_cls_session *cls_session,
>  	spin_lock_bh(&session->frwd_lock);
>  	if (is_leading)
>  		session->leadconn = conn;
> +
> +	set_bit(ISCSI_CONN_FLAG_BOUND, &conn->flags);
>  	spin_unlock_bh(&session->frwd_lock);
>  
>  	/*
> diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
> index 84086c240228..d0a24779c52d 100644
> --- a/include/scsi/libiscsi.h
> +++ b/include/scsi/libiscsi.h
> @@ -56,7 +56,7 @@ enum {
>  /* Connection flags */
>  #define ISCSI_CONN_FLAG_SUSPEND_TX	BIT(0)
>  #define ISCSI_CONN_FLAG_SUSPEND_RX	BIT(1)
> -
> +#define ISCSI_CONN_FLAG_BOUND		BIT(2)
>  
>  #define ISCSI_ITT_MASK			0x1fff
>  #define ISCSI_TOTAL_CMDS_MAX		4096
> -- 
> 2.25.1
> 

