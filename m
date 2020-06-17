Return-Path: <SRS0=X8O6=76=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB5B5C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Jun 2020 19:38:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A85B421532
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Jun 2020 19:38:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=octiron.net header.i=@octiron.net header.b="s4niYvrh";
	dkim=pass (2048-bit key) header.d=octiron.net header.i=@octiron.net header.b="iNRgLuzI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726919AbgFQTit (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Jun 2020 15:38:49 -0400
Received: from djelibeybi.uuid.uk ([45.91.101.70]:57950 "EHLO
        djelibeybi.uuid.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726597AbgFQTis (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jun 2020 15:38:48 -0400
X-Greylist: delayed 389 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Jun 2020 15:38:46 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=octiron.net
        ; s=20180214; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:Reply-To:Cc:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=CBFAg6s+vq5P374WzvzyZ5LF5sqRXWLUvi7gDQCysuQ=; b=s4niYvrhMPjKxPqwZfV/XTAR6X
        iqawHB1UE2brS2dFuRjx2BU/xoVl7uZN77L6+lV00LVJkldfRno8zX0HrZ8wLzQdqfWS1RYGNUgEu
        rfjfFsLmKcHLU3hTd5Diwj/dmRc8qPan8G0sp3/FftcuLt5Ba9RdqUkStAUskP6k0Kx/yDwP3Wb0b
        XCllNmx+7J9zxkPSem743Ksy483GZJmUUgmMYghnHdRlEJB/iXU8KT10IWJeNkfI0tDnSHHVsB49/
        IRKXRKuVWIyJCGM0wRLfS3VDQGu1ovwVtYT5QcfRPRUFDpo95gN0uE4Jjqh31rs3pD6tLCX+D3iQM
        tYodPY3w==;
Received: by djelibeybi.uuid.uk with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <simon@octiron.net>)
        id 1jldn9-0001NO-4a; Wed, 17 Jun 2020 20:32:15 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=octiron.net
        ; s=20180214; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:To:Subject;
        bh=CBFAg6s+vq5P374WzvzyZ5LF5sqRXWLUvi7gDQCysuQ=; b=iNRgLuzImYOvm7B2xpgqc+VmTG
        wSOj8XmLpCXMk8XZWAPtXq10UdhX85+0B0vNcO7HZS7RxhBYV60tW8QQ0G1zeuLYXnzFYf4MgO00K
        dphadsBfZCgcLuk1U1LytGUTHTEz4bSPbumr0a8kRhAfRS4PeJm+7sfPW4kfv3J5QPlI1FDfZ08VT
        jFBZOdQ3FM7D3Ah5tDYzMnAASIc2JR94Uq4v76bohe315pkXZ5Gqyrrevf48Sb2bftgKr98QEL8P3
        njaYk/7yR6fHUz9GoQ9zq5EDv2Hj/t8KtGtMluUIwXM7Hl+7XiA3e4l3AQjNBT08bFnMYKgQUDt3u
        43Jqp2ZA==;
Received: by tsort.uuid.uk with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <simon@octiron.net>)
        id 1jldn7-00062R-3q; Wed, 17 Jun 2020 20:32:09 +0100
Subject: Re: [PATCH] scsi: sd: stop SSD (non-rotational) disks before reboot
To:     Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org
References: <499138c8-b6d5-ef4a-2780-4f750ed337d3@0882a8b5-c6c3-11e9-b005-00805fc181fe>
 <b92ce48a-55d8-9377-f6c5-510d7e3beb1b@acm.org>
From:   Simon Arlott <simon@octiron.net>
Message-ID: <04bf3c02-85f4-3fbc-525a-4189aadf9241@0882a8b5-c6c3-11e9-b005-00805fc181fe>
Date:   Wed, 17 Jun 2020 20:32:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <b92ce48a-55d8-9377-f6c5-510d7e3beb1b@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 17/06/2020 20:19, Bart Van Assche wrote:
> On 2020-06-17 11:49, Simon Arlott wrote:
>> @@ -3576,9 +3582,19 @@ static void sd_shutdown(struct device *dev)
>>  		sd_sync_cache(sdkp, NULL);
>>  	}
>>  
>> -	if (system_state != SYSTEM_RESTART && sdkp->device->manage_start_stop) {
>> -		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
>> -		sd_start_stop_device(sdkp, 0);
>> +	if (sdkp->device->manage_start_stop) {
>> +		bool stop_disk = (system_state != SYSTEM_RESTART);
>> +
>> +		if (stop_before_reboot > 1) { /* stop all disks */
>> +			stop_disk = true;
>> +		} else if (stop_before_reboot) { /* non-rotational only */
>> +			stop_disk |= blk_queue_nonrot(sdkp->disk->queue);
>> +		}
>> +
>> +		if (stop_disk) {
>> +			sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
>> +			sd_start_stop_device(sdkp, 0);
>> +		}
>>  	}
>>  }
> 
> Is introduction of a new kernel module parameter essential?

It is system-dependent whether or not a reboot is going to result in a
loss of power, so it's required to be able to stop the HDDs too.

They're already always stopped on shutdown where power is definitely
going to be lost. I can't do that by default on a reboot because the
usual convention is that the power stays on during a reboot and it would
be expected that the HDDs keep spinning.

> Or in other
> words, has it been considered to apply the new behavior to all SSDs?

The default value is 1, so it does apply to all SSDs. I want to be able
to configure it to apply to HDDs too.

-- 
Simon Arlott
