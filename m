From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 02/24] workqueue: defer work to a draining queue
Date: Mon, 19 Dec 2011 13:49:24 -0800
Message-ID: <20111219214924.GA6256@google.com>
References: <20111217022912.15036.85808.stgit@localhost6.localdomain6>
 <20111217023318.15036.77389.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20111217023318.15036.77389.stgit@localhost6.localdomain6>
Sender: linux-ide-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

On Fri, Dec 16, 2011 at 06:33:18PM -0800, Dan Williams wrote:
> commit 9c5a2ba7 "workqueue: separate out drain_workqueue() from
> destroy_workqueue()" provided drain_workqueue() for users like libsas to
> use for flushing events.
> 
> When libsas drains it wants currently queued and chained events to be
> flushed, but it fully expects to continue issuing unchained events with
> the expectation that they are serviced sometime after the drain.
> 
> For external users of drain_workqueue() arrange for unchained work to be
> queued after the drain completes, if the caller cares if unchained work
> was queued as a result of the drain it can check for a non-zero return
> value.  Deferred work is guaranteed to be at least queued when
> drain_workqueue() returns, and visible to flush_workqueue() users as
> well.
> 
> Unfortunately this causes the promotion of workqueue_lock to hard-irq
> safe and does not guarantee that work submitted via queue_work_on() runs
> on the specified cpu if it gets deferred.
> 
> Cc: Tejun Heo <tj@kernel.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Dan, as I replied before, I'm not a big fan of this approach.  For
now, I think it would be best to add private wrapper in libsas to
support deferring unchained work items while draining.

Thanks.

-- 
tejun
