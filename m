From: Luben Tuikov <luben@splentec.com>
Subject: Re: [patch 2.5] ips queue depths
Date: Tue, 15 Oct 2002 19:56:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DACAB12.539058BD@splentec.com>
References: <A3B9245C291EEF4785A24A1DBE8D852B0376BC@rtpexc01.adaptec.com> <20021015194705.GD4391@redhat.com> <20021015130445.A829@eng2.beaverton.ibm.com> <20021015205218.GG4391@redhat.com> <20021015163057.A7687@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from splentec.com (canoe.splentec.com [209.47.35.250])
	by pepsi.splentec.com (8.11.6/8.11.0) with ESMTP id g9FNu1f28812
	for <linux-scsi@vger.kernel.org>; Tue, 15 Oct 2002 19:56:01 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

> > > The queue depth should be as small as possible without limiting the
> > > performance.
> >
> > Which happens to be a magic number that no one really knows I think ;-)
> 
> Yes, but that implies that adapters should not be relied upon to set
> the queue depth. If the adapter is setting queue depth based upon what
> the adapter knows, that is completely wrong - a regular disk and disk
> array can end up with the same queue depth (this is not ture for raid
> cards like ips, where the adapter is the device).

If I'm reading this correctly, does this bash the ability to set the
queue depth by the LLDD?

This ability is ESSENTIAL, especially in the light of newer devices
coming into play. E.g. just imagine what kind of storage magic you can
do with an iSCSI Initiator(*) connected to fiber using LUN masking... and
setting the queue depth to 50 would be just <your fav. methaphor>. 

* This of course uses 64 bit LUN transparently (as an interconnect)...

> > Current goals of the work I'm doing include making this adjustable so you
> > aren't wasting queue depth on devices that have a hard limit less than
> 
> But, this won't lower it to some optimal magic number.

No, it won't. But that is NOT the point.

All he is saying is that it will allow for the MECHANISM,
and leave the policy to some other entity/entities to decide...

As far as I remember THIS is the whole beauty of the UNIX/Linux paradigm.
 
> It would nice to have more device model/kernfs device attributes.
> 
> With your new queueing code, if we expose and allow setting new_queue_depth,
> user code can easily modify the queue depth.

Not bloody likely. To use the language of the other LT, this would be ``braindead''.

Linux is not a research project for someone to write a shell script
and expriment with different device tag queue depths from user space.

This will KILL the whole point of the matter. This should be a kernel issue.

This is the whole point of having and Operating System, (pause) and having
Device Drivers.

User space should NOT be concerned about this at all.

This is a kernel issue and the more you give userspace to play with kernel
issues the more the OS will degrade. That is, the user/kernel space border
should be clearly marked, so that both sides are happy.

If you don't believe me, ask Linus.
 
> I wanted to write some code in this area but don't have enoough time. It would
> not be hard to have a scsi_sdev_attrs.c file, that using macros could
> automagically create device attr files and functions for any selection of
> Scsi_Device fields. Locking might be an issue - since we don't have a
> Scsi_Device lock for queue depth, just one big lock, this is true for
> some of the other Scsi_Device fields.

Overengineering would not lead to good things, definitely not. On the long run,
and given the fact that so many subsystems come into play.

Let's keep the SCSI subsystem lean and clean, else the other block subsystem's
path awaits us...
 
-- 
Luben
