Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A327EC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Nov 2021 19:35:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233335AbhK2TiR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Nov 2021 14:38:17 -0500
Received: from mail-pl1-f170.google.com ([209.85.214.170]:43796 "EHLO
        mail-pl1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349986AbhK2TgN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Nov 2021 14:36:13 -0500
Received: by mail-pl1-f170.google.com with SMTP id m24so13001066pls.10
        for <linux-scsi@vger.kernel.org>; Mon, 29 Nov 2021 11:32:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tEaSCPISNJhJiU0Y5Rp1j0GcoL1HoGplL1acQNXZ/w8=;
        b=LUEAyFeMBfyMOzOMeLYnnFa7YFJl5egagxl7shP2ZMzFmfq9xdQSTMEmBgREX8g3/w
         e8tr/WElAYn3O9o2C02Qfr4sJ6eX/IOhLlpSNuNVqfa3WIa6aNPeGeUcOLqKU/bOeSAE
         LARHKGAqHpnzbUyRu5oxoHV5tQjvJ8hHIVSuEG8xTJMMynyugbMOkebhxx9/xZnsuFiA
         9rHqZ35wLaMDKBAGWTU2/RlVMg3bQb3MfEikBK3Vp2OzhM3xpp3d6LwnOiAqUIumz8lo
         m//piNdpgn4gP5wF7A2MKrPvkktABh/PiSpy7OoadnrWCeqT4kyaETdAk3+jHBAQ/Qfe
         V0jw==
X-Gm-Message-State: AOAM530WGreaxnJ516ozRSWZXeSyHxgHX4iJahOXv2wxVuT/sEu9+fkr
        0JEUyemAwXMNIclRW+16fJU=
X-Google-Smtp-Source: ABdhPJzxEE5u6L2coflzzTvhLBrmqSX702QGworpjJY7YLAidtZ2MvAPoL/PLlF3XggsjhEP54uYsw==
X-Received: by 2002:a17:90a:3d42:: with SMTP id o2mr122301pjf.150.1638214375428;
        Mon, 29 Nov 2021 11:32:55 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a4a0:8cb5:fff:67db])
        by smtp.gmail.com with ESMTPSA id w17sm18242392pfu.58.2021.11.29.11.32.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Nov 2021 11:32:54 -0800 (PST)
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
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <bc19f55f-a3e9-a3fe-437d-57b9e077f532@acm.org>
Date:   Mon, 29 Nov 2021 11:32:53 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <6bfb59ef-4f00-3918-59e6-3c9569f6adc6@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/24/21 3:02 AM, Adrian Hunter wrote:
> On 19/11/2021 21:57, Bart Van Assche wrote:
>> The only functional change in this patch is the addition of a
>> blk_mq_start_request() call in ufshcd_issue_devman_upiu_cmd().
>>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> ---
>>   drivers/scsi/ufs/ufshcd.c | 46 +++++++++++++++++++++++++--------------
>>   1 file changed, 30 insertions(+), 16 deletions(-)
>>
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index fced4528ee90..dfa5f127342b 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -2933,6 +2933,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
>>   {
>>   	struct request_queue *q = hba->cmd_queue;
>>   	DECLARE_COMPLETION_ONSTACK(wait);
>> +	struct scsi_cmnd *scmd;
>>   	struct request *req;
>>   	struct ufshcd_lrb *lrbp;
>>   	int err;
>> @@ -2945,15 +2946,18 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
>>   	 * Even though we use wait_event() which sleeps indefinitely,
>>   	 * the maximum wait time is bounded by SCSI request timeout.
>>   	 */
>> -	req = blk_mq_alloc_request(q, REQ_OP_DRV_OUT, 0);
>> -	if (IS_ERR(req)) {
>> -		err = PTR_ERR(req);
>> +	scmd = scsi_get_internal_cmd(q, DMA_TO_DEVICE, 0);
> 
> We do not need the block layer, nor SCSI commands which begs the question,
> why involve them at all?
> 
> For example, the following is much simpler and seems to work:
> [ ... ]

That patch bypasses the block layer for device management commands. So that
patch breaks a very basic assumption on which the block layer has been built,
namely that the block layer core knows whether or not any requests are ongoing.
That patch breaks at least the following functionality:
* Run-time power management. blk_pre_runtime_suspend() checks whether
   q_usage_counter is zero before initiating runtime power management.
   q_usage_counter is increased by blk_mq_alloc_request() and decreased by
   blk_mq_free_request(). I don't think it is safe to change the power state
   while a device management request is in progress.
* The code in blk_cleanup_queue() that waits for pending requests to finish
   before resources associated with the request queue are freed.
   ufshcd_remove() calls blk_cleanup_queue(hba->cmd_queue) and hence waits until
   pending device management commands have finished. That would no longer be the
   case if the block layer is bypassed to submit device management commands.

Bart.
