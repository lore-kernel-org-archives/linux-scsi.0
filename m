From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH 1/2] Block I/O while SG reset operation in progress - midlayer portion
Date: Mon, 27 Feb 2006 23:09:50 -0800
Message-ID: <20060228070950.GA26005@us.ibm.com>
References: <43FF39C0.7080509@emulex.com> <20060224201151.GA30144@us.ibm.com> <43FF8A40.8080702@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:9607 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751908AbWB1HKC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Feb 2006 02:10:02 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id k1S7A1PE020418
	for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2006 02:10:01 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k1S7A1rB061012
	for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2006 02:10:01 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.13.3) with ESMTP id k1S7A1xu007375
	for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2006 02:10:01 -0500
Content-Disposition: inline
In-Reply-To: <43FF8A40.8080702@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

James Smart <James.Smart@Emulex.Com> wrote:
> Well for a couple of reasons. I didn't view it as an actual recovery
> function as it's execution doesn't attempt to change the state of the
> shost, starget or sdev. It's not part of an escalation policy, etc.
> It's essentially performing the same effect as a reset by some other
> initiator in a multi-initiator environment, just with i/o failing faster
> than it may normally take us to detect it. As for side effects on the
> teardown, I don't see anything different than what exists today.
> At worst, it should only add a short delay until the ioflow resumes.

I agree it is unsafe today as we do not restrict the scsi_reset_provider
during scsi_remove_host.

In scsi_remove_host there was code added to detect recovery running during
removal and try to reduce the chance of eh_* routines being called post
scsi_remove_host returning.

> 
> I also looked at what it would take to implement a full state change
> or piggy back on SHOST_RECOVERY. It's a significant amount of code,
> and the addition of a new state brings it's own set of additional
> issues to get everything to play right. In the end, I saw very little
> change in result, but with lots of code changes.
> 

Yes, there is some code overhead, but some of it is needed. In looking at
your patch you add to the scsi_host_in_recovery case, but do not have a
wake_up for event waiters on host_wait.

> My main concern was - what is the interface definition we're telling
> the LLDD's for the eh routines ?  Does the LLDD expect to always be
> entered in them while in the error thread ? Does the LLDD expect that
> an eh routine will never be invoked will another call to that routine
> is outstanding ?  Obviously, none of these are true with the existing
> implementation.

Well the scsi_mid_low_api.txt indicates that the eh_*_reset_handler
routines will be called with "No other commands will be queued on current
host during eh". As you have indicated this is not true today. I did
review a few reset functions: One checked to see if a reset action was
pending and returned an error, the others appeared to not care about
current state of a reset action.


-andmike
--
Michael Anderson
andmike@us.ibm.com
