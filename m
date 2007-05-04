From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [Bugme-new] [Bug 8426] New: massive slowdown on SCSI CD/DVDdrive connected to mptspi driver
Date: Fri, 4 May 2007 14:34:02 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D7070C3C3@NAMAIL4.ad.lsil.com>
References: <1178250613.26450.3.camel@athlon>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:54530 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031545AbXEDUeP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 May 2007 16:34:15 -0400
Content-class: urn:content-classes:message
In-Reply-To: <1178250613.26450.3.camel@athlon>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Chapman <doug.chapman@hp.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>

On Thursday, May 03, 2007 9:50 PM,  Doug Chapman wrote:
> 
> ACK, tested this on my system where I originally found the problem and
> all is well with this.
> 
> Ignore my earlier comment about the original patch adding the new
> function mptspi_initTarget.  After looking at what is going 
> on I realize
> that it didn't add this, it was just renamed from mptscsih_initTarget.
> 

Are you still having issues?   I'm not clear with the above ACK email.

AFAIK, that patch your refering to which I submitted is only moving
code, not actually changing any functionality.   If your having a
problem with speed, then its most likely a domain validation problem.
In this driver, the domain validation is done from the spi transport
layer.    When you load the driver, there should be some messages
displayed along with the inquiry info during device scan, that would
provide the negotiation rates. Search your /var/log/messages or dmesg.
You can also look in the SysFS, and all the info is there as well.   If
your device is host_W:Channel_X:Target_Y:Lun_Z, then you would look in
/sys/class/spi_transport_targetW:X:Y:Z/ , in this folder will be period.
The period is found below at the end of the each line in nano seconds
units.

        factor:0x08   Ultra320 (160 Mega-transfers / second) (6.25 ns)
        factor:0x09   Ultra160 ( 80 Mega-transfers / second) (12.5 ns)
        factor:0x0A   Ultra2   ( 40 Mega-transfers / second) (25 ns)
        factor:0x0B   Ultra2   ( 40 Mega-transfers / second) (30.3 ns)
        factor:0x0C   Ultra    ( 20 Mega-transfers / second) (50 ns)
        factor:0x19   FAST     ( 10 Mega-transfers / second)
        factor:0x32   SCSI     (  5 Mega-transfers / second)
        factor:0xFF   5 Mega-trasfers/second and asynchronous


Also, in the mpt fusion, I have some debug you could enable, which will
dump all the negotiation parameters as they are written and read from
via the driver.  The spi transport layer calls these entry points when
it wants to change the negotiation parameter for each test it runs.  In
the mpt fusion driver Makefile, you need to uncomment the line
MPT_DEBUG_DV.   When you do that, then mptspi_print_read_nego and
mptspi_print_write_nego would be called.

I would like to point out that around the same time I supplied that mpt
fusion patch, there were changes in scsi_transport_spi.c, that would
effect negotitaion with regards to the starting min sync rate value.
This file is in /usr/src/linux/drivers/scsi.  You could diff between
your kernels to see the changes.

Eric Moore 
LSI
