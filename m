Return-Path: <SRS0=1vUj=CL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA2F5C433E7
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 13:50:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B07D12078E
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 13:50:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbgIBNuv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Sep 2020 09:50:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:42590 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726871AbgIBNtr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 2 Sep 2020 09:49:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E96B9B609;
        Wed,  2 Sep 2020 13:49:45 +0000 (UTC)
Message-ID: <cbbd368e6e33af6e22c850192e69b27edd043efd.camel@suse.com>
Subject: Re: [PATCH v4 2/4] target: initialize LUN in
 transport_init_se_cmd().
From:   Martin Wilck <mwilck@suse.com>
To:     Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>,
        martin.petersen@oracle.com, michael.christie@oracle.com,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     shirley.ma@oracle.com, Hannes Reinecke <hare@suse.com>,
        Daniel Wagner <daniel.wagner@suse.com>,
        Arun Easi <aeasi@marvell.com>
Date:   Wed, 02 Sep 2020 15:49:43 +0200
In-Reply-To: <1591559913-8388-3-git-send-email-sudhakar.panneerselvam@oracle.com>
References: <1591559913-8388-1-git-send-email-sudhakar.panneerselvam@oracle.com>
         <1591559913-8388-3-git-send-email-sudhakar.panneerselvam@oracle.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.36.5 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Sudhakar,

On Sun, 2020-06-07 at 19:58 +0000, Sudhakar Panneerselvam wrote:
> Initialization of orig_fe_lun is moved to transport_init_se_cmd()
> from
> transport_lookup_cmd_lun(). This helps for the cases where the scsi
> request
> fails before the call to transport_lookup_cmd_lun() so that
> trace_target_cmd_complete() can print the LUN information to the
> trace
> buffer. Due to this change, the lun parameter is removed from
> transport_lookup_cmd_lun() and transport_lookup_tmr_lun().
> 
> Signed-off-by: Sudhakar Panneerselvam <
> sudhakar.panneerselvam@oracle.com>
> ---
>  drivers/target/iscsi/iscsi_target.c    | 11 +++++------
>  drivers/target/target_core_device.c    | 19 ++++++++-----------
>  drivers/target/target_core_tmr.c       |  4 ++--
>  drivers/target/target_core_transport.c | 12 +++++++-----
>  drivers/target/target_core_xcopy.c     |  4 ++--
>  drivers/usb/gadget/function/f_tcm.c    |  6 ++++--
>  include/target/target_core_fabric.h    |  6 +++---
>  7 files changed, 31 insertions(+), 31 deletions(-)
> 
> [...]
> diff --git a/drivers/target/target_core_transport.c
> b/drivers/target/target_core_transport.c
> index f2f7c5b818cc..7ea77933e64d 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> [...]
> @@ -1790,7 +1792,7 @@ int target_submit_tmr(struct se_cmd *se_cmd,
> struct se_session *se_sess,
>  	BUG_ON(!se_tpg);
>  
>  	transport_init_se_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess,
> -			      0, DMA_NONE, TCM_SIMPLE_TAG, sense);
> +			      0, DMA_NONE, TCM_SIMPLE_TAG, sense,
> unpacked_lun);
>  	/*
>  	 * FIXME: Currently expect caller to handle se_cmd->se_tmr_req
>  	 * allocation failure.

Between this hunk and the next one in target_submit_tmr(), there
is this code:

        /*
         * If this is ABORT_TASK with no explicit fabric provided LUN,
         * go ahead and search active session tags for a match to figure
         * out unpacked_lun for the original se_cmd.
         */
        if (tm_type == TMR_ABORT_TASK && (flags & TARGET_SCF_LOOKUP_LUN_FROM_TAG)) {
                if (!target_lookup_lun_from_tag(se_sess, tag, &unpacked_lun))
                        goto failure;
        }

> @@ -1818,7 +1820,7 @@ int target_submit_tmr(struct se_cmd *se_cmd,
> struct se_session *se_sess,
>  			goto failure;
>  	}
>  
> -	ret = transport_lookup_tmr_lun(se_cmd, unpacked_lun);
> +	ret = transport_lookup_tmr_lun(se_cmd);
>  	if (ret)
>  		goto failure;
>  

AFAICS, your patch breaks the case where the above code is executed to
derive unpacked_lun from the tag. The updated value of unpacked_lun is 
never used. That would break aborts for the qla2xxx target.

Am I overlooking something? Can you please explain?

Regards
Martin


