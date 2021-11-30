Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BDA4C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Nov 2021 17:51:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244513AbhK3Ryp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Nov 2021 12:54:45 -0500
Received: from mail-pf1-f179.google.com ([209.85.210.179]:35395 "EHLO
        mail-pf1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245166AbhK3Rye (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Nov 2021 12:54:34 -0500
Received: by mail-pf1-f179.google.com with SMTP id p13so13722131pfw.2
        for <linux-scsi@vger.kernel.org>; Tue, 30 Nov 2021 09:51:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a2nGZGFevo0L5QZ8GgoJDbYtkpQxPLn6yN9V7JYpCS8=;
        b=pR6P8yvTHhArvYnDGd2IPc6Wh9lL+FKSYXYsy63dlcoWKa4NejwI6TVB31TFACmCdE
         qR9xBGc8v5NhVNHAsjGp0mTtpax70xFK975hfsBu7dzY2GXDTtt2T+i1n2TupHisic9b
         9rxorJoC/t790xzi6HvbxGJM0hhNTDIKbZAhTBmflF1rcg+YKmRD/2VKi4FPEYfy7Wzm
         8TKRUeUxF6fz5CUrxUoLuii+yOIdv6SudjU67utV1QvO+bDBUDeILGm06pMsS3NxfKEY
         ZRuILQDOfciZS+dZJox7iPKLimAZpTLifRkepwe7rbxtvRYPl317/Yl3ApR2XhJsmpoB
         dhEA==
X-Gm-Message-State: AOAM530P+Aa+3hecgrApCbbyG3IWV/rcmBQkHr0G4RI8j2t9tlj2G1ev
        qgklmn/x4SiOpWrVFUP8Tug=
X-Google-Smtp-Source: ABdhPJys82/8Fq4TxV3AwX0kr/AX99/h3o9STpZPpSnBvsRX0b4cSEwtsK9V5crBAfd6e9bOmGJ1OQ==
X-Received: by 2002:a63:90c8:: with SMTP id a191mr514925pge.482.1638294674976;
        Tue, 30 Nov 2021 09:51:14 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ef1f:f086:d1ba:8190])
        by smtp.gmail.com with ESMTPSA id j13sm20510794pfc.151.2021.11.30.09.51.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Nov 2021 09:51:14 -0800 (PST)
Subject: Re: [PATCH v2 11/20] scsi: ufs: Switch to
 scsi_(get|put)_internal_cmd()
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
References: <20211119195743.2817-1-bvanassche@acm.org>
 <20211119195743.2817-12-bvanassche@acm.org>
 <6bfb59ef-4f00-3918-59e6-3c9569f6adc6@intel.com>
 <bc19f55f-a3e9-a3fe-437d-57b9e077f532@acm.org>
 <1a9cddd9-b67a-be4b-4c83-3636f37e6769@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <2cb66e0a-df1e-0825-67b9-cbd2f116fe92@acm.org>
Date:   Tue, 30 Nov 2021 09:51:12 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <1a9cddd9-b67a-be4b-4c83-3636f37e6769@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/29/21 10:41 PM, Adrian Hunter wrote:
> On 29/11/2021 21:32, Bart Van Assche wrote:
>> * The code in blk_cleanup_queue() that waits for pending requests to finish
>>    before resources associated with the request queue are freed.
>>    ufshcd_remove() calls blk_cleanup_queue(hba->cmd_queue) and hence waits until
>>    pending device management commands have finished. That would no longer be the
>>    case if the block layer is bypassed to submit device management commands.
> 
> cmd_queue is used only by the UFS driver, so if the driver is racing with
> itself at "remove", then that should be fixed. The risk is not that the UFS
> driver might use requests, but that it might still be operating when hba or
> other resources get freed.
> 
> So the question remains, for device commands, we do not need the block
> layer, nor SCSI commands which still begs the question, why involve them
> at all?

By using the block layer request allocation functions the block layer guarantees
that each tag is in use in only one context. When bypassing the block layer code
would have to be inserted in ufshcd_exec_dev_cmd() and ufshcd_issue_devman_upiu_cmd()
to serialize these functions. In other words, we would be duplicating existing
functionality if we bypass the block layer. The recommended approach in the Linux
kernel is not to duplicate existing functionality.

Thanks,

Bart.


