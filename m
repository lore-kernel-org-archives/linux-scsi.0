Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50281C7EE29
	for <linux-scsi@archiver.kernel.org>; Tue, 23 May 2023 10:53:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236391AbjEWKx6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 May 2023 06:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232091AbjEWKx5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 May 2023 06:53:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5876B121;
        Tue, 23 May 2023 03:53:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D598060F77;
        Tue, 23 May 2023 10:53:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF92BC433D2;
        Tue, 23 May 2023 10:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684839235;
        bh=pQ96aHXywFyqqMHQEBK3XeZ6UVAHJ7zdPWunfjlTFEk=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=fjKcA+zeLT719eqkmVP9ciA5C05rv5RqgjajWEt/PTV9964mXggZq7TydOPOW01Mo
         FobpPzZwhUq5fW4q3u2AOJzci7RDfNAz5tOY/rDry3WYrmnPLvYwnIEz90KA8oB2Hd
         0vMSLqFS9mA/Q+zujshHOt5C16uvVv2lgkGCG7ZAPWQ7bcMU9MYh38GFj8hXeLpD89
         UTudM8dadOGN3gP5mHWJOLliG7UX3/zDEAfKFh1z0dIZtwifM/HTIOdvzgqdYvhVtr
         p1BlzLGpxo2uuEx5sCenj5IbOgEKT8IkWv+dcORMCcxbSZGhr2uDCNJFZc0pEzv0G5
         sGD8vccANbEnQ==
Message-ID: <f0b7dcf8-812d-5a2d-986b-5fa5b6b5a236@kernel.org>
Date:   Tue, 23 May 2023 19:53:53 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v7 00/19] Add Command Duration Limits support
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Niklas Cassel <nks@flawful.org>, Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
References: <20230511011356.227789-1-nks@flawful.org>
 <yq1h6s4nix8.fsf@ca-mkp.ca.oracle.com> <ZGyN1KkCXsTo8ZwG@x1-carbon>
 <09f5d62b-1bd4-3a25-e178-2225f1c7b603@kernel.org>
 <ZGyW54tCwesk7IXu@x1-carbon>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <ZGyW54tCwesk7IXu@x1-carbon>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/23/23 19:35, Niklas Cassel wrote:
> On Tue, May 23, 2023 at 07:08:27PM +0900, Damien Le Moal wrote:
>> On 5/23/23 18:56, Niklas Cassel wrote:
>>> On Mon, May 22, 2023 at 05:41:19PM -0400, Martin K. Petersen wrote:
>>>>
>>>> Niklas,
>>>>
>>>>> This series adds support for Command Duration Limits.
>>>>
>>>> Applied to 6.5/scsi-staging, thanks!
>>>
>>> Thank you Martin!
>>>
>>>
>>> Damien, Martin,
>>> considering that the libata changes depend on the scsi changes,
>>> and considering that further libata EH cleanups are planned for
>>> 6.5 now when the IPR driver is gone, I think that the best move
>>> is to follow the advice of:
>>> https://docs.kernel.org/maintainer/rebasing-and-merging.html#merging-from-sibling-or-upstream-trees
>>
>> Hannes cleanup of EH will create a conflict with the scsi tree but can go in
>> through the ata tree independently so I was not planning on doing a rebase,
>> especially not on the scsi tree. I will notify Stephen about the conflict send
>> him a resolution to apply and carry for linux-next. When the 6.5 merge window
>> open, I will wait for the James to send the scsi PR and send my PR to Linus
>> after that with the conflict resolution, as usual.
> 
> I wasn't suggesting that you do a rebase on the scsi tree, I was
> suggesting for a topic branch to be merged through both trees.
> 
> But I was just thinking how to make it as easy as possible to
> handle additional libata patches that should go on top of the
> CDL series (without creating conflicts for Stephen and Linus).
> 
>>
>> So far, I do not see any big issue with that.
> 
> If you think that the conflicts will be trivial, feel free to
> ignore my suggestion :)

So far, the conflicts do not look bad at all. So we should be fine. Will adapt
if needed.

> 
> 
> Kind regards,
> Niklas

-- 
Damien Le Moal
Western Digital Research

