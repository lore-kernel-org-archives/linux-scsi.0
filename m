From: Robert Love <robert.w.love@intel.com>
Subject: Re: [PATCH 3/4] fcoe: use dedicated workqueue instead of system_wq
Date: Tue, 25 Jan 2011 10:26:30 -0800
Message-ID: <1295979990.12667.7.camel@fritz>
References: <1295877451-16602-1-git-send-email-tj@kernel.org>
	 <1295877451-16602-4-git-send-email-tj@kernel.org>
	 <1295930614.15425.137.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:57669 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492Ab1AYS0b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jan 2011 13:26:31 -0500
In-Reply-To: <1295930614.15425.137.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tejun Heo <tj@kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Eric.Moore@lsi.com" <Eric.Moore@lsi.com>

On Mon, 2011-01-24 at 20:43 -0800, James Bottomley wrote:
> On Mon, 2011-01-24 at 14:57 +0100, Tejun Heo wrote:
> > fcoe uses the system_wq to destroy ports and the work items need to be
> > flushed before the driver is unloaded.  As the work items free the
> > containing data structure, they can't be flushed directly.  The
> > workqueue should be flushed instead.
> > 
> > Also, the destruction works can be chained - ie. destruction of a port
> > may lead to destruction of another port where the work item for the
> > former queues the work for the latter.  Currently, the depth of chain
> > can be at most two and fcoe_exit() makes sure everything is complete
> > by calling flush_scheduled_work() twice.
> > 
> > With commit c8efcc25 (workqueue: allow chained queueing during
> > destruction), destroy_workqueue() can take care of chained works on
> > workqueue destruction.  Add and use fcoe_wq instead.  Simply
> > destroying fcoe_wq on driver unload takes care of flushing.
> 
> Cc'ing FCoE maintainer for an opinion.
> 
> Robert, I assume this will come back via your queue with an ack.
> 
> James
> 
Yes, I will take care of it. There is going to be a lot of code movement
in the next fcoe update to make way for a new fcoe model that will allow
for new transports. It's the pre-work that the bnx2fc driver can plug
into. I think having this go through my tree is a good idea.

Thanks, //Rob

