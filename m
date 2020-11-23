Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97AD0C2D0E4
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Nov 2020 19:46:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29A5620721
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Nov 2020 19:46:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q7LSPlrM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729821AbgKWTp7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Nov 2020 14:45:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49851 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729111AbgKWTp7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Nov 2020 14:45:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606160757;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MJYZOSHHrpJKzJyZnhZUQkf2iObXOA+4Bcx2+C3VPYo=;
        b=Q7LSPlrMvmnvlhg5yZJEXy4Ry6Gnl3NDimgisbibLqwYAqPJfmPWkh4xIj+Z916w906IXC
        hqJZGijPpjf94ARfARFoax7+eT51ll50078XfnFEC1wW0m5Bun653/KdRzVGmRKu6cBcOp
        OEf/U5lVa26OljeofP73UBHbDshMrT0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-366-eCLobhEsMsihb0Y7nK7w-w-1; Mon, 23 Nov 2020 14:45:55 -0500
X-MC-Unique: eCLobhEsMsihb0Y7nK7w-w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D3B18049D6;
        Mon, 23 Nov 2020 19:45:54 +0000 (UTC)
Received: from ovpn-112-111.phx2.redhat.com (ovpn-112-111.phx2.redhat.com [10.3.112.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 500CC5D6DC;
        Mon, 23 Nov 2020 19:45:54 +0000 (UTC)
Message-ID: <33efe7f75f97aef4013f58c8c026f6d03a483906.camel@redhat.com>
Subject: Re: [PATCH v7 2/5] scsi: No retries on abort success
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-scsi@vger.kernel.org
Date:   Mon, 23 Nov 2020 14:45:53 -0500
In-Reply-To: <1605070685-20945-3-git-send-email-muneendra.kumar@broadcom.com>
References: <1605070685-20945-1-git-send-email-muneendra.kumar@broadcom.com>
         <1605070685-20945-3-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2020-11-11 at 10:28 +0530, Muneendra wrote:
> Added a new optional routine eh_should_retry_cmd
> in scsi_host_template that allows the transport to decide if a
> cmd is retryable.Return true if the transport is in a state the
> cmd should be retried on.
> 
> Added a new interface scsi_eh_should_retry_cmd which checks and
> calls the new routine eh_should_retry_cmd.
> 
> Made changes in scmd_eh_abort_handler and scsi_eh_flush_done_q which
> calls the scsi_eh_should_retry_cmd to check whether the
> command needs to be retried.
> 
> The above changes were done based on a patch by Mike Christie.
> 
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
> 
> ---
> v7:
> Added New routine in scsi_host_template to decide if a cmd is
> retryable instead of checking the same using  SCMD_NORETRIES_ABORT
> bit as the cmd retry part can be checked by validating the port
> state.
> 
> Moved the DID_TRANSPORT_MARGINAL changes to previous patch
> for reordering
> 
> v6:
> Rearranged the patch by merging second hunk of the patch2 in v5
> to this patch
> 
> v5:
> added the DID_TRANSPORT_MARGINAL case to
> scsi_decide_disposition
> v4:
> Modified the comments in the code appropriately
> 
> v3:
> Merged  first part of the previous patch(v2 patch3) with
> this patch.
> 
> v2:
> set the hostbyte as DID_TRANSPORT_MARGINAL instead of
> DID_TRANSPORT_FAILFAST.
> ---
>  drivers/scsi/scsi_error.c | 17 +++++++++++++++--
>  include/scsi/scsi_host.h  |  6 ++++++
>  2 files changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 28056ee498b3..1cdfa5a8ca09 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -124,6 +124,17 @@ static bool scsi_cmd_retry_allowed(struct
> scsi_cmnd *cmd)
>  	return ++cmd->retries <= cmd->allowed;
>  }
>  
> +static bool scsi_eh_should_retry_cmd(struct scsi_cmnd *cmd)
> +{
> +	struct scsi_device *sdev = cmd->device;
> +	struct Scsi_Host *host = sdev->host;
> +
> +	if (host->hostt->eh_should_retry_cmd)
> +		return  host->hostt->eh_should_retry_cmd(cmd);
> +
> +	return true;
> +}
> +
>  /**
>   * scmd_eh_abort_handler - Handle command aborts
>   * @work:	command to be aborted.
> @@ -159,7 +170,8 @@ scmd_eh_abort_handler(struct work_struct *work)
>  						    "eh timeout, not
> retrying "
>  						    "aborted
> command\n"));
>  			} else if (!scsi_noretry_cmd(scmd) &&
> -				   scsi_cmd_retry_allowed(scmd)) {
> +				   scsi_cmd_retry_allowed(scmd) &&
> +				scsi_eh_should_retry_cmd(scmd)) {
>  				SCSI_LOG_ERROR_RECOVERY(3,
>  					scmd_printk(KERN_WARNING, scmd,
>  						    "retry aborted
> command\n"));
> @@ -2111,7 +2123,8 @@ void scsi_eh_flush_done_q(struct list_head
> *done_q)
>  	list_for_each_entry_safe(scmd, next, done_q, eh_entry) {
>  		list_del_init(&scmd->eh_entry);
>  		if (scsi_device_online(scmd->device) &&
> -		    !scsi_noretry_cmd(scmd) &&
> scsi_cmd_retry_allowed(scmd)) {
> +		    !scsi_noretry_cmd(scmd) &&
> scsi_cmd_retry_allowed(scmd) &&
> +			scsi_eh_should_retry_cmd(scmd)) {
>  			SCSI_LOG_ERROR_RECOVERY(3,
>  				scmd_printk(KERN_INFO, scmd,
>  					     "%s: flush retry cmd\n",
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index 701f178b20ae..e30fd963b97d 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -314,6 +314,12 @@ struct scsi_host_template {
>  	 * Status: OPTIONAL
>  	 */
>  	enum blk_eh_timer_return (*eh_timed_out)(struct scsi_cmnd *);
> +	/*
> +	 * Optional routine that allows the transport to decide if a
> cmd
> +	 * is retryable. Return true if the transport is in a state the
> +	 * cmd should be retried on.
> +	 */
> +	bool (*eh_should_retry_cmd)(struct scsi_cmnd *scmd);
>  
>  	/* This is an optional routine that allows transport to
> initiate
>  	 * LLD adapter or firmware reset using sysfs attribute.

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


