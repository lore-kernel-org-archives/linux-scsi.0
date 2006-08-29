From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 0/4] Change return values from queue_work et al.
Date: Tue, 29 Aug 2006 18:06:14 +0200
Message-ID: <44F465F6.6040202@s5r6.in-berlin.de>
References: <Pine.LNX.4.44L0.0608291002300.6392-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:21894 "EHLO
	hp3.statik.tu-cottbus.de") by vger.kernel.org with ESMTP
	id S965044AbWH2QKT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Aug 2006 12:10:19 -0400
In-Reply-To: <Pine.LNX.4.44L0.0608291002300.6392-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@redhat.com>, Kernel development list <linux-kernel@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@suse.de>

Alan Stern wrote:
...
> Note that the change falls within the bounds of the documented
> behavior, in the sense that any code which was originally written
> correctly (i.e., in accordance with the documentation) will continue to
> work correctly without generating any warnings.
...

You are right that there is no comment (or better yet, kerneldoc
comment) about what happens if an instance of work_struct is enqueued
twice. However, /a/ there is the source and /b/ Corbet, Rubini,
Kroah-Hartman: LDD3 describes in detail in an easily understood section
how workqueues are to be used. (Workqueues in Linux 2.6.10, that is.)

...
> If the
> usage is correct then there is no harm in leaving the WARN_ON call where
> it is.  If the usage is wrong then the call needs to be fixed, and the
> maintainer for the subsystem containing the call will soon find out about
> it, thanks to the WARN_ON.
...

Acceptable on second thought, particularly in light of your new
replacement functions with improved semantics of their return value.
Although there are cases where the WARN_ON might not go off during a
long time, or where an update won't happen in many months despite
hundreds of reports at dozens of mailing lists and bugzillas.
-- 
Stefan Richter
-=====-=-==- =--- ===-=
http://arcgraph.de/sr/
