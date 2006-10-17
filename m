From: "Qi, Yanling" <Yanling.Qi@lsi.com>
Subject: RE: sg_remove and pending write request
Date: Tue, 17 Oct 2006 15:33:32 -0600
Message-ID: <0F08E10B769EAF4EA2C43A573B8CC87F60B3A7@NAMAIL3.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:11658 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1750745AbWJQVdm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Oct 2006 17:33:42 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

Thank you for your reply and comments, Douglas. The user land product is
waiting for release. The time frame doesn't allow doing many changes in
the user land product at this time.

Read the sg.c again. It seems that the reattached SAS devices would take
the same sg slot if the following conditions meet
1. wait for 2+ minutes for a pending SG-IO write request to come back
before pushing the cable back. The 2+ minutes gives the scsi middle
level to timeout the pending io request and do error-recovery if it is
needed.
2. close user space fd properly (sg_release will try to do the
sg_dev_arr[k] = NULL.

Do you see any other conditions?

Thanks,

Yanling
-----Original Message-----
From: Douglas Gilbert [mailto:dougg@torque.net] 
Sent: Tuesday, October 17, 2006 2:37 PM
To: Qi, Yanling
Cc: linux-scsi@vger.kernel.org
Subject: Re: sg_remove and pending write request

Qi, Yanling wrote:
> Hi All,
> 
> We are running a test case of SAS cable pull/push on a SAS RAID
system.
> After the SAS cable is pulled from a SAS RAID, scsi devices are
deleted.
> And then when the cable is pushed back, the scsi device with the same
> H:C:T:L sometime will be assigned to a diffent sgX.

There is no guarantee of the naming stability of sg
nodes (e.g. /dev/sg3) when devices disappear and re-appear.
Actually the design of lk 2.6 seems to actively discourage
user space programs from the assumption. Same applies for
all SCSI device nodes (and host numbers)

In the case of SAS, you really should be looking at the
target port SAS address in the device identification VPD
page (page 0x83). If the device in question is a SATA disk
then you have more work to do.

> Reading through the sg.c, it seems that if the sg device has a pending
> write request, the sg slot (sg_dev_arr[k] = NULL) will not be freed
> during sg_remove time. Can someone confirm this?

Yes, I can confirm that. The sg driver waits for the mid
level to callback with the outstanding IO completions (or
timeouts). If the user kills the process, the sg driver
still waits for IO completion. [A problem arises if the
user tries to 'rmmod sg'.] The device could well re-appear
during that "wait" time and the sg driver will assign a
different device node (i.e. the first unused slot in
sg_dev_arr[]).

> If this is the case, what the user space process do to prevent this
from
> happening?

Develop a user space program that applies fast acting
super glue to the SAS connectors when IOs are in flight
and hands approach.

As I said above, you cannot assume device node names will
be stable across disconnect, reconnect cycles.

> I see that the sg.c sends SIGPOLL to the user space process
> (kill_fasync(&sfp->async_qp, SIGPOLL,POLL_HUP);), what this signal
will
> be translated to the user space return-code from read/write call?

You would need to be running asynchronous IO with the
sg driver (i.e. write(),poll(),read() rather than SG_IO)
and POLLUP should appear in struct pollfd::revents .
You should also be able to run poll() from a signal handler
that catches SIGPOLL. [My knowledge is a bit rusty in this
area.]

Doug Gilbert


