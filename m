Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FEFAC4320A
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Jul 2021 16:38:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6217560F00
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Jul 2021 16:38:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbhG3QiJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Jul 2021 12:38:09 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:46904 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbhG3QiH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Jul 2021 12:38:07 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C2E472026F;
        Fri, 30 Jul 2021 16:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1627663080; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S4rmQ0t6FOsVPyieg+nbFNJTk5NgyFjY1/w97IN97D8=;
        b=ZjOZWfcxS9KflllB1FF8GnFPGqczIyz5RdxnsytaRteG1+EWM+2WlyROWzBpSlUaFqKvFo
        6wKMLGAQZXRPulJFF+PzVQ8cMlmVeslBXOEPwkVSjCAaJjJyp13anX3NZHWsrAWaWe5rzz
        dDFb/xHXSTGDrSE+zYYVs175kSSDq8s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1627663080;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S4rmQ0t6FOsVPyieg+nbFNJTk5NgyFjY1/w97IN97D8=;
        b=69GHUABe+p+Us7ii6vPm1BN4apDLt6eE4NoSoyguBwxH01xP7OVpVmIEnpEcMHEjXE0HGr
        MhtsreQryxYCqmAQ==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 74CCA13806;
        Fri, 30 Jul 2021 16:38:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id QOp4GugqBGH6GwAAGKfGzw
        (envelope-from <ddiss@suse.de>); Fri, 30 Jul 2021 16:38:00 +0000
Date:   Fri, 30 Jul 2021 18:37:58 +0200
From:   David Disseldorp <ddiss@suse.de>
To:     Sergey Samoylenko <s.samoylenko@yadro.com>
Cc:     <martin.petersen@oracle.com>, <michael.christie@oracle.com>,
        <bvanassche@acm.org>, <target-devel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux@yadro.com>
Subject: Re: [v2 1/2] target: allows backend drivers to fail with specific
 sense codes
Message-ID: <20210730183758.6efb3f95@suse.de>
In-Reply-To: <20210726151646.32631-2-s.samoylenko@yadro.com>
References: <20210726151646.32631-1-s.samoylenko@yadro.com>
        <20210726151646.32631-2-s.samoylenko@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Sergey,

On Mon, 26 Jul 2021 18:16:45 +0300, Sergey Samoylenko wrote:

> Currently, backend drivers can fail IO with
> SAM_STAT_CHECK_CONDITION which gets us
> TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE. The patch adds
> a new helper that allows backend drivers to fail with
> specific sense codes.
> 
> This is based on a patch from Mike Christie <michael.christie@oracle.com>.

This looks good and works for me, but I have one comment...

> Cc: Mike Christie <michael.christie@oracle.com>
> Cc: David Disseldorp <ddiss@suse.de>
> [ Moved target_complete_cmd_with_sense() helper to mainline ]
> Signed-off-by: Sergey Samoylenko <s.samoylenko@yadro.com>
> ---
>  drivers/target/target_core_transport.c | 21 ++++++++++++++++++---
>  include/target/target_core_backend.h   |  1 +
>  include/target/target_core_base.h      |  2 ++
>  3 files changed, 21 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 26ceabe34de5..d2a2892bda9c 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -736,8 +736,7 @@ static void target_complete_failure_work(struct work_struct *work)
>  {
>  	struct se_cmd *cmd = container_of(work, struct se_cmd, work);
>  
> -	transport_generic_request_failure(cmd,
> -			TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE);
> +	transport_generic_request_failure(cmd, cmd->sense_reason);
>  }
>  
>  /*
> @@ -855,7 +854,8 @@ static bool target_cmd_interrupted(struct se_cmd *cmd)
>  }
>  
>  /* May be called from interrupt context so must not sleep. */
> -void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
> +static void __target_complete_cmd(struct se_cmd *cmd, u8 scsi_status,
> +				  sense_reason_t sense_reason)
>  {
>  	struct se_wwn *wwn = cmd->se_sess->se_tpg->se_tpg_wwn;
>  	int success, cpu;
> @@ -865,6 +865,7 @@ void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
>  		return;
>  
>  	cmd->scsi_status = scsi_status;
> +	cmd->sense_reason = sense_reason;
>  
>  	spin_lock_irqsave(&cmd->t_state_lock, flags);
>  	switch (cmd->scsi_status) {
> @@ -893,8 +894,22 @@ void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
>  
>  	queue_work_on(cpu, target_completion_wq, &cmd->work);
>  }
> +
> +void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
> +{
> +	__target_complete_cmd(cmd, scsi_status, scsi_status ?
> +			      TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE :
> +			      TCM_NO_SENSE);
> +}
>  EXPORT_SYMBOL(target_complete_cmd);
>  
> +void target_complete_cmd_with_sense(struct se_cmd *cmd,
> +				    sense_reason_t sense_reason)
> +{
> +	__target_complete_cmd(cmd, SAM_STAT_CHECK_CONDITION, sense_reason);
> +}
> +EXPORT_SYMBOL(target_complete_cmd_with_sense);
> +

It's a little unclear from the function prototype that this actually
fails the command with SAM_STAT_CHECK_CONDITION. I could imagine people
erroneously calling target_complete_cmd_with_sense(cmd, TCM_NO_SENSE)
and expecting success.
I think it might be a bit clearer if you just export
__target_complete_cmd() as target_complete_cmd_with_sense() with all
three parameters and leave it up to the caller to flag
CHECK_CONDITION.

Cheers, David
