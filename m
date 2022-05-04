Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FAADC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  4 May 2022 08:47:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346495AbiEDIux (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 May 2022 04:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346403AbiEDIuw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 May 2022 04:50:52 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EFE324BD1
        for <linux-scsi@vger.kernel.org>; Wed,  4 May 2022 01:47:16 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id i19so1521947eja.11
        for <linux-scsi@vger.kernel.org>; Wed, 04 May 2022 01:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=QmtWwByo/ZIKuv6qy4yEByVOiPKOIaqS2BZn64y92Q4=;
        b=AL3CjXJc7FL0+ahMAGnCQ7qmyxM+AoFMp+n++syujpzPeLdz3G9e8SumISuj6OAEA0
         mN+gxfyTym9cCFHXVM2ma5gj6lTOqSS9+fFFVIN9K17+VhI/O5XELTfaBERRbjmSI/Nl
         vvObVZ+lE/oHjIPDG5c3kZEYjJQEe1NvGt+HsrQ0Q+6yNj+8se8zRPFmuQGMPF5BpxNO
         +M/mEz0tJP9w1V148yHSRWo5dQEAebdJpQrcp3fpkdmwYxogU+MGAbkl5NmYDLl3m4oe
         Nv5JLzbG6l6Ef2KxCmwdwW2oy1uCKa2pWneGeT1ndmrmk+5OUccDsfooF869KS0AeRi0
         oAQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QmtWwByo/ZIKuv6qy4yEByVOiPKOIaqS2BZn64y92Q4=;
        b=0ufSDOUjlWEnH+bN0Udri8Gfd4prCNQiH5pwlY/PXiHxJ5dg6k1oftZQzWt4icbPEj
         RnBw76RcFtv/I1Jy99+8wW6hk7ri7b70A8g82U8u9AlSWDHK4WHaPHDJEihdJQYLhkUT
         zqgZuBd63GKTcJuFAxZD0+zFrr5De8PtMl/cnkHa43V8l0a+r0kMOwWSoq8hWAiLZlqj
         lRG3/Gh9k8vRaB7mGLvKoqD599v9/33BdYkF/B3MJO1fpZUfwa9EzmzetZWfvYYwO5h6
         p8uAWBB1WWNbga/3S1jc2r3tSbzaQfPfWAn7LtrTlgh5VIav+XxsAg24iqSU9+933tzz
         H91g==
X-Gm-Message-State: AOAM5305aECEqH66N/Bo+vJCZAWesVTN7CxORDRFIZVQJFf3+vsJwNzL
        ly9lkvurhvOqoy6bBcbudTft/llZmkIz/Q==
X-Google-Smtp-Source: ABdhPJxKi7C4JKAEzHKaoMX1d2sBQ/HwAm7M6aW+7svbe2ak15MPFJVqHU4FxQsE+k7anyG0Uq+cjQ==
X-Received: by 2002:a17:906:4fc6:b0:6f4:b5c0:aa3f with SMTP id i6-20020a1709064fc600b006f4b5c0aa3fmr2810602ejw.382.1651654035170;
        Wed, 04 May 2022 01:47:15 -0700 (PDT)
Received: from [192.168.0.210] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id b6-20020aa7cd06000000b0042617ba63a9sm8799226edw.51.2022.05.04.01.47.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 May 2022 01:47:14 -0700 (PDT)
Message-ID: <38ddc169-7e8d-c8b5-62cb-7fd3de567e91@linaro.org>
Date:   Wed, 4 May 2022 10:47:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 2/4] scsi: core: fix white-spaces
Content-Language: en-US
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220408103027.311624-1-krzysztof.kozlowski@linaro.org>
 <20220408103027.311624-2-krzysztof.kozlowski@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220408103027.311624-2-krzysztof.kozlowski@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 08/04/2022 12:30, Krzysztof Kozlowski wrote:
> Remove trailing white-spaces and correct mixed-up indentation.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---
>  drivers/scsi/scsi_debug.c         |  2 +-
>  drivers/scsi/scsi_priv.h          |  4 +--
>  drivers/scsi/scsi_proc.c          | 14 ++++-----
>  drivers/scsi/scsi_scan.c          | 10 +++----
>  drivers/scsi/scsi_sysfs.c         |  4 +--
>  drivers/scsi/scsi_transport_spi.c | 49 +++++++++++++++----------------
>  drivers/scsi/scsicam.c            |  6 ++--
>  include/scsi/scsi_cmnd.h          |  2 +-
>  include/scsi/scsi_device.h        | 10 +++----
>  include/scsi/scsi_host.h          | 13 ++++----
>  include/scsi/scsi_ioctl.h         |  2 +-
>  include/scsi/scsi_transport.h     |  2 +-
>  include/scsi/scsi_transport_spi.h |  2 +-
>  include/scsi/scsicam.h            |  2 +-
>  include/scsi/sg.h                 |  2 +-
>  15 files changed, 61 insertions(+), 63 deletions(-)

Hi folks!

I understand that patch #1 in the series is discussed/needs followup,
but what about patches 2-4? Could you pick them up?

Best regards,
Krzysztof
