Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC5A5C54EE9
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Sep 2022 16:25:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbiISQZU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Sep 2022 12:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbiISQZR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Sep 2022 12:25:17 -0400
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 246FC31DCD
        for <linux-scsi@vger.kernel.org>; Mon, 19 Sep 2022 09:25:15 -0700 (PDT)
Received: by mail-pl1-f181.google.com with SMTP id w20so16311680ply.12
        for <linux-scsi@vger.kernel.org>; Mon, 19 Sep 2022 09:25:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=PdD332cfLSFspbljbqZ3rL5eMxMc8503UuRtPaoqp88=;
        b=1tWCtTqIhYlA0iiXDYqCdwcs/OFu2Gve1wyt6CDzd+bEkU//hmOuxCg56ceEECqjZL
         NmNu39lUcfiHCNSEcg1fiVWjU6DPdbe1C+duhDvd4IB+XOCMaFwFAjeENBJ3DQxbDeO6
         lckGa+Ec6/6EBSHh3Jkb7hDpieso5N9mnXpDl7U/NzsrPOiiY+3mgFXl2RCjD8aQTAq3
         ktrnkdaP7JauANjjdwGajnMTlizl4U/awllKT1VZaAEGSY9bS9LY8FzmzQwjNYwP+rGb
         yp6PVwusSBCLZgDw+XjH0Ko8lcv0fsdxiItB1yTsmGOqCaSuYUrKERKVnDIoISd7qWgo
         benw==
X-Gm-Message-State: ACrzQf3gCf+7x2ZU/g7WgyU++QGsJ637vxurndKMkN8ubYTb+yWdp294
        4nJjRBCorx/F2WYr3OKXQyQ=
X-Google-Smtp-Source: AMsMyM51d4bdzZ9v0QKCiJcEzOa6v0GxOCk3hpbzBEq7ihgMU/5VClVVxRpNZrN/C1mmhPzB2UoZNA==
X-Received: by 2002:a17:90b:3ec1:b0:203:5eef:fe1e with SMTP id rm1-20020a17090b3ec100b002035eeffe1emr16248910pjb.143.1663604715134;
        Mon, 19 Sep 2022 09:25:15 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:9b5b:c086:d392:8ccb? ([2620:15c:211:201:9b5b:c086:d392:8ccb])
        by smtp.gmail.com with ESMTPSA id t20-20020a62d154000000b0053653c6b9f9sm20463114pfl.204.2022.09.19.09.25.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Sep 2022 09:25:14 -0700 (PDT)
Message-ID: <4acf4f39-f6f8-6b65-2bc6-a4c5225d9a04@acm.org>
Date:   Mon, 19 Sep 2022 09:25:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v1] ufs: core: bypass get rpm when err handling with
 pm_op_in_progress
Content-Language: en-US
To:     Peter Wang <peter.wang@mediatek.com>, stanley.chu@mediatek.com,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com
References: <20220915115858.7642-1-peter.wang@mediatek.com>
 <4fadab02-5ab7-03d5-e849-55eaa26113cf@acm.org>
 <647e3423-94dc-f2c6-0fad-7896e709f291@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <647e3423-94dc-f2c6-0fad-7896e709f291@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/19/22 07:47, Peter Wang wrote:
> If the scsi error happened and need do ufshcd_eh_host_reset_handler, the 
> rpm state should in RPM_ACTIVE.
> Because scsi need wakeup suspended LUN, and send command to LUN then get 
> error, right?

The following sequence may activate the SCSI error handler while the RPM 
state is RPM_RESUMING:
* The RPM state is RPM_SUSPENDED.
* The RPM state is changed into RPM_RESUMING and ufshcd_wl_resume() is 
called.
* ufshcd_set_dev_pwr_mode() calls scsi_execute() and the START STOP UNIT 
command times out.
* Because of this timeout the SCSI error handler is activated.

> If remove ufshcd_rpm_get_sync directly, think about this case.
> ufshcd_err_handler is on going and try to abort some task (which may get 
> stuck and timeout too).
> Then rpm count down try to suspend. Finally runtime suspend callback may 
> return IO error and IO hang.

Hmm ... suspending a UFS device involves calling ufshcd_wl_shutdown(), 
ufshcd_set_dev_pwr_mode() and scsi_execute(). scsi_execute() is 
serialized against the UFS error handler because the latter calls 
ufshcd_scsi_block_requests().

Thanks,

Bart.
