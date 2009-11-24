From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 18/22] zfcp: Improve ELS ADISC handling
Date: Tue, 24 Nov 2009 16:54:14 +0100
Message-ID: <20091124160138.639820000@de.ibm.com>
References: <20091124155356.135092000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.17.162]:57703 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933240AbZKXQBd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2009 11:01:33 -0500
Content-Disposition: inline; filename=717-zfcp-adisc-handling.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Introduce kmem_cache for ELS ADISC data to guarantee the required
hardware alignment and free the allocated memory in case the send
failes.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_aux.c |    8 ++++++++
 drivers/s390/scsi/zfcp_def.h |    1 +
 drivers/s390/scsi/zfcp_fc.c  |   11 ++++++++---
 3 files changed, 17 insertions(+), 3 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_aux.c linux-2.6-patched/drivers/s390/scsi/zfcp_aux.c
--- linux-2.6/drivers/s390/scsi/zfcp_aux.c	2009-11-23 09:59:44.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_aux.c	2009-11-23 09:59:45.000000000 +0100
@@ -179,6 +179,11 @@ static int __init zfcp_module_init(void)
 	if (!zfcp_data.gid_pn_cache)
 		goto out_gid_cache;
 
+	zfcp_data.adisc_cache = zfcp_cache_hw_align("zfcp_adisc",
+					sizeof(struct zfcp_fc_els_adisc));
+	if (!zfcp_data.adisc_cache)
+		goto out_adisc_cache;
+
 	zfcp_data.scsi_transport_template =
 		fc_attach_transport(&zfcp_transport_functions);
 	if (!zfcp_data.scsi_transport_template)
@@ -206,6 +211,8 @@ out_ccw_register:
 out_misc:
 	fc_release_transport(zfcp_data.scsi_transport_template);
 out_transport:
+	kmem_cache_destroy(zfcp_data.adisc_cache);
+out_adisc_cache:
 	kmem_cache_destroy(zfcp_data.gid_pn_cache);
 out_gid_cache:
 	kmem_cache_destroy(zfcp_data.sr_buffer_cache);
@@ -224,6 +231,7 @@ static void __exit zfcp_module_exit(void
 	ccw_driver_unregister(&zfcp_ccw_driver);
 	misc_deregister(&zfcp_cfdc_misc);
 	fc_release_transport(zfcp_data.scsi_transport_template);
+	kmem_cache_destroy(zfcp_data.adisc_cache);
 	kmem_cache_destroy(zfcp_data.gid_pn_cache);
 	kmem_cache_destroy(zfcp_data.sr_buffer_cache);
 	kmem_cache_destroy(zfcp_data.qtcb_cache);
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_def.h linux-2.6-patched/drivers/s390/scsi/zfcp_def.h
--- linux-2.6/drivers/s390/scsi/zfcp_def.h	2009-11-23 09:59:45.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_def.h	2009-11-23 09:59:45.000000000 +0100
@@ -347,6 +347,7 @@ struct zfcp_data {
 	struct kmem_cache	*qtcb_cache;
 	struct kmem_cache	*sr_buffer_cache;
 	struct kmem_cache	*gid_pn_cache;
+	struct kmem_cache	*adisc_cache;
 };
 
 /********************** ZFCP SPECIFIC DEFINES ********************************/
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fc.c linux-2.6-patched/drivers/s390/scsi/zfcp_fc.c
--- linux-2.6/drivers/s390/scsi/zfcp_fc.c	2009-11-23 09:59:45.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fc.c	2009-11-23 09:59:45.000000000 +0100
@@ -389,15 +389,16 @@ static void zfcp_fc_adisc_handler(void *
  out:
 	atomic_clear_mask(ZFCP_STATUS_PORT_LINK_TEST, &port->status);
 	put_device(&port->sysfs_device);
-	kfree(adisc);
+	kmem_cache_free(zfcp_data.adisc_cache, adisc);
 }
 
 static int zfcp_fc_adisc(struct zfcp_port *port)
 {
 	struct zfcp_fc_els_adisc *adisc;
 	struct zfcp_adapter *adapter = port->adapter;
+	int ret;
 
-	adisc = kzalloc(sizeof(struct zfcp_fc_els_adisc), GFP_ATOMIC);
+	adisc = kmem_cache_alloc(zfcp_data.adisc_cache, GFP_ATOMIC);
 	if (!adisc)
 		return -ENOMEM;
 
@@ -420,7 +421,11 @@ static int zfcp_fc_adisc(struct zfcp_por
 	hton24(adisc->adisc_req.adisc_port_id,
 	       fc_host_port_id(adapter->scsi_host));
 
-	return zfcp_fsf_send_els(adapter, port->d_id, &adisc->els);
+	ret = zfcp_fsf_send_els(adapter, port->d_id, &adisc->els);
+	if (ret)
+		kmem_cache_free(zfcp_data.adisc_cache, adisc);
+
+	return ret;
 }
 
 void zfcp_fc_link_test_work(struct work_struct *work)

