Return-Path: <SRS0=a792=EB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D346C55178
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 11:46:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9CEA22281
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 11:46:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EBG3H25l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1773970AbgJZLqD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Oct 2020 07:46:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35055 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1773967AbgJZLqB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Oct 2020 07:46:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603712760;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PiuAFPNzdHKP4l1AGuB4exoFzewqgmOM07ixz10GaXs=;
        b=EBG3H25lJ1vYOaJIRvmD0BWzNtdNOi+TaDm1v9o+jb+mgJprfeF7u1GT5FZSW3Hcg+qS7P
        TfGXXVNwsJ7caEFUEUk9npocgPbrx1KfVuMwGFEbWPuDOufPQC1Lb3EwjJtzs1XR+kl6ro
        R8NjC2BGFOrsv7TWXws0p8N5/MShR5o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-267-B-KjkNOMNoSZbhmLMEeltw-1; Mon, 26 Oct 2020 07:45:58 -0400
X-MC-Unique: B-KjkNOMNoSZbhmLMEeltw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 293D710866A2;
        Mon, 26 Oct 2020 11:45:57 +0000 (UTC)
Received: from ovpn-112-111.phx2.redhat.com (ovpn-112-111.phx2.redhat.com [10.3.112.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 83E4910013D0;
        Mon, 26 Oct 2020 11:45:56 +0000 (UTC)
Message-ID: <8d29df3e8fc04a781191092f65a4e7ca45ce3d63.camel@redhat.com>
Subject: Re: [patch v4 2/5] scsi: Added a new error code in scsi.h
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        hare@suse.de
Cc:     jsmart2021@gmail.com, mkumar@redhat.com
Date:   Mon, 26 Oct 2020 07:45:55 -0400
In-Reply-To: <1603370091-9337-3-git-send-email-muneendra.kumar@broadcom.com>
References: <1603370091-9337-1-git-send-email-muneendra.kumar@broadcom.com>
         <1603370091-9337-3-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Don't you need to add the DID_TRANSPORT_MARGINAL case to
scsi_decide_disposition() ?   DID_TRANSPORT_FAILFAST returns
SUCCESS but the default case returns ERROR.

-Ewan


On Thu, 2020-10-22 at 18:04 +0530, Muneendra wrote:
> Added a new error code DID_TRANSPORT_MARGINAL to handle marginal
> errors in scsi.h
> 
> Clearing the SCMD_NORETRIES_ABORT bit in state flag before
> blk_mq_start_request
> 
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
> 
> ---
> v4:
> No change
> 
> v3:
> Rearranged the patch by merging second hunk of the previous(v2)
> patch3 to this patch
> 
> v2:
> Newpatch
> ---
>  drivers/scsi/scsi_lib.c | 1 +
>  include/scsi/scsi.h     | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 1a2e9bab42ef..2b5dea07498e 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1660,6 +1660,7 @@ static blk_status_t scsi_queue_rq(struct
> blk_mq_hw_ctx *hctx,
>  		req->rq_flags |= RQF_DONTPREP;
>  	} else {
>  		clear_bit(SCMD_STATE_COMPLETE, &cmd->state);
> +		clear_bit(SCMD_NORETRIES_ABORT, &cmd->state);
>  	}
>  
>  	cmd->flags &= SCMD_PRESERVED_FLAGS;
> diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
> index 5339baadc082..5b287ad8b727 100644
> --- a/include/scsi/scsi.h
> +++ b/include/scsi/scsi.h
> @@ -159,6 +159,7 @@ static inline int scsi_is_wlun(u64 lun)
>  				 * paths might yield different results
> */
>  #define DID_ALLOC_FAILURE 0x12  /* Space allocation on the device
> failed */
>  #define DID_MEDIUM_ERROR  0x13  /* Medium error */
> +#define DID_TRANSPORT_MARGINAL 0x14 /* Transport marginal errors */
>  #define DRIVER_OK       0x00	/* Driver
> status                           */
>  
>  /*

