Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 405CCC4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Oct 2022 21:13:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbiJSVNW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Oct 2022 17:13:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbiJSVNV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Oct 2022 17:13:21 -0400
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBBB7183E11
        for <linux-scsi@vger.kernel.org>; Wed, 19 Oct 2022 14:13:20 -0700 (PDT)
Received: by mail-pf1-f169.google.com with SMTP id y191so18432184pfb.2
        for <linux-scsi@vger.kernel.org>; Wed, 19 Oct 2022 14:13:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dFR6Vy/nGvgJ6xHDwjFMEPdoUzj4kWZQoiiEA+iF2rs=;
        b=yrsehQqE53ojFKn5Pw6OfFrEtvmqWENjRZYViMy0pXvuwHJz/IKiPHZXzU3U2A7Qqj
         pcsvQGczulohvRpI92gfKEqkQERX8XewNPd82D1mFOBvc2syjmw9lss45IvtdvVGmlhR
         WWO3vH9oq7J5OsCPlpBofX3jXBwk+8CzPJMI1gM3SSPgRfVgMzZ1PDlN1H7zH8Dg8ZIt
         KvQlzYvz7a2g7jCANNKj5DeAu5WmGEvtMuO9NbrHrijc64oEGklpLzVWU5OpmT/QKS4D
         yQd03Ub17TtTmMVnkPbY6cO+stVyv2NVrtA88ezzy00rz6wfRtC3M2dGyvHjLJ+F8B7M
         g1eg==
X-Gm-Message-State: ACrzQf2oDvw+EH5aSS6LnVUphK4Eh85g+Pzbthf4O8PyOzejh1vAku2d
        8HU+nVHqIZ6R1YvtM3MgqPg=
X-Google-Smtp-Source: AMsMyM7wmM3GNKjocxJPgtL5GxKOU9qORFQF+8tpM5zRPl/ba+RyJYGW8ldfY1cr7mDc1aLsP+7LTg==
X-Received: by 2002:a63:c14:0:b0:456:d887:c83 with SMTP id b20-20020a630c14000000b00456d8870c83mr8997623pgl.53.1666214000158;
        Wed, 19 Oct 2022 14:13:20 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:8280:2606:af57:d34? ([2620:15c:211:201:8280:2606:af57:d34])
        by smtp.gmail.com with ESMTPSA id z18-20020aa79592000000b0053e2b61b714sm11667333pfj.114.2022.10.19.14.13.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Oct 2022 14:13:19 -0700 (PDT)
Message-ID: <c734f63a-9634-89ec-5bde-f0111408f0c5@acm.org>
Date:   Wed, 19 Oct 2022 14:13:16 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v4 09/10] scsi: ufs: Introduce the function
 ufshcd_execute_start_stop()
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
References: <20221018202958.1902564-1-bvanassche@acm.org>
 <20221018202958.1902564-10-bvanassche@acm.org>
 <d3d656e8-f855-9ecf-3d8a-0da0e0f12cd0@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <d3d656e8-f855-9ecf-3d8a-0da0e0f12cd0@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/19/22 12:57, Mike Christie wrote:
> On 10/18/22 3:29 PM, Bart Van Assche wrote:
>> Open-code scsi_execute() because a later patch will modify scmd->flags
>> and because scsi_execute() does not support setting scmd->flags. No
>> functionality is changed.
>>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> ---
>>   drivers/ufs/core/ufshcd.c | 39 ++++++++++++++++++++++++++++++++++-----
>>   1 file changed, 34 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
>> index 2a32bcc93d2e..c5ccc7ba583b 100644
>> --- a/drivers/ufs/core/ufshcd.c
>> +++ b/drivers/ufs/core/ufshcd.c
>> @@ -8729,6 +8729,39 @@ static void ufshcd_hba_exit(struct ufs_hba *hba)
>>   	}
>>   }
>>   
>> +static int ufshcd_execute_start_stop(struct scsi_device *sdev,
>> +				     enum ufs_dev_pwr_mode pwr_mode,
>> +				     struct scsi_sense_hdr *sshdr)
>> +{
>> +	unsigned char cdb[6] = { START_STOP, 0, 0, 0, pwr_mode << 4, 0 };
>> +	struct request *req;
>> +	struct scsi_cmnd *scmd;
>> +	int ret;
>> +
>> +	req = scsi_alloc_request(sdev->request_queue, REQ_OP_DRV_IN,
>> +				 BLK_MQ_REQ_PM);
>>
> 
> Can you hit a case where we have run out of tags (__blk_mq_alloc_requests
> is hitting the blk_mq_get_tag == BLK_MQ_NO_TAG check), the host has gone
> into recovery and so commands are completing to add a tag back and then we
> try to call this and get stuck waiting on a tag? Or for passthrough do we
> have some special reserve?
> 
> If so do you need to use BLK_MQ_REQ_NOWAIT here? Maybe do the retry loop
> yourself like:
> 
> retry:
> 	if host is in recovery
> 		return failure
> 
> 	req = scsi_alloc_request(.... BLK_MQ_REQ_NOWAIT)
> 	if (!req and we have not hit some retry limit)
> 		goto retry
> 
> 
> or have some special reserve command/tag.

Hi Mike,

No other SCSI commands should be in progress when 
ufshcd_execute_start_stop() is called because that function is only 
called during system suspend and resume and no other I/O should be in 
progress at that time. Additionally, there is a mutual exclusion 
mechanism in the UFS driver to serialize system suspend/resume activity 
and error handling.

Thanks,

Bart.
