Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72C3FC77B7A
	for <linux-scsi@archiver.kernel.org>; Thu, 18 May 2023 11:37:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbjERLhR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 May 2023 07:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231357AbjERLgk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 May 2023 07:36:40 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FBEE268A
        for <linux-scsi@vger.kernel.org>; Thu, 18 May 2023 04:36:30 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 9F86E1F893;
        Thu, 18 May 2023 11:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1684409788; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HdykVMioFYYFkBYc2vtuY1KkL9ZWwCDxO65eEy12Pcs=;
        b=zUaOcPeSCeEVYCnfalluWtGGrY4+95LhOVy+HUQi+l4M856SoIS+IIc02VU0mf2snhBkji
        KD9qAN2ONxd3lCRMPKuX/9Uj6nHfawRNSrNJVtcqsbT5QYFNJT6xNcHyAfUAtlDzeLQF6l
        d9X/9r5Hs62mPRrptDv2dMVhluSdlWU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1684409788;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HdykVMioFYYFkBYc2vtuY1KkL9ZWwCDxO65eEy12Pcs=;
        b=mcK3PSqW8imimGEgYcuNXhtF6CksLHltF5/wW58a2OxVhuYXGBh4ypwUWDTIA0K99ErAUF
        vK/FqreRRXHIUrDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 58154138F5;
        Thu, 18 May 2023 11:36:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id IDVyFLwNZmSVEAAAMHmgww
        (envelope-from <hare@suse.de>); Thu, 18 May 2023 11:36:28 +0000
Message-ID: <78a6a813-95a1-66f2-35e2-00d87381ff2a@suse.de>
Date:   Thu, 18 May 2023 13:36:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH v3 4/4] scsi: core: Delay running the queue if the host is
 blocked
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>,
        Mike Christie <michael.christie@oracle.com>
References: <20230517230927.1091124-1-bvanassche@acm.org>
 <20230517230927.1091124-5-bvanassche@acm.org>
 <ZGV8YfsLYIR2H21/@ovpn-8-16.pek2.redhat.com>
 <07c13761-7f71-3281-fff7-60ec196759c5@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <07c13761-7f71-3281-fff7-60ec196759c5@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/18/23 04:34, Bart Van Assche wrote:
> On 5/17/23 18:16, Ming Lei wrote:
>> On Wed, May 17, 2023 at 04:09:27PM -0700, Bart Van Assche wrote:
>>> @@ -1767,7 +1767,7 @@ static blk_status_t scsi_queue_rq(struct 
>>> blk_mq_hw_ctx *hctx,
>>>           break;
>>>       case BLK_STS_RESOURCE:
>>>       case BLK_STS_ZONE_RESOURCE:
>>> -        if (scsi_device_blocked(sdev))
>>> +        if (scsi_device_blocked(sdev) || shost->host_self_blocked)
>>>               ret = BLK_STS_DEV_RESOURCE;
>>
>> What if scsi_unblock_requests() is just called after the above check and
>> before returning to block layer core? Then this request is invisible to
>> scsi_run_host_queues()<-scsi_unblock_requests(), and io hang happens.
> 
> If returning BLK_STS_DEV_RESOURCE could cause an I/O hang, wouldn't that 
> be a bug in the block layer core? Isn't the block layer core expected to 
> rerun the queue after a delay if a block driver returns 
> BLK_STS_DEV_RESOURCE? See also blk_mq_dispatch_rq_list().
> 
DEV_RESOURCE is a tricky thing; it actually implies that the _device_ is 
blocked, and no further I/O is possible.
And it's actually the responsibility of the device/driver to kick the 
queue again once the contention/block/whatever is done.
So no, the block layer should not do anything here, relying on the 
driver to do something.

Which is why returning DEV_RESOURCE is not recommended, seeing that it's 
easy to get it wrong...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

