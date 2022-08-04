Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C54EC19F2A
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Aug 2022 18:25:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239971AbiHDSZ4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Aug 2022 14:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiHDSZx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Aug 2022 14:25:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 528567654
        for <linux-scsi@vger.kernel.org>; Thu,  4 Aug 2022 11:25:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659637551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eu38hbsbYedljKmTmzkaBjl8sS5qPI4aYDQRaE3sos0=;
        b=XfVwcifnArQD6cIBwnWiEmrNeozOoOeNobdCVpiqenH02IPAchw9qTBQQ0bEL6+lrFQKix
        r7S/wtrrRIqvNFG8eC+lT4scBaDZCcLee96KzFnjz9zE68Eio5sHcHAGPJjsVMCJ8rdSmR
        vWULm35RivZ/UkxIX5l7R2RYwtPXKjg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-108--2OXw-MYPCuCmhHsgIftEg-1; Thu, 04 Aug 2022 14:25:50 -0400
X-MC-Unique: -2OXw-MYPCuCmhHsgIftEg-1
Received: by mail-wm1-f70.google.com with SMTP id i186-20020a1c3bc3000000b003a4fe025c91so184783wma.4
        for <linux-scsi@vger.kernel.org>; Thu, 04 Aug 2022 11:25:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=eu38hbsbYedljKmTmzkaBjl8sS5qPI4aYDQRaE3sos0=;
        b=1BIELGHpP+mfvblcVKnSan6liW6BUBslcp/3IAt3MX/ZzVv3iiRbsJboSrBEtdI5vH
         sXCjf7hl9IygqlgagfRxgRn15kX7FQC+WiJ7v9X3+q/YPzqGlkqlZIPO3haCakitKTD6
         tFzsIx7pi1+ro6ES/kTu76Fs42TfpUXT5VQynIyoiucb9binxSkVQJeB4rIyngNeNVQu
         UI59d7DyuSrcGolDdU/Lyx4c1jZ2ncjsH3MKxsxzV05plw7GBB4Gca8zngVYKanzpqcY
         tWu6DBn4ep6nGMinYwdE1la90oY0js+9QPrNbifNSpU2F0aI+0nNd8b39c5MiV70xane
         fx4g==
X-Gm-Message-State: ACgBeo3Uv5l/xn3xs2sXqxoZyM0hJJgQ2mhhDzRpgbM9833rRMVf6o6V
        NCHg1xCSrhfUylXyVFpEMOtRo+Fgg+3TxTdMX0B7ZkebSeDF57w4Tiso2r7Sq8tObNWj2B6Fuw+
        Q4AEFrjF1UOZDh6KnOnnw7A==
X-Received: by 2002:a5d:694c:0:b0:21e:bac1:478b with SMTP id r12-20020a5d694c000000b0021ebac1478bmr2225168wrw.351.1659637549167;
        Thu, 04 Aug 2022 11:25:49 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7jRbpO+mW3V9Ywty8/L7N9M72gy5OWjhkXahD/DV3axcdm8js4iFpooUfi6ezdDyv3iotP6g==
X-Received: by 2002:a5d:694c:0:b0:21e:bac1:478b with SMTP id r12-20020a5d694c000000b0021ebac1478bmr2225153wrw.351.1659637548943;
        Thu, 04 Aug 2022 11:25:48 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id j14-20020a5d464e000000b0021e30e9e44asm1950252wrs.53.2022.08.04.11.25.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Aug 2022 11:25:48 -0700 (PDT)
Message-ID: <40045672-5657-06c3-8ae1-35b2ada403ee@redhat.com>
Date:   Thu, 4 Aug 2022 20:25:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 05/10] scsi: virtio_scsi: Drop DID_NEXUS_FAILURE use.
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, jgross@suse.com,
        njavali@marvell.com, jasowang@redhat.com, mst@redhat.com,
        stefanha@redhat.com, oneukum@suse.com, manoj@linux.ibm.com,
        mrochs@linux.ibm.com, ukrishn@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20220804034100.121125-1-michael.christie@oracle.com>
 <20220804034100.121125-6-michael.christie@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220804034100.121125-6-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/4/22 05:40, Mike Christie wrote:
> DID_NEXUS_FAILURE is internal to the SCSI layer. Drivers must not use it
> because:
> 
> 1. It's not propagated upwards, so SG IO/passthrough users will not see an
> error and think a command was successful.
> 
> 2. There is no handling for them in scsi_decide_disposition so it results
> in the scsi eh running.
> 
> It looks like virtio_scsi gets this when something like qemu returns
> VIRTIO_SCSI_S_NEXUS_FAILURE. It looks like qemu returns that error code
> if host OS returns DID_NEXUS_FAILURE (qemu's internal
> SCSI_HOST_RESERVATION_ERROR maps to DID_NEXUS_FAILURE). This shouldn't
> happen for linux since we don't propagate that error code to userspace.
> 
> This has us convert VIRTIO_SCSI_S_NEXUS_FAILURE to a
> SAM_STAT_RESERVATION_CONFLICT in case some other virt layer is returning
> it. In that case we will still get the reservation confict failure we
> expect.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/scsi/virtio_scsi.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index 112d8c3962b0..00cf6743db8c 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -144,7 +144,7 @@ static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
>   		set_host_byte(sc, DID_BAD_TARGET);
>   		break;
>   	case VIRTIO_SCSI_S_NEXUS_FAILURE:
> -		set_host_byte(sc, DID_NEXUS_FAILURE);
> +		set_status_byte(sc, SAM_STAT_RESERVATION_CONFLICT);
>   		break;
>   	default:
>   		scmd_printk(KERN_WARNING, sc, "Unknown response %d",

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

