Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5149C07E98
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jul 2021 07:16:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E881613F7
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jul 2021 07:16:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbhGEHSl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Jul 2021 03:18:41 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:37462 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbhGEHSk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jul 2021 03:18:40 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 1D20022673;
        Mon,  5 Jul 2021 07:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1625469363; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IpV6eKpJ4ifVeyqfsk19r7c0EJ94bXGVmyH49kp+/V8=;
        b=1GpaMgwki9Ct9/m0UtXF+l/6oen/Bd7sg9kg7EJhLX1iU/Wa0b3bFsgNLNMKVEpQcW6Q6J
        88XiYOMTdUn3pSyzAFZLpl/ZfMfBmVtgfHcts0gWYG/YEfsbs9P0wXQphJk0BhXjwp6PAj
        LD5aglWQd7AUIfm9lDHNuaOi3I3llrk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1625469363;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IpV6eKpJ4ifVeyqfsk19r7c0EJ94bXGVmyH49kp+/V8=;
        b=n0mhFqId1DZGk1IV7Kbmtska2yFDZ6NV1Qf0Uip7Kmf17PYb8zn5bUObhJWApXX1DSOwgP
        2LUZmbZMK1odGkBw==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id A970613418;
        Mon,  5 Jul 2021 07:16:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id XdhXKLKx4mCnIAAAGKfGzw
        (envelope-from <hare@suse.de>); Mon, 05 Jul 2021 07:16:02 +0000
Subject: Re: [PATCH 02/21] libsas: Only abort commands from inside the error
 handler
To:     Jason Yan <yanaijie@huawei.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        John Garry <john.garry@huawei.com>,
        Yves-Alexis Perez <corsac@debian.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Yufen Yu <yuyufen@huawei.com>
References: <20210701211224.17070-1-bvanassche@acm.org>
 <20210701211224.17070-3-bvanassche@acm.org>
 <779caa02-6c9f-183b-2f3d-2b7dc5c877ef@huawei.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <85816d4a-781e-5ed8-1533-f600e13f5db0@suse.de>
Date:   Mon, 5 Jul 2021 09:16:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <779caa02-6c9f-183b-2f3d-2b7dc5c877ef@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/3/21 4:32 AM, Jason Yan wrote:
> Hi Bart,
> 
> 在 2021/7/2 5:12, Bart Van Assche 写道:
>> According to the information I found in patch commit descriptions, for 
>> SATA
>> devices commands must be aborted from inside the libsas error handler.
>> Check host->ehandler to determine whether or not running inside the error
>> handler since host->host_eh_scheduled != 0 indicates that the SCSI error
>> handler has been scheduled but does not mean that is already running. 
>> This
>> patch restores code that was removed by commit 909657615d9b ("scsi: 
>> libsas:
>> allow async aborts").
>>
>> Cc: Hannes Reinecke <hare@suse.de>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: Ming Lei <ming.lei@redhat.com>
>> Cc: John Garry <john.garry@huawei.com>
>> Cc: Yves-Alexis Perez <corsac@debian.org>
>> Fixes: c9f926000fe3 ("scsi: libsas: Disable asynchronous aborts for 
>> SATA devices")
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> ---
>>   drivers/scsi/libsas/sas_scsi_host.c | 5 ++++-
>>   include/scsi/libsas.h               | 1 +
>>   2 files changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/libsas/sas_scsi_host.c 
>> b/drivers/scsi/libsas/sas_scsi_host.c
>> index ee44a0d7730b..95e4d58ab9d4 100644
>> --- a/drivers/scsi/libsas/sas_scsi_host.c
>> +++ b/drivers/scsi/libsas/sas_scsi_host.c
>> @@ -462,6 +462,7 @@ int sas_eh_abort_handler(struct scsi_cmnd *cmd)
>>       int res = TMF_RESP_FUNC_FAILED;
>>       struct sas_task *task = TO_SAS_TASK(cmd);
>>       struct Scsi_Host *host = cmd->device->host;
>> +    struct sas_ha_struct *ha = SHOST_TO_SAS_HA(host);
>>       struct domain_device *dev = cmd_to_domain_dev(cmd);
>>       struct sas_internal *i = to_sas_internal(host->transportt);
>>       unsigned long flags;
>> @@ -471,7 +472,7 @@ int sas_eh_abort_handler(struct scsi_cmnd *cmd)
>>       spin_lock_irqsave(host->host_lock, flags);
>>       /* We cannot do async aborts for SATA devices */
>> -    if (dev_is_sata(dev) && !host->host_eh_scheduled) {
>> +    if (dev_is_sata(dev) && !ha->eh_running) {
>>           spin_unlock_irqrestore(host->host_lock, flags);
>>           return FAILED;
>>       }
> 
> 
> No idea why sas_eh_abort_handler() is only used by isci. The other
> libsas drivers just let the error handler do the aborting work. So my
> question is can the isci driver delete this callback and let the error
> handler do this? If so, then we cann remove this function directly.
> 
That, indeed, is a good point. SATA commands are being handled by the 
sas_ata_strategy_handler (as they don't really match the SAM logic wrt TMF).
And actually there is no 'abort' command on SATA; the best you can do is 
'abort queue', but that's more like an 'ABORT TASK SET' in SAM.
So either way that callback is pointless.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
