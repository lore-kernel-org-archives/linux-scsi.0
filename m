Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFDB53DA5B0
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jul 2026 20:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784751822; cv=none; b=OvGMOsfqd9eiHILG/k+Dxqs7zSCxEiCJflx+w90v49vKtY/HAA3Dt+frbzd764zVZw0X5Y96efSmY+m95ZaMe+gDvcBsr/U46goAYPJYUg+1iCRtkk+SY98sBFTDUVJJLIb+95bOfesnyfg6sSI3VIvu2MCeIdCDAdC4dS0UNms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784751822; c=relaxed/simple;
	bh=Z5gXa3lkiwDGvF302dpdCXW5PyeoJEjCZxWYpKwAVGY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RdtDYRGOyl2Cz9/eWt3WPtctq6e0J6roDj/rymupIHtdkBgrsmBLN6qPXebbstakhn/bM9O+VTAcrY68m9CRqLrOG7M/rqsp3WBVDMdJ4lLGgtlheZOSI1QNEMEen3pqRpuIonWdyzMQAjQs6nPuaOEZz/cVdfDPCAso62ppPQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=rQIYxq4F; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="rQIYxq4F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1784751820; x=1816287820;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Z5gXa3lkiwDGvF302dpdCXW5PyeoJEjCZxWYpKwAVGY=;
  b=rQIYxq4Fs+XXhr9A7sFNSAxt5/yjPEd1jUX9Vi4gpgXr1jnzWuOUEb40
   UPYc97JqMBmZpjSxOFJStfAi4Uqmf/4uMaWl2Xgw1YMgUZr1GJHJJY238
   c57/ZrAKLvAmdOFskgM9oFsv/iyMn54I9jSNnN0i9evGYTvedNJn+9owR
   YpUS3luIUsqvS7LKRWs6+59XK1DnXREjQCkBHdzbDvtNsdswfA9WVr9M5
   qLiVYL41jAV0hKpMlVPoqktMU9qYmFSWAqc7Si5i8yoaYCqORc6Mpj47T
   pbWZC9HXO+ifN1TriW1beRdbwBcDORGNGCgKAYcY3eULWA2S76XGzhLJS
   g==;
X-CSE-ConnectionGUID: DIPbCS+iQpCNONGRQaeErw==
X-CSE-MsgGUID: h8tebPbaQ/qtig4Y/IW0/A==
X-IronPort-AV: E=Sophos;i="6.25,179,1779174000"; 
   d="scan'208";a="60160552"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 Jul 2026 13:23:39 -0700
Received: from dks-rocky10u1-dev.pdev.net (10.10.85.11) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.58; Wed, 22 Jul 2026 13:23:38 -0700
From: David Strahan <david.strahan@microchip.com>
To: <david.strahan@microchip.com>, <linux-scsi@vger.kernel.org>
CC: <don.brace@microchip.com>
Subject: [PATCH] scsi: smartpqi: Fix AIO retry marker cleared by SCSI core between dispatches
Date: Wed, 22 Jul 2026 15:23:26 -0500
Message-ID: <20260722202327.5242-3-david.strahan@microchip.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260722202327.5242-1-david.strahan@microchip.com>
References: <20260722202327.5242-1-david.strahan@microchip.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: chn-vm-ex01.mchp-main.com (10.10.85.143) To
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
2.47.3

