Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D836C19F2A
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Aug 2022 18:25:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239231AbiHDSZv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Aug 2022 14:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiHDSZu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Aug 2022 14:25:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 48D526572
        for <linux-scsi@vger.kernel.org>; Thu,  4 Aug 2022 11:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659637548;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FCpVDMoCcjr5AIeb6Cgkje6LCry82LiYDDuT0Fs4GgE=;
        b=bKa7XXpO/0ZI/Q5bXNjASdXkg5RFnuDVjHmvwdK0RwJxRVHY5n95PBbWrMBMww0sZmP+qA
        ZvnOGKAvhw2yVghu1sE4GXV05dufXFroXc6Y19RFNZ+p7muQB9t5sg/idOowvRjQGQIzn0
        GRdAOuOTexIocqCWKZGVuQC6J1wFYy4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-147-KATRqYTMOxWN05A1EOVnPQ-1; Thu, 04 Aug 2022 14:25:47 -0400
X-MC-Unique: KATRqYTMOxWN05A1EOVnPQ-1
Received: by mail-wm1-f71.google.com with SMTP id q10-20020a1ce90a000000b003a4f6e08166so87083wmc.5
        for <linux-scsi@vger.kernel.org>; Thu, 04 Aug 2022 11:25:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=FCpVDMoCcjr5AIeb6Cgkje6LCry82LiYDDuT0Fs4GgE=;
        b=2klTR2ASsBAqvMBWrBHMmQUAIBkATQ8BZIsN5Lc9xl+8sh4QqH/WxMqhrzPr8McTDI
         rdv9pCKGJs+dWKOZnLW4+9pxe29qG6smUnA/Q93mT39wdf6BXMN+qlRs9X7gXc94frI5
         S06geIlMIXy8iyCyducLPMSdFj6S2xe6ASDip2rtmxQUwZxg6Drx7INUEhGZZ+avYqbq
         o1vivpizA8Gp+Afv+3SmqnbpKUgvcgSZusWnr/4oSMXVgXqxIKuCA5XY2orgISYaUbPB
         ETp241x2wq/M+xbWM8IPl4ds6PU0Yu50tWfH+80WyatVIQnVI88f1n7ya5aVepfclRE6
         wBlw==
X-Gm-Message-State: ACgBeo2iwNIlb26Yt1I6XHBC1gI0syT+TDC2Sdw7Ld5zDziFwPvQpR/4
        I2olsULNpPDqyYbCYjh4kYf7hOukRuaHho72P1V/CoTuRmgf5C0TwEUQSuHjd/f+6krbpvYabfC
        b/CAcNNcA1PrtLCuYgjNdqA==
X-Received: by 2002:a05:600c:4ecd:b0:3a3:3eb0:9101 with SMTP id g13-20020a05600c4ecd00b003a33eb09101mr2330902wmq.49.1659637546216;
        Thu, 04 Aug 2022 11:25:46 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6rsVw7ktbrC2FLFtLoEEXUX7c6/OxLV6DP+octdJzpcfkyyUdI42D9auXSeMymYoBc6e/2CA==
X-Received: by 2002:a05:600c:4ecd:b0:3a3:3eb0:9101 with SMTP id g13-20020a05600c4ecd00b003a33eb09101mr2330891wmq.49.1659637545996;
        Thu, 04 Aug 2022 11:25:45 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id y10-20020adfe6ca000000b0021f0cf9e543sm2047071wrm.2.2022.08.04.11.25.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Aug 2022 11:25:45 -0700 (PDT)
Message-ID: <57ffe0ac-4af5-a011-035d-6bd543e694f8@redhat.com>
Date:   Thu, 4 Aug 2022 20:25:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 04/10] scsi: virtio_scsi: Drop DID_TARGET_FAILURE use.
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, jgross@suse.com,
        njavali@marvell.com, jasowang@redhat.com, mst@redhat.com,
        stefanha@redhat.com, oneukum@suse.com, manoj@linux.ibm.com,
        mrochs@linux.ibm.com, ukrishn@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20220804034100.121125-1-michael.christie@oracle.com>
 <20220804034100.121125-5-michael.christie@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220804034100.121125-5-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/4/22 05:40, Mike Christie wrote:
> DID_TARGET_FAILURE is internal to the SCSI layer. Drivers must not use it
> because:
> 
> 1. It's not propagated upwards, so SG IO/passthrough users will not see an
> error and think a command was successful.
> 
> 2. There is no handling for them in scsi_decide_disposition so it results
> in the scsi eh running.
> 
> It looks like virtio_scsi gets this when something like qemu returns
> VIRTIO_SCSI_S_TARGET_FAILURE. It looks like qemu returns that error code
> if a host OS returns it, but this shouldn't happen for linux since we
> never propagate that error to userspace.
> 
> This has us use DID_BAD_TARGET in case some other virt layer is returning
> it. In that case we will still get a hard error like before and it conveys
> something unexpected happened.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/scsi/virtio_scsi.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index 578c4b6d0f7d..112d8c3962b0 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -141,7 +141,7 @@ static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
>   		set_host_byte(sc, DID_TRANSPORT_DISRUPTED);
>   		break;
>   	case VIRTIO_SCSI_S_TARGET_FAILURE:
> -		set_host_byte(sc, DID_TARGET_FAILURE);
> +		set_host_byte(sc, DID_BAD_TARGET);
>   		break;
>   	case VIRTIO_SCSI_S_NEXUS_FAILURE:
>   		set_host_byte(sc, DID_NEXUS_FAILURE);

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

