Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A93F1C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 18:09:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F1B560FE6
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 18:09:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232870AbhHQSKN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 14:10:13 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:49970 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232880AbhHQSKM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2021 14:10:12 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 6ACC221FAA;
        Tue, 17 Aug 2021 18:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629223776; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yf13cKoZwtr0fEGQ9si3b5x2310rWTYLji8+U4E5n2I=;
        b=A+bi7Xl8QLa0mTtSmqmc+iVRcqvc0lpLVWfgKU6hayjN4plMUXRJpZPdMskf4gs5kIY3U+
        K/foqHEprLYyfbRw0sN4QxcXRmSd+YOvs/vIzYEpk+K7TN8u4twBsnVDf9wNYSJVzJo810
        UC/1Otd8f2bJ/VfBa7ydMrH2Begna7o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629223776;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yf13cKoZwtr0fEGQ9si3b5x2310rWTYLji8+U4E5n2I=;
        b=XMBFu5Zms7LiVigGDU4ll72eIjheAKSTA3W9NkP3XhvOXclzjJcleWRIyj2wDNBBzGb/7z
        sUC1q/a67/nQMcAA==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 2CA94136BF;
        Tue, 17 Aug 2021 18:09:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id rcgBCWD7G2E0fQAAGKfGzw
        (envelope-from <hare@suse.de>); Tue, 17 Aug 2021 18:09:36 +0000
Subject: Re: [PATCH 49/51] scsi: Move eh_device_reset_handler() to use
 scsi_device as argument
To:     Steffen Maier <maier@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
References: <20210817091456.73342-1-hare@suse.de>
 <20210817091456.73342-50-hare@suse.de>
 <0a09a529-7e28-1b56-3ca3-7b172956f3a5@linux.ibm.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <fc1a49dd-28e8-54a0-b94a-67857296b60c@suse.de>
Date:   Tue, 17 Aug 2021 20:09:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <0a09a529-7e28-1b56-3ca3-7b172956f3a5@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/17/21 6:13 PM, Steffen Maier wrote:
> On 8/17/21 11:14 AM, Hannes Reinecke wrote:
>> When resetting a device we shouldn't depend on an existing SCSI
>> command, as this might be completed at any time.
>> Rather we should use 'struct scsi_device' as argument for
>> eh_device_reset_handler().
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.com>
> 
> Acked-by: Steffen Maier <maier@linux.ibm.com> # for zfcp
> 
> However, independent review comments for common code below...
> 
>> ---
>>   Documentation/scsi/scsi_eh.rst                |  2 +-
>>   Documentation/scsi/scsi_mid_low_api.rst       |  4 +--
> 
>>   drivers/s390/scsi/zfcp_scsi.c                 |  4 +--
> 
>>   drivers/scsi/scsi_error.c                     | 35 +++++++++++++------
> 
>>   include/scsi/scsi_host.h                      |  2 +-
>>   62 files changed, 314 insertions(+), 329 deletions(-)
>>
>> diff --git a/Documentation/scsi/scsi_eh.rst 
>> b/Documentation/scsi/scsi_eh.rst
>> index e09c81a54702..23f0d09668d9 100644
>> --- a/Documentation/scsi/scsi_eh.rst
>> +++ b/Documentation/scsi/scsi_eh.rst
>> @@ -214,7 +214,7 @@ considered to fail always.
>>   ::
>>
>>       int (* eh_abort_handler)(struct scsi_cmnd *);
>> -    int (* eh_device_reset_handler)(struct scsi_cmnd *);
>> +    int (* eh_device_reset_handler)(struct scsi_device *);
>>       int (* eh_target_reset_handler)(struct scsi_target *);
>>       int (* eh_bus_reset_handler)(struct Scsi_Host *, int);
>>       int (* eh_host_reset_handler)(struct Scsi_Host *);
>> diff --git a/Documentation/scsi/scsi_mid_low_api.rst 
>> b/Documentation/scsi/scsi_mid_low_api.rst
>> index 0afc1b4f89af..4650c0c6a22a 100644
>> --- a/Documentation/scsi/scsi_mid_low_api.rst
>> +++ b/Documentation/scsi/scsi_mid_low_api.rst
>> @@ -778,7 +778,7 @@ Details::
>>
>>       /**
>>       *      eh_device_reset_handler - issue SCSI device reset
>> -    *      @scp: identifies SCSI device to be reset
>> +    *      @sdev: identifies SCSI device to be reset
>>       *
>>       *      Returns SUCCESS if command aborted else FAILED
>>       *
>> @@ -791,7 +791,7 @@ Details::
>>       *
>>       *      Optionally defined in: LLD
>>       **/
>> -    int eh_device_reset_handler(struct scsi_cmnd * scp)
>> +    int eh_device_reset_handler(struct scsi_device * sdev)
>>
>>
>>       /**
> 
> 
>> diff --git a/drivers/s390/scsi/zfcp_scsi.c 
>> b/drivers/s390/scsi/zfcp_scsi.c
>> index 6492c3b1b12f..4fa626763bb6 100644
>> --- a/drivers/s390/scsi/zfcp_scsi.c
>> +++ b/drivers/s390/scsi/zfcp_scsi.c
>> @@ -333,10 +333,8 @@ static int zfcp_scsi_task_mgmt_function(struct 
>> scsi_device *sdev, u8 tm_flags)
>>       return retval;
>>   }
>>
>> -static int zfcp_scsi_eh_device_reset_handler(struct scsi_cmnd *scpnt)
>> +static int zfcp_scsi_eh_device_reset_handler(struct scsi_device *sdev)
>>   {
>> -    struct scsi_device *sdev = scpnt->device;
>> -
>>       return zfcp_scsi_task_mgmt_function(sdev, FCP_TMF_LUN_RESET);
>>   }
>>
> 
> 
>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
>> index 1d8e2f655833..44e29558b068 100644
>> --- a/drivers/scsi/scsi_error.c
>> +++ b/drivers/scsi/scsi_error.c
>> @@ -910,7 +910,7 @@ static enum scsi_disposition 
>> scsi_try_bus_device_reset(struct scsi_cmnd *scmd)
> 
>>     struct scsi_host_template *hostt = scmd->device->host->hostt;
> 
>>       if (!hostt->eh_device_reset_handler)
>>           return FAILED;
>>
>> -    rtn = hostt->eh_device_reset_handler(scmd);
>> +    rtn = hostt->eh_device_reset_handler(scmd->device);
>>       if (rtn == SUCCESS)
>>           __scsi_report_device_reset(scmd->device, NULL);
>>       return rtn;
> 
> ok
> (now that we use scmd->device 3 times in this function we could 
> introduce a local variable sdev, similarly as starget in patch 36; but 
> that would be more changed lines)
> 
> 
>> @@ -1195,6 +1195,7 @@ scsi_eh_action(struct scsi_cmnd *scmd, enum 
>> scsi_disposition rtn)
>>    * scsi_eh_finish_cmd - Handle a cmd that eh is finished with.
> 
> That old comment seems now in front of the new internal 
> __scsi_eh_finish_cmd rathern than scsi_eh_finish_cmd ?
> 
>>    * @scmd:    Original SCSI cmd that eh has finished.
>>    * @done_q:    Queue for processed commands.
>> + * @result:    Final command status to be set
> 
> You introduce a 3rd argument named "host_byte" (not "result") below?
> 
>>    *
>>    * Notes:
>>    *    We don't want to use the normal command completion while we 
>> are are
> 
>>  *    still handling errors - it may cause other commands to be queued,
>>  *    and that would disturb what we are doing.  Thus we really want to
> 
>> @@ -1203,10 +1204,18 @@ scsi_eh_action(struct scsi_cmnd *scmd, enum 
>> scsi_disposition rtn)
>>    *    keep a list of pending commands for final completion, and once we
>>    *    are ready to leave error handling we handle completion for real.
>>    */
>> -void scsi_eh_finish_cmd(struct scsi_cmnd *scmd, struct list_head 
>> *done_q)
>> +void __scsi_eh_finish_cmd(struct scsi_cmnd *scmd, struct list_head 
>> *done_q,
> 
> Should that new internal helper be static?
> 
>> +            int host_byte)
>>   {
>> +    if (host_byte)
>> +        set_host_byte(scmd, host_byte);
>>       list_move_tail(&scmd->eh_entry, done_q);
>>   }
>> +
> 
> I whish we still had a kdoc for the actual API function 
> scsi_eh_finish_cmd().
> 
>> +void scsi_eh_finish_cmd(struct scsi_cmnd *scmd, struct list_head 
>> *done_q)
>> +{
>> +    __scsi_eh_finish_cmd(scmd, done_q, 0);
>> +}
>>   EXPORT_SYMBOL(scsi_eh_finish_cmd);
>>
>>   /**
>> @@ -1381,7 +1390,8 @@ static int scsi_eh_test_devices(struct list_head 
>> *cmd_list,
>>                   if (finish_cmds &&
>>                       (try_stu ||
>>                        scsi_eh_action(scmd, SUCCESS) == SUCCESS))
>> -                    scsi_eh_finish_cmd(scmd, done_q);
>> +                    __scsi_eh_finish_cmd(scmd, done_q,
>> +                                 DID_RESET);
>>                   else
>>                       list_move_tail(&scmd->eh_entry, work_q);
>>               }
>> @@ -1529,8 +1539,9 @@ static int scsi_eh_bus_device_reset(struct 
>> Scsi_Host *shost,
>>                                work_q, eh_entry) {
>>                       if (scmd->device == sdev &&
>>                           scsi_eh_action(scmd, rtn) != FAILED)
>> -                        scsi_eh_finish_cmd(scmd,
>> -                                   done_q);
>> +                        __scsi_eh_finish_cmd(scmd,
>> +                                     done_q,
>> +                                     DID_RESET);
>>                   }
>>               }
>>           } else {
>> @@ -1598,7 +1609,8 @@ static int scsi_eh_target_reset(struct Scsi_Host 
>> *shost,
>>               if (rtn == SUCCESS)
>>                   list_move_tail(&scmd->eh_entry, &check_list);
>>               else if (rtn == FAST_IO_FAIL)
>> -                scsi_eh_finish_cmd(scmd, done_q);
>> +                __scsi_eh_finish_cmd(scmd, done_q,
>> +                             DID_TRANSPORT_DISRUPTED);
>>               else
>>                   /* push back on work queue for further processing */
>>                   list_move(&scmd->eh_entry, work_q);
>> @@ -1663,8 +1675,9 @@ static int scsi_eh_bus_reset(struct Scsi_Host 
>> *shost,
>>               list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
>>                   if (channel == scmd_channel(scmd)) {
>>                       if (rtn == FAST_IO_FAIL)
>> -                        scsi_eh_finish_cmd(scmd,
>> -                                   done_q);
>> +                        __scsi_eh_finish_cmd(scmd,
>> +                                     done_q,
>> +                                     DID_TRANSPORT_DISRUPTED);
>>                       else
>>                           list_move_tail(&scmd->eh_entry,
>>                                      &check_list);
>> @@ -1707,9 +1720,9 @@ static int scsi_eh_host_reset(struct Scsi_Host 
>> *shost,
>>           if (rtn == SUCCESS) {
>>               list_splice_init(work_q, &check_list);
>>           } else if (rtn == FAST_IO_FAIL) {
>> -            list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
>> -                    scsi_eh_finish_cmd(scmd, done_q);
>> -            }
>> +            list_for_each_entry_safe(scmd, next, work_q, eh_entry)
>> +                __scsi_eh_finish_cmd(scmd, done_q,
>> +                             DID_TRANSPORT_DISRUPTED);
>>           } else {
>>               SCSI_LOG_ERROR_RECOVERY(3,
>>                   shost_printk(KERN_INFO, shost,
> 
> I don't understand the RESET vs. DISRUPTED depending on escalation level.
> Care to explain in the patch description (or even code comment)?
> Is there any functional change compared to today and if so which?
> 
> 
Well.
That's arguably slightly odd, but anyway:
_in principle_ an EH handler might return FAST_IO_FAIL, which would 
indicate that the EH function could not complete due the transport being 
busy (eg RSCN processing taking longer than expected). In that case it's 
expected to be a transient condition, which might/should be resolved 
with a simple retry.
Hence we should indicate that by completing commands with 
DID_TRANSPORT_DISRUPTED, to allow upper layers to retry.

Having said that it's slightly odd to have FAST_IO_FAIL being returned 
from a host reset, as really the intention is that the driver will be in 
a stable state after reset.
But this doesn't seem to be true for zfcp, as we're calling 
fc_block_rport() after the reset itself, which means that there's a 
chance we'll be running into this situation.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
