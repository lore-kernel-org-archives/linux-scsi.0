From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 39/42] target: Call transport_new_cmd instead of adding
	to cmd queue
Date: Sat, 4 Jun 2011 16:18:42 +0200
Message-ID: <20110604141842.GA13579@lst.de>
References: <1306523240-15543-1-git-send-email-agrover@redhat.com> <1306523240-15543-40-git-send-email-agrover@redhat.com> <1306834367.8193.169.camel@haakon2.linux-iscsi.org> <20110531101755.GA31447@lst.de> <1306840694.8193.206.camel@haakon2.linux-iscsi.org> <20110601040945.GB15488@lst.de> <1307154838.8419.55.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:59605 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754891Ab1FDOSn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 4 Jun 2011 10:18:43 -0400
Content-Disposition: inline
In-Reply-To: <1307154838.8419.55.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-iscsi-target-dev@googlegroups.com, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, Jun 03, 2011 at 07:33:58PM -0700, Nicholas A. Bellinger wrote:
> >  - what is the point of the transport_generic_process_write wrapper?
> 
> Minus the stubbed WRITE overflow copy stuff, this primarly used by
> tcm_loop to queue up the cmd's tasks for execution via
> transport_execute_tasks() instead of a direct fabric module call..
> 
> Currently tcm_loop is the only user of this as we know the full WRITE
> payload is available once the struct scsi_cmd as been dispatched via
> ->queuecommand().

As a first step the stubbed out code really should go away ASAP, it's
really rather confusing as it has little chance to work for the current
code base.  As a follow-on transport_generic_process_write should be
replaced by a direct call to transport_execute_tasks, to make it more
obvious what's going on here.

If we then plan to keep the direct task execution from the submitter
context we should document why we're doing that.  One option would be
to make ->write_pending return a boolean indicator whether we should
call transport_exectute_tasks from
transport_generic_write_pending/transport_generic_new_cmd, and thus
making it more obvious that's it's actually similar to the read path
in that respect.

I'm still not convinced that running the read/write/flush/discard tasks
from the caller is an all that good idea.  They will 100% block for the
file backend, and can block when we reach the request limit with iblock,
and the blocking behaviour might differ for different kinds of requests.

