Received: from spam.asrmicro.com (asrmicro.com [210.13.118.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D243BB5A;
	Thu, 30 Apr 2026 04:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.13.118.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777522963; cv=none; b=bTCoomvfM5LkXDzg7lV4ju+zcK37WXa1diKNSgKVy1zwWcVA+h0MLu9xhzC2m00cqGRnZ5nMTWwGEkAvx9vTESa9Mbw8+GdM1WpIg109lKHKiwhJA9Hpmh470kOUUfMIrJNXCQIhB4ARKBYLVA7/D+Q1TjyEJqCCoUJ2lfkyYIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777522963; c=relaxed/simple;
	bh=1z/QHxhiCD6yWijr+R6xL9cdWtbtsbHFLbYbmWcWEAM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=TykgJMODBMXKeT9qo/quCqGGSQUjOg8i0O9LI3PoNcjd2e0B53YNh7fnPNmsB0TKVFLY1TaASnyTqLGybIm5b92hNSbwa6w5hJ8kiVBnI78cXJ1jEqG8RbQqN+qYh+0T9Bf1H4SMX8UkD1j9DifGpv/cXgCMesgXCOmEe0iPYCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com; spf=pass smtp.mailfrom=asrmicro.com; arc=none smtp.client-ip=210.13.118.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asrmicro.com
Received: from exch02.asrmicro.com (exch02.asrmicro.com [10.1.24.122])
	by spam.asrmicro.com with ESMTPS id 63U4MAmT010525
	(version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=FAIL);
	Thu, 30 Apr 2026 12:22:10 +0800 (GMT-8)
	(envelope-from hongjiefang@asrmicro.com)
Received: from localhost (10.1.170.248) by exch02.asrmicro.com (10.1.24.122)
 with Microsoft SMTP Server (TLS) id 15.0.847.32; Thu, 30 Apr 2026 12:22:13
 +0800
From: Hongjie Fang <hongjiefang@asrmicro.com>
To: <alim.akhtar@samsung.com>, <avri.altman@wdc.com>, <bvanassche@acm.org>,
        <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] scsi: ufs: core: call hibern8 notify when hibern8 cmd failed
Date: Thu, 30 Apr 2026 12:22:12 +0800
Message-ID: <20260430042212.3712251-1-hongjiefang@asrmicro.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: exch03.asrmicro.com (10.1.24.118) To exch02.asrmicro.com
 (10.1.24.122)
X-DNSRBL: 
X-SPAM-SOURCE-CHECK: pass
X-MAIL:spam.asrmicro.com 63U4MAmT010525

The vendor hibern8 notify callback always can be executed in the
PRE_CHANGE phase of hibern8 enter/exit. But it cannot be executed
in the POST_CHANGE phase if the hibern8 cmd fails.

When the hibern8 cmd fails, the vendor hibern8 notify callback
should still have the opportunity to execute.

Add a third enum ROLLBACK_CHANGE for the ufshcd_vops_hibern8_notify(),
pass the ROLLBACK_CHANGE when the hibern8 command returns a failure and
use the POST_CHANGE otherwise.

Signed-off-by: Hongjie Fang <hongjiefang@asrmicro.com>
---
 drivers/ufs/core/ufshcd.c | 11 ++++++-----
 include/ufs/ufshcd.h      |  1 +
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 9ceb6d6d479d..1d4939bb7ec0 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4500,9 +4500,9 @@ int ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
 	if (ret)
 		dev_err(hba->dev, "%s: hibern8 enter failed. ret = %d\n",
 			__func__, ret);
-	else
-		ufshcd_vops_hibern8_notify(hba, UIC_CMD_DME_HIBER_ENTER,
-								POST_CHANGE);
+
+	ufshcd_vops_hibern8_notify(hba, UIC_CMD_DME_HIBER_ENTER,
+					ret ? ROLLBACK_CHANGE : POST_CHANGE);
 
 	return ret;
 }
@@ -4526,12 +4526,13 @@ int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
 		dev_err(hba->dev, "%s: hibern8 exit failed. ret = %d\n",
 			__func__, ret);
 	} else {
-		ufshcd_vops_hibern8_notify(hba, UIC_CMD_DME_HIBER_EXIT,
-								POST_CHANGE);
 		hba->ufs_stats.last_hibern8_exit_tstamp = local_clock();
 		hba->ufs_stats.hibern8_exit_cnt++;
 	}
 
+	ufshcd_vops_hibern8_notify(hba, UIC_CMD_DME_HIBER_EXIT,
+					ret ? ROLLBACK_CHANGE : POST_CHANGE);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(ufshcd_uic_hibern8_exit);
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 8563b6648976..4f7c619db324 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -270,6 +270,7 @@ struct ufs_clk_info {
 enum ufs_notify_change_status {
 	PRE_CHANGE,
 	POST_CHANGE,
+	ROLLBACK_CHANGE,
 };
 
 struct ufs_pa_layer_attr {
-- 
2.25.1

