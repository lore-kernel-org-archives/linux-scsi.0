Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6118C433FE
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Oct 2022 19:20:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbiJCTUW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Oct 2022 15:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiJCTUR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2022 15:20:17 -0400
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C50EA20347
        for <linux-scsi@vger.kernel.org>; Mon,  3 Oct 2022 12:20:14 -0700 (PDT)
Received: by mail-pg1-f180.google.com with SMTP id f193so10507920pgc.0
        for <linux-scsi@vger.kernel.org>; Mon, 03 Oct 2022 12:20:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=n7Xf9CVVuyVoTVrSSvXgfDXDtlN5jbiDM0Y6q9FPcW4=;
        b=tk5yPXCR6K6u7slDlUJDlWOixy4jQwhbLa2IvX4heSPaJtzDeskFK7UEWiDt3nRdui
         GlVcsD352wUCfcDKt7f6D0AD884Zh/QLbk66oCebyiDaYknNbgL9V8U4mXbKMSXkf3dz
         dkDVbA5+pAH8AKgTSAFTwXTVqLUYb85PksFXN19ztmtneEwdTY0fsTQowZPC76m720lg
         /HjFedhxnTK05kQGBs0KY3CGpOKsM8X3xGBOqDgljG/98O6ji6hTH1Kx1Gcwn2yyHxvU
         AeFxEbR44ue0K+wBodGTT3UDTqaeOcS8lwg6zxhLF2qutb/abTBljxIj6v+GQ224bUmC
         j+aA==
X-Gm-Message-State: ACrzQf1DzpSigNlAcunOxAJKG5BOcIBf88KoAEebPIe3Lvd8zRVqEhbh
        P92BC6RmD3CfElZbX+mv2w8=
X-Google-Smtp-Source: AMsMyM45tru4n2TIGqc3f6RoeIzhPuxJ+0v1i6tyFLafrlFzh5sf4UjtNznp8OTwMSCPVTQ30fhc0w==
X-Received: by 2002:a63:8a41:0:b0:44a:648d:dd5e with SMTP id y62-20020a638a41000000b0044a648ddd5emr9256971pgd.548.1664824813881;
        Mon, 03 Oct 2022 12:20:13 -0700 (PDT)
Received: from [192.168.3.219] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id o1-20020a17090ab88100b00203059fc75bsm6682593pjr.5.2022.10.03.12.20.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Oct 2022 12:20:13 -0700 (PDT)
Message-ID: <d734148d-ca9f-70e7-e180-77097c2fc0b2@acm.org>
Date:   Mon, 3 Oct 2022 12:20:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v3 3/8] scsi: core: Support failing requests while
 recovering
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220929220021.247097-1-bvanassche@acm.org>
 <20220929220021.247097-4-bvanassche@acm.org>
 <9160ed4f-95a8-42ff-366e-f52d7816d8c3@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <9160ed4f-95a8-42ff-366e-f52d7816d8c3@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/3/22 10:27, Mike Christie wrote:
> On 9/29/22 5:00 PM, Bart Van Assche wrote:
>> The current behavior for SCSI commands submitted while error recovery
>> is ongoing is to retry command submission after error recovery has
>> finished. See also the scsi_host_in_recovery() check in
>> scsi_host_queue_ready(). Add support for failing SCSI commands while
>> host recovery is in progress. This functionality will be used to fix a
>> deadlock in the UFS driver.
>>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: Ming Lei <ming.lei@redhat.com>
>> Cc: John Garry <john.garry@huawei.com>
>> Cc: Mike Christie <michael.christie@oracle.com>
>> Cc: Hannes Reinecke <hare@suse.de>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> ---
>>   drivers/scsi/scsi_lib.c | 8 +++++---
>>   1 file changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index 473d9403f0c1..ecd2ce3815df 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -1337,9 +1337,6 @@ static inline int scsi_host_queue_ready(struct request_queue *q,
>>   				   struct scsi_device *sdev,
>>   				   struct scsi_cmnd *cmd)
>>   {
>> -	if (scsi_host_in_recovery(shost))
>> -		return 0;
>> -
>>   	if (atomic_read(&shost->host_blocked) > 0) {
>>   		if (scsi_host_busy(shost) > 0)
>>   			goto starved;
>> @@ -1727,6 +1724,11 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
>>   	ret = BLK_STS_RESOURCE;
>>   	if (!scsi_target_queue_ready(shost, sdev))
>>   		goto out_put_budget;
>> +	if (unlikely(scsi_host_in_recovery(shost))) {
>> +		if (req->cmd_flags & REQ_FAILFAST_MASK)
>> +			ret = BLK_STS_OFFLINE;
>> +		goto out_dec_target_busy;
>> +	}
>>   	if (!scsi_host_queue_ready(q, shost, sdev, cmd))
>>   		goto out_dec_target_busy;
>>   
> 
> This might add a regression to dm-multipath or it at least makes
> the behavior difficult to understand for users and support people.
> 
> If there is a transport issue and the cmd times out and the abort
> does as well or fails, then we would start the scsi eh recovery. When the
> driver/transport class figures out it's a transport issue we will block
> the scsi_device. So before this patch we would requeue the cmd then we
> would wait until the fast_io_fail (FC) or replacement_timer (iscsi) to
> fire before failing commands upwards and failing paths.
> 
> With this patch we can end up doing 2 or 3 things depending on timing:
> 1. If the cmd hits the code above we will fail the command and cause a
> path failure.
> 
> 2. If driver/transport blocks the scsi_device first then we would hit the
> scsi_device state check in scsi_queue_rq and not fail the path like before.
> 
> 3. With or without your patch, if dm_mq_queue_rq calls the busy callback
> first (this does blk_lld_busy -> scsi_mq_lld_busy -> scsi_host_in_recovery)
> then it might see all the paths in recovery. It considers this a temp condition
> and will requeue cmds. So in this case we will not fail the path.
> 
> I'm not sure what the correct fix is. Maybe not fast fail REQ_FAILFAST_TRANSPORT
> above, or maybe add a new FAILFAST type that you could use?

Hi Mike,

I will look into introducing a new request flag for this purpose.

Thanks,

Bart.
