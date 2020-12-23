Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8851C43381
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Dec 2020 02:16:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82C9F2312E
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Dec 2020 02:16:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbgLWCQt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Dec 2020 21:16:49 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:43433 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726734AbgLWCQs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Dec 2020 21:16:48 -0500
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20201223021605epoutp03152c5a89e28b30d2643fa5cb23c29972~TNtGIgOj-0236402364epoutp03J
        for <linux-scsi@vger.kernel.org>; Wed, 23 Dec 2020 02:16:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20201223021605epoutp03152c5a89e28b30d2643fa5cb23c29972~TNtGIgOj-0236402364epoutp03J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608689765;
        bh=D/uvCRGnNJdq79Xp4FdfH6T9EVfI76KEykrDHLjFiXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=Fsx44hJAR2aVy8ViXcO9ewjWriSpU75cVAeGSzP4wB72iNg+MJRuI59x2GsoQ/+RY
         ORnywWRCSFzD+VeYjIeDBHnF+1j8uX7sWQiO3/QrfCVlaSZrLBIKtZ/05tKBr6Abu0
         15GP4gLufqT2GVC1dcMPHMVsA5wR5wasOZN68lXM=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20201223021604epcas2p41e758b56f4d7bdd1fbf9af3d913a81cb~TNtE9mZQg1663116631epcas2p4d;
        Wed, 23 Dec 2020 02:16:04 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.182]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4D0xdZ38R0zMqYl3; Wed, 23 Dec
        2020 02:16:02 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        49.35.56312.268A2EF5; Wed, 23 Dec 2020 11:16:02 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20201223021601epcas2p1311bd2ee57014e3b536de5a5ca286f85~TNtCsBHlw2896728967epcas2p1J;
        Wed, 23 Dec 2020 02:16:01 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201223021601epsmtrp22823f0cdfaec2efe95334133ea95ad9b~TNtCrLk_j0278402784epsmtrp2O;
        Wed, 23 Dec 2020 02:16:01 +0000 (GMT)
X-AuditID: b6c32a46-1efff7000000dbf8-75-5fe2a86261ea
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        47.56.13470.168A2EF5; Wed, 23 Dec 2020 11:16:01 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20201223021601epsmtip14e529502be8126a69f4e7704c240c2bd~TNtCee9Je1422114221epsmtip1p;
        Wed, 23 Dec 2020 02:16:01 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v4 1/2] ufs: add a vops to configure block parameter
Date:   Wed, 23 Dec 2020 11:05:07 +0900
Message-Id: <d937b2a64d597ce969ad3e36419f9814e5e202ae.1608689016.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1608689016.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1608689016.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPJsWRmVeSWpSXmKPExsWy7bCmqW7SikfxBjf/c1g8mLeNzWJv2wl2
        i5c/r7JZHHzYyWLxdekzVotpH34yW3xav4zV4tff9ewWqxc/YLFYdGMbk8XNLUdZLLqv72Cz
        WH78H5NF190bjBZL/71lceD3uHzF2+NyXy+Tx4RFBxg9vq/vYPP4+PQWi0ffllWMHp83yXm0
        H+hmCuCIyrHJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvM
        ATpeSaEsMacUKBSQWFyspG9nU5RfWpKqkJFfXGKrlFqQklNgaFigV5yYW1yal66XnJ9rZWhg
        YGQKVJmQk/Hs6UzGgq/cFU9WTGZuYPzA2cXIySEhYCLR+34/SxcjF4eQwA5GiYW/rzBBOJ8Y
        JZbtvcUI4XxjlGg+upoJpmX9nolsILaQwF5GiavPaiGKfjBKLD/2kxEkwSagKfH05lSwUSIC
        Z5gkrrWeZQVJMAuoS+yacAJskrCAi8SPCxvAJrEIqEpsu/eNBcTmFYiWmN12kBlim5zEzXOd
        YDangKXErsXNTKhsLqCauRwSr2+fgjrPRWJG714oW1ji1fEt7BC2lMTnd3vZIOx6iX1TG1gh
        mnsYJZ7u+8cIkTCWmPWsHcjmALpUU2L9Ln0QU0JAWeLILRaI+/kkOg7/ZYcI80p0tAlBNCpL
        /Jo0GWqIpMTMm3egSjwkJi1Lh4QPyKJV61kmMMrPQpi/gJFxFaNYakFxbnpqsVGBEXLsbWIE
        p1Qttx2MU95+0DvEyMTBeIhRgoNZSYTXTOp+vBBvSmJlVWpRfnxRaU5q8SFGU2A4TmSWEk3O
        Byb1vJJ4Q1MjMzMDS1MLUzMjCyVx3mKDB/FCAumJJanZqakFqUUwfUwcnFINTJpfjPhnGr4x
        fXv37Iq+hRucDZ3uJokuu3cpbNm3soDM/qu6D6arn+PYt8HVQ+jewbM83KkTWZjcmIv+nbz3
        LZN7R6Ze1KGTrS+MGvOr0/hPL9q82KLife+TP/d1FvfUXnd3sAzYdHlG1qmb5tNm7Y6a94rV
        x/qHXXiWQp7WppNGjel/42ITpEKNvR7z6f03+cMorjBrbfc2Jd/A5bZPC3ddur6yftlhk9tl
        hi7zmwqU5i05LBRw/1P6fGvL3/baUXbPD/m+rWsSCGO62t/0zcK7fIbs8TPTnk90eL90+p7Z
        UnlHWFweynD4Fpns39cmNbNw5abVum3V2xf/kC18bBjaypuveKWwYt30b09kI5RYijMSDbWY
        i4oTAaleqaAyBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsWy7bCSnG7iikfxBssealg8mLeNzWJv2wl2
        i5c/r7JZHHzYyWLxdekzVotpH34yW3xav4zV4tff9ewWqxc/YLFYdGMbk8XNLUdZLLqv72Cz
        WH78H5NF190bjBZL/71lceD3uHzF2+NyXy+Tx4RFBxg9vq/vYPP4+PQWi0ffllWMHp83yXm0
        H+hmCuCI4rJJSc3JLEst0rdL4Mp49nQmY8FX7oonKyYzNzB+4Oxi5OSQEDCRWL9nIlsXIxeH
        kMBuRonbP74yQSQkJU7sfM4IYQtL3G85wgpR9I1R4uueTjaQBJuApsTTm1OZQBIiAveYJC5N
        mMsMkmAWUJfYNeEE2CRhAReJHxc2gDWwCKhKbLv3jQXE5hWIlpjddpAZYoOcxM1znWA2p4Cl
        xK7FzUC9HEDbLCQef2DFITyBUWABI8MqRsnUguLc9NxiwwLDvNRyveLE3OLSvHS95PzcTYzg
        iNDS3MG4fdUHvUOMTByMhxglOJiVRHjNpO7HC/GmJFZWpRblxxeV5qQWH2KU5mBREue90HUy
        XkggPbEkNTs1tSC1CCbLxMEp1cBknWV8ZsHN3k+bzeUzj1oFvD/z44KG0BKZsOggzVMcAut3
        Jm6V0DqTrHWe52LEL7Xq8IjpCwQ2bJm5OZOj5eQ3Vg51Vv+juyfO+sy/ePJv5pOXLAv69hTx
        laZyHD4UMWnFdCsnwxOZ+3rNy1cZHQ3j+cH/4b6ynEWOsvLG5Tcfz7j8zKPg4xI9m5nu+9ic
        ns0o3ht4d7PA/OoQd7afO/5NrpexbkqX/vyzqd7d+1jJhni7C/4WVhFRz3lFWg893z1xgWCv
        bdmpoIRNX7wuLTzSyqbT26mSNVn9qiCXxf1H9l+O/Tkrax6au+jxwfA9dlyqdjLib5adSMpy
        PrO+LXIyI0vKw6sun64Y7I2fdXSdEktxRqKhFnNRcSIATcjifPcCAAA=
X-CMS-MailID: 20201223021601epcas2p1311bd2ee57014e3b536de5a5ca286f85
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201223021601epcas2p1311bd2ee57014e3b536de5a5ca286f85
References: <cover.1608689016.git.kwmad.kim@samsung.com>
        <CGME20201223021601epcas2p1311bd2ee57014e3b536de5a5ca286f85@epcas2p1.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There could be some cases to set block parameters
per host, because of its own dma structure or whatever.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 2 ++
 drivers/scsi/ufs/ufshcd.h | 8 ++++++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 92d433d..5f89b0e 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4758,6 +4758,8 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
 
 	ufshcd_crypto_setup_rq_keyslot_manager(hba, q);
 
+	ufshcd_vops_slave_configure(hba, sdev);
+
 	return 0;
 }
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 61344c4..4bf4fed 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -329,6 +329,7 @@ struct ufs_hba_variant_ops {
 					void *data);
 	int	(*program_key)(struct ufs_hba *hba,
 			       const union ufs_crypto_cfg_entry *cfg, int slot);
+	void	(*slave_configure)(struct scsi_device *sdev);
 };
 
 /* clock gating state  */
@@ -1228,6 +1229,13 @@ static inline void ufshcd_vops_config_scaling_param(struct ufs_hba *hba,
 		hba->vops->config_scaling_param(hba, profile, data);
 }
 
+static inline void ufshcd_vops_slave_configure(struct ufs_hba *hba,
+						    struct scsi_device *sdev)
+{
+	if (hba->vops && hba->vops->slave_configure)
+		hba->vops->slave_configure(sdev);
+}
+
 extern struct ufs_pm_lvl_states ufs_pm_lvl_states[];
 
 /*
-- 
2.7.4

