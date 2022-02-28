Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16593C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Feb 2022 20:07:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbiB1UI3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Feb 2022 15:08:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbiB1UIU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Feb 2022 15:08:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A554641615
        for <linux-scsi@vger.kernel.org>; Mon, 28 Feb 2022 12:07:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646078849;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7WhVAymOW5u4geXWTL+7J2PABA83HXRAHgOjG17an2M=;
        b=CENGGEbgeubbEG/Qba9Xz0fs6ChD8R8MaTm4neohi6bFMiLfLKY89AQUE2QIykkdElx8gl
        X1p1tU6w05Pw8PCQY6C8KQrAdxGS5ZRqTXNO33E3Xz4WuJxpZXeli3GPV6oV7Ne9Hd/d4i
        flQenBWhtNXgdI2a70yeGlbSQsFWfM0=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-157-RVqdSRYfMb6Pp-QevGVULA-1; Mon, 28 Feb 2022 15:07:28 -0500
X-MC-Unique: RVqdSRYfMb6Pp-QevGVULA-1
Received: by mail-qv1-f69.google.com with SMTP id x16-20020a0ce250000000b00432ec6eaf85so6248423qvl.15
        for <linux-scsi@vger.kernel.org>; Mon, 28 Feb 2022 12:07:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7WhVAymOW5u4geXWTL+7J2PABA83HXRAHgOjG17an2M=;
        b=gOLzJe5yjarTf9xQRJZLeOKhFTxwUNDGRXL9eDfhlXCZQQ7cRKvaZcCmn8kYPcfOw/
         +R5JinjTtkGExyYqVHH6vudqCgU2y8ah+FZbFihEeWzKF/PtF+0dWDgTYaSsH/HLbCgy
         lmUxsYugT3zhc73b0SXZd86nIcLWNTk39isjVHejXABEmK71ITBR0b6z9eyRUzGM/oat
         OYBrfJ37joHje/O6R2uQccDoOmJFdG8B+QXIztKv57inEpWfk+Q8AAM6Q2tfNjRfGHbQ
         U7RG7ka+e2bPNHezIkDxeqSUCLSAqJqXVerryWq3TSOg7lbxrRaTVsnGHsMXyUo/mNE7
         811A==
X-Gm-Message-State: AOAM531uLklBtIX/tQ0kmKJNsqyjQnNomfEPhQiy8ibF2pX8kqylvkPB
        fJWXpdC0paUxYAKWHNhS9NPHOLaQYE1bWTXI713f2XXHLxOiJxmv8O4QBa5pg146BFcIiqawndQ
        BRv5xamYjSpkhNismKRizcA==
X-Received: by 2002:a05:620a:8dd:b0:663:2d2e:41ab with SMTP id z29-20020a05620a08dd00b006632d2e41abmr1498383qkz.260.1646078847611;
        Mon, 28 Feb 2022 12:07:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxv1/qSd7YTqkuEaxKaY+dbsUPUNm4jVbao2rwRwDRienmiCkQG7ituf9+83a5LdQXdCmxLIw==
X-Received: by 2002:a05:620a:8dd:b0:663:2d2e:41ab with SMTP id z29-20020a05620a08dd00b006632d2e41abmr1498365qkz.260.1646078847311;
        Mon, 28 Feb 2022 12:07:27 -0800 (PST)
Received: from [192.168.0.14] (97-120-59-83.ptld.qwest.net. [97.120.59.83])
        by smtp.gmail.com with ESMTPSA id y16-20020a37e310000000b00648c706dda1sm5432977qki.6.2022.02.28.12.07.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Feb 2022 12:07:26 -0800 (PST)
Message-ID: <a34c4491-209b-dbe6-53b2-322de090efa6@redhat.com>
Date:   Mon, 28 Feb 2022 12:07:25 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 3/6] scsi: iscsi: Remove iscsi_scan_finished.
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        mrangankar@marvell.com, njavali@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, lduncan@suse.com,
        liuzhengyuang521@gmail.com
References: <20220226230435.38733-1-michael.christie@oracle.com>
 <20220226230435.38733-4-michael.christie@oracle.com>
From:   Chris Leech <cleech@redhat.com>
In-Reply-To: <20220226230435.38733-4-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/26/22 3:04 PM, Mike Christie wrote:
> qla4xxx does not use iscsi_scan_finished anymore so remove it.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/scsi_transport_iscsi.c | 39 +++--------------------------
>  include/scsi/scsi_transport_iscsi.h |  2 --
>  2 files changed, 4 insertions(+), 37 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index 732938f5436b..05cd4bca979e 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -1557,7 +1557,6 @@ static int iscsi_setup_host(struct transport_container *tc, struct device *dev,
>  	struct iscsi_cls_host *ihost = shost->shost_data;
>  
>  	memset(ihost, 0, sizeof(*ihost));
> -	atomic_set(&ihost->nr_scans, 0);
>  	mutex_init(&ihost->mutex);
>  
>  	iscsi_bsg_host_add(shost, ihost);
> @@ -1744,25 +1743,6 @@ void iscsi_host_for_each_session(struct Scsi_Host *shost,
>  }
>  EXPORT_SYMBOL_GPL(iscsi_host_for_each_session);
>  
> -/**
> - * iscsi_scan_finished - helper to report when running scans are done
> - * @shost: scsi host
> - * @time: scan run time
> - *
> - * This function can be used by drives like qla4xxx to report to the scsi
> - * layer when the scans it kicked off at module load time are done.
> - */
> -int iscsi_scan_finished(struct Scsi_Host *shost, unsigned long time)
> -{
> -	struct iscsi_cls_host *ihost = shost->shost_data;
> -	/*
> -	 * qla4xxx will have kicked off some session unblocks before calling
> -	 * scsi_scan_host, so just wait for them to complete.
> -	 */
> -	return !atomic_read(&ihost->nr_scans);
> -}
> -EXPORT_SYMBOL_GPL(iscsi_scan_finished);
> -
>  struct iscsi_scan_data {
>  	unsigned int channel;
>  	unsigned int id;
> @@ -1831,8 +1811,6 @@ static void iscsi_scan_session(struct work_struct *work)
>  {
>  	struct iscsi_cls_session *session =
>  			container_of(work, struct iscsi_cls_session, scan_work);
> -	struct Scsi_Host *shost = iscsi_session_to_shost(session);
> -	struct iscsi_cls_host *ihost = shost->shost_data;
>  	struct iscsi_scan_data scan_data;
>  
>  	scan_data.channel = 0;
> @@ -1841,7 +1819,6 @@ static void iscsi_scan_session(struct work_struct *work)
>  	scan_data.rescan = SCSI_SCAN_RESCAN;
>  
>  	iscsi_user_scan_session(&session->dev, &scan_data);
> -	atomic_dec(&ihost->nr_scans);
>  }
>  
>  /**
> @@ -1912,8 +1889,6 @@ static void __iscsi_unblock_session(struct work_struct *work)
>  	struct iscsi_cls_session *session =
>  			container_of(work, struct iscsi_cls_session,
>  				     unblock_work);
> -	struct Scsi_Host *shost = iscsi_session_to_shost(session);
> -	struct iscsi_cls_host *ihost = shost->shost_data;
>  	unsigned long flags;
>  
>  	ISCSI_DBG_TRANS_SESSION(session, "Unblocking session\n");
> @@ -1924,15 +1899,6 @@ static void __iscsi_unblock_session(struct work_struct *work)
>  	spin_unlock_irqrestore(&session->lock, flags);
>  	/* start IO */
>  	scsi_target_unblock(&session->dev, SDEV_RUNNING);
> -	/*
> -	 * Only do kernel scanning if the driver is properly hooked into
> -	 * the async scanning code (drivers like iscsi_tcp do login and
> -	 * scanning from userspace).
> -	 */
> -	if (shost->hostt->scan_finished) {
> -		if (scsi_queue_work(shost, &session->scan_work))
> -			atomic_inc(&ihost->nr_scans);
> -	}
>  	ISCSI_DBG_TRANS_SESSION(session, "Completed unblocking session\n");
>  }
>  
> @@ -2192,7 +2158,10 @@ void iscsi_remove_session(struct iscsi_cls_session *session)
>  	spin_unlock_irqrestore(&session->lock, flags);
>  
>  	scsi_target_unblock(&session->dev, SDEV_TRANSPORT_OFFLINE);
> -	/* flush running scans then delete devices */
> +	/*
> +	 * qla4xxx can perform it's own scans when it runs in kernel only
> +	 * mode. Make sure to flush those scans.
> +	 */
>  	flush_work(&session->scan_work);
>  	/* flush running unbind operations */
>  	flush_work(&session->unbind_work);
> diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
> index c5d7810fd792..90b55db46d7c 100644
> --- a/include/scsi/scsi_transport_iscsi.h
> +++ b/include/scsi/scsi_transport_iscsi.h
> @@ -278,7 +278,6 @@ struct iscsi_cls_session {
>  	iscsi_dev_to_session(_stgt->dev.parent)
>  
>  struct iscsi_cls_host {
> -	atomic_t nr_scans;
>  	struct mutex mutex;
>  	struct request_queue *bsg_q;
>  	uint32_t port_speed;
> @@ -448,7 +447,6 @@ extern void iscsi_get_conn(struct iscsi_cls_conn *conn);
>  extern int iscsi_destroy_conn(struct iscsi_cls_conn *conn);
>  extern void iscsi_unblock_session(struct iscsi_cls_session *session);
>  extern void iscsi_block_session(struct iscsi_cls_session *session);
> -extern int iscsi_scan_finished(struct Scsi_Host *shost, unsigned long time);
>  extern struct iscsi_endpoint *iscsi_create_endpoint(int dd_size);
>  extern void iscsi_destroy_endpoint(struct iscsi_endpoint *ep);
>  extern struct iscsi_endpoint *iscsi_lookup_endpoint(u64 handle);

Reviewed-by: Chris Leech <cleech@redhat.com>

