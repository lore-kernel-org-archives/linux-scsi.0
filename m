Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7BF2C19F2D
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Aug 2022 20:09:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345988AbiHIUJR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Aug 2022 16:09:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346349AbiHIUI4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Aug 2022 16:08:56 -0400
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D91727B23
        for <linux-scsi@vger.kernel.org>; Tue,  9 Aug 2022 13:08:54 -0700 (PDT)
Received: by mail-pl1-f169.google.com with SMTP id z19so12349909plb.1
        for <linux-scsi@vger.kernel.org>; Tue, 09 Aug 2022 13:08:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=lfkoY2KizPVDu3nif3e8Y8atl50YnhA9dg8psig0sDM=;
        b=MYmQBix7wfljCxBaQV6fDSGWlHURG6RdALTdllMFkR9x9xY1FGLFySz5+kv8shFGrw
         crufTJ4ZOCqM9hji0mlmldWPn+GyEDoiNDMdcH21n/ja1uog/Iz3FPi8FwIubbbS+ml5
         rKAzr048hM4l8+nrJpIFtrkwWFMU+LVuVFI326ngLtDj/3wBIqVsidArl0/BYu1Vteqn
         NHPLhRldRRymjekRyoBcN3s9RPqiUmirFbzuzz82Bu4/0FJpF645SFdOZwl2gThf5/+u
         mRfGqeORZlgOW0oYSbyVqi/9YaZpG3qtX5MSdB4pLLVr4N4u0DO76HsZlpCyBsAAjGgO
         +4Yg==
X-Gm-Message-State: ACgBeo3t43Hxy9Q8kEKyAs16aOq2JCdDtlIMpxH9kLTggTKkhf8Lpnq3
        q37Fqil3iwMjhQqckrv4PMsQQwyX8CE=
X-Google-Smtp-Source: AA6agR6olFHLyVgnTPrT1fryrdj1Z7pzLfVN+Tpx1eUFjedrfJXJCvulEU4kT8ZwdLSXbmzNqifD8A==
X-Received: by 2002:a17:90b:1b43:b0:1f5:4b1b:5e91 with SMTP id nv3-20020a17090b1b4300b001f54b1b5e91mr177675pjb.204.1660075733733;
        Tue, 09 Aug 2022 13:08:53 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:61e9:2f41:c2d4:73d? ([2620:15c:211:201:61e9:2f41:c2d4:73d])
        by smtp.gmail.com with ESMTPSA id p3-20020a170902ebc300b0016dbdf7b97bsm11062083plg.266.2022.08.09.13.08.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 13:08:52 -0700 (PDT)
Message-ID: <ea92856e-1407-414c-4bfc-cae56a3014c9@acm.org>
Date:   Tue, 9 Aug 2022 13:08:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 10/10] scsi: Remove useless host error codes.
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, jgross@suse.com,
        njavali@marvell.com, pbonzini@redhat.com, jasowang@redhat.com,
        mst@redhat.com, stefanha@redhat.com, oneukum@suse.com,
        manoj@linux.ibm.com, mrochs@linux.ibm.com, ukrishn@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20220804034100.121125-1-michael.christie@oracle.com>
 <20220804034100.121125-11-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220804034100.121125-11-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/3/22 20:41, Mike Christie wrote:
> The host codes that were supposed to only be used for internal use are
> now not used, so remove them.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   include/scsi/scsi_status.h | 12 ++++++------
>   1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/include/scsi/scsi_status.h b/include/scsi/scsi_status.h
> index 31d30cee1869..9cb85262de64 100644
> --- a/include/scsi/scsi_status.h
> +++ b/include/scsi/scsi_status.h
> @@ -62,12 +62,12 @@ enum scsi_host_status {
>   					 * recover the link. Transport class will
>   					 * retry or fail IO */
>   	DID_TRANSPORT_FAILFAST = 0x0f, /* Transport class fastfailed the io */
> -	DID_TARGET_FAILURE = 0x10, /* Permanent target failure, do not retry on
> -				    * other paths */
> -	DID_NEXUS_FAILURE = 0x11,  /* Permanent nexus failure, retry on other
> -				    * paths might yield different results */
> -	DID_ALLOC_FAILURE = 0x12,  /* Space allocation on the device failed */
> -	DID_MEDIUM_ERROR = 0x13,  /* Medium error */
> +	/*
> +	 * We used to have DID_TARGET_FAILURE, DID_NEXUS_FAILURE,
> +	 * DID_ALLOC_FAILURE and DID_MEDIUM_ERROR at 0x10 - 0x13. For compat
> +	 * with userspace apps that parse the host byte for SG IO, we leave
> +	 * that block of codes unused and start at 0x14 below.
> +	 */
>   	DID_TRANSPORT_MARGINAL = 0x14, /* Transport marginal errors */
>   };

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
