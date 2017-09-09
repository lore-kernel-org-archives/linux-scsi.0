From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V3 7/8] block: allow to allocate req with REQF_PREEMPT
 when queue is preempt frozen
Date: Sat, 9 Sep 2017 15:21:11 +0800
Message-ID: <20170909072105.GA26081@ming.t460p>
References: <20170902130840.24609-8-ming.lei@redhat.com>
 <20170902131208.GA10940@ming.t460p>
 <1504498405.10804.10.camel@wdc.com>
 <20170904071653.GD7959@ming.t460p>
 <1504539634.3189.15.camel@wdc.com>
 <20170904160813.GA21757@ming.t460p>
 <1504575610.3360.7.camel@wdc.com>
 <20170905022325.GC24787@ming.t460p>
 <20170908030753.GA5627@ming.t460p>
 <1504891695.1665.5.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35198 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751548AbdIIHV3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 9 Sep 2017 03:21:29 -0400
Content-Disposition: inline
In-Reply-To: <1504891695.1665.5.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "tj@kernel.org" <tj@kernel.org>

On Fri, Sep 08, 2017 at 05:28:16PM +0000, Bart Van Assche wrote:
> On Fri, 2017-09-08 at 11:08 +0800, Ming Lei wrote:
> > Looks I replied or clarified all your questions/comments on this
> > patchset.
> 
> No, you have not addressed all my comments, you know that you have not
> addressed all my comments so you should not have written that you have

I do not know.

> addressed all my comments. This patch series not only introduces ugly
> changes in the request queue freeze mechanism but it also introduces an
> unacceptable race condition between blk_get_request() and request queue
> cleanup.

So what is the race? Could you reply in original thread?

> 
> BTW, you don't have to spend more time on this patch series. I have
> implemented an alternative and much cleaner approach to fix SCSI device
> suspend. I'm currently testing that patch series.

You do not understand the issue at all, it is not only related with
suspend. Please take a look at scsi_execute(), each request run
via scsi_execute() need to be dispatched successfully even when
SCSI device is quiesced.

-- 
Ming
