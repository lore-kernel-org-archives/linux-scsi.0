From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Notes from the four separate IO track sessions at LSF/MM
Date: Wed, 27 Apr 2016 16:39:49 -0700
Message-ID: <1461800389.2311.70.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55224 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752195AbcD0Xjw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Apr 2016 19:39:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-block@vger.kernel.org, device-mapper development <dm-devel@redhat.com>
Cc: lsf@lists.linux-foundation.org

This year, we only had two scribes from LWN.net, not three, so there
won't be any coverage of the IO track when we split into three tracks. 
 To cover for that, here are my notes of the four separated sessions

===

Multiqueue Interrupt and Queue Assignment; Hannes Reinecke
----------------------------------------------------------

All multiqueue devices need an interrupt allocation policy and an
affinity but who should set it?  Christoph Hellwig suggested making
what NVMe currently does the default (and has patches).

There then followed a discussion about interrupt allocation which
concluded that realistically, we do want the block layer doing it
because having a single policy for the whole system is by far the
simplest mechanism.  We should wait for evidence that this can't be
made to work at all (which we don't have) before we try to tamper with
it.


Blk-mq Implementor Feedback; Hannes Reinecke, Matthew Wilcox, Keith Busch
-------------------------------------------------------------------------

This began with a discussion of tag allocation policy: blkmq only
allows for a host wide tag space which is partitioned amongst the
number of hardware queues.  Potentially this leads to a tag starvation
issue where the number of host tags is small and the number of hardware
queues is large.  Consensus was that the problem is currently
theoretical but that driver writers should take care to make sure they
don't allocate too many hardware queues if they have a limited number
of tags.

The next problem was abort because of a potential tag re-use issue. 
 After discussion it was agreed there should be no problem because the
tag is held until the abort completes (and the command killed) or error
handling is escalated (in which case the whole host is quiesced). 
 There was a lot of complaining about the host quiesce part because it
takes a while to do on a fully loaded host and also path switchover
cannot occur until it has been completed, so multipath recovery takes
much longer than it should.  The general agreement was that this could
be alleviated somewhat if we could quiesce a single LUN first and issue
a LUN reset rather than doing the whole host after the abort.  Mike
Christie will send patches for LUN quiescing.


IO Cost Estimation; Tejun Heo
-----------------------------

This session began with a description of how the block cgroup currently
works: it has two modes: bandwidth limiting which works regardless of
I/O scheduler and proportional allocation, which only works with the
CFQ I/O scheduler.  Obviously, because blk-mq currently has no
scheduler, it's not possible to do proportional allocation with it. 
 The generic discussion then opened with how do we do correct I/O cost
estimation even with blk-mq so we can do some sort of proportional
allocation.  This is actually a very hard problem to solve,
particularly now that we have to consider SSDs because a large set of
sequential writes are much less likely to excite the write
amplification caused by garbage collection than a set of scattered
writes.  In an ideal world, we'd like to penalise the process doing the
scattered writes for all of the write amplification as well.  However,
after much discussion, it was agreed that the heuristics to try to do
this would end up being very complex and would likely fail in corner
cases anyway, so the best we could do was assess proportions based on
request latency, even though that would not be completely fair to some
workloads.

Multipath - Mike Snitzer
------------------------

Mike began with a request for feedback, which quickly lead to the
complaint that recovery time (and how you recover) was one of the
biggest issues in device mapper multipath (dmmp) for those in the room.
  This is primarily caused by having to wait for the pending I/O to be
released by the failing path. Christoph Hellwig said that NVMe would
soon do path failover internally (without any need for dmmp) and asked
if people would be interested in a more general implementation of this.
 Martin Petersen said he would look at implementing this in SCSI as
well.  The discussion noted that internal path failover only works in
the case where the transport is the same across all the paths and
supports some type of path down notification.  In any cases where this
isn't true (such as failover from fibre channel to iSCSI) you still
have to use dmmp.  Other benefits of internal path failover are that
the transport level code is much better qualified to recognise when the
same device appears over multiple paths, so it should make a lot of the
configuration seamless.  The consequence for end users would be that
now SCSI devices would become handles for end devices rather than
handles for paths to end devices.

James

