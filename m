From: Catalin Muresan <catalin.muresan@astral.ro>
Subject: Re: Apple Xserve RAID and qlogic ISP2312 (qla2300)
Date: Mon, 1 Nov 2004 12:56:11 +0200
Message-ID: <20041101105611.GJ22603@astral.ro>
References: <20041027233321.GA842@astral.ro> <20041028143734.GA16358@beaverton.ibm.com> <20041028153522.GC1915@astral.ro> <20041028164210.GA16905@beaverton.ibm.com> <20041028172143.GA20949@praka.san.rr.com> <20041029085800.GF6671@astral.ro> <20041029180633.GA27267@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dummy.cluj.astral.ro ([193.230.240.25]:25540 "EHLO
	cnn.astral.ro") by vger.kernel.org with ESMTP id S261483AbUKALCt
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Nov 2004 06:02:49 -0500
Content-Disposition: inline
In-Reply-To: <20041029180633.GA27267@beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, bogdan.luca@astral.ro


	I have the attached patch from Andrew which fixes the qla2300 part
of the problem (attached) and a patch is still needed for the case where
there are LUN0,3 to blacklist the device as BLIST_SPARSELUN.

On Fri, Oct 29, 2004 at 11:06:33AM -0700, Patrick Mansfield wrote:
 > On Fri, Oct 29, 2004 at 11:58:00AM +0300, Catalin Muresan wrote:
 > 
 > >  > > Catalin - does the device support REPORT LUNS? Do you have that
 > >  > > configured? It would avoid this problem.
 > >  > > 
 > >  > 
 > >  > Yes, Catalin, could you find that out?  I've only had a small amount
 > >  > of exposure with the XRAID box and know that there were some quirks
 > >  > about the device not performing an RFT_ID with the SNS, not sure if
 > >  > that was addressed.
 > > 
 > > 	i don't know how to find that, i'm gonna go and look at the source
 > > and try to figure it out untill you respond.
 > 
 > I forgot a few things:
 > 
 > 1) The REPORT LUNS is always on in current 2.6.x kernels, I do not remember
 > what kernel version first had the change.
 > 
 > 2) If LUN 0 gets a DID_NO_CONNECT (and we do return the
 > SCSI_SCAN_NO_RESPONSE), we won't scan anything, via REPORT LUN or via
 > a sequential scan.

	we need to have something on LUN 0 to be able to send REPORT LUN, in
this case we don't.

 > 3) We have a problem for REPORT LUN with sparse lun devices, in short,
 > you won't get a REPORT LUN scan if no LUN 0 is configured. I thought Kurt
 > was working on a fix for that, this post:
 > 
 > http://marc.theaimsgroup.com/?t=109545967900002&r=1&w=2

	here it was the controller which disabled the LUNs if there were no
devices connected to the LUN. Now (after the patch) we can scan the storage
with REPORT LUNS (if supported) or sequential.

 > 4) You posted as part of your logs:
 > 
 > Oct 28 02:31:38 zerg-b kernel:   Vendor: APPLE     Model: Xserve RAID Rev: 1.21
 > Oct 28 02:31:38 zerg-b kernel:   Type:   Direct-Access ANSI SCSI revision: 02
 > 
 > For SCSI 2 devices by default the REPORT LUN scan won't be used. Some
 > storage arrays have an option as to what SCSI level to report, try that or
 > use the BLIST_REPORTLUN2 devinfo flag. 
 > 
 > If you had configured in only LUNs 0 1 and 5, the sequential scan (with no
 > sparse lun) will stop scanning after LUN 2 is not seen.

	that is where the BLIST_SPARSELUN patch comes to help for non-SCSI-3
devices.

 > In short you need to first figure out why LUN 0 is getting a
 > DID_NO_CONNECT, and after that the sequential scan should work OK for your

	it's because the qla2300 does not enable in it's list LUNs that have
no devices attached. I still think that it should configure all available
LUNs if there is a target present, but this is ok.

 > *current* configuration (only LUN 5 configured), though the REPORT LUN
 > scan or sparse lun scan will be needed to avoid sparse LUNs as noted
 > above.

	Do you need me to test some other stuff or we can "close" this
issue?	

 > -- Patrick Mansfield

-- 
 Catalin Muresan
 ASTRAL Internet & Data
 Technology Manager
