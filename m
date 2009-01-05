From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH] scsi_lib: don't decrement busy counters when inserting
	commands
Date: Mon, 5 Jan 2009 15:28:25 -0800
Message-ID: <20090105232825.GA12820@plap4-2.local>
References: <1229493343215-git-send-email-michaelc@cs.wisc.edu> <1230914541.3304.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:49644 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbZAEX21 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jan 2009 18:28:27 -0500
Content-Disposition: inline
In-Reply-To: <1230914541.3304.9.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>

On Fri, 02 Jan 2009, James Bottomley wrote:

> On Tue, 2008-12-16 at 23:55 -0600, michaelc@cs.wisc.edu wrote:
> > From: Mike Christie <michaelc@cs.wisc.edu>
> > 
> > This patch fixes a regression in scsi-misc introduced with:
> > 312efe5efcdb02d604ea37a41d965f32ca276d6a
> > [SCSI] simplify scsi_io_completion().
> > 
> > The problem is that in previous kernels scsi_io_completion would call
> > scsi_requeue_command, but now it can call scsi_queue_insert for
> > something like a UNIT_ATTENTION (for netapp targets we get
> > UNIT_ATTENTION when restarting a iscsi session). And scsi_queue_insert
> > will call scsi_device_unbusy, but in the scsi_io_completion code path
> > scsi_finish_command has already called this so we now end up
> > with invalid host, target and device busy values.
> > 
> > Patch was made over scsi-misc.
> 
> This is a bad bug, but not quite the way I'd like to fix it.  Whether
> the queue should be unbusied or not is really separate from the block
> action, so it should have its own flag (plus it's not really a flag many
> people should be using).  Since, really, the wrong use is confined to
> the defining file, how about this:

Hmm, with this patch I'm still running into the problems I described
here:

http://article.gmane.org/gmane.linux.scsi/47029

basically, I/Os returned with a DID_RESET status are being requeued in
an incomplete state:

	[ 2362.068342] scsi(5:0:13): OVERRUN status detected 0x7-0x400
	[ 2362.068345] CDB: 0x2a 0x0 0x0 0x0 0xe 0x70
	[ 2362.068347] PID=0x81eeb req=0x0 xtra=0x1c00 -- returning DID_ERROR status!
	[ 2362.068411] scsi(5:0:13): OVERRUN status detected 0x7-0x400
	[ 2362.068413] CDB: 0x2a 0x0 0x0 0x0 0xe 0x70
	[ 2362.068415] PID=0x81eec req=0x0 xtra=0x1c00 -- returning DID_ERROR status!

:(

Thoughts?
