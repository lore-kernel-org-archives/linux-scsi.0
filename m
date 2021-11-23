Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DB8BC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Nov 2021 17:54:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239397AbhKWR6E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Nov 2021 12:58:04 -0500
Received: from mail-pg1-f172.google.com ([209.85.215.172]:33653 "EHLO
        mail-pg1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235026AbhKWR6D (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Nov 2021 12:58:03 -0500
Received: by mail-pg1-f172.google.com with SMTP id f65so9345655pgc.0
        for <linux-scsi@vger.kernel.org>; Tue, 23 Nov 2021 09:54:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UGBkc6X+rsczA8LsDbnJ9D9yk/B2v/Vb1M1ghrKRWLU=;
        b=wyBk5dAHtbTwP9NJgS0WdRZch/KoXXDmE0Fctbhj+9YNQF536c/jpRmyKVtw62uW5T
         /8X9q1J6mGGcT07pV+bXtsCtawuRwRyGaAybrrjB1XpXzYGkpg1NCtvgke1Aj6sAxM5p
         WWW8KjLmd/KToncpbsBIh+zckWNXNie/zHaZsfQ1ZP/VPRWJJeoPNTdn9JSxNRXKDMGx
         yKFOBfndxbjWohPp0zEeScktGX5l9rDidAiSx08VsrjHgzp7kVRNJKFKCFuETHfTn6uK
         vcbsK/Mas+AgjUbBteiCtmmmGuTJFus6YQk4kOvD8ktEE0waCr2Nk0VEP5vXOAKkmRnZ
         POvg==
X-Gm-Message-State: AOAM533ccmHJIkll8zF4FW8VuDpDhKbg8Mvf8dw9nu0jAeEbbamyl0vP
        E6gQgSWcHMr4sOnnarXD7Jo=
X-Google-Smtp-Source: ABdhPJxr+kH3B5ZAtPYceNKBIN1bA6K4ZDfrlwX/jg9mwwWjp+rPRPLYX0tClgP0XR0yup8j/W8ioQ==
X-Received: by 2002:a63:6a03:: with SMTP id f3mr4999584pgc.393.1637690095262;
        Tue, 23 Nov 2021 09:54:55 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:58e8:6593:938:2bea])
        by smtp.gmail.com with ESMTPSA id c2sm13975806pfv.112.2021.11.23.09.54.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Nov 2021 09:54:54 -0800 (PST)
Subject: Re: [PATCH v2 11/20] scsi: ufs: Switch to
 scsi_(get|put)_internal_cmd()
To:     Bean Huo <huobean@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
References: <20211119195743.2817-1-bvanassche@acm.org>
 <20211119195743.2817-12-bvanassche@acm.org>
 <5dc2cf927a0e196067b7207ee1800a09cd769de6.camel@gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <afd691a0-a92a-46b2-1cd1-b820b5591158@acm.org>
Date:   Tue, 23 Nov 2021 09:54:53 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <5dc2cf927a0e196067b7207ee1800a09cd769de6.camel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/23/21 4:20 AM, Bean Huo wrote:
> On Fri, 2021-11-19 at 11:57 -0800, Bart Van Assche wrote:
>> @@ -6722,13 +6728,19 @@ static int
>> ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
>>   
>>   	down_read(&hba->clk_scaling_lock);
>>   
>> -	req = blk_mq_alloc_request(q, REQ_OP_DRV_OUT, 0);
>> -	if (IS_ERR(req)) {
>> -		err = PTR_ERR(req);
>> +	scmd = scsi_get_internal_cmd(q, DMA_TO_DEVICE, 0);
>> +	if (IS_ERR(scmd)) {
>> +		err = PTR_ERR(scmd);
>>   		goto out_unlock;
>>   	}
>> +	req = scsi_cmd_to_rq(scmd);
>>   	tag = req->tag;
>>   	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
>> +	/*
>> +	 * Start the request such that blk_mq_tag_idle() is called when
>> the
>> +	 * device management request finishes.
>> +	 */
>> +	blk_mq_start_request(req);
> 
> Bart,
> 
> Calling blk_mq_start_request() will inject the trace print of the block
> issued, but we do not have its paired completion trace print.
> In addition, blk_mq_tag_idle() will not be called after the device
> management request is completed, it will be called after the timer
> expires.
> 
> I remember that we used to not allow this kind of LLD internal commands
> to be attached to the block layer. I now find that to be correct way.

Hi Bean,

As you may remember commit d0b2b70eb12e ("scsi: ufs: core: Increase the
usable queue depth") introduced a blk_mq_start_request() call in
ufshcd_exec_dev_cmd() to restore the queue depth from 16 to 32. I think
we need the same fix in ufshcd_issue_devman_upiu_cmd(). How about modifying
patch 1/20 of this series such that tracing is skipped for internal
requests? Would that address your concern?

Thanks,

Bart.
