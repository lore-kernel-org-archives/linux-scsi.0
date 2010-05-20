From: Tejun Heo <tj@kernel.org>
Subject: Re: spinlock recursion in scsi_end_request() (kernel 2.6.24)
Date: Thu, 20 May 2010 17:05:19 +0200
Message-ID: <4BF54FAF.6020104@kernel.org>
References: <AANLkTilIYz-UITAugWx08u-AvKB5gI-E1M3LORZ55wro@mail.gmail.com>	 <4BF508C8.9050405@kernel.org> <AANLkTilPaI-b4IUNfUnVKahK299fujgYTXsxC1BROw0L@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:34837 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753405Ab0ETPFX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 May 2010 11:05:23 -0400
In-Reply-To: <AANLkTilPaI-b4IUNfUnVKahK299fujgYTXsxC1BROw0L@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Prashant <0xfffff0@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Hello,

On 05/20/2010 01:33 PM, Prashant wrote:
> I have a question related to code which is almost same in the
> current kernel.  I don't know whether this is the right mailing list
> for the following question.

linux-scsi would probably fit better (cc'd).

> When a sata drive is unplugged, its corresponding sdev's state is set
> to SDEV_OFFLINE. Now if IO requests are still comming on the same device,
> They will be killed by calling scsi_kill_request().
> 
> 1) scsi_kill_request does following things:
>     i) Unlock request queue
>     ii) Increment host_busy count
>     iii) Lock request queue
>     iv) Calls __scsi_done()
> 
> 2) __scsi_done() does following things:
>      i) set request completion data
>      ii) Calls blk_completion_request()
> 
> 3) blk_completion_request() does following things:
>      i) Adds request->donelist to blk_cpu_done softirq queue
>         and raise the softirq (which is scsi_softirq_done)
> 
> 4) next sequence is:
>     scsi_softirq_done >> scsi_finish_command >> scsi_device_unbusy()
> 
> 5) scsi_device_unbusy() again locks the request_queue. This is the place where
>     we can get into the spinlock recursion.
> 
>     Is this correct? Please correct me if something is wrong.

Raising softirq defers the work to another context and grabbing the
same lock from softirq handler doesn't constitute a recursive locking.
Please try to reproduce the problem on recent kernel w/ lockdep
enabled.

Thanks.

-- 
tejun
