From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] add SCSI reset ioctls to scsi_ioctl.c (and sd and sr)
Date: Mon, 20 Sep 2004 10:53:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <414EEF07.5010701@adaptec.com>
References: <1095526671.2483.5.camel@mulgrave> <414E6F3E.4070502@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:55212 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S266643AbUITOyI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Sep 2004 10:54:08 -0400
In-Reply-To: <414E6F3E.4070502@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

> Perhaps there should be a new reset called:
>      ...RESET_LOGICAL_UNIT
> 
> as this is now defined as a task management function in SAM-3.
> If so ...RESET_DEVICE might get a synonym: ...RESET_TARGET.
> Most transports support a RESET_TARGET while RESET_BUS is
> SPI specific (is there an FCP equivalent?).

Very good idea.  Most likely TMF LU Reset should be
directly addressable to the LLDD, either via a separate
LLDD stub or through a common LLDD::int do_tmf(int tmf, void *data)
stub, so that the LLDD knows LU Reset is wanted.

The point is that the LLDD (and the target on the other end)
would know best how to do this (and other) TMFs. (More so
for newer protocols/transports.)

As to FCP, why not just do I_T Nexus loss or Transport
Reset (best). Ref. SAM3r13, sec 6 and FCP3r3c (4.9, 4.11, 4.12).
And possibly have the SCSI events into SCSI Core, for
all types of transports.

So, recovery would resolve to issuing a TMF (or two)
and if this doesn't work _and_ we haven't gotten a SCSI event,
we can _force_ an event,  else we just act on the
event gotten.

	Luben

P.S. We have to allow LLDDs, to mask out
"forcing" of those events, as the recovery thread
in SCSI Core shouldn't be so "trigger happy".



