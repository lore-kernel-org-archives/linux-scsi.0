From: Paul McKenney <Paul.McKenney@us.ibm.com>
Subject: Re: [patch for playing] Patch to support 4000 disks and maintain backward
 compatibility
Date: Fri, 11 Apr 2003 18:13:24 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFAD4FBC86.382E53DF-ON88256D06.0006AAF3@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:30147 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S262219AbTDLBFy (for <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Apr 2003 21:05:54 -0400
List-Id: linux-scsi@vger.kernel.org
Cc: Andries.Brouwer@cwi.nl, James.Bottomley@steeleye.com, linux-kernel@vger.kernel.org, linux-kernel-owner@vger.kernel.org, linux-scsi@vger.kernel.org, pbadari@us.ibm.com





> > It would also be nice for numeric compatibility to be a compile time
option
>
> It sounds as if you expect a lot of old cruft.
> But the compatibility code is just ten lines or so.
> Internally the kernel has an index. Externally there is a dev_t.
> At open() time the dev_t is converted. At registration time
> sd announces interest in three or four dev_t regions.
> That is all.

Some compatibility needs more code than other compatibility.
The desired compatibility includes the following, much of which
has been noted earlier in this thread, and some of which may
need to wait for multipath I/O and other of which might be best
provided by a volume manager:

o     It must be possible to switch between 2.4 and 2.5/6
      kernels without a given disk's name changing.

o     New 2.5/6 installations should se a clean disk naming
      scheme without historical cruft.

o     Removing or adding one disk should not affect the
      names of other disks.  Ideally, moving a given disk
      from one place to another should not change its
      name.  "The good news is that we repaired your
      disk.  The bad news is that, due to the resulting
      name changes, your application thoroughly
      corrupted all of its data."

o     Adding or removing a FC or SCSI adapter should not
      affect the names of disks hanging off of other
      FC or SCSI controllers.  Ideally, the name of
      a disk should not change when its FC or SCSI
      controller is moved from one slot to another.

o     Failures of or repairs to the FC fabric should
      not change the names of any of the disks (though
      a sufficiently thorough failure might make some
      of the disks unreachable).

o     Cluster nodes should ideally have the same name
      for a given disk.  Extra credit, though greatly
      appreciated by anyone who has ever had to deal
      with a cluster where different nodes have different
      names for the same disk.  ;-)

                              Thanx, Paul

