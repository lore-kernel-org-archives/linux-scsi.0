From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 0/3] qla2xxx: Updates for scsi misc 3.0.
Date: Thu, 14 Jul 2011 11:47:31 -0600
Message-ID: <20110714174731.GA5359@parisc-linux.org>
References: <1310663244-23233-1-git-send-email-giridhar.malavali@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:38408 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932254Ab1GNRrd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jul 2011 13:47:33 -0400
Content-Disposition: inline
In-Reply-To: <1310663244-23233-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: giridhar.malavali@qlogic.com
Cc: jbottomley@parallels.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

On Thu, Jul 14, 2011 at 10:07:21AM -0700, giridhar.malavali@qlogic.com wrote:
> The patch 1/3 has couple of warnings w.r.t KERN_facility level with printk.
> 
> WARNING: printk() should include KERN_ facility level
> 
> Using KERN facility in printk will print each buffer information in new line causing
> unreadable log messages.
> 
> Here is an example
> 
> With KERN facility
> Mar 23 10:05:37 linux-dcaw kernel: qla2xxx [0000:18:00.6]4:1102:
> Mar 23 10:05:37 linux-dcaw kernel: 42
> Mar 23 10:05:37 linux-dcaw kernel:
> Mar 23 10:05:37 linux-dcaw kernel: 00
> 
> Without KERN facility
> Mar 21 13:07:35 linux-dcaw kernel: qla2xxx [0000:18:00.7]37:1102: 48  00  00  00  5b  f2  00

I think you want to use KERN_CONT to avoid this warning.  BUT, note
the problem:

/*
 * Annotation for a "continued" line of log printout (only done after a
 * line that had no enclosing \n). Only to be used by core/arch code
 * during early bootup (a continued line is not SMP-safe otherwise).
 */
#define KERN_CONT       "<c>"

If you're not OK with potentially interspersed messages, you need to
accumulate into your own buffer and send it down with a single printk.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
