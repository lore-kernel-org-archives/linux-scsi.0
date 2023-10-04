Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF223E8FDD1
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Oct 2023 06:50:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241449AbjJDGuN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Oct 2023 02:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241422AbjJDGuL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Oct 2023 02:50:11 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D484B7
        for <linux-scsi@vger.kernel.org>; Tue,  3 Oct 2023 23:50:08 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B3BA72185A;
        Wed,  4 Oct 2023 06:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1696402206; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uV0aDSkduCw0pcqZ7tCVoqpPB94BbesFswpg6rF00Kg=;
        b=0TKOuUPCeU6wcxkkm63c0L89h5GZ/3VCj3i/FT629oLvJrjeIRR5JB7DMofmvJDAY5wwGT
        PpJsozonwxqXjLVOrdsXM2NEQithkbrXx/OTtogI+UfriwsZF2RJ6gLu/YvpxZQju4gMJt
        Wkk4VXdTjHVkKh6rtFVWYh+g/dz1m4k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1696402206;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uV0aDSkduCw0pcqZ7tCVoqpPB94BbesFswpg6rF00Kg=;
        b=ZyDhoEYsimbh5qXOD22ClTwuhYIHuXO+bqkcKlZdrzeLS4HsBOMMFem4TUN/4FL55nL6d7
        6b6jj7c+r/FJujAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8D064139F9;
        Wed,  4 Oct 2023 06:50:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 667rIB4LHWVTbAAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 04 Oct 2023 06:50:06 +0000
Message-ID: <7cdd86eb-c685-4f92-8557-2ec47fcf3f14@suse.de>
Date:   Wed, 4 Oct 2023 08:50:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/7] scsi_error: streamline scsi_eh_bus_device_reset()
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
References: <20231002155915.109359-1-hare@suse.de>
 <20231002155915.109359-8-hare@suse.de>
 <435a39bf-bc7b-4cce-98ea-446cc0549e3b@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <435a39bf-bc7b-4cce-98ea-446cc0549e3b@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/3/23 19:45, Bart Van Assche wrote:
> On 10/2/23 08:59, Hannes Reinecke wrote:
>> Streamline to use a similar code flow as the other reset functions.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>   drivers/scsi/scsi_error.c | 26 +++++++++++---------------
>>   1 file changed, 11 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
>> index 21d84940c9cb..81b38f5da3b6 100644
>> --- a/drivers/scsi/scsi_error.c
>> +++ b/drivers/scsi/scsi_error.c
>> @@ -1581,6 +1581,7 @@ static int scsi_eh_bus_device_reset(struct 
>> Scsi_Host *shost,
>>   {
>>       struct scsi_cmnd *scmd, *bdr_scmd, *next;
>>       struct scsi_device *sdev;
>> +    LIST_HEAD(check_list);
>>       enum scsi_disposition rtn;
>>       shost_for_each_device(sdev, shost) {
>> @@ -1606,27 +1607,22 @@ static int scsi_eh_bus_device_reset(struct 
>> Scsi_Host *shost,
>>               sdev_printk(KERN_INFO, sdev,
>>                        "%s: Sending BDR\n", current->comm));
>>           rtn = scsi_try_bus_device_reset(sdev);
>> -        if (rtn == SUCCESS || rtn == FAST_IO_FAIL) {
>> -            if (!scsi_device_online(sdev) ||
>> -                rtn == FAST_IO_FAIL ||
>> -                !scsi_eh_tur(bdr_scmd)) {
>> -                list_for_each_entry_safe(scmd, next,
>> -                             work_q, eh_entry) {
>> -                    if (scmd->device == sdev &&
>> -                        scsi_eh_action(scmd, rtn) != FAILED)
>> -                        __scsi_eh_finish_cmd(scmd,
>> -                                     done_q,
>> -                                     DID_RESET);
>> -                }
>> -            }
>> -        } else {
>> +        if (rtn != SUCCESS && rtn != FAST_IO_FAIL)
>>               SCSI_LOG_ERROR_RECOVERY(3,
>>                   sdev_printk(KERN_INFO, sdev,
>>                           "%s: BDR failed\n", current->comm));
>> +        list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
>> +            if (scmd->device != sdev)
>> +                continue;
>> +            if (rtn == SUCCESS)
>> +                list_move_tail(&scmd->eh_entry, &check_list);
>> +            else if (rtn == FAST_IO_FAIL)
>> +                __scsi_eh_finish_cmd(scmd, done_q,
>> +                             DID_TRANSPORT_DISRUPTED);
>>           }
>>       }
>> -    return list_empty(work_q);
>> +    return scsi_eh_test_devices(&check_list, work_q, done_q, 0);
>>   }
> 
> I think the description of this patch is too brief. The following 
> information is missing from the patch description:
> - Why the scsi_device_online() and scsi_eh_tur() checks have been left
>    out.
> - Why DID_RESET has been changed into DID_TRANSPORT_DISRUPTED.
> - Why the list_move_tail() call has been introduced.
> - Why the scsi_eh_test_devices() call has been introduced.
>
Okay, will be doing so.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

