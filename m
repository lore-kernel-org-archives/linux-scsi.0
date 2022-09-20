Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93102C54EE9
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Sep 2022 18:25:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbiITSZL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Sep 2022 14:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbiITSZJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Sep 2022 14:25:09 -0400
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8182936875
        for <linux-scsi@vger.kernel.org>; Tue, 20 Sep 2022 11:25:08 -0700 (PDT)
Received: by mail-pj1-f48.google.com with SMTP id rt12so1499188pjb.1
        for <linux-scsi@vger.kernel.org>; Tue, 20 Sep 2022 11:25:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=U+IcVK+v4CCuYArCNziI40d9nX4GKcgElGsEyRL6zqE=;
        b=fR75wS7rl5zf0mO0huWSZUI7hlVLPRC8WTV8rmO7OyctKmy0KKXcOr/Dq57jMcgMw5
         ZXDQgT519/Qt6lKg7fTlYXFZqX7/JWAlVDaAJLkNLl0US/9kTar7Kh9oZ9UiFJPNa2Hn
         E0hUuHYuKeF56GWqRmWBSdf3ReTASNkuZXsbYFGglbVf2zNKkI2iAfixH3jfNpqInUop
         /RUALDV0w5bJPMMZzRO4JtAUFrrCe6AOGjiZwJSUpN9yNxKjS6UsAfA5L3gRvBP5iFAH
         fCpOVXHwiWDACxvUUeq9IReL85j4qWCb2XQ3SZ+9EOtHswDttVKIvMsvmJi6zRhDtNiX
         X35w==
X-Gm-Message-State: ACrzQf3x4MuHcNuvQeV2q4dy2DILQ4KQFkTOWbfX8I8L2Dy5vpTjsRgg
        k3OlUDhC4kr9QEZCN39KA9o=
X-Google-Smtp-Source: AMsMyM73dqtDqEEhJL50ZyYJFr+TuE2WH4w3NVLhlUhDM9QKcQLeIjQAhUkThz1APHaiTtGhbDA2Mg==
X-Received: by 2002:a17:90b:1d07:b0:203:6732:e280 with SMTP id on7-20020a17090b1d0700b002036732e280mr5098215pjb.172.1663698307895;
        Tue, 20 Sep 2022 11:25:07 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:c7e0:1691:74c9:2e9? ([2620:15c:211:201:c7e0:1691:74c9:2e9])
        by smtp.gmail.com with ESMTPSA id u20-20020a627914000000b00540a8074c9dsm202759pfc.166.2022.09.20.11.25.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Sep 2022 11:25:06 -0700 (PDT)
Message-ID: <10519b85-7b5d-17cf-e5be-640129a5ad7c@acm.org>
Date:   Tue, 20 Sep 2022 11:25:04 -0700
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
 <4acf4f39-f6f8-6b65-2bc6-a4c5225d9a04@acm.org>
 <aec67382-d9d4-052a-50c4-574cf5c4a501@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <aec67382-d9d4-052a-50c4-574cf5c4a501@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/19/22 19:00, Peter Wang wrote:
> 
> On 9/20/22 00:25, Bart Van Assche wrote:
>> On 9/19/22 07:47, Peter Wang wrote:
>>> If the scsi error happened and need do ufshcd_eh_host_reset_handler, 
>>> the rpm state should in RPM_ACTIVE.
>>> Because scsi need wakeup suspended LUN, and send command to LUN then 
>>> get error, right?
>>
>> The following sequence may activate the SCSI error handler while the 
>> RPM state is RPM_RESUMING:
>> * The RPM state is RPM_SUSPENDED.
>> * The RPM state is changed into RPM_RESUMING and ufshcd_wl_resume() is 
>> called.
>> * ufshcd_set_dev_pwr_mode() calls scsi_execute() and the START STOP 
>> UNIT command times out.
>> * Because of this timeout the SCSI error handler is activated.
> 
> This case will not get rpm, because pm_op_in_progress is true.
> 
> So it won't hang with ufshcd_rpm_get_sync.

Right, but I think the following scenario will result in a hang:
* The RPM state is changed from RPM_SUSPENDED into RPM_RESUMING and
   ufshcd_wl_resume() has not yet been called.
* ufshcd_eh_host_reset_handler() queues ufshcd_err_handler() and the
   latter function calls ufshcd_rpm_get_sync().
* This results in a deadlock: the scsi_execute() call by
   ufshcd_wl_resume() cannot make progress because the SCSI host state is
   SHOST_RECOVERY and the error handler cannot make progress because it
   keeps waiting until ufshcd_rpm_get_sync() has finished.

Thanks,

Bart.
