From: Andi Kleen <ak@muc.de>
Subject: [PATCH] Add compat_ioctl to scsi host structure
Date: 18 Jan 2005 12:03:54 +0100
Message-ID: <20050118110354.GB43344@muc.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from colin2.muc.de ([193.149.48.15]:29971 "HELO colin2.muc.de")
	by vger.kernel.org with SMTP id S261260AbVARLDz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jan 2005 06:03:55 -0500
Date: Tue, 18 Jan 2005 12:03:54 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org


Add a call vector for 32bit compat ioctls to the SCSI host
structure. This is needed for some followon patches.

Signed-off-by: Andi Kleen <ak@muc.de>

diff -u linux-2.6.11-rc1-bk4/include/scsi/scsi_host.h-o linux-2.6.11-rc1-bk4/include/scsi/scsi_host.h
--- linux-2.6.11-rc1-bk4/include/scsi/scsi_host.h-o	2005-01-14 10:12:26.000000000 +0100
+++ linux-2.6.11-rc1-bk4/include/scsi/scsi_host.h	2005-01-18 03:05:31.000000000 +0100
@@ -71,6 +71,16 @@
 	 * Status: OPTIONAL
 	 */
 	int (* ioctl)(struct scsi_device *dev, int cmd, void __user *arg);
+
+
+	/* 
+	 * Compat handler. Handle 32bit ABI.
+	 * When unknown ioctl is passed return -ENOIOCTLCMD.
+	 * When called the BKL is not hold.
+	 * Status: OPTIONAL
+	 */
+	int (* compat_ioctl)(struct scsi_device *dev, int cmd, void __user *arg);
+
 	
 	/*
 	 * The queuecommand function is used to queue up a scsi
