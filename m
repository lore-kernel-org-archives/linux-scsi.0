From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 23/24] advansys: Improve interrupt handler
Date: Fri, 27 Jul 2007 15:36:49 -0400
Message-ID: <46AA4951.3040102@garzik.org>
References: <11855437542538-git-send-email-matthew@wil.cx> <46AA05ED.2060208@garzik.org> <20070727145336.GK21219@parisc-linux.org> <46AA07CC.9090004@garzik.org> <20070727150420.GL21219@parisc-linux.org> <46AA0B70.9060108@garzik.org> <20070727152520.GM21219@parisc-linux.org> <46AA150A.5090804@garzik.org> <20070727173613.GN21219@parisc-linux.org> <46AA2DB7.4010707@garzik.org> <20070727180447.GP21219@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:60387 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933642AbXG0Tgv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jul 2007 15:36:51 -0400
In-Reply-To: <20070727180447.GP21219@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

OK, I think I misunderstood your explanation.  Rather than judging based 
on English emails, I went back and looked at the old and new code.

Looking at the old code, there is a clear 1-to-1-to-1-to-1 
correspondence between adapter, request_irq() call, scsi_host, and 
boardp.  So what the old code is doing during probe is quite normal.

I thought you were saying there were multiple request_irq() calls for a 
single adapter.

The only thing that's abnormal is the interrupt handler checking 
multiple boards for events, which you rightly removed.

There is absolutely no need to add IRQF_SHARED to non-PCI devices or 
anything like that.

At this point, looking at your new code, I would only add
	"replace spin_lock_irqsave with spin_lock in interrupt handler"
and
	"delete no-ops DvcEnterCritical and DvcLeaveCritical"
to the todo list.

	Jeff



