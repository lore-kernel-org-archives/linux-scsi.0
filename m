From: Danny Kukawka <danny.kukawka@bisect.de>
Subject: [PATCH 09/16] [RFC] aic94xx: fix for -Wuninitialized
Date: Mon, 30 Jan 2012 23:00:13 +0100
Message-ID: <1327960820-11867-10-git-send-email-danny.kukawka@bisect.de>
References: <1327960820-11867-1-git-send-email-danny.kukawka@bisect.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1327960820-11867-1-git-send-email-danny.kukawka@bisect.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Jiri Kosina <trivial@kernel.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Fix for a -Wuninitialized warning. Not complete sure if this is the
correct fix since setting offs=0 is may not correct, but in case
asd_find_flash_de() fails in asd_process_ctrl_a_user() offs never
get set, but will be used later uninitialized in asd_read_flash_seg().

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/scsi/aic94xx/aic94xx_sds.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_sds.c b/drivers/scsi/aic94xx/aic94xx_sds.c
index edb43fd..6f6a5b8 100644
--- a/drivers/scsi/aic94xx/aic94xx_sds.c
+++ b/drivers/scsi/aic94xx/aic94xx_sds.c
@@ -982,7 +982,7 @@ static int asd_process_ctrl_a_user(struct asd_ha_struct *asd_ha,
 				   struct asd_flash_dir *flash_dir)
 {
 	int err, i;
-	u32 offs, size;
+	u32 offs = 0, size;
 	struct asd_ll_el *el;
 	struct asd_ctrla_phy_settings *ps;
 	struct asd_ctrla_phy_settings dflt_ps;
-- 
1.7.7.3
