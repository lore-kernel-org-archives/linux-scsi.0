From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [PATCH 3/8] zfcp: (cleanup) kmalloc/kzalloc replacement
Date: Mon, 22 May 2006 18:17:30 +0200
Message-ID: <20060522161730.GA25247@lion28.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:29957 "EHLO
	mtagate2.uk.ibm.com") by vger.kernel.org with ESMTP
	id S1750957AbWEVQUD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 May 2006 12:20:03 -0400
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate2.uk.ibm.com (8.13.6/8.13.6) with ESMTP id k4MGK33G110892
	for <linux-scsi@vger.kernel.org>; Mon, 22 May 2006 16:20:03 GMT
Received: from d06av02.portsmouth.uk.ibm.com (d06av02.portsmouth.uk.ibm.com [9.149.37.228])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k4MGL42o090674
	for <linux-scsi@vger.kernel.org>; Mon, 22 May 2006 17:21:04 +0100
Received: from d06av02.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av02.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k4MGK20p017295
	for <linux-scsi@vger.kernel.org>; Mon, 22 May 2006 17:20:02 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>

zfcp: (cleanup) kmalloc/kzalloc replacement

Replace kmalloc/memset by kzalloc or kcalloc.

Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>

---

cff9610bc6b60ba8e4c90a2314151e835addac8f
 drivers/s390/scsi/zfcp_aux.c  |   15 +++++----------
 drivers/s390/scsi/zfcp_erp.c  |    9 +++------
 drivers/s390/scsi/zfcp_scsi.c |    6 ++----
 3 files changed, 10 insertions(+), 20 deletions(-)

cff9610bc6b60ba8e4c90a2314151e835addac8f
diff --git a/drivers/s390/scsi/zfcp_aux.c b/drivers/s390/scsi/zfcp_aux.c
index 12bc8f2..4a17ce4 100644
--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -289,12 +289,11 @@ zfcp_cfdc_dev_ioctl(struct file *file, u
 		goto out;
 	}
 
-	sg_list = kmalloc(sizeof(struct zfcp_sg_list), GFP_KERNEL);
+	sg_list = kzalloc(sizeof(struct zfcp_sg_list), GFP_KERNEL);
 	if (sg_list == NULL) {
 		retval = -ENOMEM;
 		goto out;
 	}
-	memset(sg_list, 0, sizeof(*sg_list));
 
 	if (command != ZFCP_CFDC_IOC) {
 		ZFCP_LOG_INFO("IOC request code 0x%x invalid\n", command);
@@ -476,14 +475,13 @@ zfcp_sg_list_alloc(struct zfcp_sg_list *
 	sg_list->count = size >> PAGE_SHIFT;
 	if (size & ~PAGE_MASK)
 		sg_list->count++;
-	sg_list->sg = kmalloc(sg_list->count * sizeof(struct scatterlist),
+	sg_list->sg = kcalloc(sg_list->count, sizeof(struct scatterlist),
 			      GFP_KERNEL);
 	if (sg_list->sg == NULL) {
 		sg_list->count = 0;
 		retval = -ENOMEM;
 		goto out;
 	}
-	memset(sg_list->sg, 0, sg_list->count * sizeof(struct scatterlist));
 
 	for (i = 0, sg = sg_list->sg; i < sg_list->count; i++, sg++) {
 		sg->length = min(size, PAGE_SIZE);
@@ -756,10 +754,9 @@ zfcp_unit_enqueue(struct zfcp_port *port
 	if (unit)
 		return NULL;
 
-	unit = kmalloc(sizeof (struct zfcp_unit), GFP_KERNEL);
+	unit = kzalloc(sizeof (struct zfcp_unit), GFP_KERNEL);
 	if (!unit)
 		return NULL;
-	memset(unit, 0, sizeof (struct zfcp_unit));
 
 	/* initialise reference count stuff */
 	atomic_set(&unit->refcount, 0);
@@ -927,13 +924,12 @@ zfcp_adapter_enqueue(struct ccw_device *
 	 */
 
 	/* try to allocate new adapter data structure (zeroed) */
-	adapter = kmalloc(sizeof (struct zfcp_adapter), GFP_KERNEL);
+	adapter = kzalloc(sizeof (struct zfcp_adapter), GFP_KERNEL);
 	if (!adapter) {
 		ZFCP_LOG_INFO("error: allocation of base adapter "
 			      "structure failed\n");
 		goto out;
 	}
-	memset(adapter, 0, sizeof (struct zfcp_adapter));
 
 	ccw_device->handler = NULL;
 
@@ -1137,10 +1133,9 @@ zfcp_port_enqueue(struct zfcp_adapter *a
 			return NULL;
 	}
 
-	port = kmalloc(sizeof (struct zfcp_port), GFP_KERNEL);
+	port = kzalloc(sizeof (struct zfcp_port), GFP_KERNEL);
 	if (!port)
 		return NULL;
-	memset(port, 0, sizeof (struct zfcp_port));
 
 	/* initialise reference count stuff */
 	atomic_set(&port->refcount, 0);
diff --git a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_erp.c
index f57440c..ea2e7a3 100644
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -275,20 +275,17 @@ zfcp_erp_adisc(struct zfcp_port *port)
 	int retval = 0;
 	struct timer_list *timer;
 
-	send_els = kmalloc(sizeof(struct zfcp_send_els), GFP_ATOMIC);
+	send_els = kzalloc(sizeof(struct zfcp_send_els), GFP_ATOMIC);
 	if (send_els == NULL)
 		goto nomem;
-	memset(send_els, 0, sizeof(*send_els));
 
-	send_els->req = kmalloc(sizeof(struct scatterlist), GFP_ATOMIC);
+	send_els->req = kzalloc(sizeof(struct scatterlist), GFP_ATOMIC);
 	if (send_els->req == NULL)
 		goto nomem;
-	memset(send_els->req, 0, sizeof(*send_els->req));
 
-	send_els->resp = kmalloc(sizeof(struct scatterlist), GFP_ATOMIC);
+	send_els->resp = kzalloc(sizeof(struct scatterlist), GFP_ATOMIC);
 	if (send_els->resp == NULL)
 		goto nomem;
-	memset(send_els->resp, 0, sizeof(*send_els->resp));
 
 	address = (void *) get_zeroed_page(GFP_ATOMIC);
 	if (address == NULL)
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 118cf0f..3a180d8 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -761,10 +761,9 @@ zfcp_get_fc_host_stats(struct Scsi_Host 
 	if (!fc_stats)
 		return NULL;
 
-	data = kmalloc(sizeof(*data), GFP_KERNEL);
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return NULL;
-	memset(data, 0, sizeof(*data));
 
 	ret = zfcp_fsf_exchange_port_data(NULL, adapter, data);
 	if (ret) {
@@ -792,10 +791,9 @@ zfcp_reset_fc_host_stats(struct Scsi_Hos
 	int ret;
 
 	adapter = (struct zfcp_adapter *)shost->hostdata[0];
-	data = kmalloc(sizeof(*data), GFP_KERNEL);
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return;
-	memset(data, 0, sizeof(*data));
 
 	ret = zfcp_fsf_exchange_port_data(NULL, adapter, data);
 	if (ret == 0) {
-- 
1.3.3.gd5e3d

