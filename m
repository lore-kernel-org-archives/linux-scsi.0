Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36DB7C56202
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 08:56:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF815221E9
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 08:56:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fWnmsIYF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbgKRI4a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Nov 2020 03:56:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24685 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726724AbgKRI4a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 18 Nov 2020 03:56:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605689789;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oE/IfWvNx94tBWY03gu3UuKE9ZiNz0WGz4c8BQhvfUg=;
        b=fWnmsIYFi8//KB1kpoGwjshzZ/xz6UFejcisRyhYX3yNq4pJGzEYFdHxzwWThsRwZsWwUH
        IYToonZWiHqu0d949YpQdbF8+PQluB+/oiaLv7/VmM+ywfev1MgRN2HGQA6jIkyD6glggj
        kCIrqIkesoJf0uKum6hwoYSjB2U06kI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-544-eC21-j1sMO65mpAjYkhURQ-1; Wed, 18 Nov 2020 03:56:27 -0500
X-MC-Unique: eC21-j1sMO65mpAjYkhURQ-1
Received: by mail-wm1-f72.google.com with SMTP id c131so127225wma.0
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2020 00:56:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oE/IfWvNx94tBWY03gu3UuKE9ZiNz0WGz4c8BQhvfUg=;
        b=Gb4Gxo4Qv1cnrETWzs6zrpy/meriA7rypwySSBIcD3nn9Cj12tqohezr9ra9qR98T0
         xcFsASbeEe9R+TH0nkbLqhoJuagKoauixx0KysaPIivVlPmeDcWrj2I8ueNfXpziQJ7C
         ljioE+m0HbqWeXEL6UNXPV8xkryNI/Ivt+1SiTMgvujL3MCaeLzgzMnPWgOHeKoXMLTO
         XJx64zY7+HfeE6thTLghIzoWPRZcjirNlS+Cz5Dbi3UcYjKxbNooO1dxqm3ZU+w8pUo4
         jET9/0pEPtMi8QVQ7iIL6iruiIvq3jvylZeulHw4zTOuE/E1DicT/xKrmvKYaOtivqEm
         LYaQ==
X-Gm-Message-State: AOAM533z1NLgzDVp8sBQAbht538tk1Ue3KAItXXvTJ1Ai6Vl59HEfVew
        XNSfCdkwk2wGgNJtep3nW7dRbfN0wIkF4ihe9pKLv8Mnred+aUAB+AuCYM/f5BTQcQFYJ5rI1dl
        YmJIJD27aTfwdNRJuRILTxw==
X-Received: by 2002:adf:e6cf:: with SMTP id y15mr3897455wrm.403.1605689786263;
        Wed, 18 Nov 2020 00:56:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxueBisSh/Mu4b5J73GuuCPae8P0OUrhxdSJAhejf3LKVsO4+2I2VmxbqVKsBNYXWpdkhzG3w==
X-Received: by 2002:adf:e6cf:: with SMTP id y15mr3897444wrm.403.1605689786105;
        Wed, 18 Nov 2020 00:56:26 -0800 (PST)
Received: from redhat.com (bzq-109-67-54-78.red.bezeqint.net. [109.67.54.78])
        by smtp.gmail.com with ESMTPSA id u81sm2799177wmb.27.2020.11.18.00.56.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 00:56:25 -0800 (PST)
Date:   Wed, 18 Nov 2020 03:56:22 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     stefanha@redhat.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 1/1] vhost scsi: fix lun reset completion handling
Message-ID: <20201118035452-mutt-send-email-mst@kernel.org>
References: <1605680660-3671-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1605680660-3671-1-git-send-email-michael.christie@oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Nov 18, 2020 at 12:24:20AM -0600, Mike Christie wrote:
> vhost scsi owns the scsi se_cmd but lio frees the se_cmd->se_tmr
> before calling release_cmd, so while with normal cmd completion we
> can access the se_cmd from the vhost work, we can't do the same with
> se_cmd->se_tmr. This has us copy the tmf response in
> vhost_scsi_queue_tm_rsp to our internal vhost-scsi tmf struct for
> when it gets sent to the guest from our worker thread.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>

Is this a fix for
    vhost scsi: Add support for LUN resets.

If so pls add a Fixes: tag.

> ---
>  drivers/vhost/scsi.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
> index f22fce5..6ff8a5096 100644
> --- a/drivers/vhost/scsi.c
> +++ b/drivers/vhost/scsi.c
> @@ -220,6 +220,7 @@ struct vhost_scsi_tmf {
>  	struct list_head queue_entry;
>  
>  	struct se_cmd se_cmd;
> +	u8 scsi_resp;
>  	struct vhost_scsi_inflight *inflight;
>  	struct iovec resp_iov;
>  	int in_iovs;
> @@ -426,6 +427,7 @@ static void vhost_scsi_queue_tm_rsp(struct se_cmd *se_cmd)
>  	struct vhost_scsi_tmf *tmf = container_of(se_cmd, struct vhost_scsi_tmf,
>  						  se_cmd);
>  
> +	tmf->scsi_resp = se_cmd->se_tmr_req->response;
>  	transport_generic_free_cmd(&tmf->se_cmd, 0);
>  }
>  
> @@ -1183,7 +1185,7 @@ static void vhost_scsi_tmf_resp_work(struct vhost_work *work)
>  						  vwork);
>  	int resp_code;
>  
> -	if (tmf->se_cmd.se_tmr_req->response == TMR_FUNCTION_COMPLETE)
> +	if (tmf->scsi_resp == TMR_FUNCTION_COMPLETE)
>  		resp_code = VIRTIO_SCSI_S_FUNCTION_SUCCEEDED;
>  	else
>  		resp_code = VIRTIO_SCSI_S_FUNCTION_REJECTED;
> -- 
> 1.8.3.1

