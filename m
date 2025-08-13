Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2A023A9AD
	for <linux-scsi@vger.kernel.org>; Wed, 13 Aug 2025 11:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755085298; cv=none; b=juC2BkLAYsmZqgN+BLGAT8nMUm3uEqeQfni3mXj8zL6JUebo7xTnpzZBmiX1TPL7HF45LSHiDkOR0WRUH5zlJAdNaP0sssA1K/wlTWMfkB1msciYV4WYFtl/0+3mHpIpQmmOLeGuAnhxhPZtl3I0UtEe2cvbw7QsZJymJUL1LNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755085298; c=relaxed/simple;
	bh=1bpFRghpNRjz8REX5edj/z94tELkKsv0F2P+td0AdcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OTq/DbRZmvGn/rBS7VJEPe+5tjpLZZ5FEOL6T9i2j6yBJfrtyKsZvQJJogNC+S/pZn8MRaEXsvha3Cxw2t28T86vB96zBmaLAaeZiSEPPC9ZAFdJVjnANpewbaoh4Poxg/TBkoFjyiSmsdQp3zxII0MU+ybVrl9KXlaKcMSp+fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CRS4Tu2w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CRS4Tu2w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E397C4CEEB;
	Wed, 13 Aug 2025 11:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755085297;
	bh=1bpFRghpNRjz8REX5edj/z94tELkKsv0F2P+td0AdcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CRS4Tu2wmqFeT6jE0tn6Sb1es3mvJc0Avnb+qJwAJVdcQ5+8imFacZnkdh5/HZuvh
	 kkEOloRcVX1on6h/175Az9YG/9bC9QTSJJPsnU1LSmspkCTJJSFxgVinJER6H8oUsu
	 4zudatAG+nZrBxFabV4u+vMvxtqI0QKzxv+zEesio10V0hzuHXo5bC6mn0JUf77Ozh
	 gGp+a1XxuC6ymR6yqxilSl7t2CAuwc4Txn/2dRL+uuTFwjf6kEp3TrfcTiE9nzz3Pq
	 3U7WkZIf+wAsd9ceAGJdocTlxL6BXP8auz6ujnMvNc23HM0OWz6elZhZtRol5vW3Sj
	 pi9gNOzqyRrqA==
From: Niklas Cassel <cassel@kernel.org>
To: Jack Wang <jinpu.wang@cloud.ionos.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Viswas G <Viswas.G@microsemi.com>,
	Deepak Ukey <deepak.ukey@microsemi.com>
Cc: Igor Pylypiv <ipylypiv@google.com>,
	Terrence Adams <tadamsjr@google.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Jack Wang <jinpu.wang@profitbricks.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH 4/5] scsi: pm80xx: Fix pm8001_abort_task() for chip_8006 when using an expander
Date: Wed, 13 Aug 2025 13:41:11 +0200
Message-ID: <20250813114107.916919-11-cassel@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250813114107.916919-7-cassel@kernel.org>
References: <20250813114107.916919-7-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2074; i=cassel@kernel.org; h=from:subject; bh=1bpFRghpNRjz8REX5edj/z94tELkKsv0F2P+td0AdcM=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGDLmVN647DaHJ2vJVpv7N2OZ5/89/eno3j/7V0zVln7Ps e3Rg+mX1TpKWRjEuBhkxRRZfH+47C/udp9yXPGODcwcViaQIQxcnAIwEUMbRobPt+eY/Hnxk9tz 10XHLTNm7WxpDO6zDjxxQX/7fa6b6/n6GBk+ygoHrl188Gdr94w0Vat3n09YHb3aIZolrvqudS3 T+/9sAA==
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
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
 drivers/scsi/pm8001/pm8001_sas.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 56d0309d5984..b3bd61827ad6 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -1065,7 +1065,7 @@ int pm8001_abort_task(struct sas_task *task)
 	struct pm8001_hba_info *pm8001_ha;
 	struct pm8001_device *pm8001_dev;
 	int rc = TMF_RESP_FUNC_FAILED, ret;
-	u32 phy_id, port_id;
+	u32 port_id;
 	struct sas_task_slow slow_task;
 
 	if (!task->lldd_task || !task->dev)
@@ -1074,7 +1074,6 @@ int pm8001_abort_task(struct sas_task *task)
 	dev = task->dev;
 	pm8001_dev = dev->lldd_dev;
 	pm8001_ha = pm8001_find_ha_by_dev(dev);
-	phy_id = pm8001_dev->attached_phy;
 
 	if (PM8001_CHIP_DISP->fatal_errors(pm8001_ha)) {
 		// If the controller is seeing fatal errors
@@ -1106,7 +1105,8 @@ int pm8001_abort_task(struct sas_task *task)
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

