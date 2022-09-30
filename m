Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9F6BC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Sep 2022 00:12:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbiI3AMW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Sep 2022 20:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiI3AMU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Sep 2022 20:12:20 -0400
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C423A1129E1
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 17:12:17 -0700 (PDT)
Received: by mail-pf1-f178.google.com with SMTP id a80so2837626pfa.4
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 17:12:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=mxUhn0mTWwVzrzZXpXmSC4hJewItJI2MKon1eC8nEqg=;
        b=Dtv7f+QvPHcncNW/Obq56gPU2DiBkOr/uEDgQs1DB3DHA02W9DQeyggbDFWi332OKW
         eS1ky3Ll5qXqFZm0rcXMOfia60rDLOCjk8NrrOn6jXZCH0Ui3x//+DQvmeGaP1dYVDxj
         hY8fF5BAUa7JkJ+g5z8DuQv9+dU1i9P1GEz6li8b4klPw9QuaA3H5wWLSsKmIRPfgV9y
         532MYkVpuiyJ9gQfDV3zqzvhOcEiAS50F3E0AD8ULVlKjvkIryrO9o+Mqaiv1GSFueX2
         avbxc75Z2xlwlRzncz6niiHyFIoZaMEw4xZylPQJxr8XB5JwKVYpHi/77N60XhW8xKMW
         tZ6Q==
X-Gm-Message-State: ACrzQf0EYs+xok9DC5EEBJglsuNSuGTOVw/YrQtZINdSrs0X8qxktYK/
        exvgRiNptG4QaNHEKAjUoJw=
X-Google-Smtp-Source: AMsMyM5ETPH8tDDu2ucSMU7yxoVtbhA/4jOX2ZgIbtGbkyfwZAVtqbiCTc6roJ6+7wXit7hu/WUPkA==
X-Received: by 2002:a63:18c:0:b0:43c:b924:342c with SMTP id 134-20020a63018c000000b0043cb924342cmr5111131pgb.496.1664496737250;
        Thu, 29 Sep 2022 17:12:17 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:56f2:482f:20c2:1d35? ([2620:15c:211:201:56f2:482f:20c2:1d35])
        by smtp.gmail.com with ESMTPSA id w25-20020a637b19000000b004340d105fd4sm502144pgc.21.2022.09.29.17.12.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Sep 2022 17:12:16 -0700 (PDT)
Message-ID: <046b3307-7a7a-80e0-e34a-9fb11171e241@acm.org>
Date:   Thu, 29 Sep 2022 17:12:14 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v2 03/35] scsi: Add struct for args to execution functions
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20220929025407.119804-1-michael.christie@oracle.com>
 <20220929025407.119804-4-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220929025407.119804-4-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/28/22 19:53, Mike Christie wrote:
> +int __scsi_exec_req(struct scsi_exec_args *args)

Has it been considered to change the argument list into "const struct
scsi_exec_args *args"?

> -#define scsi_execute(sdev, cmd, data_direction, buffer, bufflen, sense,	\
> -		     sshdr, timeout, retries, flags, rq_flags, resid)	\
> +#define scsi_execute(_sdev, _cmd, _data_dir, _buffer, _bufflen, _sense,	\
> +		     _sshdr, _timeout, _retries, _flags, _rq_flags,	\
> +		     _resid)						\

I don't think that the added underscores are necessary. Has it been
considered not to change the argument names?

Thanks,

Bart.
