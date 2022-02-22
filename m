Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9E7AC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Feb 2022 15:25:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233299AbiBVPZn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Feb 2022 10:25:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbiBVPZm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2022 10:25:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 19A0A162034
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 07:25:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645543516;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7EWLoxrSudNNybSZkDEnJg2OSKmcU0+FM4gscz4Y5AY=;
        b=clDlaAGPkjqTltas0LGR5oDTV9UgxGHyKAB84gpD9PLFP5nnkhgTzYP/HvAZ0WKi+YS4Pv
        ylSLEfRWx8LHlOSRe68mObc2LTwQ9NAszleL7SRCzZxT7v2wN6D8qPQFElcgpWwob8ZxE/
        yNBNzaTuQ7OM4xhoAFhK1qaCpqLegfo=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-501-UPkob4rHMcC3LlcRs1drzw-1; Tue, 22 Feb 2022 10:25:14 -0500
X-MC-Unique: UPkob4rHMcC3LlcRs1drzw-1
Received: by mail-qv1-f72.google.com with SMTP id gi11-20020a056214248b00b0042c2cc3c1b9so21442479qvb.9
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 07:25:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7EWLoxrSudNNybSZkDEnJg2OSKmcU0+FM4gscz4Y5AY=;
        b=ihJ2UE5ia/BHYSc9ZbUHs6H9pwZB6mtEQiej1QplHREpBBvX4p/4FjJRHAXNc4AsXL
         rArVlDx7ibljpC13Eq4Gh41C4/dxOld9KEJYggMizIWNi3BPkJsH5MaZh1kLanCZFKlC
         CFca6Fe4BXqamVoB1kI4HV5apW2nS4MFDKnLrlZPHnmJbF56BI+Lz+YF+drcCEmHYdDY
         ogVDbuyNTxLw5+9wKYO757dQQUbEZ545wfuD7JrT7Arf/KD541kUrn4WyNUKH9n1sjdR
         5zudWdSjx3YnQPVqW+35JEBMHNHtQeR4hIBI0EAxmZAlh3dWipqQZfFri/YBKnbMw674
         DPFA==
X-Gm-Message-State: AOAM530PjIT/AjDEctM8B0oPkpTzaa6oWpmnpt0a0L6T3UdJZBuyqM17
        YUdAirZPu9uCY2RGQHH9mpaUYCZY/+MNARgNEPVd2qsTYECPaISOs3soqPdQZGyqNK8l0h90gVd
        ZDe1UpFmf9UM7X/Jv/K3Kug==
X-Received: by 2002:ad4:5c8d:0:b0:432:4bf6:47c3 with SMTP id o13-20020ad45c8d000000b004324bf647c3mr1500038qvh.54.1645543514210;
        Tue, 22 Feb 2022 07:25:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyJE2JG5FZVIMDGhiK41I4irnEb74zPKXdeQzARd1QyRCf2lr7/GY7Er7zgYT6MLa8op4vjYg==
X-Received: by 2002:ad4:5c8d:0:b0:432:4bf6:47c3 with SMTP id o13-20020ad45c8d000000b004324bf647c3mr1500000qvh.54.1645543513821;
        Tue, 22 Feb 2022 07:25:13 -0800 (PST)
Received: from loberhel ([2600:6c64:4e7f:cee0:729d:61b6:700c:6b56])
        by smtp.gmail.com with ESMTPSA id s5sm9008924qtn.35.2022.02.22.07.25.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Feb 2022 07:25:13 -0800 (PST)
Message-ID: <4fc5b114f106ac95c5b23b668be85adcedad8d8b.camel@redhat.com>
Subject: Re: [PATCH] scsi: mpt3sas: decrease potential frequency of
 scsi_dma_map errors
From:   Laurence Oberman <loberman@redhat.com>
To:     John Pittman <jpittman@redhat.com>, martin.petersen@oracle.com
Cc:     jejb@linux.ibm.com, suganath-prabu.subramani@broadcom.com,
        sreekanth.reddy@broadcom.com, sathya.prakash@broadcom.com,
        linux-scsi@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com,
        djeffery@redhat.com
Date:   Tue, 22 Feb 2022 10:25:12 -0500
In-Reply-To: <20220222150319.28397-1-jpittman@redhat.com>
References: <20220222150319.28397-1-jpittman@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2022-02-22 at 10:03 -0500, John Pittman wrote:
> When scsi_dma_map() fails by returning a sges_left value less than
> zero, the amount of logging can be extremely high.  In a recent
> end-user environment, 1200 messages per second were being sent to
> the log buffer.  This eventually overwhelmed the system and it
> stalled.  As the messages are almost all identical, use
> pr_err_ratelimited() instead of sdev_printk() to print the
> scsi_dma_map failure messages.
> 
> Signed-off-by: John Pittman <jpittman@redhat.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c | 15 ++++++---------
>  1 file changed, 6 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c
> b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index 511726f92d9a..ac9ccde6f3f8 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -2594,9 +2594,8 @@ _base_check_pcie_native_sgl(struct
> MPT3SAS_ADAPTER *ioc,
>  	/* Get the SG list pointer and info. */
>  	sges_left = scsi_dma_map(scmd);
>  	if (sges_left < 0) {
> -		sdev_printk(KERN_ERR, scmd->device,
> -			"scsi_dma_map failed: request for %d bytes!\n",
> -			scsi_bufflen(scmd));
> +		pr_err_ratelimited("sd %s: scsi_dma_map failed: request
> for %d bytes!\n",
> +			dev_name(&scmd->device->sdev_gendev),
> scsi_bufflen(scmd));
>  		return 1;
>  	}
>  
> @@ -2706,9 +2705,8 @@ _base_build_sg_scmd(struct MPT3SAS_ADAPTER
> *ioc,
>  	sg_scmd = scsi_sglist(scmd);
>  	sges_left = scsi_dma_map(scmd);
>  	if (sges_left < 0) {
> -		sdev_printk(KERN_ERR, scmd->device,
> -		 "scsi_dma_map failed: request for %d bytes!\n",
> -		 scsi_bufflen(scmd));
> +		pr_err_ratelimited("sd %s: scsi_dma_map failed: request
> for %d bytes!\n",
> +			dev_name(&scmd->device->sdev_gendev),
> scsi_bufflen(scmd));
>  		return -ENOMEM;
>  	}
>  
> @@ -2854,9 +2852,8 @@ _base_build_sg_scmd_ieee(struct MPT3SAS_ADAPTER
> *ioc,
>  	sg_scmd = scsi_sglist(scmd);
>  	sges_left = scsi_dma_map(scmd);
>  	if (sges_left < 0) {
> -		sdev_printk(KERN_ERR, scmd->device,
> -			"scsi_dma_map failed: request for %d bytes!\n",
> -			scsi_bufflen(scmd));
> +		pr_err_ratelimited("sd %s: scsi_dma_map failed: request
> for %d bytes!\n",
> +			dev_name(&scmd->device->sdev_gendev),
> scsi_bufflen(scmd));
>  		return -ENOMEM;
>  	}
>  
This high message rate triggered a double completion at a customer and
this patch will help prevent the issue of the latency causing the race
window for the double completion. This was triaged by David Jeffery

Reviewed-by: Laurence Oberman <loberman@redhat.com>

