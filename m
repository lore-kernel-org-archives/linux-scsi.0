Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2680FC433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 23:03:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFC2122D01
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 23:03:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbgLDXDu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Dec 2020 18:03:50 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:1374 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727348AbgLDXDu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2020 18:03:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607123030; x=1638659030;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pjfu8r41g7xridLJ0i98fuv1C0sQXap513gkj+n0C0U=;
  b=rs2u2irvubLQ+tj4MNLTTB29c1LX6ND4DtHquUXA3OyXTc08Ze8H/ClQ
   IETGUtBYJlicMUJpLSCAgkJfU07akrCG2MhEsZ53fpjx8yedzoctlkWxC
   62BIivno6Jkh+06tT9UgPH/JiKg4SP13CtJUP+WZ8ZJxC2EpgrmHOXww3
   z9zVjsIKsv1dQbkkE6n1ZBJx2AbNcO5baOGqUtTHivnq344O+tKjzwofY
   NTh2dOEAzpH8P6b8521QoGYlHx/Cvu2AI6thUEC24MfLcpBO8I9l1iys8
   7LXoshgouD1zLDNptbYl1xF3qe1pM3wdjjxoiuxUDTR9lLXxdIV63lmXe
   w==;
IronPort-SDR: VlnmJrKOkz0xcXXor1YBRJp0bDt+WSY/eKU4GKIIqPMo3XFVo1lHHULUrxg4GJ+5RgISNMCMIo
 dbdoI5Nkh6IG5Qi2Wbl6vXuuuz3uLx82dW73Fx3DKqOHaSzyhIWXcgGP4kMavOpbl9MdyhtFWx
 gRFb4/Gd2MvUeEXr8bQOihm+ysEIp1rY2HGGKZnFL1mMC+L1W2FVo+zT42LcZT7FRSDV0shHkK
 yWA9eNlxTvMPpUoEXHgE7HBb1t+9vFMugYbe2rhaGWn7ntZAY/a3sOyB1iODcQEarmozl0jPU7
 IG0=
X-IronPort-AV: E=Sophos;i="5.78,393,1599548400"; 
   d="scan'208";a="101548802"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Dec 2020 16:02:20 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 4 Dec 2020 16:02:18 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 4 Dec 2020 16:02:17 -0700
Subject: [PATCH 15/25] smartpqi: fix host qdepth limit
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Fri, 4 Dec 2020 17:02:17 -0600
Message-ID: <160712293782.21372.12605446472261001024.stgit@brunhilda>
In-Reply-To: <160712276179.21372.51526310810782843.stgit@brunhilda>
References: <160712276179.21372.51526310810782843.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>

* Correct scsi-mid-layer sending more requests than
  exposed host Q depth causing firmware ASSERT issue.
  * Add host Qdepth counter.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |    2 ++
 drivers/scsi/smartpqi/smartpqi_init.c |   19 ++++++++++++++++---
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index 0b94c755a74c..c3b103b15924 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -1345,6 +1345,8 @@ struct pqi_ctrl_info {
 	struct work_struct ofa_quiesce_work;
 	u32		ofa_bytes_requested;
 	u16		ofa_cancel_reason;
+
+	atomic_t	total_scmds_outstanding;
 };
 
 enum pqi_ctrl_mode {
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 0472ba6de43b..a9856cc9a951 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -5509,6 +5509,8 @@ static inline bool pqi_is_bypass_eligible_request(struct scsi_cmnd *scmd)
 void pqi_prep_for_scsi_done(struct scsi_cmnd *scmd)
 {
 	struct pqi_scsi_dev *device;
+	struct pqi_ctrl_info *ctrl_info;
+	struct Scsi_Host *shost;
 
 	if (!scmd->device) {
 		set_host_byte(scmd, DID_NO_CONNECT);
@@ -5521,7 +5523,11 @@ void pqi_prep_for_scsi_done(struct scsi_cmnd *scmd)
 		return;
 	}
 
+	shost = scmd->device->host;
+	ctrl_info = shost_to_hba(shost);
+
 	atomic_dec(&device->scsi_cmds_outstanding);
+	atomic_dec(&ctrl_info->total_scmds_outstanding);
 }
 
 static bool pqi_is_parity_write_stream(struct pqi_ctrl_info *ctrl_info,
@@ -5609,6 +5615,7 @@ static int pqi_scsi_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scm
 	bool raid_bypassed;
 
 	device = scmd->device->hostdata;
+	ctrl_info = shost_to_hba(shost);
 
 	if (!device) {
 		set_host_byte(scmd, DID_NO_CONNECT);
@@ -5617,8 +5624,11 @@ static int pqi_scsi_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scm
 	}
 
 	atomic_inc(&device->scsi_cmds_outstanding);
-
-	ctrl_info = shost_to_hba(shost);
+	if (atomic_inc_return(&ctrl_info->total_scmds_outstanding) >
+		ctrl_info->scsi_ml_can_queue) {
+		rc = SCSI_MLQUEUE_HOST_BUSY;
+		goto out;
+	}
 
 	if (pqi_ctrl_offline(ctrl_info) || pqi_device_in_remove(device)) {
 		set_host_byte(scmd, DID_NO_CONNECT);
@@ -5661,8 +5671,10 @@ static int pqi_scsi_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scm
 	}
 
 out:
-	if (rc)
+	if (rc) {
 		atomic_dec(&device->scsi_cmds_outstanding);
+		atomic_dec(&ctrl_info->total_scmds_outstanding);
+	}
 
 	return rc;
 }
@@ -7985,6 +7997,7 @@ static struct pqi_ctrl_info *pqi_alloc_ctrl_info(int numa_node)
 
 	INIT_WORK(&ctrl_info->event_work, pqi_event_worker);
 	atomic_set(&ctrl_info->num_interrupts, 0);
+	atomic_set(&ctrl_info->total_scmds_outstanding, 0);
 
 	INIT_DELAYED_WORK(&ctrl_info->rescan_work, pqi_rescan_worker);
 	INIT_DELAYED_WORK(&ctrl_info->update_time_work, pqi_update_time_worker);

