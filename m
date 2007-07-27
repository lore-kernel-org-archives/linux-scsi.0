From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 23/24] advansys: Improve interrupt handler
Date: Fri, 27 Jul 2007 13:46:53 -0600
Message-ID: <20070727194652.GR21219@parisc-linux.org>
References: <20070727145336.GK21219@parisc-linux.org> <46AA07CC.9090004@garzik.org> <20070727150420.GL21219@parisc-linux.org> <46AA0B70.9060108@garzik.org> <20070727152520.GM21219@parisc-linux.org> <46AA150A.5090804@garzik.org> <20070727173613.GN21219@parisc-linux.org> <46AA2DB7.4010707@garzik.org> <20070727180447.GP21219@parisc-linux.org> <46AA4951.3040102@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:58862 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933790AbXG0Tqy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jul 2007 15:46:54 -0400
Content-Disposition: inline
In-Reply-To: <46AA4951.3040102@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org

On Fri, Jul 27, 2007 at 03:36:49PM -0400, Jeff Garzik wrote:
> OK, I think I misunderstood your explanation.  Rather than judging based 
> on English emails, I went back and looked at the old and new code.

Phew!  I didn't like to think that one of us was going crazy in our
dotage ;-)

> Looking at the old code, there is a clear 1-to-1-to-1-to-1 
> correspondence between adapter, request_irq() call, scsi_host, and 
> boardp.  So what the old code is doing during probe is quite normal.
> 
> I thought you were saying there were multiple request_irq() calls for a 
> single adapter.
> 
> The only thing that's abnormal is the interrupt handler checking 
> multiple boards for events, which you rightly removed.
> 
> There is absolutely no need to add IRQF_SHARED to non-PCI devices or 
> anything like that.

Possibly you've misunderstood the code slightly -- for the case of a
dual-channel EISA board, the two hosts will have the same interrupt
number.  So we do need to keep the current code which sets IRQF_SHARED
on EISA interrupts.  I'm not quite sure why that's not the case for
the ABP852 dual-channel VLB card -- possibly each channel has its own
interrupt.  I don't know if VLB can do that or not.

> At this point, looking at your new code, I would only add
> 	"replace spin_lock_irqsave with spin_lock in interrupt handler"
> and
> 	"delete no-ops DvcEnterCritical and DvcLeaveCritical"
> to the todo list.

Thanks, added.

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
