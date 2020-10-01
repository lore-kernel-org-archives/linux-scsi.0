Return-Path: <SRS0=33X3=DI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92BE0C4727C
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 09:58:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 642BC206D9
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 09:58:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731670AbgJAJ6t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Oct 2020 05:58:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:57592 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726992AbgJAJ6t (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 1 Oct 2020 05:58:49 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 15A32ACAC;
        Thu,  1 Oct 2020 09:58:48 +0000 (UTC)
Subject: Re: [PATCH 2/4] scsi_dh_alua: return BLK_STS_AGAIN for ALUA
 transitioning state
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20200930080256.90964-1-hare@suse.de>
 <20200930080256.90964-3-hare@suse.de>
 <10c29e0a-688c-9cc0-3329-8f97300b8827@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <c51ffe04-0c4a-b968-109a-b1cddb308d8e@suse.de>
Date:   Thu, 1 Oct 2020 11:58:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <10c29e0a-688c-9cc0-3329-8f97300b8827@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/1/20 4:44 AM, Bart Van Assche wrote:
> On 2020-09-30 01:02, Hannes Reinecke wrote:
>> When the ALUA state indicates transitioning we should not retry
>> the command immediately, but rather complete the command with
>> BLK_STS_AGAIN to signal the completion handler that it might
>> be retried.
>> This allows multipathing to redirect the command to another path
>> if possible, and avoid stalls during lengthy transitioning times.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>   drivers/scsi/device_handler/scsi_dh_alua.c | 2 +-
>>   drivers/scsi/scsi_lib.c                    | 5 +++++
>>   2 files changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
>> index 308bda2e9c00..a68222e324e9 100644
>> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
>> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
>> @@ -1092,7 +1092,7 @@ static blk_status_t alua_prep_fn(struct scsi_device *sdev, struct request *req)
>>   	case SCSI_ACCESS_STATE_LBA:
>>   		return BLK_STS_OK;
>>   	case SCSI_ACCESS_STATE_TRANSITIONING:
>> -		return BLK_STS_RESOURCE;
>> +		return BLK_STS_AGAIN;
>>   	default:
>>   		req->rq_flags |= RQF_QUIET;
>>   		return BLK_STS_IOERR;
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index f0ee11dc07e4..b628aa0d824c 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -1726,6 +1726,11 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
>>   		    scsi_device_blocked(sdev))
>>   			ret = BLK_STS_DEV_RESOURCE;
>>   		break;
>> +	case BLK_STS_AGAIN:
>> +		scsi_req(req)->result = DID_BUS_BUSY << 16;
>> +		if (req->rq_flags & RQF_DONTPREP)
>> +			scsi_mq_uninit_cmd(cmd);
>> +		break;
>>   	default:
>>   		if (unlikely(!scsi_device_online(sdev)))
>>   			scsi_req(req)->result = DID_NO_CONNECT << 16;
> 
> Hi Hannes,
> 
> What will happen if all remote ports have the state "transitioning"?
> Does the above code resubmit a request immediately in that case? Can
> this cause spinning with 100% CPU usage if the ALUA device handler
> notices the transitioning state before multipathd does?
> 
Curiously this patch only improves the current situation :-)
With the current behaviour we will return 
BLK_STS_DEV_RESOURCE/BLK_STS_RESOURCE, causing an _immediate_ retry on 
the same queue.
This patch will cause the I/O to be _completed_, to be requeued via the 
end_request() path.
So yes, we will requeue (that's kinda the point of 'transitioning' ...), 
but with a lower frequency as originally. _And_ with a chance of 
multipath intercepting the I/O, which didn't happen previously.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
