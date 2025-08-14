Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A6028642D
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 17:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755192777; cv=none; b=klnTUhnHk3MtEHGRA8VQUcCaxv/P2CqrFlUZrXS2vnucZIquO3xw+aR9n3S/cpsm4gv0edELlam5Qj+ielJuy/zSVNcghT3U5dgftyuVu46UmD/JJWAUREzRm4dM2UotM0cvMuBXHVVihyfz0t096BOuefBf8J25KiCJnOeFQrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755192777; c=relaxed/simple;
	bh=Xvh5OwfOFxk3ctNGhprq/ggKxR8+ol9+di+i4AwRSHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LjLfaeZrV5kN3ECdgrvPBPVUfIH1EN2ug9BG4tnm+XstGnWuIB+vwm7rgOBS1BbDlm9nAGFlz7tg2/rUE96932VkrKA1PKwfVeFd4DpjwEQT7Y0YYnq+ay3AoivJIEIIWWVzmPvop+2wEjriJXjF3mR5Ddbgtn4whYGqLoCZkPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XDQIAjww; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XDQIAjww"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A27C4CEED;
	Thu, 14 Aug 2025 17:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755192776;
	bh=Xvh5OwfOFxk3ctNGhprq/ggKxR8+ol9+di+i4AwRSHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XDQIAjwwagqxEa/wm17kyl3ZxxB/rSVSIkDfGLypgcwnxUdFoUwXreK2KlmMdqHTG
	 6EE1ylo63QivBIePk1FiV0VFXU+yQH4+KELSYN9/BMNr/MzTZxEX3qY4bf2m1HXAqQ
	 yUPVvjXBdheI7JRpyEMwvUH//8ycGb8sJepjCWKqr7I4KeKspbD+J86dgKCm9XrEX0
	 TC/U//VCYmXKTHXJRPcA1Dou6MJN5bVSo/DVFX0p0j86KTOXm0K7Hjc9VdrnJQeWKp
	 QU/x/REV+0NNQ2GjyKX20Q26ppxgKJDjCTW9/4qVwczOde80quPe8w7BSGCnqv1l9F
	 yYu0z+p9eQVLQ==
From: Niklas Cassel <cassel@kernel.org>
To: Jack Wang <jinpu.wang@cloud.ionos.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Deepak Ukey <deepak.ukey@microsemi.com>,
	Viswas G <Viswas.G@microsemi.com>
Cc: Niklas Cassel <cassel@kernel.org>,
	Igor Pylypiv <ipylypiv@google.com>,
	Jack Wang <jinpu.wang@profitbricks.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH v2 09/10] scsi: pm80xx: Fix pm8001_abort_task() for chip_8006 when using an expander
Date: Thu, 14 Aug 2025 19:32:24 +0200
Message-ID: <20250814173215.1765055-21-cassel@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250814173215.1765055-12-cassel@kernel.org>
References: <20250814173215.1765055-12-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2123; i=cassel@kernel.org; h=from:subject; bh=Xvh5OwfOFxk3ctNGhprq/ggKxR8+ol9+di+i4AwRSHo=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGDLmya5IPHN45waLhDbdqdN9p20uO/Msvy/0OWvTl9vGF UFiiyXaOkpZGMS4GGTFFFl8f7jsL+52n3Jc8Y4NzBxWJpAhDFycAjCRQjaGfxZhDlWfjh3NPv1a qOaqmff7pf+4c1Zp1oQyaW6OUn29w4uRoVtrf63ge9v/7nk5Maw1xo/Xv0pp/2t7Lnfq4nqWqT/ 5eQA=
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

For a direct attached device, attached_phy contains the local phy id.
For a device behind an expander, attached_phy contains the remote phy id,
not the local phy id.

The pm8001_ha->phy array only contains the phys of the HBA.
It does not contain the phys of the expander.

Thus, you cannot use attached_phy to index the pm8001_ha->phy array,
without first verifying that the device is directly attached.

Use the pm80xx_get_local_phy_id() helper to make sure that we use the
local phy id to index the array, regardless if the device is directly
attached or not.

Fixes: 869ddbdcae3b ("scsi: pm80xx: corrected SATA abort handling sequence.")
Reviewed-by: Igor Pylypiv <ipylypiv@google.com>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
 drivers/scsi/pm8001/pm8001_sas.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 5595913eb7fc..c5354263b45e 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -1063,7 +1063,7 @@ int pm8001_abort_task(struct sas_task *task)
 	struct pm8001_hba_info *pm8001_ha;
 	struct pm8001_device *pm8001_dev;
 	int rc = TMF_RESP_FUNC_FAILED, ret;
-	u32 phy_id, port_id;
+	u32 port_id;
 	struct sas_task_slow slow_task;
 
 	if (!task->lldd_task || !task->dev)
@@ -1072,7 +1072,6 @@ int pm8001_abort_task(struct sas_task *task)
 	dev = task->dev;
 	pm8001_dev = dev->lldd_dev;
 	pm8001_ha = pm8001_find_ha_by_dev(dev);
-	phy_id = pm8001_dev->attached_phy;
 
 	if (PM8001_CHIP_DISP->fatal_errors(pm8001_ha)) {
 		// If the controller is seeing fatal errors
@@ -1104,7 +1103,8 @@ int pm8001_abort_task(struct sas_task *task)
 		if (pm8001_ha->chip_id == chip_8006) {
 			DECLARE_COMPLETION_ONSTACK(completion_reset);
 			DECLARE_COMPLETION_ONSTACK(completion);
-			struct pm8001_phy *phy = pm8001_ha->phy + phy_id;
+			u32 phy_id = pm80xx_get_local_phy_id(dev);
+			struct pm8001_phy *phy = &pm8001_ha->phy[phy_id];
 			port_id = phy->port->port_id;
 
 			/* 1. Set Device state as Recovery */
-- 
2.50.1

