Return-Path: <SRS0=dT41=YQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6D96CA9EB7
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 01:41:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F20821848
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 01:41:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733296AbfJWBlK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Oct 2019 21:41:10 -0400
Received: from alexa-out-sd-02.qualcomm.com ([199.106.114.39]:17757 "EHLO
        alexa-out-sd-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731487AbfJWBlK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 22 Oct 2019 21:41:10 -0400
Received: from unknown (HELO ironmsg01-sd.qualcomm.com) ([10.53.140.141])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 22 Oct 2019 18:41:09 -0700
IronPort-SDR: wlwIfXHPAacdGDOF3hGpHijcqij454cX71iUv6Tkf1Z5hn1MlQWhoqNTy9uxAYUxM2iBpSC/uZ
 idrXQby/OtFb+ESfWYS3EuC0qipBPLxeeYxGRUtCII0Q7q38Oxpn+kEONtv/aigwpVJxCEwJxt
 wCqpO4YtubTqcdJds9vruD5v9JnAy8gImErn/YFeHt2yGinOGpNr9/J/gNfyKJVg4cs4TsS1hB
 C1unBIVwZvJul5Qo24oeI4F3402sdzQxocG/5glxN1KlFCN2821+IVgWx0YCcZiFEg7PGLI/Hq
 OzgmNCv5YdcAled+VhMCzp8w
Received: from asutoshd-linux1.qualcomm.com ([10.46.160.39])
  by ironmsg01-sd.qualcomm.com with ESMTP; 22 Oct 2019 18:41:08 -0700
Received: by asutoshd-linux1.qualcomm.com (Postfix, from userid 92687)
        id 9FE2721328; Tue, 22 Oct 2019 18:41:08 -0700 (PDT)
From:   Asutosh Das <asutoshd@codeaurora.org>
To:     cang@codeaurora.org, vivek.gautam@codeaurora.org,
        rnayak@codeaurora.org, vinholikatti@gmail.com,
        jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com,
        Asutosh Das <asutoshd@codeaurora.org>,
        Andy Gross <agross@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-arm-msm@vger.kernel.org (open list:ARM/QUALCOMM SUPPORT),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1 2/2] scsi: ufs-qcom: enter and exit hibern8 during clock scaling
Date:   Tue, 22 Oct 2019 18:40:44 -0700
Message-Id: <1571794847-17529-2-git-send-email-asutoshd@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1571794847-17529-1-git-send-email-asutoshd@codeaurora.org>
References: <1571794847-17529-1-git-send-email-asutoshd@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Qualcomm controller needs to be in hibern8 before scaling clocks.
This change puts the controller in hibern8 state before scaling
and brings it out after scaling of clocks.

Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
---
 drivers/scsi/ufs/ufs-qcom.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index a5b7148..d117088 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -1305,6 +1305,9 @@ static int ufs_qcom_clk_scale_notify(struct ufs_hba *hba,
 	int err = 0;
 
 	if (status == PRE_CHANGE) {
+		err = ufshcd_uic_hibern8_enter(hba);
+		if (err)
+			return err;
 		if (scale_up)
 			err = ufs_qcom_clk_scale_up_pre_change(hba);
 		else
@@ -1324,6 +1327,7 @@ static int ufs_qcom_clk_scale_notify(struct ufs_hba *hba,
 				    dev_req_params->hs_rate,
 				    false);
 		ufs_qcom_update_bus_bw_vote(host);
+		ufshcd_uic_hibern8_exit(hba);
 	}
 
 out:
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

