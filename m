From: Tim Gardner <tim.gardner@canonical.com>
Subject: [PATCH linux/linux-next] aic94xx: asd_read_flash: Fix uninitialized variable warning
Date: Wed, 20 Feb 2013 12:49:33 -0700
Message-ID: <1361389773-49944-1-git-send-email-tim.gardner@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

drivers/scsi/aic94xx/aic94xx_sds.c: In function 'asd_read_flash':
drivers/scsi/aic94xx/aic94xx_sds.c:597:21: warning: 'offs' may be used uninitialized in this function [-Wmaybe-uninitialized]
drivers/scsi/aic94xx/aic94xx_sds.c:985:6: note: 'offs' was declared here

If asd_find_flash_de() fails, then 'offs' could be used without having been initialized.
Set 'offs' to zero which seems like the most reasonable value.

Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/scsi/aic94xx/aic94xx_sds.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/aic94xx/aic94xx_sds.c b/drivers/scsi/aic94xx/aic94xx_sds.c
index edb43fd..d11b4d7 100644
--- a/drivers/scsi/aic94xx/aic94xx_sds.c
+++ b/drivers/scsi/aic94xx/aic94xx_sds.c
@@ -1003,6 +1003,7 @@ static int asd_process_ctrl_a_user(struct asd_ha_struct *asd_ha,
 		}
 
 		size = sizeof(struct asd_ctrla_phy_settings);
+		offs = 0;
 		ps = &dflt_ps;
 	}
 
-- 
1.7.9.5
