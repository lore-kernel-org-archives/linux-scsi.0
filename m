From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Apple Xserve RAID and qlogic ISP2312 (qla2300)
Date: Fri, 29 Oct 2004 11:06:33 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041029180633.GA27267@beaverton.ibm.com>
References: <20041027233321.GA842@astral.ro> <20041028143734.GA16358@beaverton.ibm.com> <20041028153522.GC1915@astral.ro> <20041028164210.GA16905@beaverton.ibm.com> <20041028172143.GA20949@praka.san.rr.com> <20041029085800.GF6671@astral.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:7398 "EHLO e34.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S263452AbUJ2SGr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Oct 2004 14:06:47 -0400
Received: from westrelay04.boulder.ibm.com (westrelay04.boulder.ibm.com [9.17.193.32])
	by e34.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id i9TI6kJ8478548
	for <linux-scsi@vger.kernel.org>; Fri, 29 Oct 2004 14:06:46 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay04.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id i9TI6jpg119450
	for <linux-scsi@vger.kernel.org>; Fri, 29 Oct 2004 12:06:45 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id i9TI6idw025920
	for <linux-scsi@vger.kernel.org>; Fri, 29 Oct 2004 12:06:45 -0600
Content-Disposition: inline
In-Reply-To: <20041029085800.GF6671@astral.ro>
List-Id: linux-scsi@vger.kernel.org
To: Catalin Muresan <catalin.muresan@astral.ro>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, bogdan.luca@astral.ro

On Fri, Oct 29, 2004 at 11:58:00AM +0300, Catalin Muresan wrote:

>  > > Catalin - does the device support REPORT LUNS? Do you have that
>  > > configured? It would avoid this problem.
>  > > 
>  > 
>  > Yes, Catalin, could you find that out?  I've only had a small amount
>  > of exposure with the XRAID box and know that there were some quirks
>  > about the device not performing an RFT_ID with the SNS, not sure if
>  > that was addressed.
> 
> 	i don't know how to find that, i'm gonna go and look at the source
> and try to figure it out untill you respond.

I forgot a few things:

1) The REPORT LUNS is always on in current 2.6.x kernels, I do not remember
what kernel version first had the change.

2) If LUN 0 gets a DID_NO_CONNECT (and we do return the
SCSI_SCAN_NO_RESPONSE), we won't scan anything, via REPORT LUN or via
a sequential scan.

3) We have a problem for REPORT LUN with sparse lun devices, in short,
you won't get a REPORT LUN scan if no LUN 0 is configured. I thought Kurt
was working on a fix for that, this post:

http://marc.theaimsgroup.com/?t=109545967900002&r=1&w=2

4) You posted as part of your logs:

Oct 28 02:31:38 zerg-b kernel:   Vendor: APPLE     Model: Xserve RAID Rev: 1.21
Oct 28 02:31:38 zerg-b kernel:   Type:   Direct-Access ANSI SCSI revision: 02

For SCSI 2 devices by default the REPORT LUN scan won't be used. Some
storage arrays have an option as to what SCSI level to report, try that or
use the BLIST_REPORTLUN2 devinfo flag. 

If you had configured in only LUNs 0 1 and 5, the sequential scan (with no
sparse lun) will stop scanning after LUN 2 is not seen.

In short you need to first figure out why LUN 0 is getting a
DID_NO_CONNECT, and after that the sequential scan should work OK for your
*current* configuration (only LUN 5 configured), though the REPORT LUN
scan or sparse lun scan will be needed to avoid sparse LUNs as noted
above.

-- Patrick Mansfield
