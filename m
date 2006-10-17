From: Douglas Gilbert <dougg@torque.net>
Subject: Re: sg_remove and pending write request
Date: Tue, 17 Oct 2006 15:36:30 -0400
Message-ID: <453530BE.4030606@torque.net>
References: <0F08E10B769EAF4EA2C43A573B8CC87F60B323@NAMAIL3.ad.lsil.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:52927 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751187AbWJQTfE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Oct 2006 15:35:04 -0400
In-Reply-To: <0F08E10B769EAF4EA2C43A573B8CC87F60B323@NAMAIL3.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Qi, Yanling" <Yanling.Qi@lsi.com>
Cc: linux-scsi@vger.kernel.org

Qi, Yanling wrote:
> Hi All,
> 
> We are running a test case of SAS cable pull/push on a SAS RAID system.
> After the SAS cable is pulled from a SAS RAID, scsi devices are deleted.
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

> If this is the case, what the user space process do to prevent this from
> happening?

Develop a user space program that applies fast acting
super glue to the SAS connectors when IOs are in flight
and hands approach.

As I said above, you cannot assume device node names will
be stable across disconnect, reconnect cycles.

> I see that the sg.c sends SIGPOLL to the user space process
> (kill_fasync(&sfp->async_qp, SIGPOLL,POLL_HUP);), what this signal will
> be translated to the user space return-code from read/write call?

You would need to be running asynchronous IO with the
sg driver (i.e. write(),poll(),read() rather than SG_IO)
and POLLUP should appear in struct pollfd::revents .
You should also be able to run poll() from a signal handler
that catches SIGPOLL. [My knowledge is a bit rusty in this
area.]

Doug Gilbert


