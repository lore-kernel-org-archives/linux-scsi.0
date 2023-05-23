Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19074C7EE29
	for <linux-scsi@archiver.kernel.org>; Tue, 23 May 2023 10:08:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236192AbjEWKId (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 May 2023 06:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232871AbjEWKIc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 May 2023 06:08:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4893BFA;
        Tue, 23 May 2023 03:08:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D85A7609AE;
        Tue, 23 May 2023 10:08:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 122AAC433EF;
        Tue, 23 May 2023 10:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684836510;
        bh=D3l0vlRfmlGlM4dfcP9O1kQ16yD7pSyIfio5CoFpRyI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=UP/WTuoe3Dv4m6Hgxg+LP62R3MdNQvmTxu2IY5MwOvHQjNjUFb1M01cGGzl79oiP6
         KgEuAq8/2ikAIZosRTlvvA8momVAjxrMO53S08RnB3zaSsJ/gzTBOoTBLGU1MRMEQZ
         Pxmo5/0z2Q/wxQxuhz6CQVG3X5pV5pRDy7kpZCc1u8VXs+VYeoIAW7j7cC38gIVa3c
         AQX+Fbrl7NW5XKLqgjGv8EC0ydq9una0T3v8SYjPm56LIDHc8diGXCNSUw8O6JW43s
         rESMBLeiRqU8LfJpafoDjV7ASDPScCDi/MApVZJn3qFpBzZtutNsw7LcYaHHqPb8U+
         75uvF6R0eqzAw==
Message-ID: <09f5d62b-1bd4-3a25-e178-2225f1c7b603@kernel.org>
Date:   Tue, 23 May 2023 19:08:27 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v7 00/19] Add Command Duration Limits support
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Niklas Cassel <nks@flawful.org>, Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
References: <20230511011356.227789-1-nks@flawful.org>
 <yq1h6s4nix8.fsf@ca-mkp.ca.oracle.com> <ZGyN1KkCXsTo8ZwG@x1-carbon>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <ZGyN1KkCXsTo8ZwG@x1-carbon>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/23/23 18:56, Niklas Cassel wrote:
> On Mon, May 22, 2023 at 05:41:19PM -0400, Martin K. Petersen wrote:
>>
>> Niklas,
>>
>>> This series adds support for Command Duration Limits.
>>
>> Applied to 6.5/scsi-staging, thanks!
> 
> Thank you Martin!
> 
> 
> Damien, Martin,
> considering that the libata changes depend on the scsi changes,
> and considering that further libata EH cleanups are planned for
> 6.5 now when the IPR driver is gone, I think that the best move
> is to follow the advice of:
> https://docs.kernel.org/maintainer/rebasing-and-merging.html#merging-from-sibling-or-upstream-trees

Hannes cleanup of EH will create a conflict with the scsi tree but can go in
through the ata tree independently so I was not planning on doing a rebase,
especially not on the scsi tree. I will notify Stephen about the conflict send
him a resolution to apply and carry for linux-next. When the 6.5 merge window
open, I will wait for the James to send the scsi PR and send my PR to Linus
after that with the conflict resolution, as usual.

So far, I do not see any big issue with that.

> 
> Specifically:
> "Merging another subsystem tree to resolve a dependency risks bringing in
> other bugs and should almost never be done. If that subsystem tree fails
> to be pulled upstream, whatever problems it had will block the merging of
> your tree as well.
> Preferable alternatives include agreeing with the maintainer to carry both
> sets of changes in one of the trees or creating a topic branch dedicated
> to the prerequisite commits that can be merged into both trees."
> 
> 
> 
> Martin created a topic branch/SHA1 for the CDL series:
> 18bd7718b5c489b3161b6c2ab4685d57c1e2da3b
> in order for him to be able to have a nice merge commit:
> https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/commit/?h=6.5/scsi-staging&id=8b60e2189fcd8b10b592608256eb97aebfcff147
> 
> So, I suggest that, after this has been applied to
> 6.5/scsi-queue (right now it is only in 6.5/scsi-staging),
> that Damien merges the same topic branch/SHA1:
> 18bd7718b5c489b3161b6c2ab4685d57c1e2da3b
> to libata/for-6.5.
> 
> Perhaps the fix:
> https://lore.kernel.org/linux-scsi/20230523074701.293502-1-dlemoal@kernel.org/T/#u
> could be applied on top of that SHA1, or folded in,
> the important thing is that libata merges the exact same SHA1
> for the CDL series as scsi-queue.
> (Especially since I noticed that Martin did some minor changes to
> the ioprio hints patch, namely changed IO to I/O in the comments
> describing the macros, so Damien can't just take the patches from
> the list as is, as that would create conflicts for Linus when he
> merges the two different subsystem trees.)
> 
> 
> Kind regards,
> Niklas

-- 
Damien Le Moal
Western Digital Research

