Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34954C2BB40
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 20:28:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 002A623AA8
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 20:28:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729441AbgLHU2C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 15:28:02 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:25999 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727554AbgLHU2C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 15:28:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607459281; x=1638995281;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UZbBIqWW3Pc7AUD4R+mdvpPPoiUdaisJsNUOLylhxiw=;
  b=N7o6w7EaWouPrjyCq5tGABFBoJSRFlZEYuAlt7t1DKwlEAb9k6jN1pjF
   tMZ0g+unUhOLbvC2RhhpjMoo+u05MNy/1oXt45BQPsTjiN3GR+rCIytY4
   gRdokzJTx61SmmlCdDZg6Y8M1VAxI4uI9nvCUKL18ib+IdK/DzvAAUAV5
   WaoS6MneX++953jbKQD/Fnh0FWQUP1Xl16w2RGHzMEZskBPRBozJ/a0Yt
   NMTUIIzvo469PVaL4k3KAKtrDQb0GrL5LfysVguuLErP8RStQ9In98Ydo
   i6iwQ/SHLCdjtNp5I6qkGC2n6mqTDRBazbArJC45mCfJoHyWSCt2H6QCl
   g==;
IronPort-SDR: jqyx5U3IVYYakxEk+679tqgaImIFmgwQQm0ppJAJnchOnUmUYAeW5vCRpNLNYm8rKCmGVFQMdJ
 HqmxoQur9p7rv+4+C7dGhz3QbopTsYpIfu4xfA6/MP7G7fRzwRuELMqKAuSKlKO+5rEd0P6qfX
 PFQkEJf/5y72jpa93J8vGRRDzW+6YtVs7M7ZBM/OQ33/loKuoA7LTjIdFyVk/17uug9WjBf111
 R9vcguy1XbsAQMkg+bnm1ljlDBErMG8qnEl7xiXCcCqgLlmq4kqbTsts6wTH3HCaWJU5nsl6lx
 TnA=
X-IronPort-AV: E=Sophos;i="5.78,403,1599548400"; 
   d="scan'208";a="102012198"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Dec 2020 12:38:03 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 8 Dec 2020 12:38:03 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 8 Dec 2020 12:38:02 -0700
Subject: [PATCH V2 15/25] smartpqi: fix host qdepth limit
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 8 Dec 2020 13:38:02 -0600
Message-ID: <160745628247.13450.11175417497723758181.stgit@brunhilda>
In-Reply-To: <160745609917.13450.11882890596851148601.stgit@brunhilda>
References: <160745609917.13450.11882890596851148601.stgit@brunhilda>
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
index af2ef5b5d019..b9c50411a4e2 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -5572,6 +5572,8 @@ static inline bool pqi_is_bypass_eligible_request(struct scsi_cmnd *scmd)
 void pqi_prep_for_scsi_done(struct scsi_cmnd *scmd)
 {
 	struct pqi_scsi_dev *device;
+	struct pqi_ctrl_info *ctrl_info;
+	struct Scsi_Host *shost;
 
 	if (!scmd->device) {
 		set_host_byte(scmd, DID_NO_CONNECT);
@@ -5584,7 +5586,11 @@ void pqi_prep_for_scsi_done(struct scsi_cmnd *scmd)
 		return;
 	}
 
+	shost = scmd->device->host;
+	ctrl_info = shost_to_hba(shost);
+
 	atomic_dec(&device->scsi_cmds_outstanding);
+	atomic_dec(&ctrl_info->total_scmds_outstanding);
 }
 
 static bool pqi_is_parity_write_stream(struct pqi_ctrl_info *ctrl_info,
@@ -5672,6 +5678,7 @@ static int pqi_scsi_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scm
 	bool raid_bypassed;
 
 	device = scmd->device->hostdata;
+	ctrl_info = shost_to_hba(shost);
 
 	if (!device) {
 		set_host_byte(scmd, DID_NO_CONNECT);
@@ -5680,8 +5687,11 @@ static int pqi_scsi_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scm
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
@@ -5724,8 +5734,10 @@ static int pqi_scsi_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scm
 	}
 
 out:
-	if (rc)
+	if (rc) {
 		atomic_dec(&device->scsi_cmds_outstanding);
+		atomic_dec(&ctrl_info->total_scmds_outstanding);
+	}
 
 	return rc;
 }
@@ -8048,6 +8060,7 @@ static struct pqi_ctrl_info *pqi_alloc_ctrl_info(int numa_node)
 
 	INIT_WORK(&ctrl_info->event_work, pqi_event_worker);
 	atomic_set(&ctrl_info->num_interrupts, 0);
+	atomic_set(&ctrl_info->total_scmds_outstanding, 0);
 
 	INIT_DELAYED_WORK(&ctrl_info->rescan_work, pqi_rescan_worker);
 	INIT_DELAYED_WORK(&ctrl_info->update_time_work, pqi_update_time_worker);

