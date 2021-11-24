Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0308C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Nov 2021 06:33:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235270AbhKXGg3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Nov 2021 01:36:29 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:56706 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbhKXGg2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Nov 2021 01:36:28 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 3C0791FD2F;
        Wed, 24 Nov 2021 06:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1637735598; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fdQKBkcCqB612mejiwZus0NwSsAGjyVyWJB8rbQT0I8=;
        b=F5obHFFJKLPxkTvEK8rJ0AXxJjbi4duk3wCnnH676aXFtoyxUqhsAzz1FSKf2ep/OPiuoK
        86nYT+Fxai/CQt2xdF7k3MUc1zrbtizqXPFfaTR73P+7Lt6Pv+ySEwGuuoltb/5iibDxMv
        Y3p1x7Vz42daJzuklhVcp//udjovRV8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1637735598;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fdQKBkcCqB612mejiwZus0NwSsAGjyVyWJB8rbQT0I8=;
        b=InTrHQgzSv277ldS07vandTv8nOCE+ArNPVmxGVs5yPhS1zgTq+TjlwKLDm0NYQSMVad32
        XNzAhc1oiFEZteAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1DBEB13EC2;
        Wed, 24 Nov 2021 06:33:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id OpsxBq7cnWHQfQAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 24 Nov 2021 06:33:18 +0000
Subject: Re: [PATCH v2 05/20] scsi: core: Add support for internal commands
To:     Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20211119195743.2817-1-bvanassche@acm.org>
 <20211119195743.2817-6-bvanassche@acm.org>
 <d396a5ed-763e-de79-1714-b4e58e812c7f@huawei.com>
 <24ce9815-c01d-9ad4-2221-5a5b041ee231@acm.org>
 <0be5022e-bf3d-6e9f-22ee-9848265d2b82@suse.de>
 <140badd9-7ee0-73c8-9563-07761ab17753@acm.org>
 <64e961f1-f4c4-655a-82af-60d75ab35f7a@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <f0e13859-c9f6-bd7c-4da2-9d11a2268a6d@suse.de>
Date:   Wed, 24 Nov 2021 07:33:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <64e961f1-f4c4-655a-82af-60d75ab35f7a@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/23/21 8:18 PM, Bart Van Assche wrote:
> On 11/23/21 9:46 AM, Bart Van Assche wrote:
>> On 11/23/21 12:13 AM, Hannes Reinecke wrote:
>>> It's actually a bit more involved.
>>>
>>> The biggest issue is that the SCSI layer is littered with the assumption
>>> that there _will_ be a ->device pointer in struct scsi_cmnd.
>>> If we make up a scsi_cmnd structure _without_ that we'll have to audit
>>> the entire stack to ensure we're not tripping over a NULL device 
>>> pointer.
>>> And to make matters worse, we also need to audit the completion path in
>>> the driver, which typically have the same 'issue'.
>>>
>>> Case in point:
>>>
>>> # git grep -- '->device' drivers/scsi | wc --lines
>>> 2712
>>>
>>> Which was the primary reason for adding a stub device to the SCSI Host;
>>> simply to avoid all the pointless churn and have a valid device for all
>>> commands.
>>>
>>> The only way I can see how to avoid getting dragged down into that
>>> rat-hole is to _not_ returning a scsi_cmnd, but rather something else
>>> entirely; that's the avenue I've exploited with my last patchset which
>>> would just return a tag number.
>>> But as there are drivers which really need a scsi_cmnd I can't se how we
>>> can get away with not having a stub scsi_device for the scsi host.
>>>
>>> And that won't even show up in sysfs if we assign it a LUN number beyond
>>> the addressable range; 'max_id':0 tends to be a safe choice here.
>>
>> There is no risk that the scsi_cmnd.device member will be dereferenced 
>> for
>> internal requests allocated by the UFS driver. But I understand from your
>> email that making sure that the scsi_cmnd.device member is not NULL is
>> important for other SCSI LLDs. I will look into the approach of 
>> associating
>> a stub SCSI device with internal requests.
> 
> (replying to my own email)
> 
> Hi Hannes,
> 
> Allocating a struct scsi_device for internal requests seems tricky to 
> me. The
> most straightforward approach would be to call scsi_alloc_sdev(). 
> However, that
> function accepts a scsi_target pointer and calls .slave_alloc(). So a
> scsi_target structure would have to be set up before that function is 
> called and
> SCSI LLDs would have to be audited to verify that .slave_alloc() works 
> fine for
> the H:C:I:L tuple assigned to the fake SCSI device. Additionally, how 
> should the
> inquiry data be initialized that is filled in by scsi_add_lun()?
> 
> Since I do not use SCSI hardware that needs a scsi_device to be 
> associated with
> internal requests, I prefer that this functionality is implemented in a 
> future
> patch series. Changing the hba->host->internal_queue occurrences in the UFS
> driver into something like hba->host->internal_sdev->request_queue once 
> this
> functionality is implemented should be easy.
> 
Well, I still do have the patchset for implementing it.
Will be reposting it.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
