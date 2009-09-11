From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [Bug 14159] New: AIC79xx is not working properly with an
 attached scsi tape since 2.6.29
Date: Fri, 11 Sep 2009 23:27:45 +0000
Message-ID: <1252711665.13282.202.camel@mulgrave.site>
References: <bug-14159-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:33179 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753713AbZIKX1s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Sep 2009 19:27:48 -0400
In-Reply-To: <bug-14159-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

On Fri, 2009-09-11 at 09:18 +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=14159
> 
>            Summary: AIC79xx is not working properly with an attached scsi
>                     tape since 2.6.29
>            Product: SCSI Drivers
>            Version: 2.5
>     Kernel Version: 2.6.27 (working), 2.6.30 (not working)
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Other
>         AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
>         ReportedBy: g.giorgetti@teamsystem.com
>                 CC: g.giorgetti@teamsystem.com
>         Regression: Yes
> 
> 
> Both kernels 2.6.27 and 2.6.28 are working correctly.
> Since Linux 2.6.29 till 2.6.31rc8 the regression(?) is out there.
> 
> Please let me know if I can provide any further details.
> 
> Best regards,
>  Gabriele
> 
> =================
> Here is the messages part for Linux 2.6.27:
> 
> aic79xx 0000:41:01.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19   
> scsi5 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 3.0
>         <Adaptec 29320ALP PCIx Ultra320 SCSI adapter>
>         aic7901: Ultra320 Wide Channel A, SCSI Id=7, PCI-X 101-133Mhz, 512 SCBs
>  target5:0:3: asynchronous
> scsi 5:0:3:0: Sequential-Access IBM      HH LTO Gen 2     0376 PQ: 0 ANSI: 3
>  target5:0:3: Beginning Domain Validation
>  target5:0:3: wide asynchronous
>  target5:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
>  target5:0:3: Ending Domain Validation
> scsi 5:0:3:0: Attached scsi generic sg7 type 1
> st: Version 20080504, fixed bufsize 32768, s/g segs 256
> Driver 'st' needs updating - please use bus_type methods
> st 5:0:3:0: Attached scsi tape st0
> st 5:0:3:0: st0: try direct i/o: yes (alignment 4 B)
> osst :I: Tape driver with OnStream support version 0.99.4
> osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
> Driver 'osst' needs updating - please use bus_type methods
> st0: Block limits 256 - 524288 bytes.
> =================
> 
> =================
> Here is Linux 2.6.30:
> 
> Aug  3 06:25:04 svil kernel: aic79xx 0000:41:01.0: PCI INT A -> GSI 19 (level,
> low) -> IRQ 19
> Aug  3 06:25:04 svil kernel: scsi5 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev
> 3.0
> Aug  3 06:25:04 svil kernel:         <Adaptec 29320ALP PCIx Ultra320 SCSI
> adapter>
> Aug  3 06:25:04 svil kernel:         aic7901: Ultra320 Wide Channel A, SCSI
> Id=7, PCI-X 101-1
> Aug  3 06:25:04 svil kernel: scsi 5:0:0:0: Attempting to queue an ABORT
> message:CDB: 0x12 0x0

That's an inquiry to a non-existent target.  It should have returned a
DID_NO_CONNECT timeout within 250ms.  The fact that it didn't is
suggestive of interrupt routing problems.  After all these messages have
completed, what does /proc/interrupts say?

James


