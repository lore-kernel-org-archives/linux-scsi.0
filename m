Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95700CDB474
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Oct 2023 06:17:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbjJPGRn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Oct 2023 02:17:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjJPGRn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Oct 2023 02:17:43 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71204DC;
        Sun, 15 Oct 2023 23:17:41 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 834726732A; Mon, 16 Oct 2023 08:17:37 +0200 (CEST)
Date:   Mon, 16 Oct 2023 08:17:37 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        Avri Altman <Avri.Altman@wdc.com>,
        Bean Huo <huobean@gmail.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 03/15] block: Support data lifetime in the I/O
 priority bitfield
Message-ID: <20231016061737.GA26670@lst.de>
References: <20231005194129.1882245-1-bvanassche@acm.org> <20231005194129.1882245-4-bvanassche@acm.org> <8aec03bb-4cef-9423-0ce4-c10d060afce4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8aec03bb-4cef-9423-0ce4-c10d060afce4@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Oct 06, 2023 at 05:19:52PM +0900, Damien Le Moal wrote:
> Your change seem to assume that it makes sense to be able to combine CDL with
> lifetime hints. But does it really ? 

Yes, it does.


> CDL is of dubious value for solid state
> media and as far as I know,

No, it's pretty useful and I'd bet my 2 cents that it will eventually
show up in relevant standards and devices.

Even if it wasn't making our user interfaces exclusive would be a
massive pain.

> The other question here if you really want to keep the bit separation approach
> is: do we really need up to 64 different lifetime hints ? While the scsi
> standard allows that much, does this many different lifetime make sense in
> practice ? Can we ever think of a usecase that needs more than say 8 different
> liftimes (3 bits) ? If you limit the number of possible lifetime hints to 8,
> then we can keep 4 bits unused in the hint field for future features.

Yes, I think this is the smoking gun.  We should be fine with a much
more limited number of lifetime hints, i.e. the user interface only
exposes 5 hints, and supporting more in the in-kernel interfaces seems
of rather doubtfuŀ use.
