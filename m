From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] scsi: sd: configurable allow_restart attribute for all device
 types
Date: Tue, 21 Nov 2006 21:34:08 +0100 (CET)
Message-ID: <tkrat.b0153a503f02a550@s5r6.in-berlin.de>
References: <455DF39A.6090209@fbihome.de> <455E2D44.5030903@gmx.de>
 <455E4703.3080005@s5r6.in-berlin.de> <456188FD.3020108@fbihome.de>
 <45619611.5020502@s5r6.in-berlin.de> <45622CF5.507@fbihome.de>
 <45624009.3040208@s5r6.in-berlin.de> <45624E30.5080605@torque.net>
 <45631017.4080601@us.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:62389 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1031420AbWKUUqY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Nov 2006 15:46:24 -0500
In-Reply-To: <45631017.4080601@us.ibm.com>
Content-Disposition: INLINE
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Douglas Gilbert <dougg@torque.net>, Joern Quillman <quillman@fbihome.de>, Brian King <brking@us.ibm.com>, James Bottomley <James.Bottomley@SteelEye.com>

It is not necessary to restrict run-time configuration of sd's
allow_restart attribute to SBC disks.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
Index: linux-2.6.19-rc6/drivers/scsi/sd.c
===================================================================
--- linux-2.6.19-rc6.orig/drivers/scsi/sd.c	2006-10-10 18:18:45.000000000 +0200
+++ linux-2.6.19-rc6/drivers/scsi/sd.c	2006-11-21 21:15:10.000000000 +0100
@@ -216,9 +216,6 @@ static ssize_t sd_store_allow_restart(st
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	if (sdp->type != TYPE_DISK)
-		return -EINVAL;
-
 	sdp->allow_restart = simple_strtoul(buf, NULL, 10);
 
 	return count;


