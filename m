From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH]: Flexible timeout infrastructure
Date: Tue, 15 Jun 2004 12:27:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40CF2381.30707@adaptec.com>
References: <40CF0F9F.4050902@adaptec.com> <1087313241.2710.40.camel@laptop.fenrus.com> <40CF1852.6030306@adaptec.com> <20040615154313.GA25397@devserv.devel.redhat.com> <40CF1A5D.30908@adaptec.com> <20040615155716.GA14017@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:51417 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S265760AbUFOQ1t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jun 2004 12:27:49 -0400
In-Reply-To: <20040615155716.GA14017@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Arjan van de Ven <arjanv@redhat.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Christoph Hellwig wrote:
> Well, the question is always what is so special about your driver that
> it doesn't benefit from beeing in a common library.  I've pulled more crap
> out of individual drivers than I'd ever want to imagine, and because of
> that I'm pretty much allergic against giving driver writers more control
> then nessecary.

We are *not* talking about programming here, recognizing patterns
and modularizing them.

We are talking about _recovery_.  And this method is OPTIONAL.

The mere _procedure_ which will get executed when eh_cmd_timed_out()
is called may *not* be always be readily "pulled out". It maybe a quirk
in the: transport; target (vendor, etc); LUN; HBA (vendor, etc), etc,
for which _only_ the LLDD would know.  It may also be a specific
interconnect _recovery_ (e.g. USB, iSCSI, RDMA).  It may also be
a specific _vendor_ recovery, as is possible for iSCSI.

This kind of thing you _cannot_ generalize and "pull out". Just sit
down with a vendor and write a LLDD and you will see that there's cases
where there's no way to pull this up into a nice generalized
method, because certain defects are not always known, or too complicated
or vendor specific or non-open, etc.  The possibilies are far too many
and touch far too many areas (hw bugs, fw bugs, protocol recovery,
vendor specific protocol recovery, etc).

This infrastructure is non-intrusive (minimal patch), optional,
and SCSI Core is still in control every step of the way.  It really
is not that big of a deal, but would make wonders to SCSI Core
in the hands of capable drivers.  Granted not all would be capable of
using this, but those that would be, would definitely _improve_ recovery.

-- 
Luben


