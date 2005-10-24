From: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH RFC 12/n] HCIL drivers update
Date: Mon, 24 Oct 2005 04:17:36 -0400
Message-ID: <20051024081736.GC7160@havoc.gtf.org>
References: <20051023024104.GA20128@havoc.gtf.org> <20051023195128.GA12102@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:45440 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S1750730AbVJXIRh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Oct 2005 04:17:37 -0400
Received: from havoc.gtf.org (havoc.gtf.org [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by havoc.gtf.org (Postfix) with ESMTP id AA3D71C095AF
	for <linux-scsi@vger.kernel.org>; Mon, 24 Oct 2005 04:17:36 -0400 (EDT)
Received: (from garzik@localhost)
	by havoc.gtf.org (8.13.1/8.13.1/Submit) id j9O8Ha22007340
	for linux-scsi@vger.kernel.org; Mon, 24 Oct 2005 04:17:36 -0400
Content-Disposition: inline
In-Reply-To: <20051023195128.GA12102@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Missed updates to scsi_add_device() callers.

 drivers/ieee1394/sbp2.c        |    4 +++-
 drivers/message/i2o/i2o_scsi.c |    6 ++++--
 drivers/s390/scsi/zfcp_erp.c   |    8 ++++++--
 drivers/scsi/aacraid/commsup.c |    5 +++--
 4 files changed, 16 insertions(+), 7 deletions(-)

7c5c2cdf4c64c9114eff7764e1fb0a4da7ed9313
diff --git a/drivers/ieee1394/sbp2.c b/drivers/ieee1394/sbp2.c
index 87d381d..8982d36 100644
--- a/drivers/ieee1394/sbp2.c
+++ b/drivers/ieee1394/sbp2.c
@@ -813,6 +813,7 @@ static int sbp2_start_device(struct scsi
 {
 	struct sbp2scsi_host_info *hi = scsi_id->hi;
 	int error;
+	struct scsi_lun lun0;
 
 	SBP2_DEBUG("sbp2_start_device");
 
@@ -961,7 +962,8 @@ alloc_fail:
 	sbp2_max_speed_and_size(scsi_id);
 
 	/* Add this device to the scsi layer now */
-	error = scsi_add_device(scsi_id->scsi_host, 0, scsi_id->ud->id, 0);
+	int_to_scsilun(0, &lun0);
+	error = scsi_add_device(scsi_id->scsi_host, 0, scsi_id->ud->id, &lun0);
 	if (error) {
 		SBP2_ERR("scsi_add_device failed");
 		return error;
diff --git a/drivers/message/i2o/i2o_scsi.c b/drivers/message/i2o/i2o_scsi.c
index 9f1744c..87e6c6e 100644
--- a/drivers/message/i2o/i2o_scsi.c
+++ b/drivers/message/i2o/i2o_scsi.c
@@ -223,6 +223,7 @@ static int i2o_scsi_probe(struct device 
 	u64 lun = -1;
 	int channel = -1;
 	int i;
+	struct scsi_lun slun;
 
 	i2o_shost = i2o_scsi_get_host(c);
 	if (!i2o_shost)
@@ -293,8 +294,9 @@ static int i2o_scsi_probe(struct device 
 		return -EFAULT;
 	}
 
-	scsi_dev =
-	    __scsi_add_device(i2o_shost->scsi_host, channel, id, lun, i2o_dev);
+	int_to_scsilun(lun, &slun);
+	scsi_dev = __scsi_add_device(i2o_shost->scsi_host, channel, id,
+				     &slun, i2o_dev);
 
 	if (IS_ERR(scsi_dev)) {
 		osm_warn("can not add SCSI device %03x\n",
diff --git a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_erp.c
index 023f4e5..debec77 100644
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -3447,10 +3447,14 @@ zfcp_erp_action_cleanup(int action, stru
 		    && (!atomic_test_mask(ZFCP_STATUS_UNIT_TEMPORARY,
 					  &unit->status))
 		    && !unit->device
-		    && port->rport)
+		    && port->rport) {
+			/* FIXME XXX this driver can do better */
+			struct scsi_lun slun;
+			int_to_scsilun(unit->scsi_lun, &slun);
  			scsi_add_device(port->adapter->scsi_host, 0,
  					port->rport->scsi_target_id,
-					unit->scsi_lun);
+					&slun);
+		}
 		zfcp_unit_put(unit);
 		break;
 	case ZFCP_ERP_ACTION_REOPEN_PORT_FORCED:
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index e4d543a..d50a024 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -997,10 +997,11 @@ static void aac_handle_aif(struct aac_de
 		scsi_device_put(device);
 	}
 	if (device_config_needed == ADD) {
+		struct scsi_lun slun;
+		int_to_scsilun(CONTAINER_TO_LUN(container), &slun);
 		scsi_add_device(dev->scsi_host_ptr,
 		  CONTAINER_TO_CHANNEL(container),
-		  CONTAINER_TO_ID(container),
-		  CONTAINER_TO_LUN(container));
+		  CONTAINER_TO_ID(container), &slun);
 	}
 
 }
