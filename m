Received: from spam.asrmicro.com (asrmicro.com [210.13.118.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D8D71A6808;
	Sat,  2 May 2026 14:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.13.118.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777732276; cv=none; b=BUDcBxzLSJR9oqWgZsUI8r6ItVogJ1btgJmkP0TcFv+FXj9UnbZJPWOE76tHTHqTsdwNVG8rRryXMr+msB43B3GGscqJypMIquS22c0QHMSg5bL3uObX+D0/vhoZieUk9QIctEAuCRcBIOdu0mV7L5ZwZ2BtgS7EfEilqIEjDcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777732276; c=relaxed/simple;
	bh=Z3aoTnzA5mwEcZtINla2Wao0hAuAIP81iM5NRLvXbe8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=rhFnh6DFH+XVKRRRflrNazsv9EOkC+rF10MwvbMwkuJFGfPVDQXZgGTRua7R2p5yzUJZdYu/Z9+OAGkCkqDTOhTewQ/sUpUDxRNOm2qDTt60Pa7rQC02+Nlgvre5AdN1pgVoZb6BFGMrNdvuyujpRh+YdANwWPMK2FTOXfjFhCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com; spf=pass smtp.mailfrom=asrmicro.com; arc=none smtp.client-ip=210.13.118.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asrmicro.com
Received: from exch02.asrmicro.com (exch02.asrmicro.com [10.1.24.122])
	by spam.asrmicro.com with ESMTPS id 642EUOnS067454
	(version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=FAIL);
	Sat, 2 May 2026 22:30:24 +0800 (GMT-8)
	(envelope-from hongjiefang@asrmicro.com)
Received: from localhost (10.1.170.248) by exch02.asrmicro.com (10.1.24.122)
 with Microsoft SMTP Server (TLS) id 15.0.847.32; Sat, 2 May 2026 22:30:30
 +0800
From: Hongjie Fang <hongjiefang@asrmicro.com>
To: <alim.akhtar@samsung.com>, <avri.altman@wdc.com>, <bvanassche@acm.org>,
        <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v5] scsi: ufs: core: call hibern8 notify when hibern8 cmd failed
Date: Sat, 2 May 2026 22:30:12 +0800
Message-ID: <20260502143012.2859480-1-hongjiefang@asrmicro.com>
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
X-MAIL:spam.asrmicro.com 642EUOnS067454

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
 drivers/ufs/core/ufshcd.c     | 11 ++++++-----
 drivers/ufs/host/ufs-exynos.c |  6 ++++++
 drivers/ufs/host/ufs-qcom.c   |  4 +++-
 include/ufs/ufshcd.h          |  1 +
 4 files changed, 16 insertions(+), 6 deletions(-)

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
diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index 76fee3a79c77..7ada4e96f236 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -1654,6 +1654,8 @@ static int exynos_ufs_hce_enable_notify(struct ufs_hba *hba,
 		if (ufs->drv_data->post_hce_enable)
 			ret = ufs->drv_data->post_hce_enable(ufs);
 
+		break;
+	default:
 		break;
 	}
 
@@ -1672,6 +1674,8 @@ static int exynos_ufs_link_startup_notify(struct ufs_hba *hba,
 	case POST_CHANGE:
 		ret = exynos_ufs_post_link(hba);
 		break;
+	default:
+		break;
 	}
 
 	return ret;
@@ -1692,6 +1696,8 @@ static int exynos_ufs_pwr_change_notify(struct ufs_hba *hba,
 	case POST_CHANGE:
 		ret = exynos_ufs_post_pwr_mode(hba, dev_req_params);
 		break;
+	default:
+		break;
 	}
 
 	return ret;
diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 375fd24ba458..4f1caf8dabbf 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -1234,7 +1234,7 @@ static int ufs_qcom_setup_clocks(struct ufs_hba *hba, bool on,
 {
 	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
 	struct phy *phy;
-	int err;
+	int err = 0;
 
 	/*
 	 * In case ufs_qcom_init() is not yet done, simply ignore.
@@ -1289,6 +1289,8 @@ static int ufs_qcom_setup_clocks(struct ufs_hba *hba, bool on,
 					    ufs_qcom_bw_table[MODE_MIN][0][0].cfg_bw);
 		}
 		break;
+	default:
+		break;
 	}
 
 	return 0;
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

