Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 400D5C7619A
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Apr 2023 07:39:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbjDKHjD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Apr 2023 03:39:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbjDKHi7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Apr 2023 03:38:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73EE82D41;
        Tue, 11 Apr 2023 00:38:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00F7261B8F;
        Tue, 11 Apr 2023 07:38:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E56F5C433EF;
        Tue, 11 Apr 2023 07:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681198731;
        bh=Q4fKryPjj9qqEQQndwgzZuKHlqPkkoyBO384bI+AygE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=oeLKPteqDP1/Z4PlYbSUIFHnYJij79vSPMgN/oZw+90zqkZKN6VY66h68MAI/HRg0
         PBb0WTwvovIaLBqRtefXpg663cHyNG5vspB9DEWbBd7ev0IEZNmJSAUHUkByjEM00J
         w7AELIqagokdK60Re8d8bQptWxVkmzqb1KibeDUgpI+xxQmdIUAFFrV3qx3LukG5Ai
         1axl4fB2CVJEtTIb2T65fpT1kAF8PkIDdx/6ngOEpzHyy1QIQDDpn5ckgSWrEhs7Oe
         IUTt8wuqbON/IGNXegih1T/ZaxzbeifQHCeGuOsjjx+6L9uv9KvCQzzeyWHonzv+/3
         onRhF0sCJPRlg==
Message-ID: <15ad7cf9-e385-9cea-964a-4a2eac35385c@kernel.org>
Date:   Tue, 11 Apr 2023 16:38:48 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v6 09/19] scsi: allow enabling and disabling command
 duration limits
To:     Christoph Hellwig <hch@lst.de>
Cc:     Niklas Cassel <nks@flawful.org>, Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-block@vger.kernel.org
References: <20230406113252.41211-1-nks@flawful.org>
 <20230406113252.41211-10-nks@flawful.org> <20230411061648.GD18719@lst.de>
 <e9cf65ce-e1f0-4d99-31e7-75b8e88e2a89@kernel.org>
 <20230411072317.GA22683@lst.de>
Content-Language: en-US
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20230411072317.GA22683@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/11/23 16:23, Christoph Hellwig wrote:
> On Tue, Apr 11, 2023 at 04:09:34PM +0900, Damien Le Moal wrote:
>> But yes, I guess we could just unconditionally enable CDL for ATA on device scan
>> to be on par with scsi, which has CDL always enabled.
> 
> I'd prefer that.  With a module option to not enable it just to be
> safe.

Then it may be better to move the cdl_enable attribute store definition for ATA
devices to libata. That would be less messy that way. Let me see if that can be
done cleanly.
