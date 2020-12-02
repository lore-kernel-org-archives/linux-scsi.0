Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E91AC64E8A
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 12:04:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37FBC221FE
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 12:04:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729453AbgLBMEA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Dec 2020 07:04:00 -0500
Received: from mx2.suse.de ([195.135.220.15]:45838 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727100AbgLBMEA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 2 Dec 2020 07:04:00 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CF2A5AB63;
        Wed,  2 Dec 2020 12:03:18 +0000 (UTC)
Subject: Re: [PATCH 00/13] ibmvfc: initial MQ development
To:     Tyrel Datwyler <tyreld@linux.ibm.com>,
        james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com
References: <20201126014824.123831-1-tyreld@linux.ibm.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <90e9a8ac-d2b9-bb64-7c7d-607adaea0f26@suse.de>
Date:   Wed, 2 Dec 2020 13:03:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201126014824.123831-1-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/26/20 2:48 AM, Tyrel Datwyler wrote:
> Recent updates in pHyp Firmware and VIOS releases provide new infrastructure
> towards enabling Subordinate Command Response Queues (Sub-CRQs) such that each
> Sub-CRQ is a channel backed by an actual hardware queue in the FC stack on the
> partner VIOS. Sub-CRQs are registered with the firmware via hypercalls and then
> negotiated with the VIOS via new Management Datagrams (MADs) for channel setup.
> 
> This initial implementation adds the necessary Sub-CRQ framework and implements
> the new MADs for negotiating and assigning a set of Sub-CRQs to associated VIOS
> HW backed channels. The event pool and locking still leverages the legacy single
> queue implementation, and as such lock contention is problematic when increasing
> the number of queues. However, this initial work demonstrates a 1.2x factor
> increase in IOPs when configured with two HW queues despite lock contention.
> 
Why do you still hold the hold lock during submission?
An initial check on the submission code path didn't reveal anything 
obvious, so it _should_ be possible to drop the host lock there.
Or at least move it into the submission function itself to avoid lock 
contention. Hmm?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
