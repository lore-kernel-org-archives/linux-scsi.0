From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 4/4] fc class: use transport host byte values
Date: Thu, 15 Mar 2007 09:26:44 -0500
Message-ID: <45F957A4.8080001@cs.wisc.edu>
References: <11739019681346-git-send-email-michaelc@cs.wisc.edu> <11739019693216-git-send-email-michaelc@cs.wisc.edu> <11739019703157-git-send-email-michaelc@cs.wisc.edu> <45F865D2.9020201@cs.wisc.edu> <45F94D27.2090006@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:43466 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422722AbXCOO0w (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Mar 2007 10:26:52 -0400
In-Reply-To: <45F94D27.2090006@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

James Smart wrote:
> Background:
>   The states, in the transport are:
>      event               state
>     --------------------------------
>       n/a                running
>     lose connectivity    blocked
>     fastfail timeout     still blocked, but with fastfail indicator

My patch changed this one. When this times out, I unblock the queue.

>     dev_loss timeout     unblocked/removed
> 
> Question:
> 
> The chkready helper in the transport catches race conditions where the
> block is being put in place, but queuecommand is running on another cpu,
> thus returning DID_IMM_RETRY.
> 
> Your patch is updating chkready to look for the case when fastfail has
> fired, and returning DID_TRANSPORT_FASTFAIL  ?  Why ?  The request
> queue would be blocked so there should be no call to queuecommand that
> would fall into this category - unless you are assuming that fastfail
> timeout is so fast that it could fall into the same race condition as
> blocked.

In the patch, when the fast IO fail timer fires, I unblock the queues.

+       rport->fast_io_fail_timeout = 1;
        i->f->terminate_rport_io(rport);
+       scsi_target_unblock(&rport->dev);

At that time IO would be queued on drivers and would hit that test and
be failed. New IO would also be failed upwards by that check.

