From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 23/24] advansys: Improve interrupt handler
Date: Fri, 27 Jul 2007 11:36:13 -0600
Message-ID: <20070727173613.GN21219@parisc-linux.org>
References: <20070727134038.GC21219@parisc-linux.org> <11855437542538-git-send-email-matthew@wil.cx> <46AA05ED.2060208@garzik.org> <20070727145336.GK21219@parisc-linux.org> <46AA07CC.9090004@garzik.org> <20070727150420.GL21219@parisc-linux.org> <46AA0B70.9060108@garzik.org> <20070727152520.GM21219@parisc-linux.org> <46AA150A.5090804@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:56999 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932679AbXG0RgP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jul 2007 13:36:15 -0400
Content-Disposition: inline
In-Reply-To: <46AA150A.5090804@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org

On Fri, Jul 27, 2007 at 11:53:46AM -0400, Jeff Garzik wrote:
> Matthew Wilcox wrote:
> >I still say it's an improvement over scanning the list of scsi hosts
> >looking for any that have work pending whenever any interrupt comes in.
> 
> Having the kernel interrupt subsystem implement a loop for you is 
> completely utterly unusual, slow, silly, and likely to get broken when 
> people futz with the interrupt system core.  It probably has edge cases 
> too, like screwing with the screaming interrupt detection code.
> 
> The kernel interrupt subsystem is not meant to be abused in that way.

I think what you're missing is: This isn't new.  The advansys driver
was *already* requesting the same interrupt twice for EISA boards.
It's just that before, when an interrupt happened on the EISA board,
it would scan all Scsi_Hosts twice, and now it scans this pair of boards
once each.

It may not be elegant, it may not be the best way, but it *is* a
monotonic improvement.  So please, calm down.

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
