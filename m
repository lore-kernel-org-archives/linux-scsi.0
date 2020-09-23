Return-Path: <SRS0=SJ7r=DA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0B1BC52D7C
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Sep 2020 10:23:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97D8423787
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Sep 2020 10:23:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Yd0IdmQT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726665AbgIWKXT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Sep 2020 06:23:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22754 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726485AbgIWKXL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Sep 2020 06:23:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600856590;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VFgJToirjL1LcUbMYxqpCEwKfTDu3I+1Nj36cIZeHgU=;
        b=Yd0IdmQTpH+5D0QQ1w/Mb0SJ3HD/w1q6wrLgrcj+8ir03so6qzuOax5OWqOWdbB8APf+sJ
        KUQBtls6bZL0rRggnw5zrvIqY3v6COVWbj5mQyHhw12ZBj2Eayd3CvCZngbSHa2VeParIx
        XK+zJcHcDbxHiZ0MO1hT1H8KdcnAuFc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-391-HnWJ9N3oPw2XUXV1qWn7ow-1; Wed, 23 Sep 2020 06:23:08 -0400
X-MC-Unique: HnWJ9N3oPw2XUXV1qWn7ow-1
Received: by mail-wr1-f72.google.com with SMTP id o6so8626742wrp.1
        for <linux-scsi@vger.kernel.org>; Wed, 23 Sep 2020 03:23:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VFgJToirjL1LcUbMYxqpCEwKfTDu3I+1Nj36cIZeHgU=;
        b=FqsjeLbe0SC4cPXVKBrj2FkwKm3bBjKeRgChU2IQ53ueXcYAo8u5A/9/TLEHGGdtBQ
         AzL9uxktsXeXjHWBMBxWSTciwTrEtwB2OZPyvlm2YUVqGXQHcPZoEaH9UmoiSHF5FmUA
         /Q7Og9ZW4dDWHdI6OgTqgqBH7tPbKdYJx5L+5iteDzqkvduVu3PJKybL40TNkc/aGnri
         AWUvqbJib2Bv8YpibQ+zNAucI5y+IqRRzPxgeFHzeSkk7W6HZLPwuO1EQm5C/qcjLFLP
         1Gfx/8KopRSVnI4lkoHwU/C0evouuSjDZpsoPPmdIx8zZMdGw2B1KwpzX4WTbkGAeNJt
         t/PA==
X-Gm-Message-State: AOAM5314Jdaukf2MbYDPgBaL3b3tFC0PAuuTZSOTq6fdPoqCI3RBLk6I
        Bn//5FLPSNL3rLVldn0hiBrddRaSuXe+1D6nB22D5JAWibq0Pnt9oMAZYPRqUH2+tRq69fmKoEB
        T4LSxLVNtjOX5XWtj55R5RA==
X-Received: by 2002:a05:600c:20c:: with SMTP id 12mr4741714wmi.40.1600856587510;
        Wed, 23 Sep 2020 03:23:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwvwid4yBpJLIUdhmHJZC1dioF+qkVR7rcecEnmaK5giSVtQGS8/+Yh8i8w9490r84enyaBxw==
X-Received: by 2002:a05:600c:20c:: with SMTP id 12mr4741681wmi.40.1600856587231;
        Wed, 23 Sep 2020 03:23:07 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:15f1:648d:7de6:bad9? ([2001:b07:6468:f312:15f1:648d:7de6:bad9])
        by smtp.gmail.com with ESMTPSA id y6sm30308257wrn.41.2020.09.23.03.23.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2020 03:23:06 -0700 (PDT)
Subject: Re: [PATCH 5/8] vhost scsi: add lun parser helper
To:     Mike Christie <michael.christie@oracle.com>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        stefanha@redhat.com, virtualization@lists.linux-foundation.org
References: <1600712588-9514-1-git-send-email-michael.christie@oracle.com>
 <1600712588-9514-6-git-send-email-michael.christie@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c981b20e-895a-d5ce-9973-ffe7b21bd724@redhat.com>
Date:   Wed, 23 Sep 2020 12:23:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <1600712588-9514-6-git-send-email-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 21/09/20 20:23, Mike Christie wrote:
> Move code to parse lun from req's lun_buf to helper, so tmf code
> can use it in the next patch.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/vhost/scsi.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
> index 26d0f75..736ce19 100644
> --- a/drivers/vhost/scsi.c
> +++ b/drivers/vhost/scsi.c
> @@ -899,6 +899,11 @@ static void vhost_scsi_submission_work(struct work_struct *work)
>  	return ret;
>  }
>  
> +static u16 vhost_buf_to_lun(u8 *lun_buf)
> +{
> +	return ((lun_buf[2] << 8) | lun_buf[3]) & 0x3FFF;
> +}
> +
>  static void
>  vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
>  {
> @@ -1037,12 +1042,12 @@ static void vhost_scsi_submission_work(struct work_struct *work)
>  			tag = vhost64_to_cpu(vq, v_req_pi.tag);
>  			task_attr = v_req_pi.task_attr;
>  			cdb = &v_req_pi.cdb[0];
> -			lun = ((v_req_pi.lun[2] << 8) | v_req_pi.lun[3]) & 0x3FFF;
> +			lun = vhost_buf_to_lun(v_req_pi.lun);
>  		} else {
>  			tag = vhost64_to_cpu(vq, v_req.tag);
>  			task_attr = v_req.task_attr;
>  			cdb = &v_req.cdb[0];
> -			lun = ((v_req.lun[2] << 8) | v_req.lun[3]) & 0x3FFF;
> +			lun = vhost_buf_to_lun(v_req.lun);
>  		}
>  		/*
>  		 * Check that the received CDB size does not exceeded our
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

