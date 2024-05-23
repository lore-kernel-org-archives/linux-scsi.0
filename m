Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C0C78174C;
	Thu, 23 May 2024 12:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716469140; cv=none; b=s5KqFV5a82WfVwBCKKZgcyVjUc1anM1xRN7jQ937uuou0FVrUDsbCNV9gb2I+0/QphELZupY26jHvUlAlHWF1W84uNhhl3mxxlnM8uKxR50snidYO0jnLbmBxfPORf/gGvn6A9XkK3ewL9x0MtDm2zVO2watoc309cFM+26IjpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716469140; c=relaxed/simple;
	bh=weEYl6VBPgDFrEHa6UzdQDJyfa30XR8+4PkfKpY9u+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kqF0xs11iffxenFmYZg+/0HNY3jQSKxv0x1Y5uDm5WdEbuq64natcwWxgi6SU81jWCvf7tK+ZTpoR0EHuX2lFCmN8awXuQw342NN6+cRE5FZF17HkH1xPIEsYz3KifOGukxC8Gl10gCDznQzEvRypZJRQdr9E5qZJRYa24QmSLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=dlhGgJir; arc=none smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="dlhGgJir"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1716469137; x=1748005137;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=weEYl6VBPgDFrEHa6UzdQDJyfa30XR8+4PkfKpY9u+Q=;
  b=dlhGgJir30MMqZGucwod16iet5uuatM0YBu8BU41w0PZaQn0pqFjprX8
   rckK2gntWx9WFOsQQn771LHZ66KyVcvt1IX85Oc5hPQLj3nJm6inkjuLw
   4o2kQFhcDML3aNSRi7kboT4WgJLvHB5JMWbt4hMVn32ddMZ1xQe6xM4Tu
   BRJ0mWbjokdpGIwSCu2YRBTVxJjqqZtSxO0MewdUO3e0AU/SdCzydB6lV
   nTWOGwtbK/Cv4GaL34COaqjCtDju2+lyZsjfAEjCjOHCp21NqgKH+KTyj
   pyG+29jsTP+ubf5HJnPn9uA+LDQvSgFthF/ptWfgn8N2YJkpvYVNmbLY3
   g==;
X-CSE-ConnectionGUID: 391sdrR/TUygf+bO//3dvg==
X-CSE-MsgGUID: sRq+viBRSWafHCaIG9zgkQ==
X-IronPort-AV: E=Sophos;i="6.08,182,1712592000"; 
   d="scan'208";a="17902276"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 23 May 2024 20:58:55 +0800
IronPort-SDR: 664f2ff3_NdXhDMeSlIPBASy7p/qsdtaNZyUM2ng44C2/ImtxQRtTm5N
 cdJMbeNYFw7yU9s85/iU6z0A6fWqTSlo96v/IgA==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 May 2024 05:00:51 -0700
WDCIronportException: Internal
Received: from bxygm33.ad.shared ([10.45.31.229])
  by uls-op-cesaip02.wdc.com with ESMTP; 23 May 2024 05:58:54 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>,
	Peter Wang <peter.wang@mediatek.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v5 2/3] scsi: ufs: Allow platform vendors to set rtt
Date: Thu, 23 May 2024 15:58:25 +0300
Message-ID: <20240523125827.818-3-avri.altman@wdc.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240523125827.818-1-avri.altman@wdc.com>
References: <20240523125827.818-1-avri.altman@wdc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow platform vendors to take precedence having their own rtt
negotiation mechanism.  This makes sense because the host controller's
nortt characteristic may vary among vendors.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/ufs/core/ufshcd.c | 5 ++++-
 include/ufs/ufshcd.h      | 2 ++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 7df8bcacbe7e..d8e0e80d66a5 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8542,7 +8542,10 @@ static int ufshcd_device_params_init(struct ufs_hba *hba)
 		goto out;
 	}
 
-	ufshcd_set_rtt(hba);
+	if (hba->vops && hba->vops->set_rtt)
+		hba->vops->set_rtt(hba);
+	else
+		ufshcd_set_rtt(hba);
 
 	ufshcd_get_ref_clk_gating_wait(hba);
 
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index d74bd2d67b06..495b50a72f9f 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -329,6 +329,7 @@ struct ufs_pwr_mode_info {
  * @get_outstanding_cqs: called to get outstanding completion queues
  * @config_esi: called to config Event Specific Interrupt
  * @config_scsi_dev: called to configure SCSI device parameters
+ * @set_rtt: negotiate rtt
  */
 struct ufs_hba_variant_ops {
 	const char *name;
@@ -374,6 +375,7 @@ struct ufs_hba_variant_ops {
 	int	(*get_outstanding_cqs)(struct ufs_hba *hba,
 				       unsigned long *ocqs);
 	int	(*config_esi)(struct ufs_hba *hba);
+	void	(*set_rtt)(struct ufs_hba *hba);
 };
 
 /* clock gating state  */
-- 
2.34.1

