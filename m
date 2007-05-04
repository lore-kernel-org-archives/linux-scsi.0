From: Doug Chapman <doug.chapman@hp.com>
Subject: RE: [Bugme-new] [Bug 8426] New: massive slowdown on SCSI
	CD/DVDdrive connected to mptspi driver
Date: Fri, 04 May 2007 17:56:41 -0400
Message-ID: <1178315801.27774.15.camel@athlon>
References: <664A4EBB07F29743873A87CF62C26D7070C3C3@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161559AbXEDV4y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 May 2007 17:56:54 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D7070C3C3@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>

On Fri, 2007-05-04 at 14:34 -0600, Moore, Eric wrote:
> On Thursday, May 03, 2007 9:50 PM,  Doug Chapman wrote:
> > 
> > ACK, tested this on my system where I originally found the problem and
> > all is well with this.
> > 
> > Ignore my earlier comment about the original patch adding the new
> > function mptspi_initTarget.  After looking at what is going 
> > on I realize
> > that it didn't add this, it was just renamed from mptscsih_initTarget.
> > 
> 
> Are you still having issues?   I'm not clear with the above ACK email.

I was ACKing Andrew's patch as it fixes the issue for me.  Without the
backup patch it is still broken even in the latest git tree.  (Linus's
tree).

> 
> AFAIK, that patch your refering to which I submitted is only moving
> code, not actually changing any functionality.   If your having a
> problem with speed, then its most likely a domain validation problem.

I agree it looks that way.  In fact it took me longer to narrow this
down because I didn't suspect that patch.  But, I tested this multiple
times backing out just that specific patch and it _does_ make the
difference.  It is rather dramatic, takes about 10 minutes to read a
kernel.rpm file from a DVD (takes 2 to 4 seconds normally).

> In this driver, the domain validation is done from the spi transport
> layer.    When you load the driver, there should be some messages
> displayed along with the inquiry info during device scan, that would
> provide the negotiation rates. Search your /var/log/messages or dmesg.
> You can also look in the SysFS, and all the info is there as well.   If
> your device is host_W:Channel_X:Target_Y:Lun_Z, then you would look in
> /sys/class/spi_transport_targetW:X:Y:Z/ , in this folder will be period.
> The period is found below at the end of the each line in nano seconds
> units.
> 
>         factor:0x08   Ultra320 (160 Mega-transfers / second) (6.25 ns)
>         factor:0x09   Ultra160 ( 80 Mega-transfers / second) (12.5 ns)
>         factor:0x0A   Ultra2   ( 40 Mega-transfers / second) (25 ns)
>         factor:0x0B   Ultra2   ( 40 Mega-transfers / second) (30.3 ns)
>         factor:0x0C   Ultra    ( 20 Mega-transfers / second) (50 ns)
>         factor:0x19   FAST     ( 10 Mega-transfers / second)
>         factor:0x32   SCSI     (  5 Mega-transfers / second)
>         factor:0xFF   5 Mega-trasfers/second and asynchronous
> 

/sys/class/spi_transport/target5:0:2/period is 50 with our without the
patch in question.

> 
> Also, in the mpt fusion, I have some debug you could enable, which will
> dump all the negotiation parameters as they are written and read from
> via the driver.  The spi transport layer calls these entry points when
> it wants to change the negotiation parameter for each test it runs.  In
> the mpt fusion driver Makefile, you need to uncomment the line
> MPT_DEBUG_DV.   When you do that, then mptspi_print_read_nego and
> mptspi_print_write_nego would be called.

Perhaps I can look into this monday.

> 
> I would like to point out that around the same time I supplied that mpt
> fusion patch, there were changes in scsi_transport_spi.c, that would
> effect negotitaion with regards to the starting min sync rate value.
> This file is in /usr/src/linux/drivers/scsi.  You could diff between
> your kernels to see the changes.

I am applying/removing _only_ your patch and the problem goes away with
just removing it.

- Doug


