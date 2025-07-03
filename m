Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7046291C33
	for <linux-scsi@vger.kernel.org>; Thu,  3 Jul 2025 06:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751525027; cv=none; b=hgL/kCDhZyhRlz8Vu5IYb8/r1o4SeT6yspafYFheeurX5zyoZHz5m7BsqODTMdbgdor1i7ZJ2PNDTDcmr+GwhbChCZOch6EZmvJxDbe19Ti44KHVyJds9oFztYUSKfATVCE52hvEQpX8sghICMMv3XwyjtioHftWY0XjQZf046g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751525027; c=relaxed/simple;
	bh=13n3vBVKky90KCALe6TApijuxe3h9SATDkQCzYROkjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UJNuI8DuCxyudRNPfmuthEHPba2P756tY0gucRnXfeVuZ4cA/58kKusiQIbOBHz3Z5KdNq0wB8BAEZWINUiSbJlRv0XPEzKviZoq4Qr2flhw/VpIrUg9VOtZr6ZHraGKOsATtOzBd3myXYOlouOtKY9/qBrKRo7H/rfzQKAj+SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OwkjLK9O; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OwkjLK9O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751525026; x=1783061026;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=13n3vBVKky90KCALe6TApijuxe3h9SATDkQCzYROkjg=;
  b=OwkjLK9ORMqdDShTHuv6DNKD7IB/tkEgcHZ+VxO2Jp4T3foUDQKZIbou
   gsKpx6pdQD1OHVIdhiNSjEcJxJg6zii5NHPf8z8JXQ704B1/cNoR4DBRE
   /uwWCjT0Hni8WqoPQTyGdnK0V6Wj1x7W22Fht25NfYlpXZyrRzcckfVFg
   AjTZIGYo0rlEgMis3n6LRGqXS6JhuZeIRejO29YHbo7j9DH4hDNQtB9pT
   t99z5OrUKez3shwLERwFBel3F5wL3evi7pOLRSVwXUoqvALpLDcydjjXe
   Z1aTmwFytJ1jQJxLIYWg+Ch/bFzBgN86OoH7roc94S6W8/GbGXgoQGIee
   w==;
X-CSE-ConnectionGUID: ENzNwnIHS1i3mXFR+1lLbg==
X-CSE-MsgGUID: VjhI7F1XTJmSVBRvWxv1AA==
X-IronPort-AV: E=McAfee;i="6800,10657,11482"; a="64533838"
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="64533838"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 23:43:45 -0700
X-CSE-ConnectionGUID: IdHp08I4QJOzaLygqtiT4A==
X-CSE-MsgGUID: l121ALVeS0anNh6qP9v4HA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="158646064"
Received: from johunt-mobl9.ger.corp.intel.com (HELO localhost.localdomain) ([10.245.244.86])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 23:43:44 -0700
From: Adrian Hunter <adrian.hunter@intel.com>
To: Martin K Petersen <martin.petersen@oracle.com>
Cc: James EJ Bottomley <James.Bottomley@HansenPartnership.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@sandisk.com>,
	Archana Patni <archana.patni@intel.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH 1/3] scsi: ufs: ufs-pci: Fix hibernate state transition for Intel MTL-like host controllers
Date: Thu,  3 Jul 2025 09:43:20 +0300
Message-ID: <20250703064322.46679-2-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250703064322.46679-1-adrian.hunter@intel.com>
References: <20250703064322.46679-1-adrian.hunter@intel.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park, 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit

From: Archana Patni <archana.patni@intel.com>

UFSHCD core disables the UIC completion interrupt when issuing UIC
hibernation commands, and re-enables it afterwards if it was enabled to
start with, refer ufshcd_uic_pwr_ctrl(). For Intel MTL-like host
controllers, accessing the register to re-enable the interrupt disrupts the
state transition.

Use hibern8_notify variant operation to disable the interrupt during the
entire hibernation, thereby preventing the disruption.

Fixes: 4049f7acef3eb ("scsi: ufs: ufs-pci: Add support for Intel MTL")
Cc: stable@vger.kernel.org
Signed-off-by: Archana Patni <archana.patni@intel.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/ufs/host/ufshcd-pci.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/ufs/host/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.c
index 996387906aa1..af1c272eef1c 100644
--- a/drivers/ufs/host/ufshcd-pci.c
+++ b/drivers/ufs/host/ufshcd-pci.c
@@ -216,6 +216,32 @@ static int ufs_intel_lkf_apply_dev_quirks(struct ufs_hba *hba)
 	return ret;
 }
 
+static void ufs_intel_ctrl_uic_compl(struct ufs_hba *hba, bool enable)
+{
+	u32 set = ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
+
+	if (enable)
+		set |= UIC_COMMAND_COMPL;
+	else
+		set &= ~UIC_COMMAND_COMPL;
+	ufshcd_writel(hba, set, REG_INTERRUPT_ENABLE);
+}
+
+static void ufs_intel_mtl_h8_notify(struct ufs_hba *hba,
+				    enum uic_cmd_dme cmd,
+				    enum ufs_notify_change_status status)
+{
+	/*
+	 * Disable UIC COMPL INTR to prevent access to UFSHCI after
+	 * checking HCS.UPMCRS
+	 */
+	if (status == PRE_CHANGE && cmd == UIC_CMD_DME_HIBER_ENTER)
+		ufs_intel_ctrl_uic_compl(hba, false);
+
+	if (status == POST_CHANGE && cmd == UIC_CMD_DME_HIBER_EXIT)
+		ufs_intel_ctrl_uic_compl(hba, true);
+}
+
 #define INTEL_ACTIVELTR		0x804
 #define INTEL_IDLELTR		0x808
 
@@ -533,6 +559,7 @@ static struct ufs_hba_variant_ops ufs_intel_mtl_hba_vops = {
 	.init			= ufs_intel_mtl_init,
 	.exit			= ufs_intel_common_exit,
 	.hce_enable_notify	= ufs_intel_hce_enable_notify,
+	.hibern8_notify		= ufs_intel_mtl_h8_notify,
 	.link_startup_notify	= ufs_intel_link_startup_notify,
 	.resume			= ufs_intel_resume,
 	.device_reset		= ufs_intel_device_reset,
-- 
2.48.1

