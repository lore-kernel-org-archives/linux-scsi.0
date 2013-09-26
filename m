From: Tejun Heo <tj@kernel.org>
Subject: Re: Race condition between "read CFQ stats" and "block device
 shutdown"
Date: Thu, 26 Sep 2013 12:30:29 -0400
Message-ID: <20130926163029.GD32391@mtj.dyndns.org>
References: <CAOMFOmXJ5ZTYdOvdUt-oxsouhPGRmMshCRhn6AFgmFAGZw5WZA@mail.gmail.com>
 <5226D661.7070301@suse.de>
 <CAOMFOmUCqXN1uaqBEWH3PStuZXvnvLw=YrARgv7DvqO6Y4bFPQ@mail.gmail.com>
 <20130904160723.GC26609@mtj.dyndns.org>
 <CAOMFOmWWfxCZ7ND_Vso4UkSEOqGm=o-xsqrfrj5MKdf9_jr1gA@mail.gmail.com>
 <20130926135443.GC2480@htj.dyndns.org>
 <5244423A.2050107@suse.de>
 <CAOMFOmX2f35qWyTr7=1HNu=RMB_LMAmpMbYxSEsX1xgURhx_mg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qa0-f45.google.com ([209.85.216.45]:55206 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab3IZQac (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Sep 2013 12:30:32 -0400
Content-Disposition: inline
In-Reply-To: <CAOMFOmX2f35qWyTr7=1HNu=RMB_LMAmpMbYxSEsX1xgURhx_mg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anatol Pomozov <anatol.pomozov@gmail.com>
Cc: Hannes Reinecke <hare@suse.de>, Cgroups <cgroups@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org

Hello,

On Thu, Sep 26, 2013 at 09:23:19AM -0700, Anatol Pomozov wrote:
> We use modified version of "sbull" block device driver from GKH book.
> We use it for testing block device startup/shutdown path + CFQ
> manipulation.
> 
> The sbull driver uses function
> blk_init_queue(..., &dev->qlock);
> 
> it passes lock as a second parameter and function makes the lock
> swapping. According to your information passing lock to
> blk_init_queue() considered as an "old non recommended way" so we
> should modify our driver and avoid doing this. I'll take a look.

I wonder whether we can make request_queue record the passed in lock
and grab it in addition to the queue lock instead of replacing it when
invoking the request function.  This would mean more overhead for the
broken drivers but given how legacy they are at this point, I don't
think that's gonna be a big problem.  if that's likely to work, we may
as well just push all the extra locking to the legacy drivers so that
their request functions take the extra lock and then we can remove the
spinlock argument completely.  I'm not sure whether the locking in
request path is the only thing necessary tho.

Thanks.

-- 
tejun
