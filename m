Received: from spam.asrmicro.com (asrmicro.com [210.13.118.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279263A7F7E;
	Wed, 29 Apr 2026 11:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.13.118.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777461889; cv=none; b=oYeL8N1xFG3KUnUNAutTq+KSDYTONB9/N77QgPEJPRNpbtepXDhLnQxjSyvLVj69Rv4LF6AuBUcLrd0oycqS/kVWmggtUgkeDyNIPBUZoDCz0jWG/rjzOwfOjMAN+ayxXWq2Wzyet2dgs2Gmnihw5tk2AYbLbB8TZ0X+9+2gq5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777461889; c=relaxed/simple;
	bh=iLm/PVfzBrx1LKhX7lAS/cMk6aLU7WbRyc8kZyU03q4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ATsJP6MFm9zn7HxvsORRkO1qTjpLxfuJArPIPL6pCo/r7iSK4i+Hd3p0qWjjm5o0RHfV7Tv3+H7l9kCnjQkIAB4pnTNJ/YB8sZE01ZPL4gZD3JlaVyC+aFrze8AkUNqRxkrZZUADVQ5oCMe9//R8UYvqM93R7QxwJYsou3iwGw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com; spf=pass smtp.mailfrom=asrmicro.com; arc=none smtp.client-ip=210.13.118.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asrmicro.com
Received: from exch02.asrmicro.com (exch02.asrmicro.com [10.1.24.122])
	by spam.asrmicro.com with ESMTPS id 63TBNpCh003312
	(version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=FAIL);
	Wed, 29 Apr 2026 19:23:51 +0800 (GMT-8)
	(envelope-from hongjiefang@asrmicro.com)
Received: from localhost (10.1.170.248) by exch02.asrmicro.com (10.1.24.122)
 with Microsoft SMTP Server (TLS) id 15.0.847.32; Wed, 29 Apr 2026 19:23:55
 +0800
From: Hongjie Fang <hongjiefang@asrmicro.com>
To: <alim.akhtar@samsung.com>, <avri.altman@wdc.com>, <bvanassche@acm.org>,
        <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] scsi: ufs: core: call hibern8 notify when hibern8 cmd failed
Date: Wed, 29 Apr 2026 19:23:55 +0800
Message-ID: <20260429112355.4125408-1-hongjiefang@asrmicro.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: exch01.asrmicro.com (10.1.24.121) To exch02.asrmicro.com
 (10.1.24.122)
X-DNSRBL: 
X-SPAM-SOURCE-CHECK: pass
X-MAIL:spam.asrmicro.com 63TBNpCh003312

The vendor hibern8 notify callback always can be executed in the
PRE_CHANGE phase of hibern8 enter/exit. But it cannot be executed
in the POST_CHANGE phase if the hibern8 cmd fails.

When the hibern8 cmd fails, the vendor hibern8 notify callback
should still have the opportunity to execute.

Add a new argument to ufshcd_vops_hibern8_notify() that represents
whether or not the hibern8 cmd succeeded for POST_CHANGE callbacks.

Signed-off-by: Hongjie Fang <hongjiefang@asrmicro.com>
---
 drivers/ufs/core/ufshcd-priv.h |  5 +++--
 drivers/ufs/core/ufshcd.c      | 13 ++++++-------
 drivers/ufs/host/cdns-pltfrm.c |  4 ++--
 drivers/ufs/host/ufs-exynos.c  |  6 ++++--
 drivers/ufs/host/ufs-sprd.c    |  5 +++--
 include/ufs/ufshcd.h           |  3 ++-
 6 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index 37c32071e754..1d3b90e280a9 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -188,10 +188,11 @@ static inline void ufshcd_vops_setup_task_mgmt(struct ufs_hba *hba,
 
 static inline void ufshcd_vops_hibern8_notify(struct ufs_hba *hba,
 					enum uic_cmd_dme cmd,
-					enum ufs_notify_change_status status)
+					enum ufs_notify_change_status status,
+					int cmd_ret)
 {
 	if (hba->vops && hba->vops->hibern8_notify)
-		return hba->vops->hibern8_notify(hba, cmd, status);
+		return hba->vops->hibern8_notify(hba, cmd, status, cmd_ret);
 }
 
 static inline int ufshcd_vops_apply_dev_quirks(struct ufs_hba *hba)
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 9ceb6d6d479d..ec636a9b643d 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4491,7 +4491,7 @@ int ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
 	ktime_t start = ktime_get();
 	int ret;
 
-	ufshcd_vops_hibern8_notify(hba, UIC_CMD_DME_HIBER_ENTER, PRE_CHANGE);
+	ufshcd_vops_hibern8_notify(hba, UIC_CMD_DME_HIBER_ENTER, PRE_CHANGE, 0);
 
 	ret = ufshcd_uic_pwr_ctrl(hba, &uic_cmd);
 	trace_ufshcd_profile_hibern8(hba, "enter",
@@ -4500,9 +4500,8 @@ int ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
 	if (ret)
 		dev_err(hba->dev, "%s: hibern8 enter failed. ret = %d\n",
 			__func__, ret);
-	else
-		ufshcd_vops_hibern8_notify(hba, UIC_CMD_DME_HIBER_ENTER,
-								POST_CHANGE);
+
+	ufshcd_vops_hibern8_notify(hba, UIC_CMD_DME_HIBER_ENTER, POST_CHANGE, ret);
 
 	return ret;
 }
@@ -4516,7 +4515,7 @@ int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
 	int ret;
 	ktime_t start = ktime_get();
 
-	ufshcd_vops_hibern8_notify(hba, UIC_CMD_DME_HIBER_EXIT, PRE_CHANGE);
+	ufshcd_vops_hibern8_notify(hba, UIC_CMD_DME_HIBER_EXIT, PRE_CHANGE, 0);
 
 	ret = ufshcd_uic_pwr_ctrl(hba, &uic_cmd);
 	trace_ufshcd_profile_hibern8(hba, "exit",
@@ -4526,12 +4525,12 @@ int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
 		dev_err(hba->dev, "%s: hibern8 exit failed. ret = %d\n",
 			__func__, ret);
 	} else {
-		ufshcd_vops_hibern8_notify(hba, UIC_CMD_DME_HIBER_EXIT,
-								POST_CHANGE);
 		hba->ufs_stats.last_hibern8_exit_tstamp = local_clock();
 		hba->ufs_stats.hibern8_exit_cnt++;
 	}
 
+	ufshcd_vops_hibern8_notify(hba, UIC_CMD_DME_HIBER_EXIT, POST_CHANGE, ret);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(ufshcd_uic_hibern8_exit);
diff --git a/drivers/ufs/host/cdns-pltfrm.c b/drivers/ufs/host/cdns-pltfrm.c
index e793e3538c48..5822f23acd93 100644
--- a/drivers/ufs/host/cdns-pltfrm.c
+++ b/drivers/ufs/host/cdns-pltfrm.c
@@ -164,11 +164,11 @@ static int cdns_ufs_hce_enable_notify(struct ufs_hba *hba,
  * @status: notify stage (pre, post change)
  */
 static void cdns_ufs_hibern8_notify(struct ufs_hba *hba, enum uic_cmd_dme cmd,
-				    enum ufs_notify_change_status status)
+				    enum ufs_notify_change_status status, int cmd_ret)
 {
 	if (status == PRE_CHANGE && cmd == UIC_CMD_DME_HIBER_ENTER)
 		cdns_ufs_get_l4_attr(hba);
-	if (status == POST_CHANGE && cmd == UIC_CMD_DME_HIBER_EXIT)
+	if (status == POST_CHANGE && cmd == UIC_CMD_DME_HIBER_EXIT && !cmd_ret)
 		cdns_ufs_set_l4_attr(hba);
 }
 
diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index 76fee3a79c77..83f19a3411c5 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -1699,14 +1699,16 @@ static int exynos_ufs_pwr_change_notify(struct ufs_hba *hba,
 
 static void exynos_ufs_hibern8_notify(struct ufs_hba *hba,
 				     enum uic_cmd_dme cmd,
-				     enum ufs_notify_change_status notify)
+				     enum ufs_notify_change_status notify,
+				     int cmd_ret)
 {
 	switch ((u8)notify) {
 	case PRE_CHANGE:
 		exynos_ufs_pre_hibern8(hba, cmd);
 		break;
 	case POST_CHANGE:
-		exynos_ufs_post_hibern8(hba, cmd);
+		if (!cmd_ret)
+			exynos_ufs_post_hibern8(hba, cmd);
 		break;
 	}
 }
diff --git a/drivers/ufs/host/ufs-sprd.c b/drivers/ufs/host/ufs-sprd.c
index 65bd8fb96b99..70423a766b32 100644
--- a/drivers/ufs/host/ufs-sprd.c
+++ b/drivers/ufs/host/ufs-sprd.c
@@ -352,7 +352,8 @@ static int sprd_ufs_n6_hce_enable_notify(struct ufs_hba *hba,
 
 static void sprd_ufs_n6_h8_notify(struct ufs_hba *hba,
 				  enum uic_cmd_dme cmd,
-				  enum ufs_notify_change_status status)
+				  enum ufs_notify_change_status status,
+				  int cmd_ret)
 {
 	struct ufs_sprd_priv *priv = ufs_sprd_get_priv_data(hba);
 
@@ -372,7 +373,7 @@ static void sprd_ufs_n6_h8_notify(struct ufs_hba *hba,
 		}
 	}
 
-	if (status == POST_CHANGE) {
+	if (status == POST_CHANGE && !cmd_ret) {
 		if (cmd == UIC_CMD_DME_HIBER_EXIT)
 			ufs_sprd_ctrl_uic_compl(hba, true);
 
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 8563b6648976..c1cb30d8aa4a 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -355,7 +355,8 @@ struct ufs_hba_variant_ops {
 				  bool is_scsi_cmd);
 	void	(*setup_task_mgmt)(struct ufs_hba *, int, u8);
 	void    (*hibern8_notify)(struct ufs_hba *, enum uic_cmd_dme,
-					enum ufs_notify_change_status);
+					enum ufs_notify_change_status,
+					int cmd_ret);
 	int	(*apply_dev_quirks)(struct ufs_hba *hba);
 	void	(*fixup_dev_quirks)(struct ufs_hba *hba);
 	int     (*suspend)(struct ufs_hba *, enum ufs_pm_op,
-- 
2.25.1

