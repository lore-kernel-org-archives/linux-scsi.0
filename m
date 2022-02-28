Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71BFFC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Feb 2022 20:08:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbiB1UIm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Feb 2022 15:08:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbiB1UI3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Feb 2022 15:08:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 668B869CEA
        for <linux-scsi@vger.kernel.org>; Mon, 28 Feb 2022 12:07:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646078867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NN46cj3RJbYFU5XqoOC/dOvDEQJ3ce6idOogTModIf4=;
        b=JnI4+6CnPFdlzgPyKUqt0OQ4MW71ykZpPxsYxuK6mVtYMfuHJhosP+HiXPjmD/PdwlJ3jf
        XxfLGPmmrxnMPZy/A5AJ3t/XGTfj96+fQZFsaN6iDbxXYIobSzn2n5jEurGuZnstuMR0sT
        4wifc/3DOdHKaq4vKz28IHJHORZAFiI=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-461-pV3GfooUMcuTzmAmcGsTWw-1; Mon, 28 Feb 2022 15:07:46 -0500
X-MC-Unique: pV3GfooUMcuTzmAmcGsTWw-1
Received: by mail-qv1-f71.google.com with SMTP id fv11-20020a056214240b00b0043253a948f0so13306439qvb.1
        for <linux-scsi@vger.kernel.org>; Mon, 28 Feb 2022 12:07:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=NN46cj3RJbYFU5XqoOC/dOvDEQJ3ce6idOogTModIf4=;
        b=j1B5tzhyJnj0Xl98hMQ4xuNGC7DWA1gIUbDP0RO1VrG876u8jrPPa+e7Lb959qrgjv
         cUB0PpFd2IdDjcMgpzJ+8MTF/EEkXFBjVyZxfpOu1BUTSOfGJ/GX8CuyIGWg63oTsB9v
         Lk07RHDcnrxEN2a11bvxcZG9IlfqqI9SvbGmaPSArTwIHUp7qO77/pOvvGdxnCBuKIOQ
         xFeNj3KBJ0vUETpXJlUvXsyNmJA3F9ahYgTNN4WIRbyUR10zbp9inFDjHnqOdoqkSUi+
         FHdLINqSvavNZc8Md1BdlNDNjlscFCcMTlCGeEzvcOZ2gM8WTunfyw6dOSjJjyJ5aZPK
         Moaw==
X-Gm-Message-State: AOAM5330OzjhYDNbx3m5gz73F/60YMYRiSXS2kBnDBrk/rFTWwpA0uNE
        pQ+HrO6h1Is69fIzYckTjFGqXi4sMnPlUUjeS36Hf2fPBcc1pFMqQIfTMSjuZxPEeOmOPWY+fZR
        3BN1sY5eRlNEsfbIyePXI9Q==
X-Received: by 2002:ad4:5ba4:0:b0:433:48be:b063 with SMTP id 4-20020ad45ba4000000b0043348beb063mr2150240qvq.25.1646078865687;
        Mon, 28 Feb 2022 12:07:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJylwQFxmD+KSwZuztDELdL1Jo7iojDsCMdmBFMguW5ro+Xa88svfwxqmWaoJnAMCh+sohzjRQ==
X-Received: by 2002:ad4:5ba4:0:b0:433:48be:b063 with SMTP id 4-20020ad45ba4000000b0043348beb063mr2150225qvq.25.1646078865424;
        Mon, 28 Feb 2022 12:07:45 -0800 (PST)
Received: from [192.168.0.14] (97-120-59-83.ptld.qwest.net. [97.120.59.83])
        by smtp.gmail.com with ESMTPSA id x15-20020a05622a000f00b002de2da5e5cdsm7516332qtw.3.2022.02.28.12.07.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Feb 2022 12:07:44 -0800 (PST)
Message-ID: <413020c7-626e-a1bc-1074-c3eafa494c5e@redhat.com>
Date:   Mon, 28 Feb 2022 12:07:43 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 4/6] scsi: iscsi, ql4: Use per session workqueue for
 unbinding.
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        mrangankar@marvell.com, njavali@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, lduncan@suse.com,
        liuzhengyuang521@gmail.com
References: <20220226230435.38733-1-michael.christie@oracle.com>
 <20220226230435.38733-5-michael.christie@oracle.com>
From:   Chris Leech <cleech@redhat.com>
In-Reply-To: <20220226230435.38733-5-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/26/22 3:04 PM, Mike Christie wrote:
> We currently allocate a workqueue per host and only use it for removing
> the target. For the session per host case we could be using this workqueue
> to be able to do recoveries (block, unblock, timeout handling) in
> parallel. To also allow offload drivers to do their session recoveries in
> parallel, this drops the per host workqueue and replaces it with a per
> session one.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/qla4xxx/ql4_os.c       |  2 +-
>  drivers/scsi/scsi_transport_iscsi.c | 19 ++++++++++++++-----
>  include/scsi/scsi_transport_iscsi.h |  2 ++
>  3 files changed, 17 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
> index 0ae936d839f1..955d8cb675f1 100644
> --- a/drivers/scsi/qla4xxx/ql4_os.c
> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> @@ -5096,7 +5096,7 @@ int qla4xxx_unblock_flash_ddb(struct iscsi_cls_session *cls_session)
>  		ql4_printk(KERN_INFO, ha, "scsi%ld: %s: ddb[%d]"
>  			   " start scan\n", ha->host_no, __func__,
>  			   ddb_entry->fw_ddb_index);
> -		scsi_queue_work(ha->host, &ddb_entry->sess->scan_work);
> +		queue_work(ddb_entry->sess->workq, &ddb_entry->sess->scan_work);
>  	}
>  	return QLA_SUCCESS;
>  }
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index 05cd4bca979e..ecb592a70e03 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -2032,19 +2032,27 @@ EXPORT_SYMBOL_GPL(iscsi_alloc_session);
>  
>  int iscsi_add_session(struct iscsi_cls_session *session, unsigned int target_id)
>  {
> +	struct Scsi_Host *shost = iscsi_session_to_shost(session);
>  	unsigned long flags;
>  	int id = 0;
>  	int err;
>  
>  	session->sid = atomic_add_return(1, &iscsi_session_nr);
>  
> +	session->workq = alloc_workqueue("iscsi_ctrl_%d:%d",
> +			WQ_SYSFS | WQ_MEM_RECLAIM | WQ_UNBOUND, 0,
> +			shost->host_no, session->sid);
> +	if (!session->workq)
> +		return -ENOMEM;
> +
>  	if (target_id == ISCSI_MAX_TARGET) {
>  		id = ida_simple_get(&iscsi_sess_ida, 0, 0, GFP_KERNEL);
>  
>  		if (id < 0) {
>  			iscsi_cls_session_printk(KERN_ERR, session,
>  					"Failure in Target ID Allocation\n");
> -			return id;
> +			err = id;
> +			goto destroy_wq;
>  		}
>  		session->target_id = (unsigned int)id;
>  		session->ida_used = true;
> @@ -2078,7 +2086,8 @@ int iscsi_add_session(struct iscsi_cls_session *session, unsigned int target_id)
>  release_ida:
>  	if (session->ida_used)
>  		ida_simple_remove(&iscsi_sess_ida, session->target_id);
> -
> +destroy_wq:
> +	destroy_workqueue(session->workq);
>  	return err;
>  }
>  EXPORT_SYMBOL_GPL(iscsi_add_session);
> @@ -2177,6 +2186,8 @@ void iscsi_remove_session(struct iscsi_cls_session *session)
>  
>  	transport_unregister_device(&session->dev);
>  
> +	destroy_workqueue(session->workq);
> +
>  	ISCSI_DBG_TRANS_SESSION(session, "Completing session removal\n");
>  	device_del(&session->dev);
>  }
> @@ -3833,8 +3844,7 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
>  	case ISCSI_UEVENT_UNBIND_SESSION:
>  		session = iscsi_session_lookup(ev->u.d_session.sid);
>  		if (session)
> -			scsi_queue_work(iscsi_session_to_shost(session),
> -					&session->unbind_work);
> +			queue_work(session->workq, &session->unbind_work);
>  		else
>  			err = -EINVAL;
>  		break;
> @@ -4707,7 +4717,6 @@ iscsi_register_transport(struct iscsi_transport *tt)
>  	INIT_LIST_HEAD(&priv->list);
>  	priv->iscsi_transport = tt;
>  	priv->t.user_scan = iscsi_user_scan;
> -	priv->t.create_work_queue = 1;
>  
>  	priv->dev.class = &iscsi_transport_class;
>  	dev_set_name(&priv->dev, "%s", tt->name);
> diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
> index 90b55db46d7c..7a0d24d3b916 100644
> --- a/include/scsi/scsi_transport_iscsi.h
> +++ b/include/scsi/scsi_transport_iscsi.h
> @@ -251,6 +251,8 @@ struct iscsi_cls_session {
>  	bool recovery_tmo_sysfs_override;
>  	struct delayed_work recovery_work;
>  
> +	struct workqueue_struct *workq;
> +
>  	unsigned int target_id;
>  	bool ida_used;
>  

Reviewed-by: Chris Leech <cleech@redhat.com>

