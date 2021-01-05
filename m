Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E3DEC433DB
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 03:17:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DAA022573
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 03:17:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbhAEDQ5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jan 2021 22:16:57 -0500
Received: from labrats.qualcomm.com ([199.106.110.90]:18288 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726599AbhAEDQ4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2021 22:16:56 -0500
IronPort-SDR: OIlKBqy6uOQzBVb7beUdQkZDCrQ5X0IAuMsgC3A/lyvmwGcR5YIGFwePHoZHl2pRRuN5vF0iUy
 dVcih8yQThB87aO/UVFpWYScuHKD+bu1rtt77Fi2bF/EYQnj5zIMizt1lLMmTSCvtR6l3XO9l4
 1mk/ZhHLv4yPIqX7ZdlJRYIaouYsLjGZfe8C9oSYHcnEtOf4LDVVIIz3Lq+rhrL3eq6citj2JW
 +cRRtVVde2BfH7IHtoMpc1P64qBPr7ibnGAmwSfYsZEX1TQAZpZOX//6nv3MJgPu00TTT/wRJd
 7zc=
X-IronPort-AV: E=Sophos;i="5.78,475,1599548400"; 
   d="scan'208";a="29488172"
Received: from unknown (HELO ironmsg05-sd.qualcomm.com) ([10.53.140.145])
  by labrats.qualcomm.com with ESMTP; 04 Jan 2021 19:16:06 -0800
X-QCInternal: smtphost
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg05-sd.qualcomm.com with ESMTP; 04 Jan 2021 19:16:05 -0800
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 3B50C2184B; Mon,  4 Jan 2021 19:16:05 -0800 (PST)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com, cang@codeaurora.org
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Satya Tangirala <satyat@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/2] scsi: ufs: Introduce a vops to get info of command completion
Date:   Mon,  4 Jan 2021 19:15:50 -0800
Message-Id: <1609816552-16442-2-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1609816552-16442-1-git-send-email-cang@codeaurora.org>
References: <1609816552-16442-1-git-send-email-cang@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Similar with the vops setup_xfer_req in ufshcd_send_command(), this change
adds the vops compl_xfer_req in __ufshcd_transfer_req_compl() such that
vendor drivers can make use of the two hooks to do variant stuffs.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
Signed-off-by: Can Guo <cang@codeaurora.org>

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e221add..7ca7564 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5016,6 +5016,7 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 		lrbp->in_use = false;
 		lrbp->compl_time_stamp = ktime_get();
 		cmd = lrbp->cmd;
+		ufshcd_vops_compl_xfer_req(hba, index, (cmd) ? true : false);
 		if (cmd) {
 			ufshcd_add_command_trace(hba, index, "complete");
 			result = ufshcd_transfer_rsp_status(hba, lrbp);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 9bb5f0e..e3fb62f 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -310,7 +310,7 @@ struct ufs_pwr_mode_info {
  *			is carried out to allow vendor spesific capabilities
  *			to be set.
  * @setup_xfer_req: called before any transfer request is issued
- *                  to set some things
+ * @compl_xfer_req: called when any transfer request is completed
  * @setup_task_mgmt: called before any task management request is issued
  *                  to set some things
  * @hibern8_notify: called around hibern8 enter/exit
@@ -341,6 +341,7 @@ struct ufs_hba_variant_ops {
 					struct ufs_pa_layer_attr *,
 					struct ufs_pa_layer_attr *);
 	void	(*setup_xfer_req)(struct ufs_hba *, int, bool);
+	void	(*compl_xfer_req)(struct ufs_hba *hba, int tag, bool is_scsi);
 	void	(*setup_task_mgmt)(struct ufs_hba *, int, u8);
 	void    (*hibern8_notify)(struct ufs_hba *, enum uic_cmd_dme,
 					enum ufs_notify_change_status);
@@ -1166,6 +1167,13 @@ static inline void ufshcd_vops_setup_xfer_req(struct ufs_hba *hba, int tag,
 		return hba->vops->setup_xfer_req(hba, tag, is_scsi_cmd);
 }
 
+static inline void ufshcd_vops_compl_xfer_req(struct ufs_hba *hba,
+					      int tag, bool is_scsi)
+{
+	if (hba->vops && hba->vops->compl_xfer_req)
+		hba->vops->compl_xfer_req(hba, tag, is_scsi);
+}
+
 static inline void ufshcd_vops_setup_task_mgmt(struct ufs_hba *hba,
 					int tag, u8 tm_function)
 {
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

