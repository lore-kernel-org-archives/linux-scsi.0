Return-Path: <SRS0=mj/2=4O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96991C4BA24
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Feb 2020 22:28:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69FC824653
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Feb 2020 22:28:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727757AbgBZW2J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Feb 2020 17:28:09 -0500
Received: from mx2.suse.de ([195.135.220.15]:50188 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727740AbgBZW2J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Feb 2020 17:28:09 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7504DB15B;
        Wed, 26 Feb 2020 22:28:07 +0000 (UTC)
Subject: Re: [PATCH 10/13] scsi: add scsi_host_busy_iter()
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20200213140422.128382-1-hare@suse.de>
 <20200213140422.128382-11-hare@suse.de> <20200226174501.GG23141@lst.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <7027c6c5-e6a3-5670-b841-063225cf2912@suse.de>
Date:   Wed, 26 Feb 2020 23:28:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200226174501.GG23141@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/26/20 6:45 PM, Christoph Hellwig wrote:
>> +/**
>> + * scsi_host_busy_iter - Iterate over all busy commands
>> + * @shost:	Pointer to Scsi_Host.
>> + * @fn:		Function to call on each busy command
>> + * @priv:	Data pointer passed to @fn
>> + **/
> 
> Can you add the context information from the commit log to the kerneldoc
> comment her?
> 
Yes.

>> +typedef bool (scsi_host_busy_iter_fn)(struct scsi_cmnd *, void *, bool);
> 
> Is there much of a point in having this typedef?
> 
Hmm. Idea was to save typing, but as it's being used only once I'll drop
it for the next round.

>> +
>> +void scsi_host_busy_iter(struct Scsi_Host *,
>> +			 scsi_host_busy_iter_fn *fn, void *priv);
> 
> Any reason to spell out to argument names, but not the third one?
> 
Probably not. Will be fixing it up.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
