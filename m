Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EA6EC433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Oct 2022 23:47:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbiJDXrh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Oct 2022 19:47:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiJDXrg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Oct 2022 19:47:36 -0400
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0180295B8
        for <linux-scsi@vger.kernel.org>; Tue,  4 Oct 2022 16:47:34 -0700 (PDT)
Received: by mail-pg1-f181.google.com with SMTP id s206so13965050pgs.3
        for <linux-scsi@vger.kernel.org>; Tue, 04 Oct 2022 16:47:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=K4bvHpuVcqZ10ZZ3PYid45qPQGGLjHZW1yXv/nu1Hps=;
        b=piD1oDaKPi6Tm5Y75uHL3r8Ya8U+8K1QNx9JQDnQ55QFXiopByCjuOL0rf0lWrGjUr
         vQ+Xz6pakoI9ptPc8Mee6mMTL9RaF0gawQwWn6xCnV/aRzcbLJrWyqrUQkDbE7unf020
         eITcB5AcOSrR9eanULWiHNCNHGqSBkg1PGpErXnmBsGDXm4y6f7SkofEzlJ6fL+6L5uw
         CTh3hqNbKIvVDBla0b/HasHQRJF4OKiwAzNc4uoUKfmON4oTLy3EiHxt2hKoiCroa80z
         N1IHSbiUmy2GL9mohh7rXU6S9vLmsh75Y+g200koyNIqZr33CZN6ejd3j5nV+4otX2aA
         8o/A==
X-Gm-Message-State: ACrzQf0ZdNSuNCI1V9KQk5rs8AROqX9izU1a/SHsNkI0+gc7r8vzFs0C
        Xpg2pJ+q5p0fdZ1CnOW1Pp8=
X-Google-Smtp-Source: AMsMyM559W7hv1uBOBTWfvG4kBKytyyunazNyFTHWy2MSyR1XfloUdbISe5BDfrGez1WcbPMpQYbyw==
X-Received: by 2002:a63:5547:0:b0:456:c63b:7139 with SMTP id f7-20020a635547000000b00456c63b7139mr3292263pgm.179.1664927253342;
        Tue, 04 Oct 2022 16:47:33 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:b6b5:f763:ff03:8283? ([2620:15c:211:201:b6b5:f763:ff03:8283])
        by smtp.gmail.com with ESMTPSA id z29-20020a634c1d000000b0040caab35e5bsm8938614pga.89.2022.10.04.16.47.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Oct 2022 16:47:32 -0700 (PDT)
Message-ID: <8284352c-985d-fece-ce06-4855f6b42bdd@acm.org>
Date:   Tue, 4 Oct 2022 16:47:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v3 22/35] scsi: Have scsi-ml retry read_capacity_16 errors
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221003175321.8040-1-michael.christie@oracle.com>
 <20221003175321.8040-23-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221003175321.8040-23-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/3/22 10:53, Mike Christie wrote:
> +	memset(cmd, 0, 16);
> +	cmd[0] = SERVICE_ACTION_IN_16;
> +	cmd[1] = SAI_READ_CAPACITY_16;
> +	cmd[13] = RC16_LEN;

Can the cmd[] declaration be changed into a static const array declaration?

Thanks,

Bart.
