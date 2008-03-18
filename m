From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 2/8] Fixup initialisation oops for anonymous transport
 classes
Date: Tue, 18 Mar 2008 14:32:28 +0100
Message-ID: <20080318133228.53EAE1F60F@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:43715 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752776AbYCRNcd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Mar 2008 09:32:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org


Anonymous transport classes might call transport_add_class_devices
with NULL classdev.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/base/transport_class.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/base/transport_class.c b/drivers/base/transport_class.c
index 72cf462..61a611c 100644
--- a/drivers/base/transport_class.c
+++ b/drivers/base/transport_class.c
@@ -150,10 +150,16 @@ static int transport_add_class_device(struct attribute_container *cont,
 				      struct device *dev,
 				      struct device *classdev)
 {
-	int error = attribute_container_add_class_device(classdev);
+	int error;
 	struct transport_container *tcont = 
 		attribute_container_to_transport_container(cont);
 
+	/* NULL if called from anonymous transport classes */
+	if (!classdev)
+		return 0;
+
+	error = attribute_container_add_class_device(classdev);
+
 	if (!error && tcont->statistics)
 		error = sysfs_create_group(&classdev->kobj, tcont->statistics);
 
-- 
1.5.2.4

