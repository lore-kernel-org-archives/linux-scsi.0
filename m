From: adam radford <aradford@gmail.com>
Subject: Re: [PATCH] 3ware: use scsi_scan_target()
Date: Wed, 5 Oct 2005 12:20:33 -0700
Message-ID: <b1bc6a000510051220m5d6e60b7i74b0bba96046513c@mail.gmail.com>
References: <4341D38A.40509@pobox.com> <20051005162850.GA17710@infradead.org>
	 <43442312.4030304@adaptec.com>
Reply-To: adam radford <aradford@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xproxy.gmail.com ([66.249.82.202]:12958 "EHLO xproxy.gmail.com")
	by vger.kernel.org with ESMTP id S932542AbVJETUd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Oct 2005 15:20:33 -0400
Received: by xproxy.gmail.com with SMTP id s14so140764wxc
        for <linux-scsi@vger.kernel.org>; Wed, 05 Oct 2005 12:20:33 -0700 (PDT)
In-Reply-To: <43442312.4030304@adaptec.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jgarzik@pobox.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linuxraid@amcc.com

The firmware for the 9000 series 3ware controllers definately does support
the REPORT LUNS scsi opcode.  The only reason the LUN support is there
is for older 2.4 customers who have carved up > 2TB arrays into several
luns who then upgrade to kernel 2.6.

-Adam

On 10/5/05, Luben Tuikov <luben_tuikov@adaptec.com> wrote:
> On 10/05/05 12:28, Christoph Hellwig wrote:
> > On Mon, Oct 03, 2005 at 08:57:46PM -0400, Jeff Garzik wrote:
> >
> >>This change updates the 3ware raid drivers to use scsi_scan_target(),
> >>rather than scsi_scan_host().  This is especially nice for 3w-xxxx,
> >>which does not support LUNs.  The device scan is a bit quicker and more
> >>direct, even if it is a tiny bit more code in the driver.
> >
> >
> > if it doesn't support luns scsi_add_device sounds like the better
> > interface to use.
>
> I agree.
>
> > How does 3x-9xxx support luns?  From reading the
>
> AFAIR the firmware just exports the LUs.  The FW doesn't
> support REPORT LUNS; the LLDD exported LUs directly to SCSI Core.
>
>         Luben
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
