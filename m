Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3702DC2BB3F
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Nov 2023 19:13:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232800AbjKOTNi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Nov 2023 14:13:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbjKOTNe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Nov 2023 14:13:34 -0500
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A98212C
        for <linux-scsi@vger.kernel.org>; Wed, 15 Nov 2023 11:13:30 -0800 (PST)
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-6bd32d1a040so7410582b3a.3
        for <linux-scsi@vger.kernel.org>; Wed, 15 Nov 2023 11:13:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700075610; x=1700680410;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pgHp/CcsmdH8Xp6PYtp/IJnMqxK2UUVh/HshZgaLcUw=;
        b=cQisC0TVfyl8bpLCg5o0Y2icSYbLejHljubDfqvuaCYEZAcPxJD8gLN9JdpyuwIAcE
         x66ylx1hm8whmgVZosDopdUzRn8sS45Y38lLU74YbT5Wt8+TqZv2qHr8qUHVdHfSzQCW
         f3Zl2VA42NUB3TI84C0RnEO+XdWiJSTKYVjujsMmNuZfTEMgVivLK3mKHDTaeVqnczKm
         vNVpSM0dQcHkaiqI3VellpOeyW2Th4y26QC6w0waM/T41HYfqPXqnocVv1zclJAjTNUc
         a8+mmYv7AwKEuqy6pkvFkuC9sD1OOvwGRtWjdwEEIlYXFGFFoQtKwHZCnqMaHGkAZUBc
         sHvg==
X-Gm-Message-State: AOJu0YwOEptKYjg+ERyVW4v91uvN7UbffwjKQ+djQyxYtUwYAzQyjhSY
        qkbxQRABdLEB4oznRbBQ9i8=
X-Google-Smtp-Source: AGHT+IH/V+TISNHkbCHBDzlY1b/6QegP8/bR4B6ric69St1RINBgwJe0JaPMOIoD4iMInf8IynaiWw==
X-Received: by 2002:a05:6a00:8c5:b0:68f:bb02:fdf with SMTP id s5-20020a056a0008c500b0068fbb020fdfmr16462711pfu.27.1700075609778;
        Wed, 15 Nov 2023 11:13:29 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:56f1:2160:3a2a:2645? ([2620:0:1000:8411:56f1:2160:3a2a:2645])
        by smtp.gmail.com with ESMTPSA id p5-20020aa78605000000b006b225011ee5sm3148122pfn.6.2023.11.15.11.13.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Nov 2023 11:13:29 -0800 (PST)
Message-ID: <995a0211-ce81-49fb-b86d-28c4f162fcc0@acm.org>
Date:   Wed, 15 Nov 2023 11:13:27 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/12] scsi: ufs: Simplify ufshcd_abort_all()
Content-Language: en-US
To:     =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= 
        <peter.wang@mediatek.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc:     "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "Arthur.Simchaev@wdc.com" <Arthur.Simchaev@wdc.com>,
        "quic_asutoshd@quicinc.com" <quic_asutoshd@quicinc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        =?UTF-8?B?U3RhbmxleSBDaHUgKOacseWOn+mZnik=?= 
        <stanley.chu@mediatek.com>,
        "quic_cang@quicinc.com" <quic_cang@quicinc.com>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>
References: <20230727194457.3152309-1-bvanassche@acm.org>
 <20230727194457.3152309-10-bvanassche@acm.org>
 <13d51fbcb0c7fc91d7e655057133f6c47cfebd34.camel@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <13d51fbcb0c7fc91d7e655057133f6c47cfebd34.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/14/23 22:57, Peter Wang (王信友) wrote:
> On Thu, 2023-07-27 at 12:41 -0700, Bart Van Assche wrote:
>> Unify the MCQ and legacy code paths. This patch reworks code
>> introduced by
>> commit ab248643d3d6 ("scsi: ufs: core: Add error handling for MCQ
>> mode").
>>
>> Cc: Bao D. Nguyen <quic_nguyenb@quicinc.com>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> ---
>>   drivers/ufs/core/ufshcd.c | 46 +++++++++++++++++------------------
>> ----
>>   1 file changed, 20 insertions(+), 26 deletions(-)
>>
>> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
>> index c0031cf8855c..bf76ea59ba6c 100644
>> --- a/drivers/ufs/core/ufshcd.c
>> +++ b/drivers/ufs/core/ufshcd.c
>> @@ -6387,6 +6387,22 @@ static bool
>> ufshcd_is_pwr_mode_restore_needed(struct ufs_hba *hba)
>>   	return false;
>>   }
>>   
>> +static bool ufshcd_abort_one(struct request *rq, void *priv)
>> +{
>> +	int *ret = priv;
>> +	u32 tag = rq->tag;
>> +	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
>> +	struct scsi_device *sdev = cmd->device;
>> +	struct Scsi_Host *shost = sdev->host;
>> +	struct ufs_hba *hba = shost_priv(shost);
>> +
>> +	*ret = ufshcd_try_to_abort_task(hba, tag);
>> +	dev_err(hba->dev, "Aborting tag %d / CDB %#02x %s\n", tag,
>> +		hba->lrb[tag].cmd ? hba->lrb[tag].cmd->cmnd[0] : -1,
>> +		*ret ? "failed" : "succeeded");
>> +	return *ret == 0;
>> +}
>> +
>>   /**
>>    * ufshcd_abort_all - Abort all pending commands.
>>    * @hba: Host bus adapter pointer.
>> @@ -6395,34 +6411,12 @@ static bool
>> ufshcd_is_pwr_mode_restore_needed(struct ufs_hba *hba)
>>    */
>>   static bool ufshcd_abort_all(struct ufs_hba *hba)
>>   {
>> -	int tag, ret;
>> +	int tag, ret = 0;
>>   
>> -	if (is_mcq_enabled(hba)) {
>> -		struct ufshcd_lrb *lrbp;
>> -		int tag;
>> +	blk_mq_tagset_busy_iter(&hba->host->tag_set, ufshcd_abort_one,
>> &ret);
>> +	if (ret)
>> +		goto out;
>>   
>> -		for (tag = 0; tag < hba->nutrs; tag++) {
>> -			lrbp = &hba->lrb[tag];
>> -			if (!ufshcd_cmd_inflight(lrbp->cmd))
>> -				continue;
>> -			ret = ufshcd_try_to_abort_task(hba, tag);
>> -			dev_err(hba->dev, "Aborting tag %d / CDB %#02x
>> %s\n", tag,
>> -				hba->lrb[tag].cmd ? hba->lrb[tag].cmd-
>>> cmnd[0] : -1,
>> -				ret ? "failed" : "succeeded");
>> -			if (ret)
>> -				goto out;
>> -		}
>> -	} else {
>> -		/* Clear pending transfer requests */
>> -		for_each_set_bit(tag, &hba->outstanding_reqs, hba-
>>> nutrs) {
>> -			ret = ufshcd_try_to_abort_task(hba, tag);
>> -			dev_err(hba->dev, "Aborting tag %d / CDB %#02x
>> %s\n", tag,
>> -				hba->lrb[tag].cmd ? hba->lrb[tag].cmd-
>>> cmnd[0] : -1,
>> -				ret ? "failed" : "succeeded");
>> -			if (ret)
>> -				goto out;
>> -		}
>> -	}
>>   	/* Clear pending task management requests */
>>   	for_each_set_bit(tag, &hba->outstanding_tasks, hba->nutmrs) {
>>   		ret = ufshcd_clear_tm_cmd(hba, tag);
> 
> Hi Bart,
> 
> Previous ufshcd_try_to_abort_task retrun fail will break tag iterate
> and return true to tell caller need reset.
> But this patch only return last tag ufshcd_try_to_abort_task return
> value, if some tag abort fail and last tag abort success, will not
> retrun true to tell caller need reset, am I right?

Hi Peter,

blk_mq_tagset_busy_iter() keeps iterating as long as the callback function
that has been passed as the second argument returns true. ufshcd_abort_one()
returns false if ufshcd_try_to_abort_task() fails.

The behavior that a host reset is triggered if ufshcd_try_to_abort_task()
fails has been preserved.

Bart.

