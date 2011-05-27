From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: tcm_fc comments
Date: Fri, 27 May 2011 14:24:13 -0700
Message-ID: <1306531453.23461.174.camel@haakon2.linux-iscsi.org>
References: <20110527102410.GA14951@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:53350 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148Ab1E0Vcb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 May 2011 17:32:31 -0400
In-Reply-To: <20110527102410.GA14951@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: kiran.patil@intel.com, linux-scsi@vger.kernel.org

On Fri, 2011-05-27 at 06:24 -0400, Christoph Hellwig wrote:
> - please remove all the extra -I lines in EXTRA_CLFAGs, none of them
>    should be needed.

Dropped

>  - CONFIGFS_TCM_FC_DEBUG should be used directly in the code instead of
>    definining another symbol

Dropped as this is unused

>  - there's no need for thread_wq, you can just do a wake_up_process
>    on the task_struct for the thread.  That also means you don't have
>    the races with the kthread API you currently have

Converted to use wake_up_process() in ft_queue_cmd() and
schedule_timeout_interruptible() in ft_thread()

>  - The set_user_nice in ft_thread needs a comment explaning why you
>    really need to mess with priorities here.  I suspect you don't have
>    to anyway.

Dropped

>  - There's lots of code like "if (!(acl)) {" with completley superflous
>     
> 

Mmmm, dropping the a handful of if (!(foo)) usages on tfc_conf.c, but I
don't see the rest of the code with superflous braces..?

> In general it would have been nice to have sent a review request to
> linux-scsi, especially as most of these items have been commented on
> multiple times for other target frontends before.

Yes.  So aside from these items, there is one TMR LUN_RESET bugfix patch
that was not included in the initial merge in scsi-misc.  

So fixed in lio-core-2.6.git, and sending out the patches shortly.

Thanks,

--nab

