Return-Path: <SRS0=SJ7r=DA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBD44C4363D
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Sep 2020 07:41:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C45F235FD
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Sep 2020 07:41:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgIWHlg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Sep 2020 03:41:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:51718 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726557AbgIWHlf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Sep 2020 03:41:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id F31D7AE0D;
        Wed, 23 Sep 2020 07:42:11 +0000 (UTC)
Subject: Re: [PATCH 1/1] scsi: scsi_dh_alua: remove the list entry before
 assigning the pointer and sdev to NULL
To:     Brian Bunker <brian@purestorage.com>,
        "Ewan D. Milne" <emilne@redhat.com>
Cc:     linux-scsi@vger.kernel.org
References: <4064EB40-C84F-42E8-82F7-3940901C09D2@purestorage.com>
 <adbb27fcbe0a534a9f19f4ff624f05dbf2a1a193.camel@redhat.com>
 <1D8474C3-6D04-4C0F-B23C-A2924CD5436A@purestorage.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <cc003a85-51ea-46b6-4657-440656f632c2@suse.de>
Date:   Wed, 23 Sep 2020 09:41:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <1D8474C3-6D04-4C0F-B23C-A2924CD5436A@purestorage.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/11/20 5:47 PM, Brian Bunker wrote:
> To me just removing the h->sdev = NULL seems strange because then this
> looks strange to me:
> 
> pg = rcu_dereference_protected(h->pg, lockdep_is_held(&h->pg_lock));
> rcu_assign_pointer(h->pg, NULL);
> 
> Then saying
> If (pg)
> 
> Since we just assigned that pointer, h->pg to NULL.
> 

True, but the 'rcu_dereference()' call is just ensuring 'alua_dh_data' 
is valid, not the contents of which.
So to be absolutely correctly we would need to take 'h->lock' when 
evaluating 'h->sdev'; but then this is an optimisation anyway we might 
as well kill the BUG_ON() and replace it by a simple 'if' condition.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
