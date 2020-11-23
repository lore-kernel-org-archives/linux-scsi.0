Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81F99C63697
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Nov 2020 19:45:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25CE420721
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Nov 2020 19:45:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OihjVF6o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729369AbgKWTpT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Nov 2020 14:45:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26606 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728982AbgKWTpT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Nov 2020 14:45:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606160717;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KFQUV+1u2HWFBbfpIQY1enkhsu2djp7OdiLTdh6C90s=;
        b=OihjVF6oZtsN9X1TCWdFDSaY1dYmj2bVMYZH4qAxYsg5Hji7MQOA9SSABD7/TXPdMPOB8P
        iAh7KbIOuEXj/3UGpIvwEiCaQd0uQbx9LZKkYTJ2SQd9DBOioCgV3zuOys16hmU9MdLACS
        eMGpaNrMaLJc11ejk1hdxpNVJAgNbM8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-124-eVqjOZn_OHKahkmCo6ONOw-1; Mon, 23 Nov 2020 14:45:16 -0500
X-MC-Unique: eVqjOZn_OHKahkmCo6ONOw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 08D9881CAF9;
        Mon, 23 Nov 2020 19:45:15 +0000 (UTC)
Received: from ovpn-112-111.phx2.redhat.com (ovpn-112-111.phx2.redhat.com [10.3.112.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AD6D760873;
        Mon, 23 Nov 2020 19:45:14 +0000 (UTC)
Message-ID: <c4848c09f505db0433e64aba5de43fb008bd20b5.camel@redhat.com>
Subject: Re: [PATCH v7 1/5] scsi: Added a new error code
 DID_TRANSPORT_MARGINAL in scsi.h
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-scsi@vger.kernel.org
Date:   Mon, 23 Nov 2020 14:45:14 -0500
In-Reply-To: <1605070685-20945-2-git-send-email-muneendra.kumar@broadcom.com>
References: <1605070685-20945-1-git-send-email-muneendra.kumar@broadcom.com>
         <1605070685-20945-2-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2020-11-11 at 10:28 +0530, Muneendra wrote:
> Added a new error code DID_TRANSPORT_MARGINAL to handle marginal
> errors in scsi.h
> 
> Added a code in scsi_result_to_blk_status to translate
> a new error DID_TRANSPORT_MARGINAL to the corresponding blk_status_t
> i.e BLK_STS_TRANSPORT
> 
> Added DID_TRANSPORT_MARGINAL case to scsi_decide_disposition
> 
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
> 
> ---
> v7:
> Rearranged the patch by moving the DID_TRANSPORT_MARGINAL
> and the changes with respect to the same to this patch
> from the previous patch2 in v6
> 
> Removed the previuos patch patch1 in v6 as in the
> current approach there is no need of this bit SCMD_NORETRIES_ABORT
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
>  drivers/scsi/scsi_error.c | 6 ++++++
>  drivers/scsi/scsi_lib.c   | 1 +
>  include/scsi/scsi.h       | 1 +
>  3 files changed, 8 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index f11f51e2465f..28056ee498b3 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -1861,6 +1861,12 @@ int scsi_decide_disposition(struct scsi_cmnd
> *scmd)
>  		 * the fast io fail tmo fired), so send IO directly
> upwards.
>  		 */
>  		return SUCCESS;
> +	case DID_TRANSPORT_MARGINAL:
> +		/*
> +		 * caller has decided not to do retries on
> +		 * abort success, so send IO directly upwards
> +		 */
> +		return SUCCESS;
>  	case DID_ERROR:
>  		if (msg_byte(scmd->result) == COMMAND_COMPLETE &&
>  		    status_byte(scmd->result) == RESERVATION_CONFLICT)
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 20a357563d3d..ce1e2adaca36 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -629,6 +629,7 @@ static blk_status_t
> scsi_result_to_blk_status(struct scsi_cmnd *cmd, int result)
>  			return BLK_STS_OK;
>  		return BLK_STS_IOERR;
>  	case DID_TRANSPORT_FAILFAST:
> +	case DID_TRANSPORT_MARGINAL:
>  		return BLK_STS_TRANSPORT;
>  	case DID_TARGET_FAILURE:
>  		set_host_byte(cmd, DID_OK);
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

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


