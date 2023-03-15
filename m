Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E80DC7618A
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Mar 2023 13:31:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232428AbjCONbY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Mar 2023 09:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232318AbjCONbO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Mar 2023 09:31:14 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABECB1A955;
        Wed, 15 Mar 2023 06:30:47 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 65B0768B05; Wed, 15 Mar 2023 14:30:40 +0100 (CET)
Date:   Wed, 15 Mar 2023 14:30:39 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Stefan Haberland <sth@linux.ibm.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Mike Christie <michael.christie@oracle.com>,
        bvanassche@acm.org, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org,
        Jan Hoeppner <hoeppner@linux.ibm.com>
Subject: Re: [PATCH v4 02/18] block: Rename BLK_STS_NEXUS to
 BLK_STS_RESV_CONFLICT
Message-ID: <20230315133039.GA24533@lst.de>
References: <20230224174502.321490-1-michael.christie@oracle.com> <20230224174502.321490-3-michael.christie@oracle.com> <20230314171119.GB6780@lst.de> <33ed9615-b570-03c7-9a7a-d07f020d3222@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33ed9615-b570-03c7-9a7a-d07f020d3222@linux.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Mar 15, 2023 at 11:04:22AM +0100, Stefan Haberland wrote:
> This also fits for the DASD case. We use this error code for a
> reservation/locking conflict of the DASD device when the lock we
> previously held was stolen.

But that's not really a reservation conflict in the sense
of the reservation API.  Given that DASD doesn't support it it
might not matter.  Do you have applications that checks for
the translated errno value?  We'll probably at least want
a comment documenting this status code.
