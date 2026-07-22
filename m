Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9757C35E1BF
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jul 2026 22:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784757895; cv=none; b=BORDRfZwpn5oqhdB3n8su9iJ2KUYhnmtah1nE3Go+ww4WI6jDuFTvx8ZWXf/kJy42dDQQC5DCbo88ZP6CITXmFKY9fab4G1J4TAq6xvD0mIkwVYK9GcSfDSYMN3Unq0RQtt11LQYGEwEHd/hB5odEHaN5yHmSURhGqjqRqvS9Iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784757895; c=relaxed/simple;
	bh=CGn35QUkO7j+leN4oEpe+p3dtbCKSxHhvyQplcJZV4o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LqsiNkRglrY7KdGtoN6S+CH2fIDleRpjfTO2tYSiOcj8dMgJrAFA5Ka6e7JO9/LQ9pAb4R96JA81XGVFgpqxONjeobFrU3qdOPY+Hl2qOI8L9NS3U92KFjjPAnZob5YIrYGZ4ctDpFlfQ1shx0RsNHfTn6r8ddu9lvWD2XzZm70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=1aSiO3Ox; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="1aSiO3Ox"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1784757894; x=1816293894;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CGn35QUkO7j+leN4oEpe+p3dtbCKSxHhvyQplcJZV4o=;
  b=1aSiO3OxDH/tHTyioUxoJEFvSZIgdR101sVRKOi9ObYTF6UPJ1YyN83H
   DjaJg2J+fgqBSHESAHJckbf5DLoDBKWJUxrjpEQ2seu699BUB2s8uerog
   VzuK1f/dwCFrMmz04BpZmfcB5wf1RmV6AGL2rQMhNcIO+Byxcq8cEgZ/+
   5UiPqleZmFnNtHNPwgRigugc0D02yjR3I1VxnSGd8bW3orccFXYRCIrkN
   sOLJuii4wHbkAFimagfbtpXWYtb2TcsuhLUVdYLdTZV2hGwEqH1bKeaa2
   GtnYItlzbDRBDslH34fESz+F5jgAdrCpG895rjWu6K8DT1nzXWl3G8pbJ
   Q==;
X-CSE-ConnectionGUID: smAzN8DkSca0s08Up0sPKA==
X-CSE-MsgGUID: 50v4hvDAQNCbcT/7vWFypA==
X-IronPort-AV: E=Sophos;i="6.25,179,1779174000"; 
   d="scan'208";a="228175829"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 Jul 2026 15:04:54 -0700
Received: from dks-rocky10u1-dev.pdev.net (10.10.85.11) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.58; Wed, 22 Jul 2026 15:04:53 -0700
From: David Strahan <david.strahan@microchip.com>
To: <linux-scsi@vger.kernel.org>
CC: David Strahan <David.Strahan@microchip.com>, Mike McGowen
	<mike.mcgowen@microchip.com>, Don Brace <don.brace@microchip.com>, "David
 Strahan" <david.strahan@microchip.com>
Subject: [PATCH v1 1/4] smartpqi: Fix AIO retry marker cleared by SCSI core between dispatches.
Date: Wed, 22 Jul 2026 17:03:58 -0500
Message-ID: <20260722220401.6357-2-david.strahan@microchip.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260722220401.6357-1-david.strahan@microchip.com>
References: <20260722220401.6357-1-david.strahan@microchip.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: chn-vm-ex03.mchp-main.com (10.10.85.151) To
 chn-vm-ex01.mchp-main.com (10.10.85.143)

From: David Strahan <David.Strahan@microchip.com>

On recent Linux kernels the driver can enter a retry loop on the
AIO fast path when a request is retried, looping until timeout.
A diagnostic path that takes a physical drive offline on AIO-bypass
failure is also never entered on affected kernels.

Register a per-command initialization callback with the SCSI
core. Its presence causes the core to skip the per-dispatch
clear, so the retry marker now survives across the requeue and
the AIO-to-RAID fallback proceeds as intended. The driver takes
over the marker's lifetime: it is zeroed at tag allocation,
preserved across the retry requeue so the error path can act on
it, and cleared on terminal completion so the tag starts clean on
its next use.

Fixes: dce5c4afd035 ("scsi: core: Clear driver private data when retrying request")
Signed-off-by: Mike McGowen <mike.mcgowen@microchip.com>
Acked-by: Don Brace <don.brace@microchip.com>
Signed-off-by: David Strahan <david.strahan@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 5ec583d..3a75b9f 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -66,6 +66,12 @@ static struct pqi_cmd_priv *pqi_cmd_priv(struct scsi_cmnd *cmd)
 	return scsi_cmd_priv(cmd);
 }
 
+static int pqi_init_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
+{
+	memset(pqi_cmd_priv(cmd), 0, sizeof(struct pqi_cmd_priv));
+	return 0;
+}
+
 static void pqi_verify_structures(void);
 static void pqi_take_ctrl_offline(struct pqi_ctrl_info *ctrl_info,
 	enum pqi_ctrl_shutdown_reason ctrl_shutdown_reason);
@@ -5958,6 +5964,17 @@ void pqi_prep_for_scsi_done(struct scsi_cmnd *scmd)
 	struct pqi_scsi_dev *device;
 	struct completion *wait;
 
+	/*
+	 * Clear the AIO-retry marker on final completion so the tag
+	 * starts clean on its next dispatch.  On DID_IMM_RETRY leave
+	 * it intact: pqi_aio_io_complete() sets DID_IMM_RETRY and
+	 * bumps the marker to steer the requeue onto the RAID path,
+	 * and pqi_process_raid_io_error() consumes the non-zero
+	 * marker to offline a misbehaving drive.
+	 */
+	if (host_byte(scmd->result) != DID_IMM_RETRY)
+		pqi_cmd_priv(scmd)->this_residual = 0;
+
 	if (!scmd->device) {
 		set_host_byte(scmd, DID_NO_CONNECT);
 		return;
@@ -7612,6 +7629,7 @@ static const struct scsi_host_template pqi_driver_template = {
 	.sdev_groups = pqi_sdev_groups,
 	.shost_groups = pqi_shost_groups,
 	.cmd_size = sizeof(struct pqi_cmd_priv),
+	.init_cmd_priv = pqi_init_cmd_priv,
 };
 
 static int pqi_register_scsi(struct pqi_ctrl_info *ctrl_info)
-- 
2.52.0

