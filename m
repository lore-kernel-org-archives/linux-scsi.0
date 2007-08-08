From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH] [MEGARAID_SAS]: Remove needless memset in megasas_init
Date: Wed, 8 Aug 2007 20:14:04 -0300
Message-ID: <20070808231404.GA3375@ghostprotocols.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.239]:43184 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933522AbXHHXOM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Aug 2007 19:14:12 -0400
Received: by wx-out-0506.google.com with SMTP id h31so245482wxd
        for <linux-scsi@vger.kernel.org>; Wed, 08 Aug 2007 16:14:11 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: megaraidlinux@lsi.com
Cc: linux-scsi@vger.kernel.org, James Bottomley <jejb@steeleye.com>

megasas_mgmt_info is a static variable, so goes to .bss thus zeroed at boot.

Signed-off-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
---
 drivers/scsi/megaraid/megaraid_sas.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.c b/drivers/scsi/megaraid/megaraid_sas.c
index ebb948c..59099da 100644
--- a/drivers/scsi/megaraid/megaraid_sas.c
+++ b/drivers/scsi/megaraid/megaraid_sas.c
@@ -3033,8 +3033,6 @@ static int __init megasas_init(void)
 	printk(KERN_INFO "megasas: %s %s\n", MEGASAS_VERSION,
 	       MEGASAS_EXT_VERSION);
 
-	memset(&megasas_mgmt_info, 0, sizeof(megasas_mgmt_info));
-
 	/*
 	 * Register character device node
 	 */
-- 
1.5.2.2

