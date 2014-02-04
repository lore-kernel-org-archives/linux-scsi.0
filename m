From: Jon <nuxi@vault24.org>
Subject: PROBLEM: aacraid driver can lock up in 2.6.37 and higherA
Date: Tue, 4 Feb 2014 11:38:27 -0500
Message-ID: <20140204163827.GG3232@feynman.vault24.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pinero.vault24.org ([69.164.212.126]:34252 "EHLO
	pinero.vault24.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822AbaBDQrZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Feb 2014 11:47:25 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: aacraid@adaptec.com
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org

The conversion of the aacraid driver off of the BKL seems to have a bug
that only shows up in some older versions of the adaptec raid tools.
Older versions of the tools seem to deadlock when querying the raid
card in post-BKL kernels.

I'm not so much a kernel expert, but I did trace it to the exact commit
that removed the BKL from the driver. I think the problem is that the
function next_getadapter_fib() in drivers/scsi/aacraid/commctrl.c can
call down_interruptible() while the calling function holds a lock.

My understanding is that going to sleep while holding the BKL just kind
of did the right thing behind your back (silently released the lock and
then reaquired it when you woke up) but now that the driver has its own
mutex that is not happening and instead it is deadlocking.

I put a printk() in to confirm this is the magic line of code was only
hit by the versions of the tools that would deadlock. I also confirmed
that a crude hack to releasee and reaquire the mutex around the sleep
made the tools work again (seemingly without ill affects). Although I'm
sure there is a better fix.


arcconf never has the problem, its only the ancient aaccli utility that
can hit this deadlock. (Obligatory: why are you using aaccli?1? because
no one had updated this box in ages.) Those tools are binary only, but
its clear from the driver this isn't some quirk and its the difference
between using blocking and non-blocking access to the RAID card.

-- 
Jon
X(7): A program for managing terminal windows. See also screen(1).
