From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: [PATCH 4/6] ibmvscsi: Use of_root to access OF device tree root node
Date: Wed,  3 Feb 2016 17:28:32 -0600
Message-ID: <1454542114-1797-5-git-send-email-tyreld@linux.vnet.ibm.com>
References: <1454542114-1797-1-git-send-email-tyreld@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1454542114-1797-1-git-send-email-tyreld@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, nfont@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, hare@suse.de, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

The root node of the OF device tree is exported as of_root. No need
to look up the root by path name. Instead just get a reference
directly via of_root.

Signed-off-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvscsi.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 7e51615..47cfe33 100644
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
