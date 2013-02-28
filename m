From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH v2 0/2] dm: Avoid use-after-free of a mapped device
Date: Thu, 28 Feb 2013 09:42:27 +0900
Message-ID: <512EA7F3.6010607@ce.jp.nec.com>
References: <512E1C06.2000903@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([210.143.35.51]:38942 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab3B1AnO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Feb 2013 19:43:14 -0500
In-Reply-To: <512E1C06.2000903@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, Alasdair G Kergon <agk@redhat.com>, Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>, Tejun Heo <tj@kernel.org>, James Bottomley <JBottomley@parallels.com>

Hi Bart,

On 02/27/13 23:45, Bart Van Assche wrote:
> This mini-series of two patches avoids that the device mapper
> implementation can trigger a use-after-free during removal of a
> mapped device. The two patches in this series are:
> - block: Convert blk_run_queue() recursion into iteration.
> - dm: Avoid running the md queue after the last dm_put().
> 
> Note: these patches are the result of source reading. As far as I know this issue has not (yet) caused any harm.

Ref-counting of mapped device is like this:
  - dm depends on the fact that the block device is opened while there
    is bio/request submitted.  So dm_get/put in dm_blk_open/close is
    enough to keep mapped device while there are bios.
  - Request-based target has a tiny window between dm_blk_close()
    and the end of rq_completed() because the opener may close the device
    once the last bio completes even if request is still finishing.
    dm_get/dm_put in dm_start_request/rq_completed closes this window.
    (See comments in dm_start_request())
  - So, when dm_put() puts the last reference, there should be no
    requests in the queue.
  - If there is no reference to the mapped device, dm_destroy() may
    start tearing it down.
    It is ok if there is pending delayed work for the request queue
    because blk_cleanup_queue() is called before freeing the mapped device
    and cancels the delayed work.

So as far as blk_run_queue_async() in rq_completed() is concerned,
it is not a problem from "use-after-free" point of view.

-- 
Jun'ichi Nomura, NEC Corporation

