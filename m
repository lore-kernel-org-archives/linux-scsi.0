From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 39/42] target: Call transport_new_cmd instead of adding
	to cmd queue
Date: Wed, 1 Jun 2011 06:09:45 +0200
Message-ID: <20110601040945.GB15488@lst.de>
References: <1306523240-15543-1-git-send-email-agrover@redhat.com> <1306523240-15543-40-git-send-email-agrover@redhat.com> <1306834367.8193.169.camel@haakon2.linux-iscsi.org> <20110531101755.GA31447@lst.de> <1306840694.8193.206.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:46417 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770Ab1FAEJq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Jun 2011 00:09:46 -0400
Content-Disposition: inline
In-Reply-To: <1306840694.8193.206.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-iscsi-target-dev@googlegroups.com, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, May 31, 2011 at 04:18:14AM -0700, Nicholas A. Bellinger wrote:
> I very much agree with these points, and moving to workqueues for TCM
> v4.1 (mainline v3.1) for these reasons makes alot of sense to me.  I
> need to get a better idea of how this will actually look, but am eager
> to move ahead..

I think the first step would be to move split the se_task execution
from the current thread into a workqueue.  That would also help with
making the file backend scale much better.  If it wasn't for head of queue
semantics this would be almost trivial - just embedd a work_struct in
every task and queue it up to the work queue, which handles concurrency.
I'm not entirely sure how to handle head of queue semantics correctly,
maybe just adding a pointer to pending head of queue tasks to the
se_dev and executing those first might work.


Btw, I can't fully make sense of the current task execution, so
here's a few questions:

 - why do we have separate __transport_execute_tasks and
   transport_execute_tasks, or rather why is it safe to use
   __transport_execute_tasks transport_processing_thread
   without the checks for shutting down?
 - what is the point of the transport_generic_process_write wrapper?
 - why does transport_generic_new_cmd call transport_execute_tasks
   for reads, but for writes we leave it to the ->write_pending
   method which only calls transport_execute_tasks for some of
   the fabrics?  Note that with the current code transport_generic_new_cmd
   might not get called from the fabric thread and thus stall the
   caller - it might make sense switch to calling transport_generic_handle_data
   for that case.
