Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 967D8C25B41
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Oct 2023 08:40:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbjJWIkD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Oct 2023 04:40:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232422AbjJWIkB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2023 04:40:01 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A44310C2
        for <linux-scsi@vger.kernel.org>; Mon, 23 Oct 2023 01:39:45 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id A8B9221ABE;
        Mon, 23 Oct 2023 08:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1698050383; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cq6BsP3iQ1wFRroj8gp3PlHp2ddHBFsWyqcyT+dkTMM=;
        b=Oj3J0AJGhjitTI3e5QXJQ0PsuXdOjGAzbxi+6tC83bqR/XGfxI4L1oSJH+Gf3W9kg6Vgmy
        r6F35qvszKqSxnXs6gFWFKeCBzclA21MnG+KY1xENReIAOPb+zREMb4weyT++slIoP+kw5
        hwQWwgBz/l/LTIC809GlCL/hm44+o/E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1698050383;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cq6BsP3iQ1wFRroj8gp3PlHp2ddHBFsWyqcyT+dkTMM=;
        b=3u4FROaR8IrG3mZ3TU9Dm0me0ck/Jsz0fzb/nHpzFmNJgKJQNyYg11y+X5NgPPGS+1Q8wH
        k73dSNeRgVHlq3DQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 97EC8132FD;
        Mon, 23 Oct 2023 08:39:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Ui6tJE8xNmV7IgAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 23 Oct 2023 08:39:43 +0000
Message-ID: <9b4480aa-8123-4f07-84ad-5fe1751f1e60@suse.de>
Date:   Mon, 23 Oct 2023 10:39:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/9] scsi: Use Scsi_Host as argument for
 eh_host_reset_handler
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
References: <20231016121542.111501-1-hare@suse.de>
 <20231016121542.111501-2-hare@suse.de>
 <1ca312b6-c14c-42c3-9bec-5fc11ef8a642@acm.org>
Content-Language: en-US
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <1ca312b6-c14c-42c3-9bec-5fc11ef8a642@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp-out1.suse.de;
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
         RCPT_COUNT_FIVE(0.00)[6];
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

On 10/18/23 20:20, Bart Van Assche wrote:
> On 10/16/23 05:15, Hannes Reinecke wrote:
>> diff --git a/Documentation/scsi/scsi_mid_low_api.rst 
>> b/Documentation/scsi/scsi_mid_low_api.rst
>> index 022198c51350..85b1384ba4fd 100644
>> --- a/Documentation/scsi/scsi_mid_low_api.rst
>> +++ b/Documentation/scsi/scsi_mid_low_api.rst
>> @@ -777,7 +777,7 @@ Details::
>>       /**
>>       *      eh_host_reset_handler - reset host (host bus adapter)
>> -    *      @scp: SCSI host that contains this device should be reset
>> +    *      @shp: SCSI host that contains this device should be reset
> 
> Please change this into "@shp: SCSI host that should be reset".
> 
Ok.

>>       /*  If we can't locate the host to reset, then we failed. */
>> -    if ((hd = shost_priv(SCpnt->device->host)) == NULL){
>> -        printk(KERN_ERR MYNAM ": host reset: "
>> -            "Can't locate host! (sc=%p)\n", SCpnt);
>> +    if ((hd = shost_priv(sh)) == NULL){
>> +        printk(KERN_ERR MYNAM ": host reset: Can't locate host!\n");
>>           return FAILED;
>>       }
> 
> Please move the assignment out of the if-statement since the 
> if-statement has to be modified anyway.
> 
I've removed the entire 'if' clause as 'shost_priv()' really cannot be 
NULL here.

>> -    printk(MYIOC_s_INFO_FMT "host reset: %s (sc=%p)\n",
>> -        ioc->name, ((retval == 0) ? "SUCCESS" : "FAILED" ), SCpnt);
>> +    printk(MYIOC_s_INFO_FMT "host reset: %s\n",
>> +        ioc->name, ((retval == 0) ? "SUCCESS" : "FAILED" ));
> 
> Please consider removing the superfluous parentheses from the modified 
> code.
> 
Ok.

>>       hostdata->eh_complete = NULL;
>> -    /* Revalidate the transport parameters of the failing device */
>> -    if(hostdata->fast)
>> -        spi_schedule_dv_device(SCp->device);
>> -
>> -    spin_unlock_irq(SCp->device->host->host_lock);
>> +    /* Revalidate the transport parameters for attached devices */
>> +    if(hostdata->fast) {
>> +        struct scsi_device *sdev;
>> +        __shost_for_each_device(sdev, host)
>> +            spi_schedule_dv_device(sdev);
>> +    }
>> +    spin_unlock_irq(host->host_lock);
>>       return SUCCESS;
> 
> Since the above changes behavior of the SPI transport, shouldn't this be 
> mentioned in the patch description?
> 
Hmm. It doesn't change the behaviour for SPI transport, just for the 
53c700 driver. But I'll check what the other SPI drivers are doing;
I would have thought that a host reset would also reset the SPI timings,
and as such all devices would have to be revalidated. If not then
it begs the question why we need to reset only SPI timings for the
device of the first command; there might be several commands failing
referring to different devices.
And if we have to escalate to host reset we would revalidate only the
SPI timings for the first device, with all the other failing devices
still running on their original timing.
Which really makes no sense.

>> diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
>> index 72ceaf650b0d..9be45b7a2571 100644
>> --- a/drivers/scsi/BusLogic.c
>> +++ b/drivers/scsi/BusLogic.c
>> @@ -2852,21 +2852,14 @@ static bool blogic_write_outbox(struct 
>> blogic_adapter *adapter,
>>   /* Error Handling (EH) support */
>> -static int blogic_hostreset(struct scsi_cmnd *SCpnt)
>> +static int blogic_hostreset(struct Scsi_Host *shost)
>>   {
>> -    struct blogic_adapter *adapter =
>> -        (struct blogic_adapter *) SCpnt->device->host->hostdata;
>> -
>> -    unsigned int id = SCpnt->device->id;
>> -    struct blogic_tgt_stats *stats = &adapter->tgt_stats[id];
>> +    struct blogic_adapter *adapter = shost_priv(shost);
>>       int rc;
>> -    spin_lock_irq(SCpnt->device->host->host_lock);
>> -
>> -    blogic_inc_count(&stats->adapter_reset_req);
>> -
>> +    spin_lock_irq(shost->host_lock);
>>       rc = blogic_resetadapter(adapter, false);
>> -    spin_unlock_irq(SCpnt->device->host->host_lock);
>> +    spin_unlock_irq(shost->host_lock);
>>       return rc;
>>   }
> 
> Why has the blogic_inc_count() call been left out?
> 
Good question. Will be fixing it.

Cheers,

Hannes

