Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F155C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 20 May 2022 05:52:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345656AbiETFws (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 May 2022 01:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345649AbiETFwq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 May 2022 01:52:46 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86E25C1EFC
        for <linux-scsi@vger.kernel.org>; Thu, 19 May 2022 22:52:44 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 43E9A21B6E;
        Fri, 20 May 2022 05:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653025963; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NQp1MKdw4IUXnkixa8g6VidafxUwA1tZFIsoYFo5e7c=;
        b=KZ5OliPVXbdvjomGe3aR9CERiE0wN4SWKZ6kIev9TwS4fESQUFT+Ws0hyk8aBLRgMyBSY/
        niMlOGp/ztlDtIWpQ/c2Pq0+BZgp+K4oCtzdkD/s6W0Zu2W7K/XgRF9qNGO0+2gFMgdsgf
        2ipZQPMfHkBo7NN0w52bfvcgEYoXjuw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653025963;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NQp1MKdw4IUXnkixa8g6VidafxUwA1tZFIsoYFo5e7c=;
        b=nZ+eK1zbuUwm4LaR1pVxYcWEWU5ckqKvH6yBuH2blKv0IcR7JQT+3piuskwNewCSmsNx9b
        9qK5fj1b5omqWQBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 63B0B1330F;
        Fri, 20 May 2022 05:52:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id gwgzDaosh2IzCwAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 20 May 2022 05:52:42 +0000
Message-ID: <9e69b1d4-f00d-01e4-2425-b3db6c1a5d62@suse.de>
Date:   Fri, 20 May 2022 07:52:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 08/20] ibmvfc: open-code reset loop for target reset
Content-Language: en-US
To:     Ewan Milne <emilne@redhat.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Tyrel Datwyler <tyreld@linux.ibm.com>
References: <20220512111236.109851-1-hare@suse.de>
 <20220512111236.109851-9-hare@suse.de>
 <CAGtn9rn=RZRYpjD68ug+j6+ogenH-DSYD3-023bc5basjvq-4g@mail.gmail.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <CAGtn9rn=RZRYpjD68ug+j6+ogenH-DSYD3-023bc5basjvq-4g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/19/22 13:05, Ewan Milne wrote:
> This patch looks like it will call ibmvfc_reset_device() w/IBMVFC_TARGET_RESET
> before it has called ibmvfc_cancel_all() on all the devices, the
> existing code calls
> ibmvfc_reset_device() w/IBMVFC_TARGET_RESET after the iterator.
> 
> Since you have the starget, why change to use shost_for_each_device()
> and check the
> sdev->channel and sdev->id ?  That's what starget_for_each_device() does.
> 
> -Ewan
> 
> On Thu, May 12, 2022 at 7:13 AM Hannes Reinecke <hare@suse.de> wrote:
>>
>> From: Hannes Reinecke <hare@suse.com>
>>
>> For target reset we need a device to send the target reset to,
>> so open-code the loop in target reset to send the target reset TMF
>> to the correct device.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.com>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
>> Cc: Tyrel Datwyler <tyreld@linux.ibm.com>
>> ---
>>   drivers/scsi/ibmvscsi/ibmvfc.c | 42 +++++++++++++++++++---------------
>>   1 file changed, 23 insertions(+), 19 deletions(-)
>>
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
>> index d0eab5700dc5..721d965f4b0e 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
>> @@ -2925,18 +2925,6 @@ static void ibmvfc_dev_cancel_all_noreset(struct scsi_device *sdev, void *data)
>>          *rc |= ibmvfc_cancel_all(sdev, IBMVFC_TMF_SUPPRESS_ABTS);
>>   }
>>
>> -/**
>> - * ibmvfc_dev_cancel_all_reset - Device iterated cancel all function
>> - * @sdev:      scsi device struct
>> - * @data:      return code
>> - *
>> - **/
>> -static void ibmvfc_dev_cancel_all_reset(struct scsi_device *sdev, void *data)
>> -{
>> -       unsigned long *rc = data;
>> -       *rc |= ibmvfc_cancel_all(sdev, IBMVFC_TMF_TGT_RESET);
>> -}
>> -
>>   /**
>>    * ibmvfc_eh_target_reset_handler - Reset the target
>>    * @cmd:       scsi command struct
>> @@ -2946,22 +2934,38 @@ static void ibmvfc_dev_cancel_all_reset(struct scsi_device *sdev, void *data)
>>    **/
>>   static int ibmvfc_eh_target_reset_handler(struct scsi_cmnd *cmd)
>>   {
>> -       struct scsi_device *sdev = cmd->device;
>> -       struct ibmvfc_host *vhost = shost_priv(sdev->host);
>> -       struct scsi_target *starget = scsi_target(sdev);
>> +       struct scsi_target *starget = scsi_target(cmd->device);
>> +       struct fc_rport *rport = starget_to_rport(starget);
>> +       struct Scsi_Host *shost = rport_to_shost(rport);
>> +       struct ibmvfc_host *vhost = shost_priv(shost);
>>          int block_rc;
>>          int reset_rc = 0;
>>          int rc = FAILED;
>>          unsigned long cancel_rc = 0;
>> +       bool tgt_reset = false;
>>
>>          ENTER;
>> -       block_rc = fc_block_scsi_eh(cmd);
>> +       block_rc = fc_block_rport(rport);
>>          ibmvfc_wait_while_resetting(vhost);
>>          if (block_rc != FAST_IO_FAIL) {
>> -               starget_for_each_device(starget, &cancel_rc, ibmvfc_dev_cancel_all_reset);
>> -               reset_rc = ibmvfc_reset_device(sdev, IBMVFC_TARGET_RESET, "target");
>> +               struct scsi_device *sdev;
>> +
>> +               shost_for_each_device(sdev, shost) {
>> +                       if ((sdev->channel != starget->channel) ||
>> +                           (sdev->id != starget->id))
>> +                               continue;
>> +
>> +                       cancel_rc |= ibmvfc_cancel_all(sdev,
>> +                                                      IBMVFC_TMF_TGT_RESET);
>> +                       if (!tgt_reset) {
>> +                               reset_rc = ibmvfc_reset_device(sdev,
>> +                                       IBMVFC_TARGET_RESET, "target");
>> +                               tgt_reset = true;
>> +                       }
>> +               }
>>          } else
>> -               starget_for_each_device(starget, &cancel_rc, ibmvfc_dev_cancel_all_noreset);
>> +               starget_for_each_device(starget, &cancel_rc,
>> +                                       ibmvfc_dev_cancel_all_noreset);
>>
>>          if (!cancel_rc && !reset_rc)
>>                  rc = ibmvfc_wait_for_ops(vhost, starget, ibmvfc_match_target);
>> --
>> 2.29.2
>>
> 
You are right; the call to ibmvfc_reset_device() needs to be moved out 
of the loop.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman
