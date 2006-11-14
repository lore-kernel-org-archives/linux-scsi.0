From: "Monty Montgomery" <monty@xiph.org>
Subject: Re: 2.6.19-rc3 system freezes when ripping with cdparanoia at ioctl(SG_IO)
Date: Tue, 14 Nov 2006 17:52:04 -0500
Message-ID: <806dafc20611141452y7262df80g6fb7d3c0581f7b7f@mail.gmail.com>
References: <20061111104642.GA3356@infradead.org>
	 <589461.23187.qm@web31813.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nz-out-0102.google.com ([64.233.162.193]:3663 "EHLO
	nz-out-0102.google.com") by vger.kernel.org with ESMTP
	id S966424AbWKNWwG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Nov 2006 17:52:06 -0500
Received: by nz-out-0102.google.com with SMTP id l1so1113772nzf
        for <linux-scsi@vger.kernel.org>; Tue, 14 Nov 2006 14:52:05 -0800 (PST)
In-Reply-To: <589461.23187.qm@web31813.mail.mud.yahoo.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: Christoph Hellwig <hch@infradead.org>, dougg@torque.net, Tejun Heo <htejun@gmail.com>, Brice Goglin <Brice.Goglin@ens-lyon.org>, Jens Axboe <jens.axboe@oracle.com>, Gregor Jasny <gjasny@googlemail.com>, Linux Kernel <linux-kernel@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On 11/11/06, Luben Tuikov <ltuikov@yahoo.com> wrote:
> --- Christoph Hellwig <hch@infradead.org> wrote:
> > On Fri, Nov 10, 2006 at 12:08:15PM -0800, Luben Tuikov wrote:
> > > P.S. I'd love to see SG_DXFER_TO_FROM_DEV completely ripped out
> > > of sg.c, for obvious reasons.  Can you not duplicate the resid "fix"
> > > it provides into "FROM_DEV" -- do apps really rely on it?
> >
> > At the beginning of this thread it was mentioned cdparanio uses it.
> > But in general we can't just rip out userland interfaces, we pretend
> > to have a stable userspace abi (and except for the big sysfs mess that
> > actually comes very close to the truth).
>
> The more reason to think things thorougly when introducing
> new code and architecture into a kernel.

It was introduced for a good reason, and that reason is still relevant
today.  Cdparanoia is not using it gratuitously.  The only problem is
that the implementation had a bug (well, at least two bugs) and only
sg ever implemented it correctly.  Had block and sata implemente dit
correctly, we'd not be having this discussion.

Or you can blame a lower level layer for having no way to inform
mid-level drivers that DMA only completed a partial transfer.

"but anyway"...

This lockup was happening using SATA through the block layer, or does
SATA implement its own version of the ioctl?  Back when I was testing
my probing code, the buggy kernel would reject the request, not lock
up-- did a change make it inot 2.6.18 or later that causes a lockup
instead?

(I never tested with SATA cdroms, as I don't have any.  I tested with
IDE and SCSI and saw correct or detectable behavior)

Monty
