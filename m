From: jassduec@gmail.com
Subject: Re: TCQ depth of aic7xxx
Date: Wed, 16 Aug 2006 22:30:57 -0500
Message-ID: <3a1eedb70608162030q44123f9csc3d51039c969bb8c@mail.gmail.com>
References: <3a1eedb70608160501l1637a01ai97faadbe6ea5620f@mail.gmail.com>
	 <1155730591.3023.31.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:13188 "EHLO
	nf-out-0910.google.com") by vger.kernel.org with ESMTP
	id S1751265AbWHQDa7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Aug 2006 23:30:59 -0400
Received: by nf-out-0910.google.com with SMTP id o25so841899nfa
        for <linux-scsi@vger.kernel.org>; Wed, 16 Aug 2006 20:30:57 -0700 (PDT)
In-Reply-To: <1155730591.3023.31.camel@laptopd505.fenrus.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-scsi@vger.kernel.org

Thanks for the reply.

Yeah, I have a raid array connected to the SCSI interface. There are
two raidgroups in the array using RAID 5. Each raidgroup consists of
5-6 disks and one LUN over the entire raidgroup. The LUNs have been
partitioned at the OS level into different partitions. The storage
system has a battery protected cache of 16 MB. What range of values of
TCQ depth would be good enough in such a scenario? I want that the
SCSI HBA not be the bottleneck and get the maximum out of the storage
system.

TIA

On 8/16/06, Arjan van de Ven <arjan@infradead.org> wrote:
> On Wed, 2006-08-16 at 06:01 -0600, jassduec@gmail.com wrote:
> > Hi All,
> >
> > Is there a good reference on tuning the TCQ depth parameter of the
> > module aic7xxx. I am using an adaptec's SCSI card and would like to
> > tune the module parameters to get the best possible I/O rate. Any help
> > in this regard would be highly appreciated.
>
> Hi,
>
> unless you have a raid array connected with multiple disks, keeping the
> TCQ value low (say 3 or 4) is probably best. This low TCQ value (just
> don't pick 1, since that introduces some latency) allows the kernel
> elevator to do a lot more work, and both merge ios better as well as
> taking care of fairness.... giving you a good mix of performance and
> fairness. High TCQ values mean that the IO's leave the linux queue too
> quickly (and just end up in the disks queue instead). Linux has more
> options for optimization than the disk has (the disk is constrained by
> both a relatively simple brain, and by various ordering and grouping
> rules imposed by the scsi specification), so giving the kernel more
> chance to optimize is going to be best.
>
> Now if you have a raid array connected, the balance is different, since
> "3 or 4" isn't going to be enough to keep all spindles in the raid array
> busy; in that case I'd recommend a much higher value, especially if the
> raid array has battery backed ram (which means write can be completed
> instantaneously).
>
> Greetings,
>     Arjan van de Ven
> --
> if you want to mail me at work (you don't), use arjan (at) linux.intel.com
>
>
