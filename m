From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH] Protect against overflow in dev_loss_tmo
Date: Tue, 09 Mar 2010 10:18:48 +0100
Message-ID: <20100309091848.4C7412BD8B@ochil.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:60064 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537Ab0CIJSt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Mar 2010 04:18:49 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.221.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id 7634A93A00
	for <linux-scsi@vger.kernel.org>; Tue,  9 Mar 2010 10:18:48 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org


The rport structure defines dev_loss_tmo as u32, which is
later multiplied with HZ to get the actual timeout value.
This might overflow for large dev_loss_tmo values. So we
should be better using u64 as intermediate variables here
to protect against overflow.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 79660ee..9860322 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -833,7 +833,7 @@ static ssize_t
 store_fc_rport_dev_loss_tmo(struct device *dev, struct device_attribute *attr,
 			    const char *buf, size_t count)
 {
-	int val;
+	unsigned long val;
 	struct fc_rport *rport = transport_class_to_rport(dev);
 	struct Scsi_Host *shost = rport_to_shost(rport);
 	struct fc_internal *i = to_fc_internal(shost->transportt);
@@ -847,6 +847,12 @@ store_fc_rport_dev_loss_tmo(struct device *dev, struct device_attribute *attr,
 		return -EINVAL;
 
 	/*
+	 * Check for overflow; dev_loss_tmo is u32
+	 */
+	if (val > UINT_MAX)
+		return -EINVAL;
+
+	/*
 	 * If fast_io_fail is off we have to cap
 	 * dev_loss_tmo at SCSI_DEVICE_BLOCK_MAX_TIMEOUT
 	 */
@@ -2852,7 +2858,7 @@ void
 fc_remote_port_delete(struct fc_rport  *rport)
 {
 	struct Scsi_Host *shost = rport_to_shost(rport);
-	int timeout = rport->dev_loss_tmo;
+	unsigned long timeout = rport->dev_loss_tmo;
 	unsigned long flags;
 
 	/*
