From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: [PATCH 2.4 ] MPT Fusion driver 2.05.16 update
Date: Mon, 26 Apr 2004 17:59:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E570442CB4F@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:10390 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S263609AbUDZV7w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Apr 2004 17:59:52 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: marcelo.tosatti@cyclades.com

This is an update for the MPT Fusion drivers 2.4 kernel.

This is mpt version is 2.05.16  The attached patch is made
against 2.05.11.03 driver found in 2.4.25 kernel or later.


----------------------------------------------------------------

Changelog for 2.05.16, Release Date: March 17, 2004

(1) SDTR/WDTR Disallow bits were not being set
in Device Configuration Page 1 for SEP devices.
(2) Increase the timeout in RAID Action Request
from 2 to 10 seconds.  Under stress conditions, the
QUIESCE_PHYS_IO action request was taking longer 
than 2 seconds timeout to complete, thus resulting
in the driver going into a host bus reset.
(3) Replace sys_ioctl with our own defined function
compat_mptctl_ioctl. This removes the warning messages.

--------------------------------------------------


Changelog for 2.05.15, Release Date: March 16, 2004

(1) Processing of an IOCStatus of 
MPI_IOCSTATUS_SCSI_RESIDUAL_MISMATCH was changed to
allow the OS SCSI layer to retry the command.
(2) Firmware upload and downloadboot was 
simplified to match the algorithms in the MPI 1.2 spec.

--------------------------------------------------


Changelog for 2.05.14, Release Date: March 8, 2004

(1) Search IOCPage3 for Id being a physical drive
of a volume.  If so, don't include its information in 
Ioctl TargetInfo data.
(2) Default to QAS before checking for QAS capable
in inquiry data.  This allows Ultra320 drives to
operate with QAS in SuSE systems.

--------------------------------------------------

Changelog for 2.05.13, Release Date: Feb 20, 2004

(1) Read IOCPage2 and IOCPage3 on each Ioctl 
TargetInfo request.  Prevents stale data from being 
used if volume is changed while the driver is operational
(via Ioctl interface).
(2) Extend time to at least 5 seconds for Doorbell
Interrupt and Ack checks.
(3) Allow Check Conditions to take precedence over
data length checks in DATA_UNDERRUN error processing.

--------------------------------------------------

Changelog for 2.05.12, Release Date: Feb 6, 2004


(1) The driver now supports the FC929XL.  
(2) The driver now supports I2C requirements. 
Toolbox message generation and processing has been 
added to IOCTL processing.
(3) Rpm and DUD files are now available for 
Redhat 3.0 on ia64 machines.
(4) Added code to check for QAS enabled or disabled 
in SCSI Port Page 0.  Ultra 320 negotiations will reflect 
the QAS setting in SCSI Port Page 0.
(5) Added code to obtain IOC Page 2 data in order to 
provide Volume data in Target Info Data returned by an IOCTL
request.
(6) Fixed Target Info code to prevent overrunning the 
data buffer length provided by the application.  Also fixed 
that code to include checking for the last id on the IOC.
(7) Added code in the data underrun response processing
 to return an error code if no data was transferred.
(9) Added code to properly set each device's queue_depth
 for Fibre Channel devices.
(10) Fixed code to allow Ioctl operation on ia64 machines.
(11) Performance enhancements were made.


You can download full source as well as the patches for this 
driver at:
ftp://ftp.lsil.com/HostAdapterDrivers/linux/FiberChannel/2.05.16


Eric Moore
Staff Engineer
Standard Storage Products Division
LSI Logic Corporation
4420 Arrowswest Drive
Colorado Springs, CO 80907
Tel: (719) 533-7056
Email: emoore@lsil.com
Web: http://www.lsilogic.com/
