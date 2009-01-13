From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: [PATCH] next-20090113 - scsi_debug fails with CONFIG_CRC_T10DIF=n
Date: Tue, 13 Jan 2009 18:32:15 +0530
Message-ID: <20090113130215.GD2364@linux.vnet.ibm.com>
References: <20090113175145.cdfa9c6a.sfr@canb.auug.org.au>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:60490 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbZAMNCT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jan 2009 08:02:19 -0500
Content-Disposition: inline
In-Reply-To: <20090113175145.cdfa9c6a.sfr@canb.auug.org.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

Hi Stephen,

    next-20090113 kernel randconfig fails with

ERROR: "crc_t10dif" [drivers/scsi/scsi_debug.ko] undefined!
make[1]: *** [__modpost] Error 1

Impact: Fix the dependency of scsi_debug on crc-t10dif library

scsi_debug calls the functions exported by crc-t10dif library,
adding dependency to select CONFIG_CRC_T10DIF

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
---
 drivers/scsi/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
old mode 100644
new mode 100755
index d25d21e..32ccf96
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1535,6 +1535,7 @@ config SCSI_NSP32
 config SCSI_DEBUG
 	tristate "SCSI debugging host simulator"
 	depends on SCSI
+	select CRC_T10DIF
 	help
 	  This is a host adapter simulator that can simulate multiple hosts
 	  each with multiple dummy SCSI devices (disks). It defaults to one
-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
