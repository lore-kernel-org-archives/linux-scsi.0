From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 12195] "dd" make kernel panic
Date: Thu, 11 Dec 2008 09:17:23 -0600
Message-ID: <1229008643.3266.7.camel@localhost.localdomain>
References: <20081211090559.1DF1610800C@picon.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:58017 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755617AbYLKPRS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Dec 2008 10:17:18 -0500
In-Reply-To: <20081211090559.1DF1610800C@picon.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

On Thu, 2008-12-11 at 01:05 -0800, bugme-daemon@bugzilla.kernel.org
wrote:
> I instrumented kernel. below is some finding.
> 1) The disk isn't stable. If we run dd in a loop, sometimes the disk doesn't
> work, so block request will expire to start a scsi error handling;
> 2) fussion driver has its own periodic (1 sec) checking in
> mpt_fault_reset_work. If something is wrong, it will do a hardware reset and
> flush all pending requests;
> 3) Step 1) and 2) have a race that a request might be flushed in step 2), but
> step 1) releases the request firstly. Later on, when SOFTIRQ tries to release
> the scsi_cmnd, kernel panic.

OK, so to rule out the block timer problems which we think are fixed,
could you reproduce on 2.6.28-rc8.

Also, the routine 

> [<a000000100391cf0>] scsi_softirq_done+0x50/0x2e0
>                                 sp=e000000008a97e10 bsp=e000000008a90d70

Is hard to diagnose. Could you ask gdb or addr2line which actual source
line this is?

Thanks,

James


