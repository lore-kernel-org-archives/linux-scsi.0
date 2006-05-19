From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: [PATCH] ppa: no highmem pages
Date: Thu, 18 May 2006 22:07:44 -0700
Message-ID: <20060518220744.cb986f3f.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:16526 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S932233AbWESFFQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 May 2006 01:05:16 -0400
Received: from midway.site ([71.245.102.105]) by xenotime.net for <linux-scsi@vger.kernel.org>; Thu, 18 May 2006 22:05:14 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: jejb <james.bottomley@steeleye.com>, akpm <akpm@osdl.org>

From: Randy Dunlap <rdunlap@xenotime.net>

ppa cannot handle highmem pages, and like imm, which already has
this patch, the device is slow, so performance is not a big issue,
so just force pages to be in low memory (hence mapped).

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/scsi/ppa.c |    4 ++++
 1 files changed, 4 insertions(+)

--- linux-2.6.17-rc4.orig/drivers/scsi/ppa.c
+++ linux-2.6.17-rc4/drivers/scsi/ppa.c
@@ -997,6 +997,10 @@ static struct scsi_host_template ppa_tem
 	.cmd_per_lun		= 1,
 	.use_clustering		= ENABLE_CLUSTERING,
 	.can_queue		= 1,
+	.unchecked_isa_dma	= 1, /* ppa cannot deal with highmem, so
+				      * this is an easy trick to ensure
+				      * all io pages for this host reside
+				      * in low memory */
 };
 
 /***************************************************************************


---
