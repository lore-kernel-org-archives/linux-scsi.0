Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A248EC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Feb 2022 20:06:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbiB1UHJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Feb 2022 15:07:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbiB1UHG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Feb 2022 15:07:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8E00B4BBA6
        for <linux-scsi@vger.kernel.org>; Mon, 28 Feb 2022 12:06:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646078784;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dQMJKjvnmYnFunMilAShMLK8B75BOippUXgb1Xv5vI4=;
        b=UoQjcvFULNVO9UOntTOjbjJNHK9Oii34iQ7Q8zQ3qNECgaIQyHRUkgyiIiSBkHX1YxQhPg
        n5otMTRXCuvcKZJ1nTtj1aMickUw0uC6v3VwThY6azzEJdwqr4ko0Yor/TI6YESAso+VNv
        UEdnoV6c8bD0h4FUWzOlpN0QAiSsXW8=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-38-Fe4Vl35FNwWJQUJcdoO4jw-1; Mon, 28 Feb 2022 15:06:21 -0500
X-MC-Unique: Fe4Vl35FNwWJQUJcdoO4jw-1
Received: by mail-qk1-f197.google.com with SMTP id u17-20020a05620a431100b004765c0dc33cso12236402qko.14
        for <linux-scsi@vger.kernel.org>; Mon, 28 Feb 2022 12:06:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dQMJKjvnmYnFunMilAShMLK8B75BOippUXgb1Xv5vI4=;
        b=dTiNGftxH5DOTIOqtz6brqlJPWbutyK2MJW/O+Gzj4EcJ/y1A/PG7igIe+DAFaHeg2
         Uvu2r44gM69SHBZGfyA+S30WJNI9fKV8Z9ZI1lHwXJVFX8hd37MXb6uypIcI7dNkrAeH
         OBP8P+44bJWUlKoUbRyeezI88nbjJySX4DII6I56mhb5tA0s3yDogDnaxS3EPgCtsiwg
         hFl7SSiVmkYdGIzilI1xni9PUZ+mR+j7oW9YBfwZPMXXse4p1XKdMsEikXlPCN6BknpC
         JMuSxsoTHLRAuyfySal558ZF3g5DZ8OZ17AvmWDN4ysQmpRcsCTs0Qghc0r8RX4QN0K0
         +0ag==
X-Gm-Message-State: AOAM531oRgXo9T74AncnS/5P5HbPzDS0oIgN9THjTXjPSBK5Um3tBMBu
        eJm5PZ/uWpVZ314ad8kUbht/B9NF8ImQmh63qzPeR2HTDlk9GHrjBglT0w8XX2LWCfPkZVR3ga/
        NWFSDXb4oULFHt3VAwyvP+w==
X-Received: by 2002:a05:6214:a8a:b0:430:8fbc:6be2 with SMTP id ev10-20020a0562140a8a00b004308fbc6be2mr15550984qvb.7.1646078781039;
        Mon, 28 Feb 2022 12:06:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzv/l5V6+aspgKzPPYNn/6mZxZxpc5NV2ZUlWrXVmqVoITHSQKq1Z/io3a7hCxknMhOy2O0ng==
X-Received: by 2002:a05:6214:a8a:b0:430:8fbc:6be2 with SMTP id ev10-20020a0562140a8a00b004308fbc6be2mr15550967qvb.7.1646078780836;
        Mon, 28 Feb 2022 12:06:20 -0800 (PST)
Received: from [192.168.0.14] (97-120-59-83.ptld.qwest.net. [97.120.59.83])
        by smtp.gmail.com with ESMTPSA id y17-20020a376411000000b006490deb56b2sm5427984qkb.1.2022.02.28.12.06.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Feb 2022 12:06:20 -0800 (PST)
Message-ID: <1cc496ed-a023-9a06-72eb-fc0fb98025e5@redhat.com>
Date:   Mon, 28 Feb 2022 12:06:18 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 1/6] scsi: iscsi: Fix recovery and ublocking race.
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        mrangankar@marvell.com, njavali@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, lduncan@suse.com,
        liuzhengyuang521@gmail.com
References: <20220226230435.38733-1-michael.christie@oracle.com>
 <20220226230435.38733-2-michael.christie@oracle.com>
From:   Chris Leech <cleech@redhat.com>
In-Reply-To: <20220226230435.38733-2-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/26/22 3:04 PM, Mike Christie wrote:
> If the user sets the iscsi_eh_timer_workq/iscsi_eh workqueue's max_active
> to greater than 1, the recovery_work could be running when
> __iscsi_unblock_session runs. The cancel_delayed_work will then not wait
> for the running work and we can race where we end up with the wrong
> session state and scsi_device state set.
> 
> This replaces the cancel_delayed_work with the sync version.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/scsi_transport_iscsi.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index 554b6f784223..c58126e8cd88 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -1917,11 +1917,8 @@ static void __iscsi_unblock_session(struct work_struct *work)
>  	unsigned long flags;
>  
>  	ISCSI_DBG_TRANS_SESSION(session, "Unblocking session\n");
> -	/*
> -	 * The recovery and unblock work get run from the same workqueue,
> -	 * so try to cancel it if it was going to run after this unblock.
> -	 */
> -	cancel_delayed_work(&session->recovery_work);
> +
> +	cancel_delayed_work_sync(&session->recovery_work);
>  	spin_lock_irqsave(&session->lock, flags);
>  	session->state = ISCSI_SESSION_LOGGED_IN;
>  	spin_unlock_irqrestore(&session->lock, flags);

Looks good to me,

Reviewed-by: Chris Leech <cleech@redhat.com>

