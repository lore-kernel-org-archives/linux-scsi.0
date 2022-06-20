Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CA40C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jun 2022 07:12:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239141AbiFTHMj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jun 2022 03:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238956AbiFTHMe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jun 2022 03:12:34 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40751DFFE;
        Mon, 20 Jun 2022 00:12:33 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8F79668AA6; Mon, 20 Jun 2022 09:12:29 +0200 (CEST)
Date:   Mon, 20 Jun 2022 09:12:29 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
        dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-nvme@lists.infradead.org
Subject: Re: [PATCH 0/8] Use block pr_ops in LIO
Message-ID: <20220620071229.GB11418@lst.de>
References: <20220603065536.5641-1-michael.christie@oracle.com> <20220603114645.GA14309@lst.de> <2634b3ae-f63d-c711-36cd-bf8f56ecc43b@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2634b3ae-f63d-c711-36cd-bf8f56ecc43b@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jun 03, 2022 at 12:55:33PM -0500, Mike Christie wrote:
> However, for nvme and for the interface we want to provide to userspace,
> do we want to implement an interface like READ_FULL_STATUS and report
> reservations where we report the host/controller/port info? If so, below
> is a patch I started.

If we wire the ops up to the nvme target we'd need that.  But for now
I think the more useful case would be to use nvme as the underlying
devices for the scsi target that already has all the PR infrastructure
and helps to validate the interface.

> Notes:
> 1. I hit some issues with SCSI targets not reporting the IDs sometimes or
> sometimes they report it incorrectly. For nvme, it seems easier. SCSI has 
> to handle a hand full of ways to report the ID where nvme has 2 ways to
> do the host ID.

Yeah.

> 2. I couldn't find a nvme device to test. Qemu and nvmet don't seem to
> support reservations.

Basically any dual ported PCIe SSD should support them, typically those
are the U.2 format factor ones found in servers or enclosures.
