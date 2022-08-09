Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E5CCC19F2D
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Aug 2022 07:16:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235985AbiHIHQi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Aug 2022 03:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233045AbiHIHQi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Aug 2022 03:16:38 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAD7A20BC1;
        Tue,  9 Aug 2022 00:16:36 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id A29FD68AA6; Tue,  9 Aug 2022 09:16:32 +0200 (CEST)
Date:   Tue, 9 Aug 2022 09:16:32 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     bvanassche@acm.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
        hch@lst.de, linux-nvme@lists.infradead.org,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: Re: [PATCH v2 14/20] scsi: Retry pr_ops commands if a UA is
 returned.
Message-ID: <20220809071632.GA11161@lst.de>
References: <20220809000419.10674-1-michael.christie@oracle.com> <20220809000419.10674-15-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809000419.10674-15-michael.christie@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Aug 08, 2022 at 07:04:13PM -0500, Mike Christie wrote:
> It's common to get a UA when doing PR commands. It could be due to a
> target restarting, transport level relogin or other PR commands like a
> release causing it. The upper layers don't get the sense and in some cases
> have no idea if it's a SCSI device, so this has the sd layer retry.

This seems like another case for the generic in-kernel passthrugh
command retry discussed in the other thread.

Can you split out two series with just bug fixes for nvme and scsi
as I think we should probably get those into 6.0, and then we can
do the actual feature on top of those?
