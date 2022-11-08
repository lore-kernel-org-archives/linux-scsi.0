Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7568BC433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Nov 2022 23:57:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiKHX5Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Nov 2022 18:57:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbiKHX5P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2022 18:57:15 -0500
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E62EC60E89
        for <linux-scsi@vger.kernel.org>; Tue,  8 Nov 2022 15:57:13 -0800 (PST)
Received: by mail-pl1-f182.google.com with SMTP id l2so15548828pld.13
        for <linux-scsi@vger.kernel.org>; Tue, 08 Nov 2022 15:57:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KEYsrmcKqs20vMch/WIhQhq1D9Yp8ZTqB0AwfS0/PCI=;
        b=AGY7ruuY50EW8IlT1ZpUSeYNIQCoxuv3qz2/KCI7vIO/hqYBjpIRCXz4rfP66MQXia
         3nY66UgEjhuHceZ0V4JgVL3pvhVqUepNEVMR0te9mdhuedQDnzScnEGza7c6rjCTS1jR
         EV4fl+L2dxLc4nyz37QTpv+APBBgGqUOHdQPJ6+TQBKSnwE61wtSP6JmoxVRsGs8kftV
         5/WRESO+X04JOsoLF9ElbhqyZ/HWk+8ccdSUjKL1EPK69I6+gKGKEvRiyW9ZVLTT/R4u
         pRkbxfJszZly0P01blC5F/HTvLSCRQF17j7/XblVnuqEDx76Vqy1p177cLATIp1wuUAs
         Fb9g==
X-Gm-Message-State: ACrzQf0dgvYIbpsuuuvi8P2eVde+zUarvOE+mFg/BaO6u/981juNqVgs
        ekm6c+t/5uy2vau3zYwzXYA=
X-Google-Smtp-Source: AMsMyM7lihg1jtOrAva0+X/1zZjPqHg0tiaEl3R8TTYl4QuMs9pLlW/KW6CAKY/fnfr/Rx9cVaEUAg==
X-Received: by 2002:a17:902:e405:b0:186:b1bb:147a with SMTP id m5-20020a170902e40500b00186b1bb147amr57949647ple.19.1667951833331;
        Tue, 08 Nov 2022 15:57:13 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:44ad:aec5:7cab:4532? ([2620:15c:211:201:44ad:aec5:7cab:4532])
        by smtp.gmail.com with ESMTPSA id p64-20020a625b43000000b0056bdc3f5b29sm6868496pfb.186.2022.11.08.15.57.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Nov 2022 15:57:12 -0800 (PST)
Message-ID: <132f8a3a-1cee-e660-4fb7-3a09ab22c10b@acm.org>
Date:   Tue, 8 Nov 2022 15:57:10 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v6 02/35] scsi: Allow passthrough to override what errors
 to retry
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221104231927.9613-1-michael.christie@oracle.com>
 <20221104231927.9613-3-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221104231927.9613-3-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/4/22 16:18, Mike Christie wrote:
> +/**
> + * scsi_check_passthrough - Determine if passthrough scsi_cmnd needs a retry.
> + * @scmd: scsi_cmnd to check.
> + *
> + * Return value:
> + *	SCSI_RETURN_NOT_HANDLED - if the caller should process the command

Should "process the command" perhaps be changed into "examine the 
command status" since SCSI devices process SCSI commands while 
scsi_check_passthrough() callers examine the command status? Otherwise 
this patch looks good to me. Hence:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
