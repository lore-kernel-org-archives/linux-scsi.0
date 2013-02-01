From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH v2 2/8] [SCSI] Add a kernel config option for enhanced Unit Attention support
Date: Fri,  1 Feb 2013 12:53:09 -0500
Message-ID: <1359741195-2641-3-git-send-email-emilne@redhat.com>
References: <1359741195-2641-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757081Ab3BARxS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Feb 2013 12:53:18 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r11HrIXO003306
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Fri, 1 Feb 2013 12:53:18 -0500
Received: from emilne.csb (dhcp-186-175.bos.redhat.com [10.16.186.175])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r11HrGRf011917
	for <linux-scsi@vger.kernel.org>; Fri, 1 Feb 2013 12:53:17 -0500
In-Reply-To: <1359741195-2641-1-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

Added CONFIG_SCSI_ENHANCED_UA kernel config option to enable changes
in the SCSI mid-layer which detect and report certain Unit Attention
conditions reported by devices.  These changes are primarily useful
when storage arrays that can be reconfigured are being used, so the
config option would normally not be used unless it was needed.

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/Kconfig | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index e955978..5d1e614 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -280,6 +280,18 @@ config SCSI_WAIT_SCAN
 # disabling it, whereas people who accidentally switch it off may wonder why
 # their mkinitrd gets into trouble.
 
+config SCSI_ENHANCED_UA
+       bool "Enhanced SCSI Unit Attention handling"
+       depends on SCSI
+       help
+	 Certain SCSI devices report changes via a UNIT ATTENTION code.
+	 (For example, the addition or removal of LUNs from a target, or
+	 changing the number of logical blocks on a LUN.)  This option
+	 enables reporting of these changes via udev events, so that the
+	 device can be rescanned to find out what has changed.  This is
+	 primarily useful when storage arrays that can be reconfigured
+	 are attached to the system, otherwise you can say N here.
+
 menu "SCSI Transports"
 	depends on SCSI
 
-- 
1.7.11.7

