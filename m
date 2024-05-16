Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6470929424;
	Thu, 16 May 2024 05:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715838710; cv=none; b=r9qDTjeGY3tZjiBeet5lA3flcpB+L/tVYctUDSdqMs3wyE3MO33dX7Auqdxj4ThLjvl1AFuChfZZOtWIS8XLkq//W17+/OrUBj6SgYpzAAtwb1fY5BjGvzYR0Bc3gpTZoPNewYIgCJvfuuFuYUyAijmWHPW7/B1T6pxZCWoZ2V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715838710; c=relaxed/simple;
	bh=q71DnC9S45cHGSP7aHjDfuajgF1C8NzvZXMKmM3pLNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SK7P9E6Km2tyQW53RGs3suu9+/rIgOXYwvC5fClZFphhqm1ib1pxvgo7KmSGqkA18i6KQF5Xh279itV7cjrrjeofGYqH8v6Xp1ZkGmZpMdTeCn5LxUUUcAOsLPC40We/70AwZJNcOxG6UqadjeFuyCnFrUsMI+Yo8cZ+w07uQQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=ei8vkge8; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ei8vkge8"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1715838708; x=1747374708;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=q71DnC9S45cHGSP7aHjDfuajgF1C8NzvZXMKmM3pLNg=;
  b=ei8vkge88I0KR8jMXoZDPChNXMO+LXO0kcPfBvVTehY/rbu9k6TuTsyf
   iz7q9l/nISrUg6CmTtQwJ8FT7DeAy7Y6YuYkLhyGRByH9mtHrIJDb09h8
   FkHQGy1uNx+7OtWwoIpbzFRmZD9YNLxKyilyBoTlflnTAkttUKgR2SRTA
   qxvGlu96TWgNfFZX64RVNbfQiOYAy0Cdjm8gbfcFCemZaDmj5dJCFjYmw
   jqLX/yXbb/eEI10kT6tzKNEfJK4DesipWLAnRGVywH50yIYXrVEDHMdMJ
   fGazgVFF7JQKG5e5COxGmd/tikt8rpWHNcu1LxUyboK9lCpP4AxhlNnvP
   w==;
X-CSE-ConnectionGUID: oX3FVi/FTxqfMS2btVSf9w==
X-CSE-MsgGUID: H6oDOhGLSG6k9rOikp+Avw==
X-IronPort-AV: E=Sophos;i="6.08,163,1712592000"; 
   d="scan'208";a="16457576"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 16 May 2024 13:51:46 +0800
IronPort-SDR: 664592b3_dI9ZHyBQ7K9/ptOZjIlTIbpM7BHPe08YCxd8kvRghQ2viud
 HoMp/vdoNfkoiWUG0XdYQZIUKXfwF5KlJaH67Jw==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 15 May 2024 21:59:31 -0700
WDCIronportException: Internal
Received: from bxygm33.ad.shared ([10.45.31.229])
  by uls-op-cesaip02.wdc.com with ESMTP; 15 May 2024 22:51:45 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>,
	Peter Wang <peter.wang@mediatek.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v4 2/3] scsi: ufs: Allow platform vendors to set rtt
Date: Thu, 16 May 2024 08:51:23 +0300
Message-ID: <20240516055124.24490-3-avri.altman@wdc.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240516055124.24490-1-avri.altman@wdc.com>
References: <20240516055124.24490-1-avri.altman@wdc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow platform vendors to take precedence having their own rtt
negotiation mechanism.  This makes sense because the host controller's
nortt characteristic may defer among vendors.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/ufs/core/ufshcd.c | 5 ++++-
 include/ufs/ufshcd.h      | 2 ++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index c472bfdf071e..0407d1064e74 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8312,7 +8312,10 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 	if (hba->ext_iid_sup)
 		ufshcd_ext_iid_probe(hba, desc_buf);
 
-	ufshcd_rtt_set(hba, desc_buf);
+	if (hba->vops && hba->vops->rtt_set)
+		hba->vops->rtt_set(hba, desc_buf);
+	else
+		ufshcd_rtt_set(hba, desc_buf);
 
 	/*
 	 * ufshcd_read_string_desc returns size of the string
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index d74bd2d67b06..9237ea65bd26 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -329,6 +329,7 @@ struct ufs_pwr_mode_info {
  * @get_outstanding_cqs: called to get outstanding completion queues
  * @config_esi: called to config Event Specific Interrupt
  * @config_scsi_dev: called to configure SCSI device parameters
+ * @rtt_set: negotiate rtt
  */
 struct ufs_hba_variant_ops {
 	const char *name;
@@ -374,6 +375,7 @@ struct ufs_hba_variant_ops {
 	int	(*get_outstanding_cqs)(struct ufs_hba *hba,
 				       unsigned long *ocqs);
 	int	(*config_esi)(struct ufs_hba *hba);
+	void	(*rtt_set)(struct ufs_hba *hba, u8 *desc_buf);
 };
 
 /* clock gating state  */
-- 
2.34.1

