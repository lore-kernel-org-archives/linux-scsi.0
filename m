Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1EC6C4167B
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Dec 2020 20:37:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 973EF23E25
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Dec 2020 20:37:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404656AbgLJUh2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Dec 2020 15:37:28 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:13285 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404013AbgLJUhU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Dec 2020 15:37:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607632638; x=1639168638;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wx/rFxEsFYmKJp+x3YgucDeY54zopuzvSkA2vcvzSXs=;
  b=n/2D7pbHCZtpHqwT6VhW7EfnSboWoY+obIPbCRejEssCNJl5XhPn8COz
   XsqDAmKlpISV4jlGmVU96LtHssmagbpAsk17TuwtEcnI0pAga25EOBVxa
   RUsTasx820NTUkwcS9niZLn3nMRVmGjQmsOWdi6POTbStxeUsqrjWxjIc
   80LqgPtdNUBqlLVYMs9kw7O6xplQQuIWawjMFHklmJ905UuqF0QMxqlq6
   bCJFcTdMUtjMxewKqOiIAZrCT9xAowF1NwS371Wkw7gefxDJPTQ4+ww2c
   reX9ltvkUdWJewSMTs4n2NcoWikVCSktJIv54LtblzKQc0t2OKZV9823K
   w==;
IronPort-SDR: YYrtuJs6Dx2WrxHWpp/EfujubEo6sCs9dR334k8Rti2p65zyMS6Muc1UACZ4C7Vj4o1qfCMyIP
 YS8g6dEY4wPrafkgfO/m5rMEaS6OEjMZ0umqDkEyONGDiNSgCulvEqUMYTQpO1ptRaWv9p0xjE
 a+5QmEAFvHe3oMsWVXrgWyAjSteUOzWOZGv0iGCoZ/es7Vm4EbdY9IIQ+ofIupxRfMKmP+y4ew
 uWgWnPgS6Pu4Mi4mgiUtiAaA6kRUROGoAdEJNKqnhbqCs2ORAY3MyvEO8TWzi8hrGcmiC+2uqK
 b/s=
X-IronPort-AV: E=Sophos;i="5.78,409,1599548400"; 
   d="scan'208";a="102325159"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Dec 2020 13:35:58 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 10 Dec 2020 13:35:48 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Thu, 10 Dec 2020 13:35:47 -0700
Subject: [PATCH V3 15/25] smartpqi: fix host qdepth limit
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Thu, 10 Dec 2020 14:35:47 -0600
Message-ID: <160763254769.26927.9249430312259308888.stgit@brunhilda>
In-Reply-To: <160763241302.26927.17487238067261230799.stgit@brunhilda>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
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
index 082b17e9bd80..4e088f47d95f 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -5578,6 +5578,8 @@ static inline bool pqi_is_bypass_eligible_request(struct scsi_cmnd *scmd)
 void pqi_prep_for_scsi_done(struct scsi_cmnd *scmd)
 {
 	struct pqi_scsi_dev *device;
+	struct pqi_ctrl_info *ctrl_info;
+	struct Scsi_Host *shost;
 
 	if (!scmd->device) {
 		set_host_byte(scmd, DID_NO_CONNECT);
@@ -5590,7 +5592,11 @@ void pqi_prep_for_scsi_done(struct scsi_cmnd *scmd)
 		return;
 	}
 
+	shost = scmd->device->host;
+	ctrl_info = shost_to_hba(shost);
+
 	atomic_dec(&device->scsi_cmds_outstanding);
+	atomic_dec(&ctrl_info->total_scmds_outstanding);
 }
 
 static bool pqi_is_parity_write_stream(struct pqi_ctrl_info *ctrl_info,
@@ -5678,6 +5684,7 @@ static int pqi_scsi_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scm
 	bool raid_bypassed;
 
 	device = scmd->device->hostdata;
+	ctrl_info = shost_to_hba(shost);
 
 	if (!device) {
 		set_host_byte(scmd, DID_NO_CONNECT);
@@ -5686,8 +5693,11 @@ static int pqi_scsi_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scm
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
@@ -5730,8 +5740,10 @@ static int pqi_scsi_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scm
 	}
 
 out:
-	if (rc)
+	if (rc) {
 		atomic_dec(&device->scsi_cmds_outstanding);
+		atomic_dec(&ctrl_info->total_scmds_outstanding);
+	}
 
 	return rc;
 }
@@ -8054,6 +8066,7 @@ static struct pqi_ctrl_info *pqi_alloc_ctrl_info(int numa_node)
 
 	INIT_WORK(&ctrl_info->event_work, pqi_event_worker);
 	atomic_set(&ctrl_info->num_interrupts, 0);
+	atomic_set(&ctrl_info->total_scmds_outstanding, 0);
 
 	INIT_DELAYED_WORK(&ctrl_info->rescan_work, pqi_rescan_worker);
 	INIT_DELAYED_WORK(&ctrl_info->update_time_work, pqi_update_time_worker);

