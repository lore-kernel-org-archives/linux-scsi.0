From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: [PATCH] - MPT FUSION - SPLITTING SCSI HOST DRIVERS
Date: Thu, 24 Mar 2005 16:56:30 -0700
Message-ID: <91888D455306F94EBD4D168954A9457C01B7055E@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Received: from mail0.lsil.com ([147.145.40.20]:3809 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261250AbVCXX4e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Mar 2005 18:56:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Here are several patches(7) which follow this email.

These patches are for the mpt fusion scsi host drivers, which separate
the scsi host drivers into separate bus type kernel modules.  This was
requested
by several people on the linux-scsi@ forum, so our driver can properly
support 
the various transport layers; e.g. SPI, FC, and eventually SAS.  In these
set of patches
the Fiber Channel controllers are moved to a new driver called mptfch.ko.
The current
Parallel SCSI controllers will remain with mptscsih.ko.  Eventually we will
be adding SAS support
in the new modules that will be mptsash.ko.  

Overview of patches
(1) mptlinux-3.03.00-1-misc - Kconfig and Makefile changes, for new
separated drivers.
(2) mptlinux-3.03.00-2-mptscsih-c - delete mptscsih.c , code moved to
mptcore.c
(3) mptlinux-3.03.00-3-mptscsih-h - delete mptscsih.h, code moved to
mptscsi.h
(4) mptlinux-3.03.00-4-mpt-core-c - formerly mptscsih.c. This will be
compiled linked between mptscsi.c and mptfc.c
(5) mptlinux-3.03.00-5-mptscsi-h - formerly mptscsih.c
(6) mptlinux-3.03.00-6-mptscsi-c - SPI driver, having only module_init,
module_exit, and probe.
(7) mptlinux-3.03.00-7-mptfc-c - FC driver, having only module_init,
module_exit, and probe.

Please apply this patch against the 3.01.20 version of the mpt driver
in http://linux-scsi.bkbits.net:8080/scsi-misc-2.6

Backup of these patches can be found at this ftp:
ftp://ftp.lsil.com/HostAdapterDrivers/linux/Fusion-MPT/2.6-kernel/3.03.00/

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>
