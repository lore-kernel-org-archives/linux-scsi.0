From: Will Lowe <harpo@thebackrow.net>
Subject: aacraid, 2.4.26, adaptec 2810sa
Date: Fri, 24 Sep 2004 15:14:50 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040924221450.GA18494@thebackrow.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from leftcoast.thebackrow.net ([64.152.73.80]:13210 "EHLO
	leftcoast.thebackrow.net") by vger.kernel.org with ESMTP
	id S269001AbUIXWOt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Sep 2004 18:14:49 -0400
Received: from harpo by leftcoast.thebackrow.net with local (Microsoft Exchange Internet Mail Service 5.5.2653.13)
	for <linux-scsi@vger.kernel.org>; Fri, 24 Sep 2004 15:14:50 -0700
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I've got several Adaptec 2810SA SATA raid cards in use running Debian
Woody with a 2.4.26 kernel using the aacraid driver.  The boxes are
MySQL (4.1.1) servers with dual Xeon 2.8G cpus (hyperthreading is on)
and the filesystem is reiserfs.

At irregular intervals we get this:

Sep 24 13:59:45 cd-grapherdb02b kernel: aacraid: Host adapter reset request. SCSI hang ?
Sep 24 13:59:55 cd-grapherdb02b kernel: scsi: device set offline - command error recover failed: host 1 channel 0 id 0 lun 0
Sep 24 13:59:55 cd-grapherdb02b kernel: SCSI disk error : host 1 channel 0 id 0 lun 0 return code = 6000000
Sep 24 13:59:55 cd-grapherdb02b kernel:  I/O error: dev 08:11, sector 128
Sep 24 13:59:55 cd-grapherdb02b kernel:  I/O error: dev 08:11, sector 532385968
Sep 24 13:59:55 cd-grapherdb02b kernel: :11, sector 113398656
Sep 24 13:59:55 cd-grapherdb02b kernel:  I/O error: dev 08:11, sector 113400000

... followed by lots and lots of lines of IO errors.  The box doesn't
crash -- it's booting from another drive -- but the aacraid partitions
are unusable.  So far we can't reproduce the bug on demand.

Here's what the cli control app says about the controller:

Component Revisions
-------------------
                CLI: 4.1-0 (Build #6127)
                API: 4.1-0 (Build #6127)
    Miniport Driver: 1.1-0 Beta (Build #9999)
Controller Software: 4.1-0 (Build #7211)
    Controller BIOS: 4.1-0 (Build #7211)
Controller Firmware: (Build #7211)
Controller Hardware: 2.64

It looks like there's a newer firmware available at Adaptec.com, but
it "requires" a version of the driver that seems to be Windows-only.

Googling shows a lot of people with the "Host adapter reset request"
message going back at least a year with lots of different hardware --
and no known fixes.

Any ideas? 

-- 
        				thanks,
		
					Will
