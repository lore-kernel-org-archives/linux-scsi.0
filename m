Return-Path: <SRS0=wj+1=BI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33AC7C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 22:10:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09F092082E
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 22:10:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fech8Rcu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbgG2WK0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 18:10:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:56890 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726628AbgG2WKZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jul 2020 18:10:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596060623;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bJ9gcg8hgg+gXoaDiJiCDnUPl9TBTNe9dHQAX/u98cA=;
        b=Fech8Rcu5VT5stjdknGY7iXYOKckOYJf+TJewSNyb0S4W+BFnorzrldNaJF3pr0XchhvQS
        bNdZMM+7VJ2clGWwvSAqZSy2yRt6qEWvwnM8o+470rGEy/8CgxoxCAzM+U7u7nWiXj7biQ
        QyR5vgsXFMT3rHk5iCQDqi40tQ5gC1A=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-511-FORWJb5rN6iki_BSp51Kug-1; Wed, 29 Jul 2020 18:10:21 -0400
X-MC-Unique: FORWJb5rN6iki_BSp51Kug-1
Received: by mail-wm1-f71.google.com with SMTP id h205so1521389wmf.0
        for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2020 15:10:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bJ9gcg8hgg+gXoaDiJiCDnUPl9TBTNe9dHQAX/u98cA=;
        b=qhe+fuZueV3AThImZ/nnbc1l3NfdY/FA7p/1ajJGPjPoj52q2JppHPg2yP426WCvDi
         YPZdkNyns+ITfxtYLQL3t/5Xhv7zLhBMDJagIQPYQxoLzmQ+gtsOtWualc6QHxSGYPwH
         aoO9JRweaQQ81ZeJ2qtMRXf0o+b5oBtkZsgMyS/6DzPea2RQKZ1e3urZ11kYMhO4VpfE
         xwtSUbCKtBDrWxnP1ldrYjdeikN7BarUGvwRc/IDlOPZWEz8OXHrwHa3Ph3LbfAzjam5
         JZkES8ANGHCgWL1PAfI4NLwSdBAockZjM3bIq4gi/bAu2v38K89KOmelm86/12QqRhor
         g7gA==
X-Gm-Message-State: AOAM533oMb+EvkeHvdcsg4Ex6/T4DnWdqC27zWKF1TevyRSWhsAQw9QH
        9K5p92k9dPJi859Jg68qbIy3hwmx5pXNJyl8U8JpaivnyybrC6CUPDQ0hThOP4sC5SBRxRFozQ+
        E9EkAxZxSmTij82kCcVxTqA==
X-Received: by 2002:adf:de09:: with SMTP id b9mr18976056wrm.409.1596060620639;
        Wed, 29 Jul 2020 15:10:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwAVkmT45/6AHu0ZMgIzc+okxTAhaZCPNqOlK4XLAY29yq9rtl6Quhri6cx4tDK9mKXNiWkKA==
X-Received: by 2002:adf:de09:: with SMTP id b9mr18976036wrm.409.1596060620367;
        Wed, 29 Jul 2020 15:10:20 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:101f:6e7:e073:454c? ([2001:b07:6468:f312:101f:6e7:e073:454c])
        by smtp.gmail.com with ESMTPSA id z8sm6490516wmf.42.2020.07.29.15.10.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2020 15:10:19 -0700 (PDT)
Subject: Re: [PATCH 1/1] scsi: virtio-scsi: handle correctly case when all
 LUNs were unplugged
To:     Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org
Cc:     "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>,
        "open list:VIRTIO BLOCK AND SCSI DRIVERS" 
        <virtualization@lists.linux-foundation.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jason Wang <jasowang@redhat.com>
References: <20200729194806.4933-1-mlevitsk@redhat.com>
 <20200729194806.4933-2-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e56b2e4c-6dcd-1ec5-dde6-ef81c1f98e2a@redhat.com>
Date:   Thu, 30 Jul 2020 00:10:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200729194806.4933-2-mlevitsk@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 29/07/20 21:48, Maxim Levitsky wrote:
> Commit 5ff843721467 ("scsi: virtio_scsi: unplug LUNs when events missed"),
> almost fixed the case of mass unpluging of LUNs, but it missed a
> corner case in which all the LUNs are unplugged at the same time.
> 
> In this case INQUIRY ends with DID_BAD_TARGET.
> Detect this and unplug the LUN.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  drivers/scsi/virtio_scsi.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index 0e0910c5b9424..c7f0c22b6f11d 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -351,6 +351,16 @@ static void virtscsi_rescan_hotunplug(struct virtio_scsi *vscsi)
>  			/* PQ indicates the LUN is not attached */
>  			scsi_remove_device(sdev);
>  		}
> +
> +		else if (host_byte(result) == DID_BAD_TARGET) {
> +			/*
> +			 * if all LUNs of a virtio-scsi device are unplugged,
> +			 * it will respond with BAD TARGET on any INQUIRY
> +			 * command.
> +			 * Remove the device in this case as well
> +			 */
> +			scsi_remove_device(sdev);
> +		}
>  	}
>  
>  	kfree(inq_result);
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

