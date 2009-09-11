From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14159] AIC79xx is not working properly with an attached scsi
 tape since 2.6.29
Date: Fri, 11 Sep 2009 23:27:55 GMT
Message-ID: <200909112327.n8BNRtDF032672@demeter.kernel.org>
References: <bug-14159-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:45131 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757184AbZIKX1w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Sep 2009 19:27:52 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n8BNRtDD032673
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2009 23:27:55 GMT
In-Reply-To: <bug-14159-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14159





--- Comment #2 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org>  2009-09-11 23:27:53 ---
Reply-To: James.Bottomley@suse.de

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

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
