From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: [PATCH v2 4/7] ibmvscsi: Use of_root to access OF device tree root node
Date: Wed, 10 Feb 2016 19:32:25 -0600
Message-ID: <1455154348-3226-5-git-send-email-tyreld@linux.vnet.ibm.com>
References: <1455154348-3226-1-git-send-email-tyreld@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:52900 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585AbcBKBco (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Feb 2016 20:32:44 -0500
Received: from localhost
	by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <tyreld@linux.vnet.ibm.com>;
	Wed, 10 Feb 2016 18:32:44 -0700
In-Reply-To: <1455154348-3226-1-git-send-email-tyreld@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, nfont@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, jthumshirn@suse.de, manoj@linux.vnet.ibm.com, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>

The root node of the OF device tree is exported as of_root. No need
to look up the root by path name. Instead just get a reference
directly via of_root.

Signed-off-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/ibmvscsi/ibmvscsi.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 4b09a9b..c208295 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -248,25 +248,23 @@ static void ibmvscsi_task(void *data)
 
 static void gather_partition_info(void)
 {
-	struct device_node *rootdn;
-
 	const char *ppartition_name;
 	const __be32 *p_number_ptr;
 
 	/* Retrieve information about this partition */
-	rootdn = of_find_node_by_path("/");
-	if (!rootdn) {
+	if (!of_root)
 		return;
-	}
 
-	ppartition_name = of_get_property(rootdn, "ibm,partition-name", NULL);
+	of_node_get(of_root);
+
+	ppartition_name = of_get_property(of_root, "ibm,partition-name", NULL);
 	if (ppartition_name)
 		strncpy(partition_name, ppartition_name,
 				sizeof(partition_name));
-	p_number_ptr = of_get_property(rootdn, "ibm,partition-no", NULL);
+	p_number_ptr = of_get_property(of_root, "ibm,partition-no", NULL);
 	if (p_number_ptr)
 		partition_number = of_read_number(p_number_ptr, 1);
-	of_node_put(rootdn);
+	of_node_put(of_root);
 }
 
 static void set_adapter_info(struct ibmvscsi_host_data *hostdata)
-- 
2.5.0

