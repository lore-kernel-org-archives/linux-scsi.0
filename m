From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 06/11] libfcoe: clean up netdev mapping properly when the
	transport goes away
Date: Fri, 01 Apr 2011 16:06:19 -0700
Message-ID: <20110401230619.15001.49648.stgit@localhost6.localdomain6>
References: <20110401230548.15001.2009.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:13353 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753995Ab1DAXGV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Apr 2011 19:06:21 -0400
In-Reply-To: <20110401230548.15001.2009.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Ross Brattain <ross.b.brattain@intel.com>, Yi Zou <yi.zou@intel.com>

From: Yi Zou <yi.zou@intel.com>

When rmmoving the underlying fcoe transport driver module by force when
it's attached and in use, the correspoding netdev mapping should be
cleaned up properly as well, otherwise the lookup for a given netdev
for the transport would still return non NULL pointer, causing "unable
to handle paging request" bug.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe_transport.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
index 7b61d00..ec0f395 100644
--- a/drivers/scsi/fcoe/fcoe_transport.c
+++ b/drivers/scsi/fcoe/fcoe_transport.c
@@ -343,6 +343,7 @@ EXPORT_SYMBOL(fcoe_transport_attach);
 int fcoe_transport_detach(struct fcoe_transport *ft)
 {
 	int rc = 0;
+	struct fcoe_netdev_mapping *nm = NULL, *tmp;
 
 	mutex_lock(&ft_mutex);
 	if (!ft->attached) {
@@ -352,6 +353,19 @@ int fcoe_transport_detach(struct fcoe_transport *ft)
 		goto out_attach;
 	}
 
+	/* remove netdev mapping for this transport as it is going away */
+	mutex_lock(&fn_mutex);
+	list_for_each_entry_safe(nm, tmp, &fcoe_netdevs, list) {
+		if (nm->ft == ft) {
+			LIBFCOE_TRANSPORT_DBG("transport %s going away, "
+				"remove its netdev mapping for %s\n",
+				ft->name, nm->netdev->name);
+			list_del(&nm->list);
+			kfree(nm);
+		}
+	}
+	mutex_unlock(&fn_mutex);
+
 	list_del(&ft->list);
 	ft->attached = false;
 	LIBFCOE_TRANSPORT_DBG("detaching transport %s\n", ft->name);

