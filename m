From: "Scott T. Smith" <scott@gelatinous.com>
Subject: Re: error handling in 2.6.x
Date: Wed, 01 Sep 2004 15:42:25 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1094078545.11894.681.camel@tinny.home.foo>
References: <1094069889.4883.652.camel@tinny.home.foo>
	 <4136442C.2090303@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dsl093-129-198.sfo4.dsl.speakeasy.net ([66.93.129.198]:18594
	"EHLO localhost.localdomain") by vger.kernel.org with ESMTP
	id S267520AbUIAWm3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Sep 2004 18:42:29 -0400
In-Reply-To: <4136442C.2090303@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: brking@us.ibm.com
Cc: linux-scsi@vger.kernel.org

On Wed, 2004-09-01 at 14:50, Brian King wrote:
> They are called from a kernel thread, so they can sleep if necessary. 
> They are called with the host_lock held, so make sure to drop the lock 
> before you sleep.

ah ok, thanks... I now see in scsi_error where it is locking host_lock. 
Unfortunately, I don't have the flags to go along with it, so I guess
I'll just take a stab and call spin_unlock_irq and hope it isn't nested
inside another spinlock.  I (quickly) grepped for spin_lock within
scsi*.c and none of the other locks looked important (haha famous last
words!)

	Scott

