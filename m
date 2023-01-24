Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F4150C25B50
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Jan 2023 19:38:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234875AbjAXTiS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Jan 2023 14:38:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234777AbjAXTiA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jan 2023 14:38:00 -0500
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5452402DA;
        Tue, 24 Jan 2023 11:37:14 -0800 (PST)
Received: by mail-pl1-f177.google.com with SMTP id c6so15780235pls.4;
        Tue, 24 Jan 2023 11:37:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9JvOanYYuxIDAMqxsWY9Jti5vr+KRQq4vg9mQlqlcNk=;
        b=fzr1HzKvrqdhfMKtplZvoxwwJ3c+NtphCwl/7qPc+crsPxjag1JF7AlV0i8tUqq5oO
         6IZ0MnkccvyYH7S0rYiG46BvlHB5P1i9piGwjEYF3k45re5sjrq6uxMn9amFe8szV50x
         9/HpE/q2qIcumT4O0qNS/x21JIZCVURugSDV5Yyte7K7SRInqV9HigXFJJ7D5ZIImRmH
         qkE3vKRpzCLG4KTrOlz4PMoMwl73s6Nqx9EwARTmDaSfmq19uMWtCVGIBIBYOxHWmxHK
         S7dWfHeXC3dAnQPc5EVCE4m2Cjk2mnpM3TjJ4RjfTkUvcYJcOy+nNLVbptVYo83lz7CM
         /GAA==
X-Gm-Message-State: AFqh2kruLwmXUUi1iZzsmEMFsShOo+ZCCiU8551bSPv19cHoQxA4jF/n
        43Nz5E7OS/RDs6B16eqf55s=
X-Google-Smtp-Source: AMrXdXtfZq7L9g3DdrJ/tB5P+520DH2kUunNBr+XRP8mNuIwkwI+eeSMBJsDKgmM+BBu8zLSMMx7Iw==
X-Received: by 2002:a17:902:ba88:b0:193:1fc5:f611 with SMTP id k8-20020a170902ba8800b001931fc5f611mr29344802pls.38.1674588968714;
        Tue, 24 Jan 2023 11:36:08 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:c69a:cf2c:dc2d:7829? ([2620:15c:211:201:c69a:cf2c:dc2d:7829])
        by smtp.gmail.com with ESMTPSA id d13-20020a170902728d00b00174f61a7d09sm2027160pll.247.2023.01.24.11.36.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jan 2023 11:36:07 -0800 (PST)
Message-ID: <c76433d4-1eb2-1bfd-99ac-e1c7ae2a5e09@acm.org>
Date:   Tue, 24 Jan 2023 11:36:05 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v3 06/18] scsi: support service action in
 scsi_report_opcode()
Content-Language: en-US
To:     Niklas Cassel <niklas.cassel@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20230124190308.127318-1-niklas.cassel@wdc.com>
 <20230124190308.127318-7-niklas.cassel@wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230124190308.127318-7-niklas.cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/24/23 11:02, Niklas Cassel wrote:
> From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> 
> The REPORT_SUPPORTED_OPERATION_CODES command allows checking for support
> of commands that have the same opcode but different service actions,
> such as READ 32 and WRITE 32. However, the current implementation of
> scsi_report_opcode() only allows checking an operation code without a
> service action differentiation.
> 
> Add the "sa" argument to scsi_report_opcode() to allow passing a service
> action. If a non-zero service action is specified, the reporting
> options field value is set to 3 to have the service action field taken
> into account by the device. If no service action field is specified
> (zero), the reporting options field is set to 1 as before.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

