From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: Calling scsi_add_host multiple times for concurency
Date: Thu, 10 Mar 2011 13:41:12 -0600
Message-ID: <1299786072.11933.162.camel@mulgrave.site>
References: <AANLkTinKxORC1P0zY6LUupUU89WTAsN_FQ+dPhjtw6EW@mail.gmail.com>
	 <AANLkTikKbsoSmfoW9Ma7agW4SFBPEFPPPp7QeB_+9i0H@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:52851 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125Ab1CJTlT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Mar 2011 14:41:19 -0500
In-Reply-To: <AANLkTikKbsoSmfoW9Ma7agW4SFBPEFPPPp7QeB_+9i0H@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: va stg2010 <va.storage2010@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 2011-03-10 at 08:35 -0800, va stg2010 wrote:
> Hi
> My initiator HBA  has 4 ports. Right now  I call scsi_add_host() only once.
> Currently I have single queue for all 4 ports where  pending scsi
> commands wait till interrupt handler posts response.  I am trying to
> add more queue (one per port) to reduce some locking contention.

Why do you have a single issue queue?  If the contention is in that,
then you can easily fix that without altering the host structure.

> Can I expect higher concurrency if I call scsi_add_host 4 times , one
> for each port. ?
> Is it going to work if I call scsi_add_host  4 times and  will
> allocate queue (for pending scsi commands) for each scsi host I
> registered?

Um, so this makes me think you don't understand the SCSI queuing.  The
block queue is per registered sdev (which is usually a LUN) not per
host.  However, pending commands aren't kept on the block queue: we
dequeue them in the request queue.

> What performance benefits can I expect, if any?

SCSI counts things per host, Like maximum number of commands.  It
doesn't really impact concurrency, since that's done per queue (which is
per LUN) but it does mean there's a per-host lock in the submit path
which can show up in profiling (particularly for high iop devices).

James


