From: David Dillow <dillowda@ornl.gov>
Subject: Re: [PATCH 13/14] ib_srp: Implement transport layer ping
Date: Mon, 19 Dec 2011 17:32:11 -0500
Message-ID: <1324333931.7043.52.camel@lap75545.ornl.gov>
References: <201112011954.25811.bvanassche@acm.org>
	 <201112012011.45444.bvanassche@acm.org>
	 <1324255806.17849.68.camel@obelisk.thedillows.org>
	 <CAO+b5-o+-JF61a+8vFWj1rxMuVWuG-CVLQKorr5cKzi-Kc44Ag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta02.ornl.gov ([128.219.14.62]:56174 "EHLO mta02.ornl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827Ab1LSWcP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Dec 2011 17:32:15 -0500
In-Reply-To: <CAO+b5-o+-JF61a+8vFWj1rxMuVWuG-CVLQKorr5cKzi-Kc44Ag@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Roland Dreier <roland@purestorage.com>, Fujita Tomonori <fujita.tomonori@lab.ntt.co.jp>, Brian King <brking@linux.vnet.ibm.com>

On Mon, 2011-12-19 at 05:16 -0500, Bart Van Assche wrote:
> On Mon, Dec 19, 2011 at 12:50 AM, David Dillow <dillowda@ornl.gov> wrote:
> > On Thu, 2011-12-01 at 20:11 +0100, Bart Van Assche wrote:
> >> Add a time-based transport layer test such that fail-over in a multipath
> >> setup can happen quickly.
> >
> > Why should this be done in the kernel? multipathd already verifies all
> > paths to a SCSI device are up and that the device is reachable.
> 
> I'm afraid it's impossible to make a transport layer check work
> reliably from user space. As an example, srp_reset_host() blocks the
> SCSI host before reconnecting. Before starting to attempt to
> reconnect, that action does block the SCSI host and hence also all
> transport layer checks issued from user space. I doubt it's possible
> to fix the resulting race between a transport layer reconnect issued
> from srp_reset_host() and a transport layer reconnect triggered from
> user space.

Part of the problem is introduced by allowing for permanent connections
rather than using the familiar dev_loss_tmo and fast_io_fail_tmo
parameters from other SCSI transports. For instance, in the FC
transport, rports are allowed to disappear for up to dev_loss_tmo
seconds before being removed from the SCSI device tree. Until they have
been gone for fast_fail_io_tmo seconds, they are blocked (as is error
handling to prevent offlining devices). Once they have been gone longer
that fast_fail_io_tmo, they become unblocked and new IO will be failed.

Now, the FC transport is probably a bit more complex than we want right
now, but following it (and the SAS transport's) lead should keep us in
sync with where the rest of the SCSI stack is headed.

As for reliability from user space, multipathd checks that the SCSI
initiator is not blocked before checking the liveness of the path;
blocked paths are assumed to be down. It still seems to default to a 30
second timeout for the test TUR/directIO/etc check, and that doesn't
currently look to be configurable (fixable). These timeouts are
independent of the SCSI layer, and will mark a path down for new traffic
without waiting for the lower level timeout.

The transport layer reconnect from user space (I'm assuming you were
thinking ioctl or using the sg device) would coordinated by the
SCSI-midlayer, using calls to srp_reset_host(), so I think we avoid any
race condition. Or did you mean a manual reconnect attempt from
manipulating srp_host/X/reconnect_tmo via sysfs -- in which case it is
in our code, so we can certainly avoid race conditions.

I still think this is already solved in user space, but the new
reconnect model you've implemented doesn't match up with the expected
semantics. It'd be better to match the rest of the SCSI stack for this.
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

