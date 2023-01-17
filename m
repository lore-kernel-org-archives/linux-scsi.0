Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 714BDC3DA78
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Jan 2023 11:44:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236715AbjAQLog (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Jan 2023 06:44:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236580AbjAQLof (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jan 2023 06:44:35 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FBD29012;
        Tue, 17 Jan 2023 03:44:34 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id BD4E23453B;
        Tue, 17 Jan 2023 11:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1673955872; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5ole6isE4RExd/uxxeZuPvFlLXIRWIIDWEltEeqOodo=;
        b=oXCvkkZH8Qh6p/q9dIUf+LvjViezQNXRxe3SQ97YDxKHQJXYUL74TYrqbGkKfZNFm21ihH
        FQa18NyRudcGHd4tvB7LS+GaSFPfUUwESBQGY0ExF5eRxy3B8T9fkdDz6rbtNthV1We++Z
        R3btKdeyFOnTkK23A6JdjintVSJpNPw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1673955872;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5ole6isE4RExd/uxxeZuPvFlLXIRWIIDWEltEeqOodo=;
        b=Flz8OS1zLtVdgcyg24JF30m5Ftf75Ep+rCQyrEdIFB8hMYvjwzN8bKPswfntZ1/Sz+mcbk
        rAIoXimX7GBnlcCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id AC04A13357;
        Tue, 17 Jan 2023 11:44:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ksW2KSCKxmMnSAAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 17 Jan 2023 11:44:32 +0000
Message-ID: <c48cb125-dcde-d1a1-3b99-f85b3348b4bc@suse.de>
Date:   Tue, 17 Jan 2023 12:44:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 03/18] scsi: core: allow libata to complete successful
 commands via EH
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
References: <20230112140412.667308-1-niklas.cassel@wdc.com>
 <20230112140412.667308-4-niklas.cassel@wdc.com>
 <ab23c5dd-3a61-452c-52c9-43b6b18f2c8e@suse.de> <Y8VGeFSKuIr0nwC3@x1-carbon>
Content-Language: en-US
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <Y8VGeFSKuIr0nwC3@x1-carbon>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/16/23 13:43, Niklas Cassel wrote:
> On Fri, Jan 13, 2023 at 08:57:37AM +0100, Hannes Reinecke wrote:
>> On 1/12/23 15:03, Niklas Cassel wrote:
>>> In SCSI, we get the sense data as part of the completion, for ATA
>>> however, we need to fetch the sense data as an extra step. For an
>>> aborted ATA command the sense data is fetched via libata's
>>> ->eh_strategy_handler().
>>>
>>> For Command Duration Limits policy 0xD:
>>> The device shall complete the command without error with the additional
>>> sense code set to DATA CURRENTLY UNAVAILABLE.
>>>
>>> In order to handle this policy in libata, we intend to send a successful
>>> command via SCSI EH, and let libata's ->eh_strategy_handler() fetch the
>>> sense data for the good command. This is similar to how we handle an
>>> aborted ATA command, just that we need to read the Successful NCQ
>>> Commands log instead of the NCQ Command Error log.
>>>
>>> When we get a SATA completion with successful commands, ATA_SENSE will
>>> be set, indicating that some commands in the completion have sense data.
>>>
>>> The sense_valid bitmask in the Sense Data for Successful NCQ Commands
>>> log will inform exactly which commands that had sense data, which might
>>> be a subset of all the commands that was completed in the same
>>> completion. (Yet all will have ATA_SENSE set, since the status is per
>>> completion.)
>>>
>>> The successful commands that have e.g. a "DATA CURRENTLY UNAVAILABLE"
>>> sense data will have a SCSI ML byte set, so scsi_eh_flush_done_q() will
>>> not set the scmd->result to DID_TIME_OUT for these commands. However,
>>> the successful commands that did not have sense data, must not get their
>>> result marked as DID_TIME_OUT by SCSI EH.
>>>
>>> Add a new flag SCMD_EH_SUCCESS_CMD, which tells SCSI EH to not mark a
>>> command as DID_TIME_OUT, even if it has scmd->result == SAM_STAT_GOOD.
>>>
>>> This will be used by libata in a follow-up patch.
>>>
>>> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
>>> ---
>>>    drivers/scsi/scsi_error.c | 3 ++-
>>>    include/scsi/scsi_cmnd.h  | 5 +++++
>>>    2 files changed, 7 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
>>> index 2aa2c2aee6e7..51aa5c1e31b5 100644
>>> --- a/drivers/scsi/scsi_error.c
>>> +++ b/drivers/scsi/scsi_error.c
>>> @@ -2165,7 +2165,8 @@ void scsi_eh_flush_done_q(struct list_head *done_q)
>>>    			 * scsi_eh_get_sense), scmd->result is already
>>>    			 * set, do not set DID_TIME_OUT.
>>>    			 */
>>> -			if (!scmd->result)
>>> +			if (!scmd->result &&
>>> +			    !(scmd->flags & SCMD_EH_SUCCESS_CMD))
>>>    				scmd->result |= (DID_TIME_OUT << 16);
>>>    			SCSI_LOG_ERROR_RECOVERY(3,
>>>    				scmd_printk(KERN_INFO, scmd,
>> Wouldn't it be better to use '!scmd->result && !scsi_sense_valid(scmd)'
>> instead of a new flag?
>> After all, if we have a valid sense code we _have_ been able to communicate
>> with the device. And as we did so it's questionable whether it should count
>> as a command time out ...
> 
> Hello Hannes,
> 
> Thanks a lot for helping out reviewing this series!
> 
> Unfortunately, your suggestion won't work.
> 
> 
> Let me explain:
> 
> When you get a FIS, the ACT register will have a bit set for each
> command that finished, however, all the commands will share a single
> STATUS value (since there is just a shared STATUS field in the FIS).
> 
> So let's say that tags 0-3 got finished (i.e. bits 0-3 are set in the
> ACT field) and the STATUS field has the "Sense Data Available" bit set.
> 
> This just tells us that at least one of tags 0-3 has sense data.
> 
> 
> In order to know which of these tags that actually has sense data,
> we need to read the "Sense Data for Successful NCQ Commands log",
> which contains a sense_valid bitmask (which contains one bit for
> each of the 32 tags).
> 
> So reading the "Sense Data for Successful NCQ Commands log" might
> tell us that just tag 0-1 have sense data.
> 
> So, libata calls ata_qc_schedule_eh() on tags 0-3, wait until SCSI calls
> libata .eh_strategy_handler(). libata .eh_strategy_handler() will read the
> "Sense Data for Successful NCQ Commands log", which will see that there is
> sense data for tags 0-1, and will add sense data for those commands, and
> call scsi_check_sense() for tags 0-1.
> 
> ata_eh_finish() will finally be called, to determine what to do with the
> commands that belonged to EH.
> 
> The code looks like this:
> if (qc->flags & ATA_QCFLAG_SENSE_VALID ||
>      qc->flags & ATA_QCFLAG_EH_SUCCESS_CMD) {
> 	ata_eh_qc_complete(qc);
> }
> 
> So it will call complete for all 4 tags, regardless is they had sense data
> or not.
> 
> 
> scsi_eh_flush_done_q() will soon be called, and since ata_eh_qc_complete()
> sets scmd->retries == scmd->allowed, none of the four commands will be retired.
> 
> if (!scmd->result &&
>      !(scmd->flags & SCMD_EH_SUCCESS_CMD))
> 	scmd->result |= (DID_TIME_OUT << 16);
> 
> The 2 commands with sense data will not get DID_TIMEOUT,
> because scmd->result has the SCSI ML byte set
> (which is set by scsi_check_sense()).
> 
> The 2 commands without sense data will have scmd->result == 0,
> so they will get DID_TIME_OUT set if we don't have the extra
> !(scmd->flags & SCMD_EH_SUCCESS_CMD)) condition.
> 
> 
> SCSI could add an additional check for:
> 
> if (!scmd->result && !scsi_sense_valid(scmd) &&
>      !(scmd->flags & SCMD_EH_SUCCESS_CMD))
> 	scmd->result |= (DID_TIME_OUT << 16);
> 
> so that a command with does have sense data, but scsi_check_sense()
> did not set any SCSI ML byte, does not get DID_TIME_OUT set.
> 
> However, for CDL policy 0xD, which this patch cares about,
> we would still need the "&& !(scmd->flags & SCMD_EH_SUCCESS_CMD))",
> so at least from a CDL perspective, I don't see how any benefit of
> also adding a check for "&& !scsi_sense_valid(scmd)".
> 

Right, I see.
Thanks for the explanation.

You can add:

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer

