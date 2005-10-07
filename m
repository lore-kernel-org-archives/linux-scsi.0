From: "Chen, Kenneth W" <kenneth.w.chen@intel.com>
Subject: [patch] fix unnecessary activation of blk tag queue for qla2x00
Date: Fri, 7 Oct 2005 01:18:32 -0700
Message-ID: <B05667366EE6204181EABE9C1B1C0EB5086AEC35@scsmsx401.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmr16.intel.com ([192.55.52.70]:29380 "EHLO
	fmsfmr006.fm.intel.com") by vger.kernel.org with ESMTP
	id S932104AbVJGISe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Oct 2005 04:18:34 -0400
Received: from fmsfmr101.fm.intel.com (fmsfmr101.fm.intel.com [10.253.24.21])
	by fmsfmr006.fm.intel.com (8.12.10/8.12.10/d: major-outer.mc,v 1.1 2004/09/17 17:50:56 root Exp $) with ESMTP id j978IYNC011578
	for <linux-scsi@vger.kernel.org>; Fri, 7 Oct 2005 08:18:34 GMT
Received: from fmsmsxvs043.fm.intel.com (fmsmsxvs043.fm.intel.com [132.233.42.129])
	by fmsfmr101.fm.intel.com (8.12.10/8.12.10/d: major-inner.mc,v 1.2 2004/09/17 18:05:01 root Exp $) with SMTP id j978IK2t031747
	for <linux-scsi@vger.kernel.org>; Fri, 7 Oct 2005 08:18:34 GMT
Received: from fmsmsx332.amr.corp.intel.com ([132.233.42.148])
 by fmsmsxvs043.fm.intel.com (SAVSMTP 3.1.7.47) with SMTP id M2005100701183303993
 for <linux-scsi@vger.kernel.org>; Fri, 07 Oct 2005 01:18:33 -0700
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Regarding to discussion on LKML:
http://marc.theaimsgroup.com/?t=112865351000001&r=1&w=2

It turns out that qla2x00 driver unnecessarily activated generic
blk tag queue without actually use any of the tag maintained by
the block layer.  I suggest we turn that off until there is a
real consumer of the tag queuing in the qla driver. Please apply.

Signed-off-by: Ken Chen <kenneth.w.chen@intel.com>

--- ./drivers/scsi/qla2xxx/qla_os.c.orig	2005-10-06
23:24:32.547238409 -0700
+++ ./drivers/scsi/qla2xxx/qla_os.c	2005-10-06 23:30:44.004265109
-0700
@@ -1101,11 +1101,7 @@ qla2xxx_slave_configure(struct scsi_devi
 	scsi_qla_host_t *ha = to_qla_host(sdev->host);
 	struct fc_rport *rport = starget_to_rport(sdev->sdev_target);
 
-	if (sdev->tagged_supported)
-		scsi_activate_tcq(sdev, 32);
-	else
-		scsi_deactivate_tcq(sdev, 32);
-
+	scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), 32);
 	rport->dev_loss_tmo = ha->port_down_retry_count + 5;
 
 	return 0;
@@ -1127,13 +1123,9 @@ qla2x00_change_queue_depth(struct scsi_d
 static int
 qla2x00_change_queue_type(struct scsi_device *sdev, int tag_type)
 {
-	if (sdev->tagged_supported) {
+	if (sdev->tagged_supported)
 		scsi_set_tag_type(sdev, tag_type);
-		if (tag_type)
-			scsi_activate_tcq(sdev, sdev->queue_depth);
-		else
-			scsi_deactivate_tcq(sdev, sdev->queue_depth);
-	} else
+	else
 		tag_type = 0;
 
 	return tag_type;
