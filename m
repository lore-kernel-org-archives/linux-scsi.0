Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C6F2C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 18:58:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44ED560EE9
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 18:58:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233469AbhKJTAv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Nov 2021 14:00:51 -0500
Received: from mail-pj1-f43.google.com ([209.85.216.43]:34553 "EHLO
        mail-pj1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233227AbhKJS64 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Nov 2021 13:58:56 -0500
Received: by mail-pj1-f43.google.com with SMTP id j5-20020a17090a318500b001a6c749e697so2364778pjb.1
        for <linux-scsi@vger.kernel.org>; Wed, 10 Nov 2021 10:56:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7m6xIDBLrw+vu4PHyTxnwX8y3h4xm1beFCH/SsJU4bU=;
        b=kLiacUhnW1lVXyi9cWgDx79zD5slfrJKqan4rIcQKVDCNV/8WR9mjqy7yjnYxgfido
         7iOlR3Fh0sz1WYV+w4mQPg0eQAY+GmkaFbBNBeZtPf5I7KywhZnGVxztelJqIjwOvv+C
         S0mgJCjC7cZlGH+Xqz59Y7Yadkjzgbz/sGzaVsN+BLbxz5UwJ+vld5h4Ci9wKv+Uobzc
         S+5aJYFUXgKe4cbIw2p72coEV/ttRPk9XDCT7fotEtdVQDc86CVSGS4XZVRukq7XXVeU
         s91QbGufp7jVrVuQJ0v+PT75VBGl0gvRtwMNbAwkLEVqRyq9lqvXi9YlHXPwwzN8KAfx
         Z5nQ==
X-Gm-Message-State: AOAM533UQjdVUah4oZyAM2r6rFcpjSJe/6O6o43+t9ME9XcAebcrEsjM
        mXRBqr0HtQHoqob0uVte0Ng=
X-Google-Smtp-Source: ABdhPJyf9Os0siN9KM+Ok0WMOWWgOmZyg6ozY2B5oD8RGqyoQH0EuRKF4DV4lQx46kTHk7C8MBnVAw==
X-Received: by 2002:a17:902:a50f:b0:143:7dec:567 with SMTP id s15-20020a170902a50f00b001437dec0567mr1492921plq.18.1636570568183;
        Wed, 10 Nov 2021 10:56:08 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:b41d:11d3:d117:fe23])
        by smtp.gmail.com with ESMTPSA id a12sm6130424pjq.16.2021.11.10.10.56.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Nov 2021 10:56:07 -0800 (PST)
Subject: Re: [PATCH 08/11] scsi: ufs: Improve SCSI abort handling further
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Santosh Yaraganavi <santoshsy@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Vishak G <vishak.g@samsung.com>
References: <20211110004440.3389311-1-bvanassche@acm.org>
 <20211110004440.3389311-9-bvanassche@acm.org>
 <509e2b2c-689a-04e3-e773-b8b99d9f6d0e@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <aac7b8c8-7474-4317-c342-1714cc61a331@acm.org>
Date:   Wed, 10 Nov 2021 10:56:06 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <509e2b2c-689a-04e3-e773-b8b99d9f6d0e@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/10/21 12:57 AM, Adrian Hunter wrote:
> On 10/11/2021 02:44, Bart Van Assche wrote:
>> Make sure that aborted commands are completed once by clearing the
>> corresponding tag bit from hba->outstanding_reqs. This patch is a
>> follow-up for commit cd892096c940 ("scsi: ufs: core: Improve SCSI
>> abort handling").
>>
>> Fixes: 7a3e97b0dc4b ("[SCSI] ufshcd: UFS Host controller driver")
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> ---
>>   drivers/scsi/ufs/ufshcd.c | 9 +++++++++
>>   1 file changed, 9 insertions(+)
>>
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index 8f5640647054..1e15ed1f639f 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -7090,6 +7090,15 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>>   		goto release;
>>   	}
>>   
>> +	/*
>> +	 * ufshcd_try_to_abort_task() cleared the 'tag' bit in the doorbell
>> +	 * register. Clear the corresponding bit from outstanding_reqs to
>> +	 * prevent early completion.
>> +	 */
>> +	spin_lock_irqsave(&hba->outstanding_lock, flags);
>> +	__clear_bit(tag, &hba->outstanding_reqs);
>> +	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
> 
> Seems like something ufshcd_clear_cmd() should be doing instead?

Hi Adrian,

I'm concerned that would break ufshcd_eh_device_reset_handler() since 
that reset handler retries SCSI commands by calling 
__ufshcd_transfer_req_compl() after having called ufshcd_clear_cmd().

Thanks,

Bart.
