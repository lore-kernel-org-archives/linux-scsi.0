From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] 3/7 consolidate single_lun code
Date: Fri, 28 Mar 2003 12:06:44 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030328120644.A20061@beaverton.ibm.com>
References: <20030324175337.A14957@beaverton.ibm.com> <20030324175422.A14996@beaverton.ibm.com> <20030324180227.A15047@beaverton.ibm.com> <20030324180247.B15047@beaverton.ibm.com> <3E80BDC3.7000503@splentec.com> <20030326111146.A3548@beaverton.ibm.com> <3E822415.2080306@splentec.com> <20030327144326.A14457@beaverton.ibm.com> <3E8465A2.7020501@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E8465A2.7020501@splentec.com>; from luben@splentec.com on Fri, Mar 28, 2003 at 10:09:22AM -0500
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: linux-scsi@vger.kernel.org

On Fri, Mar 28, 2003 at 10:09:22AM -0500, Luben Tuikov wrote:
> Patrick Mansfield wrote:
> > On Wed, Mar 26, 2003 at 05:05:09PM -0500, Luben Tuikov wrote:

> You see, all I'm doing is trying to come up with a suitable ADT
> and algorithm for the premise which _you_ gave.
> 
> The problem is that you have no fixed arbitration criterium between single
> lun and fully capable targets.  If you did, it's a little thing to get
> the sinlge list as priority queue working.
> 
> I.e. What I'm asking is this: _even_ if you had 2 lists, one
> for sinlge lun and another for fully capable targets,
> how would you arbitrate between the two in scsi_request_fn().

OK I see your point, and I don't have an answer.

So we should be able to put single_lun sdev's on the starved_list, and
maintain the same priority (current scsi-locking-2.5 with all 7 patches
applied runs single_lun queue's, and then runs starved queues; it puts all
devices on the starved_list if the can_queue or other host limits are hit;
no device is put on the starved_list unless it is unable to send IO).

I'm working on getting rid of the lock hierarchy now, I would rather not
touch any more of the single_lun code (I would rather such devices go
away). If you or anyone can submit a patch (against the scsi-lock-2.5) for
single_lun code to use the starved_list that would be nice :)

I tested the single_lun code by booting with scsi_dev_flags=vend:prod:0x10
for some of the disks on my system, or you can modify the scsi_scan.c
table.

I'm not sure if we can ever prioritize the starved_list (holding a list of
sdev's or their request functions) without locking out one or the other of
the single lun or starved devices.

We might need a per-target or per-host queue (of requests, not of sdev's)
to fix it properly. A per-target (or per-host?) queue might also allow an
easier fix to prevent a one single_lun device from starving all others. I
would rather leave this as a broken hardware or bad configuration, the fix
is to get rid of the single_lun hardware, or only attach one of them
(target) to an adapter.

In any case the starved_list patch is an improvement over previous
handling for the starved cases, and for single_lun cases we should not be
any worse than before.

-- Patrick Mansfield
