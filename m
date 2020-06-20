Return-Path: <SRS0=CpYn=AB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E0F9C433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Jun 2020 07:00:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32EBF2245A
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Jun 2020 07:00:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="bgaWL5Id"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbgFTHA4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Jun 2020 03:00:56 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:34457 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725826AbgFTHAw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Jun 2020 03:00:52 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200620070048epoutp039bab22b0c48f2c78c0aa1fba5fb83e95~aLmlMLaz50663806638epoutp03B
        for <linux-scsi@vger.kernel.org>; Sat, 20 Jun 2020 07:00:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200620070048epoutp039bab22b0c48f2c78c0aa1fba5fb83e95~aLmlMLaz50663806638epoutp03B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592636448;
        bh=2DYmyi4wpc3ZfQNsKIRHCfQGxwde0GPxyUQjGgNq6oY=;
        h=From:To:Cc:Subject:Date:References:From;
        b=bgaWL5IdmuKG/oMYOcg0UZQI8Qkpv73gcGuVCxtjBwkh52A1aRGxqWTYPqaDuEgrW
         ysUqqePNvsoDjfl7sFRUkI93fRJpJeSSsTTxVORqpyUtKNUKxq0YjlQ0KbbvyohCTQ
         PyyLB5JUhJViXVH4iLMSE8h/RPl3Ijtsj0Nz8T7k=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20200620070047epcas2p451d9183fec44b0e34a893c8c367752bb~aLmkmmyOT1970419704epcas2p4t;
        Sat, 20 Jun 2020 07:00:47 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.184]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 49pmlx3l5XzMqYkX; Sat, 20 Jun
        2020 07:00:45 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        41.AE.19322.D14BDEE5; Sat, 20 Jun 2020 16:00:45 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20200620070044epcas2p269e3c266c86c65dd0e894d8188036a30~aLmiJ7fkR2388523885epcas2p20;
        Sat, 20 Jun 2020 07:00:44 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200620070044epsmtrp1027a9cf28b6361a7695b035fdcfedf1b~aLmiGhVAa1811618116epsmtrp1A;
        Sat, 20 Jun 2020 07:00:44 +0000 (GMT)
X-AuditID: b6c32a45-7adff70000004b7a-6b-5eedb41d73b2
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        C9.61.08382.C14BDEE5; Sat, 20 Jun 2020 16:00:44 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200620070044epsmtip2d484533084a520a3dbd00514d3f9242c~aLmh3x4t53122731227epsmtip2x;
        Sat, 20 Jun 2020 07:00:44 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [RFC PATCH v1 1/2] ufs: introduce callbacks to get command
 information
Date:   Sat, 20 Jun 2020 15:53:11 +0900
Message-Id: <1592635992-35619-1-git-send-email-kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLKsWRmVeSWpSXmKPExsWy7bCmua7slrdxBt9OSVo8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWiy6sY3J4uaWoywW3dd3sFksP/6PyYHL4/IVb4/Lfb1M
        HhMWHWD0+L6+g83j49NbLB59W1YxenzeJOfRfqCbKYAjKscmIzUxJbVIITUvOT8lMy/dVsk7
        ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB+hGJYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+
        cYmtUmpBSk6BoWGBXnFibnFpXrpecn6ulaGBgZEpUGVCTsaqB+EFewQr5j1bxNrAuIuvi5GT
        Q0LAROL5sV/sXYxcHEICOxgl/m3ZxwThfGKU+LVjCyuE841R4vuubjaYll2TzjFDJPYySszZ
        vQaq/wejxJkvD5lBqtgENCWe3pwKNktE4AZQVfNhVpAEs4C6xK4JJ5hAbGGBQIltl48B2Rwc
        LAKqEs07REDCvAKuEvc+NTFCbJOTuHmuE2ybhMAtdoltrS3sEAkXid61+1ghbGGJV8e3QMWl
        JF72t0HZ9RL7pjawQjT3MEo83fcPaqqxxKxn7Ywgi5mBLl2/Sx/ElBBQljhyiwXiTD6JjsN/
        2SHCvBIdbUIQjcoSvyZNhhoiKTHz5h2oTR4Sez80gMWFBGIlDm2cwj6BUXYWwvwFjIyrGMVS
        C4pz01OLjQoMkSNpEyM43Wm57mCc/PaD3iFGJg7GQ4wSHMxKIryH37+JE+JNSaysSi3Kjy8q
        zUktPsRoCgyuicxSosn5wISbVxJvaGpkZmZgaWphamZkoSTOm6t4IU5IID2xJDU7NbUgtQim
        j4mDU6qBacr9LyaSDjLC+j/lPnmL6+9yKSu8fna6dG63zGyzBxEvfvsFbI9/s8VD8qbDVJVT
        zOczXytNlm1O0Zl7qmqulMmjJH2+/1ksxrk/Fh9dPVuG1/PAw8pVe3Kq5j3dvnfSs5Tvpw+H
        ujx+yWIY9O8ai/wfn6VX7nu7zw/56812dErSHNaa9pTdc+d+qO1d+1zFg+1gRpuAzjzfSK16
        4XxzrtSdgisc00MubMm6w/VTebtdq5Gcy/q8/Y1uVoWyAUerlV51fdbUPzb7TM73MsmjK+pE
        1S9Ys3+3WzspMGn7/cajkg4L19/5dCpzbcWNJOtrj4Sir/67s9C1UDrLLdqhYPqML4f7/92/
        nNsV+v/KTCWW4oxEQy3mouJEAO5VJTMABAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNLMWRmVeSWpSXmKPExsWy7bCSvK7MlrdxBj/3KVo8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWiy6sY3J4uaWoywW3dd3sFksP/6PyYHL4/IVb4/Lfb1M
        HhMWHWD0+L6+g83j49NbLB59W1YxenzeJOfRfqCbKYAjissmJTUnsyy1SN8ugStj1YPwgj2C
        FfOeLWJtYNzF18XIySEhYCKxa9I55i5GLg4hgd2MEk8XTWKCSEhKnNj5nBHCFpa433KEFaLo
        G6PE56Uf2UESbAKaEk9vTmUCSYgIPGKU+D2zEyzBLKAusWvCCbBJwgL+En++/WfrYuTgYBFQ
        lWjeIQIS5hVwlbj3qQlqgZzEzXOdzBMYeRYwMqxilEwtKM5Nzy02LDDMSy3XK07MLS7NS9dL
        zs/dxAgOPy3NHYzbV33QO8TIxMF4iFGCg1lJhPfw+zdxQrwpiZVVqUX58UWlOanFhxilOViU
        xHlvFC6MExJITyxJzU5NLUgtgskycXBKNTCtfif902nPva2C3ztOSfG+miz2SsyH2S/wpi/7
        onymAmaGXzMu+e6Iy42cHltgxs5tbW2ySPCcm+7UAN3eJ+0HGw/UHnJoOLVh156NB55eMP62
        oDcgaoonS/22P13q5w0+R7j9Sp558sCE1gY2uV9NukzfZxY8sjFOOzJrM+tWpqrS/ft39kxv
        WTStaLvRopfbZKcwyh2ceTX1z8lMVtsEg3eBh1cktkov+er0RuH5v/+lXE3BU7J1PmTsyX5y
        OP/6qzccZYnNzXoc1wI6tptdZDK90XBCaGbKS+7vfw5rBkvt99qUUVBTHvd2wtyX6tVaXtcU
        ZVJ+rE1kOxsaHitw8ZmU7qeegy/3NczsLrirxFKckWioxVxUnAgAY79gA64CAAA=
X-CMS-MailID: 20200620070044epcas2p269e3c266c86c65dd0e894d8188036a30
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200620070044epcas2p269e3c266c86c65dd0e894d8188036a30
References: <CGME20200620070044epcas2p269e3c266c86c65dd0e894d8188036a30@epcas2p2.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Some SoC specific might need command history for
various reasons, such as stacking command contexts
in system memory to check for debugging in the future
or scaling some DVFS knobs to boost IO throughput.

What you would do with the information could be
variant per SoC vendor.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 4 ++++
 drivers/scsi/ufs/ufshcd.h | 8 ++++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 52abe82..0eae3ce 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2545,6 +2545,8 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	/* issue command to the controller */
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	ufshcd_vops_setup_xfer_req(hba, tag, true);
+	if (cmd)
+		ufshcd_vops_cmd_log(hba, cmd, 1);
 	ufshcd_send_command(hba, tag);
 out_unlock:
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
@@ -4890,6 +4892,8 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 			/* Mark completed command as NULL in LRB */
 			lrbp->cmd = NULL;
 			lrbp->compl_time_stamp = ktime_get();
+			ufshcd_vops_cmd_log(hba, cmd, 2);
+
 			/* Do not touch lrbp after scsi done */
 			cmd->scsi_done(cmd);
 			__ufshcd_release(hba);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index c774012..80c4f0d 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -307,6 +307,7 @@ struct ufs_hba_variant_ops {
 	void	(*config_scaling_param)(struct ufs_hba *hba,
 					struct devfreq_dev_profile *profile,
 					void *data);
+	void	(*cmd_log)(struct ufs_hba *hba, struct scsi_cmnd *cmd, int enter);
 };
 
 /* clock gating state  */
@@ -1137,6 +1138,13 @@ static inline void ufshcd_vops_config_scaling_param(struct ufs_hba *hba,
 		hba->vops->config_scaling_param(hba, profile, data);
 }
 
+static inline void ufshcd_vops_cmd_log(struct ufs_hba *hba,
+					 struct scsi_cmnd *cmd, int enter)
+{
+	if (hba->vops && hba->vops->cmd_log)
+		hba->vops->cmd_log(hba, cmd, enter);
+}
+
 extern struct ufs_pm_lvl_states ufs_pm_lvl_states[];
 
 /*
-- 
2.7.4

