From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Linux 3.0 oopses when pulling a USB CDROM
Date: Sun, 3 Jul 2011 20:16:15 +0200
Message-ID: <20110703181615.GC15637@one.firstfloor.org>
References: <1309609482.2554.8.camel@mulgrave> <Pine.LNX.4.44L0.1107021320180.14703-100000@netrider.rowland.org> <CAA9_cmd7KV_CkvbB+nsc7LHui8gECB-0d4oWt+6cA0x21=crDg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:52125 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab1GCSQR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Jul 2011 14:16:17 -0400
Content-Disposition: inline
In-Reply-To: <CAA9_cmd7KV_CkvbB+nsc7LHui8gECB-0d4oWt+6cA0x21=crDg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, axboe@kernel.dk, James Bottomley <James.Bottomley@hansenpartnership.com>, Andi Kleen <andi@firstfloor.org>, Dave Jones <davej@redhat.com>, SCSI development list <linux-scsi@vger.kernel.org>, Kernel development list <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, USB list <linux-usb@vger.kernel.org>

> Not sure it's related, but it sounds like the hotplug failures being
> seen with libsas hotplug.  Have not had a chance yet to track it down
> further with isci, but mvsas developer Xiangliang Yu is reporting:

It looks somewhat different: he has a bad pointer, not a NULL pointer,
and it's in elv_completed_request() (but that may be related to 
the different request types)

> 
> http://marc.info/?l=linux-scsi&m=130707166512002&w=2
> 
> He tracked it down to a suspected regression between .39-rc4 and
> .39-rc5 but did not finalize the bisect.

I can check if it disappears with .39-rc4.

> The isci driver sees this and other signatures all seemingly related
> to early device tear down and only when pulling a drive with in-flight
> i/o.

In my case it's not really in flight IO, but umount after pull with an
idle drive.

-Andi
