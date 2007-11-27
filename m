From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 9462] New: Adaptec AHA-7850 with MOD drive:
 Hard lockup with new Adaptec driver
Date: Tue, 27 Nov 2007 10:26:25 -0800
Message-ID: <20071127102625.afdd49e8.akpm@linux-foundation.org>
References: <bug-9462-10286@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34297 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755919AbXK0S0e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Nov 2007 13:26:34 -0500
In-Reply-To: <bug-9462-10286@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: bugme-daemon@bugzilla.kernel.org, wagner@tik.ee.ethz.ch


(switched to email - please respond via emailed reply-to-all, not via the
bugzilla web interface)

On Tue, 27 Nov 2007 07:11:02 -0800 (PST) bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=9462
> 
>            Summary: Adaptec AHA-7850 with MOD drive: Hard lockup with new
>                     Adaptec driver
>            Product: IO/Storage
>            Version: 2.5
>      KernelVersion: 2.6.22.14
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: high
>           Priority: P1
>          Component: SCSI
>         AssignedTo: io_scsi@kernel-bugs.osdl.org
>         ReportedBy: wagner@tik.ee.ethz.ch
> 
> 
> Most recent kernel where this bug did not occur: Works with the old Adaptec
> driver. Had lockups with 2.6.18.8 as well, with the new driver. 
> 
> Distribution: Debian etch
> 
> Hardware Environment: Epox 8kta+, Athlon 800 MHz, 768MB RAM
> 
> Output form lspci:
> 00:00.0 Host bridge: VIA Technologies, Inc. VT8363/8365 [KT133/KM133] (rev 02)
> 00:01.0 PCI bridge: VIA Technologies, Inc. VT8363/8365 [KT133/KM133 AGP]
> 00:07.0 ISA bridge: VIA Technologies, Inc. VT82C686 [Apollo Super South] (rev
> 22)
> 00:07.1 IDE interface: VIA Technologies, Inc.
> VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 10)
> 00:07.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
> Controller (rev 10)
> 00:07.3 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
> Controller (rev 10)
> 00:07.4 Bridge: VIA Technologies, Inc. VT82C686 [Apollo Super ACPI] (rev 30)
> 00:09.0 Ethernet controller: D-Link System Inc DL2000-based Gigabit Ethernet
> (rev 0c)
> 00:0a.0 USB Controller: NEC Corporation USB (rev 43)
> 00:0a.1 USB Controller: NEC Corporation USB (rev 43)
> 00:0a.2 USB Controller: NEC Corporation USB 2.0 (rev 04)
> 00:0b.0 Mass storage controller: Promise Technology, Inc. PDC20518/PDC40518
> (SATAII 150 TX4) (rev 02)
> 00:0c.0 SCSI storage controller: Adaptec AHA-7850 (rev 03)
> 00:0d.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
> RTL-8139/8139C/8139C+ (rev 10)
> 01:00.0 VGA compatible controller: nVidia Corporation NV11 [GeForce2 MX/MX 400]
> (rev a1)
> 
> 
> Software Environment: Tried cp, dd_rescue and cat for copy. No difference.
> 
> Problem Description: When writing to the filesystem on the MOD, the computer
> locks completely as far as I can tell, no responses to ping, no log-entries
> (this is a headless server) MOD not writing and only a hard reset helps. The
> target filesystem had (after recovery with e2fsck) 22MB on it in one try and
> 350MB in another one. I guess there is some race condition or other randomized
> process at work. MOD size is 600MB.
> 
> 
> 
> Steps to reproduce:
> Insert MOD, mount it, write to it, see lockup happen.
> Observed with new dribver in 2.6.18.8 and 2.6.22.14. Also happens with TCQ
> disabled.
> 
> I should add that MODs are slow. The writing process blocks for 10-20 seconds
> frequently for disk flushes. This is normal and expected. 
> 
> Maybe a warning should be added to the new drivr and the old one should be kept
> for the time being.
> 
> If there are some tests I can run for you, please let me know.
> 

I guess this doesn't really count as a regression, as the new driver has
never worked.  I assume that the old driver continues to work OK and that
there is no plan to remove it?

