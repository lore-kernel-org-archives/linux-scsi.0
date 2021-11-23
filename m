Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C072C43217
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Nov 2021 08:13:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234696AbhKWIQX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Nov 2021 03:16:23 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:40964 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234531AbhKWIQV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Nov 2021 03:16:21 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 7901C218BB;
        Tue, 23 Nov 2021 08:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1637655192; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nF3cZaA+Zy5EwN4yhrnvHlGbHQAzDUiHxt7H5OQiTFw=;
        b=vdgOHY3LlG6MqiiPIaDRwXQddij1WkSrVBt/P8ubVzHZngtvAS6fJjgCVGzTVdlj5/hhXH
        TS8aBChOvOYQZrcsDg9o6aNkdovD4fvRdV2zVvqiGCgC/ckqLv+U5JDYEDUjvDwF2NIZOA
        05mPMYR1nXsr6C95jiNMJFNljyI9sWM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1637655192;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nF3cZaA+Zy5EwN4yhrnvHlGbHQAzDUiHxt7H5OQiTFw=;
        b=mUNzJijI4wFLzqg3vyGq+d5KwE1S/l+UPTgatranHTPd8/xUNWa/l6AQtudfEcod7vNJCM
        +7Q6U5+CwmKbHZCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6D1E113D2B;
        Tue, 23 Nov 2021 08:13:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id nLNpGpiinGGJcgAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 23 Nov 2021 08:13:12 +0000
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
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <0be5022e-bf3d-6e9f-22ee-9848265d2b82@suse.de>
Date:   Tue, 23 Nov 2021 09:13:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <24ce9815-c01d-9ad4-2221-5a5b041ee231@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/22/21 6:46 PM, Bart Van Assche wrote:
> On 11/22/21 12:58 AM, John Garry wrote:
>> On 19/11/2021 19:57, Bart Van Assche wrote:
>>> +/**
>>> + * scsi_get_internal_cmd - Allocate an internal SCSI command
>>> + * @q: request queue from which to allocate the command. This
>>> request queue may
>>> + *    but does not have to be associated with a SCSI device. This
>>> request
>>> + *    queue must be associated with a SCSI tag set. See also
>>> + *    scsi_mq_setup_tags().
>>> + * @data_direction: Data direction for the allocated command.
>>> + * @flags: Zero or more BLK_MQ_REQ_* flags.
>>> + *
>>> + * Allocates a request for driver-internal use. The tag of the
>>> returned SCSI
>>> + * command is guaranteed to be unique.
>>> + */
>>> +struct scsi_cmnd *scsi_get_internal_cmd(struct request_queue *q,
>>> +                    enum dma_data_direction data_direction,
>>> +                    blk_mq_req_flags_t flags)
>>
>> I'd pass the Scsi_Host or scsi_device rather than a request q, so maybe:
>>
>> struct scsi_cmnd *scsi_get_internal_cmd(struct scsi_device *sdev, ..)
>> struct scsi_cmnd *scsi_host_get_internal_cmd(struct Scsi_Host *shost, ..)
> 
> Passing a request queue pointer as first argument instead of a struct
> scsi_device is a deliberate choice. In the UFS driver (and probably also
> in other SCSI LLDs) we want to allocate internal requests without these
> requests being visible in any existing SCSI device statistics. Creating
> a new SCSI device for the allocation of internal requests is not a good
> choice because that new SCSI device would have to be assigned a LUN
> number and would be visible in sysfs. Hence the choice to allocate
> internal requests from a request queue that is not associated with any
> SCSI device.
> 
It's actually a bit more involved.

The biggest issue is that the SCSI layer is littered with the assumption
that there _will_ be a ->device pointer in struct scsi_cmnd.
If we make up a scsi_cmnd structure _without_ that we'll have to audit
the entire stack to ensure we're not tripping over a NULL device pointer.
And to make matters worse, we also need to audit the completion path in
the driver, which typically have the same 'issue'.

Case in point:

# git grep -- '->device' drivers/scsi | wc --lines
2712

Which was the primary reason for adding a stub device to the SCSI Host;
simply to avoid all the pointless churn and have a valid device for all
commands.

The only way I can see how to avoid getting dragged down into that
rat-hole is to _not_ returning a scsi_cmnd, but rather something else
entirely; that's the avenue I've exploited with my last patchset which
would just return a tag number.
But as there are drivers which really need a scsi_cmnd I can't se how we
can get away with not having a stub scsi_device for the scsi host.

And that won't even show up in sysfs if we assign it a LUN number beyond
the addressable range; 'max_id':0 tends to be a safe choice here.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
