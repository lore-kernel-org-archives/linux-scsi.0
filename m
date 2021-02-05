Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4D55C4332E
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 22:14:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 779B764FB4
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 22:14:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232805AbhBEWNN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Feb 2021 17:13:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26899 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231723AbhBEOkd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Feb 2021 09:40:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612541860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=khNEiGi3gSDvPl4eGhmwPqK2s3UCa52HPIkP8Eu2Bsc=;
        b=bpRSFNolmSuPtYuN13RbkEGPUZUyVq3sJ+Ik5Ddi9QNacuAlSft69RxtAz0dxmBhNIA23T
        Ig3hPnr2eNC2EIEOAFvP7WgypMchr4q3zMDdF9pW4c+6a1zFgpPzKR5FDS/a9PKd1P8+le
        oIougAwWgzPBue6tQRY2C5FEFL1GPhM=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-55--kQxqC4vMvOahs5gXbIbJQ-1; Fri, 05 Feb 2021 11:17:24 -0500
X-MC-Unique: -kQxqC4vMvOahs5gXbIbJQ-1
Received: by mail-ed1-f69.google.com with SMTP id o8so7248294edh.12
        for <linux-scsi@vger.kernel.org>; Fri, 05 Feb 2021 08:17:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=khNEiGi3gSDvPl4eGhmwPqK2s3UCa52HPIkP8Eu2Bsc=;
        b=GO7sazzn/Q8u9IdmpcYaUKgCi9PQQ4x/BxQhThsB4hqSOo0kp2C+RH/A/kVxeB6iVq
         MiLFPkY++2PMm2n9EPwcP5dx9N2jm2Vi2uA+GfBTbcPwJYxpUxPwikvqaAYVc53/pkoE
         /Fc4PcaHKwP6DG3rg9Tazzx/o9MbxeSxVvrpgQ0jCc3TIs0LGDkn0wuGqC9+D4YsyWfO
         R0z8lNfp1GCTeJChKyYnTJ3vuzgWzI8WRNU0XA1QyWsXSIA9aCnSzZwmeV0j6oMjfoNg
         OXrDZnJZmuv8X0OWDY0XNKVZXdiPkGjcbifevM2PDYzu+K7S0Y8IgbEjxsBVhgH1GHl/
         iQXA==
X-Gm-Message-State: AOAM532gYDrs/JertBBFdDV+2Fk2Sw36FeEA9FAscDyKM1HacB4vshmn
        ccnnCGNPnxc9T/kdaEnwQkSD1XJIUWS+FzPVUr3l1x0nztKCPGjKUp0uCy1lDV2FBYct4X2ToZT
        rKlxuKlRatthBvSops/Hk8w==
X-Received: by 2002:a17:906:169b:: with SMTP id s27mr343276ejd.396.1612541842914;
        Fri, 05 Feb 2021 08:17:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxASMO+xswfNgpQwV8wyefPe1EMyJevJ53IOHaWEyDD08C7S3RPlbtBmcuhKVYuF8c/fBWAdQ==
X-Received: by 2002:a17:906:169b:: with SMTP id s27mr343257ejd.396.1612541842771;
        Fri, 05 Feb 2021 08:17:22 -0800 (PST)
Received: from redhat.com (bzq-79-180-2-31.red.bezeqint.net. [79.180.2.31])
        by smtp.gmail.com with ESMTPSA id 94sm2442486edq.91.2021.02.05.08.17.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 08:17:22 -0800 (PST)
Date:   Fri, 5 Feb 2021 11:17:19 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, jasowang@redhat.com,
        stefanha@redhat.com, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 05/11] vhost scsi: use lio wq cmd submission helper
Message-ID: <20210205111638-mutt-send-email-mst@kernel.org>
References: <20210204113513.93204-1-michael.christie@oracle.com>
 <20210204113513.93204-6-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210204113513.93204-6-michael.christie@oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Feb 04, 2021 at 05:35:07AM -0600, Mike Christie wrote:
> @@ -1132,14 +1127,8 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
>  		 * vhost_scsi_queue_data_in() and vhost_scsi_queue_status()
>  		 */
>  		cmd->tvc_vq_desc = vc.head;
> -		/*
> -		 * Dispatch cmd descriptor for cmwq execution in process
> -		 * context provided by vhost_scsi_workqueue.  This also ensures
> -		 * cmd is executed on the same kworker CPU as this vhost
> -		 * thread to gain positive L2 cache locality effects.
> -		 */
> -		INIT_WORK(&cmd->work, vhost_scsi_submission_work);
> -		queue_work(vhost_scsi_workqueue, &cmd->work);
> +		target_queue_cmd_submit(tpg->tpg_nexus->tvn_se_sess,
> +					&cmd->tvc_se_cmd);
>  		ret = 0;
>  err:
>  		/*

What about this aspect? Will things still stay on the same CPU?

-- 
MST

