Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB359C197A0
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Nov 2023 22:53:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbjKTWxy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Nov 2023 17:53:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjKTWxy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Nov 2023 17:53:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0775A2
        for <linux-scsi@vger.kernel.org>; Mon, 20 Nov 2023 14:53:50 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89101C433C8;
        Mon, 20 Nov 2023 22:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700520830;
        bh=aW9oiZ3o4UGPxFMSHXh5t1d8o/tBWYebBgReCYTpbkk=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=mxh9lEhJ3xJlLKVaB60eVEkz0Dnf3NlNEQeQNJzKBhoosaKucxdmLfI3hyINl/Y72
         RGrCzzaceqz0yU8iZ/K4XZmnWhuSMhcMHu5Ikx6XbeUJrsF45pQ1UqUEuZHWmUPJRf
         lhPzTh919DXomilLCQhe54ocWRgpUu7rp2HhodpIx9djRRpCo4WhPA9Nf9oW8NK4Qd
         I1kv12hmxeZ6E5QbLlLH+pzDt/vCX/4Nb7iAYNxW6Hdn3x/KJEzxX18HxxePqNOHuz
         XwRxJBZ4pAJQgOdZcjK9Ru2/3ctqY7Ta3sGgopNKaGojK3x4pGFS5pDxOxCUAGWDmK
         l3TdKeKhqERDw==
Message-ID: <8b9d4663-dca5-496a-a173-feb5d7bf01bc@kernel.org>
Date:   Tue, 21 Nov 2023 07:53:48 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] scsi: Change scsi device boolean fields to single bit
 flags
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Cc:     Phillip Susi <phill@thesusis.net>
References: <20231120073522.34180-1-dlemoal@kernel.org>
 <20231120073522.34180-2-dlemoal@kernel.org>
 <6e72b067-15a3-47e2-98c3-fdeed054dfba@acm.org>
Content-Language: en-US
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <6e72b067-15a3-47e2-98c3-fdeed054dfba@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/21/23 01:06, Bart Van Assche wrote:
> On 11/19/23 23:35, Damien Le Moal wrote:
>> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
>> index 10480eb582b2..1fb460dfca0c 100644
>> --- a/include/scsi/scsi_device.h
>> +++ b/include/scsi/scsi_device.h
>> @@ -167,19 +167,19 @@ struct scsi_device {
>>   	 * power state for system suspend/resume (suspend to RAM and
>>   	 * hibernation) operations.
>>   	 */
>> -	bool manage_system_start_stop;
>> +	unsigned manage_system_start_stop:1;
>>   
>>   	/*
>>   	 * If true, let the high-level device driver (sd) manage the device
>>   	 * power state for runtime device suspand and resume operations.
>>   	 */
>> -	bool manage_runtime_start_stop;
>> +	unsigned manage_runtime_start_stop:1;
>>   
>>   	/*
>>   	 * If true, let the high-level device driver (sd) manage the device
>>   	 * power state for system shutdown (power off) operations.
>>   	 */
>> -	bool manage_shutdown;
>> +	unsigned manage_shutdown:1;
>>   
>>   	unsigned removable:1;
>>   	unsigned changed:1;	/* Data invalid due to media change */
> 
> Is there any code that modifies the above flags from different
> threads simultaneously? I'm wondering whether this patch introduces
> one or more race conditions related to changing these flags.

These are set once when the LLD probes and initialize the scsi device and never
changed again by the LLD. The manage_xxx_start_stop flags can be changed through
sysfs though, but doing so would be a mistake as things would stop working as
expected... I do think that we should change these flags to be RO in sysfs.

Note that only libata and the firewire/sbp2 driver use these flags.

> 
> Thanks,
> 
> Bart.

-- 
Damien Le Moal
Western Digital Research

