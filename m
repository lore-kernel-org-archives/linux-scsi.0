From: Catalin Muresan <catalin.muresan@astral.ro>
Subject: Re: Apple Xserve RAID and qlogic ISP2312 (qla2300)
Date: Sat, 30 Oct 2004 18:44:31 +0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041030154430.GC9629@astral.ro>
References: <20041027233321.GA842@astral.ro> <20041028143734.GA16358@beaverton.ibm.com> <20041028153522.GC1915@astral.ro> <20041028164210.GA16905@beaverton.ibm.com> <20041028172143.GA20949@praka.san.rr.com> <20041029085800.GF6671@astral.ro> <20041029180633.GA27267@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dummy.cluj.astral.ro ([193.230.240.25]:60608 "EHLO
	cnn.astral.ro") by vger.kernel.org with ESMTP id S261303AbUJ3Puv
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 30 Oct 2004 11:50:51 -0400
Content-Disposition: inline
In-Reply-To: <20041029180633.GA27267@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, bogdan.luca@astral.ro

On Fri, Oct 29, 2004 at 11:06:33AM -0700, Patrick Mansfield wrote:
 > I forgot a few things:
 > 
 > 1) The REPORT LUNS is always on in current 2.6.x kernels, I do not remember
 > what kernel version first had the change.

	from a quick glance at the source it's tried if LUN 0 returns
TARGET_PRESENT (meaning target is there but no lun), so some changes need to
be made to have REPORT LUN (also fake the device as scsi-3). 

 > 2) If LUN 0 gets a DID_NO_CONNECT (and we do return the
 > SCSI_SCAN_NO_RESPONSE), we won't scan anything, via REPORT LUN or via
 > a sequential scan.

	yep. what i don't know is how the REPORT LUN command is issued: to a
LUN or to the target ? if it's to the LUN it's hopeless and only changes in
the driver can help.

 > 3) We have a problem for REPORT LUN with sparse lun devices, in short,
 > you won't get a REPORT LUN scan if no LUN 0 is configured. I thought Kurt
 > was working on a fix for that, this post:
 > 
 > http://marc.theaimsgroup.com/?t=109545967900002&r=1&w=2

	even if not configured, I think the target should respond with
TARGET_PRESENT but this storage doesn't communicate at all.

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

	if I would have LUN 0 configured and any other combinations it would
have worked because i've already whitelisted the storage as BLIST_SPARSELUN

 > In short you need to first figure out why LUN 0 is getting a
 > DID_NO_CONNECT, and after that the sequential scan should work OK for your

	I blame it on the storage for not following the spec now.

 > *current* configuration (only LUN 5 configured), though the REPORT LUN

	REPORT LUN is sent to LUN 0 ? if yes it doesn't help because the
storage is willomg to cdommunicate only with unmasked LUNs. 

 > scan or sparse lun scan will be needed to avoid sparse LUNs as noted
 > above.

	I'll continue on this monday when I'll be at work and near the
equipments.

 > -- Patrick Mansfield

-- 
Kat
