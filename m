From: john smith <whalajam@yahoo.com>
Subject: Re: scsi_host_template.queuecommand() instances
Date: Tue, 8 Mar 2011 10:22:19 -0800 (PST)
Message-ID: <149126.21460.qm@web161909.mail.bf1.yahoo.com>
References: <1298902479.2487.9.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web161909.mail.bf1.yahoo.com ([98.139.210.200]:37340 "HELO
	web161909.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753405Ab1CHSWV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2011 13:22:21 -0500
In-Reply-To: <1298902479.2487.9.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>, James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org

> What actually governs the threading is the ioscheduler
> entry context to
> the request function, which tends to be governed by how the
> I/O is
> called at the top.
> 
> James

Considering the IO scheduler and the IO merges: I can imagine how it works if all the concurrent IO's for the same device are scheduled and merged and re-issued by another thread - that is the scheduler theread.

But how the two activities are accomplished such that IO's are still issued by their original threads?
For ex., IO_1 is issued by thread1 and IO_2 issued by thread2; they are merged/re-ordered and IO_2 is merged with IO_1 in one single IO (IO_2, IO_1); 
which thread is issueing the single, but larger IO? 
what is the other thread doing if there are no/fewer IO's left to issue?
Some IO's are issued on behalf of an other IO thread context?
It is even uglier for scheduling (which may involve interlacing IO's from different threads), is the scheduler lock-stepping the IO threads to enforce the sequence?

I doubt it this is the way it is implemented and I'd like to understand how is it done.
It would be more efficient that all IO's for a particular device are handled by one (queue and) thread

thanks,
John


      
