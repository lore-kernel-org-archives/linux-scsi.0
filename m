From: Luben Tuikov <luben@splentec.com>
Subject: Re: [patch 2.5] ips queue depths
Date: Thu, 17 Oct 2002 17:13:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DAF27FB.7F3E18A6@splentec.com>
References: <A3B9245C291EEF4785A24A1DBE8D852B0376BC@rtpexc01.adaptec.com> <20021015194705.GD4391@redhat.com> <20021015130445.A829@eng2.beaverton.ibm.com> <20021015205218.GG4391@redhat.com> <20021015163057.A7687@eng2.beaverton.ibm.com> <20021016023231.GA4690@redhat.com> <20021016120436.A1598@eng2.beaverton.ibm.com> <3DAE06B9.FBB60D49@splentec.com> <20021017170115.GA4558@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from splentec.com ([24.43.247.227])
          by fep04-mail.bloor.is.net.cable.rogers.com
          (InterMail vM.5.01.05.06 201-253-122-126-106-20020509) with ESMTP
          id <20021017211312.NNWX4298.fep04-mail.bloor.is.net.cable.rogers.com@splentec.com>
          for <linux-scsi@vger.kernel.org>; Thu, 17 Oct 2002 17:13:12 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Mike Anderson wrote:
> 
> Luben Tuikov [luben@splentec.com] wrote:
> > Even if you have little memory (thin client) it makes sense to have a TCQ depth
> > of 200 if you're connected to a monster storage system, since if you send
> > 200 tagged commands to /dev/sda they may NOT necessarily go to one ``device''.
> > Imagine that!
> 
> Just because a device can accept a command and not return busy does not
> mean it is always a good thing to give it 200 commands. Most larger
> arrays will have dynamic queue depths and accept a lot of IO without
> really working on it. If the delta of time is increasing on your IO than
> at some point you are inefficient. We have already seen on some adapters
> that reducing the queue depths achieved the same amount of IO rate with
> reduced CPU overhead. Which is a good thing as users usally want to do
> something else besides IO.

I repeat again: those commands will NOT go to the same device, but
after tier one, they'll be sent out to different devices and
probably execute concurrently, and come back out of order,
at which point the interconnect will (may) order them, before
returning status.

> If you are using shared resources (i.e. sg_table pool mem, the above
> suggested scsi command poll, timers, etc) to avoid resource starvation
> you might need to set limits outside of what a single LLDD believes is
> best. More efficient implementations would also reduce some of the
> overhead.
> 
> A administrator may want to adjust the overall policy for a specific
> work load. Maybe proper values can be set and feedback information can
> allow self adjustment, but there are probably workloads that the
> values are incorrect. What that policy is would depend on the resources.
> Something similar to vm adjustments.

Cannot comment on general statements like this.
A more concrete example would be needed.

-- 
Luben
