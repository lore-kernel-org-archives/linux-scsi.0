From: Jamie Lenehan <lenehan@twibble.org>
Subject: [PATCH] dc395x [5/6] - check for device
Date: Thu, 21 Aug 2003 20:17:29 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030821101729.GF7570@twibble.org>
References: <20030821101348.GA7570@twibble.org> <20030821101434.GB7570@twibble.org> <20030821101525.GC7570@twibble.org> <20030821101619.GD7570@twibble.org> <20030821101658.GE7570@twibble.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tuon.twibble.org ([203.217.29.157]:39570 "EHLO tuon.twibble.org")
	by vger.kernel.org with ESMTP id S262569AbTHUKR3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Aug 2003 06:17:29 -0400
Content-Disposition: inline
In-Reply-To: <20030821101658.GE7570@twibble.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dc395x@twibble.org

After searching for a device to free, only free it if it was found.

diff -du -r a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
--- a/drivers/scsi/dc395x.c	2003-08-20 21:38:20.141105272 +1000
+++ b/drivers/scsi/dc395x.c	2003-08-20 21:38:26.892078968 +1000
@@ -4833,7 +4833,8 @@
 {
 	struct AdapterCtlBlk *acb = (struct AdapterCtlBlk *)scsi_device->host->hostdata;
 	struct DeviceCtlBlk *dcb = find_dcb(acb, scsi_device->id, scsi_device->lun);
-	adapter_remove_and_free_device(acb, dcb);
+	if (dcb)
+		adapter_remove_and_free_device(acb, dcb);
 }
 
 

-- 
 Jamie Lenehan <lenehan@twibble.org>
