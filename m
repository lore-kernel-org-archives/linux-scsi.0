From: Suparna Bhattacharya <suparna@in.ibm.com>
Subject: Re: Some interesting results in the aic7xxx slowdown problem
Date: Fri, 19 Aug 2005 15:24:28 +0530
Message-ID: <20050819095428.GA9130@in.ibm.com>
References: <1123119347.5019.78.camel@mulgrave> <20050804061809.GA4158@in.ibm.com> <1123166928.5026.8.camel@mulgrave>
Reply-To: suparna@in.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:58073 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S964815AbVHSJpX
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Aug 2005 05:45:23 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e35.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j7J9jE48086380
	for <linux-scsi@vger.kernel.org>; Fri, 19 Aug 2005 05:45:14 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j7J9inJ7527112
	for <linux-scsi@vger.kernel.org>; Fri, 19 Aug 2005 03:44:49 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id j7J9jDQl001100
	for <linux-scsi@vger.kernel.org>; Fri, 19 Aug 2005 03:45:13 -0600
Content-Disposition: inline
In-Reply-To: <1123166928.5026.8.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

James,

I finally got around to trying out 2.6.13-rc6 which (I think) includes the
AIC driver modifications to use block layer tagging. But it
looks like I'm out of luck -- the system doesn't even come up now.
This is what I see.

...
Initializing IPsec netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
NET: Registered protocol family 15
Starting balanced_irq
Using IPI Shortcut mode
VFS: Cannot open root device "sda6" or unknown-block(8,6)
Please append a correct "root=" boot option
Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(8,6)


Is this a known problem ? I do not get it if I configure the OLD aic driver
instead.

Some snippets from the scsi bootup messages :


...
scsi0:A:11:0: Tagged Queuing enabled.  Depth 32
 target0:0:11: Beginning Domain Validation
 target0:0:11: wide asynchronous.
 target0:0:11: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 63)
 target0:0:11: Ending Domain Validation
 target0:0:12: asynchronous.
  Vendor: IBM-ESXS  Model: ST318305LC    !#  Rev: B245
  Type:   Direct-Access

...

ACPI: PCI Interrupt 0000:00:01.1[A] -> GSI 17 (level, low) -> IRQ 17
scsi1 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.36
        <Adaptec aic7896/97 Ultra2 SCSI adapter>
        aic7896/97: Ultra2 Wide Channel B, SCSI Id=7, 32/253 SCBs

 target1:0:0: asynchronous.
  Vendor: IBM-ESXS  Model: ST318305LC    !#  Rev: B245
  Type:   Direct-Access                      ANSI SCSI revision: 03

....

SCSI device sda: 35548320 512-byte hdwr sectors (18201 MB)
SCSI device sda: drive cache: write through
SCSI device sda: 35548320 512-byte hdwr sectors (18201 MB)
SCSI device sda: drive cache: write through
 sda:
Attached scsi disk sda at scsi0, channel 0, id 9, lun 0
SCSI device sdb: 35548320 512-byte hdwr sectors (18201 MB)
....

Attached scsi generic sg0 at scsi0, channel 0, id 9, lun 0,  type 0
Attached scsi generic sg1 at scsi0, channel 0, id 10, lun 0,  type 0

...

Regards
Suparna

-- 
Suparna Bhattacharya (suparna@in.ibm.com)
Linux Technology Center
IBM Software Lab, India

