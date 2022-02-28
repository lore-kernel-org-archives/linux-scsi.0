Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A43F8C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Feb 2022 20:07:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbiB1UHn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Feb 2022 15:07:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbiB1UHm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Feb 2022 15:07:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 620134F449
        for <linux-scsi@vger.kernel.org>; Mon, 28 Feb 2022 12:07:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646078822;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tY2wuFkmpJR28gYvvnpGsXdKAYmLerpM8bc4gTLHqH4=;
        b=Xy6rU9aiZb/0vCzhmjN1ridho3WCS1RCU34mdvtmNKg+x9sQ9DLy6YDVPvE1j5sNLgDgnD
        wY2XuEwj3/DWm82UW0V9Xas/7pdyKyKW4N669vPDFctPT/Hcj5PJk7eWfWO7wb6RKVK604
        0APJ6+QDjuEMwfCnUlTI+ah6X8fpiyw=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-435-sDEzS0NgP6Wfs2pKdPba_Q-1; Mon, 28 Feb 2022 15:07:01 -0500
X-MC-Unique: sDEzS0NgP6Wfs2pKdPba_Q-1
Received: by mail-qk1-f197.google.com with SMTP id k23-20020a05620a139700b0062cda5c6cecso12278188qki.6
        for <linux-scsi@vger.kernel.org>; Mon, 28 Feb 2022 12:07:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=tY2wuFkmpJR28gYvvnpGsXdKAYmLerpM8bc4gTLHqH4=;
        b=fc0/BTXs+Isx0wql0z7dUloBMS053GZBDLtulGFIRsdvu7zVT4MPsdwxsEXl0Hd2Rc
         67/m1205Vv1+p1VlmEfYc8VBLA55LeeUn4N3O9oNUVzGgxYWXvgmFgxvhNM0Koww/0hX
         eXSO7SNhgB9QBU54wG1DU5M8f49PtDk2+ZDN08AuFBC79v33T9oR7DalHpg2tHBqOrqi
         tELNEVFmliPfCjc+OIt3MCBMRtceIZmZRfq9hyEClsdc9nORHQA5gFkbhZg38W2E0pfC
         msYfq/h+weLlIORbURpPS/FoODlALiLFbJB08QVhYug1GOsWonNeLau3Iz/Q211qLeWQ
         HWeQ==
X-Gm-Message-State: AOAM532rpertO+kYTOH59RJdR+h8tG0H4NGXoA3piP/64Tfv+mrV1CaP
        qa4rsv47lZEcmQc9RtVst0tckODqZ5+u7o2St7fw71bz0A0TsAsAAhCGuBqr4fZRiJUXKbhSsad
        TozbU3ycBihaz65dXEiKnow==
X-Received: by 2002:a0c:c3c6:0:b0:42c:17e4:9a75 with SMTP id p6-20020a0cc3c6000000b0042c17e49a75mr15052237qvi.124.1646078820779;
        Mon, 28 Feb 2022 12:07:00 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz6siDvNS5FVQJxqQnJsUN2z8HvNco5+5z4dwZ9N4CFo9LQ72klqgoOa33WXP8JR4C7UVx9Tg==
X-Received: by 2002:a0c:c3c6:0:b0:42c:17e4:9a75 with SMTP id p6-20020a0cc3c6000000b0042c17e49a75mr15052217qvi.124.1646078820381;
        Mon, 28 Feb 2022 12:07:00 -0800 (PST)
Received: from [192.168.0.14] (97-120-59-83.ptld.qwest.net. [97.120.59.83])
        by smtp.gmail.com with ESMTPSA id n7-20020a37bd07000000b0064934ed3004sm5455817qkf.132.2022.02.28.12.06.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Feb 2022 12:06:59 -0800 (PST)
Message-ID: <7681316e-a9a0-d997-a606-795e2db5bf37@redhat.com>
Date:   Mon, 28 Feb 2022 12:06:57 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 2/6] scsi: iscsi: Speed up session unblocking and removal.
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        mrangankar@marvell.com, njavali@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, lduncan@suse.com,
        liuzhengyuang521@gmail.com
References: <20220226230435.38733-1-michael.christie@oracle.com>
 <20220226230435.38733-3-michael.christie@oracle.com>
From:   Chris Leech <cleech@redhat.com>
In-Reply-To: <20220226230435.38733-3-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/26/22 3:04 PM, Mike Christie wrote:
> When the iscsi class was added upstream blocking a queue was fast because
> it just set some flag bits and didn't handle IO that was in the process
> of being sent to the driver. That's no longer the case so blocking a queue
> is expensive and we can end up with a backlog of blocks by the time we
> have relogged in and are trying to start the queues.
> 
> For the session unblock case, this has try to cancel the block and
> recovery work in case they are still queued so we can avoid unneeded queue
> manipulations. For removal we also now try to cancel all the recovery
> related works since a couple lines down we will set the session and device
> state so running those functions are not necessary.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/scsi_transport_iscsi.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index c58126e8cd88..732938f5436b 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -1944,7 +1944,8 @@ static void __iscsi_unblock_session(struct work_struct *work)
>   */
>  void iscsi_unblock_session(struct iscsi_cls_session *session)
>  {
> -	flush_work(&session->block_work);
> +	if (!cancel_work_sync(&session->block_work))
> +		cancel_delayed_work_sync(&session->recovery_work);
>  
>  	queue_work(iscsi_eh_timer_workq, &session->unblock_work);
>  	/*
> @@ -2177,9 +2178,9 @@ void iscsi_remove_session(struct iscsi_cls_session *session)
>  		list_del(&session->sess_list);
>  	spin_unlock_irqrestore(&sesslock, flags);
>  
> -	flush_work(&session->block_work);
> -	flush_work(&session->unblock_work);
> -	cancel_delayed_work_sync(&session->recovery_work);
> +	if (!cancel_work_sync(&session->block_work))
> +		cancel_delayed_work_sync(&session->recovery_work);
> +	cancel_work_sync(&session->unblock_work);
>  	/*
>  	 * If we are blocked let commands flow again. The lld or iscsi
>  	 * layer should set up the queuecommand to fail commands.


Reviewed-by: Chris Leech <cleech@redhat.com>

