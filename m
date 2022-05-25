Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3435C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 25 May 2022 12:08:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234006AbiEYMIF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 May 2022 08:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230511AbiEYMIE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 May 2022 08:08:04 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A504C12754
        for <linux-scsi@vger.kernel.org>; Wed, 25 May 2022 05:08:00 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 46B50219FD;
        Wed, 25 May 2022 12:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653480479; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nwl6kzNM081rV7M+9SayTyi1QTXmCiCzIRRQSZsADaE=;
        b=JExseuqj8kSV4XlYsX3GrJUYOPZE7cefGky/p1W+xevIRIOfcIRN/L/oca6ZvVggFVETH8
        XQui3neEOIp7aPWChWAD6Fp92q1VsZrEDRSW3iU2cXml9zvx19Mm7l+O6I7AeTvQY4AARS
        5Tr1dVrwoSOva68BxNigJPJNBAOJE7Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653480479;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nwl6kzNM081rV7M+9SayTyi1QTXmCiCzIRRQSZsADaE=;
        b=+n6LGrjSRcFHBVi9dZHqeWw/M1WcjdcjGRCKRWGZ+Quhb0R5QHKqoEX9pz93RQlz07nzQF
        wmWK6p0wFsSrxQBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A5D4613487;
        Wed, 25 May 2022 12:07:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 0J+KIx4cjmLRJAAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 25 May 2022 12:07:58 +0000
Message-ID: <afa5f370-4e16-319f-ded8-49e11f12ff56@suse.de>
Date:   Wed, 25 May 2022 14:07:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Content-Language: en-US
To:     Martin Wilck <mwilck@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Brian Bunker <brian@purestorage.com>,
        Martin Wilck <mwilck@suse.de>
References: <20220525081139.88165-1-hare@suse.de>
 <37b61d6b956c18bf4a56d14b5746dab2719ef20d.camel@suse.com>
From:   Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi_dh_alua: mark port group as failed after ALUA
 transitioning timeout
In-Reply-To: <37b61d6b956c18bf4a56d14b5746dab2719ef20d.camel@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/25/22 13:20, Martin Wilck wrote:
> On Wed, 2022-05-25 at 10:11 +0200, Hannes Reinecke wrote:
>> When ALUA transitioning timeout triggers the path group state must
>> be considered invalid. So add a new flag ALUA_PG_FAILED to indicate
>> that the path state isn't necessarily valid, and keep the existing
>> path state until we get a valid response from a RTPG.
>>
>> Cc: Brian Bunker <brian@purestorage.com>
>> Cc: Martin Wilck <mwilck@suse.de>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>   drivers/scsi/device_handler/scsi_dh_alua.c | 24 +++++++-------------
>> --
>>   1 file changed, 7 insertions(+), 17 deletions(-)
>>
>> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c
>> b/drivers/scsi/device_handler/scsi_dh_alua.c
>> index 1d9be771f3ee..6921490a5e65 100644
>> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
>> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
>> @@ -49,6 +49,7 @@
>>   #define ALUA_PG_RUN_RTPG               0x10
>>   #define ALUA_PG_RUN_STPG               0x20
>>   #define ALUA_PG_RUNNING                        0x40
>> +#define ALUA_PG_FAILED                 0x80
>>   
>>   static uint optimize_stpg;
>>   module_param(optimize_stpg, uint, S_IRUGO|S_IWUSR);
>> @@ -420,7 +421,7 @@ static enum scsi_disposition
>> alua_check_sense(struct scsi_device *sdev,
>>                           */
>>                          rcu_read_lock();
>>                          pg = rcu_dereference(h->pg);
>> -                       if (pg)
>> +                       if (pg && !(pg->flags & ALUA_PG_FAILED))
>>                                  pg->state =
>> SCSI_ACCESS_STATE_TRANSITIONING;
>>                          rcu_read_unlock();
>>                          alua_check(sdev, false);
> 
> You still return NEEDS_RETRY from alua_check_sense(), even if
> ALUA_PG_FAILED is set?
> 
>> @@ -694,7 +695,7 @@ static int alua_rtpg(struct scsi_device *sdev,
>> struct alua_port_group *pg)
>>   
>>    skip_rtpg:
>>          spin_lock_irqsave(&pg->lock, flags);
>> -       if (transitioning_sense)
>> +       if (transitioning_sense && !(pg->flags & ALUA_PG_FAILED))
>>                  pg->state = SCSI_ACCESS_STATE_TRANSITIONING;
>>   
>>          if (group_id_old != pg->group_id || state_old != pg->state ||
>> @@ -718,23 +719,10 @@ static int alua_rtpg(struct scsi_device *sdev,
>> struct alua_port_group *pg)
>>                          pg->interval = ALUA_RTPG_RETRY_DELAY;
>>                          err = SCSI_DH_RETRY;
>>                  } else {
>> -                       struct alua_dh_data *h;
>> -
>> -                       /* Transitioning time exceeded, set port to
>> standby */
>> +                       /* Transitioning time exceeded, mark pg as
>> failed */
>>                          err = SCSI_DH_IO;
>> -                       pg->state = SCSI_ACCESS_STATE_STANDBY;
>> +                       pg->flags |= ALUA_PG_FAILED;
>>                          pg->expiry = 0;
>> -                       rcu_read_lock();
>> -                       list_for_each_entry_rcu(h, &pg->dh_list,
>> node) {
>> -                               if (!h->sdev)
>> -                                       continue;
>> -                               h->sdev->access_state =
>> -                                       (pg->state &
>> SCSI_ACCESS_STATE_MASK);
>> -                               if (pg->pref)
>> -                                       h->sdev->access_state |=
>> -
>>                                                 SCSI_ACCESS_STATE_PREFE
>> RRED;
>> -                       }
>> -                       rcu_read_unlock();
>>                  }
>>                  break;
>>          case SCSI_ACCESS_STATE_OFFLINE:
>> @@ -746,6 +734,8 @@ static int alua_rtpg(struct scsi_device *sdev,
>> struct alua_port_group *pg)
>>                  /* Useable path if active */
>>                  err = SCSI_DH_OK;
>>                  pg->expiry = 0;
>> +               /* RTPG succeeded, clear ALUA_PG_FAILED */
>> +               pg->flags &= ~ALUA_PG_FAILED;
> 
> Shouldn't this be done for any state except TRANSITIONING?
> 
Why, but it does.
We're only entering this block if the state is not TRANSITIONING.
(It's part of a 'switch' statement)

> Btw I've re-read SPC6 and found "The IMPLICIT TRANSITION TIME field
> indicates the minimum amount of time in seconds the application client
> should wait prior to timing out an implicit state transition (see
> 5.18.2.3)".
> 
> This is unclear to me. "minimum amount of time" suggests that the host
> could decide to wait longer until it times out the transition. Worse,
> the spec doesn't clearly define when the transition is supposed to have
> started. From the host's PoV it makes sense to assume the start time is
> when it first encounters either TRANSITIONING from an RTPG, or NOT
> READY / 04 / 0a from a regular I/O, which is what we currently do. But
> the spec is remarkably unclear about it. Finally, the spec explicitly
> says that the timeout applies only to implicit transitions, without
> saying what to do in the case of an explicit transition...
> 
Why, but it does; "5.15.2.5 Transitions between target port asymmetric 
access states" speaks at length what should happen when transitions 
fail. Problem is, a timeout expiring is something outside the spec, so 
one can't be sure that the array does what's expected here.

But the one key takeaway is that any port in transitioning is allowed to 
ignore TMFs, so any SCSI EH is pointless anyway.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
