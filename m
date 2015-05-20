From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH] iscsi: Fix iscsi endpoints leak
Date: Wed, 20 May 2015 12:38:58 +0300
Message-ID: <1432114738-967-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1327.ztomy.com ([193.47.165.129]:37715 "EHLO mellanox.co.il"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753007AbbETJjY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 May 2015 05:39:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, Or Gerlitz <ogerlitz@mellanox.com>, Alex Lyakas <alex@zadarastorage.com>

When creating a new endpoint, we look for a free id
for the new endpoint. We baisically loop on possible ids
and use the first id that class_find_device() returns NULL.
However, we are missing a reference put when class_find_device()
does find an existing device for a given id.

Reported-by: Alex Lyakas <alex@zadarastorage.com>
Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/scsi/scsi_transport_iscsi.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 67d43e3..55647aa 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -204,6 +204,8 @@ iscsi_create_endpoint(int dd_size)
 					iscsi_match_epid);
 		if (!dev)
 			break;
+		else
+			put_device(dev);
 	}
 	if (id == ISCSI_MAX_EPID) {
 		printk(KERN_ERR "Too many connections. Max supported %u\n",
-- 
1.7.1

