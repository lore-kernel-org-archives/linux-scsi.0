Return-Path: <SRS0=glVe=EF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DE1FC4741F
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 08:54:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27C8222253
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 08:54:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NtIHAIxj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725875AbgJ3IyD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Oct 2020 04:54:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53044 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725355AbgJ3IyD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Oct 2020 04:54:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604048041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EkkbFBzuO71laTFHVRqjnoW6qUXVs253bo//A3S1us4=;
        b=NtIHAIxjXy/BrMgx2TyDzHInEucdo1pVsjKajbw4zk71jTucCXyw0yF8feTfl+q33GjHF+
        xaoUm3iaseaOFyMuIpYpLKnLphHF1p6oMCGCBGk7zFL6B7c2kYvKmeP8q2nutFhHDqXesd
        pxT/FsInpx7XCRGIqzdQI9Nuuernc+U=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-fPwwOKRJOMWixMXrfr3TSQ-1; Fri, 30 Oct 2020 04:51:21 -0400
X-MC-Unique: fPwwOKRJOMWixMXrfr3TSQ-1
Received: by mail-wm1-f69.google.com with SMTP id p7so398535wma.9
        for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2020 01:51:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EkkbFBzuO71laTFHVRqjnoW6qUXVs253bo//A3S1us4=;
        b=oWEvmUJoAjovGNX/o+20bcfG+mbJ7Qv7aISxQNVFTIW+L1SHqNOqgL6+U/ME6RW+xp
         ZU86AKgPJTz0WRhJVDm/Jk75i/2TsREm+g+8sVI9GG7H8GWfD+r2yp0hVyMGmNiad8sA
         kYri8PFTMzqCb+Oizrvi8V7pOqecjMfITmwDNUrHm6lt5PstiLnFyJpOciZPlC3vNNVB
         baxDhf8hBDD7UCd6eCWTtrD7jc4I0Ew5+w36SidR+VWjW4EqGY5ZaW+kLaBagfcmSzfm
         IMIeadUyICBAFKgUVKuGKuRmHS62RNoR/rlmaMiT5NHkXB8d/n9KvrXrDrfFvgSpas7a
         JQwA==
X-Gm-Message-State: AOAM531L4vHz8cURdZBy/CTXpwFO4/I5e8jYDY7cw3UGmJyELO87wyW+
        S/0xqTXe/ZNYOwNWmZ0D/AXnBUQKMdbNBdg/0vjYU2MGhZqazQaFhVc2cwr+1S/9xiii9WB5gBl
        hT5jm8/dcxDe5qO2rng/6Kg==
X-Received: by 2002:a5d:56d0:: with SMTP id m16mr1649447wrw.120.1604047880317;
        Fri, 30 Oct 2020 01:51:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxj1MIwQ89bJ9kkwAMBxlNZwrbEnzRE72LWtV7F3wZEY97skaECdSnY11+Ta3iR9UnpXR/YyQ==
X-Received: by 2002:a5d:56d0:: with SMTP id m16mr1649435wrw.120.1604047880142;
        Fri, 30 Oct 2020 01:51:20 -0700 (PDT)
Received: from redhat.com (bzq-79-176-118-93.red.bezeqint.net. [79.176.118.93])
        by smtp.gmail.com with ESMTPSA id o10sm3889774wma.47.2020.10.30.01.51.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 01:51:19 -0700 (PDT)
Date:   Fri, 30 Oct 2020 04:51:16 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, jasowang@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 09/17] vhost scsi: fix cmd completion race
Message-ID: <20201030045053-mutt-send-email-mst@kernel.org>
References: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
 <1603326903-27052-10-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1603326903-27052-10-git-send-email-michael.christie@oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Oct 21, 2020 at 07:34:55PM -0500, Mike Christie wrote:
> We might not do the final se_cmd put from vhost_scsi_complete_cmd_work.
> When the last put happens a little later then we could race where
> vhost_scsi_complete_cmd_work does vhost_signal, the guest runs and sends
> more IO, and vhost_scsi_handle_vq runs but does not find any free cmds.
> 
> This patch has us delay completing the cmd until the last lio core ref
> is dropped. We then know that once we signal to the guest that the cmd
> is completed that if it queues a new command it will find a free cmd.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>


Paolo, could you review this one?

> ---
>  drivers/vhost/scsi.c | 42 +++++++++++++++---------------------------
>  1 file changed, 15 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
> index f6b9010..2fa48dd 100644
> --- a/drivers/vhost/scsi.c
> +++ b/drivers/vhost/scsi.c
> @@ -322,7 +322,7 @@ static u32 vhost_scsi_tpg_get_inst_index(struct se_portal_group *se_tpg)
>  	return 1;
>  }
>  
> -static void vhost_scsi_release_cmd(struct se_cmd *se_cmd)
> +static void vhost_scsi_release_cmd_res(struct se_cmd *se_cmd)
>  {
>  	struct vhost_scsi_cmd *tv_cmd = container_of(se_cmd,
>  				struct vhost_scsi_cmd, tvc_se_cmd);
> @@ -344,6 +344,16 @@ static void vhost_scsi_release_cmd(struct se_cmd *se_cmd)
>  	vhost_scsi_put_inflight(inflight);
>  }
>  
> +static void vhost_scsi_release_cmd(struct se_cmd *se_cmd)
> +{
> +	struct vhost_scsi_cmd *cmd = container_of(se_cmd,
> +					struct vhost_scsi_cmd, tvc_se_cmd);
> +	struct vhost_scsi *vs = cmd->tvc_vhost;
> +
> +	llist_add(&cmd->tvc_completion_list, &vs->vs_completion_list);
> +	vhost_work_queue(&vs->dev, &vs->vs_completion_work);
> +}
> +
>  static u32 vhost_scsi_sess_get_index(struct se_session *se_sess)
>  {
>  	return 0;
> @@ -366,28 +376,15 @@ static int vhost_scsi_get_cmd_state(struct se_cmd *se_cmd)
>  	return 0;
>  }
>  
> -static void vhost_scsi_complete_cmd(struct vhost_scsi_cmd *cmd)
> -{
> -	struct vhost_scsi *vs = cmd->tvc_vhost;
> -
> -	llist_add(&cmd->tvc_completion_list, &vs->vs_completion_list);
> -
> -	vhost_work_queue(&vs->dev, &vs->vs_completion_work);
> -}
> -
>  static int vhost_scsi_queue_data_in(struct se_cmd *se_cmd)
>  {
> -	struct vhost_scsi_cmd *cmd = container_of(se_cmd,
> -				struct vhost_scsi_cmd, tvc_se_cmd);
> -	vhost_scsi_complete_cmd(cmd);
> +	transport_generic_free_cmd(se_cmd, 0);
>  	return 0;
>  }
>  
>  static int vhost_scsi_queue_status(struct se_cmd *se_cmd)
>  {
> -	struct vhost_scsi_cmd *cmd = container_of(se_cmd,
> -				struct vhost_scsi_cmd, tvc_se_cmd);
> -	vhost_scsi_complete_cmd(cmd);
> +	transport_generic_free_cmd(se_cmd, 0);
>  	return 0;
>  }
>  
> @@ -433,15 +430,6 @@ static void vhost_scsi_free_evt(struct vhost_scsi *vs, struct vhost_scsi_evt *ev
>  	return evt;
>  }
>  
> -static void vhost_scsi_free_cmd(struct vhost_scsi_cmd *cmd)
> -{
> -	struct se_cmd *se_cmd = &cmd->tvc_se_cmd;
> -
> -	/* TODO locking against target/backend threads? */
> -	transport_generic_free_cmd(se_cmd, 0);
> -
> -}
> -
>  static int vhost_scsi_check_stop_free(struct se_cmd *se_cmd)
>  {
>  	return target_put_sess_cmd(se_cmd);
> @@ -560,7 +548,7 @@ static void vhost_scsi_complete_cmd_work(struct vhost_work *work)
>  		} else
>  			pr_err("Faulted on virtio_scsi_cmd_resp\n");
>  
> -		vhost_scsi_free_cmd(cmd);
> +		vhost_scsi_release_cmd_res(se_cmd);
>  	}
>  
>  	vq = -1;
> @@ -1096,7 +1084,7 @@ static u16 vhost_buf_to_lun(u8 *lun_buf)
>  						      &prot_iter, exp_data_len,
>  						      &data_iter))) {
>  				vq_err(vq, "Failed to map iov to sgl\n");
> -				vhost_scsi_release_cmd(&cmd->tvc_se_cmd);
> +				vhost_scsi_release_cmd_res(&cmd->tvc_se_cmd);
>  				goto err;
>  			}
>  		}
> -- 
> 1.8.3.1

