Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01E8EC433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  3 May 2022 18:42:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234806AbiECSqB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 May 2022 14:46:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbiECSp7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2022 14:45:59 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B833191E
        for <linux-scsi@vger.kernel.org>; Tue,  3 May 2022 11:42:26 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 06AF521871;
        Tue,  3 May 2022 18:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651603345; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uBQS4foiJaAAUHMi1P0OFgno4dnRlUF1RQ5nlEzs944=;
        b=HyFUYnTue2FkNSu7ziTaI/zMgf4UDzpyXfQvu+rDDroseODlKEoyXu2qHQT6Oem1qkpeC2
        k+u3HclXzp9peq3AvKOsb5VPHwVIee6srx1pDGEQRY4MDAxIkso8om/WyFhQG2mL3hCNja
        /Npj82dUxXETlxREbotFiOy/0LW3RUE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651603345;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uBQS4foiJaAAUHMi1P0OFgno4dnRlUF1RQ5nlEzs944=;
        b=yeuHi+ZIGVEunXuOv77wBmntoTDezzVlvFC57JTuseVNoM5ZyRG3ss5PiSoAlHqJ8AMoPr
        yhmjNATogbdM/mDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E6DB113AA3;
        Tue,  3 May 2022 18:42:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id HeEDKY53cWI0UgAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 03 May 2022 18:42:22 +0000
Message-ID: <1c0b14a9-a389-776a-d9fa-aa26498c653d@suse.de>
Date:   Tue, 3 May 2022 11:42:20 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 03/24] zfcp: open-code fc_block_scsi_eh() for host reset
Content-Language: en-US
To:     Steffen Maier <maier@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Benjamin Block <bblock@linux.ibm.com>
References: <20220502213820.3187-1-hare@suse.de>
 <20220502213820.3187-4-hare@suse.de>
 <6e2c56db-99bc-64d6-34e0-af0f21de9707@linux.ibm.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <6e2c56db-99bc-64d6-34e0-af0f21de9707@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/3/22 10:21, Steffen Maier wrote:
> Hi Hannes,
> 
> On 5/2/22 23:37, Hannes Reinecke wrote:
>> When issuing a host reset we should be waiting for all
>> ports to become unblocked; just waiting for one might
>> be resulting in host reset to return too early.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.com>
>> Cc: Steffen Maier <maier@linux.ibm.com>
>> Cc: Benjamin Block <bblock@linux.ibm.com>
>> ---
>>   drivers/s390/scsi/zfcp_scsi.c | 29 +++++++++++++++++++++++------
>>   1 file changed, 23 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/s390/scsi/zfcp_scsi.c 
>> b/drivers/s390/scsi/zfcp_scsi.c
>> index 526ac240d9fe..fb2b73fca381 100644
>> --- a/drivers/s390/scsi/zfcp_scsi.c
>> +++ b/drivers/s390/scsi/zfcp_scsi.c
>> @@ -373,9 +373,11 @@ static int 
>> zfcp_scsi_eh_target_reset_handler(struct scsi_cmnd *scpnt)
>>   static int zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *scpnt)
>>   {
>> -    struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(scpnt->device);
>> -    struct zfcp_adapter *adapter = zfcp_sdev->port->adapter;
>> -    int ret = SUCCESS, fc_ret;
>> +    struct Scsi_Host *host = scpnt->device->host;
>> +    struct zfcp_adapter *adapter = (struct zfcp_adapter 
>> *)host->hostdata[0];
>> +    int ret = SUCCESS;
>> +    unsigned long flags;
>> +    struct zfcp_port *port;
>>       if (!(adapter->connection_features & FSF_FEATURE_NPIV_MODE)) {
>>           zfcp_erp_port_forced_reopen_all(adapter, 0, "schrh_p");
>> @@ -383,9 +385,24 @@ static int zfcp_scsi_eh_host_reset_handler(struct 
>> scsi_cmnd *scpnt)
>>       }
>>       zfcp_erp_adapter_reopen(adapter, 0, "schrh_1");
>>       zfcp_erp_wait(adapter);
>> -    fc_ret = fc_block_scsi_eh(scpnt);
>> -    if (fc_ret)
>> -        ret = fc_ret;
>> +retry_rport_blocked:
>> +    spin_lock_irqsave(host->host_lock, flags);
>> +    list_for_each_entry(port, &adapter->port_list, list) {
> 
> Reading adapter->port_list needs to be protected by
>      read_lock_irq(&adapter->port_list_lock);
> 
> Cf. Benjamin's last review 
> https://lore.kernel.org/linux-scsi/YRujHScPbb1Aokrj@t480-pf1aa2c2.linux.ibm.com/ 
> 
> 
Ah. Sorry. Will be including it in the next round.

>> +        struct fc_rport *rport = port->rport;
> 
> While an rport is blocked, port->rport == NULL [zfcp_scsi_rport_block() 
> and zfcp_scsi_rport_register()], so below could be a NULL pointer deref.
> Or is there evidence we would never have a blocked rport while iterating 
> port_list here?
> 
> See also my previous review comments 
> https://lore.kernel.org/linux-scsi/a7950ea7-380c-bb01-7f31-5c555217ad2d@linux.vnet.ibm.com/ 
> 
> It also alludes to lock ordering.
> 
Right. Will be folding in the changes.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
