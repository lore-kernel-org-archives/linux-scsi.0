From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 52/83] scsi: ufs: Fix system suspend status
Date: Tue, 12 Feb 2019 21:36:30 -0500
Message-ID: <20190213023701.20286-52-sashal@kernel.org>
References: <20190213023701.20286-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190213023701.20286-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Stanley Chu <stanley.chu@mediatek.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Stanley Chu <stanley.chu@mediatek.com>

[ Upstream commit ce9e7bce43526626f7cffe2e657953997870197e ]

hba->is_sys_suspended is set after successful system suspend but
not clear after successful system resume.

According to current behavior, hba->is_sys_suspended will not be set if
host is runtime-suspended but not system-suspended. Thus we shall aligh the
same policy: clear this flag even if host remains runtime-suspended after
ufshcd_system_resume is successfully returned.

Simply fix this flag to correct host status logs.

Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 12ddb5928a73..6e80dfe4fa97 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7768,6 +7768,8 @@ int ufshcd_system_resume(struct ufs_hba *hba)
 	trace_ufshcd_system_resume(dev_name(hba->dev), ret,
 		ktime_to_us(ktime_sub(ktime_get(), start)),
 		hba->curr_dev_pwr_mode, hba->uic_link_state);
+	if (!ret)
+		hba->is_sys_suspended = false;
 	return ret;
 }
 EXPORT_SYMBOL(ufshcd_system_resume);
-- 
2.19.1
