Return-Path: <SRS0=Lz4Y=DB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F3DFC4363D
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Sep 2020 10:42:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0900E23772
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Sep 2020 10:42:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbgIXKmo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Sep 2020 06:42:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:48252 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726615AbgIXKmo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 24 Sep 2020 06:42:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 28507B117;
        Thu, 24 Sep 2020 10:43:21 +0000 (UTC)
Subject: Re: [PATCH 1/1] scsi: scsi_dh_alua: do not set h->sdev to NULL before
 removing the list entry
To:     Brian Bunker <brian@purestorage.com>
Cc:     "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
References: <8239CB66-1836-444D-A230-83714795D5DC@purestorage.com>
 <3b86ce755e3b0b2b3d9e1a2cdf8c48b742f94265.camel@redhat.com>
 <D047536E-9A0E-430D-BD0C-634DC7594033@purestorage.com>
 <be7e6061-5b10-25a7-e8bb-aa4008c04e22@suse.de>
 <F861B128-F3AC-4928-9B9C-14DE921F70FD@purestorage.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <ec422868-3c9d-f9de-5bed-14e9d6093ebb@suse.de>
Date:   Thu, 24 Sep 2020 12:42:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <F861B128-F3AC-4928-9B9C-14DE921F70FD@purestorage.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/24/20 12:21 AM, Brian Bunker wrote:
> We have tried with our patch here and it works. We have not tried with our patch at the
> customer site where they hit the crash. Since they hit the BUG_ON line which we
> can see in the logs we have, we expect that removing the race as we did
> would avoid the crash. We also remove the BUG_ON’s in our patch so it can’t hit
> the same crash. If there is another similar race a null pointer deference could still
> happen in our patch. I saw you had a patch to only use the value if the pointer is not
> null. That would also work to stop the crash, but it would hide the race where the
> BUG_ON was helpful in finding it.
> 
> Trying our fix at the customer site for us would be more difficult since the operating
> system crash belongs to Oracle. That is why you see their patch for the same
> issue. Our interest in getting this fixed goes beyond this customer since more
> Linux vendors as they move forward in kernel version inherit this code, and
> we are reliant on ALUA. We hope to catch it here.
> 
> Should I put together a patch with the h->sdev set to null removed from the
> detach function along the syncrhronize_rcu and removing the BUG_ON, or
> did you want me to diff against your checkin where you have already removed
> the BUG_ON?
> 
No need, I already sent a patch attached to another mail to the oracle 
folks.
Guess I'll be sending an 'official' patch now, seeing that I have 
confirmation.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
