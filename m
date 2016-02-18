From: "Pocas, Jamie" <Jamie.Pocas@emc.com>
Subject: RE: [PATCH] target: Fix incorrect unmap_zeroes_data_store return
Date: Thu, 18 Feb 2016 16:41:07 +0000
Message-ID: <6726346952932A41A42F959D66A73B4C05F471@MX203CL03.corp.emc.com>
References: <1455174146-29700-1-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailuogwhop.emc.com ([168.159.213.141]:44169 "EHLO
	mailuogwhop.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946996AbcBRQl3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Feb 2016 11:41:29 -0500
In-Reply-To: <1455174146-29700-1-git-send-email-nab@daterainc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Nicholas Bellinger <nab@linux-iscsi.org>

Sorry about this. I am working on an older 3.10 codebase (RHEL7.x) where the equivalent function int se_dev_set_unmap_zeroes_data(struct se_device *dev, int flag) does and SHOULD return 0. There are apparently more changes between configfs in 3.10 and latest than I found. That one slipped by when I ported it up to latest. Good catch!

-----Original Message-----
From: Nicholas A. Bellinger [mailto:nab@daterainc.com] 
Sent: Thursday, February 11, 2016 2:02 AM
To: target-devel; linux-scsi
Cc: Christoph Hellwig; Pocas, Jamie; Nicholas Bellinger
Subject: [PATCH] target: Fix incorrect unmap_zeroes_data_store return

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes an incorrect return of zero from the new
unmap_zeroes_data_store() configfs store attribute handler introduced in v4.5-rc1, to use the correct 'count' bytes return value.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_configfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 3327c49..713c63d9 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -898,7 +898,7 @@ static ssize_t unmap_zeroes_data_store(struct config_item *item,
 	da->unmap_zeroes_data = flag;
 	pr_debug("dev[%p]: SE Device Thin Provisioning LBPRZ bit: %d\n",
 		 da->da_dev, flag);
-	return 0;
+	return count;
 }
 
 /*
--
1.9.1

