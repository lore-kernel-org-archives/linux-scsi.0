Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69497C2D0E4
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Nov 2020 19:48:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07BD420721
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Nov 2020 19:48:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Tz0ptFKO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730542AbgKWTsq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Nov 2020 14:48:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34030 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728576AbgKWTsq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Nov 2020 14:48:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606160925;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Il1q7XPRKlOMB1Jij0ocrRezs3d5qlvd8/Ls8BRwiYI=;
        b=Tz0ptFKOtrfLR6Puse60BRiU34apyiG7YUH71FmSiV6XF8P9s+3CtiMLBrKMuTsgDQm0+2
        ORZPRRCCn4Q/U0poyMEsXzWPHv3tk7Oel63eer9AC1RfkmgWFfs9lCoE/6SSBCwX0stVE2
        IPbiKq75wHsUcV/VwIJKwsZbTfOXfZw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-466-eBOgks8IO1mINhbAEtf_Dw-1; Mon, 23 Nov 2020 14:48:34 -0500
X-MC-Unique: eBOgks8IO1mINhbAEtf_Dw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 846BB1005E5C;
        Mon, 23 Nov 2020 19:48:19 +0000 (UTC)
Received: from ovpn-112-111.phx2.redhat.com (ovpn-112-111.phx2.redhat.com [10.3.112.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 11BF65C1BB;
        Mon, 23 Nov 2020 19:48:18 +0000 (UTC)
Message-ID: <758bd7858fdb83c6b695187f793555acbae5f5e4.camel@redhat.com>
Subject: Re: [PATCH v7 5/5] scsi:lpfc: Added support for eh_should_retry_cmd
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, mkumar@redhat.com
Date:   Mon, 23 Nov 2020 14:48:18 -0500
In-Reply-To: <1605070685-20945-6-git-send-email-muneendra.kumar@broadcom.com>
References: <1605070685-20945-1-git-send-email-muneendra.kumar@broadcom.com>
         <1605070685-20945-6-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2020-11-11 at 10:28 +0530, Muneendra wrote:
> Added support to handle eh_should_retry_cmd in lpfc_template.
> 
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
> 
> ---
> v7:
> New patch
> ---
>  drivers/scsi/lpfc/lpfc_scsi.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c
> b/drivers/scsi/lpfc/lpfc_scsi.c
> index 4ffdfd2c8604..dbc80e6423ea 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.c
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> @@ -6040,6 +6040,7 @@ struct scsi_host_template lpfc_template = {
>  	.info			= lpfc_info,
>  	.queuecommand		= lpfc_queuecommand,
>  	.eh_timed_out		= fc_eh_timed_out,
> +	.eh_should_retry_cmd    = fc_eh_should_retry_cmd,
>  	.eh_abort_handler	= lpfc_abort_handler,
>  	.eh_device_reset_handler = lpfc_device_reset_handler,
>  	.eh_target_reset_handler = lpfc_target_reset_handler,

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


