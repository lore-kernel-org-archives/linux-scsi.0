From: Doug Ledford <dledford@redhat.com>
Subject: RE: Kernel 2.6.x hangs with Symbios Logic 53c1010 Ultra3 SCSI
	Adapter
Date: Mon, 08 Nov 2004 10:38:33 -0500
Message-ID: <1099928314.10944.81.camel@compaq-rhel4.xsintricity.com>
References: <04Nov8.094419est.332239@cyborg.cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:14724 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S261905AbUKHPii (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2004 10:38:38 -0500
In-Reply-To: <04Nov8.094419est.332239@cyborg.cybernetics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tonyb@cybernetics.com
Cc: 'Thomas Babut' <thomas@babut.net>, linux-scsi mailing list <linux-scsi@vger.kernel.org>, 'Matthew Wilcox' <matthew@wil.cx>

On Mon, 2004-11-08 at 09:44 -0500, Tony Battersby wrote:
> > Finally, there are devices out there that do target initiated speed
> > negotiations.  If we get an incoming PPR message from a device
> 
> The spec says:
> 
> "PPR may be originated by SCSI initiator ports but shall not be
> originated by SCSI target ports."

Yeah, what the spec says and what devices do are not always one and the
same thing.

> "WDTR and SDTR may be originated by either SCSI target ports or SCSI
> initiator ports."
> 
> Unless someone has seen a counter-example, the case of target-originated
> PPR negotiations can probably be ignored.

DEC SCSI-2 hard disks that were installed with modified firmware.
Specifically, the Vaxen class computers they were hooked up to A) didn't
expect and handle SCSI-3 devices properly, B) didn't handle the DT bit
in the INQUIRY data properly, C) but DEC still wanted the devices to
talk 160MByte/s transfer rates, so the firmware was modified to send
preemptive PPR messages.  Problem solved something like 4 years ago, but
it existed at the time and physical devices may still exist in the
field.  In any case, yeah, the spec says otherwise, but I wouldn't rely
on that since getting this wrong leads to an infinite speed negotiation
loop.  Infinite loops suck...better safe than sorry on this issue IMO.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc.
         1801 Varsity Dr.
         Raleigh, NC 27606


