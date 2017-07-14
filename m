From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [for-4.14 RFC PATCH 1/2] dm rq: avoid deadlock if dm-mq is
 stacked on old .request_fn device(s)
Date: Fri, 14 Jul 2017 13:17:53 -0400
Message-ID: <1500052673.10198.174.camel@localhost.localdomain>
References: <20170713211217.52361-1-snitzer@redhat.com>
         <20170713211217.52361-2-snitzer@redhat.com> <20170714072250.GC17046@lst.de>
         <20170714141929.GB18245@redhat.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44168 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753665AbdGNRSC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 14 Jul 2017 13:18:02 -0400
In-Reply-To: <20170714141929.GB18245@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, 2017-07-14 at 10:19 -0400, Mike Snitzer wrote:
> 
> Do you see a benefit to extracting that portion of your WIP patch
> (removing the ->complete handler entirely)?
> 
> Or leave well enough alone and just continue to disable dm-mq's ability
> to stack on .request_fn paths?
> 
> Given SCSI's switch to scsi-mq by default I cannot see value in propping
> up stacking on the old .request_fn devices.

So, the dm_mod.use_blk_mq flag is global, right?  I guess the question
is whether all of the block device types used on a system under DM are
supported under MQ.  If that is the case then we would be OK.

The other question is whether there are negative performance
consequences in any (corner?) cases with MQ that would result in it
being preferable to run in non-MQ mode (e.g. tag space with lpfc, did
we ever resolve that?) but the right approach there is to put the effort
into the MQ path going forward, as has been the case.

-Ewan
