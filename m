Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31DC2CDB47E
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Oct 2023 05:46:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbjJRFql (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Oct 2023 01:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjJRFqk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Oct 2023 01:46:40 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F65BA
        for <linux-scsi@vger.kernel.org>; Tue, 17 Oct 2023 22:46:37 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id CACAA67373; Wed, 18 Oct 2023 07:46:34 +0200 (CEST)
Date:   Wed, 18 Oct 2023 07:46:34 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 5/9] scsi: set host byte after EH completed
Message-ID: <20231018054634.GB17150@lst.de>
References: <20231016121542.111501-1-hare@suse.de> <20231016121542.111501-6-hare@suse.de> <20231017072529.GA11484@lst.de> <af6c6f63-aa40-4045-8079-0f8268d7314b@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af6c6f63-aa40-4045-8079-0f8268d7314b@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Oct 17, 2023 at 10:14:19AM +0200, Hannes Reinecke wrote:
>> What is the point of passing in the host_byte vs just setting it in
>> the caller?
>>
> Hmm. Sure, could do.
>
>> In fat I'm not even quite sure what the point of the existing helper
>> is, as moving the command to the passed in queue doesn't provide
>> much of a useful abstraction.
>>
> Share your sentiments.
> One could open-code it, but if I move the host_byte setting into the
> caller this function won't be touched at all.

Yes, I can rant about existing code, not just new code :)

> And it's time to clean up the entire list splice-and-dice game in
> SCSI EH once this rework is in; my plan is to move failed commands
> onto a per-entity list, and merge them onto the next higher entity
> list once an escalation fails.
>
> So maybe shelf it for now, and just open-code the host_byte setting
> in the caller.

Sounds good.
