Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BA6DC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 23:25:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDCD460C41
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 23:25:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235537AbhA0XZA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 18:25:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39205 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232390AbhA0W42 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Jan 2021 17:56:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611788102;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M8Db6OQTFMtJ9Vv1KMcnjVs7A6/Ib7/81Vec9f6LkSg=;
        b=JIi2YTGBLV695ynWEWFxisDaXX6xtA//HBhQzzWfFaWok9cigBYBswFaEHG5V/tUFVtPYI
        XJv14pKlQOGehwVCbO9y0b58cHomCrogoL8bTZ9UAZar5jhTp56rUC9/g3JWIwFGj1N1pZ
        AgcZIbZ82u9HgM62mYdhxHLMZZ+YLXw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-xAUwIh3PMouW2YoRpGRX0g-1; Wed, 27 Jan 2021 17:45:15 -0500
X-MC-Unique: xAUwIh3PMouW2YoRpGRX0g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5384C107ACE8;
        Wed, 27 Jan 2021 22:45:14 +0000 (UTC)
Received: from ovpn-113-224.phx2.redhat.com (ovpn-113-224.phx2.redhat.com [10.3.113.224])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 02B9E60BE5;
        Wed, 27 Jan 2021 22:45:13 +0000 (UTC)
Message-ID: <87fa97430ea20f45ac02124297cb0655dcdb70a6.camel@redhat.com>
Subject: Re: [PATCH] lpfc: Fix EEH encountering oops with nvme traffic
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Date:   Wed, 27 Jan 2021 17:45:13 -0500
In-Reply-To: <20210127221601.84878-1-jsmart2021@gmail.com>
References: <20210127221601.84878-1-jsmart2021@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-01-27 at 14:16 -0800, James Smart wrote:
> In testing, in a configuration with Redfish and native nvme multipath
> when an EEH is injected, a kernel oops is being encountered:
> (unreliable)
> lpfc_nvme_ls_req+0x328/0x720 [lpfc]
> __nvme_fc_send_ls_req.constprop.13+0x1d8/0x3d0 [nvme_fc]
> nvme_fc_create_association+0x224/0xd10 [nvme_fc]
> nvme_fc_reset_ctrl_work+0x110/0x154 [nvme_fc]
> process_one_work+0x304/0x5d
> 
> the nvme transport is issuing a Disconnect LS request, which the
> driver
> receives and tries to post but the work queue used by the driver is
> already being torn down by the eeh.
> 
> Fix by validating the validity of the work queue before proceeding
> with
> the LS transmit.
> 
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> ---
>  drivers/scsi/lpfc/lpfc_nvme.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_nvme.c
> b/drivers/scsi/lpfc/lpfc_nvme.c
> index 5e990f4c1ca6..4d819e52496a 100644
> --- a/drivers/scsi/lpfc/lpfc_nvme.c
> +++ b/drivers/scsi/lpfc/lpfc_nvme.c
> @@ -559,6 +559,9 @@ __lpfc_nvme_ls_req(struct lpfc_vport *vport,
> struct lpfc_nodelist *ndlp,
>  		return -ENODEV;
>  	}
>  
> +	if (!vport->phba->sli4_hba.nvmels_wq)
> +		return -ENOMEM;
> +
>  	/*
>  	 * there are two dma buf in the request, actually there is one
> and
>  	 * the second one is just the start address + cmd size.

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


