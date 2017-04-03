From: Arun Easi <arun.easi@cavium.com>
Subject: Re: scsi-mq - tag# and can_queue, performance.
Date: Mon, 3 Apr 2017 09:41:00 -0700 (PDT)
Message-ID: <alpine.LRH.2.00.1704030931320.727@mvluser05.qlc.com>
References: <alpine.LRH.2.00.1704022326190.727@mvluser05.qlc.com>  <3fd1ca57-3b0a-9405-0ec8-3be15ba33caf@suse.de> <1491232832.2661.1.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="487202828-762993377-1491237669=:727"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0046.outbound.protection.outlook.com ([104.47.34.46]:4615
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751716AbdDCQlM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 3 Apr 2017 12:41:12 -0400
In-Reply-To: <1491232832.2661.1.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.de" <hare@suse.de>, "axboe@kernel.dk" <axboe@kernel.dk>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--487202828-762993377-1491237669=:727
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Mon, 3 Apr 2017, 8:20am, Bart Van Assche wrote:

> On Mon, 2017-04-03 at 09:29 +0200, Hannes Reinecke wrote:
> > On 04/03/2017 08:37 AM, Arun Easi wrote:
> > > If the above is true, then for a LLD to get tag# within it's max-tasks 
> > > range, it has to report max-tasks / number-of-hw-queues in can_queue, and 
> > > in the I/O path, use the tag and hwq# to arrive at a index# to use. This, 
> > > though, leads to a poor use of tag resources -- queue reaching it's 
> > > capacity while LLD can still take it.
> >
> > Shared tag sets continue to dog the block-mq on 'legacy' (ie non-NVMe)
> > HBAs. ATM the only 'real' solution to this problem is indeed have a
> > static split of the entire tag space by the number of hardware queues.
> > With the mentioned tag-starvation problem.
> 
> Hello Arun and Hannes,
> 
> Apparently the current blk_mq_alloc_tag_set() implementation is well suited
> for drivers like NVMe and ib_srp but not for traditional SCSI HBA drivers.
> How about adding a BLK_MQ_F_* flag that tells __blk_mq_alloc_rq_maps() to
> allocate a single set of tags for all hardware queues and also to add a flag
> to struct scsi_host_template such that SCSI LLDs can enable this behavior?
> 

Hi Bart,

This would certainly be beneficial in my case. Moreover, it certainly 
makes sense to move the logic up where multiple drivers can leverage. 

Perhaps, use percpu_ida* interfaces to do that, but I think I read 
somewhere that, it is not efficient (enough?) and is the reason to go the 
current way for block tags.

Regards,
-Arun
--487202828-762993377-1491237669=:727--
