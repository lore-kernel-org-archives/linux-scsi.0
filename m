Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E354F41D631;
	Tue, 13 Oct 2026 10:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791885630; cv=none; b=fndnyKktMQMl0/YhGtMDBLp8aIRAke1+muXu7ulAODLOTzeuIJiKnWXLx6wezpivcbvRZ7B9go5BYR5OE9Y2MPGecYHfrtXjJhlnCFVCY2t7dDlkyHQ9SLunyen9/n0RMLyKo78/6pQkF9NhRXhyVVAxZT0X1Kuuc5BRPXBCXKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791885630; c=relaxed/simple;
	bh=ij8DXb9AszlL7+ayMVlj08Let4/fuS6eqq7j3crkeGg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QoF3e24UQIwuZm7YZX4SUHYACPhYiz436KddEIn9qLQhhhPoZdiezfdy34n2PzVV82j3HB0C03xEoB/RTy+KF0tlYJio2ArjHrgLhhGFD20nHai1vRmaAJNoWCi/5Nr2WQf6YPhMRe1VX1eicWp7uaq/iYX6m+m2oPeZm/YqqwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lBvhgzhu; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lBvhgzhu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791885629; x=1823421629;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ij8DXb9AszlL7+ayMVlj08Let4/fuS6eqq7j3crkeGg=;
  b=lBvhgzhuLSyzz0t3SHE+8/2c1Ddtz/++G+Dh3jccBUxgWZNwHr5YDuWX
   PmAqeq/9gmHfbYDkiLWkTh2TXua5hVtEM5v1TyhORvIItGeIymW4wm1W0
   FTHMlWE5apL529Ci1FC7q2vhs/eMbPabZh+43aHcRdcFarDE/plkg5s36
   N8cfcXYG1TSOq+qhp/bwxGc/hbjqt4Dr9IJpulMLEx5oc7M+4zrzCbAEu
   AhiPqgfUsnh1AM3uKA5fdJCvt2vUEnACcOeqFEHsA2+/1tyM8gUWgQr9A
   VN1tRBCm3S1YRwJr5q8tAsllpN9e9fG15ZQvb+UtHOfofbZh1+EFb1oD3
   A==;
X-CSE-ConnectionGUID: 1tnwBDxXQMaFdEAqymxhTw==
X-CSE-MsgGUID: rh1101sWQEOjlvAyGW7Akg==
X-IronPort-AV: E=McAfee;i="6800,10657,11933"; a="504189"
X-IronPort-AV: E=Sophos;i="6.27,155,1787036400"; 
   d="scan'208";a="504189"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2026 03:00:28 -0700
X-CSE-ConnectionGUID: H4dzonFgTGeBaxHmUhc+fw==
X-CSE-MsgGUID: LAu6IWiFQG+/Z8ptIW0ILA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,155,1787036400"; 
   d="scan'208";a="1055460"
Received: from black.igk.intel.com ([10.91.253.5])
  by orviesa005.jf.intel.com with ESMTP; 13 Oct 2026 03:00:26 -0700
Received: by black.igk.intel.com (Postfix, from userid 1003)
	id EE5BE99; Tue, 13 Oct 2026 12:00:24 +0200 (CEST)
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Can Guo <can.guo@oss.qualcomm.com>,
	linux-arm-msm@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Manivannan Sadhasivam <mani@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 1/1] scsi: ufs: ufs-qcom: Don't define variable in the middle of the code
Date: Tue, 13 Oct 2026 11:59:24 +0200
Message-ID: <20261013095924.959455-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

While the C11 allows us to define variables in the code, we do not
do this style (see more at [1]). Move the declaration to the top of
the function.

Link: https://lore.kernel.org/lkml/58fd478f408a34b578ee8d949c5c4b4da4d4f41d.camel@HansenPartnership.com/ [1]
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/ufs/host/ufs-qcom.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 91a14a32f205..fee9b54ba5e1 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -2439,6 +2439,7 @@ static irqreturn_t ufs_qcom_mcq_esi_handler(int irq, void *data)
 static int ufs_qcom_config_esi(struct ufs_hba *hba)
 {
 	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
+	struct ufs_qcom_irq *qi;
 	int nr_irqs, ret;
 
 	if (host->esi_enabled)
@@ -2457,8 +2458,7 @@ static int ufs_qcom_config_esi(struct ufs_hba *hba)
 		return ret; /* Continue without ESI */
 	}
 
-	struct ufs_qcom_irq *qi = devm_kcalloc(hba->dev, nr_irqs, sizeof(*qi), GFP_KERNEL);
-
+	qi = devm_kcalloc(hba->dev, nr_irqs, sizeof(*qi), GFP_KERNEL);
 	if (!qi) {
 		platform_device_msi_free_irqs_all(hba->dev);
 		return -ENOMEM;
-- 
2.50.1

