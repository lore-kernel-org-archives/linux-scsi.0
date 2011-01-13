From: Yi Zou <yi.zou@intel.com>
Subject: [PATCH v3 09/10] libfcoe: Handle ERESTARTSYS for fcoe transport
Date: Wed, 12 Jan 2011 18:20:36 -0800
Message-ID: <20110113022035.12798.20350.stg.yi.zou@intel.com>
References: <20110113021649.12798.71742.stg.yi.zou@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:23367 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932361Ab1AMCXa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Jan 2011 21:23:30 -0500
In-Reply-To: <20110113021649.12798.71742.stg.yi.zou@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: devel@open-fcoe.org
Cc: bprakash@broadcom.com, linux-scsi@vger.kernel.org

From: Bhanu Gollapudi <bprakash@broadcom.com>

When the LLDDs return ERESTARTSYS as a result of not succeeding
rtnl_trylock(), fcoe_transport_* functions should return
restart_syscall().

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Signed-off-by: Yi Zou <yi.zou@intel.com>
---

 drivers/scsi/fcoe/fcoe_transport.c |   21 +++++++++++++++++----
 1 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
index 8a630aa..95fe16b 100644
--- a/drivers/scsi/fcoe/fcoe_transport.c
+++ b/drivers/scsi/fcoe/fcoe_transport.c
@@ -360,7 +360,10 @@ out_nodev:
 		(rc) ? "failed" : "succeeded",
 		(netdev) ? netdev->name : "n/a");
 
-	return rc;
+	if (rc == -ERESTARTSYS)
+		return restart_syscall();
+	else
+		return rc;
 }
 
 /**
@@ -420,7 +423,10 @@ out_nodev:
 		(rc) ? "failed" : "succeeded",
 		(netdev) ? netdev->name : "n/a");
 
-	return rc;
+	if (rc == -ERESTARTSYS)
+		return restart_syscall();
+	else
+		return rc;
 }
 
 /**
@@ -472,7 +478,11 @@ out_putdev:
 	dev_put(netdev);
 out_nodev:
 	mutex_unlock(&ft_mutex);
-	return rc;
+
+	if (rc == -ERESTARTSYS)
+		return restart_syscall();
+	else
+		return rc;
 }
 
 /**
@@ -524,7 +534,10 @@ out_putdev:
 	dev_put(netdev);
 out_nodev:
 	mutex_unlock(&ft_mutex);
-	return rc;
+	if (rc == -ERESTARTSYS)
+		return restart_syscall();
+	else
+		return rc;
 }
 
 /**

