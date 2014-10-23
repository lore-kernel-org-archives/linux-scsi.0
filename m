From: Dolev Raviv <draviv@codeaurora.org>
Subject: [PATCH 6/6] scsi: ufs: fix static checker warning in ufshcd_parse_clock_info
Date: Thu, 23 Oct 2014 13:25:17 +0300
Message-ID: <1414059917-13831-7-git-send-email-draviv@codeaurora.org>
References: <1414059917-13831-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1414059917-13831-1-git-send-email-draviv@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Dolev Raviv <draviv@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

This patch fixes newly introduced static checker warning in
ufshcd_parse_clock_info, introduced by UFS power management series.

Warning:
drivers/scsi/ufs/ufshcd-pltfrm.c:138 ufshcd_parse_clock_info()
warn: passing devm_ allocated variable to kfree. 'clkfreq'

To fix it we remove the kfree(clkfreq) statement.
In addition we removed the redundant goto label.

Signed-off-by: Dolev Raviv <draviv@codeaurora.org>

diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 2cdec78..1c3467b 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -102,7 +102,6 @@ static int ufshcd_parse_clock_info(struct ufs_hba *hba)
 	clkfreq = devm_kzalloc(dev, sz * sizeof(*clkfreq),
 			GFP_KERNEL);
 	if (!clkfreq) {
-		dev_err(dev, "%s: no memory\n", "freq-table-hz");
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -112,19 +111,19 @@ static int ufshcd_parse_clock_info(struct ufs_hba *hba)
 	if (ret && (ret != -EINVAL)) {
 		dev_err(dev, "%s: error reading array %d\n",
 				"freq-table-hz", ret);
-		goto free_clkfreq;
+		return ret;
 	}
 
 	for (i = 0; i < sz; i += 2) {
 		ret = of_property_read_string_index(np,
 				"clock-names", i/2, (const char **)&name);
 		if (ret)
-			goto free_clkfreq;
+			goto out;
 
 		clki = devm_kzalloc(dev, sizeof(*clki), GFP_KERNEL);
 		if (!clki) {
 			ret = -ENOMEM;
-			goto free_clkfreq;
+			goto out;
 		}
 
 		clki->min_freq = clkfreq[i];
@@ -134,8 +133,6 @@ static int ufshcd_parse_clock_info(struct ufs_hba *hba)
 				clki->min_freq, clki->max_freq, clki->name);
 		list_add_tail(&clki->list, &hba->clk_list_head);
 	}
-free_clkfreq:
-	kfree(clkfreq);
 out:
 	return ret;
 }
-- 
1.8.5.2
-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project
