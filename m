From: David Dillow <dillowda@ornl.gov>
Subject: Re: [PATCH 13/14] ib_srp: Implement transport layer ping
Date: Tue, 20 Dec 2011 22:05:36 -0500
Message-ID: <1324436736.7621.38.camel@obelisk.thedillows.org>
References: <201112011954.25811.bvanassche@acm.org>
	 <201112012011.45444.bvanassche@acm.org>
	 <1324255806.17849.68.camel@obelisk.thedillows.org>
	 <CAO+b5-o+-JF61a+8vFWj1rxMuVWuG-CVLQKorr5cKzi-Kc44Ag@mail.gmail.com>
	 <1324333931.7043.52.camel@lap75545.ornl.gov>
	 <CAO+b5-r4AZymMkVyFSXbBzpcc86hL0RJm2j3FnT3=uXSLUkj9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from matrix.voodoobox.net ([75.127.97.206]:37914 "EHLO
	matrix.voodoobox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab1LUDFs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Dec 2011 22:05:48 -0500
In-Reply-To: <CAO+b5-r4AZymMkVyFSXbBzpcc86hL0RJm2j3FnT3=uXSLUkj9A@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Roland Dreier <roland@purestorage.com>, Fujita Tomonori <fujita.tomonori@lab.ntt.co.jp>, Brian King <brking@linux.vnet.ibm.com>

On Tue, 2011-12-20 at 10:27 +0000, Bart Van Assche wrote:
> On Mon, Dec 19, 2011 at 10:32 PM, David Dillow <dillowda@ornl.gov> wrote:
> > Part of the problem is introduced by allowing for permanent connections
> > rather than using the familiar dev_loss_tmo and fast_io_fail_tmo
> > parameters from other SCSI transports. For instance, in the FC
> > transport, rports are allowed to disappear for up to dev_loss_tmo
> > seconds before being removed from the SCSI device tree. Until they have
> > been gone for fast_fail_io_tmo seconds, they are blocked (as is error
> > handling to prevent offlining devices). Once they have been gone longer
> > that fast_fail_io_tmo, they become unblocked and new IO will be failed.
> 
> I'm not convinced an equivalent of fast_fail_io_tmo is necessary for
> the SRP transport. If a target disappears briefly from the IB fabric
> what will happen with the posted patch series is that the initiator is
> blocked during one ping interval and also that a reconnect is
> triggered. Also, some SCSI commands may be reissued after
> reconnecting. But that shouldn't have any adverse consequences, isn't
> it ?

We don't want to leave a target blocked indefinitely -- commands caught
in the blocked queue won't be reissued until the queue is unblocked --
but we may want to keep the sdX mappings around for a long time.
fast_io_fail_tmo gives us the ability to do that -- the expiration of
fast_io_fail_tmo unblocks the queue and allows commands to be failed due
to the transport error. See commit f2818663.

Also, these settings can be used to help tune multipath failover for
devices with relatively long LUN transfer times (say with RDAC) vs short
ones (ALUA). You still don't want the mappings to go away, but you want
to move data to the other paths in a reasonably quick fashion.
http://lkml.org/lkml/2008/1/7/244 talks about this a bit.

As for reissued commands, most shouldn't be an issue -- once they get
out of the blocked queue. I would expect there to be problems with
certain vendor specific commands, and tape drives will have issues, but
those are common to any multipath solution.
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

