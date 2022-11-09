Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F05FC4332F
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Nov 2022 09:37:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbiKIJhh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Nov 2022 04:37:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbiKIJhg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2022 04:37:36 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D66511A34;
        Wed,  9 Nov 2022 01:37:32 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 0B8B91F903;
        Wed,  9 Nov 2022 09:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1667986651; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZZAQUNnQw/srCqQQSjshlY5taFfn85M58QTBf8TnK2M=;
        b=W3HInWejp+Prt5tZ1uu9n79fEqLw6g+nBwxbKWJlxFxYr4g3h82yQesHd85pTXqVZwAL1r
        A9irnJw8FSriVcbmI/Yvx7PUu3zi3mAvWyfFG+MPgrqq7jyl97Cgmct2xUax8MFDoto2mF
        xvVJAGKaAb/VljBXjqPiyLkKf4T2+VY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1667986651;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZZAQUNnQw/srCqQQSjshlY5taFfn85M58QTBf8TnK2M=;
        b=PaiO76RV3035naGJ+3loiIvi9B5ZysWnqHwU7gg41rX68smWqQs/dhkyjMkD27ugqD3OAS
        Biy5UDfYjxajkoBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E401F1331F;
        Wed,  9 Nov 2022 09:37:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id LjZIN9p0a2NieQAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 09 Nov 2022 09:37:30 +0000
Message-ID: <690bc629-8606-a533-1b44-d6b97319b811@suse.de>
Date:   Wed, 9 Nov 2022 10:37:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v2] ata: libata-core: do not issue non-internal commands
 once EH is pending
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        John Garry <john.g.garry@oracle.com>,
        "tj@kernel.org" <tj@kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>
References: <20221107161036.670237-1-niklas.cassel@wdc.com>
 <5a4fa5db-c706-5cf2-1145-bf091445d20e@oracle.com>
 <Y2mbX8MvYrF0FHaI@x1-carbon>
 <976bdcb7-cb97-9332-2bcc-5d98bc41871b@opensource.wdc.com>
 <Y2ri7EVPZb2O9iD8@x1-carbon> <c0a34e41-17ca-cbc1-cf54-9fee23b830a3@suse.de>
 <Y2tyqn+VAVfL+muq@x1-carbon>
Content-Language: en-US
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <Y2tyqn+VAVfL+muq@x1-carbon>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/9/22 10:28, Niklas Cassel wrote:
> On Wed, Nov 09, 2022 at 08:11:17AM +0100, Hannes Reinecke wrote:
>> Thanks for the detailed explanation, Niklas.
>>
>> However, one fundamental thing is still unresolved:
>> I've switched SCSI EH to do asynchronous aborts with commit e494f6a72839
>> ("[SCSI] improved eh timeout handler"); since then commands will be aborted
>> without invoking SCSI EH.
>>
>> This goes _fundamentally_ against libata's .eh_strategy (as it's never
>> invoked), and as such libata _cannot_ use command aborts.
>> Which typically wouldn't matter as ATA doesn't have command aborts, and
>> realistically any error is causing the NCQ queue to be drained.
>>
>> So SCSI EH scsi_abort_command() really shouldn't queue a workqueue item, as
>> it'll never be able to do anything meaningful.
>>
>> You need this patch:
>>
>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
>> index be2a70c5ac6d..4fb72b73871e 100644
>> --- a/drivers/scsi/scsi_error.c
>> +++ b/drivers/scsi/scsi_error.c
>> @@ -242,6 +242,11 @@ scsi_abort_command(struct scsi_cmnd *scmd)
>>                  return FAILED;
>>          }
>>
>> +       if (!hostt->eh_abort_handler) {
>> +               /* No abort handler, fail command directly */
>> +               return FAILED;
>> +       }
>> +
>>          spin_lock_irqsave(shost->host_lock, flags);
>>          if (shost->eh_deadline != -1 && !shost->last_reset)
>>                  shost->last_reset = jiffies;
>>
>> to avoid having libata trying to queue a (pointless) abort workqueue item,
>> and get rid of the various workqueue thingies you mentioned above.
>>
>> And it's a sensible fix anyway, will be sending it as a separate patch.
> 
> Hello Hannes,
> 
> This is how it looks before your patch:
> scsi_logging_level -s -E 7
> 
> [   33.737069] sd 0:0:0:0: [sda] tag#0 abort scheduled
> [   33.738812] sd 0:0:0:0: [sda] tag#3 abort scheduled
> [   33.749085] sd 0:0:0:0: [sda] tag#0 aborting command
> [   33.751393] sd 0:0:0:0: [sda] tag#0 cmd abort failed
> [   33.753541] sd 0:0:0:0: [sda] tag#3 aborting command
> [   33.755565] sd 0:0:0:0: [sda] tag#3 cmd abort failed
> [   33.763051] scsi host0: Waking error handler thread
> [   33.765727] scsi host0: scsi_eh_0: waking up 0/2/2
> [   33.768815] ata1.00: exception Emask 0x0 SAct 0x9 SErr 0x0 action 0x0
> [   33.772211] ata1.00: irq_stat 0x40000000
> [   33.774187] ata1.00: failed command: WRITE FPDMA QUEUED
> [   33.776962] ata1.00: cmd 61/00:00:00:00:0f/01:00:00:00:00/40 tag 0 ncq dma 131072 out
> [   33.776962]          res 43/04:00:00:00:00/00:00:00:00:00/00 Emask 0x400 (NCQ error) <F>
> [   33.783598] ata1.00: status: { DRDY SENSE ERR }
> [   33.785252] ata1.00: error: { ABRT }
> [   33.791290] ata1.00: configured for UDMA/100
> [   33.792195] sd 0:0:0:0: [sda] tag#0 scsi_eh_0: flush finish cmd
> [   33.793426] sd 0:0:0:0: [sda] tag#3 scsi_eh_0: flush finish cmd
> [   33.794653] ata1: EH complete
> 
> So we do get the scmd:s sent to ATA EH (strategy_handler).
> 
> In scmd_eh_abort_handler(), scsi_try_to_abort_cmd() will return FAILED
> since hostt->eh_abort_handler is not implemented for libata, so
> scmd_eh_abort_handler() will do goto out; which calls scsi_eh_scmd_add().
> 
> 
> This is how it looks after your patch:
> scsi_logging_level -s -E 7
> 
> [  223.417749] scsi host0: Waking error handler thread
> [  223.419782] scsi host0: scsi_eh_0: waking up 0/2/2
> [  223.423101] ata1.00: exception Emask 0x0 SAct 0x80002 SErr 0x0 action 0x0
> [  223.425362] ata1.00: irq_stat 0x40000008
> [  223.426778] ata1.00: failed command: WRITE FPDMA QUEUED
> [  223.428925] ata1.00: cmd 61/00:08:00:00:0f/01:00:00:00:00/40 tag 1 ncq dma 131072 out
> [  223.428925]          res 43/04:00:00:00:00/00:00:00:00:00/00 Emask 0x400 (NCQ error) <F>
> [  223.436077] ata1.00: status: { DRDY SENSE ERR }
> [  223.438015] ata1.00: error: { ABRT }
> [  223.441179] ata1.00: Security Log not supported
> [  223.445698] ata1.00: Security Log not supported
> [  223.448475] ata1.00: configured for UDMA/100
> [  223.449790] sd 0:0:0:0: [sda] tag#1 scsi_eh_0: flush finish cmd
> [  223.451063] sd 0:0:0:0: [sda] tag#19 scsi_eh_0: flush finish cmd
> [  223.452648] ata1: EH complete
> 
> So your patch looks good to me, like you said, it removes a
> a pointless queue_work().
> 
> Do we perhaps want to remove the !hostt->eh_abort_handler check
> from scmd_eh_abort_handler(), now when you've moved it earlier
> (to scsi_abort_command()) ? Perhaps we need to keep it, since
> the function used for checking this, scsi_try_to_abort_cmd()
> is used in other places as well.
> 
I'd keep it as it aligns with all the other 'scsi_try_to_XXX()' commands.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer

