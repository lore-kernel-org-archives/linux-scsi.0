From: "Zhao, Forrest" <forrest.zhao@intel.com>
Subject: A bug report for Fusion MPT driver for kernel 2.6.11.6
Date: Thu, 7 Apr 2005 19:49:02 +0800
Message-ID: <8126E4F969BA254AB43EA03C59F44E8401CC0FF8@pdsmsx404>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmr17.intel.com ([134.134.136.16]:50873 "EHLO
	orsfmr002.jf.intel.com") by vger.kernel.org with ESMTP
	id S261247AbVDGLtK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Apr 2005 07:49:10 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, =?gb2312?B?08nUqM+8?= <yxyou@yahoo.com.cn>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

First forgive me to change the mail subject to the above.
The HBA driver is Fusion_MPT, the log file is filled up by the following lines:

----------------------------------------------------------------------------
Apr  7 19:15:29 tiger43 kernel: mptbase: ioc0: IOCStatus(0x0043): SCSI Device Not There
Apr  7 19:15:29 tiger43 kernel: SCSI error : <1 0 1 0> return code = 0x10000
Apr  7 19:15:29 tiger43 kernel: end_request: I/O error, dev sdb, sector 13370730
Apr  7 19:15:30 tiger43 kernel: mptbase: ioc0: IOCStatus(0x0043): SCSI Device Not There
Apr  7 19:15:30 tiger43 kernel: SCSI error : <1 0 1 0> return code = 0x10000
Apr  7 19:15:30 tiger43 kernel: end_request: I/O error, dev sdb, sector 13370730
Apr  7 19:15:30 tiger43 kernel: mptbase: ioc0: IOCStatus(0x0043): SCSI Device Not There
Apr  7 19:15:30 tiger43 kernel: SCSI error : <1 0 1 0> return code = 0x10000
Apr  7 19:15:30 tiger43 kernel: end_request: I/O error, dev sdb, sector 13370730
Apr  7 19:15:30 tiger43 kernel: mptbase: ioc0: IOCStatus(0x0043): SCSI Device Not There
Apr  7 19:15:30 tiger43 kernel: SCSI error : <1 0 1 0> return code = 0x10000
Apr  7 19:15:30 tiger43 kernel: end_request: I/O error, dev sdb, sector 13370730
----------------------------------------------------------------------------

Then the system become very busy and can't respond to other applications timely.

Thanks,
Forrest
-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@SteelEye.com] 
Sent: Thursday, March 24, 2005 12:36 AM
To: Zhao, Forrest
Cc: SCSI Mailing List
Subject: Re: Proposal to add a new sysfs attribute to SCSI device

On Tue, 2005-03-22 at 11:05 +0800, Zhao, Forrest wrote:
> Let me tell you the testing experience in our lab: 
> 1 we install kernel 2.6.11.2 on a Tiger4 platform, 
> 2 there're two SCSI disks, one is sda for root fs, the other is sdb for
> /mnt
> 3 execute "cp -r /usr/src/linux-2.6.11.2 /mnt"
> 4 during the process of copying, we surprise-removed sdb 
> 5 then system become very busy and freezing, even the user can't login
> into the system whether locally or remotely
> 6 the error output on the screen demonstrates that SCSI mid-layer is
> endless retrying the failed I/O requests

Which HBA driver is this?  As long as the HBA can recognise the device
is missing, the retries should go very fast because it's simply a bounce
between the eh thread and the driver.

James


