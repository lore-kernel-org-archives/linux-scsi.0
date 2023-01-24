Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE9A5C54E94
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Jan 2023 20:00:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233827AbjAXUAC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Jan 2023 15:00:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234307AbjAXT7y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jan 2023 14:59:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0139C6EAE;
        Tue, 24 Jan 2023 11:59:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4EEB9B81104;
        Tue, 24 Jan 2023 19:59:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CA6EC433EF;
        Tue, 24 Jan 2023 19:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674590391;
        bh=HUTNlf3awUxb4xjGbfxSzTxnxTEgouf/7bEFKmPdPAU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=li6XUs3zD2rFhwIkqnDthuFyOA3VSqkHL6ZIAbehxLn5BvhmjppV3K4PXOV1okhZw
         pBzYe4fG+LL/z6XcgLQ3fMJPKJLcm9l9oASHS1JbQrVfRilgPwZOWw2K+cjx7p0kAf
         yKb31UIsgzYyRPrr2EKHbcEK0dOrFAbcG6dDZufmF1b7hg8hccLBmyQ0+IvpbA4AbK
         egz8DmBqxZ4hAqZnrTuPg6WMSeR0QCz0qIBWC6Dbsqo7VtFX0qYhZqbzFPgAiCP3So
         dnPEqJSE1Kn0M+gaZ9j4eh3mQ1xHQlwD5XdV8VrE/X0heIUlIPoQ6Pc5XY+aT0dq7q
         Rg6coENugwGDg==
Date:   Tue, 24 Jan 2023 12:59:47 -0700
From:   Keith Busch <kbusch@kernel.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: Re: [PATCH v3 02/18] block: introduce BLK_STS_DURATION_LIMIT
Message-ID: <Y9A4s5tlsdx0S8s4@kbusch-mbp.dhcp.thefacebook.com>
References: <20230124190308.127318-1-niklas.cassel@wdc.com>
 <20230124190308.127318-3-niklas.cassel@wdc.com>
 <517c119a-38cf-2600-0443-9bda93e03f32@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <517c119a-38cf-2600-0443-9bda93e03f32@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jan 24, 2023 at 11:29:10AM -0800, Bart Van Assche wrote:
> On 1/24/23 11:02, Niklas Cassel wrote:
> > Introduce the new block IO status BLK_STS_DURATION_LIMIT for LLDDs to
> > report command that failed due to a command duration limit being
> > exceeded. This new status is mapped to the ETIME error code to allow
> > users to differentiate "soft" duration limit failures from other more
> > serious hardware related errors.
> 
> What makes exceeding the duration limit different from an I/O timeout
> (BLK_STS_TIMEOUT)? Why is it important to tell the difference between an I/O
> timeout and exceeding the command duration limit?

BLK_STS_TIMEOUT should be used if the target device doesn't provide any
response to the command. The DURATION_LIMIT status is used when the device
completes a command with that status.
