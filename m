From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: linux kernel security issuse scsi_report_lun_scan report
Date: Sat, 21 Nov 2015 09:20:01 -0800
Message-ID: <1448126401.2173.7.camel@HansenPartnership.com>
References: <8159e011-35a9-4952-a0ef-be4dfb13983f.chengmiao.cj@alibaba-inc.com>
	 <CA+55aFyn44rDnv3E9sSg_YGfeqhExvGz8yeAANU-BVghDHRFdA@mail.gmail.com>
	 <1448044014.2168.34.camel@HansenPartnership.com>
	 <CA+55aFxuts9UQb3XAVzq8TWQbfgBvftn_iOvo5+qb10RT65mrg@mail.gmail.com>
	 <1448053036.2168.46.camel@HansenPartnership.com>
	 <CA+55aFwHzeWy8oqMkscR0OLnk8Cq3cFGvZCsaHR4iNWL98mqpQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45342 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751431AbbKURUE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Nov 2015 12:20:04 -0500
In-Reply-To: <CA+55aFwHzeWy8oqMkscR0OLnk8Cq3cFGvZCsaHR4iNWL98mqpQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>

On Fri, 2015-11-20 at 13:24 -0800, Linus Torvalds wrote:
> On Fri, Nov 20, 2015 at 12:57 PM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> >
> > It's done under the scan mutex, so there can only be one thread in that
> > code at once.
> 
> Hmm. Looking at the call chain seems to confirm that.
> 
> But looking at the call chain I _also_ see that we have
> scsi_free_host_dev() there, which seems to be some stale frame data
> from a previous scan.
> 
> I'm wondering if that is a clue.  I find exactly two callers of that
> functions, both in the gdth driver.

The trace seems to indicate this is virtio_scsi.  A few people do have
gdth but I would be highly surprised if some type of checker system had
one (they're usually only present in ancient systems). I suspect the
callback unwinding is incorrect meaning the identified callsites are a
bit unreliable.

Just in case, I checked the init path of gdth to see if it would
allocate a host device if compiled in with no hw on the ISA path, but it
doesn't seem to (the ISA probe will fail first).  Having the system logs
will confirm this ... there's a specific print it will display if they
succeeded:

	printk("Configuring GDT-ISA HA at BIOS 0x%05X IRQ %u DRQ %u\n",
		isa_bios, ha->irq, ha->drq);


> Maybe this is some odd refcount bug, brought on by reuse of a sdev.
> Would that make more sense?

That's what I was wondering ... something happens in one probe to leave
the device, so it's reused by the next.  However, in that case, the
identified put wouldn't be final unless something had deliberately
pinned and then released the sdev.

virtio SCSI does have a lot of scsi_device_lookup() scsi_device_put()
pairs ... it might possibly be one of those.

> Why is that scsi_free_host_dev() used only by that one driver, and
> nobody else wants it or needs it?

Can we get the reporter to explain what they were doing at the time?
Just bringing up a VM with a virtio_scsi root or something else?

If you just cc the reporter on this thread, we can take it from here.

James


