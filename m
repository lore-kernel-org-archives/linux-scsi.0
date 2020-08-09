Return-Path: <SRS0=1wnw=BT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18088C433DF
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Aug 2020 12:21:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDF30206A2
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Aug 2020 12:21:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbgHIMQi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 9 Aug 2020 08:16:38 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:19764 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgHIMQU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Aug 2020 08:16:20 -0400
IronPort-SDR: 92jKMmQlN7NLWOviB47xxBHdJPo1Qfzrcjb9k76EApeNJxsJbjh671BckgoRNKwMFNf0jxFmUx
 R7/Hh6CYBVwzvir+aA9p7IwfZbZXKdmb+W4foMK3OX0wMAuvVE5eBn+1ZtDAwKSW3S2qh2v5MN
 IRlmlxi+0OYJWfLUzFZK3DMfPMOxaUNHxZaD2IOzmiuA0Xq4FRz/ujBBH87AqE/S6lBlceYmsx
 qFlmHazaJTguduaTe7EyK2ACWY5ZqGY9LYakmeonmCR46Onmk0g95McIPJWYK7bCAncg+DlVFz
 NRs=
X-IronPort-AV: E=Sophos;i="5.75,453,1589266800"; 
   d="scan'208";a="47246499"
Received: from unknown (HELO ironmsg04-sd.qualcomm.com) ([10.53.140.144])
  by labrats.qualcomm.com with ESMTP; 09 Aug 2020 05:16:06 -0700
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg04-sd.qualcomm.com with ESMTP; 09 Aug 2020 05:16:04 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id C864B2156E; Sun,  9 Aug 2020 05:16:04 -0700 (PDT)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com, cang@codeaurora.org
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-arm-msm@vger.kernel.org (open list:ARM/QUALCOMM SUPPORT),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 3/9] scsi: ufs-qcom: Remove testbus dump in ufs_qcom_dump_dbg_regs
Date:   Sun,  9 Aug 2020 05:15:49 -0700
Message-Id: <1596975355-39813-4-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1596975355-39813-1-git-send-email-cang@codeaurora.org>
References: <1596975355-39813-1-git-send-email-cang@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Dumping testbus registers is heavy enough to cause stability issues
sometime, just remove them as of now.

Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Hongwu Su <hongwus@codeaurora.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 823eccf..6b75338 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -1630,44 +1630,12 @@ int ufs_qcom_testbus_config(struct ufs_qcom_host *host)
 	return 0;
 }
 
-static void ufs_qcom_testbus_read(struct ufs_hba *hba)
-{
-	ufshcd_dump_regs(hba, UFS_TEST_BUS, 4, "UFS_TEST_BUS ");
-}
-
-static void ufs_qcom_print_unipro_testbus(struct ufs_hba *hba)
-{
-	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
-	u32 *testbus = NULL;
-	int i, nminor = 256, testbus_len = nminor * sizeof(u32);
-
-	testbus = kmalloc(testbus_len, GFP_KERNEL);
-	if (!testbus)
-		return;
-
-	host->testbus.select_major = TSTBUS_UNIPRO;
-	for (i = 0; i < nminor; i++) {
-		host->testbus.select_minor = i;
-		ufs_qcom_testbus_config(host);
-		testbus[i] = ufshcd_readl(hba, UFS_TEST_BUS);
-	}
-	print_hex_dump(KERN_ERR, "UNIPRO_TEST_BUS ", DUMP_PREFIX_OFFSET,
-			16, 4, testbus, testbus_len, false);
-	kfree(testbus);
-}
-
 static void ufs_qcom_dump_dbg_regs(struct ufs_hba *hba)
 {
 	ufshcd_dump_regs(hba, REG_UFS_SYS1CLK_1US, 16 * 4,
 			 "HCI Vendor Specific Registers ");
 
-	/* sleep a bit intermittently as we are dumping too much data */
 	ufs_qcom_print_hw_debug_reg_all(hba, NULL, ufs_qcom_dump_regs_wrapper);
-	udelay(1000);
-	ufs_qcom_testbus_read(hba);
-	udelay(1000);
-	ufs_qcom_print_unipro_testbus(hba);
-	udelay(1000);
 }
 
 /**
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

