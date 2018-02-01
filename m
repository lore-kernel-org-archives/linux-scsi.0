From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: RE: [LSF/MM TOPIC] irq affinity handling for high CPU count machines
Date: Thu, 1 Feb 2018 22:29:22 +0530
Message-ID: <a6bf37e1aa2c45ef725c4cc1a7f57af9@mail.gmail.com>
References: <45dc032d-a0ce-816c-d2c5-74c69433bd29@suse.de> <20180201150532.GA31930@ming.t460p>
 <0f650f4b-aa7f-bf52-2ecb-582761b4937f@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:34412 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752395AbeBAQ7Z (ORCPT
        <rfc822;Linux-scsi@vger.kernel.org>); Thu, 1 Feb 2018 11:59:25 -0500
Received: by mail-it0-f45.google.com with SMTP id m11-v6so551065iti.1
        for <Linux-scsi@vger.kernel.org>; Thu, 01 Feb 2018 08:59:24 -0800 (PST)
In-Reply-To: <0f650f4b-aa7f-bf52-2ecb-582761b4937f@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>
Cc: lsf-pc@lists.linux-foundation.org, "linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>, linux-nvme@lists.infradead.org

> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Thursday, February 1, 2018 9:50 PM
> To: Ming Lei
> Cc: lsf-pc@lists.linux-foundation.org; linux-scsi@vger.kernel.org; linux-
> nvme@lists.infradead.org; Kashyap Desai
> Subject: Re: [LSF/MM TOPIC] irq affinity handling for high CPU count
> machines
>
> On 02/01/2018 04:05 PM, Ming Lei wrote:
> > Hello Hannes,
> >
> > On Mon, Jan 29, 2018 at 10:08:43AM +0100, Hannes Reinecke wrote:
> >> Hi all,
> >>
> >> here's a topic which came up on the SCSI ML (cf thread '[RFC 0/2]
> >> mpt3sas/megaraid_sas: irq poll and load balancing of reply queue').
> >>
> >> When doing I/O tests on a machine with more CPUs than MSIx vectors
> >> provided by the HBA we can easily setup a scenario where one CPU is
> >> submitting I/O and the other one is completing I/O. Which will result
> >> in the latter CPU being stuck in the interrupt completion routine for
> >> basically ever, resulting in the lockup detector kicking in.
> >
> > Today I am looking at one megaraid_sas related issue, and found
> > pci_alloc_irq_vectors(PCI_IRQ_AFFINITY) is used in the driver, so
> > looks each reply queue has been handled by more than one CPU if there
> > are more CPUs than MSIx vectors in the system, which is done by
> > generic irq affinity code, please see kernel/irq/affinity.c.

Yes. That is a problematic area. If CPU and MSI-x(reply queue) is 1:1
mapped, we don't have any issue.

> >
> > Also IMO each reply queue may be treated as blk-mq's hw queue, then
> > megaraid may benefit from blk-mq's MQ framework, but one annoying
> > thing is that both legacy and blk-mq path need to be handled inside
> > driver.

Both MR and IT driver is (due to H/W design.) is using blk-mq frame work bu=
t
it is really  a single h/w queue.
IT and MR HBA has single submission queue and multiple reply queue.

> >
> The megaraid driver is a really strange beast;, having layered two
> different
> interfaces (the 'legacy' MFI interface and that from from
> mpt3sas) on top of each other.
> I had been thinking of converting it to scsi-mq, too (as my mpt3sas patch
> finally went in), but I'm not sure if we can benefit from it as we're
> still be
> bound by the HBA-wide tag pool.
> It's on my todo list, albeit pretty far down :-)

Hannes, this is typically same in both MR (megaraid_sas) and IT (mpt3sas).
Both the driver is using shared HBA-wide tag pool.
Both MR and IT driver use request->tag to get command from free pool.

>
> >>
> >> How should these situations be handled?
> >> Should it be made the responsibility of the drivers, ensuring that
> >> the interrupt completion routine is terminated after a certain time?
> >> Should it be made the resposibility of the upper layers?
> >> Should it be the responsibility of the interrupt mapping code?
> >> Can/should interrupt polling be used in these situations?
> >
> > Yeah, I guess interrupt polling may improve these situations,
> > especially KPTI introduces some extra cost in interrupt handling.
> >
> The question is not so much if one should be doing irq polling, but rathe=
r
> if we
> can come up with some guidance or even infrastructure to make this happen
> automatically.
> Having to rely on individual drivers to get this right is probably not th=
e
> best
> option.
>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke		   Teamlead Storage & Networking
> hare@suse.de			               +49 911 74053 688
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton HRB=
 21284
> (AG N=C3=BCrnberg)
