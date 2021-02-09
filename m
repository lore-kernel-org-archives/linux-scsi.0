Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4863DC433DB
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 14:33:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 046DE64E6C
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 14:33:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232114AbhBIOdF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 09:33:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33386 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232058AbhBIOcl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2021 09:32:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612881074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xsQHaAcfnczvRDCUHJxfE+zH2d4fNlt8hUE1bnnjqN8=;
        b=RtPC4zAeAERWX4Ooj9Rb5QM83EyzrI32JXUA+oo0MWXXCfs7Lc7efOhcNkF95VbcVbtO4m
        VXiiIuHeE4u/EbTt9CgpWH3Z9Tr71NmExn2pKNGGBnKoevpWVXDqDi2HQY89hWyWOJErpj
        0wuDUlrq3dfKhcyVM2/jtHSBCtvx0Ro=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-193-9VSjKX1sM7a9ZF701iGYsw-1; Tue, 09 Feb 2021 09:31:12 -0500
X-MC-Unique: 9VSjKX1sM7a9ZF701iGYsw-1
Received: by mail-qt1-f199.google.com with SMTP id l1so3309455qtv.2
        for <linux-scsi@vger.kernel.org>; Tue, 09 Feb 2021 06:31:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xsQHaAcfnczvRDCUHJxfE+zH2d4fNlt8hUE1bnnjqN8=;
        b=LA6jZIzpU7bfsL/PcisL13rt4RAHz65+C74T6fa6ZxF0FDbHd/r2ave6w4hVt2GWMh
         4ldTFcwlZUbyck6eKHPEzlp1mf+bA/Z6j2/e190iSsOCANqm4bf9/Mi0zzhyyF5/qPKh
         kwt1QYnHm66F/CyZdGXb50aKAWm9+osYsKr2rbIQpE3NXwhFaYBtdPwwOx/jz/J6/GnL
         dvVafQkCDEHJY63MX6N4HTLpLWj1TSW/pJ8lKVfNxu1jERfoi/vBylOihcmOHvK2TX3p
         w2R4y2HHYI/XiRQPyC5Ffbbef5p7uQ/GUe091v2+VGag13nNDFqjYTSBkRQFEkqWAFhV
         knXw==
X-Gm-Message-State: AOAM530uqYSRrsltKT4zSi0CQpOXZpSUQtnVIJY8pocAJareQTNQk4Kf
        lOnDOQoxMcGXz9WTZRjZUUgsAsHvfKV8Iig2aXAUFIa/pq4BqGySiKUym7ABKu8de9+IzLlrnHq
        RKOWJLqvDeEZ1D4JRbM5hkw==
X-Received: by 2002:a05:6214:b2c:: with SMTP id w12mr20585109qvj.54.1612881071269;
        Tue, 09 Feb 2021 06:31:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJytrckkQnLMtpUEe78SbejAFVuMPxI/xviDVxLBRF5J76dOjqRW7EojZZtJldY2dwHIjJpUeQ==
X-Received: by 2002:a05:6214:b2c:: with SMTP id w12mr20585090qvj.54.1612881071050;
        Tue, 09 Feb 2021 06:31:11 -0800 (PST)
Received: from loberhel7laptop ([2600:6c64:4e7f:cee0:ccad:a4ca:9a69:d8bc])
        by smtp.gmail.com with ESMTPSA id z139sm4817581qkb.0.2021.02.09.06.31.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Feb 2021 06:31:10 -0800 (PST)
Message-ID: <679c61cf1dad2848edac6f7d6490ad6587f0ada3.camel@redhat.com>
Subject: Re: [PATCH 13/13] target: flush submission work during TMR
 processing
From:   Laurence Oberman <loberman@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>,
        Chaitanya.Kulkarni@wdc.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
Date:   Tue, 09 Feb 2021 09:31:04 -0500
In-Reply-To: <20210209123845.4856-14-michael.christie@oracle.com>
References: <20210209123845.4856-1-michael.christie@oracle.com>
         <20210209123845.4856-14-michael.christie@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-02-09 at 06:38 -0600, Mike Christie wrote:
> If a cmd is on the submission workqueue then the TMR code will
> miss it, and end up returning task not found or success for
> lun resets. The fabric driver might then tell the initiator that
> the running cmds have been handled when they are about to run.
> 
> This adds a cancel when we are processing TMRs.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/target/target_core_tmr.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/target/target_core_tmr.c
> b/drivers/target/target_core_tmr.c
> index 7347285471fa..9b7f159f9341 100644
> --- a/drivers/target/target_core_tmr.c
> +++ b/drivers/target/target_core_tmr.c
> @@ -124,6 +124,8 @@ void core_tmr_abort_task(
>  	int i;
>  
>  	for (i = 0; i < dev->queue_cnt; i++) {
> +		cancel_work_sync(&dev->queues[i].sq.work);
> +
>  		spin_lock_irqsave(&dev->queues[i].lock, flags);
>  		list_for_each_entry_safe(se_cmd, next, &dev-
> >queues[i].state_list,
>  					 state_list) {
> @@ -302,6 +304,8 @@ static void core_tmr_drain_state_list(
>  	 * in the Control Mode Page.
>  	 */
>  	for (i = 0; i < dev->queue_cnt; i++) {
> +		cancel_work_sync(&dev->queues[i].sq.work);
> +
>  		spin_lock_irqsave(&dev->queues[i].lock, flags);
>  		list_for_each_entry_safe(cmd, next, &dev-
> >queues[i].state_list,
>  	


> 				 state_list) {

Hello Mike
Thanks for these
This one in particular is the one that I think will help our case. I
will pull all of these and test later this week as a bundle.

Many Thanks
Laurence Oberman

