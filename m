Return-Path: <SRS0=dT41=YQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AF22C47E49
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 16:49:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1510021925
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 16:49:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbfJWQtO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Oct 2019 12:49:14 -0400
Received: from alexa-out-sd-01.qualcomm.com ([199.106.114.38]:58675 "EHLO
        alexa-out-sd-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726350AbfJWQtO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Oct 2019 12:49:14 -0400
Received: from unknown (HELO ironmsg-SD-alpha.qualcomm.com) ([10.53.140.30])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 23 Oct 2019 09:49:14 -0700
IronPort-SDR: aU3DnqRCFkZmOkajL0Sr2Bg7tG5AnKS/LzDPTpWTkWwJ2XQGTVsRBrWQhWbaQfKUFGgMmHSpjr
 ml9qL1VHdb9Lp7UfOkzBYoNz5XBKw0IcU=
Received: from asutoshd-linux1.qualcomm.com ([10.46.160.39])
  by ironmsg-SD-alpha.qualcomm.com with ESMTP; 23 Oct 2019 09:49:13 -0700
Received: by asutoshd-linux1.qualcomm.com (Postfix, from userid 92687)
        id 50C3A2135A; Wed, 23 Oct 2019 09:49:13 -0700 (PDT)
From:   Asutosh Das <asutoshd@codeaurora.org>
To:     cang@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com,
        jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com,
        Asutosh Das <asutoshd@codeaurora.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 1/2] scsi: ufs: export hibern8 entry and exit
Date:   Wed, 23 Oct 2019 09:49:08 -0700
Message-Id: <1571849351-819-1-git-send-email-asutoshd@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Qualcomm controllers need to be in hibern8 before scaling up
or down the clocks. Hence, export the hibern8 entry and exit
functions.

Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 8 ++++----
 drivers/scsi/ufs/ufshcd.h | 3 ++-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c28c144..57d9315 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -250,8 +250,6 @@ static int ufshcd_probe_hba(struct ufs_hba *hba);
 static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
 				 bool skip_ref_clk);
 static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on);
-static int ufshcd_uic_hibern8_exit(struct ufs_hba *hba);
-static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba);
 static inline void ufshcd_add_delay_before_dme_cmd(struct ufs_hba *hba);
 static int ufshcd_host_reset_and_restore(struct ufs_hba *hba);
 static void ufshcd_resume_clkscaling(struct ufs_hba *hba);
@@ -3904,7 +3902,7 @@ static int __ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
 	return ret;
 }
 
-static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
+int ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
 {
 	int ret = 0, retries;
 
@@ -3916,8 +3914,9 @@ static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
 out:
 	return ret;
 }
+EXPORT_SYMBOL_GPL(ufshcd_uic_hibern8_enter);
 
-static int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
+int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
 {
 	struct uic_command uic_cmd = {0};
 	int ret;
@@ -3943,6 +3942,7 @@ static int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(ufshcd_uic_hibern8_exit);
 
 static void ufshcd_auto_hibern8_enable(struct ufs_hba *hba)
 {
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index e0fe247..1e3daf5 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -1107,5 +1107,6 @@ static inline u8 ufshcd_scsi_to_upiu_lun(unsigned int scsi_lun)
 
 int ufshcd_dump_regs(struct ufs_hba *hba, size_t offset, size_t len,
 		     const char *prefix);
-
+int ufshcd_uic_hibern8_enter(struct ufs_hba *hba);
+int ufshcd_uic_hibern8_exit(struct ufs_hba *hba);
 #endif /* End of Header */
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

