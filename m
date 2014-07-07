From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: dummy scsi read or scsi command periodically for external USB
 Hard Disk
Date: Mon, 7 Jul 2014 16:52:34 +0100
Message-ID: <20140707155233.GD19630@localhost.localdomain>
References: <CANudz+sYkDthT9-xpt_hdqXHj+pSeTR5UcNmsPa4uP+YCvzSiw@mail.gmail.com>
 <20140707092029.GA19630@localhost.localdomain>
 <CANudz+uUuhLdfkVSseXXHW6ugm126Q4Taau+s7wavAP=Z9=4XA@mail.gmail.com>
 <53BAB5DF.5090606@gmail.com>
 <063D6719AE5E284EB5DD2968C1650D6D1726D887@AcuExch.aculab.com>
 <CANudz+uOS3VVyz6FcHoui8z678R6Xc0CQrdqFRdS5NyfCB59Zw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582AbaGGPwl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Jul 2014 11:52:41 -0400
Content-Disposition: inline
In-Reply-To: <CANudz+uOS3VVyz6FcHoui8z678R6Xc0CQrdqFRdS5NyfCB59Zw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: loody <miloody@gmail.com>
Cc: David Laight <David.Laight@aculab.com>, Lars Melin <larsm17@gmail.com>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, Jul 07, 2014 at 11:39:05PM +0800, loody wrote:
> hi David:
> 
> 2014-07-07 23:06 GMT+08:00 David Laight <David.Laight@aculab.com>:
> > From: Lars Melin
> > ...
> >> sgread is not included in BusyBox but you should have "touch".
> >> Create a dummy file on the disk and let cron touch it every 4 minutes.
> >
> > You don't need 'touch' a shell redirect eg ": >file" will do open(..., O_CREAT|O_TRUNC).
> > However that still might not force an actual disc access.
> >
> > In any case you really only want to do a read, doing a write will kill the NAND memory.
> 
> actually I have searched the scsi/usb layer for possible dummy read,
> even read sector 0 is fine, but in vain.
> 
> I found the read
> a. determined by VFS -> block layer,
> b. Block layer put it in queue
> c. call scsi pre-queue function to usb layer.
> 
> That mean if I try to read sector from usb devices, I have to create a
> queue and follow above b) and c) rule.
> is there any already kernel API I can use?
> 
> sincerely appreciate all yours help,

If you don't want to put sg_read into your image you could just use a dd;
busybox includes an implementation that should be good enough.

Just make sure you use the right flags to use O_DIRECT access or you'll
just end up hammering on the page cache. Iirc that's "iflags=direct" (check
the busybox docs to make sure it's the same).

Regards,
Bryn.

