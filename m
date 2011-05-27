From: Christoph Hellwig <hch@infradead.org>
Subject: tcm_fc comments
Date: Fri, 27 May 2011 06:24:10 -0400
Message-ID: <20110527102410.GA14951@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:49742
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752600Ab1E0KYM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 May 2011 06:24:12 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kiran.patil@intel.com, nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org


 - please remove all the extra -I lines in EXTRA_CLFAGs, none of them
   should be needed.
 - CONFIGFS_TCM_FC_DEBUG should be used directly in the code instead of
   definining another symbol
 - there's no need for thread_wq, you can just do a wake_up_process
   on the task_struct for the thread.  That also means you don't have
   the races with the kthread API you currently have
 - The set_user_nice in ft_thread needs a comment explaning why you
   really need to mess with priorities here.  I suspect you don't have
   to anyway.
 - There's lots of code like "if (!(acl)) {" with completley superflous
   braces.

In general it would have been nice to have sent a review request to
linux-scsi, especially as most of these items have been commented on
multiple times for other target frontends before.
