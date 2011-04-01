From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 07/11] libfcoe: fix possible buffer overflow in
	fcoe_transport_show
Date: Fri, 01 Apr 2011 16:06:25 -0700
Message-ID: <20110401230625.15001.48362.stgit@localhost6.localdomain6>
References: <20110401230548.15001.2009.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:27763 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754427Ab1DAXGZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Apr 2011 19:06:25 -0400
In-Reply-To: <20110401230548.15001.2009.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Ross Brattain <ross.b.brattain@intel.com>, Tomas Henzl <thenzl@redhat.com>, Yi Zou <yi.zou@intel.com>

From: Yi Zou <yi.zou@intel.com>

possible buffer overflow in fcoe_transport_show when reaching the end of
buffer and crossing PAGE_SIZE boundary.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe_transport.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
index ec0f395..538f299 100644
--- a/drivers/scsi/fcoe/fcoe_transport.c
+++ b/drivers/scsi/fcoe/fcoe_transport.c
@@ -385,9 +385,9 @@ static int fcoe_transport_show(char *buffer, const struct kernel_param *kp)
 	i = j = sprintf(buffer, "Attached FCoE transports:");
 	mutex_lock(&ft_mutex);
 	list_for_each_entry(ft, &fcoe_transports, list) {
-		i += snprintf(&buffer[i], IFNAMSIZ, "%s ", ft->name);
-		if (i >= PAGE_SIZE)
+		if (i >= PAGE_SIZE - IFNAMSIZ)
 			break;
+		i += snprintf(&buffer[i], IFNAMSIZ, "%s ", ft->name);
 	}
 	mutex_unlock(&ft_mutex);
 	if (i == j)

