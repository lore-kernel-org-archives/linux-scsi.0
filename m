Return-Path: <SRS0=HQac=AN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17677C433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 15:14:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1C99206B7
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 15:14:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730013AbgGBPO5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jul 2020 11:14:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:46442 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729210AbgGBPO5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 2 Jul 2020 11:14:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id F155AB18A;
        Thu,  2 Jul 2020 15:14:53 +0000 (UTC)
Subject: Re: [PATCH] scsi: allow state transitions BLOCK -> BLOCK
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org
References: <20200702142436.98336-1-hare@suse.de>
 <1593700443.9652.2.camel@HansenPartnership.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <0c1ce7fc-98ba-0a14-d1a7-889bf1ce794f@suse.de>
Date:   Thu, 2 Jul 2020 17:14:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <1593700443.9652.2.camel@HansenPartnership.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/2/20 4:34 PM, James Bottomley wrote:
> On Thu, 2020-07-02 at 16:24 +0200, Hannes Reinecke wrote:
>> scsi_transport_srp.c will call scsi_target_block() repeatedly
>> without calling scsi_target_unblock() first.
>> So allow the idempotent state transition BLOCK -> BLOCK to avoid
>> a warning here.
> 
> That really doesn't sound like a good idea.  Block and unblock should
> be matched pairs and since you don't have a running->running transition
> allowed this implies that srp calls block many times but unblock only
> once.  It really sounds like srp needs fixing.
> 
That was what I was planning first, but then SRP has a weird mix of 
states, calling scsi_target_block()/scsi_target_unblock() on all sorts 
of places.
Bart?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
