From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH 2.6.13 2/14] sas-class: README
Date: Tue, 13 Sep 2005 09:30:54 -0400
Message-ID: <4326D48E.1080305@adaptec.com>
References: <4321E4DD.7070405@adaptec.com> <432543C6.1020403@torque.net> <4325CB10.1020902@adaptec.com> <4326A635.3020400@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:13725 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S964772AbVIMNbF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Sep 2005 09:31:05 -0400
In-Reply-To: <4326A635.3020400@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On 09/13/05 06:13, Douglas Gilbert wrote:
> 
> That is a relief, retired at last.

C'mon, you and I both know that sg has its place,
and is perfect doing what it is doing now.

But for protocol _interjection_, the mecanism
posted is easiest and sanest.

> It is impressive how elegant a passthrough can be when

I cannot call it a "passthrough" since the SMP frame isn't
"passing though" (by passing) anything.  When userspace
does a read(2) to get the data they expect, the SMP
frame they wrote(2) is sent to the SDS immediately.
In effect there is no "passing through".

It is a _protocol_ interjection.

That is an SMP frame (submission) _instantiates_
at that layer/level, not lower, not higher.

> one dispenses with a bit of metadata such as per command
> timeouts and 3 levels of error messages (i.e. from the
> driver, from the link layer and from the SMP target).
> I always enjoy getting EIO in errno.
> 
> This all seems so frustrating; a LLD injects a
> command/frame/whatever into an initiator and waits for
> a response or something to happen. Networking code faces
> the same scenario and presents it "as is" to the user
> space (for any application that cares). Yes, there are
> messy details. However in the SCSI subsystem we want to
> hide this simple reality with all these wierd and
> wonderful abstractions.

Doug, SMP is what it is, and this is where it _instantiates_.
You have to agree that interjecting an SMP frame at any other
level would be _more_ messy.

Plus, I always like presenting things "as is" to userspace
or higher layer, to keep the current layer cleaner and concerned
only with things belonging to it.

	Luben

