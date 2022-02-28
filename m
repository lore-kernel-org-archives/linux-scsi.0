Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E18EC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Feb 2022 20:08:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbiB1UIv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Feb 2022 15:08:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbiB1UIr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Feb 2022 15:08:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B8ED85D66C
        for <linux-scsi@vger.kernel.org>; Mon, 28 Feb 2022 12:08:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646078886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mkbvljvXcy8XPjyTH8Nma1est9IadsBkedXNrAPWRgk=;
        b=W0TpoRo4TzacBH9BODrqIXZW/bh/DOGJm9uCcATx1EDsTf1YHwDIXdROyyhtmcWID+ClOB
        N57/GxmI035vLkBsXGts3LyqGxt/r58xZH6SBT4Hh01xedFDoSCN+SfNdWdoKthtH+iB9q
        VhJJ/fnQ7mSCiKlu0cB7usWRkO6S8lc=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-538-DlLJcaOoNEiBKPL4exmj7A-1; Mon, 28 Feb 2022 15:08:05 -0500
X-MC-Unique: DlLJcaOoNEiBKPL4exmj7A-1
Received: by mail-qv1-f69.google.com with SMTP id fh12-20020a0562141a0c00b00432f7fe8804so5899870qvb.4
        for <linux-scsi@vger.kernel.org>; Mon, 28 Feb 2022 12:08:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mkbvljvXcy8XPjyTH8Nma1est9IadsBkedXNrAPWRgk=;
        b=plRhNsSfBnNpricM7c1RhzfGxJcRshwQoAyLfr9O3VoDPfLwJrjBv/Umfkc3oK7ieF
         xqPqKw7C2SK5jpHZk3De4iLlDJzxuBBucAWz+bdq1bzysPrvnbs1c3D3qCmCvicK+teL
         7jHbYp65qnPd5Q9+AuWqIuFwfEbQI35Ywux7FO5Rg2yRwZxKz+ZC+YVV0cb2AyQVpqVf
         T1p8MlaSYAU0o/eX/bT4c1lE/SducE2993on5xQdvYZyYZWfic2XdTgpQ5mYAVHiki3d
         K+MVl47WlUp7XqzMziDl9liAXsD7CRDgCkeTQt3R1KPG5KfrPrYne41e30F1cfvp86du
         U7Cg==
X-Gm-Message-State: AOAM5338oyY/LqEl4JneFVAE2A5Tsg/RBMtbfKbAskTcY2xBCzLNZeAd
        Hql09l3Ax781UZMeYWz+N3cvK3tRgdjhB3EWdjbNd8QRXMD74B3RXsOZP8fL6uo+fCcy2SGwF56
        wMaodRMndQEuA3qbzc9+zAw==
X-Received: by 2002:a05:622a:44a:b0:2de:50a6:93e8 with SMTP id o10-20020a05622a044a00b002de50a693e8mr17433735qtx.91.1646078884476;
        Mon, 28 Feb 2022 12:08:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzZJ3r+oUWzdMIMqbU+votAXZSYutWN6CfsLFgozBOqnLK+dtJ6iwm7RdrUkfgz6pdbYvBCLA==
X-Received: by 2002:a05:622a:44a:b0:2de:50a6:93e8 with SMTP id o10-20020a05622a044a00b002de50a693e8mr17433718qtx.91.1646078884260;
        Mon, 28 Feb 2022 12:08:04 -0800 (PST)
Received: from [192.168.0.14] (97-120-59-83.ptld.qwest.net. [97.120.59.83])
        by smtp.gmail.com with ESMTPSA id x12-20020ac85f0c000000b002de8931d4d6sm7549985qta.77.2022.02.28.12.08.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Feb 2022 12:08:03 -0800 (PST)
Message-ID: <c8c1c90a-5af6-282c-686a-3d35dab5ef6f@redhat.com>
Date:   Mon, 28 Feb 2022 12:08:01 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5/6] scsi: iscsi: Use the session workqueue for recovery.
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        mrangankar@marvell.com, njavali@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, lduncan@suse.com,
        liuzhengyuang521@gmail.com
References: <20220226230435.38733-1-michael.christie@oracle.com>
 <20220226230435.38733-6-michael.christie@oracle.com>
From:   Chris Leech <cleech@redhat.com>
In-Reply-To: <20220226230435.38733-6-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/26/22 3:04 PM, Mike Christie wrote:
> Use the session workqueue for recovery and unbinding. If there are delays
> during device blocking/cleanup then it will no longer affect other
> sessions.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/scsi_transport_iscsi.c | 20 ++++----------------
>  1 file changed, 4 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index ecb592a70e03..754277bec63a 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -87,7 +87,6 @@ struct iscsi_internal {
>  };
>  
>  static atomic_t iscsi_session_nr; /* sysfs session id for next new session */
> -static struct workqueue_struct *iscsi_eh_timer_workq;
>  
>  static struct workqueue_struct *iscsi_conn_cleanup_workq;
>  
> @@ -1913,7 +1912,7 @@ void iscsi_unblock_session(struct iscsi_cls_session *session)
>  	if (!cancel_work_sync(&session->block_work))
>  		cancel_delayed_work_sync(&session->recovery_work);
>  
> -	queue_work(iscsi_eh_timer_workq, &session->unblock_work);
> +	queue_work(session->workq, &session->unblock_work);
>  	/*
>  	 * Blocking the session can be done from any context so we only
>  	 * queue the block work. Make sure the unblock work has completed
> @@ -1937,14 +1936,14 @@ static void __iscsi_block_session(struct work_struct *work)
>  	scsi_target_block(&session->dev);
>  	ISCSI_DBG_TRANS_SESSION(session, "Completed SCSI target blocking\n");
>  	if (session->recovery_tmo >= 0)
> -		queue_delayed_work(iscsi_eh_timer_workq,
> +		queue_delayed_work(session->workq,
>  				   &session->recovery_work,
>  				   session->recovery_tmo * HZ);
>  }
>  
>  void iscsi_block_session(struct iscsi_cls_session *session)
>  {
> -	queue_work(iscsi_eh_timer_workq, &session->block_work);
> +	queue_work(session->workq, &session->block_work);
>  }
>  EXPORT_SYMBOL_GPL(iscsi_block_session);
>  
> @@ -4851,26 +4850,16 @@ static __init int iscsi_transport_init(void)
>  		goto unregister_flashnode_bus;
>  	}
>  
> -	iscsi_eh_timer_workq = alloc_workqueue("%s",
> -			WQ_SYSFS | __WQ_LEGACY | WQ_MEM_RECLAIM | WQ_UNBOUND,
> -			1, "iscsi_eh");
> -	if (!iscsi_eh_timer_workq) {
> -		err = -ENOMEM;
> -		goto release_nls;
> -	}
> -
>  	iscsi_conn_cleanup_workq = alloc_workqueue("%s",
>  			WQ_SYSFS | WQ_MEM_RECLAIM | WQ_UNBOUND, 0,
>  			"iscsi_conn_cleanup");
>  	if (!iscsi_conn_cleanup_workq) {
>  		err = -ENOMEM;
> -		goto destroy_wq;
> +		goto release_nls;
>  	}
>  
>  	return 0;
>  
> -destroy_wq:
> -	destroy_workqueue(iscsi_eh_timer_workq);
>  release_nls:
>  	netlink_kernel_release(nls);
>  unregister_flashnode_bus:
> @@ -4893,7 +4882,6 @@ static __init int iscsi_transport_init(void)
>  static void __exit iscsi_transport_exit(void)
>  {
>  	destroy_workqueue(iscsi_conn_cleanup_workq);
> -	destroy_workqueue(iscsi_eh_timer_workq);
>  	netlink_kernel_release(nls);
>  	bus_unregister(&iscsi_flashnode_bus);
>  	transport_class_unregister(&iscsi_connection_class);


Reviewed-by: Chris Leech <cleech@redhat.com>

