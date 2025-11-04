Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CCCB2D5944
	for <linux-scsi@vger.kernel.org>; Tue,  4 Nov 2025 10:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762250680; cv=none; b=ZjjLpvjT8Un93hY+z8FeltnJ6HxM709BIUbNYT4AK4Njmqf2yZWMDh1d+PpwAQpW317aM+oHy6lcSeoFoh6fOQ2vnnzl6GCo9sncKbj9DRKzhhR+7K0zeteiLJu3uGyUDRt560vL4JiEe8vMXPORZH83ZiODxkVLjXlwV/4T9Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762250680; c=relaxed/simple;
	bh=aOKTAHCkaS8G9/uR/r6feetx7s4o4o6R9pjGNqauhRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LWn1xc4kPHK0ASG+iNCg4apmTa4SZ6KimVb+h3JxbpzG4njL27bErxlrk2ddeBlBLklq02iFkC9NcMT8PCUS3RNo5PaB/shc+E31dGIoTCUXqX+pRI8XVzKYntEanSCnuyICBvOyK2tF507/aLru3lEjAgWTYVsUE9H86xGVGh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MFlCFmLK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MFlCFmLK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA9A1C4CEF7;
	Tue,  4 Nov 2025 10:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762250679;
	bh=aOKTAHCkaS8G9/uR/r6feetx7s4o4o6R9pjGNqauhRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MFlCFmLKzMUHv0U1DBpAySJvYJwrttdAXlYnpFcCBmk2G3fKrG4aDZ5cPvR22AIbn
	 4mGNmERA9zbs5dV0EEVm5uqMPfrNOXgaoNGU4eoP2cq4u8qA7TNUzvgp8+gX3GRYQW
	 +GqBxslHu+TTazk4GLJbtbPW6tDQYE70gtk59/GSFheWJ6b7WyhE4uDPbDCeXBlr4q
	 13wrzUYftF9rDMDg6FtdJ+bA5oItfnHUzC1xnI/AgyYmq4owa8PbFUdaKGtJGa94uO
	 aWzzOsh2/JQyyLjL0TpKNR19jjhD0YOpS3IzguViCOkxOx39UXEjsEGsbeq9zKCTCZ
	 aVDkRyDostCug==
From: Hannes Reinecke <hare@kernel.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>,
	linux-scsi@vger.kernel.org,
	Karan Tilak Kumar <kartilak@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	Satish Kharat <satishkh@cisco.com>,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH 4/4] fnic: make interrupt mode configurable
Date: Tue,  4 Nov 2025 11:04:24 +0100
Message-ID: <20251104100424.8215-5-hare@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251104100424.8215-1-hare@kernel.org>
References: <20251104100424.8215-1-hare@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In some environments (eg kdump) not all CPUs are online, so the MQ
mapping might be resulting in an invalid layout. So make the interrupt
mode settable via an 'fnic_intr_mode' module parameter and switch
to INTx if the 'reset_devices' kernel parameter is specified.

Signed-off-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/fnic/fnic.h      |  2 +-
 drivers/scsi/fnic/fnic_isr.c  | 13 +++++++++----
 drivers/scsi/fnic/fnic_main.c | 10 +++++++++-
 3 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 1199d701c3f5..c679283955e9 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -484,7 +484,7 @@ extern struct workqueue_struct *fnic_fip_queue;
 extern const struct attribute_group *fnic_host_groups[];
 
 void fnic_clear_intr_mode(struct fnic *fnic);
-int fnic_set_intr_mode(struct fnic *fnic);
+int fnic_set_intr_mode(struct fnic *fnic, unsigned int mode);
 int fnic_set_intr_mode_msix(struct fnic *fnic);
 void fnic_free_intr(struct fnic *fnic);
 int fnic_request_intr(struct fnic *fnic);
diff --git a/drivers/scsi/fnic/fnic_isr.c b/drivers/scsi/fnic/fnic_isr.c
index e16b76d537e8..b6594ad064ca 100644
--- a/drivers/scsi/fnic/fnic_isr.c
+++ b/drivers/scsi/fnic/fnic_isr.c
@@ -319,20 +319,25 @@ int fnic_set_intr_mode_msix(struct fnic *fnic)
 	return 1;
 }
 
-int fnic_set_intr_mode(struct fnic *fnic)
+int fnic_set_intr_mode(struct fnic *fnic, unsigned int intr_mode)
 {
 	int ret_status = 0;
 
 	/*
 	 * Set interrupt mode (INTx, MSI, MSI-X) depending
 	 * system capabilities.
-	 *
+	 */
+	if (intr_mode != VNIC_DEV_INTR_MODE_MSIX)
+		goto try_msi;
+	/*
 	 * Try MSI-X first
 	 */
 	ret_status = fnic_set_intr_mode_msix(fnic);
 	if (ret_status == 0)
 		return ret_status;
-
+try_msi:
+	if (intr_mode != VNIC_DEV_INTR_MODE_MSI)
+		goto try_intx;
 	/*
 	 * Next try MSI
 	 * We need 1 RQ, 1 WQ, 1 WQ_COPY, 3 CQs, and 1 INTR
@@ -358,7 +363,7 @@ int fnic_set_intr_mode(struct fnic *fnic)
 
 		return 0;
 	}
-
+try_intx:
 	/*
 	 * Next try INTx
 	 * We need 1 RQ, 1 WQ, 1 WQ_COPY, 3 CQs, and 3 INTRs
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 870b265be41a..4bdd55958f59 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -97,6 +97,10 @@ module_param(pc_rscn_handling_feature_flag, uint, 0644);
 MODULE_PARM_DESC(pc_rscn_handling_feature_flag,
 		 "PCRSCN handling (0 for none. 1 to handle PCRSCN (default))");
 
+static unsigned int fnic_intr_mode = VNIC_DEV_INTR_MODE_MSIX;
+module_param(fnic_intr_mode, uint, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(fnic_intr_mode, "Interrupt mode, 1 = INTx, 2 = MSI, 3 = MSIx (default: 3)");
+
 struct workqueue_struct *reset_fnic_work_queue;
 struct workqueue_struct *fnic_fip_queue;
 
@@ -869,7 +873,11 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	fnic_get_res_counts(fnic);
 
-	err = fnic_set_intr_mode(fnic);
+	/* Override interrupt selection during kdump */
+	if (reset_devices)
+		fnic_intr_mode = VNIC_DEV_INTR_MODE_INTX;
+
+	err = fnic_set_intr_mode(fnic, fnic_intr_mode);
 	if (err) {
 		dev_err(&fnic->pdev->dev, "Failed to set intr mode, "
 			     "aborting.\n");
-- 
2.43.0

