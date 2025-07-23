Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D6C20C029
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jul 2025 16:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753289965; cv=none; b=UCWUdTWSwRKEtYlzNrumdYQcKrbtGPUoDOZx6xMMwtQ8K2UUO83CF1tEPn4IW9xLlCGqXg3cBOf6VRXwLQ+YtQBxUU0O0tceRSxE0P69bzxXRP2/jAlQMQMuD2wr8iduPjScOxVIMctQJRrhchJOXn7quLRiYw2trxvgMYf35ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753289965; c=relaxed/simple;
	bh=huMn8N5cHch9+6sXoQs7lvbGPsQo0GdGLJzG2/XTdN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LyQtsPYzw7t2xPCqnslby32N2lhCV6O5YoEm/LfVRgyUy2H6lofyBR4JVT9pDLrz+IaKpu2J79VYz17Bpdvvgrb49IGL2ulK/fkfLtSPJ7sx0if5a8DdSWHtSqRuSmbSsWdKPKlfs6wQj+bqhUrvj/zhW11+gm3/ZPXnuWdCiMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GnnVEIpg; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GnnVEIpg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753289964; x=1784825964;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=huMn8N5cHch9+6sXoQs7lvbGPsQo0GdGLJzG2/XTdN4=;
  b=GnnVEIpgxy0L/UZ+Zpw0CnmGxYaggVxdfYxNHZsgv+kFJGTvqw0fNXig
   4qD8ixf9KqV1U4I0MiiLxihH36C3mcZRXsik4Ufny0maewCmxJL/Wfptn
   2/Yx6huVIq+odGgtzLcpL+ZdrGUfueXxvD/oD+i+M30EpOZu5bd9C5RKO
   SWwlGMG9rkY1iY6JiW5p5MxcpyIZUf99Ur2+AQAcx53d5q6dn2qT1EZ8L
   6FamcFHiyRXYzro+rvP/lPHpMJeFr65zV+MFQ27OR4XtRDNS7dDwaEYUr
   kUVDDp4v9ab74TJwJTS7mK7UbbpCPPce3XmiSTHPn80JpiN2bxJah85gj
   w==;
X-CSE-ConnectionGUID: sKl4Lhr3QAe6lM8wM3t0Gw==
X-CSE-MsgGUID: 1SS2jQvsTMmdPDBlPT0X+g==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="55735020"
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="55735020"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 09:59:24 -0700
X-CSE-ConnectionGUID: kk9UDyMrR3OcAWnG/J4C3g==
X-CSE-MsgGUID: 2tSjjMK9RnezMuPiVe/vDw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="196733027"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO localhost.localdomain) ([10.245.245.72])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 09:59:22 -0700
From: Adrian Hunter <adrian.hunter@intel.com>
To: Martin K Petersen <martin.petersen@oracle.com>
Cc: James EJ Bottomley <James.Bottomley@HansenPartnership.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@sandisk.com>,
	Archana Patni <archana.patni@intel.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH V2 6/8] scsi: ufs: core: Set and clear UIC Completion interrupt as needed
Date: Wed, 23 Jul 2025 19:58:54 +0300
Message-ID: <20250723165856.145750-7-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250723165856.145750-1-adrian.hunter@intel.com>
References: <20250723165856.145750-1-adrian.hunter@intel.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park, 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit

Currently the UIC Completion interrupt is left enabled except for when
issuing link hibernate commands, in which case the interrupt is disabled
and then re-enabled.

Instead, set and clear the interrupt enable bit as needed.

That is slightly simpler and less error prone, but also avoids side effects
of accessing the interrupt enable register after entering link hibernation.
Specifically, for some host controllers like Intel MTL, doing so disrupts
the link state transition.

Note also, the interrupt register is not read back anymore after it is
updated.  No other code does that, so it is assumed to be no longer
necessary if it ever was.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/ufs/core/ufshcd.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 7fb0ca3576d4..1567aba866b5 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2622,6 +2622,7 @@ __ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
  */
 int ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 {
+	unsigned long flags;
 	int ret;
 
 	if (hba->quirks & UFSHCD_QUIRK_BROKEN_UIC_CMD)
@@ -2631,6 +2632,10 @@ int ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 	mutex_lock(&hba->uic_cmd_mutex);
 	ufshcd_add_delay_before_dme_cmd(hba);
 
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	ufshcd_enable_intr(hba, UIC_COMMAND_COMPL);
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
 	ret = __ufshcd_send_uic_cmd(hba, uic_cmd);
 	if (!ret)
 		ret = ufshcd_wait_for_uic_cmd(hba, uic_cmd);
@@ -4318,7 +4323,6 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 	unsigned long flags;
 	u8 status;
 	int ret;
-	bool reenable_intr = false;
 
 	mutex_lock(&hba->uic_cmd_mutex);
 	ufshcd_add_delay_before_dme_cmd(hba);
@@ -4329,15 +4333,7 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 		goto out_unlock;
 	}
 	hba->uic_async_done = &uic_async_done;
-	if (ufshcd_readl(hba, REG_INTERRUPT_ENABLE) & UIC_COMMAND_COMPL) {
-		ufshcd_disable_intr(hba, UIC_COMMAND_COMPL);
-		/*
-		 * Make sure UIC command completion interrupt is disabled before
-		 * issuing UIC command.
-		 */
-		ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
-		reenable_intr = true;
-	}
+	ufshcd_disable_intr(hba, UIC_COMMAND_COMPL);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	ret = __ufshcd_send_uic_cmd(hba, cmd);
 	if (ret) {
@@ -4381,8 +4377,6 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	hba->active_uic_cmd = NULL;
 	hba->uic_async_done = NULL;
-	if (reenable_intr)
-		ufshcd_enable_intr(hba, UIC_COMMAND_COMPL);
 	if (ret) {
 		ufshcd_set_link_broken(hba);
 		ufshcd_schedule_eh_work(hba);
-- 
2.48.1

