Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 610BAC433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Oct 2022 17:52:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbiJTRwK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Oct 2022 13:52:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiJTRwJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Oct 2022 13:52:09 -0400
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B02A54B0DB
        for <linux-scsi@vger.kernel.org>; Thu, 20 Oct 2022 10:52:08 -0700 (PDT)
Received: by mail-pj1-f54.google.com with SMTP id v4-20020a17090a088400b00212cb0ed97eso85721pjc.5
        for <linux-scsi@vger.kernel.org>; Thu, 20 Oct 2022 10:52:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DmxCojt7JwOfqJmrk27Tb40z/rkKuPY71xQiDAeJCN0=;
        b=1EZ1G1si0OXRQtBQIkVUA1aQeM/UZ5LqCxxrHEECyxkUiJHgCWVDuEHgxDLpxYD6Qk
         HGvOObCyRsoivmRfG3gGKApSkSJsJ5Qvg2YwCa0WjR3xiSJ1SNsZkoRcd73LIzWqtxzN
         hovlqPPZ9KL+eP/LQYagY8ncvfMzFIUMGXIWh9B/7y3Yhxoa7fIIwUOYqyC2eOPdLK3x
         YF8BenbSE/CFRETA7xkcWX7YzQ02U+mNpKwuAI2tPHHhvx9DR5/pXRHJ9iivRnrUorFp
         O5iLukxQqyR3u8FD2BQYoMUesIWw9L7rBBJ+MUKy1IK4spvlM015VhhKDGz49/7GIoIw
         FxvQ==
X-Gm-Message-State: ACrzQf3geGkraPG8dgCW1oF1nEfpszXXRQEbjnhzYT7HdtawUpbjOS5S
        9tnCdyipcRBmmTp8OOv3pYs=
X-Google-Smtp-Source: AMsMyM4FXc7zd50qtTbl1kWKZawPZ83NQA4WjS+fHEYYh0v80tXKt+vlHdhfTd+1zoNnSxGUt6HIRw==
X-Received: by 2002:a17:90a:4ec6:b0:20a:96cd:2a46 with SMTP id v6-20020a17090a4ec600b0020a96cd2a46mr17676153pjl.171.1666288328102;
        Thu, 20 Oct 2022 10:52:08 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:e10c:786f:1f97:68bc? ([2620:15c:211:201:e10c:786f:1f97:68bc])
        by smtp.gmail.com with ESMTPSA id m8-20020a17090a414800b00210039560c0sm167125pjg.49.2022.10.20.10.52.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Oct 2022 10:52:07 -0700 (PDT)
Message-ID: <77dd1234-ff8a-e86e-f1ea-16cfd49582b1@acm.org>
Date:   Thu, 20 Oct 2022 10:52:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v4 06/36] hwmon: drivetemp: Convert to scsi_exec_req
Content-Language: en-US
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221016195946.7613-1-michael.christie@oracle.com>
 <20221016195946.7613-7-michael.christie@oracle.com>
 <01d9407a-26d1-e00b-8e52-04760af4b65a@acm.org>
 <787a0875-27c3-7bb8-8777-3d8b38635789@opensource.wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <787a0875-27c3-7bb8-8777-3d8b38635789@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/19/22 16:23, Damien Le Moal wrote:
> Anyway, while not being a fan of the function call + struct initialization
> all together, this looks correct to me.

Hi Damien,

I asked to make this change for scsi_execute() because Mike's patch 
series adds an argument to that macro and because I would like to add 
another argument to that macro. Adding a member to a struct is much 
easier than adding an additional argument to a macro and updating all 
callers.

Thanks,

Bart.
