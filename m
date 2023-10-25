Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 540F6C0032E
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Oct 2023 13:37:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232800AbjJYNhC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Oct 2023 09:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232566AbjJYNhB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Oct 2023 09:37:01 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09C09131
        for <linux-scsi@vger.kernel.org>; Wed, 25 Oct 2023 06:37:00 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id F17401FF5F;
        Wed, 25 Oct 2023 13:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1698241017; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PWinwUjDATxQ/orb/2IkmHormvyFydBA/2oSM/LndIY=;
        b=qMqGkWcYasUNNk0KQhWEe7vqSiZ7oQofaexrSLD44iDmJb7bkMQT14wRdNH97YucyQw2rx
        YVnW3UIUUyXruBQSqeabzH9nUvC5rsxCyELV8x0ciZsfb4tsZsxRJpTsYroDMJws6he2jP
        i20lPhad1pGPm+8vZuXJlcldMXo3ncM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1698241017;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PWinwUjDATxQ/orb/2IkmHormvyFydBA/2oSM/LndIY=;
        b=jxAlviFOzILvN2pvhHVngoOIhLASQVUuVw/rCcZ/71YbpH0uCMNQgnOY1z7L+gSyxEQOes
        arI5GHmpEEOHHbAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D5A7813524;
        Wed, 25 Oct 2023 13:36:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id OrQTM/kZOWV7AgAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 25 Oct 2023 13:36:57 +0000
Message-ID: <0879f7eb-72ec-41bf-ac23-9e1e8a669b68@suse.de>
Date:   Wed, 25 Oct 2023 15:36:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/10] scsi: Use Scsi_Host and channel number as argument
 for eh_bus_reset_handler()
Content-Language: en-US
To:     Benjamin Block <bblock@linux.ibm.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
References: <20231023092837.33786-1-hare@suse.de>
 <20231023092837.33786-3-hare@suse.de>
 <20231025133342.GE1917450@p1gen4-pw042f0m.boeblingen.de.ibm.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20231025133342.GE1917450@p1gen4-pw042f0m.boeblingen.de.ibm.com>
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

On 10/25/23 15:33, Benjamin Block wrote:
> On Mon, Oct 23, 2023 at 11:28:29AM +0200, Hannes Reinecke wrote:
>> diff --git a/Documentation/scsi/scsi_mid_low_api.rst b/Documentation/scsi/scsi_mid_low_api.rst
>> index 96983bb1cc45..43083efc554b 100644
>> --- a/Documentation/scsi/scsi_mid_low_api.rst
>> +++ b/Documentation/scsi/scsi_mid_low_api.rst
>> @@ -741,7 +741,8 @@ Details::
>>   
>>       /**
>>       *      eh_bus_reset_handler - issue SCSI bus reset
>> -    *      @scp: SCSI bus that contains this device should be reset
>> +    *      @host: SCSI Host that contains the channel which should be reset
>> +    *      @channel: channel to be reset
>>       *
>>       *      Returns SUCCESS if command aborted else FAILED
> 
> Same as in Patch 1. Although I don't know how relevant FAST_IO_FAIL is for bus
> reset, we don't implement that for zFCP.
> 
I'd rather delegate that to the later patch where I update scsi_error to 
factor in FAST_IO_FAIL for ioctl reset.

>>       *
>> diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
>> index 77c91a405d20..ee8bb7985d09 100644
>> --- a/drivers/scsi/aic7xxx/aic79xx_osm.c
>> +++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
>> @@ -863,21 +863,21 @@ ahd_linux_dev_reset(struct scsi_cmnd *cmd)
>>    * Reset the SCSI bus.
>>    */
>>   static int
>> -ahd_linux_bus_reset(struct scsi_cmnd *cmd)
>> +ahd_linux_bus_reset(struct Scsi_Host *shost, unsigned int channel)
>>   {
>>   	struct ahd_softc *ahd;
>>   	int    found;
>>   	unsigned long flags;
>>   
>> -	ahd = *(struct ahd_softc **)cmd->device->host->hostdata;
>> +	ahd = *(struct ahd_softc **)shost->hostdata;
> 
> Not `shost_priv(shost)`? The pointer casts end up at `struct ahd_softc *`, so
> `void *` as return type should be fine.
> 
Ah, no. The adaptec driver is storing the _pointer_ to 'ahd_softc' in 
hostdata[0]. So shost_priv() won't work here.
Or, rather, not without an additional cast, but then we might as well 
keep it for now.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

