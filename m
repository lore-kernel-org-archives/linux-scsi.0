From: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: Linux 2.6.16-rc3
Date: Thu, 16 Feb 2006 17:12:00 +0000
Message-ID: <20060216171200.GD29443@flint.arm.linux.org.uk>
References: <Pine.LNX.4.64.0602121709240.3691@g5.osdl.org> <20060212190520.244fcaec.akpm@osdl.org> <20060213203800.GC22441@kroah.com> <1139934883.14115.4.camel@mulgrave.il.steeleye.com> <1140054960.3037.5.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([212.18.232.186]:24586 "EHLO
	caramon.arm.linux.org.uk") by vger.kernel.org with ESMTP
	id S932175AbWBPRMn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Feb 2006 12:12:43 -0500
Content-Disposition: inline
In-Reply-To: <1140054960.3037.5.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>, linux-kernel@vger.kernel.org, Jens Axboe <axboe@suse.de>, "Brown, Len" <len.brown@intel.com>, "David S. Miller" <davem@davemloft.net>, linux-acpi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, "Yu, Luming" <luming.yu@intel.com>, Ben Castricum <lk@bencastricum.nl>, sanjoy@mrao.cam.ac.uk, Helge Hafting <helgehaf@aitel.hist.no>, "Carlo E. Prelz" <fluido@fluido.as>, Gerrit Bruchh?user <gbruchhaeuser@gmx.de>, Nicolas.Mailhot@LaPoste.net, Jaroslav Kysela <perex@suse.cz>, Takashi Iwai <tiwai@suse.de>, Patrizio Bassi <patrizio.bassi@gmail.com>, Bj?rn Nilsson <bni.swe@gmail.com>, Andrey Borzenkov <arvidjaar@mail.ru>, "P. Christeas" <p_christ@hol.gr>, ghrt <ghrt@dial.kappa.ro>, jinhong hu <jinhong.hu@gmail.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-scsi@vger.ker

On Wed, Feb 15, 2006 at 08:56:00PM -0500, James Bottomley wrote:
> On Tue, 2006-02-14 at 10:34 -0600, James Bottomley wrote:
> > Well, I can't solve the problem that it requires memory allocation from
> > IRQ context to operate.  Based on that, it's an unsafe interface.  I'm
> > going to put it inside SCSI for 2.6.16, since it's better than what we
> > have now, but I don't think we can export it globally.
> 
> OK, this is what I'm proposing as the device model fix.  What it does is
> thread context checking APIs throughout the device subsystem.  SCSI can
> then use it simply via device_put_process_context().  Since we have to
> supply the kref_work; I'd plan to do that as an additional element in
> struct scsi_device.
> 
> This, by itself, won't solve the SCSI target problem, but I plan to fix
> that via a device model addition which would have target alloc waiting
> around for any deleted targets to disappear.
> 
> Since this is planned for post 2.6.16, we have plenty of time to argue
> about it.

This is probably an idiotic question, but if there's something in the
scsi release handler can't be called in non-process context, why can't
scsi queue up the release processing via the work API itself, rather
than having to have this additional code and complexity for everyone?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:  2.6 Serial core
