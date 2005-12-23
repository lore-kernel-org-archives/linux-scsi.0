From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [SCSI] fix scsi_reap_target() device_del from atomic context
Date: Fri, 23 Dec 2005 09:58:56 -0600
Message-ID: <1135353536.3728.15.camel@mulgrave>
References: <200512212359.jBLNxluV016971@hera.kernel.org>
	 <20051222221329.5f317b8d.akpm@osdl.org>
	 <20051223121534.GM2361@parisc-linux.org> <1135351652.3728.4.camel@mulgrave>
	 <20051223073840.7110dbb0.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:25275 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932433AbVLWP7F (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Dec 2005 10:59:05 -0500
In-Reply-To: <20051223073840.7110dbb0.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: matthew@wil.cx, linux-scsi@vger.kernel.org

On Fri, 2005-12-23 at 07:38 -0800, Andrew Morton wrote:
> James Bottomley <James.Bottomley@SteelEye.com> wrote:
> > There is a potential improvement, in that could be done which is only to
> > use the workqueue if we're in atomic context.  However, I elected to
> > leave playing with that cleanup until after 2.6.15
> 
> We don't have a way of determining whether we're in atomic context
> (in_atomic() only works with CONFIG_PREEMPT).  If scsi internally knows what
> context things are in then that'll work OK.

Yes, that's what I thought ... and we don't really have a good way of
identifying this from the reap_target invocations (because of the way
most in-context paths could come back to us via a softirq).

> > There is also the point that I now have two of these allocations of
> > structures containing a workqueue and a pointer in separate instances.
> > It does look like this might be an improvement to the API (i.e. a
> > workqueue use that manages the allocation of the actual work_struct).
> 
> Perhaps you could use work_struct.data for the scsi_target* and get back to
> the work_struct via container_of().

Could you elaborate some more on this?  If I simply use the starget
pointer as my work_struct.data, how do I get back to the actual
work_struct for me to free it?  It's not passed in to the function as
far as I can tell.  But even if I do this, I still have to manage the
allocation and deallocation of the work_struct.

James


