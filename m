From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] initialize shost_data to zero
Date: Wed, 01 Aug 2007 08:40:27 +0900
Message-ID: <20070801084027X.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:38078 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756310AbXGaXkj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Jul 2007 19:40:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

It's better to initialize host->shost_data to zero like
target->starget_data and device->sdev_data.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/hosts.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index bd8e7f3..96bc312 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -220,7 +220,7 @@ int scsi_add_host(struct Scsi_Host *shost, struct device *dev)
 	get_device(&shost->shost_gendev);
 
 	if (shost->transportt->host_size &&
-	    (shost->shost_data = kmalloc(shost->transportt->host_size,
+	    (shost->shost_data = kzalloc(shost->transportt->host_size,
 					 GFP_KERNEL)) == NULL)
 		goto out_del_classdev;
 
-- 
1.5.2.4

