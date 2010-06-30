From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: aacraid problems on 2.6.35-rc3
Date: Wed, 30 Jun 2010 15:02:28 -0500
Message-ID: <1277928148.2839.364.camel@mulgrave.site>
References: <AANLkTimvQtYPh_6ZeKiGz2-eZf_pVy6N7TwEeXCoq0Iv@mail.gmail.com>
	 <1277909662.2839.17.camel@mulgrave.site>
	 <AANLkTinRg1WIRWIBE1odKkvbECBPLPUoY2mVKmAjqpKZ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55117 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756245Ab0F3UCd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jun 2010 16:02:33 -0400
In-Reply-To: <AANLkTinRg1WIRWIBE1odKkvbECBPLPUoY2mVKmAjqpKZ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alex <mysqlstudent@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Wed, 2010-06-30 at 10:57 -0400, Alex wrote:
> Hi,
> 
> >> It only prints the following when booting:
> >>
> >> Adaptec aacraid driver 1.1-5[2456]-ms
> >
> > That driver comes from a rather old kernel (2.6.29 or before).  Could
> > you try with a modern version (which should print 1.1-5[26400]-ms just
> > in case the problem got fixed in the interim.
> 
> Yes, my apologies. This was from the working kernel, which is 2.6.27.
> I am working with 2.6.35-rc3.
> 
> >> The dmesg output from a working system is here:
> >>
> >> http://pastebin.com/0AnVBV7s
> >
> > This trace shows your system won't configure interrupts correctly
> > without ACPI ... if ACPI isn't working, more than just the aacraid will
> > be non functional.  A dmesg of the failing system would be definitive in
> > diagnosing this.
> 
> How can I do this? The kernel panics without mounting a filesystem.

You need a serial or net console to capture the output.  At a guess, the
latest ACPI cockup is this one:

commit b430acbd7c4b919886fa7fd92eeb7a695f1940d3
Author: Len Brown <len.brown@intel.com>
Date:   Thu May 6 17:41:08 2010 -0400

    ACPICA: simplify SCI_EN workaround

Try reverting that and seeing if it boots.

James


