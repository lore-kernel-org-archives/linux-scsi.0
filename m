From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [RFC][PATCH] scsi-misc-2.5 software enqueue when can_queue reached
Date: Wed, 5 Mar 2003 10:43:20 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030305104320.A14722@beaverton.ibm.com>
References: <20030228111924.A32018@beaverton.ibm.com> <1046833360.2757.43.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1046833360.2757.43.camel@mulgrave>; from James.Bottomley@steeleye.com on Wed, Mar 05, 2003 at 04:02:38AM +0100
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, Mar 05, 2003 at 04:02:38AM +0100, James Bottomley wrote:
> 
> Could you elaborate on why a pending_queue (which duplicates some of the
> block layer queueing functionality that we use) is a good idea.

> Under the current scheme, we prep one command beyond the can_queue limit
> and leave it in the block queue, so the returning commands can restart
> with a fully prepped command but we still leave all the others in the
> block queue for potential elevator merging. 

Note that if we go over can_queue performance can suffer no matter what we
do in scsi core. If the bandwidth or a limit of the adapter is reached, no
changes in scsi core can fix that, all we can do is make sure each
scsi_device can do some IO. So, we are trying to figure out a good way to
make sure all devices can do IO when can_queue is hit.

(Not sure if you implied the following change) The host pending_cmd queue
could be replaced in the future with a (block) request queue for each
LLDD, without much change in function - we would still have to pull
requests off of the scsi_device queue before putting them into any LLDD
request queue, so we still would not be able to leave requests in the
scsi_device queue.  We could try to "sort" the LLDD queue so we have a mix
of scsi_devices represented, but that could lead to other issues.

Going to a block request queue now might be hard - it would likely need a
further separation of scsi_device and scsi_host within scsi core (in the
request and prep functions, and in the IO completion path).

With multiple starved devices with IO requests pending for all of them,
the algorithm we have now (assuming it worked right) can unfairly allow
each scsi_device to have as many commands outstanding as it did when we
hit the starved state.

The current algorithm could be fixed and throttling added.

Today, many of the host adapter drivers avoid the can_queue issue by
limiting the queue_depth (such as ips.c), or by having their own software
queue (qlogic's qla driver).

Pros of a host pending_cmd queue versus throttling across (effectively) a
queue of queues:

1) Simpler (and perhaps faster) code.

2) We don't need any throttling, and can always keep can_queue IO's in
flight. With per-host throttling, we sometimes must keep the number of
IO's in flight below can_queue in order to be fair (in cases where one
device is busier than another; there could be a way around this, but I
haven't figured it out).

3) The queue_depth setting can be used to limit IO across scsi_devices on
a single adapter - if you are hitting can_queue, setting a lower
queue_depth for some devices will affectively lower the bandwidth
available to them. (Given we can modify these on a per scsi_device basis;
I would really like a writable sysfs sdev->queue_depth).

4) Allows better separation of scsi_device code from scsi_host, for
example, it simplifies going to a per-device queue lock.

Cons:

1) Does not leave leave devices on the block queue so they can be
merged/sorted with incoming commands.

2) Might lead to grouping of IO per scsi_device rather than spreading IO
across all devices. Hopefully this would balance out over the long term or
not degrade performance at all (for sequential IO it might speed things
up, but for random it might slow down), and over a long period and with
random enough (across scsi_device queues, not within a given queue) IO
patterns, we would end up spreading IO across all queues.

Given that we are talking about what to do when a hardware limit is
reached (can_queue) I would rather go with the simpler approach.

-- Patrick Mansfield
