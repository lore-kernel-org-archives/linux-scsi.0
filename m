From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 1/1] osd_uld: Bump MAX_OSD_DEVICES from 64 to 1,048,576
Date: Wed, 25 Jan 2012 21:42:58 +0200
Message-ID: <4F205B42.9020200@panasas.com>
References: <4F205AAF.7000305@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from natasha.panasas.com ([67.152.220.90]:46319 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab2AYTnO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jan 2012 14:43:14 -0500
In-Reply-To: <4F205AAF.7000305@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd <osd-dev@open-osd.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>
Cc: "Welch, Brent" <welch@panasas.com>, "Bhamare, Sachin" <sbhamare@panasas.com>, Stable Tree <stable@vger.kernel.org>


It used to be that minors where 8 bit. But now they
are actually 20 bit. So the fix is simplicity itself.

I've tested with 300 devices and all user-mode utils
work just fine. I have also mechanically added 10,000
to the ida (so devices are /dev/osd10000, /dev/osd10001 ...)
and was able to mkfs an exofs filesystem and access osds
from user-mode.

All the open-osd user-mode code uses the same library
to access devices through their symbolic names in
/dev/osdX so I'd say it's pretty safe. (Well tested)

This patch is very important because some of the systems
that will be deploying the 3.2 pnfs-objects code are larger
than 64 OSDs and will stop to work properly when reaching
that number.

CC: Stable <stable@vger.kernel.org>
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/osd/osd_uld.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c
index b31a8e3..d4ed9eb 100644
--- a/drivers/scsi/osd/osd_uld.c
+++ b/drivers/scsi/osd/osd_uld.c
@@ -69,10 +69,10 @@
 #ifndef SCSI_OSD_MAJOR
 #  define SCSI_OSD_MAJOR 260
 #endif
-#define SCSI_OSD_MAX_MINOR 64
+#define SCSI_OSD_MAX_MINOR MINORMASK
 
 static const char osd_name[] = "osd";
-static const char *osd_version_string = "open-osd 0.2.0";
+static const char *osd_version_string = "open-osd 0.2.1";
 
 MODULE_AUTHOR("Boaz Harrosh <bharrosh@panasas.com>");
 MODULE_DESCRIPTION("open-osd Upper-Layer-Driver osd.ko");
-- 
1.7.2.3


