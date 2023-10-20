Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D5C0CDB474
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Oct 2023 05:53:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345092AbjJTFxO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Oct 2023 01:53:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235623AbjJTFxL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Oct 2023 01:53:11 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE2DCD4C
        for <linux-scsi@vger.kernel.org>; Thu, 19 Oct 2023 22:53:08 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 279251F38C;
        Fri, 20 Oct 2023 05:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1697781187; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IUYle1861HTuFVh+Z1grIi06dH6Xwi+ZO/awwpDr9HY=;
        b=Mf5zGGRX6LKDlFjke4KTWuDQYXro8OQa6I22gkNeqSQTQ0f+6ykkKSqQOirfEhf/iHtvXf
        NIORafinu+4Fj2z4RgMHUx/4xaB0KDaX3/yHrbOlp0fyxCZz/2y9EaGLuAN75HfR7bjo8D
        A4eI1HfdKLsC26ZtJwDF1QhU7jHV6Gs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1697781187;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IUYle1861HTuFVh+Z1grIi06dH6Xwi+ZO/awwpDr9HY=;
        b=fAmOJPR6xXb1rjJvTQVeri+5NM42hwAOOVDMBUaxuP0zPlh9PtPY8gdQ9CrnkW2xSqXPB9
        za6KlMyZ2Y0wVADg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EF5DC1348D;
        Fri, 20 Oct 2023 05:53:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id vlXaOMIVMmU1ZQAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 20 Oct 2023 05:53:06 +0000
Message-ID: <06475025-fb65-4ea4-8ae3-54292b2360e4@suse.de>
Date:   Fri, 20 Oct 2023 07:53:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/17] libiscsi: use cls_session as argument for target
 and session reset
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20231016092430.55557-1-hare@suse.de>
 <20231016092430.55557-10-hare@suse.de>
 <00f10f98-46bc-4af2-a3f1-a1523c9f4e1f@oracle.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <00f10f98-46bc-4af2-a3f1-a1523c9f4e1f@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp-out2.suse.de;
        none
X-Spamd-Result: default: False [-7.09 / 50.00];
         ARC_NA(0.00)[];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         XM_UA_NO_VERSION(0.01)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         BAYES_HAM(-3.00)[100.00%];
         MIME_GOOD(-0.10)[text/plain];
         NEURAL_HAM_LONG(-3.00)[-1.000];
         RCPT_COUNT_FIVE(0.00)[5];
         DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
         NEURAL_HAM_SHORT(-1.00)[-1.000];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2];
         RCVD_TLS_ALL(0.00)[];
         MID_RHS_MATCH_FROM(0.00)[]
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/19/23 22:02, Mike Christie wrote:
> On 10/16/23 4:24 AM, Hannes Reinecke wrote:
>> iscsi_eh_target_reset() and iscsi_eh_session_reset() only depend
>> on the cls_session, so use that as an argument.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> ---
>>   drivers/scsi/be2iscsi/be_main.c | 10 +++++++++-
>>   drivers/scsi/libiscsi.c         | 21 +++++++++------------
>>   include/scsi/libiscsi.h         |  2 +-
>>   3 files changed, 19 insertions(+), 14 deletions(-)
>>
>> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
>> index e48f14ad6dfd..441ad2ebc5d5 100644
>> --- a/drivers/scsi/be2iscsi/be_main.c
>> +++ b/drivers/scsi/be2iscsi/be_main.c
>> @@ -385,6 +385,14 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
>>   	return rc;
>>   }
>>   
>> +static int beiscsi_eh_session_reset(struct scsi_cmnd *sc)
>> +{
>> +	struct iscsi_cls_session *cls_session;
>> +
>> +	cls_session = starget_to_session(scsi_target(sc->device));
>> +	return iscsi_eh_session_reset(cls_session);
>> +}
>> +
>>   /*------------------- PCI Driver operations and data ----------------- */
>>   static const struct pci_device_id beiscsi_pci_id_table[] = {
>>   	{ PCI_DEVICE(BE_VENDOR_ID, BE_DEVICE_ID1) },
>> @@ -408,7 +416,7 @@ static const struct scsi_host_template beiscsi_sht = {
>>   	.eh_timed_out = iscsi_eh_cmd_timed_out,
>>   	.eh_abort_handler = beiscsi_eh_abort,
>>   	.eh_device_reset_handler = beiscsi_eh_device_reset,
>> -	.eh_target_reset_handler = iscsi_eh_session_reset,
>> +	.eh_target_reset_handler = beiscsi_eh_session_reset,
>>   	.shost_groups = beiscsi_groups,
>>   	.sg_tablesize = BEISCSI_SGLIST_ELEMENTS,
>>   	.can_queue = BE2_IO_DEPTH,
>> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
>> index 0fda8905eabd..a561eefabb50 100644
>> --- a/drivers/scsi/libiscsi.c
>> +++ b/drivers/scsi/libiscsi.c
>> @@ -2600,13 +2600,11 @@ EXPORT_SYMBOL_GPL(iscsi_session_recovery_timedout);
>>    * This function will wait for a relogin, session termination from
>>    * userspace, or a recovery/replacement timeout.
>>    */
>> -int iscsi_eh_session_reset(struct scsi_cmnd *sc)
>> +int iscsi_eh_session_reset(struct iscsi_cls_session *cls_session)
>>   {
> 
> Patch looks ok to me.
> 
> Reviewed-by: Mike Christie <michael.christie@oracle.com>
> 
> As an alternative to this approach though it might be easier to have
> this function take a scsi_target. You won't need beiscsi_eh_session_reset
> and for iscsi_eh_recover_target you can pass the scsi_target to
> iscsi_eh_recover_target/iscsi_eh_session_reset.
> 
> Either way is ok to me though since we have to convert from scsi_target
> to cls_session somewhere.
> 
Yeah, one could do that. But the relationship between the target and
the host is not fixed, but rather depends on the driver and/or transport 
class. For simpler devices the host is the parent, for others there are 
elements in between so the parent device is something else entirely.
So for generic routines (like libiscsi) I prefer to use dedicated
elements such that the relationship is known.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

