From: "Anil Veerabhadrappa" <anilgv@broadcom.com>
Subject: [PATCH 2/5 ] BNX2I - Adjust sq_size module parametr to power of
 2 only if a non-zero value is specified
Date: Mon, 7 Dec 2009 11:39:54 -0800
Message-ID: <1260214794.31468.93.camel@anilgv-desktop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1438 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932233AbZLGTj7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Dec 2009 14:39:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, michaelc@cs.wisc.edu, mchan@broadcom.com, poswald@novell.com


    * This issue was discovered during 10G iscsi testing
    * Default value of 'sq_size' module parameter is '0' which means
      driver should use predefined SQ queue size when setting up iscsi
      connection.
    * roundup_pow_of_two(0) results in '1' and forces driver to setup
      connections with send queue size of '1' and results in lower
      performance as well

Signed-off-by: Anil Veerabhadrappa <anilgv@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i_init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_init.c b/drivers/scsi/bnx2i/bnx2i_init.c
index 3c46458..dc6b56c 100644
--- a/drivers/scsi/bnx2i/bnx2i_init.c
+++ b/drivers/scsi/bnx2i/bnx2i_init.c
@@ -367,7 +367,7 @@ static int __init bnx2i_mod_init(void)
 
 	printk(KERN_INFO "%s", version);
 
-	if (!is_power_of_2(sq_size))
+	if (sq_size && !is_power_of_2(sq_size))
 		sq_size = roundup_pow_of_two(sq_size);
 
 	mutex_init(&bnx2i_dev_lock);
-- 
1.6.5.1




