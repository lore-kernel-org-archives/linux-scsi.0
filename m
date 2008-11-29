From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [Bug 12120] New: [Block layer or SCSI] requests aborted too early
 during check_partition()
Date: Sat, 29 Nov 2008 16:12:25 +0100 (CET)
Message-ID: <tkrat.ff41089ef3c5d74f@s5r6.in-berlin.de>
References: <bug-12120-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:51605 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbYK2PMm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Nov 2008 10:12:42 -0500
In-Reply-To: <bug-12120-11613@http.bugzilla.kernel.org/>
Content-Disposition: INLINE
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux1394-devel@lists.sourceforge.net, bugme-daemon@bugzilla.kernel.org

On 29 Nov, bugme-daemon@bugzilla.kernel.org wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=12120
> 
>            Summary: [Block layer or SCSI] requests aborted too early during
>                     check_partition()
>            Product: IO/Storage
>            Version: 2.5
>      KernelVersion: 2.6.28-rc
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: SCSI
>         AssignedTo: linux-scsi@vger.kernel.org
>         ReportedBy: stefan-r-bz@s5r6.in-berlin.de
> OtherBugsDependingO 11808
>              nThis:
>         Regression: 1
> 
> 
> Latest working kernel version: 2.6.27.4
> Earliest failing kernel version: 2.6.28-rc6  (I didn't test earlier -rcs yet)
> 
> Hardware Environment: OxSemi 912 and 92x based FireWire harddisks
> 
> 
> See http://marc.info/?l=linux-scsi&m=122774022130397 --
> Disks may still spin their motor up when the kernel attempts to read
> partitions. In kernel 2.6.27, this was handled transparently.  But since
> 2.6.28-rc?, the kernel immediately aborts the associated requests and sets the
> new scsi_device offline.
> 
> 

I tried a workaround in firewire-sbp2:  Check whether the new sdev is
offline right after scsi_add_device.  If so, remove the sdev and try
everything again.  However,
  - a regression still remains because the addition of the HDD takes
    about 30...40 seconds instead of only a few seconds like in 2.6.27.
  - The workaround works with OXFW912 and OXUF922, but not with
    OXUF924DSB.  Login retries don't succeed with the latter at all.
  - The workaround would be very hard to implement in the older
    ieee1394/sbp2 driver.
  - Other hardware besides FireWire may be affected.
-- 
Stefan Richter
-=====-==--- =-== ===-=
http://arcgraph.de/sr/

