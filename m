Return-Path: <SRS0=ZMHN=ZI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A522C43141
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Nov 2019 16:01:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6450420815
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Nov 2019 16:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573920087;
	bh=ZUU5H9HjWn3RXfrImjsnjhkhrT3YNJwLQmoT5CgPNO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=fsweOtwnAhC41LVPnI9ubrmf0L9JBV0p2kKt1xFWGFAmowFUpqU2muoo9mp+AJ6p5
	 x7TkrkaoD85AB8nu6bweWL+lUpkE3cN90L5mV53BWQ9KZRxTf4NDuWvLlcoDzoS8cr
	 BPAdzyCCCHVr5S4iI5yGLXUJjoBlmjmSqTI6Rxnc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730914AbfKPQBS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 16 Nov 2019 11:01:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:34290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731183AbfKPPxR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 16 Nov 2019 10:53:17 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 428DC2186D;
        Sat, 16 Nov 2019 15:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919596;
        bh=ZUU5H9HjWn3RXfrImjsnjhkhrT3YNJwLQmoT5CgPNO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VfDov+inAarS8gq4WStmTfTcIGkOqp/8rqMqAPEVPNOR7O5vzRbIZsml5MYX6Z01j
         SQ+cxvMRhegLPx/2TXRzOlik9GUNcI176eHeDsayqmYICwVTMkK6m/ry0pv427XBEn
         6PDAXXAQ36caNXTya8MhMN8T9XtbpnTsH6Anf2so=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Suganath Prabu <suganath-prabu.subramani@broadcom.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 83/99] scsi: mpt3sas: Fix Sync cache command failure during driver unload
Date:   Sat, 16 Nov 2019 10:50:46 -0500
Message-Id: <20191116155103.10971-83-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116155103.10971-1-sashal@kernel.org>
References: <20191116155103.10971-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Suganath Prabu <suganath-prabu.subramani@broadcom.com>

[ Upstream commit 9029a72500b95578a35877a43473b82cb0386c53 ]

This is to fix SYNC CACHE and START STOP command failures with
DID_NO_CONNECT during driver unload.

In driver's IO submission patch (i.e. in driver's .queuecommand()) driver
won't allow any SCSI commands to the IOC when ioc->remove_host flag is set
and hence SYNC CACHE commands which are issued to the target drives (where
write cache is enabled) during driver unload time is failed with
DID_NO_CONNECT status.

Now modified the driver to allow SYNC CACHE and START STOP commands to IOC,
even when remove_host flag is set.

Signed-off-by: Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 36 +++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index ec48c010a3bab..aa2078d7e23e2 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3297,6 +3297,40 @@ _scsih_tm_tr_complete(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
 	return _scsih_check_for_pending_tm(ioc, smid);
 }
 
+/** _scsih_allow_scmd_to_device - check whether scmd needs to
+ *				 issue to IOC or not.
+ * @ioc: per adapter object
+ * @scmd: pointer to scsi command object
+ *
+ * Returns true if scmd can be issued to IOC otherwise returns false.
+ */
+inline bool _scsih_allow_scmd_to_device(struct MPT3SAS_ADAPTER *ioc,
+	struct scsi_cmnd *scmd)
+{
+
+	if (ioc->pci_error_recovery)
+		return false;
+
+	if (ioc->hba_mpi_version_belonged == MPI2_VERSION) {
+		if (ioc->remove_host)
+			return false;
+
+		return true;
+	}
+
+	if (ioc->remove_host) {
+
+		switch (scmd->cmnd[0]) {
+		case SYNCHRONIZE_CACHE:
+		case START_STOP:
+			return true;
+		default:
+			return false;
+		}
+	}
+
+	return true;
+}
 
 /**
  * _scsih_sas_control_complete - completion routine
@@ -4059,7 +4093,7 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 		return 0;
 	}
 
-	if (ioc->pci_error_recovery || ioc->remove_host) {
+	if (!(_scsih_allow_scmd_to_device(ioc, scmd))) {
 		scmd->result = DID_NO_CONNECT << 16;
 		scmd->scsi_done(scmd);
 		return 0;
-- 
2.20.1

