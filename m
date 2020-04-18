Return-Path: <SRS0=0GAJ=6C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF39DC2BB1D
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Apr 2020 02:42:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2314221E9
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Apr 2020 02:42:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U4avTxzs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725849AbgDRCmU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Apr 2020 22:42:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48500 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725320AbgDRCmU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2020 22:42:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587177738;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DBh+Ri5pOk30fNT8I6F8lrYkO/4dwNKjYBq3br2f5kM=;
        b=U4avTxzsd9rRVPIKPLyTTTMrkgirHlBRTaOskITQA1avCKzPY9zdRBX8NUg7QPkFartUVR
        br3YyCzOpObC8tPLmk4jd7tUmV2KoawPRmJUXO7S3khuuzBUbnyXU6pKUJZ8eSgIO8VLeZ
        yMm02w+72s6Wa2VP9KbxhmRv/VzNohM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-6Qo4JwthPh2Byv35jY2YdQ-1; Fri, 17 Apr 2020 22:42:16 -0400
X-MC-Unique: 6Qo4JwthPh2Byv35jY2YdQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B85A613FB;
        Sat, 18 Apr 2020 02:42:14 +0000 (UTC)
Received: from T590 (ovpn-8-23.pek2.redhat.com [10.72.8.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 612E0118F4D;
        Sat, 18 Apr 2020 02:42:03 +0000 (UTC)
Date:   Sat, 18 Apr 2020 10:41:58 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@lst.de, bvanassche@acm.org, hare@suse.de,
        mikelley@microsoft.com, longli@microsoft.com
Subject: Re: [PATCH] scsi: core: Allow the state change from SDEV_QUIESCE to
 SDEV_BLOCK
Message-ID: <20200418024158.GB17090@T590>
References: <1587170445-50013-1-git-send-email-decui@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1587170445-50013-1-git-send-email-decui@microsoft.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Apr 17, 2020 at 05:40:45PM -0700, Dexuan Cui wrote:
> The APIs scsi_host_block()/scsi_host_unblock() are recently added by:
> 2bb955840c1d ("scsi: core: add scsi_host_(block,unblock) helper function")
> and so far the APIs are only used by:
> 3d3ca53b1639 ("scsi: aacraid: use scsi_host_(block,unblock) to block I/O")
> 
> However, from reading the code, I think the APIs don't really work for
> aacraid, because, in the resume path of hibernation, when aac_suspend() ->
> scsi_host_block() is called, scsi_device_quiesce() has set the state to
> SDEV_QUIESCE, so aac_suspend() -> scsi_host_block() returns -EINVAL.
> 
> Fix the issue by allowing the state change.
> 
> Fixes: 2bb955840c1d ("scsi: core: add scsi_host_(block,unblock) helper function")
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> ---
>  drivers/scsi/scsi_lib.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 47835c4b4ee0..06c260f6cdae 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -2284,6 +2284,7 @@ scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
>  		switch (oldstate) {
>  		case SDEV_RUNNING:
>  		case SDEV_CREATED_BLOCK:
> +		case SDEV_QUIESCE:
>  		case SDEV_OFFLINE:
>  			break;
>  		default:

Looks reasonable because SDEV_BLOCK is one more strict state than
QEIESCE, so:

Reviewed-by: Ming Lei <ming.lei@redha.com>


Thanks,
Ming

