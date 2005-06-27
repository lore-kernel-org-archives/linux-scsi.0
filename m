From: Nick Orlov <bugfixer@list.ru>
Subject: Re: Fw: 2.6.12-mm2: 3ware SATA RAID inaccessible
Date: Mon, 27 Jun 2005 00:46:47 -0400
Message-ID: <20050627044647.GA4104@nikolas.hn.org>
References: <20050626153941.456543d6.akpm@osdl.org>
 <1119829031.5038.15.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200]:51398 "EHLO
	mta5.srv.hcvlny.cv.net") by vger.kernel.org with ESMTP
	id S261343AbVF0Eqt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Jun 2005 00:46:49 -0400
Received: from nikolas.hn.org (ool-45731e9d.dyn.optonline.net [69.115.30.157])
 by mta5.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-2.06 (built May 11 2005))
 with ESMTP id <0IIQ007EO7Y6CH70@mta5.srv.hcvlny.cv.net> for
 linux-scsi@vger.kernel.org; Mon, 27 Jun 2005 00:46:54 -0400 (EDT)
In-reply-to: <1119829031.5038.15.camel@mulgrave>
Content-disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

On Sun, Jun 26, 2005 at 06:37:11PM -0500, James Bottomley wrote:
> On Sun, 2005-06-26 at 15:39 -0700, Andrew Morton wrote:
> > : OK ... I looked ... and it's not pretty.  The problem is that the 3ware
> > : assumes certain commands (INQUIRY, READ_CAPACITY, MODE_SENSE + a few
> > : others) are only generated internally and thus only have use_sg == 0.
> > : The scsi-block-tree breaks this assumption because we're trying to
> > : eliminate the use_sg == 0 special case.
> > : 
> > : It's important to note that this behaviour is already broken, as anyone
> > : using SG_IO to send commands to the device would have discovered.
> 
> OK, I think the attached is the fix.  It makes the 3w-xxxx routines
> handle sg data.  Can we verify it works first, and then we'll worry
> about how many other internal command processing devices are broken in
> this way.
> 

This fix caused the following Oops + kernel panic:

c0267437 tw_interrupt+0x317/0x480
c013ac9d handle_IRQ_event+0x3d/0x70
c013adb0 __do_IRQ+0xe0/0x170
c0104fc3 do_IRQ+0x23/0x40
c01031ce common_interrupt+0x1a/0x20
c0100ca6 default_idle+0x26/0x30
c0110bbc apm_cpu_idle+0xce/0x160
c0100d24 cpu_idle+0x34/0x50
c03947e5 start_kernel+0x165/0x180
c0394360 unknown_bootoption+0x0/0x1e0

I've manually copied that from the screen, so it can contain some typos.

Thank you,
	Nick Orlov.
-- 
With best wishes,
	Nick Orlov.

