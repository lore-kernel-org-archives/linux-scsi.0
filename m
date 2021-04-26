Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 314D0C433B4
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 07:03:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05D3661131
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 07:03:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231879AbhDZHE3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Apr 2021 03:04:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:37468 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231616AbhDZHE3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Apr 2021 03:04:29 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 70A33AFF1;
        Mon, 26 Apr 2021 07:03:47 +0000 (UTC)
Subject: Re: [PATCH 12/39] xen-scsifront: compability status handling
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210423113944.42672-1-hare@suse.de>
 <20210423113944.42672-13-hare@suse.de>
 <f6f18bcd-8873-d37e-ce76-161196fff33c@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Message-ID: <9b38aa52-5cff-46e1-f9fc-91dbd67dc0be@suse.de>
Date:   Mon, 26 Apr 2021 09:03:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <f6f18bcd-8873-d37e-ce76-161196fff33c@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/26/21 5:44 AM, Bart Van Assche wrote:
> On 4/23/21 4:39 AM, Hannes Reinecke wrote:
>> The Xen guest might run against arbitrary backends, so the driver
>> might receive a status with driver_byte set. Map these errors
>> to DID_ERROR to be consistent with recent changes.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  drivers/scsi/xen-scsifront.c | 8 +++++++-
>>  1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/xen-scsifront.c b/drivers/scsi/xen-scsifront.c
>> index 259fc248d06c..0d813a2d9ad2 100644
>> --- a/drivers/scsi/xen-scsifront.c
>> +++ b/drivers/scsi/xen-scsifront.c
>> @@ -251,6 +251,7 @@ static void scsifront_cdb_cmd_done(struct vscsifrnt_info *info,
>>  	struct scsi_cmnd *sc;
>>  	uint32_t id;
>>  	uint8_t sense_len;
>> +	int result;
>>  
>>  	id = ring_rsp->rqid;
>>  	shadow = info->shadow[id];
>> @@ -261,7 +262,12 @@ static void scsifront_cdb_cmd_done(struct vscsifrnt_info *info,
>>  	scsifront_gnttab_done(info, shadow);
>>  	scsifront_put_rqid(info, id);
>>  
>> -	sc->result = ring_rsp->rslt;
>> +	result = ring_rsp->rslt;
>> +	if ((result >> 24) & 0xff)
>> +		set_host_byte(sc, DID_ERROR);
>> +	else
>> +		set_host_byte(sc, host_byte(result));
>> +	set_status_byte(sc, result & 0xff);
> 
> The "& 0xff" isn't necessary in "(result >> 24) & 0xff" since 'result'
> is a 32-bit variable.
> 
Will be fixing it up.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)
