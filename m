From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 6/8] Fix spi initialisation failure
Date: Tue, 18 Mar 2008 14:32:28 +0100
Message-ID: <20080318133228.6DFD9159159@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43708 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775AbYCRNcd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Mar 2008 09:32:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org


With the target rework we cannot set the attribute of the
sysfs files as the sysfs object is not registered yet. So
just modify the attribute itself.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_transport_spi.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index bc12b5d..4f9c98c 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -1473,13 +1473,13 @@ static int spi_target_configure(struct transport_container *tc,
 		 * to ignore, sysfs also does a WARN_ON and dumps a trace,
 		 * which is bad, so temporarily, skip attributes that are
 		 * already visible (the revalidate one) */
-		if (j && attr != &dev_attr_revalidate.attr)
+		if (j && attr != &dev_attr_revalidate.attr) {
+			if ((j & 1))
+				attr->mode |= S_IWUSR;
+
 			rc = sysfs_add_file_to_group(kobj, attr,
 						target_attribute_group.name);
-		/* and make the attribute writeable if we have a set
-		 * function */
-		if ((j & 1))
-			rc = sysfs_chmod_file(kobj, attr, attr->mode | S_IWUSR);
+		}
 	}
 
 	return 0;
-- 
1.5.2.4

