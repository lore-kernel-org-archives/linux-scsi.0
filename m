From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 05/28] fnic: fix memory leak
Date: Fri, 28 Jan 2011 16:03:36 -0800
Message-ID: <20110129000336.1784.24707.stgit@localhost6.localdomain6>
References: <20110129000310.1784.58748.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:9625 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753732Ab1A2ADh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Jan 2011 19:03:37 -0500
In-Reply-To: <20110129000310.1784.58748.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Abhijeet Joglekar <abjoglek@cisco.com>, Venkata Siva Vijayendra Bhamidipati <vbhamidi@cisco.com>

From: Venkata Siva Vijayendra Bhamidipati <vbhamidi@cisco.com>

Fix memory leak arising due to incorrect freeing of allocated memory
for vnic stats when unregistering a vnic.

Signed-off-by: Abhijeet Joglekar <abjoglek@cisco.com>
Signed-off-by: Venkata Siva Vijayendra Bhamidipati <vbhamidi@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fnic/vnic_dev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/fnic/vnic_dev.c b/drivers/scsi/fnic/vnic_dev.c
index db71014..b576be7 100644
--- a/drivers/scsi/fnic/vnic_dev.c
+++ b/drivers/scsi/fnic/vnic_dev.c
@@ -654,7 +654,7 @@ void vnic_dev_unregister(struct vnic_dev *vdev)
 				vdev->linkstatus_pa);
 		if (vdev->stats)
 			pci_free_consistent(vdev->pdev,
-				sizeof(struct vnic_dev),
+				sizeof(struct vnic_stats),
 				vdev->stats, vdev->stats_pa);
 		if (vdev->fw_info)
 			pci_free_consistent(vdev->pdev,

